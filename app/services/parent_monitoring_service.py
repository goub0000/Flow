"""
Parent Monitoring Service
Business logic for parent monitoring and student activity tracking
"""
from typing import Optional, List, Dict, Any
from datetime import datetime, timedelta
import logging
from uuid import uuid4

from app.database.config import get_supabase
from app.schemas.parent_monitoring import (
    ParentStudentLinkCreateRequest,
    ParentStudentLinkResponse,
    ParentStudentLinkListResponse,
    LinkPermissionsUpdateRequest,
    StudentActivityResponse,
    StudentActivityListResponse,
    ProgressReportRequest,
    ProgressReportResponse,
    ApplicationProgressSummary,
    CounselingSessionSummary,
    AlertSettingsUpdateRequest,
    AlertSettingsResponse,
    ParentAlertResponse,
    ParentAlertListResponse,
    ParentDashboardStats,
    MultiStudentDashboardResponse,
    LinkStatus
)

logger = logging.getLogger(__name__)


class ParentMonitoringService:
    """Service for parent monitoring features"""

    def __init__(self):
        self.db = get_supabase()

    async def create_parent_link(
        self,
        parent_id: str,
        link_data: ParentStudentLinkCreateRequest
    ) -> ParentStudentLinkResponse:
        """Create a parent-student link (pending approval)"""
        try:
            # Verify student exists
            student = self.db.table('users').select('id, roles').eq('id', link_data.student_id).single().execute()

            if not student.data or 'student' not in student.data.get('roles', []):
                raise Exception("Invalid student ID")

            # Check if link already exists
            existing = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', link_data.student_id).execute()

            if existing.data:
                raise Exception("Link already exists")

            link = {
                "id": str(uuid4()),
                "parent_id": parent_id,
                "student_id": link_data.student_id,
                "relationship": link_data.relationship,
                "status": LinkStatus.PENDING.value,  # Pending student approval
                "can_view_grades": link_data.can_view_grades,
                "can_view_activity": link_data.can_view_activity,
                "can_view_messages": link_data.can_view_messages,
                "can_receive_alerts": link_data.can_receive_alerts,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat(),
            }

            response = self.db.table('parent_student_links').insert(link).execute()

            if not response.data:
                raise Exception("Failed to create link")

            logger.info(f"Parent-student link created: {response.data[0]['id']}")

            # TODO: Send notification to student for approval

            return ParentStudentLinkResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create parent link error: {e}")
            raise Exception(f"Failed to create link: {str(e)}")

    async def approve_parent_link(self, link_id: str, student_id: str) -> ParentStudentLinkResponse:
        """Student approves parent link"""
        try:
            link = self.db.table('parent_student_links').select('*').eq('id', link_id).single().execute()

            if not link.data:
                raise Exception("Link not found")

            if link.data['student_id'] != student_id:
                raise Exception("Not authorized")

            if link.data['status'] != LinkStatus.PENDING.value:
                raise Exception(f"Cannot approve link with status: {link.data['status']}")

            update = {
                "status": LinkStatus.ACTIVE.value,
                "linked_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('parent_student_links').update(update).eq('id', link_id).execute()

            if not response.data:
                raise Exception("Failed to approve link")

            logger.info(f"Parent link approved: {link_id}")

            return ParentStudentLinkResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Approve link error: {e}")
            raise Exception(f"Failed to approve link: {str(e)}")

    async def revoke_parent_link(self, link_id: str, user_id: str) -> Dict[str, Any]:
        """Revoke parent-student link"""
        try:
            link = self.db.table('parent_student_links').select('*').eq('id', link_id).single().execute()

            if not link.data:
                raise Exception("Link not found")

            # Either parent or student can revoke
            if link.data['parent_id'] != user_id and link.data['student_id'] != user_id:
                raise Exception("Not authorized")

            update = {
                "status": LinkStatus.REVOKED.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            self.db.table('parent_student_links').update(update).eq('id', link_id).execute()

            logger.info(f"Parent link revoked: {link_id}")

            return {"success": True}

        except Exception as e:
            logger.error(f"Revoke link error: {e}")
            raise Exception(f"Failed to revoke link: {str(e)}")

    async def list_parent_links(self, user_id: str, user_role: str) -> ParentStudentLinkListResponse:
        """List parent-student links"""
        try:
            if user_role == "parent":
                links_response = self.db.table('parent_student_links').select('*').eq('parent_id', user_id).execute()
            elif user_role == "student":
                links_response = self.db.table('parent_student_links').select('*').eq('student_id', user_id).execute()
            else:
                raise Exception("Invalid role")

            links = [ParentStudentLinkResponse(**link) for link in links_response.data] if links_response.data else []

            return ParentStudentLinkListResponse(
                links=links,
                total=len(links)
            )

        except Exception as e:
            logger.error(f"List links error: {e}")
            raise Exception(f"Failed to list links: {str(e)}")

    async def verify_parent_access(self, parent_id: str, student_id: str) -> ParentStudentLinkResponse:
        """Verify parent has access to student data"""
        try:
            link = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', student_id).eq('status', LinkStatus.ACTIVE.value).single().execute()

            if not link.data:
                raise Exception("No active link found")

            return ParentStudentLinkResponse(**link.data)

        except Exception as e:
            raise Exception(f"Access denied: {str(e)}")

    async def list_student_activities(
        self,
        parent_id: str,
        student_id: str,
        page: int = 1,
        page_size: int = 20,
        activity_type: Optional[str] = None
    ) -> StudentActivityListResponse:
        """List student activities (parent view)"""
        try:
            # Verify parent access
            link = await self.verify_parent_access(parent_id, student_id)

            if not link.can_view_activity:
                raise Exception("Parent does not have permission to view activity")

            query = self.db.table('student_activities').select('*', count='exact').eq('student_id', student_id)

            if activity_type:
                query = query.eq('activity_type', activity_type)

            offset = (page - 1) * page_size
            query = query.order('timestamp', desc=True).range(offset, offset + page_size - 1)

            response = query.execute()

            activities = [StudentActivityResponse(**a) for a in response.data] if response.data else []
            total = response.count or 0

            return StudentActivityListResponse(
                activities=activities,
                total=total,
                page=page,
                page_size=page_size,
                has_more=(offset + page_size) < total
            )

        except Exception as e:
            logger.error(f"List activities error: {e}")
            raise Exception(f"Failed to list activities: {str(e)}")

    async def generate_progress_report(
        self,
        parent_id: str,
        report_request: ProgressReportRequest
    ) -> ProgressReportResponse:
        """Generate comprehensive progress report"""
        try:
            # Verify parent access
            await self.verify_parent_access(parent_id, report_request.student_id)

            student_id = report_request.student_id

            # Get student info
            student = self.db.table('users').select('full_name').eq('id', student_id).single().execute()
            student_name = student.data.get('full_name', 'Student') if student.data else 'Student'

            report = ProgressReportResponse(
                student_id=student_id,
                student_name=student_name,
                report_period_start=report_request.report_period_start,
                report_period_end=report_request.report_period_end,
                generated_at=datetime.utcnow().isoformat()
            )

            # Applications data
            if report_request.include_applications:
                applications = self.db.table('applications').select('*').eq('student_id', student_id).execute()

                if applications.data:
                    report.total_applications = len(applications.data)
                    report.pending_applications = len([a for a in applications.data if a['status'] in ['pending', 'under_review']])
                    report.accepted_applications = len([a for a in applications.data if a['status'] == 'accepted'])

                    # Application summaries
                    for app in applications.data:
                        report.applications.append(ApplicationProgressSummary(
                            application_id=app['id'],
                            institution_name=app.get('institution_name', 'Unknown'),
                            program_name=app.get('program_name', 'Unknown'),
                            status=app['status'],
                            submitted_at=app.get('submitted_at'),
                            last_updated=app['updated_at']
                        ))

            # Counseling data
            if report_request.include_counseling:
                sessions = self.db.table('counseling_sessions').select('*').eq('student_id', student_id).execute()

                if sessions.data:
                    report.total_counseling_sessions = len(sessions.data)
                    completed = [s for s in sessions.data if s['status'] == 'completed']
                    report.completed_sessions = len(completed)

                    ratings = [s['feedback_rating'] for s in completed if s.get('feedback_rating')]
                    report.average_session_rating = sum(ratings) / len(ratings) if ratings else None

                    # Session summaries
                    for session in sessions.data[:10]:  # Last 10 sessions
                        counselor = self.db.table('users').select('full_name').eq('id', session['counselor_id']).single().execute()
                        counselor_name = counselor.data.get('full_name', 'Unknown') if counselor.data else 'Unknown'

                        report.counseling_sessions.append(CounselingSessionSummary(
                            session_id=session['id'],
                            counselor_name=counselor_name,
                            session_type=session['session_type'],
                            status=session['status'],
                            scheduled_start=session['scheduled_start'],
                            feedback_rating=session.get('feedback_rating')
                        ))

            # Achievements data
            if report_request.include_achievements:
                achievements = self.db.table('student_achievements').select('*').eq('student_id', student_id).execute()

                if achievements.data:
                    report.total_achievements = len(achievements.data)

                    # Filter achievements in report period
                    period_start = datetime.fromisoformat(report_request.report_period_start)
                    period_end = datetime.fromisoformat(report_request.report_period_end)

                    for ach in achievements.data:
                        earned_at = datetime.fromisoformat(ach['earned_at'].replace('Z', '+00:00'))
                        if period_start <= earned_at <= period_end:
                            report.achievements_this_period += 1
                            if len(report.recent_achievements) < 5:
                                report.recent_achievements.append({
                                    "id": ach['id'],
                                    "title": ach.get('title', 'Achievement'),
                                    "earned_at": ach['earned_at']
                                })

            # Activity summary
            activities = self.db.table('student_activities').select('*').eq('student_id', student_id).gte(
                'timestamp', report_request.report_period_start
            ).lte('timestamp', report_request.report_period_end).execute()

            if activities.data:
                report.total_activities = len(activities.data)

                # Group by type
                for activity in activities.data:
                    atype = activity.get('activity_type', 'unknown')
                    report.activities_by_type[atype] = report.activities_by_type.get(atype, 0) + 1

            logger.info(f"Progress report generated for student: {student_id}")

            return report

        except Exception as e:
            logger.error(f"Generate report error: {e}")
            raise Exception(f"Failed to generate report: {str(e)}")

    async def get_parent_dashboard(self, parent_id: str) -> MultiStudentDashboardResponse:
        """Get dashboard for parent (all linked students)"""
        try:
            # Get all active links
            links = await self.list_parent_links(parent_id, "parent")
            active_links = [link for link in links.links if link.status == LinkStatus.ACTIVE.value]

            if not active_links:
                return MultiStudentDashboardResponse(
                    parent_id=parent_id,
                    students=[],
                    total_students=0
                )

            students_stats = []

            for link in active_links:
                student_id = link.student_id

                # Get student info
                student = self.db.table('users').select('full_name').eq('id', student_id).single().execute()
                student_name = student.data.get('full_name', 'Student') if student.data else 'Student'

                stats = ParentDashboardStats(
                    student_id=student_id,
                    student_name=student_name,
                    is_active=False,
                    total_applications=0,
                    pending_applications=0,
                    accepted_applications=0,
                    rejected_applications=0,
                    upcoming_sessions=0,
                    completed_sessions_this_month=0,
                    achievements_count=0,
                    achievements_this_month=0,
                    unread_alerts=0,
                    high_severity_alerts=0,
                    total_activities_last_30_days=0
                )

                # Last activity check
                recent_activity = self.db.table('student_activities').select('timestamp').eq(
                    'student_id', student_id
                ).order('timestamp', desc=True).limit(1).execute()

                if recent_activity.data:
                    last_activity = datetime.fromisoformat(recent_activity.data[0]['timestamp'].replace('Z', '+00:00'))
                    stats.last_activity = recent_activity.data[0]['timestamp']
                    stats.is_active = (datetime.utcnow() - last_activity).days < 7

                # Application stats
                applications = self.db.table('applications').select('status').eq('student_id', student_id).execute()
                if applications.data:
                    stats.total_applications = len(applications.data)
                    stats.pending_applications = len([a for a in applications.data if a['status'] in ['pending', 'under_review']])
                    stats.accepted_applications = len([a for a in applications.data if a['status'] == 'accepted'])
                    stats.rejected_applications = len([a for a in applications.data if a['status'] == 'rejected'])

                # Counseling stats
                sessions = self.db.table('counseling_sessions').select('*').eq('student_id', student_id).execute()
                if sessions.data:
                    stats.upcoming_sessions = len([s for s in sessions.data if s['status'] == 'scheduled'])

                    # Sessions this month
                    month_start = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
                    completed_this_month = [
                        s for s in sessions.data
                        if s['status'] == 'completed' and datetime.fromisoformat(s['updated_at'].replace('Z', '+00:00')) >= month_start
                    ]
                    stats.completed_sessions_this_month = len(completed_this_month)

                    ratings = [s['feedback_rating'] for s in sessions.data if s.get('feedback_rating')]
                    stats.average_counseling_rating = sum(ratings) / len(ratings) if ratings else None

                # Achievement stats
                achievements = self.db.table('student_achievements').select('earned_at').eq('student_id', student_id).execute()
                if achievements.data:
                    stats.achievements_count = len(achievements.data)

                    month_start = datetime.utcnow().replace(day=1, hour=0, minute=0, second=0, microsecond=0)
                    achievements_this_month = [
                        a for a in achievements.data
                        if datetime.fromisoformat(a['earned_at'].replace('Z', '+00:00')) >= month_start
                    ]
                    stats.achievements_this_month = len(achievements_this_month)

                # Alert stats
                alerts = self.db.table('parent_alerts').select('*').eq('parent_id', parent_id).eq('student_id', student_id).execute()
                if alerts.data:
                    stats.unread_alerts = len([a for a in alerts.data if not a.get('is_read')])
                    stats.high_severity_alerts = len([a for a in alerts.data if a.get('severity') == 'high' and not a.get('is_read')])

                # Activity stats (last 30 days)
                thirty_days_ago = (datetime.utcnow() - timedelta(days=30)).isoformat()
                activities = self.db.table('student_activities').select('*').eq(
                    'student_id', student_id
                ).gte('timestamp', thirty_days_ago).execute()

                if activities.data:
                    stats.total_activities_last_30_days = len(activities.data)

                students_stats.append(stats)

            return MultiStudentDashboardResponse(
                parent_id=parent_id,
                students=students_stats,
                total_students=len(students_stats)
            )

        except Exception as e:
            logger.error(f"Get dashboard error: {e}")
            raise Exception(f"Failed to get dashboard: {str(e)}")
