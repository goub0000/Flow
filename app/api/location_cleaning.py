"""
Location Cleaning API - Clean country codes and state values
"""
from fastapi import APIRouter, BackgroundTasks
from pydantic import BaseModel
from typing import Dict, List, Optional
from datetime import datetime
import logging
import uuid

from app.database.config import get_supabase
from app.enrichment.location_cleaner import LocationCleaner

router = APIRouter()
logger = logging.getLogger(__name__)

# In-memory job tracking
cleaning_jobs = {}


class CleaningRequest(BaseModel):
    """Request to clean location data"""
    batch_size: int = 100
    preview_only: bool = False


class CleaningStatus(BaseModel):
    """Status of a cleaning job"""
    job_id: str
    status: str
    started_at: datetime
    completed_at: Optional[datetime] = None
    total_processed: int = 0
    countries_updated: int = 0
    states_updated: int = 0
    states_nullified: int = 0
    errors: int = 0
    message: str = ""


class PreviewResponse(BaseModel):
    """Preview of changes that would be made"""
    total_changes: int
    sample_changes: List[Dict]


def run_cleaning_job(job_id: str, request: CleaningRequest):
    """Background task to run location cleaning"""
    try:
        logger.info(f"Starting location cleaning job {job_id}")
        cleaning_jobs[job_id]['status'] = 'running'

        db = get_supabase()
        cleaner = LocationCleaner(db=db)

        # Run cleaning
        stats = cleaner.clean_all_locations(batch_size=request.batch_size)

        cleaning_jobs[job_id].update({
            'status': 'completed',
            'completed_at': datetime.now(),
            'total_processed': stats['total_processed'],
            'countries_updated': stats['countries_updated'],
            'states_updated': stats['states_updated'],
            'states_nullified': stats['states_nullified'],
            'errors': stats['errors'],
            'message': f"Cleaned {stats['countries_updated']} countries and {stats['states_updated']} states"
        })

        logger.info(f"Location cleaning job {job_id} completed successfully")

    except Exception as e:
        logger.error(f"Location cleaning job {job_id} failed: {e}")
        cleaning_jobs[job_id].update({
            'status': 'failed',
            'completed_at': datetime.now(),
            'message': str(e)
        })


@router.post("/location-cleaning/start", response_model=Dict)
def start_location_cleaning(
    request: CleaningRequest,
    background_tasks: BackgroundTasks
):
    """
    Start location data cleaning (countries and states)

    This will:
    - Convert 2-letter ISO country codes to full names (US -> United States)
    - Remove "XX" placeholder countries
    - Convert US state codes to full names (CA -> California)
    - Convert Canadian province codes to full names
    - Remove invalid/nonsensical state values
    """
    job_id = f"clean_{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex[:8]}"

    cleaning_jobs[job_id] = {
        'job_id': job_id,
        'status': 'pending',
        'started_at': datetime.now(),
        'completed_at': None,
        'total_processed': 0,
        'countries_updated': 0,
        'states_updated': 0,
        'states_nullified': 0,
        'errors': 0,
        'message': 'Location cleaning job queued'
    }

    # Start background task
    background_tasks.add_task(run_cleaning_job, job_id, request)

    logger.info(f"Location cleaning job {job_id} started")

    return {
        'job_id': job_id,
        'status': 'pending',
        'message': 'Location cleaning job started. Use /location-cleaning/status/{job_id} to check progress.'
    }


@router.get("/location-cleaning/status/{job_id}", response_model=CleaningStatus)
def get_cleaning_status(job_id: str):
    """Get status of a location cleaning job"""
    if job_id not in cleaning_jobs:
        return {
            'job_id': job_id,
            'status': 'not_found',
            'started_at': datetime.now(),
            'message': 'Job not found'
        }

    return cleaning_jobs[job_id]


@router.get("/location-cleaning/preview", response_model=PreviewResponse)
def preview_location_changes(limit: int = 50):
    """
    Preview changes that would be made without actually updating

    Args:
        limit: Number of universities to preview (max 100)

    Returns:
        Sample of changes that would be made
    """
    limit = min(limit, 100)  # Cap at 100 for performance

    db = get_supabase()
    cleaner = LocationCleaner(db=db)

    changes = cleaner.preview_changes(limit=limit)

    return {
        'total_changes': len(changes),
        'sample_changes': changes
    }


@router.post("/location-cleaning/clean-all")
def clean_all_locations_now(background_tasks: BackgroundTasks):
    """
    Convenient endpoint to clean all location data immediately
    Uses default batch size of 100
    """
    return start_location_cleaning(
        CleaningRequest(batch_size=100, preview_only=False),
        background_tasks
    )


@router.get("/location-cleaning/analyze")
def analyze_location_data():
    """
    Analyze current location data quality
    Shows statistics about country codes and state values
    """
    db = get_supabase()

    # Get sample of data
    response = db.table('universities').select('country', 'state').limit(1000).execute()
    universities = response.data

    from collections import Counter

    countries = [u.get('country') for u in universities if u.get('country')]
    states = [u.get('state') for u in universities if u.get('state')]

    country_counts = Counter(countries)
    state_counts = Counter(states)

    # Identify issues
    two_letter_countries = [c for c in countries if len(c) == 2]
    xx_countries = [c for c in countries if c == 'XX']

    return {
        'total_analyzed': len(universities),
        'countries': {
            'total_with_country': len(countries),
            'total_null': len(universities) - len(countries),
            'unique_values': len(country_counts),
            'two_letter_codes': len(two_letter_countries),
            'xx_placeholder': len(xx_countries),
            'top_10_values': dict(country_counts.most_common(10))
        },
        'states': {
            'total_with_state': len(states),
            'total_null': len(universities) - len(states),
            'unique_values': len(state_counts),
            'top_10_values': dict(state_counts.most_common(10))
        }
    }
