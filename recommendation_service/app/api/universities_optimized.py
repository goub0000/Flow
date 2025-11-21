"""
Universities API endpoints - Cloud-Based (Supabase) with Performance Optimizations
Includes pagination, selective field queries, and enhanced caching
"""
from fastapi import APIRouter, Depends, HTTPException, Query
from supabase import Client
from app.database.config import get_db
from app.schemas.university import UniversityResponse, UniversitySearchResponse
from app.cache.redis_cache import cache
from typing import Optional, List, Dict, Any
import logging
import json
import hashlib

logger = logging.getLogger(__name__)

router = APIRouter()


def generate_cache_key(prefix: str, **params) -> str:
    """Generate a consistent cache key from parameters"""
    # Sort parameters for consistent key generation
    sorted_params = sorted(params.items())
    param_str = json.dumps(sorted_params)
    param_hash = hashlib.md5(param_str.encode()).hexdigest()[:8]
    return f"{prefix}:{param_hash}"


@router.get("/universities", response_model=UniversitySearchResponse)
def search_universities(
    country: Optional[str] = None,
    state: Optional[str] = None,
    university_type: Optional[str] = None,
    location_type: Optional[str] = None,
    min_acceptance_rate: Optional[float] = None,
    max_acceptance_rate: Optional[float] = None,
    min_tuition: Optional[float] = None,
    max_tuition: Optional[float] = None,
    min_ranking: Optional[int] = None,
    max_ranking: Optional[int] = None,
    min_students: Optional[int] = None,
    max_students: Optional[int] = None,
    search: Optional[str] = None,
    fields: Optional[str] = Query(None, description="Comma-separated list of fields to return"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    sort_by: Optional[str] = Query("ranking", description="Field to sort by"),
    sort_order: Optional[str] = Query("asc", description="Sort order (asc or desc)"),
    use_cache: bool = Query(True, description="Use cached results if available"),
    db: Client = Depends(get_db),
):
    """
    Search universities with advanced filters, pagination, and performance optimizations

    **Performance Features:**
    - Pagination: Results are paginated to reduce data transfer
    - Selective fields: Use 'fields' parameter to fetch only needed columns
    - Caching: Results are cached for 1 hour by default
    - Indexed queries: All filters use database indexes for fast retrieval

    **Query Parameters:**
    - country, state: Location filters (indexed)
    - university_type, location_type: Type filters (indexed)
    - min/max_acceptance_rate: Acceptance rate range (indexed)
    - min/max_tuition: Tuition cost range (indexed)
    - min/max_ranking: University ranking range (indexed)
    - min/max_students: Student population range (indexed)
    - search: Text search in name, city, state (uses GIN index)
    - fields: Comma-separated list of fields to return (reduces data transfer)
    - page, page_size: Pagination controls
    - sort_by, sort_order: Result sorting
    - use_cache: Whether to use cached results

    **Example field selection:**
    - fields="id,name,country,state,acceptance_rate,total_cost"
    - Returns only specified fields, reducing response size
    """
    try:
        # Generate cache key if caching is enabled
        cache_key = None
        if use_cache:
            cache_params = {
                "country": country,
                "state": state,
                "university_type": university_type,
                "location_type": location_type,
                "min_acceptance_rate": min_acceptance_rate,
                "max_acceptance_rate": max_acceptance_rate,
                "min_tuition": min_tuition,
                "max_tuition": max_tuition,
                "min_ranking": min_ranking,
                "max_ranking": max_ranking,
                "min_students": min_students,
                "max_students": max_students,
                "search": search,
                "fields": fields,
                "page": page,
                "page_size": page_size,
                "sort_by": sort_by,
                "sort_order": sort_order
            }
            cache_key = generate_cache_key("universities_search", **cache_params)

            # Try to get from cache
            cached_data = cache.get(cache_key)
            if cached_data:
                logger.debug(f"Cache hit for universities search: {cache_key}")
                return cached_data

        # Prepare field selection
        select_fields = "*"
        if fields:
            # Parse and validate field list
            field_list = [f.strip() for f in fields.split(",")]
            # Always include 'id' for consistency
            if "id" not in field_list:
                field_list.insert(0, "id")
            select_fields = ",".join(field_list)

        # Start building query with field selection and count
        query = db.table('universities').select(select_fields, count='exact')

        # Apply filters (all using indexes for performance)
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

        if min_tuition is not None:
            query = query.gte('total_cost', min_tuition)

        if max_tuition is not None:
            query = query.lte('total_cost', max_tuition)

        if min_ranking is not None:
            query = query.gte('ranking', min_ranking)

        if max_ranking is not None:
            query = query.lte('ranking', max_ranking)

        if min_students is not None:
            query = query.gte('students', min_students)

        if max_students is not None:
            query = query.lte('students', max_students)

        if search:
            # Use full-text search with GIN index
            query = query.or_(f'name.ilike.%{search}%,city.ilike.%{search}%,state.ilike.%{search}%')

        # Apply sorting
        if sort_by:
            if sort_order == "desc":
                query = query.order(sort_by, desc=True)
            else:
                query = query.order(sort_by)

        # Calculate pagination
        offset = (page - 1) * page_size
        query = query.range(offset, offset + page_size - 1)

        # Execute query
        response = query.execute()

        total = response.count if response.count is not None else len(response.data)
        universities = response.data

        # Calculate pagination metadata
        total_pages = (total + page_size - 1) // page_size if total > 0 else 0

        result = UniversitySearchResponse(
            total=total,
            universities=universities,
            pagination={
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": total_pages,
                "has_next": page < total_pages,
                "has_previous": page > 1
            }
        )

        # Cache the result if caching is enabled
        if use_cache and cache_key:
            # Cache for 1 hour
            cache.set(cache_key, result, ex=3600)

        return result

    except Exception as e:
        logger.error(f"Error searching universities: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/{university_id}", response_model=UniversityResponse)
def get_university(
    university_id: int,
    fields: Optional[str] = Query(None, description="Comma-separated list of fields to return"),
    use_cache: bool = Query(True, description="Use cached result if available"),
    db: Client = Depends(get_db)
):
    """
    Get a specific university by ID with selective field retrieval and caching

    **Performance Features:**
    - Selective fields: Fetch only the fields you need
    - Long-term caching: University data is cached for 24 hours
    - Indexed lookup: Uses primary key index for fast retrieval

    **Parameters:**
    - university_id: The university ID
    - fields: Optional comma-separated list of fields to return
    - use_cache: Whether to use cached data (default: true)
    """
    try:
        # Generate cache key
        cache_key = f"university:{university_id}"
        if fields:
            cache_key += f":{hashlib.md5(fields.encode()).hexdigest()[:8]}"

        # Try cache first if enabled
        if use_cache:
            cached_data = cache.get(cache_key)
            if cached_data:
                logger.debug(f"Cache hit for university {university_id}")
                return cached_data

        # Prepare field selection
        select_fields = "*"
        if fields:
            field_list = [f.strip() for f in fields.split(",")]
            if "id" not in field_list:
                field_list.insert(0, "id")
            select_fields = ",".join(field_list)

        # Cache miss - fetch from database with selective fields
        response = db.table('universities').select(select_fields).eq('id', university_id).execute()

        if not response.data or len(response.data) == 0:
            raise HTTPException(status_code=404, detail="University not found")

        university_data = response.data[0]

        # Cache for 24 hours (university data rarely changes)
        if use_cache:
            cache.set(cache_key, university_data, ex=86400)

        return university_data

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching university {university_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/{university_id}/programs")
def get_university_programs(
    university_id: int,
    field: Optional[str] = Query(None, description="Filter by field of study"),
    level: Optional[str] = Query(None, description="Filter by program level"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(20, ge=1, le=100, description="Items per page"),
    use_cache: bool = Query(True, description="Use cached results if available"),
    db: Client = Depends(get_db)
):
    """
    Get programs offered by a university with pagination and filtering

    **Performance Features:**
    - Pagination for large program lists
    - Field and level filtering using indexes
    - Result caching for frequently accessed data
    """
    try:
        # Generate cache key if caching is enabled
        cache_key = None
        if use_cache:
            cache_params = {
                "university_id": university_id,
                "field": field,
                "level": level,
                "page": page,
                "page_size": page_size
            }
            cache_key = generate_cache_key("university_programs", **cache_params)

            # Try cache first
            cached_data = cache.get(cache_key)
            if cached_data:
                logger.debug(f"Cache hit for university {university_id} programs")
                return cached_data

        # First check if university exists (uses index)
        university_response = db.table('universities').select('id').eq('id', university_id).execute()

        if not university_response.data or len(university_response.data) == 0:
            raise HTTPException(status_code=404, detail="University not found")

        # Build programs query with filters
        query = db.table('programs').select('*', count='exact')
        query = query.eq('university_id', university_id)

        if field:
            query = query.eq('field', field)

        if level:
            query = query.eq('level', level)

        # Get total count
        count_response = query.execute()
        total = count_response.count if count_response.count is not None else 0

        # Apply pagination
        offset = (page - 1) * page_size
        query = query.range(offset, offset + page_size - 1)

        # Execute paginated query
        programs_response = query.execute()

        # Calculate pagination metadata
        total_pages = (total + page_size - 1) // page_size if total > 0 else 0

        result = {
            "university_id": university_id,
            "programs": programs_response.data,
            "total": total,
            "pagination": {
                "page": page,
                "page_size": page_size,
                "total": total,
                "total_pages": total_pages,
                "has_next": page < total_pages,
                "has_previous": page > 1
            }
        }

        # Cache the result if enabled
        if use_cache and cache_key:
            # Cache for 6 hours
            cache.set(cache_key, result, ex=21600)

        return result

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching programs for university {university_id}: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/bulk")
def get_universities_bulk(
    ids: str = Query(..., description="Comma-separated list of university IDs"),
    fields: Optional[str] = Query(None, description="Comma-separated list of fields to return"),
    use_cache: bool = Query(True, description="Use cached results if available"),
    db: Client = Depends(get_db)
):
    """
    Get multiple universities by IDs in a single request (batch fetching)

    **Performance Features:**
    - Batch fetching reduces number of API calls
    - Selective field retrieval
    - Result caching

    **Parameters:**
    - ids: Comma-separated list of university IDs (e.g., "1,2,3,4,5")
    - fields: Optional comma-separated list of fields to return
    - use_cache: Whether to use cached data

    **Use Case:**
    - Fetching details for multiple universities in recommendations
    - Loading comparison data for multiple universities
    """
    try:
        # Parse university IDs
        university_ids = [int(id.strip()) for id in ids.split(",")]

        if len(university_ids) > 100:
            raise HTTPException(status_code=400, detail="Maximum 100 universities can be fetched at once")

        # Generate cache key if caching is enabled
        cache_key = None
        if use_cache:
            cache_key = f"universities_bulk:{hashlib.md5(ids.encode()).hexdigest()[:8]}"
            if fields:
                cache_key += f":{hashlib.md5(fields.encode()).hexdigest()[:8]}"

            # Try cache first
            cached_data = cache.get(cache_key)
            if cached_data:
                logger.debug(f"Cache hit for bulk universities")
                return cached_data

        # Prepare field selection
        select_fields = "*"
        if fields:
            field_list = [f.strip() for f in fields.split(",")]
            if "id" not in field_list:
                field_list.insert(0, "id")
            select_fields = ",".join(field_list)

        # Fetch universities using IN query (uses index)
        response = db.table('universities').select(select_fields).in_('id', university_ids).execute()

        result = {
            "universities": response.data,
            "requested": len(university_ids),
            "found": len(response.data)
        }

        # Cache the result if enabled
        if use_cache and cache_key:
            # Cache for 6 hours
            cache.set(cache_key, result, ex=21600)

        return result

    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid university ID format")
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching bulk universities: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/universities/stats")
def get_universities_statistics(
    country: Optional[str] = None,
    state: Optional[str] = None,
    use_cache: bool = Query(True, description="Use cached statistics if available"),
    db: Client = Depends(get_db)
):
    """
    Get aggregated statistics about universities

    **Returns:**
    - Total count
    - Average acceptance rate
    - Average tuition cost
    - Distribution by type
    - Distribution by location type

    **Performance Features:**
    - Uses database aggregation functions
    - Results are cached for 12 hours
    - Filters use indexes for fast aggregation
    """
    try:
        # Generate cache key
        cache_key = f"universities_stats:{country or 'all'}:{state or 'all'}"

        if use_cache:
            cached_data = cache.get(cache_key)
            if cached_data:
                logger.debug(f"Cache hit for universities statistics")
                return cached_data

        # Build base query
        query = db.table('universities').select('*')

        if country:
            query = query.eq('country', country)

        if state:
            query = query.eq('state', state)

        # Execute query
        response = query.execute()
        universities = response.data

        if not universities:
            return {
                "total": 0,
                "statistics": {}
            }

        # Calculate statistics
        total = len(universities)
        acceptance_rates = [u['acceptance_rate'] for u in universities if u.get('acceptance_rate')]
        tuition_costs = [u['total_cost'] for u in universities if u.get('total_cost')]
        rankings = [u['ranking'] for u in universities if u.get('ranking')]

        # Type distributions
        type_distribution = {}
        location_distribution = {}

        for u in universities:
            # University type
            u_type = u.get('university_type', 'Unknown')
            type_distribution[u_type] = type_distribution.get(u_type, 0) + 1

            # Location type
            l_type = u.get('location_type', 'Unknown')
            location_distribution[l_type] = location_distribution.get(l_type, 0) + 1

        result = {
            "total": total,
            "statistics": {
                "acceptance_rate": {
                    "average": sum(acceptance_rates) / len(acceptance_rates) if acceptance_rates else None,
                    "min": min(acceptance_rates) if acceptance_rates else None,
                    "max": max(acceptance_rates) if acceptance_rates else None
                },
                "tuition": {
                    "average": sum(tuition_costs) / len(tuition_costs) if tuition_costs else None,
                    "min": min(tuition_costs) if tuition_costs else None,
                    "max": max(tuition_costs) if tuition_costs else None
                },
                "ranking": {
                    "average": sum(rankings) / len(rankings) if rankings else None,
                    "min": min(rankings) if rankings else None,
                    "max": max(rankings) if rankings else None
                }
            },
            "distributions": {
                "university_type": type_distribution,
                "location_type": location_distribution
            },
            "filters_applied": {
                "country": country,
                "state": state
            }
        }

        # Cache for 12 hours
        if use_cache:
            cache.set(cache_key, result, ex=43200)

        return result

    except Exception as e:
        logger.error(f"Error calculating universities statistics: {e}")
        raise HTTPException(status_code=500, detail=str(e))