"""
Cookie Consent API Endpoints
Handles user cookie consent preferences
"""
from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
import logging

from app.database.config import get_supabase, get_supabase_admin
from app.utils.security import get_current_user, get_optional_user, CurrentUser, require_admin

logger = logging.getLogger(__name__)

router = APIRouter()


class ConsentRequest(BaseModel):
    """Cookie consent request"""
    necessary: bool = True
    preferences: bool = False
    analytics: bool = False
    marketing: bool = False
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None


class ConsentResponse(BaseModel):
    """Cookie consent response"""
    id: str
    user_id: str
    necessary: bool
    preferences: bool
    analytics: bool
    marketing: bool
    consent_date: datetime
    last_updated: datetime


@router.post("/consent")
async def save_consent(
    consent_data: ConsentRequest,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Save user's cookie consent preferences

    **Requires:** Authentication

    **Request Body:**
    - necessary: Essential cookies (always true)
    - preferences: Functional/preference cookies
    - analytics: Analytics/statistics cookies
    - marketing: Marketing/advertising cookies
    - ip_address: Optional IP address for audit
    - user_agent: Optional user agent for audit

    **Returns:**
    - Saved consent data (201 for new, 200 for update)
    """
    try:
        db = get_supabase_admin()  # Use admin client for consent data
        user_id = current_user.id

        now = datetime.utcnow().isoformat()

        consent_record = {
            'user_id': user_id,
            'necessary': consent_data.necessary,
            'preferences': consent_data.preferences,
            'analytics': consent_data.analytics,
            'marketing': consent_data.marketing,
            'consent_date': now,
            'last_updated': now,
            'ip_address': consent_data.ip_address,
            'user_agent': consent_data.user_agent,
        }

        # Check if consent already exists
        existing = db.table('cookie_consents').select('id').eq('user_id', user_id).execute()

        is_update = existing.data and len(existing.data) > 0

        if is_update:
            # Update existing consent
            response = db.table('cookie_consents').update({
                'necessary': consent_data.necessary,
                'preferences': consent_data.preferences,
                'analytics': consent_data.analytics,
                'marketing': consent_data.marketing,
                'last_updated': now,
                'ip_address': consent_data.ip_address,
                'user_agent': consent_data.user_agent,
            }).eq('user_id', user_id).execute()
        else:
            # Insert new consent
            response = db.table('cookie_consents').insert(consent_record).execute()

        if not response.data:
            raise Exception("Failed to save consent")

        data = response.data[0]
        logger.info(f"Cookie consent {'updated' if is_update else 'created'} for user: {user_id}")

        result = ConsentResponse(
            id=data['id'],
            user_id=data['user_id'],
            necessary=data['necessary'],
            preferences=data['preferences'],
            analytics=data['analytics'],
            marketing=data['marketing'],
            consent_date=data['consent_date'],
            last_updated=data['last_updated'],
        )

        # Return 200 for update, 201 for create
        return JSONResponse(
            content=result.model_dump(mode='json'),
            status_code=200 if is_update else 201
        )

    except Exception as e:
        logger.error(f"Save consent error: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


@router.get("/consent")
async def get_consent(
    current_user: CurrentUser = Depends(get_current_user)
) -> Optional[ConsentResponse]:
    """
    Get user's current cookie consent preferences

    **Requires:** Authentication

    **Returns:**
    - User's consent data or null if not set
    """
    try:
        db = get_supabase_admin()  # Use admin client for consent data
        user_id = current_user.id

        response = db.table('cookie_consents').select('*').eq('user_id', user_id).execute()

        if not response.data or len(response.data) == 0:
            return None

        data = response.data[0]

        return ConsentResponse(
            id=data['id'],
            user_id=data['user_id'],
            necessary=data['necessary'],
            preferences=data['preferences'],
            analytics=data['analytics'],
            marketing=data['marketing'],
            consent_date=data['consent_date'],
            last_updated=data['last_updated'],
        )

    except Exception as e:
        logger.error(f"Get consent error: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )


def _derive_consent_status(row: dict) -> str:
    """Derive consent status string from DB columns."""
    prefs = row.get('preferences', False)
    analytics = row.get('analytics', False)
    marketing = row.get('marketing', False)
    if prefs and analytics and marketing:
        return "accepted"
    if not prefs and not analytics and not marketing:
        return "declined"
    return "customized"


@router.get("/consent/admin/statistics")
async def get_consent_statistics(
    current_user: CurrentUser = Depends(require_admin),
):
    """
    Get aggregated cookie consent statistics for the admin dashboard.

    **Requires:** Admin authentication
    """
    try:
        db = get_supabase_admin()  # Use admin client for consent data

        # Get total users
        users_result = db.table('users').select('id', count='exact').execute()
        total_users = users_result.count if users_result.count is not None else 0

        # Get all consent records
        consents_result = db.table('cookie_consents').select('*').execute()
        consents = consents_result.data or []

        total_consented = len(consents)

        # Classify each consent record
        accepted_all = 0
        customized = 0
        declined = 0
        category_counts = {
            'essential': 0,
            'functional': 0,
            'analytics': 0,
            'marketing': 0,
        }

        for row in consents:
            s = _derive_consent_status(row)
            if s == "accepted":
                accepted_all += 1
            elif s == "customized":
                customized += 1
            else:
                declined += 1

            # Count per-category acceptance
            if row.get('necessary', False):
                category_counts['essential'] += 1
            if row.get('preferences', False):
                category_counts['functional'] += 1
            if row.get('analytics', False):
                category_counts['analytics'] += 1
            if row.get('marketing', False):
                category_counts['marketing'] += 1

        not_asked = total_users - total_consented

        # Recent activity: last 10 consent changes ordered by last_updated desc
        recent_result = db.table('cookie_consents').select(
            'user_id, last_updated, preferences, analytics, marketing'
        ).order('last_updated', desc=True).limit(10).execute()

        recent_activity: List[dict] = []
        for row in (recent_result.data or []):
            s = _derive_consent_status(row)
            action_map = {
                "accepted": "Accepted all cookies",
                "customized": "Customized preferences",
                "declined": "Declined cookies",
            }
            recent_activity.append({
                "userId": row['user_id'],
                "action": action_map.get(s, s),
                "timestamp": row.get('last_updated', ''),
            })

        return {
            "totalUsers": total_users,
            "totalConsented": total_consented,
            "acceptedAll": accepted_all,
            "customized": customized,
            "declined": declined,
            "notAsked": not_asked,
            "categoryBreakdown": category_counts,
            "recentActivity": recent_activity,
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Get consent statistics error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        )


@router.get("/consent/admin/users")
async def get_consent_users(
    search: Optional[str] = Query(None, description="Search by user ID"),
    consent_status: Optional[str] = Query(None, alias="status", description="Filter by status: accepted, customized, declined"),
    current_user: CurrentUser = Depends(require_admin),
):
    """
    Get list of user consent records for the admin dashboard.

    **Requires:** Admin authentication
    """
    try:
        db = get_supabase_admin()  # Use admin client for consent data

        # Fetch all consent records joined with user display names
        query = db.table('cookie_consents').select(
            'user_id, necessary, preferences, analytics, marketing, consent_date, last_updated, users!cookie_consents_user_id_fkey(display_name)'
        )

        if search:
            query = query.ilike('user_id', f'%{search}%')

        result = query.order('last_updated', desc=True).execute()
        rows = result.data or []

        users_list: List[dict] = []
        for row in rows:
            s = _derive_consent_status(row)

            # Apply status filter in Python (since it's a derived value)
            if consent_status and s != consent_status:
                continue

            # Extract display name from joined users table
            user_data = row.get('users') or {}
            display_name = ''
            if isinstance(user_data, dict):
                display_name = user_data.get('display_name', '') or ''
            elif isinstance(user_data, list) and len(user_data) > 0:
                display_name = user_data[0].get('display_name', '') or ''

            users_list.append({
                "userId": row['user_id'],
                "displayName": display_name,
                "status": s,
                "timestamp": row.get('last_updated', row.get('consent_date', '')),
                "consentDate": row.get('consent_date', ''),
                "lastUpdated": row.get('last_updated', ''),
                "categories": {
                    "essential": row.get('necessary', True),
                    "functional": row.get('preferences', False),
                    "analytics": row.get('analytics', False),
                    "marketing": row.get('marketing', False),
                },
            })

        return {
            "users": users_list,
            "total": len(users_list),
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Get consent users error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e),
        )
