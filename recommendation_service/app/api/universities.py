"""
Universities API endpoints - Cloud-Based (Supabase)
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from supabase import Client
from app.database.config import get_db
from app.schemas.university import UniversityResponse, UniversitySearchResponse
from app.cache.redis_cache import cache
from typing import Optional
import logging

logger = logging.getLogger(__name__)

router = APIRouter()


@router.get("/universities", response_model=UniversitySearchResponse)
def search_universities(
    country: Optional[str] = None,
    state: Optional[str] = None,
    university_type: Optional[str] = None,
    location_type: Optional[str] = None,
    min_acceptance_rate: Optional[float] = None,
    max_acceptance_rate: Optional[float] = None,
    max_tuition: Optional[float] = None,
    search: Optional[str] = None,
    skip: int = 0,
    limit: int = Query(default=50, le=100),
    db: Client = Depends(get_db),
):
    """Search universities with filters"""
    try:
        # Start building query
        query = db.table('universities').select('*', count='exact')

        # Apply filters
        if country:
            query = query.eq('country', country)

        if state:
            query = query.eq('state', state)

        if university_type:
            query = query.eq('university_type', university_type)

        if location_type:
            query = query.eq('location_type', location_type)

        if min_acceptance_rate is not None:
            query = query.gte('acceptance_rate', min_acceptance_rate)

        if max_acceptance_rate is not None:
            query = query.lte('acceptance_rate', max_acceptance_rate)

        if max_tuition is not None:
            query = query.lte('total_cost', max_tuition)

        if search:
            # Supabase full-text search or ilike for multiple columns
            # Using or_ for multiple columns
            query = query.or_(f'name.ilike.%{search}%,city.ilike.%{search}%,state.ilike.%{search}%')

        # Apply pagination
        query = query.range(skip, skip + limit - 1)

        # Execute query
        response = query.execute()

        total = response.count if response.count is not None else len(response.data)
        universities = response.data

        return UniversitySearchResponse(total=total, universities=universities)

    except Exception as e:
        logger.error(f"Error searching universities: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/{university_id}", response_model=UniversityResponse)
def get_university(university_id: int, db: Client = Depends(get_db)):
    """Get a specific university by ID (cached)"""
    cache_key = f"university:{university_id}"

    try:
        # Try cache first
        cached_data = cache.get(cache_key)
        if cached_data:
            logger.debug(f"Cache hit for university {university_id}")
            return cached_data

        # Cache miss - fetch from database
        response = db.table('universities').select('*').eq('id', university_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="University not found")

        university_data = response.data[0]

        # Cache for 24 hours (university data rarely changes)
        cache.set(cache_key, university_data, ex=86400)

        return university_data

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching university {university_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/{university_id}/programs")
def get_university_programs(university_id: int, db: Client = Depends(get_db)):
    """Get programs offered by a university"""
    try:
        # First check if university exists
        university_response = db.table('universities').select('id').eq('id', university_id).execute()

        if not university_response.data or len(university_response.data) == 0:
            raise HTTPException(status_code=404, detail="University not found")

        # Get programs
        programs_response = db.table('programs').select('*').eq('university_id', university_id).execute()

        return {"university_id": university_id, "programs": programs_response.data}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching programs for university {university_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))
