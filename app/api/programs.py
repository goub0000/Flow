"""
Programs API endpoints
Cloud-based institutional programs management
"""
from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from uuid import UUID
from app.database.config import get_supabase
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
        db = get_supabase()

        # Start query
        query = db.table('programs').select('*', count='exact')

        # Apply filters
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

        return {
            "total": result.count if result.count else 0,
            "programs": result.data
        }

    except Exception as e:
        logger.error(f"Error fetching programs: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to fetch programs: {str(e)}")


@router.get("/programs/statistics/overview", response_model=ProgramStatistics)
async def get_program_statistics(institution_id: Optional[UUID] = None):
    """Get program statistics, optionally filtered by institution"""
    try:
        db = get_supabase()

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
async def get_program(program_id: UUID):
    """Get a specific program by ID"""
    try:
        db = get_supabase()

        result = db.table('programs').select('*').eq('id', str(program_id)).execute()

        if not result.data:
            raise HTTPException(status_code=404, detail="Program not found")

        return result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to fetch program: {str(e)}")


@router.post("/programs", response_model=ProgramResponse, status_code=201)
async def create_program(program: ProgramCreate):
    """Create a new program"""
    try:
        db = get_supabase()

        # Convert Pydantic model to dict
        program_data = program.model_dump()

        # Convert UUID to string for Supabase
        program_data['institution_id'] = str(program_data['institution_id'])

        # Convert Decimal to float for JSON serialization
        program_data['fee'] = float(program_data['fee'])

        # Insert into database
        result = db.table('programs').insert(program_data).execute()

        if not result.data:
            raise HTTPException(status_code=500, detail="Failed to create program")

        return result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating program: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to create program: {str(e)}")


@router.put("/programs/{program_id}", response_model=ProgramResponse)
async def update_program(program_id: UUID, program: ProgramUpdate):
    """Update an existing program"""
    try:
        db = get_supabase()

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

        # Update in database
        result = db.table('programs').update(update_data).eq('id', str(program_id)).execute()

        if not result.data:
            raise HTTPException(status_code=500, detail="Failed to update program")

        return result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to update program: {str(e)}")


@router.delete("/programs/{program_id}", status_code=204)
async def delete_program(program_id: UUID):
    """Delete a program"""
    try:
        db = get_supabase()

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
async def toggle_program_status(program_id: UUID):
    """Toggle program active status"""
    try:
        db = get_supabase()

        # Get current status
        result = db.table('programs').select('is_active').eq('id', str(program_id)).execute()
        if not result.data:
            raise HTTPException(status_code=404, detail="Program not found")

        current_status = result.data[0]['is_active']

        # Toggle status
        update_result = db.table('programs').update({
            'is_active': not current_status
        }).eq('id', str(program_id)).execute()

        return update_result.data[0]

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
async def enroll_student_in_program(program_id: UUID):
    """Increment enrolled students count (simulated enrollment)"""
    try:
        db = get_supabase()

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

        return update_result.data[0]

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error enrolling in program {program_id}: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to enroll: {str(e)}")
