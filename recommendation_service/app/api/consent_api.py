"""
Cookie Consent API Endpoints
Handles user cookie consent preferences
"""
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
import logging

from app.database.config import get_supabase
from app.utils.security import get_current_user, get_optional_user, CurrentUser

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


@router.post("/consent", status_code=status.HTTP_201_CREATED)
async def save_consent(
    consent_data: ConsentRequest,
    current_user: CurrentUser = Depends(get_current_user)
) -> ConsentResponse:
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
    - Saved consent data
    """
    try:
        db = get_supabase()
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

        if existing.data and len(existing.data) > 0:
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
        logger.info(f"Cookie consent saved for user: {user_id}")

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
        db = get_supabase()
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
