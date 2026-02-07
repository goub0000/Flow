"""
Programs API endpoints
Cloud-based institutional programs management
"""
from fastapi import APIRouter, HTTPException, Query, Path
from typing import List, Optional
from uuid import UUID
from datetime import datetime
from app.database.config import get_supabase, get_supabase_admin
from app.schemas.program import (
    ProgramCreate,
    ProgramUpdate,
    ProgramResponse,
    ProgramListResponse,
    ProgramStatistics
)
import logging

router = APIRouter()
logger = logging.getLogger(__name__)


def _add_computed_fields(program: dict) -> dict:
    """Add computed fields required by ProgramResponse schema"""
    # Convert ID to string (handles both integer and UUID IDs)
    if 'id' in program and program['id'] is not None:
        program['id'] = str(program['id'])

    # Convert institution_id to string if it exists
    if 'institution_id' in program and program['institution_id'] is not None:
        program['institution_id'] = str(program['institution_id'])

    # Convert fee to float (Supabase may return it as string/Decimal)
    if 'fee' in program and program['fee'] is not None:
        program['fee'] = float(program['fee'])

    # Safely compute available_slots and fill_percentage
    max_students = program.get('max_students', 0)
    enrolled_students = program.get('enrolled_students', 0)

    program['available_slots'] = max_students - enrolled_students
    program['fill_percentage'] = float(
        (enrolled_students / max_students * 100)
        if max_students > 0 else 0
    )

    # If updated_at doesn't exist in database, use created_at
    if 'updated_at' not in program or program['updated_at'] is None:
        program['updated_at'] = program.get('created_at')

    # Convert datetime strings to datetime objects (Pydantic expects datetime objects)
    # Supabase returns datetime fields as ISO strings, we need to parse them
    for field in ['created_at', 'updated_at', 'application_deadline', 'start_date']:
        if field in program and program[field] is not None:
            if isinstance(program[field], str):
                try:
                    # Parse ISO string to datetime object
                    program[field] = datetime.fromisoformat(program[field].replace('Z', '+00:00'))
                except (ValueError, AttributeError):
                    # If parsing fails, leave as is
                    pass

    return program


@router.get("/programs", response_model=ProgramListResponse)
async def get_programs(
    institution_id: Optional[UUID] = None,
    category: Optional[str] = None,
    level: Optional[str] = None,
    is_active: Optional[bool] = None,
    search: Optional[str] = None,
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=20, le=100)
):
    """
    Get programs with optional filtering

    NOTE: Only returns programs from REGISTERED institutions (users with role='institution').
    Recommendation/informational universities are excluded.

    Query Parameters:
    - institution_id: Filter by institution
    - category: Filter by category
    - level: Filter by academic level
    - is_active: Filter by active status
    - search: Search in name and description
    - skip: Pagination offset
    - limit: Pagination limit (max 100)
    """
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # CRITICAL: First, get all registered institution user IDs from auth.users
        # This ensures we only show programs from registered institutions,
        # NOT from recommendation universities
        try:
            # Query auth.users table for users with institution role
            auth_response = db.rpc('get_institution_user_ids').execute()

            if not auth_response.data:
                # Fallback: If RPC doesn't exist, use raw metadata query
                # Get users where raw_user_meta_data->'role' = 'institution'
                users_response = db.table('auth.users').select('id').execute()
                registered_institution_ids = [u['id'] for u in users_response.data if u.get('raw_user_meta_data', {}).get('role') == 'institution']
            else:
                # Extract user_id from the response (function returns TABLE(user_id UUID))
                registered_institution_ids = [row['user_id'] for row in auth_response.data if row.get('user_id')]

        except Exception as auth_error:
            logger.warning(f"Could not fetch registered institutions: {auth_error}")
            # Fallback: At minimum, include the known registered institution
            registered_institution_ids = ['8099317e-c970-4b13-9417-5bc891fa44a0']

        # Convert to strings for comparison
        registered_institution_ids_str = [str(uid) for uid in registered_institution_ids]

        if not registered_institution_ids_str:
            # No registered institutions found
            return {
                "total": 0,
                "programs": []
            }

        # Start query - ONLY from registered institutions
        query = db.table('programs').select('*', count='exact')

        # CRITICAL FILTER: Only show programs from registered institutions
        query = query.in_('institution_id', registered_institution_ids_str)

        # Apply additional filters
        if institution_id:
            query = query.eq('institution_id', str(institution_id))

        if category:
            query = query.eq('category', category)

        if level:
            query = query.eq('level', level)

        if is_active is not None:
            query = query.eq('is_active', is_active)

        if search:
            query = query.or_(f'name.ilike.%{search}%,description.ilike.%{search}%')

        # Apply pagination
        query = query.range(skip, skip + limit - 1)

        # Execute query
        result = query.execute()

        # Add computed fields to all programs
        programs_with_computed = [_add_computed_fields(p) for p in result.data]

        return {
            "total": result.count if result.count else 0,
            "programs": programs_with_computed
        }

    except Exception as e:
        logger.error(f"Error fetching programs: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to fetch programs: {str(e)}")


@router.get("/programs/statistics/overview", response_model=ProgramStatistics)
async def get_program_statistics(institution_id: Optional[UUID] = None):
    """Get program statistics, optionally filtered by institution"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Build query
        query = db.table('programs').select('*')
        if institution_id:
            query = query.eq('institution_id', str(institution_id))

        result = query.execute()
        programs = result.data

        # Calculate statistics
        total_programs = len(programs)
        active_programs = sum(1 for p in programs if p['is_active'])
        total_capacity = sum(p['max_students'] for p in programs)
        total_enrolled = sum(p['enrolled_students'] for p in programs)
        available_spots = total_capacity - total_enrolled
        occupancy_rate = (total_enrolled / total_capacity * 100) if total_capacity > 0 else 0

        return {
            "total_programs": total_programs,
            "active_programs": active_programs,
            "inactive_programs": total_programs - active_programs,
            "total_capacity": total_capacity,
            "total_enrolled": total_enrolled,
            "available_spots": available_spots,
            "occupancy_rate": round(occupancy_rate, 2)
        }

    except Exception as e:
        logger.error(f"Error calculating program statistics: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to calculate statistics: {str(e)}")


@router.get("/programs/{program_id}", response_model=ProgramResponse)
async def get_program(program_id: str = Path(..., description="Program ID", pattern="^[a-zA-Z0-9_-]+$")):
    """Get a specific program by ID"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        result = db.table('programs').select('*').eq('id', str(program_id)).execute()

        if not result.data:
            raise HTTPException(status_code=404, detail="Program not found")

        return _add_computed_fields(result.data[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to fetch program: {str(e)}")


@router.post("/programs", response_model=ProgramResponse, status_code=201)
async def create_program(program: ProgramCreate):
    """Create a new program"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Convert Pydantic model to dict
        program_data = program.model_dump()

        # Convert UUID to string for Supabase
        program_data['institution_id'] = str(program_data['institution_id'])

        # Convert Decimal to float for JSON serialization
        program_data['fee'] = float(program_data['fee'])

        # Convert datetime objects to ISO strings for Supabase
        for field in ['application_deadline', 'start_date']:
            if field in program_data and program_data[field] is not None:
                if isinstance(program_data[field], datetime):
                    program_data[field] = program_data[field].isoformat()

        # Insert into database
        result = db.table('programs').insert(program_data).execute()

        if not result.data:
            raise HTTPException(status_code=500, detail="Failed to create program")

        # Get the created program and add computed fields
        created_program = result.data[0]
        return _add_computed_fields(created_program)

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating program: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create program: {str(e)}")


@router.put("/programs/{program_id}", response_model=ProgramResponse)
async def update_program(program_id: str = Path(..., description="Program ID", pattern="^[a-zA-Z0-9_-]+$"), program: ProgramUpdate = ...):
    """Update an existing program"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Check if program exists
        existing = db.table('programs').select('id').eq('id', str(program_id)).execute()
        if not existing.data:
            raise HTTPException(status_code=404, detail="Program not found")

        # Convert Pydantic model to dict, excluding unset values
        update_data = program.model_dump(exclude_unset=True)

        # Convert UUID to string if present
        if 'institution_id' in update_data:
            update_data['institution_id'] = str(update_data['institution_id'])

        # Convert Decimal to float if present
        if 'fee' in update_data:
            update_data['fee'] = float(update_data['fee'])

        # Convert datetime objects to ISO strings for Supabase
        for field in ['application_deadline', 'start_date']:
            if field in update_data and update_data[field] is not None:
                if isinstance(update_data[field], datetime):
                    update_data[field] = update_data[field].isoformat()

        # Update in database
        result = db.table('programs').update(update_data).eq('id', str(program_id)).execute()

        if not result.data:
            raise HTTPException(status_code=500, detail="Failed to update program")

        return _add_computed_fields(result.data[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update program: {str(e)}")


@router.delete("/programs/{program_id}", status_code=204)
async def delete_program(program_id: str = Path(..., description="Program ID", pattern="^[a-zA-Z0-9_-]+$")):
    """Delete a program"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Check if program exists
        existing = db.table('programs').select('id').eq('id', str(program_id)).execute()
        if not existing.data:
            raise HTTPException(status_code=404, detail="Program not found")

        # Delete from database
        db.table('programs').delete().eq('id', str(program_id)).execute()

        return None

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to delete program: {str(e)}")


@router.patch("/programs/{program_id}/toggle-status", response_model=ProgramResponse)
async def toggle_program_status(program_id: str = Path(..., description="Program ID", pattern="^[a-zA-Z0-9_-]+$")):
    """Toggle program active status"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Get current status
        result = db.table('programs').select('is_active').eq('id', str(program_id)).execute()
        if not result.data:
            raise HTTPException(status_code=404, detail="Program not found")

        current_status = result.data[0]['is_active']

        # Toggle status
        update_result = db.table('programs').update({
            'is_active': not current_status
        }).eq('id', str(program_id)).execute()

        return _add_computed_fields(update_result.data[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error toggling program status {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to toggle status: {str(e)}")


@router.get("/institutions/{institution_id}/programs", response_model=ProgramListResponse)
async def get_institution_programs(
    institution_id: UUID,
    is_active: Optional[bool] = None,
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=20, le=100)
):
    """Get all programs for a specific institution"""
    return await get_programs(
        institution_id=institution_id,
        is_active=is_active,
        skip=skip,
        limit=limit
    )


@router.post("/programs/{program_id}/enroll")
async def enroll_student_in_program(program_id: str = Path(..., description="Program ID", pattern="^[a-zA-Z0-9_-]+$")):
    """Increment enrolled students count (simulated enrollment)"""
    try:
        db = get_supabase_admin()  # Use admin client for public data access

        # Get current enrollment
        result = db.table('programs').select('enrolled_students, max_students').eq('id', str(program_id)).execute()
        if not result.data:
            raise HTTPException(status_code=404, detail="Program not found")

        program = result.data[0]

        # Check if program is full
        if program['enrolled_students'] >= program['max_students']:
            raise HTTPException(status_code=400, detail="Program is full")

        # Increment enrollment
        update_result = db.table('programs').update({
            'enrolled_students': program['enrolled_students'] + 1
        }).eq('id', str(program_id)).execute()

        return _add_computed_fields(update_result.data[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error enrolling in program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to enroll: {str(e)}")
