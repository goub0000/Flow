"""
Admin/Management API Endpoints
Includes data enrichment and other administrative tasks
"""
from fastapi import APIRouter, BackgroundTasks, HTTPException
from pydantic import BaseModel
from typing import Optional
import logging
from datetime import datetime

from app.database.config import get_supabase
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.enrichment.web_search_enricher import WebSearchEnricher
from app.enrichment.field_scrapers import FieldSpecificScrapers

router = APIRouter()
logger = logging.getLogger(__name__)

# Global variable to track enrichment status
enrichment_status = {
    "running": False,
    "start_time": None,
    "progress": 0,
    "total": 0,
    "fields_filled": 0,
    "errors": 0
}


class EnrichmentRequest(BaseModel):
    limit: Optional[int] = None
    priority_high_only: bool = False
    rate_limit_delay: float = 3.0


def run_enrichment_task(limit: Optional[int], priority_high_only: bool, rate_limit_delay: float):
    """Background task to run data enrichment"""
    global enrichment_status

    try:
        enrichment_status["running"] = True
        enrichment_status["start_time"] = datetime.utcnow()
        enrichment_status["progress"] = 0
        enrichment_status["total"] = 0
        enrichment_status["fields_filled"] = 0
        enrichment_status["errors"] = 0

        logger.info(f"Starting data enrichment (limit={limit}, priority_high={priority_high_only})")

        db = get_supabase()
        orchestrator = AutoFillOrchestrator(db, rate_limit_delay=rate_limit_delay)

        # Determine priority fields
        priority_fields = None
        if priority_high_only:
            priority_fields = [
                'acceptance_rate', 'gpa_average', 'graduation_rate_4year',
                'total_students', 'tuition_out_state', 'total_cost'
            ]

        # Run enrichment
        stats = orchestrator.run_enrichment(
            limit=limit,
            priority_fields=priority_fields,
            dry_run=False
        )

        # Update status
        enrichment_status["progress"] = stats["total_processed"]
        enrichment_status["total"] = stats["total_processed"]
        enrichment_status["fields_filled"] = sum(stats["fields_filled"].values())
        enrichment_status["errors"] = stats["errors"]
        enrichment_status["running"] = False

        logger.info(f"Enrichment complete: {stats['total_processed']} universities processed")

    except Exception as e:
        logger.error(f"Enrichment failed: {e}", exc_info=True)
        enrichment_status["running"] = False
        enrichment_status["errors"] += 1


@router.post("/admin/enrich/start")
async def start_enrichment(
    request: EnrichmentRequest,
    background_tasks: BackgroundTasks
):
    """
    Start data enrichment process in the background

    This endpoint triggers the web scraping enrichment process that fills
    NULL values in the university database.

    - **limit**: Maximum number of universities to process (None = all)
    - **priority_high_only**: Only fill high-priority fields (acceptance_rate, costs, etc.)
    - **rate_limit_delay**: Delay between web requests in seconds (default: 3.0)

    Returns immediately while enrichment runs in background.
    Use /admin/enrich/status to check progress.
    """
    global enrichment_status

    if enrichment_status["running"]:
        raise HTTPException(
            status_code=409,
            detail="Enrichment process is already running"
        )

    # Start enrichment in background
    background_tasks.add_task(
        run_enrichment_task,
        request.limit,
        request.priority_high_only,
        request.rate_limit_delay
    )

    return {
        "message": "Data enrichment started",
        "limit": request.limit,
        "priority_high_only": request.priority_high_only,
        "rate_limit_delay": request.rate_limit_delay
    }


@router.get("/admin/enrich/status")
async def get_enrichment_status():
    """
    Get current status of data enrichment process

    Returns:
    - running: Whether enrichment is currently running
    - start_time: When the current/last enrichment started
    - progress: Number of universities processed
    - total: Total universities to process
    - fields_filled: Total fields filled so far
    - errors: Number of errors encountered
    """
    return enrichment_status


@router.post("/admin/enrich/analyze")
async def analyze_null_values():
    """
    Analyze NULL values in the database

    Returns statistics about NULL values per field, including:
    - null_count: Number of NULL values
    - percentage: Percentage of records with NULL
    - priority: Field priority (1=HIGH, 2=MEDIUM, 3=LOW)
    """
    try:
        db = get_supabase()
        orchestrator = AutoFillOrchestrator(db)

        analysis = orchestrator.analyze_null_values()

        # Sort by null count (descending)
        sorted_analysis = dict(sorted(
            analysis.items(),
            key=lambda x: x[1]['null_count'],
            reverse=True
        ))

        total_nulls = sum(s['null_count'] for s in analysis.values())
        high_priority_nulls = sum(
            s['null_count'] for s in analysis.values() if s['priority'] == 1
        )

        return {
            "fields": sorted_analysis,
            "summary": {
                "total_null_values": total_nulls,
                "high_priority_nulls": high_priority_nulls
            }
        }

    except Exception as e:
        logger.error(f"Analysis failed: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=str(e))
