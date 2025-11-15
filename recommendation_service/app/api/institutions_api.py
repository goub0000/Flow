"""
Institutions API Endpoints
Handles fetching registered institutions (users with 'institution' role)
"""
from fastapi import APIRouter, Depends, HTTPException, Query, status
from typing import List, Optional
import logging

from app.database.config import get_supabase
from app.utils.security import get_current_user, CurrentUser
from pydantic import BaseModel

logger = logging.getLogger(__name__)
router = APIRouter()


class InstitutionResponse(BaseModel):
    """Institution response model"""
    id: str
    name: str
    email: str
    phone_number: Optional[str] = None
    photo_url: Optional[str] = None
    created_at: Optional[str] = None
    is_verified: bool = False
    programs_count: int = 0
    courses_count: int = 0

    class Config:
        from_attributes = True


class InstitutionsListResponse(BaseModel):
    """Institutions list with pagination"""
    institutions: List[InstitutionResponse]
    total: int
    page: int
    page_size: int


@router.get("/institutions", response_model=InstitutionsListResponse)
async def get_institutions(
    search: Optional[str] = Query(None, description="Search by institution name or email"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    is_verified: Optional[bool] = Query(None, description="Filter by verification status"),
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get list of registered institutions (users with 'institution' role)

    This endpoint returns only institutions that are registered users in the Flow platform,
    NOT the universities from the recommendation database.

    **Use this for:**
    - Browsing institutions to apply to
    - Selecting institution for creating applications
    - Institution directory

    **Query Parameters:**
    - search: Search by name or email
    - page: Page number (starts at 1)
    - page_size: Number of items per page (max 100)
    - is_verified: Filter by email verification status

    **Returns:**
    - List of registered institutions with their basic info
    - Total count for pagination
    """
    try:
        db = get_supabase()

        # Calculate offset for pagination
        offset = (page - 1) * page_size

        # Build query - fetch users with 'institution' role
        query = db.table('users').select(
            'id, display_name, email, phone_number, photo_url, '
            'created_at, email_verified, metadata',
            count='exact'
        ).in_('active_role', ['institution']).or_(
            'available_roles.cs.{institution}'
        )

        # Apply search filter
        if search:
            search_lower = search.lower()
            # Note: Supabase doesn't support case-insensitive search directly,
            # we'll filter on the backend side after fetching
            pass

        # Apply verification filter
        if is_verified is not None:
            query = query.eq('email_verified', is_verified)

        # Apply ordering
        query = query.order('display_name', desc=False)

        # Apply pagination
        query = query.range(offset, offset + page_size - 1)

        # Execute query
        response = query.execute()

        institutions_data = response.data
        total = response.count if hasattr(response, 'count') else len(institutions_data)

        # Apply search filter on backend if search is provided
        if search:
            search_lower = search.lower()
            institutions_data = [
                inst for inst in institutions_data
                if search_lower in (inst.get('display_name', '') or '').lower()
                or search_lower in (inst.get('email', '') or '').lower()
            ]
            total = len(institutions_data)

        # Get program counts for each institution
        institutions = []
        for inst in institutions_data:
            # Count programs
            programs_response = db.table('programs').select(
                'id', count='exact'
            ).eq('institution_id', inst['id']).execute()
            programs_count = programs_response.count if hasattr(programs_response, 'count') else 0

            institutions.append(InstitutionResponse(
                id=inst['id'],
                name=inst.get('display_name', 'Unnamed Institution'),
                email=inst['email'],
                phone_number=inst.get('phone_number'),
                photo_url=inst.get('photo_url'),
                created_at=inst.get('created_at'),
                is_verified=inst.get('email_verified', False),
                programs_count=programs_count,
                courses_count=0  # Courses removed from system
            ))

        logger.info(
            f"User {current_user.id} fetched {len(institutions)} institutions "
            f"(page {page}, total {total})"
        )

        return InstitutionsListResponse(
            institutions=institutions,
            total=total,
            page=page,
            page_size=page_size
        )

    except Exception as e:
        logger.error(f"Error fetching institutions: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch institutions: {str(e)}"
        )


@router.get("/institutions/{institution_id}", response_model=InstitutionResponse)
async def get_institution(
    institution_id: str,
    current_user: CurrentUser = Depends(get_current_user)
):
    """
    Get a specific institution by ID

    **Path Parameters:**
    - institution_id: UUID of the institution user

    **Returns:**
    - Institution details including programs and courses count
    """
    try:
        db = get_supabase()

        # Fetch institution
        response = db.table('users').select(
            'id, display_name, email, phone_number, photo_url, '
            'created_at, email_verified, active_role, available_roles'
        ).eq('id', institution_id).execute()

        if not response.data:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"Institution with ID {institution_id} not found"
            )

        inst = response.data[0]

        # Verify it's an institution
        if inst.get('active_role') != 'institution' and 'institution' not in inst.get('available_roles', []):
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="The specified user is not an institution"
            )

        # Count programs
        programs_response = db.table('programs').select(
            'id', count='exact'
        ).eq('institution_id', institution_id).execute()
        programs_count = programs_response.count if hasattr(programs_response, 'count') else 0

        return InstitutionResponse(
            id=inst['id'],
            name=inst.get('display_name', 'Unnamed Institution'),
            email=inst['email'],
            phone_number=inst.get('phone_number'),
            photo_url=inst.get('photo_url'),
            created_at=inst.get('created_at'),
            is_verified=inst.get('email_verified', False),
            programs_count=programs_count,
            courses_count=0  # Courses removed from system
        )

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching institution {institution_id}: {str(e)}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch institution: {str(e)}"
        )
