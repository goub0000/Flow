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
