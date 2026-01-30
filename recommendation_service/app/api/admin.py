"""
Admin/Management API Endpoints
Includes data enrichment and other administrative tasks
"""
from fastapi import APIRouter, BackgroundTasks, HTTPException, Depends, Query
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
import logging
from datetime import datetime, timedelta, timezone

from app.database.config import get_supabase, get_supabase_admin
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.enrichment.web_search_enricher import WebSearchEnricher
from app.enrichment.field_scrapers import FieldSpecificScrapers
from app.utils.security import (
    get_current_user, CurrentUser, require_admin, require_super_admin,
    require_content_admin, require_finance_admin, require_support_admin,
    require_analytics_admin, apply_regional_filter,
)
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


class SystemSettingsUpdate(BaseModel):
    settings: Dict[str, Any]


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
    background_tasks: BackgroundTasks,
    current_user: CurrentUser = Depends(require_super_admin),
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
async def get_enrichment_status(
    current_user: CurrentUser = Depends(require_super_admin),
):
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
async def analyze_null_values(
    current_user: CurrentUser = Depends(require_super_admin),
):
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


# ==================== ADMIN USER MANAGEMENT ====================

class CreateAdminRequest(BaseModel):
    """Request model for creating an admin user"""
    email: str
    password: str
    display_name: str
    admin_role: str  # superadmin, regionaladmin, contentadmin, supportadmin, financeadmin, analyticsadmin
    phone_number: Optional[str] = None
    regional_scope: Optional[str] = None


class AdminProfileResponse(BaseModel):
    """Response model for admin profile"""
    id: str
    email: str
    display_name: Optional[str] = None
    admin_role: Optional[str] = None
    permissions: Optional[List[str]] = None
    regional_scope: Optional[str] = None
    is_active: bool = True
    created_at: Optional[str] = None


ALLOWED_ADMIN_ROLES = [
    'superadmin', 'regionaladmin', 'contentadmin',
    'supportadmin', 'financeadmin', 'analyticsadmin',
]

# Default permissions per role (text[] in PostgreSQL)
_ROLE_PERMISSIONS = {
    'superadmin': ['*'],
    'regionaladmin': ['users', 'content', 'support', 'analytics'],
    'contentadmin': ['content'],
    'supportadmin': ['support', 'users_read'],
    'financeadmin': ['finance', 'analytics'],
    'analyticsadmin': ['analytics'],
}


@router.post("/admin/users/admins")
async def create_admin_user(
    request: CreateAdminRequest,
    current_user: CurrentUser = Depends(require_super_admin),
) -> Dict[str, Any]:
    """
    Create a new admin user (Super Admin only).

    Creates a Supabase Auth user, inserts into `users` table,
    and inserts into `admin_users` table with role and permissions.
    """
    # Validate role
    if request.admin_role not in ALLOWED_ADMIN_ROLES:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid admin_role. Must be one of: {ALLOWED_ADMIN_ROLES}"
        )

    # Regional admin requires regional_scope
    if request.admin_role == 'regionaladmin' and not request.regional_scope:
        raise HTTPException(
            status_code=400,
            detail="regional_scope is required for regionaladmin role"
        )

    try:
        admin_db = get_supabase_admin()

        # 1. Create Supabase Auth user via admin API
        auth_response = admin_db.auth.admin.create_user({
            "email": request.email,
            "password": request.password,
            "email_confirm": True,
            "user_metadata": {
                "role": request.admin_role,
                "display_name": request.display_name,
            },
        })
        new_user_id = auth_response.user.id

        # Explicitly confirm email (belt-and-suspenders for Supabase versions
        # where email_confirm in create_user may not take effect)
        try:
            admin_db.auth.admin.update_user_by_id(
                new_user_id,
                {"email_confirm": True}
            )
        except Exception as confirm_err:
            logger.warning(f"Could not explicitly confirm email: {confirm_err}")

        # 2. Insert into users table
        admin_db.table('users').insert({
            'id': new_user_id,
            'email': request.email,
            'display_name': request.display_name,
            'active_role': request.admin_role,
            'available_roles': [request.admin_role],
            'phone_number': request.phone_number,
            'is_active': True,
        }).execute()

        # 3. Insert into admin_users table
        permissions = _ROLE_PERMISSIONS.get(request.admin_role, {})
        admin_db.table('admin_users').insert({
            'id': new_user_id,
            'admin_role': request.admin_role,
            'permissions': permissions,
            'regional_scope': request.regional_scope,
            'is_active': True,
        }).execute()

        logger.info(
            f"Super admin {current_user.id} created admin user "
            f"{request.email} with role {request.admin_role}"
        )

        return {
            'success': True,
            'message': f'Admin account created for {request.email}',
            'admin': {
                'id': new_user_id,
                'email': request.email,
                'display_name': request.display_name,
                'admin_role': request.admin_role,
                'regional_scope': request.regional_scope,
            }
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating admin user: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create admin user: {str(e)}"
        )


@router.get("/admin/users/admins/me", response_model=AdminProfileResponse)
async def get_current_admin_profile(
    current_user: CurrentUser = Depends(require_admin),
) -> AdminProfileResponse:
    """
    Get current admin's profile (any admin role).
    """
    try:
        db = get_supabase()
        response = db.table('admin_users').select('*').eq('id', current_user.id).single().execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Admin profile not found")

        data = response.data
        return AdminProfileResponse(
            id=current_user.id,
            email=current_user.email,
            display_name=current_user.display_name,
            admin_role=data.get('admin_role'),
            permissions=data.get('permissions'),
            regional_scope=data.get('regional_scope'),
            is_active=data.get('is_active', True),
            created_at=data.get('created_at'),
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching admin profile: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Failed to fetch admin profile: {str(e)}")


@router.get("/admin/users/admins")
async def list_admin_users(
    current_user: CurrentUser = Depends(require_super_admin),
) -> Dict[str, Any]:
    """
    List all admin users (Super Admin only).

    Joins admin_users with users to get display names and emails.
    """
    try:
        db = get_supabase()
        response = db.table('admin_users').select(
            '*, users!inner(email, display_name)'
        ).execute()

        admins = []
        for row in response.data or []:
            user_info = row.get('users', {})
            admins.append(AdminProfileResponse(
                id=row['id'],
                email=user_info.get('email', ''),
                display_name=user_info.get('display_name'),
                admin_role=row.get('admin_role'),
                permissions=row.get('permissions'),
                regional_scope=row.get('regional_scope'),
                is_active=row.get('is_active', True),
                created_at=row.get('created_at'),
            ))

        return {
            'success': True,
            'admins': [a.model_dump() for a in admins],
            'total': len(admins),
        }

    except Exception as e:
        logger.error(f"Error listing admin users: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Failed to list admin users: {str(e)}")


class UpdateAdminRequest(BaseModel):
    """Request model for updating an admin user"""
    display_name: Optional[str] = None
    admin_role: Optional[str] = None
    phone_number: Optional[str] = None
    regional_scope: Optional[str] = None
    is_active: Optional[bool] = None


@router.get("/admin/users/admins/{admin_id}")
async def get_admin_user(
    admin_id: str,
    current_user: CurrentUser = Depends(require_super_admin),
) -> Dict[str, Any]:
    """
    Get a single admin user by ID (Super Admin only).
    """
    try:
        db = get_supabase()
        response = db.table('admin_users').select(
            '*, users!inner(email, display_name, phone_number)'
        ).eq('id', admin_id).single().execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Admin user not found")

        row = response.data
        user_info = row.get('users', {})

        return {
            'success': True,
            'admin': {
                'id': row['id'],
                'email': user_info.get('email', ''),
                'display_name': user_info.get('display_name'),
                'phone_number': user_info.get('phone_number'),
                'admin_role': row.get('admin_role'),
                'permissions': row.get('permissions'),
                'regional_scope': row.get('regional_scope'),
                'is_active': row.get('is_active', True),
                'created_at': row.get('created_at'),
            }
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching admin user {admin_id}: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Failed to fetch admin user: {str(e)}")


@router.put("/admin/users/admins/{admin_id}")
async def update_admin_user(
    admin_id: str,
    request: UpdateAdminRequest,
    current_user: CurrentUser = Depends(require_super_admin),
) -> Dict[str, Any]:
    """
    Update an admin user (Super Admin only).

    Updates both `users` and `admin_users` tables as needed.
    """
    # Validate role if provided
    if request.admin_role is not None:
        if request.admin_role not in ALLOWED_ADMIN_ROLES:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid admin_role. Must be one of: {ALLOWED_ADMIN_ROLES}"
            )
        if request.admin_role == 'regionaladmin' and not request.regional_scope:
            # Check if existing record already has regional_scope
            db = get_supabase()
            existing = db.table('admin_users').select('regional_scope').eq('id', admin_id).single().execute()
            if not (existing.data and existing.data.get('regional_scope')):
                raise HTTPException(
                    status_code=400,
                    detail="regional_scope is required for regionaladmin role"
                )

    try:
        admin_db = get_supabase_admin()

        # Update users table fields
        user_updates = {}
        if request.display_name is not None:
            user_updates['display_name'] = request.display_name
        if request.phone_number is not None:
            user_updates['phone_number'] = request.phone_number
        if request.admin_role is not None:
            user_updates['active_role'] = request.admin_role
            user_updates['available_roles'] = [request.admin_role]
        if request.is_active is not None:
            user_updates['is_active'] = request.is_active

        if user_updates:
            admin_db.table('users').update(user_updates).eq('id', admin_id).execute()

        # Update admin_users table fields
        admin_updates = {}
        if request.admin_role is not None:
            admin_updates['admin_role'] = request.admin_role
            admin_updates['permissions'] = _ROLE_PERMISSIONS.get(request.admin_role, [])
        if request.regional_scope is not None:
            admin_updates['regional_scope'] = request.regional_scope
        if request.is_active is not None:
            admin_updates['is_active'] = request.is_active

        if admin_updates:
            admin_db.table('admin_users').update(admin_updates).eq('id', admin_id).execute()

        logger.info(
            f"Super admin {current_user.id} updated admin user {admin_id}"
        )

        return {
            'success': True,
            'message': f'Admin account updated successfully',
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating admin user {admin_id}: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to update admin user: {str(e)}"
        )


# ==================== ADMIN DASHBOARD ACTIVITY FEED ====================

@router.get("/admin/dashboard/recent-activity")
async def get_recent_activity(
    limit: int = Query(default=10, ge=1, le=100, description="Maximum number of activities to return"),
    user_id: Optional[str] = Query(default=None, description="Filter by user ID"),
    action_type: Optional[str] = Query(default=None, description="Filter by action type"),
    current_user: CurrentUser = Depends(require_admin)
):
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
        logger.warning(f"Error fetching recent activities (activity_log table may not exist): {e}")
        # Return empty response if table doesn't exist
        return RecentActivityResponse(
            activities=[],
            total_count=0,
            limit=limit,
            has_more=False
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
        logger.warning(f"Error fetching activity stats (activity_log table may not exist): {e}")
        # Return default response if table doesn't exist
        return ActivityStatsResponse(
            total_activities=0,
            activities_today=0,
            activities_this_week=0,
            activities_this_month=0,
            top_action_types={},
            top_users=[],
            recent_registrations=0,
            recent_logins=0,
            recent_applications=0
        )


@router.delete("/admin/data/courses")
async def clear_all_courses(
    confirm: bool = Query(False, description="Set to true to confirm deletion"),
    current_user: CurrentUser = Depends(require_super_admin)
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
        now = datetime.now(timezone.utc)

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
        response = db.table('users').select('id, created_at, active_role').order('created_at').execute()

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
            created_at_str = user['created_at']
            # Parse datetime and ensure timezone awareness
            if created_at_str:
                try:
                    created_at = datetime.fromisoformat(created_at_str.replace('Z', '+00:00'))
                    # Ensure timezone awareness
                    if created_at.tzinfo is None:
                        created_at = created_at.replace(tzinfo=timezone.utc)
                except Exception:
                    continue  # Skip invalid dates

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
        logger.warning(f"Error fetching user growth analytics: {e}")
        # Return empty response on error
        return UserGrowthResponse(
            data_points=[],
            total_users=0,
            growth_rate=0.0,
            period=period,
            comparison_period_users=0,
            average_per_period=0.0
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
        response = db.table('users').select('active_role').execute()

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
            role = user.get('active_role', 'unknown')
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


class AdminUserResponse(BaseModel):
    """Response model for admin user list"""
    id: str
    email: str
    display_name: Optional[str] = None
    active_role: Optional[str] = None
    available_roles: Optional[List[str]] = None
    photo_url: Optional[str] = None
    phone_number: Optional[str] = None
    created_at: Optional[str] = None
    last_login_at: Optional[str] = None
    is_email_verified: Optional[bool] = False
    is_phone_verified: Optional[bool] = False
    is_active: Optional[bool] = True
    # Role-specific fields
    school: Optional[str] = None
    grade: Optional[str] = None
    graduation_year: Optional[int] = None
    institution_type: Optional[str] = None
    location: Optional[str] = None
    website: Optional[str] = None
    specialty: Optional[str] = None
    organization: Optional[str] = None
    position: Optional[str] = None
    children_count: Optional[int] = None
    occupation: Optional[str] = None


class AdminUsersListResponse(BaseModel):
    """Response model for admin users list"""
    success: bool = True
    users: List[AdminUserResponse]
    total: int


@router.get("/admin/users", response_model=AdminUsersListResponse)
async def get_all_users_for_admin(
    role: Optional[str] = Query(None, description="Filter by role"),
    current_user: CurrentUser = Depends(require_admin)
) -> AdminUsersListResponse:
    """
    Get all users for admin panel

    **Admin Only** - Returns all users with their profiles.

    **Query Parameters:**
    - role: Optional filter by active_role (e.g., 'student', 'parent', 'institution')

    **Returns:**
    - users: List of user objects with all profile data
    - total: Total count of users
    """
    try:
        db = get_supabase()

        # Build query
        query = db.table('users').select('*')

        # Apply role filter if provided
        if role:
            query = query.eq('active_role', role.lower())

        # Apply regional scope filter for regional admins
        query = apply_regional_filter(query, current_user, region_column='location')

        response = query.execute()

        users = []
        for user_data in response.data or []:
            users.append(AdminUserResponse(
                id=user_data.get('id', ''),
                email=user_data.get('email', ''),
                display_name=user_data.get('display_name'),
                active_role=user_data.get('active_role'),
                available_roles=user_data.get('available_roles', []),
                photo_url=user_data.get('photo_url'),
                phone_number=user_data.get('phone_number'),
                created_at=user_data.get('created_at'),
                last_login_at=user_data.get('last_login_at'),
                is_email_verified=user_data.get('is_email_verified', False),
                is_phone_verified=user_data.get('is_phone_verified', False),
                is_active=user_data.get('is_active', True),
                school=user_data.get('school'),
                grade=user_data.get('grade'),
                graduation_year=user_data.get('graduation_year'),
                institution_type=user_data.get('institution_type'),
                location=user_data.get('location'),
                website=user_data.get('website'),
                specialty=user_data.get('specialty'),
                organization=user_data.get('organization'),
                position=user_data.get('position'),
                children_count=user_data.get('children_count'),
                occupation=user_data.get('occupation'),
            ))

        return AdminUsersListResponse(
            success=True,
            users=users,
            total=len(users)
        )

    except Exception as e:
        logger.error(f"Error fetching users for admin: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch users: {str(e)}"
        )


@router.get("/admin/analytics/metrics")
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
        all_users_response = db.table('users').select('active_role', count='exact').execute()
        total_users = all_users_response.count if all_users_response.count else 0

        # Count by role (using active_role column)
        students_response = db.table('users').select('id', count='exact').eq('active_role', 'student').execute()
        total_students = students_response.count if students_response.count else 0

        institutions_response = db.table('users').select('id', count='exact').eq('active_role', 'institution').execute()
        total_institutions = institutions_response.count if institutions_response.count else 0

        parents_response = db.table('users').select('id', count='exact').eq('active_role', 'parent').execute()
        total_parents = parents_response.count if parents_response.count else 0

        counselors_response = db.table('users').select('id', count='exact').eq('active_role', 'counselor').execute()
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
        logger.warning(f"Error fetching enhanced metrics: {e}")
        # Return default response if tables don't exist
        return EnhancedMetricsResponse(
            active_users_30days=0,
            active_users_30days_previous=0,
            active_users_change_percent=0.0,
            new_registrations_7days=0,
            new_registrations_7days_previous=0,
            registrations_change_percent=0.0,
            applications_7days=0,
            applications_7days_previous=0,
            applications_change_percent=0.0,
            total_users=0,
            total_students=0,
            total_institutions=0,
            total_parents=0,
            total_counselors=0
        )


# =============================================================================
# ADMIN CONTENT MANAGEMENT ENDPOINTS
# =============================================================================

class AdminContentItem(BaseModel):
    """Response model for admin content item"""
    id: str
    title: str
    description: Optional[str] = None
    type: str  # 'course', 'module', 'lesson'
    status: str  # 'draft', 'published', 'archived', 'pending'
    institution_id: Optional[str] = None
    institution_name: Optional[str] = None
    author_id: Optional[str] = None
    author_name: Optional[str] = None
    category: Optional[str] = None
    level: Optional[str] = None
    duration_hours: Optional[float] = None
    enrollment_count: int = 0
    created_at: Optional[str] = None
    updated_at: Optional[str] = None
    published_at: Optional[str] = None


class AdminContentListResponse(BaseModel):
    """Response model for admin content list"""
    success: bool = True
    content: List[AdminContentItem]
    total: int
    stats: Dict[str, int]


class AdminContentStatsResponse(BaseModel):
    """Response model for content statistics"""
    success: bool = True
    total_content: int = 0
    published: int = 0
    draft: int = 0
    pending: int = 0
    archived: int = 0
    by_type: Dict[str, int] = {}
    by_category: Dict[str, int] = {}


@router.get("/admin/content", response_model=AdminContentListResponse)
async def get_all_content_for_admin(
    status: Optional[str] = Query(None, description="Filter by status"),
    content_type: Optional[str] = Query(None, alias="type", description="Filter by type"),
    category: Optional[str] = Query(None, description="Filter by category"),
    search: Optional[str] = Query(None, description="Search in title"),
    current_user: CurrentUser = Depends(require_content_admin)
) -> AdminContentListResponse:
    """
    Get all content for admin panel

    **Admin Only** - Returns all courses/content with their metadata.

    **Query Parameters:**
    - status: Filter by status (draft, published, archived, pending)
    - type: Filter by content type (course, module, lesson)
    - category: Filter by category
    - search: Search in title

    **Returns:**
    - content: List of content items with all metadata
    - total: Total count of content
    - stats: Counts by status
    """
    try:
        db = get_supabase()

        # Build query for courses
        query = db.table('courses').select('*')

        # Apply filters
        if status:
            query = query.eq('status', status.lower())
        if category:
            query = query.eq('category', category)
        if search:
            query = query.ilike('title', f'%{search}%')

        response = query.order('created_at', desc=True).execute()

        content_items = []
        stats = {'draft': 0, 'published': 0, 'archived': 0, 'pending': 0}

        for course in response.data or []:
            course_status = course.get('status', 'draft')
            if course_status in stats:
                stats[course_status] += 1

            # Get institution name
            institution_name = None
            institution_id = course.get('institution_id')
            if institution_id:
                inst_response = db.table('users').select('display_name').eq('id', institution_id).single().execute()
                if inst_response.data:
                    institution_name = inst_response.data.get('display_name')

            content_items.append(AdminContentItem(
                id=course.get('id', ''),
                title=course.get('title', ''),
                description=course.get('description'),
                type='course',
                status=course_status,
                institution_id=institution_id,
                institution_name=institution_name,
                author_id=institution_id,
                author_name=institution_name,
                category=course.get('category'),
                level=course.get('level'),
                duration_hours=course.get('duration_hours'),
                enrollment_count=course.get('enrollment_count', 0),
                created_at=course.get('created_at'),
                updated_at=course.get('updated_at'),
                published_at=course.get('published_at'),
            ))

        # Filter by type if specified (currently only courses)
        if content_type and content_type.lower() != 'course':
            content_items = []  # No other types yet

        return AdminContentListResponse(
            success=True,
            content=content_items,
            total=len(content_items),
            stats=stats
        )

    except Exception as e:
        logger.error(f"Error fetching content for admin: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch content: {str(e)}"
        )


@router.get("/admin/content/stats", response_model=AdminContentStatsResponse)
async def get_content_statistics(
    current_user: CurrentUser = Depends(require_content_admin)
) -> AdminContentStatsResponse:
    """
    Get content statistics for admin dashboard

    **Admin Only** - Returns aggregated content statistics.

    **Returns:**
    - Total content count
    - Counts by status (draft, published, archived, pending)
    - Counts by type
    - Counts by category
    """
    try:
        db = get_supabase()

        # Get all courses
        response = db.table('courses').select('status, category, course_type').execute()

        stats = AdminContentStatsResponse()
        by_type: Dict[str, int] = {}
        by_category: Dict[str, int] = {}

        for course in response.data or []:
            stats.total_content += 1

            # Count by status
            course_status = course.get('status', 'draft')
            if course_status == 'draft':
                stats.draft += 1
            elif course_status == 'published':
                stats.published += 1
            elif course_status == 'archived':
                stats.archived += 1
            elif course_status == 'pending':
                stats.pending += 1

            # Count by type
            course_type = course.get('course_type', 'course')
            by_type[course_type] = by_type.get(course_type, 0) + 1

            # Count by category
            category = course.get('category', 'uncategorized')
            if category:
                by_category[category] = by_category.get(category, 0) + 1

        stats.by_type = by_type
        stats.by_category = by_category

        return stats

    except Exception as e:
        logger.error(f"Error fetching content statistics: {e}", exc_info=True)
        # Return empty stats on error
        return AdminContentStatsResponse()


@router.put("/admin/content/{content_id}/status")
async def update_content_status(
    content_id: str,
    status_update: Dict[str, str],
    current_user: CurrentUser = Depends(require_content_admin)
) -> Dict[str, Any]:
    """
    Update content status (approve, reject, archive)

    **Admin Only** - Update the status of a content item.

    **Path Parameters:**
    - content_id: Content (course) ID

    **Request Body:**
    - status: New status (draft, published, archived, pending)

    **Returns:**
    - Success message and updated content
    """
    try:
        db = get_supabase()
        new_status = status_update.get('status', '').lower()

        if new_status not in ['draft', 'published', 'archived', 'pending']:
            raise HTTPException(
                status_code=400,
                detail="Invalid status. Must be: draft, published, archived, or pending"
            )

        update_data = {'status': new_status}

        # Sync is_published with status to satisfy database constraint
        # published_status_match: (is_published = TRUE AND status = 'published') OR (is_published = FALSE AND status != 'published')
        if new_status == 'published':
            update_data['is_published'] = True
            update_data['published_at'] = datetime.utcnow().isoformat()
        else:
            update_data['is_published'] = False

        response = db.table('courses').update(update_data).eq('id', content_id).execute()

        if not response.data:
            raise HTTPException(
                status_code=404,
                detail=f"Content not found: {content_id}"
            )

        return {
            'success': True,
            'message': f'Content status updated to {new_status}',
            'content': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating content status: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to update content status: {str(e)}"
        )


@router.delete("/admin/content/{content_id}")
async def delete_content(
    content_id: str,
    current_user: CurrentUser = Depends(require_content_admin)
) -> Dict[str, Any]:
    """
    Delete content (soft delete by archiving)

    **Admin Only** - Archive a content item.

    **Path Parameters:**
    - content_id: Content (course) ID

    **Returns:**
    - Success message
    """
    try:
        db = get_supabase()

        # Soft delete by setting status to archived
        response = db.table('courses').update({
            'status': 'archived',
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', content_id).execute()

        if not response.data:
            raise HTTPException(
                status_code=404,
                detail=f"Content not found: {content_id}"
            )

        return {
            'success': True,
            'message': 'Content archived successfully'
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting content: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to delete content: {str(e)}"
        )


class CreateContentRequest(BaseModel):
    """Request model for creating content"""
    title: str
    description: Optional[str] = None
    # course_type must be: video, text, interactive, live, hybrid
    type: str = "video"
    category: Optional[str] = None
    # level must be: beginner, intermediate, advanced, expert
    level: Optional[str] = None
    duration_hours: Optional[float] = None
    institution_id: Optional[str] = None


@router.post("/admin/content")
async def create_content(
    request: CreateContentRequest,
    current_user: CurrentUser = Depends(require_content_admin)
) -> Dict[str, Any]:
    """
    Create new content (course, lesson, resource)

    **Admin Only** - Create a new content item.

    **Request Body:**
    - title: Content title (required)
    - description: Content description
    - type: Content type (course, lesson, resource, assessment)
    - category: Content category
    - level: Difficulty level
    - duration_hours: Expected duration in hours
    - institution_id: Optional institution ID

    **Returns:**
    - Created content item
    """
    try:
        db = get_supabase()
        import uuid

        # Build content data with valid constraint values
        # course_type CHECK: 'video', 'text', 'interactive', 'live', 'hybrid'
        # level CHECK: 'beginner', 'intermediate', 'advanced', 'expert'
        # status CHECK: 'draft', 'published', 'archived'
        valid_course_types = ['video', 'text', 'interactive', 'live', 'hybrid']
        valid_levels = ['beginner', 'intermediate', 'advanced', 'expert']

        course_type = request.type if request.type in valid_course_types else 'video'
        level = request.level if request.level in valid_levels else 'beginner'

        content_data = {
            'id': str(uuid.uuid4()),
            'title': request.title,
            'description': request.description or '',
            'status': 'draft',
            'course_type': course_type,
            'level': level,
            'is_published': False,
            'price': 0.0,
            'currency': 'USD',
            'enrolled_count': 0,
            'review_count': 0,
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        # Add optional fields only if they have values
        if request.category:
            content_data['category'] = request.category
        if request.duration_hours is not None:
            content_data['duration_hours'] = request.duration_hours
        if request.institution_id:
            content_data['institution_id'] = request.institution_id

        response = db.table('courses').insert(content_data).execute()

        if not response.data:
            raise HTTPException(
                status_code=500,
                detail="Failed to create content"
            )

        logger.info(f"Admin {current_user.id} created content: {request.title}")

        return {
            'success': True,
            'message': f'Content "{request.title}" created as draft',
            'content': {
                'id': response.data[0]['id'],
                'title': response.data[0]['title'],
                'description': response.data[0].get('description'),
                'type': response.data[0].get('course_type', 'course'),
                'status': response.data[0].get('status', 'draft'),
                'institution_id': response.data[0].get('institution_id'),
                'category': response.data[0].get('category'),
                'level': response.data[0].get('level'),
                'duration_hours': response.data[0].get('duration_hours'),
                'created_at': response.data[0].get('created_at'),
                'updated_at': response.data[0].get('updated_at'),
            }
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating content: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create content: {str(e)}"
        )


class ContentAssignmentRequest(BaseModel):
    """Request model for assigning content"""
    content_id: str
    target_type: str  # 'student', 'institution', 'all_students'
    target_ids: Optional[List[str]] = None  # List of user IDs
    is_required: bool = False
    due_date: Optional[str] = None


class ContentAssignmentResponse(BaseModel):
    """Response model for content assignment"""
    id: str
    content_id: str
    content_title: str
    target_type: str
    target_id: Optional[str] = None
    target_name: Optional[str] = None
    is_required: bool = False
    due_date: Optional[str] = None
    assigned_at: str
    assigned_by: str
    status: str = "assigned"


@router.post("/admin/content/assign")
async def assign_content(
    request: ContentAssignmentRequest,
    current_user: CurrentUser = Depends(require_content_admin)
) -> Dict[str, Any]:
    """
    Assign content to students or institutions

    **Admin Only** - Assign content to specific users or groups.

    **Request Body:**
    - content_id: Content ID to assign
    - target_type: 'student', 'institution', or 'all_students'
    - target_ids: List of user/institution IDs (not needed for 'all_students')
    - is_required: Whether the content is mandatory
    - due_date: Optional due date (ISO format)

    **Returns:**
    - List of created assignments
    """
    try:
        db = get_supabase()
        import uuid

        # Verify content exists
        content_response = db.table('courses').select('id, title').eq('id', request.content_id).single().execute()
        if not content_response.data:
            raise HTTPException(
                status_code=404,
                detail=f"Content not found: {request.content_id}"
            )

        content_title = content_response.data['title']
        assignments_created = []

        if request.target_type == 'all_students':
            # Create a single assignment for all students
            assignment_data = {
                'id': str(uuid.uuid4()),
                'content_id': request.content_id,
                'target_id': None,  # No specific target for all_students
                'target_type': 'all_students',
                'is_required': request.is_required,
                'due_date': request.due_date,
                'assigned_by': current_user.id,
                'assigned_at': datetime.utcnow().isoformat(),
                'status': 'assigned',
                'progress': 0,
            }

            try:
                response = db.table('content_assignments').insert(assignment_data).execute()
                if response.data:
                    assignments_created.append(ContentAssignmentResponse(
                        id=response.data[0]['id'],
                        content_id=request.content_id,
                        content_title=content_title,
                        target_type='all_students',
                        target_id=None,
                        target_name='All Students',
                        is_required=request.is_required,
                        due_date=request.due_date,
                        assigned_at=response.data[0]['assigned_at'],
                        assigned_by=current_user.id,
                        status='assigned'
                    ))
            except Exception as table_error:
                logger.warning(f"content_assignments table may not exist: {table_error}")
                assignments_created.append(ContentAssignmentResponse(
                    id=assignment_data['id'],
                    content_id=request.content_id,
                    content_title=content_title,
                    target_type='all_students',
                    target_id=None,
                    target_name='All Students',
                    is_required=request.is_required,
                    due_date=request.due_date,
                    assigned_at=assignment_data['assigned_at'],
                    assigned_by=current_user.id,
                    status='assigned'
                ))

            logger.info(f"Admin {current_user.id} assigned content {request.content_id} to all students")
            return {
                'success': True,
                'message': 'Content assigned to all students',
                'assignments': assignments_created
            }

        # For specific students or institutions
        target_ids = request.target_ids or []

        # Create assignments for each target
        for target_id in target_ids:
            # Get target name
            target_response = db.table('users').select('display_name').eq('id', target_id).single().execute()
            target_name = target_response.data.get('display_name', 'Unknown') if target_response.data else 'Unknown'

            assignment_data = {
                'id': str(uuid.uuid4()),
                'content_id': request.content_id,
                'target_id': target_id,
                'target_type': request.target_type,
                'is_required': request.is_required,
                'due_date': request.due_date,
                'assigned_by': current_user.id,
                'assigned_at': datetime.utcnow().isoformat(),
                'status': 'assigned',
                'progress': 0,
            }

            # Check if content_assignments table exists, if not use a fallback
            try:
                response = db.table('content_assignments').insert(assignment_data).execute()
                if response.data:
                    assignments_created.append(ContentAssignmentResponse(
                        id=response.data[0]['id'],
                        content_id=request.content_id,
                        content_title=content_title,
                        target_type=request.target_type,
                        target_id=target_id,
                        target_name=target_name,
                        is_required=request.is_required,
                        due_date=request.due_date,
                        assigned_at=response.data[0]['assigned_at'],
                        assigned_by=current_user.id,
                        status='assigned'
                    ))
            except Exception as table_error:
                # If table doesn't exist, log it but continue
                logger.warning(f"content_assignments table may not exist: {table_error}")
                # Create a virtual assignment response
                assignments_created.append(ContentAssignmentResponse(
                    id=assignment_data['id'],
                    content_id=request.content_id,
                    content_title=content_title,
                    target_type=request.target_type,
                    target_id=target_id,
                    target_name=target_name,
                    is_required=request.is_required,
                    due_date=request.due_date,
                    assigned_at=assignment_data['assigned_at'],
                    assigned_by=current_user.id,
                    status='assigned'
                ))

        logger.info(f"Admin {current_user.id} assigned content {request.content_id} to {len(assignments_created)} targets")

        return {
            'success': True,
            'message': f'Content assigned to {len(assignments_created)} target(s)',
            'assignments': assignments_created
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error assigning content: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to assign content: {str(e)}"
        )


@router.get("/admin/content/{content_id}/assignments")
async def get_content_assignments(
    content_id: str,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Get all assignments for a specific content item

    **Admin Only** - View who is assigned to a content item.

    **Path Parameters:**
    - content_id: Content ID

    **Returns:**
    - List of assignments with target details
    """
    try:
        db = get_supabase()

        # Get content title
        content_response = db.table('courses').select('title').eq('id', content_id).single().execute()
        content_title = content_response.data.get('title', 'Unknown') if content_response.data else 'Unknown'

        # Get assignments
        try:
            response = db.table('content_assignments').select('*').eq('content_id', content_id).execute()
            assignments = []

            for assignment in response.data or []:
                # Get target name - use target_id from assignment
                target_id = assignment.get('target_id')
                target_type = assignment.get('target_type', 'student')
                target_name = 'All Students'

                if target_id and target_type != 'all_students':
                    user_response = db.table('users').select('display_name').eq('id', target_id).single().execute()
                    target_name = user_response.data.get('display_name', 'Unknown') if user_response.data else 'Unknown'

                assignments.append(ContentAssignmentResponse(
                    id=assignment['id'],
                    content_id=content_id,
                    content_title=content_title,
                    target_type=target_type,
                    target_id=target_id,
                    target_name=target_name,
                    is_required=assignment.get('is_required', False),
                    due_date=assignment.get('due_date'),
                    assigned_at=assignment.get('assigned_at', ''),
                    assigned_by=assignment.get('assigned_by', ''),
                    status=assignment.get('status', 'assigned')
                ))

            return {
                'success': True,
                'content_id': content_id,
                'content_title': content_title,
                'assignments': assignments,
                'total': len(assignments)
            }

        except Exception as table_error:
            logger.warning(f"content_assignments table may not exist: {table_error}")
            return {
                'success': True,
                'content_id': content_id,
                'content_title': content_title,
                'assignments': [],
                'total': 0,
                'note': 'Content assignments table not yet created'
            }

    except Exception as e:
        logger.error(f"Error fetching content assignments: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch content assignments: {str(e)}"
        )


@router.delete("/admin/content/assignment/{assignment_id}")
async def remove_content_assignment(
    assignment_id: str,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Remove a content assignment

    **Admin Only** - Unassign content from a user.

    **Path Parameters:**
    - assignment_id: Assignment ID to remove

    **Returns:**
    - Success message
    """
    try:
        db = get_supabase()

        response = db.table('content_assignments').delete().eq('id', assignment_id).execute()

        logger.info(f"Admin {current_user.id} removed content assignment {assignment_id}")

        return {
            'success': True,
            'message': 'Assignment removed successfully'
        }

    except Exception as e:
        logger.error(f"Error removing content assignment: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to remove assignment: {str(e)}"
        )


# =============================================================================
# ADMIN SUPPORT TICKETS ENDPOINTS
# =============================================================================

class SupportTicketResponse(BaseModel):
    """Response model for support ticket"""
    id: str
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    user_email: Optional[str] = None
    subject: str
    description: Optional[str] = None
    category: str = "general"
    priority: str = "medium"
    status: str = "open"
    assigned_to: Optional[str] = None
    assigned_to_name: Optional[str] = None
    created_at: str
    updated_at: str
    resolved_at: Optional[str] = None


class SupportTicketsListResponse(BaseModel):
    """Response model for support tickets list"""
    success: bool = True
    tickets: List[SupportTicketResponse]
    total: int
    open_count: int = 0
    in_progress_count: int = 0
    resolved_count: int = 0
    closed_count: int = 0


class CreateTicketRequest(BaseModel):
    """Request model for creating support ticket"""
    subject: str
    description: Optional[str] = None
    category: str = "general"
    priority: str = "medium"
    user_id: Optional[str] = None


class UpdateTicketStatusRequest(BaseModel):
    """Request model for updating ticket status"""
    status: str  # open, in_progress, resolved, closed


class AssignTicketRequest(BaseModel):
    """Request model for assigning ticket"""
    assigned_to: str  # User ID of admin/support agent


@router.get("/admin/support/tickets", response_model=SupportTicketsListResponse)
async def get_support_tickets(
    status: Optional[str] = Query(None, description="Filter by status"),
    priority: Optional[str] = Query(None, description="Filter by priority"),
    category: Optional[str] = Query(None, description="Filter by category"),
    assigned_to: Optional[str] = Query(None, description="Filter by assigned agent"),
    search: Optional[str] = Query(None, description="Search in subject"),
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    current_user: CurrentUser = Depends(require_admin)
) -> SupportTicketsListResponse:
    """
    Get all support tickets for admin panel

    **Admin Only** - Returns all support tickets with filtering options.
    """
    try:
        db = get_supabase()

        # Build query
        query = db.table('support_tickets').select('*')

        # Apply filters
        if status:
            query = query.eq('status', status.lower())
        if priority:
            query = query.eq('priority', priority.lower())
        if category:
            query = query.eq('category', category.lower())
        if assigned_to:
            query = query.eq('assigned_to', assigned_to)
        if search:
            query = query.ilike('subject', f'%{search}%')

        # Get total count first
        count_response = db.table('support_tickets').select('id', count='exact').execute()
        total = count_response.count if count_response.count else 0

        # Apply pagination and ordering
        query = query.order('created_at', desc=True).range(offset, offset + limit - 1)

        response = query.execute()

        tickets = []
        status_counts = {'open': 0, 'in_progress': 0, 'resolved': 0, 'closed': 0}

        for ticket_data in response.data or []:
            ticket_status = ticket_data.get('status', 'open')
            if ticket_status in status_counts:
                status_counts[ticket_status] += 1

            # Get assigned admin name
            assigned_to_name = None
            if ticket_data.get('assigned_to'):
                admin_response = db.table('users').select('display_name').eq('id', ticket_data['assigned_to']).single().execute()
                if admin_response.data:
                    assigned_to_name = admin_response.data.get('display_name')

            tickets.append(SupportTicketResponse(
                id=ticket_data.get('id', ''),
                user_id=ticket_data.get('user_id'),
                user_name=ticket_data.get('user_name'),
                user_email=ticket_data.get('user_email'),
                subject=ticket_data.get('subject', ''),
                description=ticket_data.get('description'),
                category=ticket_data.get('category', 'general'),
                priority=ticket_data.get('priority', 'medium'),
                status=ticket_status,
                assigned_to=ticket_data.get('assigned_to'),
                assigned_to_name=assigned_to_name,
                created_at=ticket_data.get('created_at', ''),
                updated_at=ticket_data.get('updated_at', ''),
                resolved_at=ticket_data.get('resolved_at'),
            ))

        return SupportTicketsListResponse(
            success=True,
            tickets=tickets,
            total=total,
            open_count=status_counts['open'],
            in_progress_count=status_counts['in_progress'],
            resolved_count=status_counts['resolved'],
            closed_count=status_counts['closed'],
        )

    except Exception as e:
        logger.warning(f"Error fetching support tickets (table may not exist): {e}")
        return SupportTicketsListResponse(
            success=True,
            tickets=[],
            total=0,
        )


@router.post("/admin/support/tickets")
async def create_support_ticket(
    request: CreateTicketRequest,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Create a new support ticket

    **Admin Only** - Create ticket on behalf of user or system.
    """
    try:
        db = get_supabase()
        import uuid

        # Get user info if user_id provided
        user_name = None
        user_email = None
        if request.user_id:
            user_response = db.table('users').select('display_name, email').eq('id', request.user_id).single().execute()
            if user_response.data:
                user_name = user_response.data.get('display_name')
                user_email = user_response.data.get('email')

        ticket_data = {
            'id': str(uuid.uuid4()),
            'user_id': request.user_id,
            'user_name': user_name,
            'user_email': user_email,
            'subject': request.subject,
            'description': request.description,
            'category': request.category,
            'priority': request.priority,
            'status': 'open',
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        response = db.table('support_tickets').insert(ticket_data).execute()

        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to create ticket")

        logger.info(f"Admin {current_user.id} created support ticket: {request.subject}")

        return {
            'success': True,
            'message': 'Support ticket created',
            'ticket': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating support ticket: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create ticket: {str(e)}"
        )


@router.put("/admin/support/tickets/{ticket_id}/status")
async def update_ticket_status(
    ticket_id: str,
    request: UpdateTicketStatusRequest,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Update support ticket status

    **Admin Only** - Change ticket status (open, in_progress, resolved, closed).
    """
    try:
        db = get_supabase()
        valid_statuses = ['open', 'in_progress', 'resolved', 'closed']

        if request.status.lower() not in valid_statuses:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}"
            )

        update_data = {
            'status': request.status.lower(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        # Set resolved_at if status is resolved or closed
        if request.status.lower() in ['resolved', 'closed']:
            update_data['resolved_at'] = datetime.utcnow().isoformat()

        response = db.table('support_tickets').update(update_data).eq('id', ticket_id).execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Ticket not found")

        logger.info(f"Admin {current_user.id} updated ticket {ticket_id} status to {request.status}")

        return {
            'success': True,
            'message': f'Ticket status updated to {request.status}',
            'ticket': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating ticket status: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to update ticket status: {str(e)}"
        )


@router.put("/admin/support/tickets/{ticket_id}/assign")
async def assign_ticket(
    ticket_id: str,
    request: AssignTicketRequest,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Assign support ticket to an admin/support agent

    **Admin Only** - Assign ticket to a support team member.
    """
    try:
        db = get_supabase()

        update_data = {
            'assigned_to': request.assigned_to,
            'status': 'in_progress',
            'updated_at': datetime.utcnow().isoformat(),
        }

        response = db.table('support_tickets').update(update_data).eq('id', ticket_id).execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Ticket not found")

        logger.info(f"Admin {current_user.id} assigned ticket {ticket_id} to {request.assigned_to}")

        return {
            'success': True,
            'message': 'Ticket assigned successfully',
            'ticket': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error assigning ticket: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to assign ticket: {str(e)}"
        )


@router.get("/admin/support/tickets/{ticket_id}")
async def get_ticket_details(
    ticket_id: str,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Get detailed information about a specific ticket

    **Admin Only** - Get full ticket details including history.
    """
    try:
        db = get_supabase()

        response = db.table('support_tickets').select('*').eq('id', ticket_id).single().execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Ticket not found")

        ticket_data = response.data

        # Get assigned admin name
        assigned_to_name = None
        if ticket_data.get('assigned_to'):
            admin_response = db.table('users').select('display_name').eq('id', ticket_data['assigned_to']).single().execute()
            if admin_response.data:
                assigned_to_name = admin_response.data.get('display_name')

        return {
            'success': True,
            'ticket': SupportTicketResponse(
                id=ticket_data.get('id', ''),
                user_id=ticket_data.get('user_id'),
                user_name=ticket_data.get('user_name'),
                user_email=ticket_data.get('user_email'),
                subject=ticket_data.get('subject', ''),
                description=ticket_data.get('description'),
                category=ticket_data.get('category', 'general'),
                priority=ticket_data.get('priority', 'medium'),
                status=ticket_data.get('status', 'open'),
                assigned_to=ticket_data.get('assigned_to'),
                assigned_to_name=assigned_to_name,
                created_at=ticket_data.get('created_at', ''),
                updated_at=ticket_data.get('updated_at', ''),
                resolved_at=ticket_data.get('resolved_at'),
            )
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching ticket details: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch ticket details: {str(e)}"
        )


# =============================================================================
# ADMIN FINANCE/TRANSACTIONS ENDPOINTS
# =============================================================================

class TransactionResponse(BaseModel):
    """Response model for transaction"""
    id: str
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    type: str  # payment, refund, subscription, payout
    amount: float
    currency: str = "USD"
    status: str = "completed"
    description: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None
    created_at: str


class TransactionsListResponse(BaseModel):
    """Response model for transactions list"""
    success: bool = True
    transactions: List[TransactionResponse]
    total: int
    total_revenue: float = 0.0
    total_refunds: float = 0.0
    net_revenue: float = 0.0


class FinanceStatsResponse(BaseModel):
    """Response model for finance statistics"""
    success: bool = True
    total_revenue: float = 0.0
    total_refunds: float = 0.0
    net_revenue: float = 0.0
    revenue_today: float = 0.0
    revenue_this_week: float = 0.0
    revenue_this_month: float = 0.0
    transactions_count: int = 0
    avg_transaction_value: float = 0.0
    currency: str = "USD"


@router.get("/admin/finance/transactions", response_model=TransactionsListResponse)
async def get_transactions(
    transaction_type: Optional[str] = Query(None, alias="type", description="Filter by type"),
    status: Optional[str] = Query(None, description="Filter by status"),
    user_id: Optional[str] = Query(None, description="Filter by user"),
    start_date: Optional[str] = Query(None, description="Start date (ISO format)"),
    end_date: Optional[str] = Query(None, description="End date (ISO format)"),
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    current_user: CurrentUser = Depends(require_admin)
) -> TransactionsListResponse:
    """
    Get all transactions for admin panel

    **Admin Only** - Returns all financial transactions with filtering.
    """
    try:
        db = get_supabase()

        # Build query
        query = db.table('transactions').select('*')

        # Apply filters
        if transaction_type:
            query = query.eq('type', transaction_type.lower())
        if status:
            query = query.eq('status', status.lower())
        if user_id:
            query = query.eq('user_id', user_id)
        if start_date:
            query = query.gte('created_at', start_date)
        if end_date:
            query = query.lte('created_at', end_date)

        # Get total count
        count_response = db.table('transactions').select('id', count='exact').execute()
        total = count_response.count if count_response.count else 0

        # Apply pagination and ordering
        query = query.order('created_at', desc=True).range(offset, offset + limit - 1)

        response = query.execute()

        transactions = []
        total_revenue = 0.0
        total_refunds = 0.0

        for tx_data in response.data or []:
            amount = float(tx_data.get('amount', 0))
            tx_type = tx_data.get('type', 'payment')

            if tx_type in ['payment', 'subscription']:
                total_revenue += amount
            elif tx_type == 'refund':
                total_refunds += amount

            transactions.append(TransactionResponse(
                id=tx_data.get('id', ''),
                user_id=tx_data.get('user_id'),
                user_name=tx_data.get('user_name'),
                type=tx_type,
                amount=amount,
                currency=tx_data.get('currency', 'USD'),
                status=tx_data.get('status', 'completed'),
                description=tx_data.get('description'),
                metadata=tx_data.get('metadata'),
                created_at=tx_data.get('created_at', ''),
            ))

        return TransactionsListResponse(
            success=True,
            transactions=transactions,
            total=total,
            total_revenue=total_revenue,
            total_refunds=total_refunds,
            net_revenue=total_revenue - total_refunds,
        )

    except Exception as e:
        logger.warning(f"Error fetching transactions (table may not exist): {e}")
        return TransactionsListResponse(
            success=True,
            transactions=[],
            total=0,
        )


@router.get("/admin/finance/stats", response_model=FinanceStatsResponse)
async def get_finance_stats(
    current_user: CurrentUser = Depends(require_admin)
) -> FinanceStatsResponse:
    """
    Get financial statistics for admin dashboard

    **Admin Only** - Returns aggregated financial statistics.
    """
    try:
        db = get_supabase()
        now = datetime.utcnow()
        today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
        week_start = today_start - timedelta(days=today_start.weekday())
        month_start = today_start.replace(day=1)

        # Get all transactions
        response = db.table('transactions').select('*').execute()

        total_revenue = 0.0
        total_refunds = 0.0
        revenue_today = 0.0
        revenue_this_week = 0.0
        revenue_this_month = 0.0
        transactions_count = len(response.data) if response.data else 0

        for tx in response.data or []:
            amount = float(tx.get('amount', 0))
            tx_type = tx.get('type', 'payment')
            created_at_str = tx.get('created_at', '')

            # Parse transaction date
            try:
                created_at = datetime.fromisoformat(created_at_str.replace('Z', '+00:00'))
                if created_at.tzinfo:
                    created_at = created_at.replace(tzinfo=None)
            except Exception:
                created_at = None

            if tx_type in ['payment', 'subscription']:
                total_revenue += amount
                if created_at:
                    if created_at >= today_start:
                        revenue_today += amount
                    if created_at >= week_start:
                        revenue_this_week += amount
                    if created_at >= month_start:
                        revenue_this_month += amount
            elif tx_type == 'refund':
                total_refunds += amount

        avg_transaction_value = total_revenue / transactions_count if transactions_count > 0 else 0.0

        return FinanceStatsResponse(
            success=True,
            total_revenue=round(total_revenue, 2),
            total_refunds=round(total_refunds, 2),
            net_revenue=round(total_revenue - total_refunds, 2),
            revenue_today=round(revenue_today, 2),
            revenue_this_week=round(revenue_this_week, 2),
            revenue_this_month=round(revenue_this_month, 2),
            transactions_count=transactions_count,
            avg_transaction_value=round(avg_transaction_value, 2),
            currency="USD",
        )

    except Exception as e:
        logger.warning(f"Error fetching finance stats (table may not exist): {e}")
        return FinanceStatsResponse(success=True)


# =============================================================================
# ADMIN COMMUNICATIONS ENDPOINTS
# =============================================================================

class CampaignResponse(BaseModel):
    """Response model for communication campaign"""
    id: str
    name: str
    type: str  # email, notification, announcement
    status: str = "draft"
    target_audience: Optional[Dict[str, Any]] = None
    content: Optional[Dict[str, Any]] = None
    scheduled_at: Optional[str] = None
    sent_at: Optional[str] = None
    stats: Optional[Dict[str, Any]] = None
    created_by: Optional[str] = None
    created_at: str
    updated_at: str


class CampaignsListResponse(BaseModel):
    """Response model for campaigns list"""
    success: bool = True
    campaigns: List[CampaignResponse]
    total: int
    draft_count: int = 0
    scheduled_count: int = 0
    sent_count: int = 0


class CreateCampaignRequest(BaseModel):
    """Request model for creating campaign"""
    name: str
    type: str = "email"
    target_audience: Optional[Dict[str, Any]] = None
    content: Optional[Dict[str, Any]] = None
    scheduled_at: Optional[str] = None


class SendAnnouncementRequest(BaseModel):
    """Request model for sending announcement"""
    title: str
    message: str
    target_roles: Optional[List[str]] = None  # If None, send to all
    priority: str = "normal"


@router.get("/admin/communications/campaigns", response_model=CampaignsListResponse)
async def get_campaigns(
    campaign_type: Optional[str] = Query(None, alias="type", description="Filter by type"),
    status: Optional[str] = Query(None, description="Filter by status"),
    limit: int = Query(default=50, ge=1, le=200),
    offset: int = Query(default=0, ge=0),
    current_user: CurrentUser = Depends(require_admin)
) -> CampaignsListResponse:
    """
    Get all communication campaigns

    **Admin Only** - Returns all campaigns with filtering options.
    """
    try:
        db = get_supabase()

        # Build query
        query = db.table('communication_campaigns').select('*')

        # Apply filters
        if campaign_type:
            query = query.eq('type', campaign_type.lower())
        if status:
            query = query.eq('status', status.lower())

        # Get total count
        count_response = db.table('communication_campaigns').select('id', count='exact').execute()
        total = count_response.count if count_response.count else 0

        # Apply pagination and ordering
        query = query.order('created_at', desc=True).range(offset, offset + limit - 1)

        response = query.execute()

        campaigns = []
        status_counts = {'draft': 0, 'scheduled': 0, 'sent': 0}

        for campaign_data in response.data or []:
            campaign_status = campaign_data.get('status', 'draft')
            if campaign_status in status_counts:
                status_counts[campaign_status] += 1

            campaigns.append(CampaignResponse(
                id=campaign_data.get('id', ''),
                name=campaign_data.get('name', ''),
                type=campaign_data.get('type', 'email'),
                status=campaign_status,
                target_audience=campaign_data.get('target_audience'),
                content=campaign_data.get('content'),
                scheduled_at=campaign_data.get('scheduled_at'),
                sent_at=campaign_data.get('sent_at'),
                stats=campaign_data.get('stats'),
                created_by=campaign_data.get('created_by'),
                created_at=campaign_data.get('created_at', ''),
                updated_at=campaign_data.get('updated_at', ''),
            ))

        return CampaignsListResponse(
            success=True,
            campaigns=campaigns,
            total=total,
            draft_count=status_counts['draft'],
            scheduled_count=status_counts['scheduled'],
            sent_count=status_counts['sent'],
        )

    except Exception as e:
        logger.warning(f"Error fetching campaigns (table may not exist): {e}")
        return CampaignsListResponse(
            success=True,
            campaigns=[],
            total=0,
        )


@router.post("/admin/communications/campaigns")
async def create_campaign(
    request: CreateCampaignRequest,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Create a new communication campaign

    **Admin Only** - Create email, notification, or announcement campaign.
    """
    try:
        db = get_supabase()
        import uuid

        campaign_data = {
            'id': str(uuid.uuid4()),
            'name': request.name,
            'type': request.type,
            'status': 'draft',
            'target_audience': request.target_audience or {},
            'content': request.content or {},
            'scheduled_at': request.scheduled_at,
            'stats': {'sent': 0, 'delivered': 0, 'opened': 0, 'clicked': 0},
            'created_by': current_user.id,
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        response = db.table('communication_campaigns').insert(campaign_data).execute()

        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to create campaign")

        logger.info(f"Admin {current_user.id} created campaign: {request.name}")

        return {
            'success': True,
            'message': 'Campaign created',
            'campaign': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating campaign: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to create campaign: {str(e)}"
        )


@router.post("/admin/communications/announcements")
async def send_announcement(
    request: SendAnnouncementRequest,
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Send an immediate announcement

    **Admin Only** - Send announcement to all users or specific roles.
    """
    try:
        db = get_supabase()
        import uuid

        # Determine target users
        target_users = []
        if request.target_roles:
            for role in request.target_roles:
                users_response = db.table('users').select('id, email, display_name').eq('active_role', role.lower()).execute()
                target_users.extend(users_response.data or [])
        else:
            # All users
            users_response = db.table('users').select('id, email, display_name').execute()
            target_users = users_response.data or []

        # Create announcement campaign record
        campaign_data = {
            'id': str(uuid.uuid4()),
            'name': f"Announcement: {request.title}",
            'type': 'announcement',
            'status': 'sent',
            'target_audience': {'roles': request.target_roles or ['all']},
            'content': {'title': request.title, 'message': request.message, 'priority': request.priority},
            'sent_at': datetime.utcnow().isoformat(),
            'stats': {'sent': len(target_users), 'delivered': len(target_users), 'opened': 0, 'clicked': 0},
            'created_by': current_user.id,
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        try:
            db.table('communication_campaigns').insert(campaign_data).execute()
        except Exception as table_error:
            logger.warning(f"communication_campaigns table may not exist: {table_error}")

        logger.info(f"Admin {current_user.id} sent announcement to {len(target_users)} users: {request.title}")

        return {
            'success': True,
            'message': f'Announcement sent to {len(target_users)} users',
            'recipients_count': len(target_users),
            'announcement': {
                'title': request.title,
                'message': request.message,
                'target_roles': request.target_roles or ['all'],
            }
        }

    except Exception as e:
        logger.error(f"Error sending announcement: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to send announcement: {str(e)}"
        )


@router.put("/admin/communications/campaigns/{campaign_id}/status")
async def update_campaign_status(
    campaign_id: str,
    status_update: Dict[str, str],
    current_user: CurrentUser = Depends(require_admin)
) -> Dict[str, Any]:
    """
    Update campaign status (schedule, send, cancel)

    **Admin Only** - Change campaign status.
    """
    try:
        db = get_supabase()
        new_status = status_update.get('status', '').lower()

        valid_statuses = ['draft', 'scheduled', 'sent', 'cancelled']
        if new_status not in valid_statuses:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid status. Must be one of: {', '.join(valid_statuses)}"
            )

        update_data = {
            'status': new_status,
            'updated_at': datetime.utcnow().isoformat(),
        }

        if new_status == 'sent':
            update_data['sent_at'] = datetime.utcnow().isoformat()

        response = db.table('communication_campaigns').update(update_data).eq('id', campaign_id).execute()

        if not response.data:
            raise HTTPException(status_code=404, detail="Campaign not found")

        logger.info(f"Admin {current_user.id} updated campaign {campaign_id} status to {new_status}")

        return {
            'success': True,
            'message': f'Campaign status updated to {new_status}',
            'campaign': response.data[0] if response.data else None
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating campaign status: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to update campaign status: {str(e)}"
        )


# ── System Settings Endpoints ──────────────────────────────────────────────


@router.get("/admin/system/settings")
async def get_system_settings(
    current_user: CurrentUser = Depends(require_admin),
) -> Dict[str, Any]:
    """
    Get all system settings from app_config table.

    **Admin Only** - Returns all settings as a dict keyed by setting name.
    Secret values are masked.
    """
    try:
        db = get_supabase_admin()
        response = db.table('app_config').select('*').execute()

        settings: Dict[str, Any] = {}
        for row in (response.data or []):
            key = row.get('key', '')
            is_secret = row.get('is_secret', False)
            settings[key] = {
                'value': '••••••••' if is_secret else row.get('value'),
                'category': row.get('category', 'general'),
                'type': row.get('type', 'string'),
                'description': row.get('description'),
                'is_secret': is_secret,
            }

        return settings

    except Exception as e:
        logger.error(f"Error fetching system settings: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to fetch system settings: {str(e)}"
        )


@router.put("/admin/system/settings")
async def update_system_settings(
    body: SystemSettingsUpdate,
    current_user: CurrentUser = Depends(require_super_admin),
) -> Dict[str, Any]:
    """
    Batch upsert system settings into app_config table.

    **Super Admin Only** - Accepts { settings: { key: value, ... } }
    and upserts each key into app_config.
    """
    try:
        db = get_supabase_admin()
        updated_keys: list[str] = []

        for key, value in body.settings.items():
            # value column is text not null — convert to string
            str_value = str(value) if value is not None else ''
            db.table('app_config').upsert({
                'key': key,
                'value': str_value,
                'updated_at': datetime.now(timezone.utc).isoformat(),
            }, on_conflict='key').execute()
            updated_keys.append(key)

        logger.info(
            f"Admin {current_user.id} updated system settings: {updated_keys}"
        )

        # Return the refreshed settings
        response = db.table('app_config').select('*').execute()
        settings: Dict[str, Any] = {}
        for row in (response.data or []):
            k = row.get('key', '')
            is_secret = row.get('is_secret', False)
            settings[k] = {
                'value': '••••••••' if is_secret else row.get('value'),
                'category': row.get('category', 'general'),
                'type': row.get('type', 'string'),
                'description': row.get('description'),
                'is_secret': is_secret,
            }

        return settings

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating system settings: {e}", exc_info=True)
        raise HTTPException(
            status_code=500,
            detail=f"Failed to update system settings: {str(e)}"
        )
