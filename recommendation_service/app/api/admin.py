"""
Admin/Management API Endpoints
Includes data enrichment and other administrative tasks
"""
from fastapi import APIRouter, BackgroundTasks, HTTPException, Depends, Query
from pydantic import BaseModel
from typing import Optional, List
import logging
from datetime import datetime, timedelta

from app.database.config import get_supabase
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.enrichment.web_search_enricher import WebSearchEnricher
from app.enrichment.field_scrapers import FieldSpecificScrapers
from app.utils.security import get_current_user, CurrentUser, require_admin
from app.utils.activity_logger import get_recent_activities, ActivityType
from app.schemas.activity import (
    RecentActivityResponse,
    ActivityLogResponse,
    ActivityFilterRequest,
    ActivityStatsResponse
)

router = APIRouter()
logger = logging.getLogger(__name__)

# Global variable to track enrichment status
enrichment_status = {
    "running": False,
    "start_time": None,
    "progress": 0,
    "total": 0,
    "fields_filled": 0,
    "errors": 0
}


class EnrichmentRequest(BaseModel):
    limit: Optional[int] = None
    priority_high_only: bool = False
    rate_limit_delay: float = 3.0


def run_enrichment_task(limit: Optional[int], priority_high_only: bool, rate_limit_delay: float):
    """Background task to run data enrichment"""
    global enrichment_status

    try:
        enrichment_status["running"] = True
        enrichment_status["start_time"] = datetime.utcnow()
        enrichment_status["progress"] = 0
        enrichment_status["total"] = 0
        enrichment_status["fields_filled"] = 0
        enrichment_status["errors"] = 0

        logger.info(f"Starting data enrichment (limit={limit}, priority_high={priority_high_only})")

        db = get_supabase()
        orchestrator = AutoFillOrchestrator(db, rate_limit_delay=rate_limit_delay)

        # Determine priority fields
        priority_fields = None
        if priority_high_only:
            priority_fields = [
                'acceptance_rate', 'gpa_average', 'graduation_rate_4year',
                'total_students', 'tuition_out_state', 'total_cost'
            ]

        # Run enrichment
        stats = orchestrator.run_enrichment(
            limit=limit,
            priority_fields=priority_fields,
            dry_run=False
        )

        # Update status
        enrichment_status["progress"] = stats["total_processed"]
        enrichment_status["total"] = stats["total_processed"]
        enrichment_status["fields_filled"] = sum(stats["fields_filled"].values())
        enrichment_status["errors"] = stats["errors"]
        enrichment_status["running"] = False

        logger.info(f"Enrichment complete: {stats['total_processed']} universities processed")

    except Exception as e:
        logger.error(f"Enrichment failed: {e}", exc_info=True)
        enrichment_status["running"] = False
        enrichment_status["errors"] += 1


@router.post("/admin/enrich/start")
async def start_enrichment(
    request: EnrichmentRequest,
    background_tasks: BackgroundTasks
):
    """
    Start data enrichment process in the background

    This endpoint triggers the web scraping enrichment process that fills
    NULL values in the university database.

    - **limit**: Maximum number of universities to process (None = all)
    - **priority_high_only**: Only fill high-priority fields (acceptance_rate, costs, etc.)
    - **rate_limit_delay**: Delay between web requests in seconds (default: 3.0)

    Returns immediately while enrichment runs in background.
    Use /admin/enrich/status to check progress.
    """
    global enrichment_status

    if enrichment_status["running"]:
        raise HTTPException(
            status_code=409,
            detail="Enrichment process is already running"
        )

    # Start enrichment in background
    background_tasks.add_task(
        run_enrichment_task,
        request.limit,
        request.priority_high_only,
        request.rate_limit_delay
    )

    return {
        "message": "Data enrichment started",
        "limit": request.limit,
        "priority_high_only": request.priority_high_only,
        "rate_limit_delay": request.rate_limit_delay
    }


@router.get("/admin/enrich/status")
async def get_enrichment_status():
    """
    Get current status of data enrichment process

    Returns:
    - running: Whether enrichment is currently running
    - start_time: When the current/last enrichment started
    - progress: Number of universities processed
    - total: Total universities to process
    - fields_filled: Total fields filled so far
    - errors: Number of errors encountered
    """
    return enrichment_status


@router.post("/admin/enrich/analyze")
async def analyze_null_values():
    """
    Analyze NULL values in the database

    Returns statistics about NULL values per field, including:
    - null_count: Number of NULL values
    - percentage: Percentage of records with NULL
    - priority: Field priority (1=HIGH, 2=MEDIUM, 3=LOW)
    """
    try:
        db = get_supabase()
        orchestrator = AutoFillOrchestrator(db)

        analysis = orchestrator.analyze_null_values()

        # Sort by null count (descending)
        sorted_analysis = dict(sorted(
            analysis.items(),
            key=lambda x: x[1]['null_count'],
            reverse=True
        ))

        total_nulls = sum(s['null_count'] for s in analysis.values())
        high_priority_nulls = sum(
            s['null_count'] for s in analysis.values() if s['priority'] == 1
        )

        return {
            "fields": sorted_analysis,
            "summary": {
                "total_null_values": total_nulls,
                "high_priority_nulls": high_priority_nulls
            }
        }

    except Exception as e:
        logger.error(f"Analysis failed: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))


# ==================== ADMIN DASHBOARD ACTIVITY FEED ====================

@router.get("/admin/dashboard/recent-activity")
async def get_recent_activity(
    limit: int = Query(default=10, ge=1, le=100, description="Maximum number of activities to return"),
    user_id: Optional[str] = Query(default=None, description="Filter by user ID"),
    action_type: Optional[str] = Query(default=None, description="Filter by action type"),
    current_user: CurrentUser = Depends(require_admin)
) -> RecentActivityResponse:
    """
    Get recent activities for admin dashboard

    **Admin Only** - Retrieves the latest activities from the audit log.

    **Query Parameters:**
    - limit: Maximum number of activities to return (1-100, default: 10)
    - user_id: Optional filter by user ID
    - action_type: Optional filter by action type

    **Returns:**
    - activities: List of recent activity log entries
    - total_count: Total number of activities matching filters
    - limit: The limit applied
    - has_more: Whether there are more activities beyond the limit

    **Tracked Event Types:**
    - User registrations (new students, parents, counselors, institutions)
    - User logins/logouts
    - Application submissions and status changes
    - Program/course creation and updates
    - System events

    **Example Response:**
    ```json
    {
      "activities": [
        {
          "id": "uuid",
          "timestamp": "2025-01-17T10:30:00Z",
          "user_name": "John Doe",
          "user_role": "student",
          "action_type": "application_submitted",
          "description": "Submitted application to Harvard University",
          "metadata": {"university_id": "123", "program_id": "456"}
        }
      ],
      "total_count": 150,
      "limit": 10,
      "has_more": true
    }
    ```
    """
    try:
        db = get_supabase()

        # Build query
        query = db.table('activity_log').select('*', count='exact')

        # Apply filters
        if user_id:
            query = query.eq('user_id', user_id)

        if action_type:
            query = query.eq('action_type', action_type)

        # Get total count (before limit)
        count_response = query.execute()
        total_count = count_response.count if count_response.count else 0

        # Apply limit and ordering
        query = query.order('timestamp', desc=True).limit(limit)

        response = query.execute()

        activities = []
        if response.data:
            for activity in response.data:
                activities.append(ActivityLogResponse(
                    id=activity['id'],
                    timestamp=activity['timestamp'],
                    user_id=activity.get('user_id'),
                    user_name=activity.get('user_name'),
                    user_email=activity.get('user_email'),
                    user_role=activity.get('user_role'),
                    action_type=activity['action_type'],
                    description=activity['description'],
                    metadata=activity.get('metadata', {}),
                    ip_address=activity.get('ip_address'),
                    user_agent=activity.get('user_agent'),
                    created_at=activity['created_at']
                ))

        return RecentActivityResponse(
            activities=activities,
            total_count=total_count,
            limit=limit,
            has_more=total_count > limit
        )

    except Exception as e:
        logger.error(f"Error fetching recent activities: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch recent activities: {str(e)}"
        )


@router.get("/admin/dashboard/activity-stats")
async def get_activity_stats(
    current_user: CurrentUser = Depends(require_admin)
) -> ActivityStatsResponse:
    """
    Get activity statistics for admin dashboard

    **Admin Only** - Returns aggregated statistics about user activities.

    **Returns:**
    - total_activities: Total number of activities in the log
    - activities_today: Number of activities today
    - activities_this_week: Number of activities this week
    - activities_this_month: Number of activities this month
    - top_action_types: Most common action types with counts
    - top_users: Most active users
    - recent_registrations: Number of recent user registrations
    - recent_logins: Number of recent logins
    - recent_applications: Number of recent application submissions
    """
    try:
        db = get_supabase()

        # Get current time boundaries
        now = datetime.utcnow()
        today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
        week_start = today_start - timedelta(days=today_start.weekday())
        month_start = today_start.replace(day=1)

        # Total activities
        total_response = db.table('activity_log').select('id', count='exact').execute()
        total_activities = total_response.count if total_response.count else 0

        # Activities today
        today_response = db.table('activity_log').select('id', count='exact').gte(
            'timestamp', today_start.isoformat()
        ).execute()
        activities_today = today_response.count if today_response.count else 0

        # Activities this week
        week_response = db.table('activity_log').select('id', count='exact').gte(
            'timestamp', week_start.isoformat()
        ).execute()
        activities_this_week = week_response.count if week_response.count else 0

        # Activities this month
        month_response = db.table('activity_log').select('id', count='exact').gte(
            'timestamp', month_start.isoformat()
        ).execute()
        activities_this_month = month_response.count if month_response.count else 0

        # Top action types (last 30 days)
        thirty_days_ago = now - timedelta(days=30)
        action_types_response = db.table('activity_log').select('action_type').gte(
            'timestamp', thirty_days_ago.isoformat()
        ).execute()

        top_action_types = {}
        if action_types_response.data:
            for activity in action_types_response.data:
                action_type = activity['action_type']
                top_action_types[action_type] = top_action_types.get(action_type, 0) + 1

        # Sort and get top 10
        top_action_types = dict(sorted(
            top_action_types.items(),
            key=lambda x: x[1],
            reverse=True
        )[:10])

        # Top users (last 30 days)
        users_response = db.table('activity_log').select(
            'user_id, user_name, user_email'
        ).gte(
            'timestamp', thirty_days_ago.isoformat()
        ).not_.is_('user_id', 'null').execute()

        user_activity_counts = {}
        if users_response.data:
            for activity in users_response.data:
                user_id = activity['user_id']
                if user_id not in user_activity_counts:
                    user_activity_counts[user_id] = {
                        'user_id': user_id,
                        'user_name': activity.get('user_name', 'Unknown'),
                        'user_email': activity.get('user_email', 'Unknown'),
                        'activity_count': 0
                    }
                user_activity_counts[user_id]['activity_count'] += 1

        top_users = sorted(
            user_activity_counts.values(),
            key=lambda x: x['activity_count'],
            reverse=True
        )[:10]

        # Recent registrations (last 7 days)
        seven_days_ago = now - timedelta(days=7)
        registrations_response = db.table('activity_log').select('id', count='exact').eq(
            'action_type', ActivityType.USER_REGISTRATION
        ).gte('timestamp', seven_days_ago.isoformat()).execute()
        recent_registrations = registrations_response.count if registrations_response.count else 0

        # Recent logins (last 24 hours)
        logins_response = db.table('activity_log').select('id', count='exact').eq(
            'action_type', ActivityType.USER_LOGIN
        ).gte('timestamp', today_start.isoformat()).execute()
        recent_logins = logins_response.count if logins_response.count else 0

        # Recent applications (last 7 days)
        applications_response = db.table('activity_log').select('id', count='exact').eq(
            'action_type', ActivityType.APPLICATION_SUBMITTED
        ).gte('timestamp', seven_days_ago.isoformat()).execute()
        recent_applications = applications_response.count if applications_response.count else 0

        return ActivityStatsResponse(
            total_activities=total_activities,
            activities_today=activities_today,
            activities_this_week=activities_this_week,
            activities_this_month=activities_this_month,
            top_action_types=top_action_types,
            top_users=top_users,
            recent_registrations=recent_registrations,
            recent_logins=recent_logins,
            recent_applications=recent_applications
        )

    except Exception as e:
        logger.error(f"Error fetching activity stats: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch activity statistics: {str(e)}"
        )


@router.get("/admin/dashboard/user-activity/{user_id}")
async def get_user_activity(
    user_id: str,
    limit: int = Query(default=20, ge=1, le=100),
    current_user: CurrentUser = Depends(require_admin)
) -> List[ActivityLogResponse]:
    """
    Get activity history for a specific user

    **Admin Only** - Retrieves all activities for a specific user.

    **Path Parameters:**
    - user_id: The user's ID

    **Query Parameters:**
    - limit: Maximum number of activities to return (1-100, default: 20)

    **Returns:**
    - List of activity log entries for the user
    """
    try:
        db = get_supabase()

        response = db.table('activity_log').select('*').eq(
            'user_id', user_id
        ).order('timestamp', desc=True).limit(limit).execute()

        activities = []
        if response.data:
            for activity in response.data:
                activities.append(ActivityLogResponse(
                    id=activity['id'],
                    timestamp=activity['timestamp'],
                    user_id=activity.get('user_id'),
                    user_name=activity.get('user_name'),
                    user_email=activity.get('user_email'),
                    user_role=activity.get('user_role'),
                    action_type=activity['action_type'],
                    description=activity['description'],
                    metadata=activity.get('metadata', {}),
                    ip_address=activity.get('ip_address'),
                    user_agent=activity.get('user_agent'),
                    created_at=activity['created_at']
                ))

        return activities

    except Exception as e:
        logger.error(f"Error fetching user activity: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch user activity: {str(e)}"
        )
