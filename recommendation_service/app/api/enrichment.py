"""
University Data Enrichment API Endpoints
Cloud-based enrichment system for filling NULL values
"""
from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional, List
import logging
from datetime import datetime
from app.database.config import get_supabase
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.enrichment.async_auto_fill_orchestrator import AsyncAutoFillOrchestrator

router = APIRouter()
logger = logging.getLogger(__name__)

# Track running enrichment jobs
enrichment_jobs = {}


class EnrichmentRequest(BaseModel):
    """Request model for starting enrichment"""
    limit: Optional[int] = 50
    priority: Optional[str] = None  # 'critical', 'high', 'medium'
    dry_run: bool = False
    fields: Optional[List[str]] = None  # Specific fields to enrich
    max_concurrent: Optional[int] = 10  # For async enrichment


class EnrichmentStatus(BaseModel):
    """Status of an enrichment job"""
    job_id: str
    status: str  # 'running', 'completed', 'failed'
    started_at: datetime
    completed_at: Optional[datetime] = None
    universities_processed: int
    universities_updated: int
    errors: int
    message: Optional[str] = None


def run_enrichment_job(job_id: str, request: EnrichmentRequest, trigger_ml_training: bool = False):
    """Background task to run enrichment"""
    try:
        logger.info(f"Starting enrichment job {job_id}")
        enrichment_jobs[job_id]['status'] = 'running'

        # Get database client
        db = get_supabase()

        # Initialize orchestrator
        orchestrator = AutoFillOrchestrator(
            db=db,
            rate_limit_delay=3.0
        )

        # Run enrichment
        results = orchestrator.run_enrichment(
            limit=request.limit,
            priority_fields=request.fields
        )

        # Update job status
        enrichment_jobs[job_id].update({
            'status': 'completed',
            'completed_at': datetime.now(),
            'universities_processed': results.get('total_processed', 0),
            'universities_updated': results.get('total_updated', 0),
            'errors': results.get('errors', 0),
            'message': 'Enrichment completed successfully'
        })

        logger.info(f"Enrichment job {job_id} completed")

        # Trigger ML training if requested and enough data was updated
        if trigger_ml_training and results.get('total_updated', 0) > 0:
            logger.info(f"Triggering ML training after enriching {results.get('total_updated', 0)} universities")
            from app.api.ml_training import train_models_background
            try:
                train_models_background()
                enrichment_jobs[job_id]['message'] += ' | ML training triggered'
            except Exception as ml_error:
                logger.error(f"ML training trigger failed: {ml_error}")
                enrichment_jobs[job_id]['message'] += ' | ML training failed'

    except Exception as e:
        logger.error(f"Enrichment job {job_id} failed: {e}")
        enrichment_jobs[job_id].update({
            'status': 'failed',
            'completed_at': datetime.now(),
            'message': str(e)
        })


async def run_async_enrichment_job(job_id: str, request: EnrichmentRequest, trigger_ml_training: bool = False):
    """Background task to run async enrichment (5-10x faster)"""
    try:
        logger.info(f"Starting ASYNC enrichment job {job_id}")
        enrichment_jobs[job_id]['status'] = 'running'

        # Get database client
        db = get_supabase()

        # Initialize async orchestrator
        orchestrator = AsyncAutoFillOrchestrator(
            db=db,
            rate_limit_delay=1.0,  # Faster than sync version
            max_concurrent=request.max_concurrent or 10
        )

        # Run async enrichment
        results = await orchestrator.run_enrichment_async(
            limit=request.limit,
            priority_fields=request.fields,
            dry_run=request.dry_run
        )

        # Update job status
        enrichment_jobs[job_id].update({
            'status': 'completed',
            'completed_at': datetime.now(),
            'universities_processed': results.get('total_processed', 0),
            'universities_updated': results.get('total_updated', 0),
            'errors': results.get('errors', 0),
            'message': f'Async enrichment completed successfully (5-10x faster)'
        })

        logger.info(f"Async enrichment job {job_id} completed")

        # Trigger ML training if requested and enough data was updated
        if trigger_ml_training and results.get('total_updated', 0) > 0:
            logger.info(f"Triggering ML training after enriching {results.get('total_updated', 0)} universities")
            from app.api.ml_training import train_models_background
            try:
                train_models_background()
                enrichment_jobs[job_id]['message'] += ' | ML training triggered'
            except Exception as ml_error:
                logger.error(f"ML training trigger failed: {ml_error}")
                enrichment_jobs[job_id]['message'] += ' | ML training failed'

    except Exception as e:
        logger.error(f"Async enrichment job {job_id} failed: {e}")
        enrichment_jobs[job_id].update({
            'status': 'failed',
            'completed_at': datetime.now(),
            'message': str(e)
        })


@router.post("/enrichment/start", response_model=EnrichmentStatus)
async def start_enrichment(request: EnrichmentRequest, background_tasks: BackgroundTasks):
    """
    Start a university data enrichment job

    This will search the web and fill NULL values in the database.

    Parameters:
    - limit: Maximum number of universities to process
    - priority: Filter by priority ('critical', 'high', 'medium')
    - dry_run: If true, don't update database
    - fields: Specific fields to enrich (e.g., ['acceptance_rate', 'tuition'])
    """
    try:
        # Generate job ID
        job_id = f"enrich_{datetime.now().strftime('%Y%m%d_%H%M%S')}"

        # Initialize job status
        enrichment_jobs[job_id] = {
            'job_id': job_id,
            'status': 'starting',
            'started_at': datetime.now(),
            'completed_at': None,
            'universities_processed': 0,
            'universities_updated': 0,
            'errors': 0,
            'message': 'Enrichment job queued'
        }

        # Start enrichment in background
        # Auto-trigger ML training for weekly/monthly batches
        trigger_ml = request.limit >= 100
        background_tasks.add_task(run_enrichment_job, job_id, request, trigger_ml)

        return enrichment_jobs[job_id]

    except Exception as e:
        logger.error(f"Failed to start enrichment: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/enrichment/status/{job_id}", response_model=EnrichmentStatus)
async def get_enrichment_status(job_id: str):
    """Get status of an enrichment job"""
    if job_id not in enrichment_jobs:
        raise HTTPException(status_code=404, detail="Job not found")

    return enrichment_jobs[job_id]


@router.get("/enrichment/status")
async def get_all_enrichment_jobs():
    """Get status of all enrichment jobs"""
    return {
        "total_jobs": len(enrichment_jobs),
        "jobs": list(enrichment_jobs.values())
    }


@router.get("/enrichment/analyze")
async def analyze_data_quality():
    """
    Analyze data quality - show NULL value statistics

    Returns statistics on which fields have NULL values and how many
    """
    try:
        db = get_supabase()

        # Get total count
        result = db.table('universities').select('id', count='exact').limit(1).execute()
        total_universities = result.count

        # Fields to analyze
        fields = [
            'state', 'city', 'website', 'logo_url',
            'university_type', 'location_type', 'total_students',
            'acceptance_rate', 'gpa_average',
            'sat_math_25th', 'sat_math_75th',
            'sat_ebrw_25th', 'sat_ebrw_75th',
            'act_composite_25th', 'act_composite_75th',
            'tuition_out_state', 'total_cost',
            'graduation_rate_4year', 'median_earnings_10year'
        ]

        analysis = []
        total_nulls = 0

        for field in fields:
            try:
                # Count non-null values
                result = db.table('universities').select(field, count='exact').not_.is_(field, 'null').execute()
                filled_count = result.count or 0
                null_count = total_universities - filled_count
                null_percentage = (null_count / total_universities * 100) if total_universities > 0 else 0

                total_nulls += null_count

                # Determine priority
                critical_fields = ['acceptance_rate', 'gpa_average', 'graduation_rate_4year', 'tuition_out_state']
                high_fields = ['total_students', 'total_cost', 'university_type', 'location_type']

                if field in critical_fields:
                    priority = 'CRITICAL'
                elif field in high_fields:
                    priority = 'HIGH'
                else:
                    priority = 'MEDIUM'

                analysis.append({
                    'field': field,
                    'null_count': null_count,
                    'null_percentage': round(null_percentage, 1),
                    'filled_count': filled_count,
                    'priority': priority
                })
            except:
                continue

        # Sort by null count descending
        analysis.sort(key=lambda x: x['null_count'], reverse=True)

        return {
            'total_universities': total_universities,
            'total_null_values': total_nulls,
            'fields': analysis,
            'summary': {
                'critical_nulls': sum(f['null_count'] for f in analysis if f['priority'] == 'CRITICAL'),
                'high_nulls': sum(f['null_count'] for f in analysis if f['priority'] == 'HIGH'),
                'medium_nulls': sum(f['null_count'] for f in analysis if f['priority'] == 'MEDIUM')
            }
        }

    except Exception as e:
        logger.error(f"Failed to analyze data quality: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/enrichment/daily")
async def run_daily_enrichment(background_tasks: BackgroundTasks):
    """
    Run daily enrichment (30 critical priority universities)

    This endpoint can be called by a cron job
    """
    request = EnrichmentRequest(
        limit=30,
        priority='critical',
        dry_run=False
    )
    return await start_enrichment(request, background_tasks)


@router.post("/enrichment/weekly")
async def run_weekly_enrichment(background_tasks: BackgroundTasks):
    """
    Run weekly enrichment (100 high priority universities)

    This endpoint can be called by a cron job
    """
    request = EnrichmentRequest(
        limit=100,
        priority='high',
        dry_run=False
    )
    return await start_enrichment(request, background_tasks)


@router.post("/enrichment/monthly")
async def run_monthly_enrichment(background_tasks: BackgroundTasks):
    """
    Run monthly enrichment (300 medium priority universities)

    This endpoint can be called by a cron job
    """
    request = EnrichmentRequest(
        limit=300,
        priority='medium',
        dry_run=False
    )
    return await start_enrichment(request, background_tasks)


@router.post("/enrichment/start-async", response_model=EnrichmentStatus)
async def start_async_enrichment(request: EnrichmentRequest):
    """
    Start an ASYNC university data enrichment job (5-10x faster)

    Uses asyncio and aiohttp for concurrent processing.

    Parameters:
    - limit: Maximum number of universities to process
    - priority: Filter by priority ('critical', 'high', 'medium')
    - dry_run: If true, don't update database
    - fields: Specific fields to enrich (e.g., ['acceptance_rate', 'tuition'])
    - max_concurrent: Number of concurrent enrichments (default: 10)
    """
    try:
        # Generate job ID
        job_id = f"async_enrich_{datetime.now().strftime('%Y%m%d_%H%M%S')}"

        # Initialize job status
        enrichment_jobs[job_id] = {
            'job_id': job_id,
            'status': 'starting',
            'started_at': datetime.now(),
            'completed_at': None,
            'universities_processed': 0,
            'universities_updated': 0,
            'errors': 0,
            'message': 'Async enrichment job queued (5-10x faster)'
        }

        # Auto-trigger ML training for weekly/monthly batches
        trigger_ml = request.limit >= 100

        # Run async enrichment (await directly, not in background)
        import asyncio
        asyncio.create_task(run_async_enrichment_job(job_id, request, trigger_ml))

        return enrichment_jobs[job_id]

    except Exception as e:
        logger.error(f"Failed to start async enrichment: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/enrichment/daily-async")
async def run_daily_async_enrichment():
    """
    Run daily ASYNC enrichment (30 critical priority universities)

    5-10x faster than sync version (2-5 minutes vs 20-30 minutes)
    """
    request = EnrichmentRequest(
        limit=30,
        priority='critical',
        dry_run=False,
        max_concurrent=10
    )
    return await start_async_enrichment(request)


@router.post("/enrichment/weekly-async")
async def run_weekly_async_enrichment():
    """
    Run weekly ASYNC enrichment (100 high priority universities)

    5-10x faster than sync version (7-13 minutes vs 1-2 hours)
    """
    request = EnrichmentRequest(
        limit=100,
        priority='high',
        dry_run=False,
        max_concurrent=15
    )
    return await start_async_enrichment(request)


@router.post("/enrichment/monthly-async")
async def run_monthly_async_enrichment():
    """
    Run monthly ASYNC enrichment (300 medium priority universities)

    5-10x faster than sync version (20-40 minutes vs 3-5 hours)
    """
    request = EnrichmentRequest(
        limit=300,
        priority='medium',
        dry_run=False,
        max_concurrent=20
    )
    return await start_async_enrichment(request)


@router.delete("/enrichment/jobs")
async def clear_old_jobs():
    """Clear completed jobs older than 24 hours"""
    from datetime import timedelta

    cutoff = datetime.now() - timedelta(hours=24)
    jobs_to_remove = []

    for job_id, job in enrichment_jobs.items():
        if job['status'] in ['completed', 'failed']:
            if job.get('completed_at') and job['completed_at'] < cutoff:
                jobs_to_remove.append(job_id)

    for job_id in jobs_to_remove:
        del enrichment_jobs[job_id]

    return {
        'removed': len(jobs_to_remove),
        'remaining': len(enrichment_jobs)
    }


# ============================================================================
# CACHE MANAGEMENT ENDPOINTS
# ============================================================================

@router.get("/cache/stats")
async def get_cache_statistics():
    """
    Get enrichment cache statistics

    Returns:
        - total_entries: Total cache entries
        - valid_entries: Non-expired entries
        - expired_entries: Expired entries
        - by_source: Breakdown by data source (College Scorecard, Wikipedia, etc.)
        - by_field: Breakdown by field (acceptance_rate, tuition, etc.)
    """
    try:
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        db = get_supabase()
        cache = AsyncEnrichmentCache(db)

        stats = cache.get_database_stats()

        if stats is None:
            raise HTTPException(status_code=500, detail="Failed to retrieve cache statistics")

        return {
            "success": True,
            "statistics": stats,
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to get cache stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/cache/health")
async def get_cache_health():
    """
    Check cache health and provide recommendations

    Returns health status and recommendations for cache management
    """
    try:
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        db = get_supabase()
        cache = AsyncEnrichmentCache(db)

        stats = cache.get_database_stats()

        if stats is None:
            return {
                "status": "error",
                "message": "Could not retrieve cache statistics"
            }

        total = stats['total_entries']
        valid = stats['valid_entries']
        expired = stats['expired_entries']

        # Calculate health metrics
        expiration_rate = (expired / total * 100) if total > 0 else 0

        # Determine health status
        if expiration_rate > 30:
            status = "warning"
            message = "High expiration rate - consider running cleanup"
            recommendations = [
                "Run cache cleanup to remove expired entries",
                f"{expired} entries can be cleaned up"
            ]
        elif total > 100000:
            status = "warning"
            message = "Large cache size - monitor performance"
            recommendations = [
                "Cache is growing large - monitor database size",
                "Consider reducing TTL for less critical sources"
            ]
        else:
            status = "healthy"
            message = "Cache is operating normally"
            recommendations = []

        return {
            "status": status,
            "message": message,
            "metrics": {
                "total_entries": total,
                "valid_entries": valid,
                "expired_entries": expired,
                "expiration_rate": round(expiration_rate, 2)
            },
            "recommendations": recommendations,
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to check cache health: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/cache/university/{university_id}")
async def invalidate_university_cache(university_id: int):
    """
    Invalidate all cached fields for a specific university

    Use this when:
    - University data has been manually updated
    - University website has changed significantly
    - You want to force fresh enrichment for this university

    Args:
        university_id: ID of the university

    Returns:
        Number of cache entries deleted
    """
    try:
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        db = get_supabase()
        cache = AsyncEnrichmentCache(db)

        deleted = cache.invalidate_university(university_id)

        return {
            "success": True,
            "university_id": university_id,
            "entries_deleted": deleted,
            "message": f"Invalidated {deleted} cache entries for university {university_id}",
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to invalidate university cache: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/cache/field/{field_name}")
async def invalidate_field_cache(field_name: str):
    """
    Invalidate a specific field across ALL universities

    Use this when:
    - Field definition or calculation has changed
    - Data source for this field has been updated
    - You want to force re-enrichment of this field for all universities

    Args:
        field_name: Name of the field (e.g., 'acceptance_rate', 'tuition_out_state')

    Returns:
        Number of cache entries deleted
    """
    try:
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        db = get_supabase()
        cache = AsyncEnrichmentCache(db)

        deleted = cache.invalidate_field(field_name)

        return {
            "success": True,
            "field_name": field_name,
            "entries_deleted": deleted,
            "message": f"Invalidated {deleted} cache entries for field '{field_name}'",
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to invalidate field cache: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/cache/cleanup")
async def cleanup_expired_cache():
    """
    Remove all expired cache entries

    This frees up database space and improves query performance.
    Safe to run anytime - only removes entries past their expiration date.

    Recommended: Run weekly via cron job

    Returns:
        Number of expired entries deleted
    """
    try:
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        db = get_supabase()
        cache = AsyncEnrichmentCache(db)

        deleted = cache.cleanup_expired()

        return {
            "success": True,
            "entries_deleted": deleted,
            "message": f"Cleaned up {deleted} expired cache entries",
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to cleanup cache: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/cache/all")
async def clear_all_cache():
    """
    DANGER: Clear ALL cache entries (expired and valid)

    Use with extreme caution! This will:
    - Delete all cached enrichment data
    - Force fresh enrichment for all universities on next run
    - Significantly slow down next enrichment (no cache hits)

    Only use when:
    - Major data source changes
    - Cache corruption suspected
    - Complete refresh needed

    Returns:
        Number of entries deleted
    """
    try:
        db = get_supabase()

        # Delete all cache entries
        response = db.table('enrichment_cache').delete().neq('id', 0).execute()
        deleted = len(response.data) if response.data else 0

        logger.warning(f"CACHE CLEARED: All {deleted} cache entries deleted")

        return {
            "success": True,
            "entries_deleted": deleted,
            "message": f"⚠️ ALL cache cleared: {deleted} entries deleted",
            "warning": "Next enrichment will be slower (no cache hits)",
            "timestamp": datetime.now().isoformat()
        }

    except Exception as e:
        logger.error(f"Failed to clear all cache: {e}")
        raise HTTPException(status_code=500, detail=str(e))
