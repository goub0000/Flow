"""
Admin/Management API Endpoints
Includes data enrichment and other administrative tasks
"""
from fastapi import APIRouter, BackgroundTasks, HTTPException, Depends, Query
from pydantic import BaseModel
from typing import Optional, List, Dict
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


@router.delete("/admin/data/courses")
async def clear_all_courses(
    confirm: bool = Query(False, description="Set to true to confirm deletion"),
    current_user: CurrentUser = Depends(require_admin)
) -> Dict:
    """
    Clear all courses from the database (Admin only)

    This is a destructive operation - use with caution!

    **Query Parameters:**
    - confirm: Must be set to true to confirm deletion

    **Returns:**
    - deleted_count: Number of courses deleted
    - message: Success message
    """
    if not confirm:
        raise HTTPException(
            status_code=400,
            detail="Please set confirm=true to delete all courses"
        )

    try:
        db = get_supabase()

        # Get count before deletion
        count_response = db.table('courses').select('id', count='exact').execute()
        count = count_response.count or 0

        if count == 0:
            return {"deleted_count": 0, "message": "No courses to delete"}

        # Delete all courses
        db.table('courses').delete().neq('id', 'impossible-id-that-wont-match').execute()

        logger.info(f"Admin {current_user.id} deleted all {count} courses")

        return {
            "deleted_count": count,
            "message": f"Successfully deleted {count} courses"
        }

    except Exception as e:
        logger.error(f"Error clearing courses: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to clear courses: {str(e)}"
        )


@router.get("/admin/data/courses/count")
async def get_courses_count(
    current_user: CurrentUser = Depends(require_admin)
) -> Dict:
    """
    Get count of courses in the database (Admin only)

    **Returns:**
    - count: Total number of courses
    - by_status: Breakdown by status (draft, published, archived)
    """
    try:
        db = get_supabase()

        # Get total count
        total_response = db.table('courses').select('id', count='exact').execute()
        total = total_response.count or 0

        # Get breakdown by status
        all_courses = db.table('courses').select('status').execute()

        by_status = {"draft": 0, "published": 0, "archived": 0}
        if all_courses.data:
            for course in all_courses.data:
                status = course.get('status', 'draft')
                by_status[status] = by_status.get(status, 0) + 1

        return {
            "count": total,
            "by_status": by_status
        }

    except Exception as e:
        logger.error(f"Error getting courses count: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to get courses count: {str(e)}"
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


# ==================== ADMIN DASHBOARD ANALYTICS ====================

class DataPoint(BaseModel):
    """Single data point for charts"""
    label: str  # Month name, role name, etc.
    value: float  # The numeric value
    date: Optional[datetime] = None  # Optional date for time-series


class UserGrowthResponse(BaseModel):
    """User growth analytics response"""
    data_points: List[DataPoint]
    total_users: int
    growth_rate: float  # Percentage growth from previous period
    period: str  # "6_months", "1_year", etc.
    comparison_period_users: int  # Users in previous period
    average_per_period: float  # Average users per month/week


class RoleDistributionResponse(BaseModel):
    """Role distribution analytics response"""
    distributions: List[DataPoint]
    total_users: int
    most_common_role: str
    role_percentages: Dict[str, float]


class EnhancedMetricsResponse(BaseModel):
    """Enhanced metrics with comparisons"""
    active_users_30days: int
    active_users_30days_previous: int
    active_users_change_percent: float

    new_registrations_7days: int
    new_registrations_7days_previous: int
    registrations_change_percent: float

    applications_7days: int
    applications_7days_previous: int
    applications_change_percent: float

    total_users: int
    total_students: int
    total_institutions: int
    total_parents: int
    total_counselors: int


@router.get("/admin/dashboard/analytics/user-growth")
async def get_user_growth_analytics(
    period: str = Query(default="6_months", description="Time period: 6_months, 1_year, 3_months"),
    current_user: CurrentUser = Depends(require_admin)
) -> UserGrowthResponse:
    """
    Get user growth analytics over time

    **Admin Only** - Returns time-series data of user registrations.

    **Query Parameters:**
    - period: Time period to analyze (6_months, 1_year, 3_months)

    **Returns:**
    - data_points: Array of {label, value, date} for chart visualization
    - total_users: Total number of users
    - growth_rate: Percentage growth from previous period
    - comparison_period_users: Number of users in comparison period
    - average_per_period: Average users registered per month
    """
    try:
        db = get_supabase()
        now = datetime.utcnow()

        # Determine time range
        if period == "1_year":
            months_back = 12
            comparison_months_back = 24
        elif period == "3_months":
            months_back = 3
            comparison_months_back = 6
        else:  # default 6_months
            months_back = 6
            comparison_months_back = 12

        start_date = now - timedelta(days=months_back * 30)
        comparison_start_date = now - timedelta(days=comparison_months_back * 30)
        comparison_end_date = start_date

        # Get all users with registration dates
        response = db.table('users').select('id, created_at, role').order('created_at').execute()

        if not response.data:
            return UserGrowthResponse(
                data_points=[],
                total_users=0,
                growth_rate=0.0,
                period=period,
                comparison_period_users=0,
                average_per_period=0.0
            )

        # Aggregate by month
        month_counts = {}
        total_users = len(response.data)
        current_period_users = 0
        comparison_period_users = 0

        for user in response.data:
            created_at = datetime.fromisoformat(user['created_at'].replace('Z', '+00:00'))

            # Count for current period
            if created_at >= start_date:
                current_period_users += 1
                # Group by month
                month_key = created_at.strftime('%Y-%m')
                month_label = created_at.strftime('%b')  # Jan, Feb, etc.

                if month_key not in month_counts:
                    month_counts[month_key] = {
                        'label': month_label,
                        'value': 0,
                        'date': created_at.replace(day=1, hour=0, minute=0, second=0, microsecond=0)
                    }
                month_counts[month_key]['value'] += 1

            # Count for comparison period
            if comparison_start_date <= created_at < comparison_end_date:
                comparison_period_users += 1

        # Convert to list and sort by date
        data_points_raw = sorted(month_counts.values(), key=lambda x: x['date'])

        # Calculate cumulative values for better visualization
        cumulative = 0
        data_points = []
        for point in data_points_raw:
            cumulative += point['value']
            data_points.append(DataPoint(
                label=point['label'],
                value=cumulative,  # Cumulative total
                date=point['date']
            ))

        # Calculate growth rate
        if comparison_period_users > 0:
            growth_rate = ((current_period_users - comparison_period_users) / comparison_period_users) * 100
        else:
            growth_rate = 100.0 if current_period_users > 0 else 0.0

        # Average per month
        average_per_period = current_period_users / months_back if months_back > 0 else 0.0

        return UserGrowthResponse(
            data_points=data_points,
            total_users=total_users,
            growth_rate=round(growth_rate, 2),
            period=period,
            comparison_period_users=comparison_period_users,
            average_per_period=round(average_per_period, 2)
        )

    except Exception as e:
        logger.error(f"Error fetching user growth analytics: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch user growth analytics: {str(e)}"
        )


@router.get("/admin/dashboard/analytics/role-distribution")
async def get_role_distribution_analytics(
    current_user: CurrentUser = Depends(require_admin)
) -> RoleDistributionResponse:
    """
    Get user role distribution analytics

    **Admin Only** - Returns breakdown of users by role.

    **Returns:**
    - distributions: Array of {label, value} for pie chart
    - total_users: Total number of users
    - most_common_role: Role with most users
    - role_percentages: Percentage breakdown by role
    """
    try:
        db = get_supabase()

        # Get all users with roles
        response = db.table('users').select('role').execute()

        if not response.data:
            return RoleDistributionResponse(
                distributions=[],
                total_users=0,
                most_common_role="none",
                role_percentages={}
            )

        # Count by role
        role_counts = {}
        total_users = len(response.data)

        for user in response.data:
            role = user.get('role', 'unknown')
            role_counts[role] = role_counts.get(role, 0) + 1

        # Convert to data points
        distributions = []
        role_percentages = {}

        for role, count in role_counts.items():
            percentage = (count / total_users) * 100 if total_users > 0 else 0
            role_percentages[role] = round(percentage, 2)

            distributions.append(DataPoint(
                label=role.capitalize(),
                value=count
            ))

        # Find most common role
        most_common_role = max(role_counts.items(), key=lambda x: x[1])[0] if role_counts else "none"

        # Sort by count descending
        distributions.sort(key=lambda x: x.value, reverse=True)

        return RoleDistributionResponse(
            distributions=distributions,
            total_users=total_users,
            most_common_role=most_common_role,
            role_percentages=role_percentages
        )

    except Exception as e:
        logger.error(f"Error fetching role distribution analytics: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch role distribution analytics: {str(e)}"
        )


@router.get("/admin/dashboard/analytics/metrics")
async def get_enhanced_metrics(
    current_user: CurrentUser = Depends(require_admin)
) -> EnhancedMetricsResponse:
    """
    Get enhanced user activity metrics with period comparisons

    **Admin Only** - Returns key metrics with comparison to previous periods.

    **Returns:**
    - Active users in last 30 days (with comparison to previous 30 days)
    - New registrations in last 7 days (with comparison to previous 7 days)
    - Applications in last 7 days (with comparison to previous 7 days)
    - Total user counts by role
    - Percentage changes for all metrics
    """
    try:
        db = get_supabase()
        now = datetime.utcnow()

        # Time boundaries
        days_30_ago = now - timedelta(days=30)
        days_60_ago = now - timedelta(days=60)
        days_7_ago = now - timedelta(days=7)
        days_14_ago = now - timedelta(days=14)

        # Active users (last 30 days) - users who logged in
        active_30_response = db.table('activity_log').select('user_id', count='exact').eq(
            'action_type', ActivityType.USER_LOGIN
        ).gte('timestamp', days_30_ago.isoformat()).execute()

        # Unique active users
        active_users_30days = len(set([a['user_id'] for a in active_30_response.data if a.get('user_id')])) if active_30_response.data else 0

        # Active users (previous 30 days)
        active_60_response = db.table('activity_log').select('user_id').eq(
            'action_type', ActivityType.USER_LOGIN
        ).gte('timestamp', days_60_ago.isoformat()).lt('timestamp', days_30_ago.isoformat()).execute()

        active_users_30days_previous = len(set([a['user_id'] for a in active_60_response.data if a.get('user_id')])) if active_60_response.data else 0

        # Calculate change percent
        if active_users_30days_previous > 0:
            active_users_change_percent = ((active_users_30days - active_users_30days_previous) / active_users_30days_previous) * 100
        else:
            active_users_change_percent = 100.0 if active_users_30days > 0 else 0.0

        # New registrations (last 7 days)
        reg_7_response = db.table('users').select('id', count='exact').gte(
            'created_at', days_7_ago.isoformat()
        ).execute()
        new_registrations_7days = reg_7_response.count if reg_7_response.count else 0

        # New registrations (previous 7 days)
        reg_14_response = db.table('users').select('id', count='exact').gte(
            'created_at', days_14_ago.isoformat()
        ).lt('created_at', days_7_ago.isoformat()).execute()
        new_registrations_7days_previous = reg_14_response.count if reg_14_response.count else 0

        if new_registrations_7days_previous > 0:
            registrations_change_percent = ((new_registrations_7days - new_registrations_7days_previous) / new_registrations_7days_previous) * 100
        else:
            registrations_change_percent = 100.0 if new_registrations_7days > 0 else 0.0

        # Applications (last 7 days)
        apps_7_response = db.table('applications').select('id', count='exact').gte(
            'created_at', days_7_ago.isoformat()
        ).execute()
        applications_7days = apps_7_response.count if apps_7_response.count else 0

        # Applications (previous 7 days)
        apps_14_response = db.table('applications').select('id', count='exact').gte(
            'created_at', days_14_ago.isoformat()
        ).lt('created_at', days_7_ago.isoformat()).execute()
        applications_7days_previous = apps_14_response.count if apps_14_response.count else 0

        if applications_7days_previous > 0:
            applications_change_percent = ((applications_7days - applications_7days_previous) / applications_7days_previous) * 100
        else:
            applications_change_percent = 100.0 if applications_7days > 0 else 0.0

        # Total users by role
        all_users_response = db.table('users').select('role', count='exact').execute()
        total_users = all_users_response.count if all_users_response.count else 0

        # Count by role
        students_response = db.table('users').select('id', count='exact').eq('role', 'student').execute()
        total_students = students_response.count if students_response.count else 0

        institutions_response = db.table('users').select('id', count='exact').eq('role', 'institution').execute()
        total_institutions = institutions_response.count if institutions_response.count else 0

        parents_response = db.table('users').select('id', count='exact').eq('role', 'parent').execute()
        total_parents = parents_response.count if parents_response.count else 0

        counselors_response = db.table('users').select('id', count='exact').eq('role', 'counselor').execute()
        total_counselors = counselors_response.count if counselors_response.count else 0

        return EnhancedMetricsResponse(
            active_users_30days=active_users_30days,
            active_users_30days_previous=active_users_30days_previous,
            active_users_change_percent=round(active_users_change_percent, 2),

            new_registrations_7days=new_registrations_7days,
            new_registrations_7days_previous=new_registrations_7days_previous,
            registrations_change_percent=round(registrations_change_percent, 2),

            applications_7days=applications_7days,
            applications_7days_previous=applications_7days_previous,
            applications_change_percent=round(applications_change_percent, 2),

            total_users=total_users,
            total_students=total_students,
            total_institutions=total_institutions,
            total_parents=total_parents,
            total_counselors=total_counselors
        )

    except Exception as e:
        logger.error(f"Error fetching enhanced metrics: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch enhanced metrics: {str(e)}"
        )
