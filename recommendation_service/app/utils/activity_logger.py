"""
Activity Logger Utility
Provides functions to log user activities and system events to the activity_log table
"""
from typing import Optional, Dict, Any
from datetime import datetime
import logging
from uuid import UUID

from app.database.config import get_supabase

logger = logging.getLogger(__name__)


class ActivityType:
    """Constants for activity types"""
    # User Management
    USER_REGISTRATION = "user_registration"
    USER_LOGIN = "user_login"
    USER_LOGOUT = "user_logout"
    USER_PASSWORD_CHANGED = "user_password_changed"
    USER_PROFILE_UPDATED = "user_profile_updated"
    USER_ROLE_CHANGED = "user_role_changed"
    USER_DELETED = "user_deleted"

    # Application Management
    APPLICATION_SUBMITTED = "application_submitted"
    APPLICATION_UPDATED = "application_updated"
    APPLICATION_STATUS_CHANGED = "application_status_changed"
    APPLICATION_WITHDRAWN = "application_withdrawn"
    APPLICATION_DELETED = "application_deleted"

    # Program Management
    PROGRAM_CREATED = "program_created"
    PROGRAM_UPDATED = "program_updated"
    PROGRAM_DELETED = "program_deleted"

    # University Management
    UNIVERSITY_CREATED = "university_created"
    UNIVERSITY_UPDATED = "university_updated"
    UNIVERSITY_DELETED = "university_deleted"

    # Course Management
    COURSE_CREATED = "course_created"
    COURSE_UPDATED = "course_updated"
    COURSE_DELETED = "course_deleted"
    ENROLLMENT_CREATED = "enrollment_created"
    ENROLLMENT_UPDATED = "enrollment_updated"

    # Messaging
    MESSAGE_SENT = "message_sent"
    MESSAGE_RECEIVED = "message_received"

    # Counseling
    COUNSELING_SESSION_SCHEDULED = "counseling_session_scheduled"
    COUNSELING_SESSION_COMPLETED = "counseling_session_completed"
    COUNSELING_SESSION_CANCELLED = "counseling_session_cancelled"

    # Meeting Management
    MEETING_REQUESTED = "meeting_requested"
    MEETING_APPROVED = "meeting_approved"
    MEETING_DECLINED = "meeting_declined"
    MEETING_CANCELLED = "meeting_cancelled"
    MEETING_COMPLETED = "meeting_completed"
    MEETING_RESCHEDULED = "meeting_rescheduled"

    # System Events
    SYSTEM_ERROR = "system_error"
    SYSTEM_MAINTENANCE = "system_maintenance"
    SYSTEM_BACKUP = "system_backup"
    DATA_IMPORT = "data_import"
    DATA_EXPORT = "data_export"


async def log_activity(
    action_type: str,
    description: str,
    user_id: Optional[str] = None,
    user_name: Optional[str] = None,
    user_email: Optional[str] = None,
    user_role: Optional[str] = None,
    metadata: Optional[Dict[str, Any]] = None,
    ip_address: Optional[str] = None,
    user_agent: Optional[str] = None
) -> Optional[Dict[str, Any]]:
    """
    Log an activity to the activity_log table

    Args:
        action_type: Type of action (use ActivityType constants)
        description: Human-readable description of the activity
        user_id: Optional user ID who performed the action
        user_name: Optional user name for display
        user_email: Optional user email for display
        user_role: Optional user role at the time of action
        metadata: Optional additional structured data
        ip_address: Optional IP address
        user_agent: Optional user agent string

    Returns:
        Inserted activity log record or None if failed
    """
    try:
        db = get_supabase()

        activity_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "action_type": action_type,
            "description": description,
            "metadata": metadata or {}
        }

        # Add optional fields if provided
        if user_id:
            activity_data["user_id"] = user_id
        if user_name:
            activity_data["user_name"] = user_name
        if user_email:
            activity_data["user_email"] = user_email
        if user_role:
            activity_data["user_role"] = user_role
        if ip_address:
            activity_data["ip_address"] = ip_address
        if user_agent:
            activity_data["user_agent"] = user_agent

        response = db.table('activity_log').insert(activity_data).execute()

        if response.data:
            logger.debug(f"Activity logged: {action_type} - {description}")
            return response.data[0]
        else:
            logger.warning(f"Failed to log activity: {action_type}")
            return None

    except Exception as e:
        # Don't fail the main operation if activity logging fails
        logger.error(f"Error logging activity: {e}", exc_info=True)
        return None


def log_activity_sync(
    action_type: str,
    description: str,
    user_id: Optional[str] = None,
    user_name: Optional[str] = None,
    user_email: Optional[str] = None,
    user_role: Optional[str] = None,
    metadata: Optional[Dict[str, Any]] = None,
    ip_address: Optional[str] = None,
    user_agent: Optional[str] = None
) -> Optional[Dict[str, Any]]:
    """
    Synchronous version of log_activity for use in non-async contexts

    Args: Same as log_activity

    Returns:
        Inserted activity log record or None if failed
    """
    try:
        db = get_supabase()

        activity_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "action_type": action_type,
            "description": description,
            "metadata": metadata or {}
        }

        # Add optional fields if provided
        if user_id:
            activity_data["user_id"] = user_id
        if user_name:
            activity_data["user_name"] = user_name
        if user_email:
            activity_data["user_email"] = user_email
        if user_role:
            activity_data["user_role"] = user_role
        if ip_address:
            activity_data["ip_address"] = ip_address
        if user_agent:
            activity_data["user_agent"] = user_agent

        response = db.table('activity_log').insert(activity_data).execute()

        if response.data:
            logger.debug(f"Activity logged: {action_type} - {description}")
            return response.data[0]
        else:
            logger.warning(f"Failed to log activity: {action_type}")
            return None

    except Exception as e:
        # Don't fail the main operation if activity logging fails
        logger.error(f"Error logging activity: {e}", exc_info=True)
        return None


async def get_recent_activities(
    limit: int = 10,
    user_id: Optional[str] = None,
    action_types: Optional[list] = None,
    start_date: Optional[datetime] = None,
    end_date: Optional[datetime] = None
) -> list:
    """
    Get recent activities from the activity log

    Args:
        limit: Maximum number of activities to return
        user_id: Optional filter by user ID
        action_types: Optional filter by action types
        start_date: Optional filter by start date
        end_date: Optional filter by end date

    Returns:
        List of activity log records
    """
    try:
        db = get_supabase()

        query = db.table('activity_log').select('*')

        # Apply filters
        if user_id:
            query = query.eq('user_id', user_id)

        if action_types:
            query = query.in_('action_type', action_types)

        if start_date:
            query = query.gte('timestamp', start_date.isoformat())

        if end_date:
            query = query.lte('timestamp', end_date.isoformat())

        # Order by timestamp descending and limit
        query = query.order('timestamp', desc=True).limit(limit)

        response = query.execute()

        return response.data if response.data else []

    except Exception as e:
        logger.error(f"Error fetching recent activities: {e}", exc_info=True)
        return []


async def get_user_activity_summary(
    user_id: str,
    days: int = 30
) -> Dict[str, Any]:
    """
    Get activity summary for a user over the last N days

    Args:
        user_id: User ID
        days: Number of days to look back

    Returns:
        Dictionary with activity statistics
    """
    try:
        db = get_supabase()

        start_date = datetime.utcnow() - timedelta(days=days)

        response = db.table('activity_log').select('action_type').eq(
            'user_id', user_id
        ).gte('timestamp', start_date.isoformat()).execute()

        if not response.data:
            return {
                "user_id": user_id,
                "days": days,
                "total_activities": 0,
                "activity_breakdown": {}
            }

        # Count activities by type
        activity_counts = {}
        for activity in response.data:
            action_type = activity['action_type']
            activity_counts[action_type] = activity_counts.get(action_type, 0) + 1

        return {
            "user_id": user_id,
            "days": days,
            "total_activities": len(response.data),
            "activity_breakdown": activity_counts
        }

    except Exception as e:
        logger.error(f"Error getting user activity summary: {e}", exc_info=True)
        return {
            "user_id": user_id,
            "days": days,
            "total_activities": 0,
            "activity_breakdown": {},
            "error": str(e)
        }


from datetime import timedelta
