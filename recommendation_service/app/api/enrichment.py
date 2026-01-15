"""
University Data Enrichment API Endpoints
Cloud-based enrichment system for filling NULL values
Includes cache management endpoints for performance monitoring
"""
from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel
from typing import Optional, List
import logging
import aiohttp
from datetime import datetime
from app.database.config import get_supabase
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.enrichment.async_auto_fill_orchestrator import AsyncAutoFillOrchestrator

router = APIRouter()
logger = logging.getLogger(__name__)

# REMOVED: In-memory job storage (replaced with database persistence)
# enrichment_jobs = {}

# Helper functions for database-backed job persistence
def _get_job_from_db(job_id: str) -> Optional[dict]:
    """Retrieve job status from database"""
    try:
        db = get_supabase()
        response = db.table('enrichment_jobs').select('*').eq('job_id', job_id).single().execute()
        if response.data:
            job = response.data
            # Convert to API format
            return {
                'job_id': job['job_id'],
                'status': job['status'],
                'started_at': job.get('started_at'),
                'completed_at': job.get('completed_at'),
                'universities_processed': job.get('processed_universities', 0),
                'universities_updated': job.get('successful_updates', 0),
                'errors': job.get('errors_count', 0),
                'message': job.get('error_message')
            }
        return None
    except Exception as e:
        logger.error(f"Failed to get job {job_id} from database: {e}")
        return None

def _create_job_in_db(job_id: str, status: str = 'pending', message: str = 'Job queued') -> dict:
    """Create new job record in database"""
    try:
        db = get_supabase()
        job_data = {
            'job_id': job_id,
            'status': status,
            'created_at': datetime.now().isoformat(),
            'total_universities': 0,
            'processed_universities': 0,
            'successful_updates': 0,
            'total_fields_filled': 0,
            'errors_count': 0,
            'error_message': message if status == 'failed' else None,
            'results': {'message': message}
        }
        db.table('enrichment_jobs').insert(job_data).execute()
        return {
            'job_id': job_id,
            'status': status,
            'started_at': None,
            'completed_at': None,
            'universities_processed': 0,
            'universities_updated': 0,
            'errors': 0,
            'message': message
        }
    except Exception as e:
        logger.error(f"Failed to create job {job_id} in database: {e}")
        raise

def _update_job_in_db(job_id: str, updates: dict) -> bool:
    """Update job status in database"""
    try:
        db = get_supabase()
        # Map API field names to database column names
        db_updates = {}
        if 'status' in updates:
            db_updates['status'] = updates['status']
        if 'started_at' in updates:
            db_updates['started_at'] = updates['started_at'].isoformat() if isinstance(updates['started_at'], datetime) else updates['started_at']
        if 'completed_at' in updates:
            db_updates['completed_at'] = updates['completed_at'].isoformat() if isinstance(updates['completed_at'], datetime) else updates['completed_at']
        if 'universities_processed' in updates:
            db_updates['processed_universities'] = updates['universities_processed']
        if 'universities_updated' in updates:
            db_updates['successful_updates'] = updates['universities_updated']
        if 'errors' in updates:
            db_updates['errors_count'] = updates['errors']
        if 'message' in updates:
            db_updates['error_message'] = updates['message']
            db_updates['results'] = {'message': updates['message']}

        db.table('enrichment_jobs').update(db_updates).eq('job_id', job_id).execute()
        return True
    except Exception as e:
        logger.error(f"Failed to update job {job_id} in database: {e}")
        return False


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
        _update_job_in_db(job_id, {'status': 'running', 'started_at': datetime.now()})

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

        # Update job status in database
        _update_job_in_db(job_id, {
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
                job = _get_job_from_db(job_id)
                if job:
                    message = job.get('message', 'Enrichment completed successfully')
                    _update_job_in_db(job_id, {'message': message + ' | ML training triggered'})
            except Exception as ml_error:
                logger.error(f"ML training trigger failed: {ml_error}")
                job = _get_job_from_db(job_id)
                if job:
                    message = job.get('message', 'Enrichment completed successfully')
                    _update_job_in_db(job_id, {'message': message + ' | ML training failed'})

    except Exception as e:
        logger.error(f"Enrichment job {job_id} failed: {e}")
        _update_job_in_db(job_id, {
            'status': 'failed',
            'completed_at': datetime.now(),
            'message': str(e)
        })


async def run_async_enrichment_job(job_id: str, request: EnrichmentRequest, trigger_ml_training: bool = False):
    """Background task to run async enrichment (5-10x faster)"""
    try:
        logger.info(f"Starting ASYNC enrichment job {job_id}")
        _update_job_in_db(job_id, {'status': 'running', 'started_at': datetime.now()})

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

        # Update job status in database
        _update_job_in_db(job_id, {
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
                job = _get_job_from_db(job_id)
                if job:
                    message = job.get('message', 'Async enrichment completed successfully')
                    _update_job_in_db(job_id, {'message': message + ' | ML training triggered'})
            except Exception as ml_error:
                logger.error(f"ML training trigger failed: {ml_error}")
                job = _get_job_from_db(job_id)
                if job:
                    message = job.get('message', 'Async enrichment completed successfully')
                    _update_job_in_db(job_id, {'message': message + ' | ML training failed'})

    except Exception as e:
        logger.error(f"Async enrichment job {job_id} failed: {e}")
        _update_job_in_db(job_id, {
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

        # Create job record in database
        job_status = _create_job_in_db(job_id, status='pending', message='Enrichment job queued')

        # Start enrichment in background
        # Auto-trigger ML training for weekly/monthly batches
        trigger_ml = request.limit >= 100
        background_tasks.add_task(run_enrichment_job, job_id, request, trigger_ml)

        return job_status

    except Exception as e:
        logger.error(f"Failed to start enrichment: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/enrichment/status/{job_id}", response_model=EnrichmentStatus)
async def get_enrichment_status(job_id: str):
    """Get status of an enrichment job"""
    job = _get_job_from_db(job_id)
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")

    return job


@router.get("/enrichment/status")
async def get_all_enrichment_jobs():
    """Get status of all enrichment jobs"""
    try:
        db = get_supabase()
        # Get recent jobs (last 100)
        response = db.table('enrichment_jobs')\
            .select('*')\
            .order('created_at', desc=True)\
            .limit(100)\
            .execute()

        jobs = []
        for job_data in response.data:
            jobs.append({
                'job_id': job_data['job_id'],
                'status': job_data['status'],
                'started_at': job_data.get('started_at'),
                'completed_at': job_data.get('completed_at'),
                'universities_processed': job_data.get('processed_universities', 0),
                'universities_updated': job_data.get('successful_updates', 0),
                'errors': job_data.get('errors_count', 0),
                'message': job_data.get('error_message')
            })

        return {
            "total_jobs": len(jobs),
            "jobs": jobs
        }
    except Exception as e:
        logger.error(f"Failed to get jobs: {e}")
        raise HTTPException(status_code=500, detail=str(e))


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

        # Create job record in database
        job_status = _create_job_in_db(job_id, status='pending', message='Async enrichment job queued (5-10x faster)')

        # Auto-trigger ML training for weekly/monthly batches
        trigger_ml = request.limit >= 100

        # Run async enrichment (await directly, not in background)
        import asyncio
        asyncio.create_task(run_async_enrichment_job(job_id, request, trigger_ml))

        return job_status

    except Exception as e:
        logger.error(f"Failed to start async enrichment: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/enrichment/daily-async")
async def run_daily_async_enrichment():
    """
    Run daily ASYNC enrichment (100 critical priority universities)

    AGGRESSIVE MODE: 3x larger batches for faster coverage
    """
    request = EnrichmentRequest(
        limit=100,
        priority='critical',
        dry_run=False,
        max_concurrent=20
    )
    return await start_async_enrichment(request)


@router.post("/enrichment/weekly-async")
async def run_weekly_async_enrichment():
    """
    Run weekly ASYNC enrichment (300 high priority universities)

    AGGRESSIVE MODE: 3x larger batches for faster coverage
    """
    request = EnrichmentRequest(
        limit=300,
        priority='high',
        dry_run=False,
        max_concurrent=25
    )
    return await start_async_enrichment(request)


@router.post("/enrichment/monthly-async")
async def run_monthly_async_enrichment():
    """
    Run monthly ASYNC enrichment (500 medium priority universities)

    AGGRESSIVE MODE: Runs every 2 hours for maximum coverage
    """
    request = EnrichmentRequest(
        limit=500,
        priority='medium',
        dry_run=False,
        max_concurrent=30
    )
    return await start_async_enrichment(request)


@router.post("/enrichment/us-universities")
async def enrich_us_universities(limit: int = 100):
    """
    Enrich US universities with College Scorecard data (priority endpoint)

    US universities are prioritized because College Scorecard API provides:
    - Official government data (high accuracy)
    - Comprehensive coverage (7,000+ institutions)
    - High-quality fields: acceptance rate, SAT/ACT scores, tuition, graduation rates

    Args:
        limit: Maximum universities to process (default: 100)
    """
    try:
        job_id = f"us_enrich_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        job_status = _create_job_in_db(job_id, status='pending', message='US university enrichment queued (College Scorecard priority)')

        import asyncio
        asyncio.create_task(run_us_enrichment_job(job_id, limit))

        return job_status

    except Exception as e:
        logger.error(f"Failed to start US enrichment: {e}")
        raise HTTPException(status_code=500, detail=str(e))


async def run_us_enrichment_job(job_id: str, limit: int):
    """Background task to run US-focused enrichment"""
    try:
        logger.info(f"Starting US university enrichment job {job_id}")
        _update_job_in_db(job_id, {'status': 'running', 'started_at': datetime.now()})

        db = get_supabase()

        # Use orchestrator with US-only query
        orchestrator = AsyncAutoFillOrchestrator(
            db=db,
            rate_limit_delay=0.5,  # Faster for College Scorecard
            max_concurrent=15
        )

        # Get US universities specifically
        universities = orchestrator.get_us_universities_to_enrich(limit=limit)

        if not universities:
            _update_job_in_db(job_id, {
                'status': 'completed',
                'completed_at': datetime.now(),
                'message': 'No US universities need enrichment'
            })
            return

        logger.info(f"Processing {len(universities)} US universities with College Scorecard priority")

        # Initialize enrichers
        from app.enrichment.async_web_search_enricher import AsyncWebSearchEnricher
        from app.enrichment.async_field_scrapers import AsyncFieldScrapers
        from app.enrichment.async_college_scorecard_enricher import AsyncCollegeScorecardEnricher
        from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache

        async with aiohttp.ClientSession() as session:
            web_enricher = AsyncWebSearchEnricher()
            field_scrapers = AsyncFieldScrapers()
            scorecard_enricher = AsyncCollegeScorecardEnricher()
            cache = AsyncEnrichmentCache(db)

            results = {'processed': 0, 'updated': 0, 'errors': 0, 'fields_filled': 0}

            for university in universities:
                try:
                    enriched_data, fields_filled = await orchestrator.enrich_university_async(
                        university, session, web_enricher, field_scrapers, scorecard_enricher, cache
                    )

                    if enriched_data:
                        success = orchestrator.update_university(university['id'], enriched_data)
                        if success:
                            results['updated'] += 1
                            results['fields_filled'] += fields_filled

                    results['processed'] += 1

                    # Update progress every 10 universities
                    if results['processed'] % 10 == 0:
                        _update_job_in_db(job_id, {
                            'universities_processed': results['processed'],
                            'universities_updated': results['updated'],
                            'total_fields_filled': results['fields_filled']
                        })

                except Exception as e:
                    logger.error(f"Error enriching {university.get('name')}: {e}")
                    results['errors'] += 1

        _update_job_in_db(job_id, {
            'status': 'completed',
            'completed_at': datetime.now(),
            'universities_processed': results['processed'],
            'universities_updated': results['updated'],
            'total_fields_filled': results['fields_filled'],
            'errors': results['errors'],
            'message': f"US university enrichment complete: {results['updated']}/{results['processed']} updated"
        })

        logger.info(f"US enrichment job {job_id} completed: {results}")

    except Exception as e:
        logger.error(f"US enrichment job {job_id} failed: {e}")
        _update_job_in_db(job_id, {
            'status': 'failed',
            'completed_at': datetime.now(),
            'message': str(e)
        })


@router.get("/enrichment/us-stats")
async def get_us_university_stats():
    """
    Get statistics about US universities and their enrichment status

    Shows how many US universities need College Scorecard enrichment
    """
    try:
        db = get_supabase()

        # Get all US universities
        response = db.table('universities').select('*').in_(
            'country', ['USA', 'United States', 'US', 'U.S.', 'U.S.A.']
        ).execute()

        us_universities = response.data or []
        total_us = len(us_universities)

        if total_us == 0:
            return {
                'total_us_universities': 0,
                'message': 'No US universities in database'
            }

        # Count fields that College Scorecard can provide
        scorecard_fields = [
            'city', 'state', 'website', 'location_type', 'university_type',
            'total_students', 'acceptance_rate', 'sat_math_25th', 'sat_math_75th',
            'sat_ebrw_25th', 'sat_ebrw_75th', 'act_composite_25th', 'act_composite_75th',
            'tuition_out_state', 'total_cost', 'graduation_rate_4year', 'median_earnings_10year'
        ]

        field_stats = {}
        need_enrichment = 0

        for uni in us_universities:
            needs_any = False
            for field in scorecard_fields:
                if field not in field_stats:
                    field_stats[field] = {'filled': 0, 'null': 0}

                if uni.get(field):
                    field_stats[field]['filled'] += 1
                else:
                    field_stats[field]['null'] += 1
                    needs_any = True

            if needs_any:
                need_enrichment += 1

        return {
            'total_us_universities': total_us,
            'need_enrichment': need_enrichment,
            'fully_enriched': total_us - need_enrichment,
            'enrichment_coverage': round((total_us - need_enrichment) / total_us * 100, 1),
            'field_stats': {
                field: {
                    'filled': stats['filled'],
                    'null': stats['null'],
                    'fill_rate': round(stats['filled'] / total_us * 100, 1)
                }
                for field, stats in sorted(field_stats.items(), key=lambda x: x[1]['null'], reverse=True)
            },
            'college_scorecard_api_status': 'Check COLLEGE_SCORECARD_API_KEY environment variable'
        }

    except Exception as e:
        logger.error(f"Failed to get US stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.delete("/enrichment/jobs")
async def clear_old_jobs():
    """Clear completed jobs older than 24 hours from database"""
    from datetime import timedelta

    try:
        db = get_supabase()
        cutoff = (datetime.now() - timedelta(hours=24)).isoformat()

        # Delete old completed/failed jobs
        response = db.table('enrichment_jobs')\
            .delete()\
            .in_('status', ['completed', 'failed', 'cancelled'])\
            .lt('completed_at', cutoff)\
            .execute()

        removed = len(response.data) if response.data else 0

        # Get remaining job count
        remaining_response = db.table('enrichment_jobs').select('job_id', count='exact').execute()
        remaining = remaining_response.count or 0

        return {
            'removed': removed,
            'remaining': remaining
        }
    except Exception as e:
        logger.error(f"Failed to clear old jobs: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/enrichment/cleanup-stuck")
async def cleanup_stuck_jobs():
    """
    Mark stuck 'running' jobs as failed (jobs running for more than 6 hours)

    Jobs can get stuck in 'running' state due to:
    - Server restarts during processing
    - Network timeouts
    - Unhandled exceptions

    This endpoint marks them as 'failed' so they stop showing in active jobs.
    """
    from datetime import timedelta

    try:
        db = get_supabase()
        cutoff = (datetime.now() - timedelta(hours=6)).isoformat()

        # Find stuck jobs (running for more than 6 hours)
        stuck_response = db.table('enrichment_jobs')\
            .select('job_id, started_at, processed_universities')\
            .eq('status', 'running')\
            .lt('started_at', cutoff)\
            .execute()

        stuck_jobs = stuck_response.data if stuck_response.data else []

        # Mark each stuck job as failed
        for job in stuck_jobs:
            db.table('enrichment_jobs')\
                .update({
                    'status': 'failed',
                    'completed_at': datetime.now().isoformat(),
                    'error_message': f'Job timed out after 6+ hours (processed {job.get("processed_universities", 0)} universities)'
                })\
                .eq('job_id', job['job_id'])\
                .execute()

        return {
            'success': True,
            'stuck_jobs_found': len(stuck_jobs),
            'jobs_marked_failed': len(stuck_jobs),
            'job_ids': [j['job_id'] for j in stuck_jobs],
            'message': f'Cleaned up {len(stuck_jobs)} stuck jobs',
            'timestamp': datetime.now().isoformat()
        }
    except Exception as e:
        logger.error(f"Failed to cleanup stuck jobs: {e}")
        raise HTTPException(status_code=500, detail=str(e))


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
