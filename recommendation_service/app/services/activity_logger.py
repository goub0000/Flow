"""
Activity Logger Service
Handles automatic creation of activity records when events occur
"""
import logging
from datetime import datetime
from typing import Optional, Dict, Any
from uuid import uuid4

from supabase import Client

from app.schemas.activity import StudentActivityType

logger = logging.getLogger(__name__)


class ActivityLogger:
    """Service for logging student activities automatically"""

    def __init__(self, db: Client):
        self.db = db

    def _create_activity(
        self,
        student_id: str,
        activity_type: StudentActivityType,
        title: str,
        description: str,
        icon: str,
        related_entity_id: Optional[str] = None,
        metadata: Optional[Dict[str, Any]] = None,
    ) -> bool:
        """
        Create an activity record in the database

        Args:
            student_id: ID of the student
            activity_type: Type of activity
            title: Activity title
            description: Activity description
            icon: Icon emoji for the activity
            related_entity_id: ID of related entity (optional)
            metadata: Additional metadata (optional)

        Returns:
            True if successful, False otherwise
        """
        try:
            activity_data = {
                'id': str(uuid4()),
                'student_id': student_id,
                'activity_type': activity_type.value,
                'title': title,
                'description': description,
                'icon': icon,
                'related_entity_id': related_entity_id,
                'metadata': metadata or {},
                'timestamp': datetime.utcnow().isoformat(),
                'created_at': datetime.utcnow().isoformat(),
            }

            result = self.db.table('student_activities').insert(activity_data).execute()

            if result.data:
                logger.info(f"Created activity: {activity_type.value} for student {student_id}")
                return True
            else:
                logger.error(f"Failed to create activity: {activity_type.value}")
                return False

        except Exception as e:
            logger.error(f"Error creating activity: {e}")
            return False

    # ==================== Application Events ====================

    def log_application_submitted(
        self,
        student_id: str,
        application_id: str,
        institution_name: str,
        program_name: Optional[str] = None,
    ) -> bool:
        """Log when a student submits an application"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.APPLICATION_SUBMITTED,
            title="Application Submitted",
            description=f"You submitted an application to {institution_name}",
            icon="📝",
            related_entity_id=application_id,
            metadata={
                'institution_name': institution_name,
                'program_name': program_name,
            },
        )

    def log_application_status_changed(
        self,
        student_id: str,
        application_id: str,
        institution_name: str,
        new_status: str,
        previous_status: Optional[str] = None,
        program_name: Optional[str] = None,
    ) -> bool:
        """Log when an application status changes"""
        status_icons = {
            'accepted': '🎉',
            'rejected': '📋',
            'waitlisted': '⏳',
            'under_review': '👀',
            'pending': '⏰',
        }

        status_titles = {
            'accepted': 'Application Accepted',
            'rejected': 'Application Status Update',
            'waitlisted': 'Added to Waitlist',
            'under_review': 'Application Under Review',
            'pending': 'Application Pending',
        }

        icon = status_icons.get(new_status.lower(), '📄')
        title = status_titles.get(new_status.lower(), 'Application Updated')

        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.APPLICATION_STATUS_CHANGED,
            title=title,
            description=f"Your application to {institution_name} was {new_status}",
            icon=icon,
            related_entity_id=application_id,
            metadata={
                'institution_name': institution_name,
                'program_name': program_name,
                'status': new_status,
                'previous_status': previous_status,
            },
        )

    # ==================== Achievement Events ====================

    def log_achievement_earned(
        self,
        student_id: str,
        achievement_id: str,
        achievement_name: str,
        achievement_description: str,
        points: int = 0,
        category: Optional[str] = None,
    ) -> bool:
        """Log when a student earns an achievement"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.ACHIEVEMENT_EARNED,
            title=f"Achievement Unlocked: {achievement_name}",
            description=achievement_description,
            icon="🏆",
            related_entity_id=achievement_id,
            metadata={
                'achievement_name': achievement_name,
                'points': points,
                'category': category,
            },
        )

    # ==================== Meeting Events ====================

    def log_meeting_scheduled(
        self,
        student_id: str,
        meeting_id: str,
        staff_name: str,
        scheduled_date: str,
        subject: Optional[str] = None,
        meeting_mode: Optional[str] = None,
    ) -> bool:
        """Log when a meeting is scheduled"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.MEETING_SCHEDULED,
            title="Meeting Scheduled",
            description=f"Meeting with {staff_name} scheduled for {scheduled_date}",
            icon="📅",
            related_entity_id=meeting_id,
            metadata={
                'staff_name': staff_name,
                'scheduled_date': scheduled_date,
                'subject': subject,
                'meeting_mode': meeting_mode,
            },
        )

    def log_meeting_completed(
        self,
        student_id: str,
        meeting_id: str,
        staff_name: str,
        subject: Optional[str] = None,
        notes: Optional[str] = None,
    ) -> bool:
        """Log when a meeting is completed"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.MEETING_COMPLETED,
            title="Meeting Completed",
            description=f"Completed meeting with {staff_name}",
            icon="✅",
            related_entity_id=meeting_id,
            metadata={
                'staff_name': staff_name,
                'subject': subject,
                'notes': notes,
            },
        )

    # ==================== Message Events ====================

    def log_message_received(
        self,
        student_id: str,
        message_id: str,
        sender_name: str,
        subject: str,
    ) -> bool:
        """Log when a student receives a message"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.MESSAGE_RECEIVED,
            title=f"New Message from {sender_name}",
            description=subject,
            icon="💬",
            related_entity_id=message_id,
            metadata={
                'sender_name': sender_name,
                'subject': subject,
                'is_read': False,
            },
        )

    # ==================== Course/Enrollment Events ====================

    def log_course_completed(
        self,
        student_id: str,
        enrollment_id: str,
        course_name: str,
        course_code: Optional[str] = None,
        grade: Optional[str] = None,
    ) -> bool:
        """Log when a student completes a course"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.COURSE_COMPLETED,
            title="Course Completed",
            description=f"Completed {course_name}",
            icon="🎓",
            related_entity_id=enrollment_id,
            metadata={
                'course_name': course_name,
                'course_code': course_code,
                'grade': grade,
            },
        )

    # ==================== Payment Events ====================

    def log_payment_made(
        self,
        student_id: str,
        payment_id: str,
        amount: float,
        description: str,
        payment_type: Optional[str] = None,
    ) -> bool:
        """Log when a student makes a payment"""
        return self._create_activity(
            student_id=student_id,
            activity_type=StudentActivityType.PAYMENT_MADE,
            title="Payment Processed",
            description=description,
            icon="💳",
            related_entity_id=payment_id,
            metadata={
                'amount': amount,
                'payment_type': payment_type,
            },
        )


# Helper function to get activity logger instance
def get_activity_logger(db: Client) -> ActivityLogger:
    """Get an ActivityLogger instance"""
    return ActivityLogger(db)
