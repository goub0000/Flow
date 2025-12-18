"""
Parent Monitoring Service
Business logic for parent monitoring and student activity tracking
"""
from typing import Optional, List, Dict, Any
from datetime import datetime, timedelta
import logging
import secrets
import string
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
    CourseProgressSummary,
    ApplicationProgressSummary,
    CounselingSessionSummary,
    AlertSettingsUpdateRequest,
    AlertSettingsResponse,
    ParentAlertResponse,
    ParentAlertListResponse,
    ParentDashboardStats,
    MultiStudentDashboardResponse,
    LinkStatus,
    ChildResponse,
    ChildApplicationResponse,
    ChildEnrollmentResponse,
    LinkByEmailRequest,
    LinkByEmailResponse,
    InviteCodeCreateRequest,
    InviteCodeResponse,
    InviteCodeListResponse,
    UseInviteCodeRequest,
    UseInviteCodeResponse,
    PendingLinkResponse,
    PendingLinksListResponse
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
            # Resolve student_id - handle both user_id (auth) and internal profile ID
            internal_student_id = student_id
            profile_response = self.db.table('student_profiles').select('id').eq('user_id', student_id).execute()

            if profile_response.data and len(profile_response.data) > 0:
                internal_student_id = profile_response.data[0]['id']
            else:
                # Check if it's already an internal profile id
                profile_by_id = self.db.table('student_profiles').select('id').eq('id', student_id).execute()
                if profile_by_id.data and len(profile_by_id.data) > 0:
                    internal_student_id = student_id

            link = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', internal_student_id).eq('status', LinkStatus.ACTIVE.value).single().execute()

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
            # Resolve student_id - handle both user_id (auth) and internal profile ID
            internal_student_id = student_id
            profile_response = self.db.table('student_profiles').select('id').eq('user_id', student_id).execute()

            if profile_response.data and len(profile_response.data) > 0:
                internal_student_id = profile_response.data[0]['id']
            else:
                # Check if it's already an internal profile id
                profile_by_id = self.db.table('student_profiles').select('id').eq('id', student_id).execute()
                if profile_by_id.data and len(profile_by_id.data) > 0:
                    internal_student_id = student_id

            # Verify parent access (using resolved ID)
            link = await self.verify_parent_access(parent_id, internal_student_id)

            if not link.can_view_activity:
                raise Exception("Parent does not have permission to view activity")

            query = self.db.table('student_activities').select('*', count='exact').eq('student_id', internal_student_id)

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
            # Resolve student_id - handle both user_id (auth) and internal profile ID
            student_id = report_request.student_id
            internal_student_id = student_id
            profile_response = self.db.table('student_profiles').select('id, user_id').eq('user_id', student_id).execute()

            if profile_response.data and len(profile_response.data) > 0:
                internal_student_id = profile_response.data[0]['id']
            else:
                # Check if it's already an internal profile id
                profile_by_id = self.db.table('student_profiles').select('id, user_id').eq('id', student_id).execute()
                if profile_by_id.data and len(profile_by_id.data) > 0:
                    internal_student_id = student_id
                    # Get the user_id for fetching user info
                    student_id = profile_by_id.data[0].get('user_id', student_id)

            # Verify parent access (using resolved ID)
            await self.verify_parent_access(parent_id, internal_student_id)

            # Get student info (using user_id for users table)
            student = self.db.table('users').select('full_name').eq('id', student_id).single().execute()
            student_name = student.data.get('full_name', 'Student') if student.data else 'Student'

            report = ProgressReportResponse(
                student_id=student_id,
                student_name=student_name,
                report_period_start=report_request.report_period_start,
                report_period_end=report_request.report_period_end,
                generated_at=datetime.utcnow().isoformat()
            )

            # Courses data
            if report_request.include_courses:
                enrollments = self.db.table('enrollments').select('*').eq('student_id', internal_student_id).execute()

                if enrollments.data:
                    report.total_courses = len(enrollments.data)
                    report.active_courses = len([e for e in enrollments.data if e['status'] == 'active'])
                    report.completed_courses = len([e for e in enrollments.data if e['status'] == 'completed'])

                    progress_values = [e['progress_percentage'] for e in enrollments.data]
                    report.average_progress = sum(progress_values) / len(progress_values) if progress_values else 0.0

                    # Get course details
                    for enrollment in enrollments.data:
                        course = self.db.table('courses').select('title').eq('id', enrollment['course_id']).single().execute()
                        course_title = course.data.get('title', 'Unknown') if course.data else 'Unknown'

                        report.courses.append(CourseProgressSummary(
                            course_id=enrollment['course_id'],
                            course_title=course_title,
                            enrollment_status=enrollment['status'],
                            progress_percentage=enrollment['progress_percentage'],
                            last_activity=enrollment.get('updated_at')
                        ))

            # Applications data
            if report_request.include_applications:
                applications = self.db.table('applications').select('*').eq('student_id', internal_student_id).execute()

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
                sessions = self.db.table('counseling_sessions').select('*').eq('student_id', internal_student_id).execute()

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
                achievements = self.db.table('student_achievements').select('*').eq('student_id', internal_student_id).execute()

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
            activities = self.db.table('student_activities').select('*').eq('student_id', internal_student_id).gte(
                'timestamp', report_request.report_period_start
            ).lte('timestamp', report_request.report_period_end).execute()

            if activities.data:
                report.total_activities = len(activities.data)

                # Group by type
                for activity in activities.data:
                    atype = activity.get('activity_type', 'unknown')
                    report.activities_by_type[atype] = report.activities_by_type.get(atype, 0) + 1

            logger.info(f"Progress report generated for student: {internal_student_id}")

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
                    active_courses=0,
                    average_course_progress=0.0,
                    courses_at_risk=0,
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

                # Course stats
                enrollments = self.db.table('enrollments').select('*').eq('student_id', student_id).execute()
                if enrollments.data:
                    stats.active_courses = len([e for e in enrollments.data if e['status'] == 'active'])
                    progress_values = [e['progress_percentage'] for e in enrollments.data if e['status'] == 'active']
                    stats.average_course_progress = sum(progress_values) / len(progress_values) if progress_values else 0.0
                    stats.courses_at_risk = len([e for e in enrollments.data if e['progress_percentage'] < 50 and e['status'] == 'active'])

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

    # ==================== Children Methods (Frontend Compatibility) ====================

    async def get_children_for_parent(self, parent_id: str) -> List[ChildResponse]:
        """Get all linked children for a parent with full details"""
        try:
            # Get all active links for parent
            links = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('status', LinkStatus.ACTIVE.value).execute()

            if not links.data:
                return []

            children = []
            for link in links.data:
                student_id = link['student_id']
                child = await self._build_child_response(parent_id, student_id)
                if child:
                    children.append(child)

            return children

        except Exception as e:
            logger.error(f"Get children error: {e}")
            raise Exception(f"Failed to get children: {str(e)}")

    async def get_child_by_id(self, parent_id: str, student_id: str) -> ChildResponse:
        """Get single child by ID"""
        try:
            # Verify link exists
            link = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', student_id).execute()

            if not link.data:
                raise Exception("Child not linked to parent")

            child = await self._build_child_response(parent_id, student_id)
            if not child:
                raise Exception("Failed to build child data")

            return child

        except Exception as e:
            logger.error(f"Get child by ID error: {e}")
            raise Exception(f"Failed to get child: {str(e)}")

    async def _build_child_response(self, parent_id: str, student_id: str) -> Optional[ChildResponse]:
        """Build ChildResponse from database"""
        try:
            # Get student/user info
            user = self.db.table('users').select('*').eq('id', student_id).single().execute()
            if not user.data:
                return None

            user_data = user.data

            # Get student profile for additional info
            profile = self.db.table('student_profiles').select('*').eq('user_id', student_id).single().execute()
            profile_data = profile.data if profile.data else {}

            # Get applications
            apps = self.db.table('applications').select('*').eq('student_id', student_id).execute()
            applications = []
            if apps.data:
                for app in apps.data:
                    applications.append(ChildApplicationResponse(
                        id=app['id'],
                        institutionName=app.get('institution_name', 'Unknown'),
                        programName=app.get('program_name', 'Unknown'),
                        status=app.get('status', 'pending'),
                        submittedAt=app.get('submitted_at', app.get('created_at', datetime.utcnow().isoformat()))
                    ))

            # Get enrollments for course list
            enrollments = self.db.table('enrollments').select('course_id, courses(title)').eq('student_id', student_id).execute()
            enrolled_courses = []
            if enrollments.data:
                for enr in enrollments.data:
                    course_title = enr.get('courses', {}).get('title') if enr.get('courses') else f"Course {enr.get('course_id', 'Unknown')}"
                    enrolled_courses.append(course_title)

            # Get last activity
            last_activity = self.db.table('student_activities').select('timestamp').eq(
                'student_id', student_id
            ).order('timestamp', desc=True).limit(1).execute()

            last_active = datetime.utcnow().isoformat()
            if last_activity.data:
                last_active = last_activity.data[0]['timestamp']

            # Calculate average grade from enrollments
            grades = self.db.table('enrollments').select('grade').eq('student_id', student_id).not_.is_('grade', 'null').execute()
            average_grade = 0.0
            if grades.data:
                grade_values = [g['grade'] for g in grades.data if g.get('grade') is not None]
                if grade_values:
                    average_grade = sum(grade_values) / len(grade_values)

            # Build response
            return ChildResponse(
                id=student_id,
                parentId=parent_id,
                name=user_data.get('full_name', user_data.get('email', 'Unknown')),
                email=user_data.get('email', ''),
                dateOfBirth=profile_data.get('date_of_birth', '2005-01-01'),
                photoUrl=user_data.get('avatar_url'),
                schoolName=profile_data.get('school_name', profile_data.get('institution_name')),
                grade=profile_data.get('grade_level', profile_data.get('education_level', 'Unknown')),
                enrolledCourses=enrolled_courses,
                applications=applications,
                averageGrade=average_grade,
                lastActive=last_active
            )

        except Exception as e:
            logger.error(f"Build child response error: {e}")
            return None

    async def remove_child_link(self, parent_id: str, child_id: str) -> Dict[str, Any]:
        """Remove parent-child link"""
        try:
            # Find the link
            link = self.db.table('parent_student_links').select('id').eq(
                'parent_id', parent_id
            ).eq('student_id', child_id).single().execute()

            if not link.data:
                raise Exception("Link not found")

            # Revoke the link
            return await self.revoke_parent_link(link.data['id'], parent_id)

        except Exception as e:
            logger.error(f"Remove child link error: {e}")
            raise Exception(f"Failed to remove child: {str(e)}")

    async def get_child_enrollments(self, parent_id: str, child_id: str) -> List[ChildEnrollmentResponse]:
        """Get child's course enrollments"""
        try:
            # Verify access
            await self.verify_parent_access(parent_id, child_id)

            # Get enrollments with course info
            enrollments = self.db.table('enrollments').select(
                '*, courses(title, total_lessons)'
            ).eq('student_id', child_id).execute()

            result = []
            if enrollments.data:
                for enr in enrollments.data:
                    course = enr.get('courses', {}) or {}
                    course_title = course.get('title', f"Course {enr.get('course_id', 'Unknown')}")
                    total_lessons = course.get('total_lessons', 10)

                    # Calculate completion
                    completed_lessons = enr.get('completed_lessons', 0)
                    completion_pct = (completed_lessons / total_lessons * 100) if total_lessons > 0 else 0

                    result.append(ChildEnrollmentResponse(
                        id=enr.get('id', ''),
                        courseName=course_title,
                        completionPercentage=completion_pct,
                        currentGrade=enr.get('grade', 0.0) or 0.0,
                        assignmentsCompleted=enr.get('assignments_completed', 0) or 0,
                        totalAssignments=enr.get('total_assignments', 10) or 10,
                        lastActivity=enr.get('last_activity', enr.get('updated_at', datetime.utcnow().isoformat()))
                    ))

            return result

        except Exception as e:
            logger.error(f"Get child enrollments error: {e}")
            raise Exception(f"Failed to get enrollments: {str(e)}")

    async def get_child_applications(self, parent_id: str, child_id: str) -> List[ChildApplicationResponse]:
        """Get child's applications"""
        try:
            # Verify access
            await self.verify_parent_access(parent_id, child_id)

            # Get applications
            apps = self.db.table('applications').select('*').eq('student_id', child_id).execute()

            result = []
            if apps.data:
                for app in apps.data:
                    result.append(ChildApplicationResponse(
                        id=app['id'],
                        institutionName=app.get('institution_name', 'Unknown'),
                        programName=app.get('program_name', 'Unknown'),
                        status=app.get('status', 'pending'),
                        submittedAt=app.get('submitted_at', app.get('created_at', datetime.utcnow().isoformat()))
                    ))

            return result

        except Exception as e:
            logger.error(f"Get child applications error: {e}")
            raise Exception(f"Failed to get applications: {str(e)}")

    # ==================== Email-Based Linking ====================

    async def create_link_by_email(
        self,
        parent_id: str,
        request: LinkByEmailRequest
    ) -> LinkByEmailResponse:
        """Create parent-student link by student's email address"""
        try:
            # Find student by email
            student = self.db.table('users').select('id, display_name, full_name, roles, available_roles').eq(
                'email', request.student_email.lower().strip()
            ).single().execute()

            if not student.data:
                return LinkByEmailResponse(
                    success=False,
                    message=f"No student found with email: {request.student_email}"
                )

            # Check if user is a student
            roles = student.data.get('roles', []) or student.data.get('available_roles', []) or []
            if 'student' not in roles:
                return LinkByEmailResponse(
                    success=False,
                    message="The user with this email is not registered as a student"
                )

            student_id = student.data['id']
            student_name = student.data.get('display_name') or student.data.get('full_name') or 'Student'

            # Check if link already exists
            existing = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', student_id).execute()

            if existing.data:
                existing_link = existing.data[0]
                status = existing_link.get('status', 'unknown')
                if status == 'active':
                    return LinkByEmailResponse(
                        success=False,
                        message=f"You are already linked with {student_name}"
                    )
                elif status == 'pending':
                    return LinkByEmailResponse(
                        success=False,
                        message=f"A link request to {student_name} is already pending approval"
                    )
                elif status == 'declined':
                    # Delete the old declined link and allow new request
                    self.db.table('parent_student_links').delete().eq('id', existing_link['id']).execute()

            # Create the link request
            link_request = ParentStudentLinkCreateRequest(
                student_id=student_id,
                relationship=request.relationship,
                can_view_grades=request.can_view_grades,
                can_view_activity=request.can_view_activity,
                can_view_messages=request.can_view_messages,
                can_receive_alerts=request.can_receive_alerts
            )

            link = await self.create_parent_link(parent_id, link_request)

            logger.info(f"Link request created by email: parent={parent_id}, student={student_id}")

            return LinkByEmailResponse(
                success=True,
                message=f"Link request sent to {student_name}. Awaiting their approval.",
                link_id=link.id,
                student_name=student_name,
                status="pending"
            )

        except Exception as e:
            logger.error(f"Create link by email error: {e}")
            return LinkByEmailResponse(
                success=False,
                message=f"Failed to create link request: {str(e)}"
            )

    # ==================== Invite Code System ====================

    def _generate_invite_code(self) -> str:
        """Generate a random 8-character invite code (excludes confusing characters)"""
        # Exclude 0, O, 1, I, l to avoid confusion
        chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
        return ''.join(secrets.choice(chars) for _ in range(8))

    async def create_invite_code(
        self,
        student_id: str,
        request: InviteCodeCreateRequest
    ) -> InviteCodeResponse:
        """Student generates an invite code for their parent"""
        try:
            # Generate unique code
            code = self._generate_invite_code()

            # Ensure uniqueness
            attempts = 0
            while attempts < 5:
                existing = self.db.table('student_invite_codes').select('id').eq('code', code).execute()
                if not existing.data:
                    break
                code = self._generate_invite_code()
                attempts += 1

            expires_at = datetime.utcnow() + timedelta(days=request.expires_in_days)

            invite = {
                "id": str(uuid4()),
                "code": code,
                "student_id": student_id,
                "expires_at": expires_at.isoformat(),
                "max_uses": request.max_uses,
                "uses_remaining": request.max_uses,
                "is_active": True,
                "created_at": datetime.utcnow().isoformat(),
                "updated_at": datetime.utcnow().isoformat()
            }

            response = self.db.table('student_invite_codes').insert(invite).execute()

            if not response.data:
                raise Exception("Failed to create invite code")

            logger.info(f"Invite code created: {code} for student {student_id}")

            return InviteCodeResponse(**response.data[0])

        except Exception as e:
            logger.error(f"Create invite code error: {e}")
            raise Exception(f"Failed to create invite code: {str(e)}")

    async def list_invite_codes(self, student_id: str) -> InviteCodeListResponse:
        """List all invite codes for a student"""
        try:
            response = self.db.table('student_invite_codes').select('*').eq(
                'student_id', student_id
            ).order('created_at', desc=True).execute()

            codes = []
            if response.data:
                for code_data in response.data:
                    # Check if expired
                    expires_at = datetime.fromisoformat(code_data['expires_at'].replace('Z', '+00:00'))
                    is_active = code_data['is_active'] and expires_at > datetime.utcnow() and code_data['uses_remaining'] > 0
                    code_data['is_active'] = is_active
                    codes.append(InviteCodeResponse(**code_data))

            return InviteCodeListResponse(codes=codes, total=len(codes))

        except Exception as e:
            logger.error(f"List invite codes error: {e}")
            raise Exception(f"Failed to list invite codes: {str(e)}")

    async def delete_invite_code(self, student_id: str, code_id: str) -> Dict[str, Any]:
        """Delete/deactivate an invite code"""
        try:
            # Verify ownership
            code = self.db.table('student_invite_codes').select('*').eq('id', code_id).single().execute()

            if not code.data:
                raise Exception("Invite code not found")

            if code.data['student_id'] != student_id:
                raise Exception("Not authorized to delete this code")

            # Deactivate the code
            self.db.table('student_invite_codes').update({
                'is_active': False,
                'updated_at': datetime.utcnow().isoformat()
            }).eq('id', code_id).execute()

            logger.info(f"Invite code deactivated: {code_id}")

            return {"success": True, "message": "Invite code deleted"}

        except Exception as e:
            logger.error(f"Delete invite code error: {e}")
            raise Exception(f"Failed to delete invite code: {str(e)}")

    async def use_invite_code(
        self,
        parent_id: str,
        request: UseInviteCodeRequest
    ) -> UseInviteCodeResponse:
        """Parent uses an invite code to link with student"""
        try:
            code_str = request.code.upper().strip()

            # Find the code
            code = self.db.table('student_invite_codes').select('*').eq('code', code_str).single().execute()

            if not code.data:
                return UseInviteCodeResponse(
                    success=False,
                    message="Invalid invite code"
                )

            code_data = code.data

            # Check if code is valid
            if not code_data['is_active']:
                return UseInviteCodeResponse(
                    success=False,
                    message="This invite code has been deactivated"
                )

            expires_at = datetime.fromisoformat(code_data['expires_at'].replace('Z', '+00:00'))
            if expires_at < datetime.utcnow():
                return UseInviteCodeResponse(
                    success=False,
                    message="This invite code has expired"
                )

            if code_data['uses_remaining'] <= 0:
                return UseInviteCodeResponse(
                    success=False,
                    message="This invite code has been used up"
                )

            student_id = code_data['student_id']

            # Get student info
            student = self.db.table('users').select('display_name, full_name, email').eq('id', student_id).single().execute()
            student_name = 'Student'
            student_email = ''
            if student.data:
                student_name = student.data.get('display_name') or student.data.get('full_name') or 'Student'
                student_email = student.data.get('email', '')

            # Check if link already exists
            existing = self.db.table('parent_student_links').select('*').eq(
                'parent_id', parent_id
            ).eq('student_id', student_id).execute()

            if existing.data:
                existing_link = existing.data[0]
                status = existing_link.get('status', 'unknown')
                if status == 'active':
                    return UseInviteCodeResponse(
                        success=False,
                        message=f"You are already linked with {student_name}"
                    )
                elif status == 'pending':
                    return UseInviteCodeResponse(
                        success=False,
                        message=f"A link request to {student_name} is already pending"
                    )
                elif status in ['declined', 'revoked']:
                    # Delete old link and create new one
                    self.db.table('parent_student_links').delete().eq('id', existing_link['id']).execute()

            # Create the link (with pending status for approval)
            link_request = ParentStudentLinkCreateRequest(
                student_id=student_id,
                relationship=request.relationship,
                can_view_grades=True,
                can_view_activity=True,
                can_view_messages=False,
                can_receive_alerts=True
            )

            link = await self.create_parent_link(parent_id, link_request)

            # Decrement uses remaining
            self.db.table('student_invite_codes').update({
                'uses_remaining': code_data['uses_remaining'] - 1,
                'updated_at': datetime.utcnow().isoformat()
            }).eq('id', code_data['id']).execute()

            logger.info(f"Invite code used: {code_str} by parent {parent_id} for student {student_id}")

            return UseInviteCodeResponse(
                success=True,
                message=f"Link request sent to {student_name}. Awaiting their approval.",
                link_id=link.id,
                student_name=student_name,
                student_email=student_email,
                status="pending"
            )

        except Exception as e:
            logger.error(f"Use invite code error: {e}")
            return UseInviteCodeResponse(
                success=False,
                message=f"Failed to use invite code: {str(e)}"
            )

    # ==================== Pending Links for Students ====================

    async def get_pending_links_for_student(self, student_id: str) -> PendingLinksListResponse:
        """Get all pending link requests for a student to approve/decline"""
        try:
            # Get pending links
            links = self.db.table('parent_student_links').select('*').eq(
                'student_id', student_id
            ).eq('status', LinkStatus.PENDING.value).execute()

            pending_links = []
            if links.data:
                for link in links.data:
                    # Get parent info
                    parent = self.db.table('users').select('display_name, full_name, email').eq(
                        'id', link['parent_id']
                    ).single().execute()

                    parent_name = 'Parent'
                    parent_email = ''
                    if parent.data:
                        parent_name = parent.data.get('display_name') or parent.data.get('full_name') or 'Parent'
                        parent_email = parent.data.get('email', '')

                    pending_links.append(PendingLinkResponse(
                        id=link['id'],
                        parent_id=link['parent_id'],
                        parent_name=parent_name,
                        parent_email=parent_email,
                        relationship=link['relationship'],
                        requested_permissions={
                            "can_view_grades": link['can_view_grades'],
                            "can_view_activity": link['can_view_activity'],
                            "can_view_messages": link['can_view_messages'],
                            "can_receive_alerts": link['can_receive_alerts']
                        },
                        created_at=link['created_at']
                    ))

            return PendingLinksListResponse(links=pending_links, total=len(pending_links))

        except Exception as e:
            logger.error(f"Get pending links error: {e}")
            raise Exception(f"Failed to get pending links: {str(e)}")

    async def decline_parent_link(self, link_id: str, student_id: str) -> Dict[str, Any]:
        """Student declines a parent link request"""
        try:
            link = self.db.table('parent_student_links').select('*').eq('id', link_id).single().execute()

            if not link.data:
                raise Exception("Link not found")

            if link.data['student_id'] != student_id:
                raise Exception("Not authorized")

            if link.data['status'] != LinkStatus.PENDING.value:
                raise Exception(f"Cannot decline link with status: {link.data['status']}")

            update = {
                "status": LinkStatus.DECLINED.value,
                "updated_at": datetime.utcnow().isoformat()
            }

            self.db.table('parent_student_links').update(update).eq('id', link_id).execute()

            logger.info(f"Parent link declined: {link_id}")

            return {"success": True, "message": "Link request declined"}

        except Exception as e:
            logger.error(f"Decline link error: {e}")
            raise Exception(f"Failed to decline link: {str(e)}")
