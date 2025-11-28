"""
Student Activities Service
Aggregates student activities from multiple data sources:
- Applications
- Achievements
- Meetings
- Messages
- Enrollments
"""
import logging
from datetime import datetime, timedelta
from typing import List, Optional
from uuid import uuid4

from supabase import Client

from app.schemas.activity import (
    StudentActivity,
    StudentActivityType,
    StudentActivityFeedResponse,
    StudentActivityFilterRequest
)
from app.database.config import get_db

logger = logging.getLogger(__name__)


class StudentActivitiesService:
    """Service for managing student activity feeds"""

    def __init__(self):
        pass

    async def get_student_activities(
        self,
        student_id: str,
        filters: Optional[StudentActivityFilterRequest] = None,
        db: Optional[Client] = None
    ) -> StudentActivityFeedResponse:
        """
        Get aggregated activities for a student

        Args:
            student_id: The student's user ID (Supabase auth user ID)
            filters: Optional filters for pagination and filtering
            db: Optional database client (will create if not provided)

        Returns:
            StudentActivityFeedResponse with activities and pagination info
        """
        if filters is None:
            filters = StudentActivityFilterRequest()

        if db is None:
            # This will be injected in the API route
            raise ValueError("Database client is required")

        # Collect activities from various sources
        activities = []

        try:
            # First, get the internal student_id from the student_profiles table
            # The passed student_id is the Supabase auth user_id, but we need the internal profile id
            profile_response = db.table('student_profiles').select('id').eq('user_id', student_id).execute()

            if not profile_response.data or len(profile_response.data) == 0:
                # No student profile found - return empty activities
                logger.warning(f"No student profile found for user_id: {student_id}")
                return StudentActivityFeedResponse(
                    activities=[],
                    total_count=0,
                    page=filters.page,
                    limit=filters.limit,
                    has_more=False
                )

            # Use the internal student profile id for database queries
            internal_student_id = profile_response.data[0]['id']
            logger.info(f"Resolved user_id {student_id} to internal student_id {internal_student_id}")

            # First, try to get from dedicated student_activities table
            stored_activities = await self._get_stored_activities(
                internal_student_id, filters, db
            )

            if stored_activities:
                # If we have stored activities, use them (they're more efficient)
                activities.extend(stored_activities)
                logger.info(f"Retrieved {len(stored_activities)} stored activities for student {internal_student_id}")
            else:
                # Fallback to real-time aggregation from various tables
                logger.info(f"No stored activities found, aggregating from source tables for student {internal_student_id}")

                # 1. Application Activities
                application_activities = await self._get_application_activities(
                    internal_student_id, filters, db
                )
                activities.extend(application_activities)

                # 2. Achievement Activities
                achievement_activities = await self._get_achievement_activities(
                    internal_student_id, filters, db
                )
                activities.extend(achievement_activities)

                # 3. Meeting Activities
                meeting_activities = await self._get_meeting_activities(
                    internal_student_id, filters, db
                )
                activities.extend(meeting_activities)

                # 4. Message Activities (recent unread messages)
                # Note: Messages use receiver_id which is the auth user_id, not internal_student_id
                message_activities = await self._get_message_activities(
                    student_id, filters, db  # Use original user_id for messages
                )
                activities.extend(message_activities)

                # 5. Enrollment Activities
                enrollment_activities = await self._get_enrollment_activities(
                    internal_student_id, filters, db
                )
                activities.extend(enrollment_activities)

            # Sort by timestamp (most recent first)
            activities.sort(key=lambda x: x.timestamp, reverse=True)

            # Apply pagination
            total_count = len(activities)
            start_idx = (filters.page - 1) * filters.limit
            end_idx = start_idx + filters.limit

            paginated_activities = activities[start_idx:end_idx]
            has_more = end_idx < total_count

            return StudentActivityFeedResponse(
                activities=paginated_activities,
                total_count=total_count,
                page=filters.page,
                limit=filters.limit,
                has_more=has_more
            )

        except Exception as e:
            logger.error(f"Error fetching student activities: {e}")
            raise

    async def _get_stored_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get activities from the dedicated student_activities table"""
        activities = []

        try:
            # Build query
            query = db.table('student_activities').select('*').eq('student_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('timestamp', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('timestamp', filters.end_date.isoformat())

            # Apply activity type filter
            if filters.activity_types:
                # Convert enum values to strings for query
                type_values = [t.value for t in filters.activity_types]
                query = query.in_('activity_type', type_values)

            # Execute query with sorting and limit
            result = query.order('timestamp', desc=True).limit(200).execute()

            if result.data:
                for activity in result.data:
                    try:
                        # Convert database record to StudentActivity model
                        activities.append(StudentActivity(
                            id=activity['id'],
                            timestamp=datetime.fromisoformat(activity['timestamp'].replace('Z', '+00:00')),
                            type=StudentActivityType(activity['activity_type']),
                            title=activity['title'],
                            description=activity['description'],
                            icon=activity['icon'],
                            related_entity_id=activity.get('related_entity_id'),
                            metadata=activity.get('metadata', {}),
                        ))
                    except Exception as e:
                        logger.warning(f"Skipping invalid activity record: {e}")
                        continue

        except Exception as e:
            logger.error(f"Error fetching stored activities: {e}")
            # Don't raise - fall back to aggregation

        return activities

    async def _get_application_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get application-related activities"""
        activities = []

        try:
            # Build query
            query = db.table('applications').select('*').eq('student_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('created_at', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('created_at', filters.end_date.isoformat())

            # Execute query
            result = query.order('created_at', desc=True).limit(50).execute()

            for app in result.data:
                # Application submitted
                if app.get('status') in ['submitted', 'under_review', 'pending']:
                    activities.append(StudentActivity(
                        id=f"app_submit_{app['id']}",
                        timestamp=datetime.fromisoformat(app['created_at'].replace('Z', '+00:00')),
                        type=StudentActivityType.APPLICATION_SUBMITTED,
                        title="Application Submitted",
                        description=f"You submitted an application to {app.get('institution_name', 'Unknown Institution')}",
                        icon="📝",
                        related_entity_id=app['id'],
                        metadata={
                            'institution_name': app.get('institution_name'),
                            'program_name': app.get('program_name'),
                            'status': app.get('status')
                        }
                    ))

                # Application status changed (if updated_at differs from created_at)
                if app.get('updated_at') and app.get('updated_at') != app.get('created_at'):
                    if app.get('status') in ['accepted', 'rejected', 'waitlisted']:
                        status_icon = {
                            'accepted': '🎉',
                            'rejected': '📋',
                            'waitlisted': '⏳'
                        }.get(app.get('status'), '📄')

                        status_title = {
                            'accepted': 'Application Accepted',
                            'rejected': 'Application Status Update',
                            'waitlisted': 'Added to Waitlist'
                        }.get(app.get('status'), 'Application Updated')

                        activities.append(StudentActivity(
                            id=f"app_status_{app['id']}",
                            timestamp=datetime.fromisoformat(app['updated_at'].replace('Z', '+00:00')),
                            type=StudentActivityType.APPLICATION_STATUS_CHANGED,
                            title=status_title,
                            description=f"Your application to {app.get('institution_name', 'Unknown Institution')} was {app.get('status')}",
                            icon=status_icon,
                            related_entity_id=app['id'],
                            metadata={
                                'institution_name': app.get('institution_name'),
                                'program_name': app.get('program_name'),
                                'status': app.get('status'),
                                'previous_status': app.get('previous_status')
                            }
                        ))

        except Exception as e:
            logger.error(f"Error fetching application activities: {e}")

        return activities

    async def _get_achievement_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get achievement-related activities"""
        activities = []

        try:
            # Build query
            query = db.table('achievements').select('*').eq('student_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('earned_at', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('earned_at', filters.end_date.isoformat())

            # Execute query
            result = query.order('earned_at', desc=True).limit(20).execute()

            for achievement in result.data:
                activities.append(StudentActivity(
                    id=f"achievement_{achievement['id']}",
                    timestamp=datetime.fromisoformat(achievement['earned_at'].replace('Z', '+00:00')),
                    type=StudentActivityType.ACHIEVEMENT_EARNED,
                    title=f"Achievement Unlocked: {achievement.get('name', 'New Achievement')}",
                    description=achievement.get('description', 'You earned a new achievement!'),
                    icon="🏆",
                    related_entity_id=achievement['id'],
                    metadata={
                        'achievement_name': achievement.get('name'),
                        'points': achievement.get('points', 0),
                        'category': achievement.get('category')
                    }
                ))

        except Exception as e:
            logger.error(f"Error fetching achievement activities: {e}")

        return activities

    async def _get_meeting_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get meeting-related activities"""
        activities = []

        try:
            # Build query
            query = db.table('meetings').select('*').eq('student_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('created_at', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('created_at', filters.end_date.isoformat())

            # Execute query
            result = query.order('created_at', desc=True).limit(20).execute()

            for meeting in result.data:
                # Meeting scheduled (approved)
                if meeting.get('status') == 'approved' and meeting.get('scheduled_date'):
                    activities.append(StudentActivity(
                        id=f"meeting_scheduled_{meeting['id']}",
                        timestamp=datetime.fromisoformat(meeting['updated_at'].replace('Z', '+00:00')),
                        type=StudentActivityType.MEETING_SCHEDULED,
                        title="Meeting Scheduled",
                        description=f"Meeting with {meeting.get('staff_name', 'counselor')} scheduled for {meeting.get('scheduled_date', '')}",
                        icon="📅",
                        related_entity_id=meeting['id'],
                        metadata={
                            'staff_name': meeting.get('staff_name'),
                            'scheduled_date': meeting.get('scheduled_date'),
                            'subject': meeting.get('subject'),
                            'meeting_mode': meeting.get('meeting_mode')
                        }
                    ))

                # Meeting completed
                if meeting.get('status') == 'completed':
                    activities.append(StudentActivity(
                        id=f"meeting_completed_{meeting['id']}",
                        timestamp=datetime.fromisoformat(meeting['updated_at'].replace('Z', '+00:00')),
                        type=StudentActivityType.MEETING_COMPLETED,
                        title="Meeting Completed",
                        description=f"Completed meeting with {meeting.get('staff_name', 'counselor')}",
                        icon="✅",
                        related_entity_id=meeting['id'],
                        metadata={
                            'staff_name': meeting.get('staff_name'),
                            'subject': meeting.get('subject'),
                            'notes': meeting.get('staff_notes')
                        }
                    ))

        except Exception as e:
            logger.error(f"Error fetching meeting activities: {e}")

        return activities

    async def _get_message_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get message-related activities (recent unread messages)"""
        activities = []

        try:
            # Build query for received messages
            query = db.table('messages').select('*').eq('receiver_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('created_at', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('created_at', filters.end_date.isoformat())

            # Execute query - only get recent messages
            result = query.order('created_at', desc=True).limit(10).execute()

            for message in result.data:
                # Only show unread or recent messages (last 7 days)
                message_date = datetime.fromisoformat(message['created_at'].replace('Z', '+00:00'))
                if not message.get('is_read') or (datetime.now() - message_date).days <= 7:
                    activities.append(StudentActivity(
                        id=f"message_{message['id']}",
                        timestamp=message_date,
                        type=StudentActivityType.MESSAGE_RECEIVED,
                        title=f"New Message from {message.get('sender_name', 'Unknown')}",
                        description=message.get('subject', 'You have a new message'),
                        icon="💬",
                        related_entity_id=message['id'],
                        metadata={
                            'sender_name': message.get('sender_name'),
                            'subject': message.get('subject'),
                            'is_read': message.get('is_read', False)
                        }
                    ))

        except Exception as e:
            logger.error(f"Error fetching message activities: {e}")

        return activities

    async def _get_enrollment_activities(
        self,
        student_id: str,
        filters: StudentActivityFilterRequest,
        db: Client
    ) -> List[StudentActivity]:
        """Get enrollment/course-related activities"""
        activities = []

        try:
            # Build query
            query = db.table('enrollments').select('*, course:courses(*)').eq('student_id', student_id)

            # Apply date filters
            if filters.start_date:
                query = query.gte('enrolled_at', filters.start_date.isoformat())
            if filters.end_date:
                query = query.lte('enrolled_at', filters.end_date.isoformat())

            # Execute query
            result = query.order('enrolled_at', desc=True).limit(20).execute()

            for enrollment in result.data:
                course = enrollment.get('course', {})

                # Course enrollment
                activities.append(StudentActivity(
                    id=f"enrollment_{enrollment['id']}",
                    timestamp=datetime.fromisoformat(enrollment['enrolled_at'].replace('Z', '+00:00')),
                    type=StudentActivityType.COURSE_COMPLETED,  # Using this for now
                    title="Course Enrolled",
                    description=f"Enrolled in {course.get('name', 'a course')}",
                    icon="📚",
                    related_entity_id=enrollment['id'],
                    metadata={
                        'course_name': course.get('name'),
                        'course_code': course.get('code'),
                        'status': enrollment.get('status')
                    }
                ))

                # Course completion
                if enrollment.get('completed_at'):
                    activities.append(StudentActivity(
                        id=f"completion_{enrollment['id']}",
                        timestamp=datetime.fromisoformat(enrollment['completed_at'].replace('Z', '+00:00')),
                        type=StudentActivityType.COURSE_COMPLETED,
                        title="Course Completed",
                        description=f"Completed {course.get('name', 'a course')}",
                        icon="🎓",
                        related_entity_id=enrollment['id'],
                        metadata={
                            'course_name': course.get('name'),
                            'course_code': course.get('code'),
                            'grade': enrollment.get('final_grade')
                        }
                    ))

        except Exception as e:
            logger.error(f"Error fetching enrollment activities: {e}")

        return activities
