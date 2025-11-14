"""
Batch Enrichment API
REST endpoints for managing background enrichment jobs
"""
from fastapi import APIRouter, HTTPException, BackgroundTasks
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime
import asyncio

from app.jobs.job_queue import job_queue, JobStatus
from app.jobs.enrichment_worker import EnrichmentWorker

router = APIRouter()


# Request/Response Models
class CreateJobRequest(BaseModel):
    """Request model for creating enrichment job"""
    limit: Optional[int] = Field(None, description="Maximum number of universities to enrich (None = all)")
    university_ids: Optional[List[int]] = Field(None, description="Specific university IDs to enrich")
    max_concurrent: int = Field(5, ge=1, le=20, description="Maximum concurrent enrichment operations")

    class Config:
        json_schema_extra = {
            "example": {
                "limit": 100,
                "max_concurrent": 10
            }
        }


class JobResponse(BaseModel):
    """Response model for job information"""
    job_id: str
    status: str
    created_at: str
    started_at: Optional[str] = None
    completed_at: Optional[str] = None

    # Job parameters
    limit: Optional[int] = None
    university_ids: Optional[List[int]] = None
    max_concurrent: int

    # Progress
    total_universities: int
    processed_universities: int
    successful_updates: int
    total_fields_filled: int
    errors_count: int

    # Results
    error_message: Optional[str] = None
    results: Optional[dict] = None


class QueueStatsResponse(BaseModel):
    """Response model for queue statistics"""
    pending_count: int
    running_count: int
    completed_count: int
    failed_count: int
    cancelled_count: int
    total_jobs: int
    memory_cached_jobs: int
    pending_queue_size: int


# Background task runner
async def run_worker_task():
    """Run worker in background to process one job"""
    worker = EnrichmentWorker()
    await worker.run(continuous=False)


# API Endpoints
@router.post("/jobs", response_model=JobResponse, status_code=201)
async def create_enrichment_job(
    request: CreateJobRequest,
    background_tasks: BackgroundTasks
):
    """
    Create a new batch enrichment job

    The job will be queued and processed asynchronously in the background.
    Use the returned job_id to check status and progress.

    **Request Body:**
    - `limit` (optional): Maximum number of universities to enrich. If not specified, enriches all.
    - `university_ids` (optional): Specific university IDs to enrich. Overrides `limit`.
    - `max_concurrent` (optional): Maximum concurrent enrichment operations (1-20, default: 5)

    **Example Request:**
    ```json
    {
        "limit": 100,
        "max_concurrent": 10
    }
    ```

    **Returns:**
    - Job details including job_id for tracking
    """
    # Validate request
    if request.university_ids and request.limit:
        raise HTTPException(
            status_code=400,
            detail="Cannot specify both 'university_ids' and 'limit'. Use one or the other."
        )

    # Create job
    job = job_queue.create_job(
        limit=request.limit,
        university_ids=request.university_ids,
        max_concurrent=request.max_concurrent
    )

    # Start worker in background
    background_tasks.add_task(run_worker_task)

    # Return job details
    return JobResponse(**job.to_dict())


@router.get("/jobs/{job_id}", response_model=JobResponse)
async def get_job_status(job_id: str):
    """
    Get status and progress of an enrichment job

    **Path Parameters:**
    - `job_id`: Job identifier returned when creating the job

    **Returns:**
    - Complete job details including progress and results

    **Status Values:**
    - `pending`: Job queued, waiting to start
    - `running`: Job currently executing
    - `completed`: Job finished successfully
    - `failed`: Job failed with error
    - `cancelled`: Job cancelled by user
    """
    job = job_queue.get_job(job_id)

    if not job:
        raise HTTPException(status_code=404, detail=f"Job {job_id} not found")

    return JobResponse(**job.to_dict())


@router.get("/jobs", response_model=List[JobResponse])
async def list_jobs(
    status: Optional[str] = None,
    limit: int = 50,
    offset: int = 0
):
    """
    List enrichment jobs with optional filtering

    **Query Parameters:**
    - `status` (optional): Filter by status (pending, running, completed, failed, cancelled)
    - `limit` (optional): Maximum number of jobs to return (default: 50, max: 200)
    - `offset` (optional): Offset for pagination (default: 0)

    **Example:**
    ```
    GET /api/v1/batch/jobs?status=running&limit=10
    ```

    **Returns:**
    - List of jobs matching the criteria
    """
    # Validate status
    job_status = None
    if status:
        try:
            job_status = JobStatus(status)
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid status '{status}'. Must be one of: pending, running, completed, failed, cancelled"
            )

    # Validate limit
    if limit < 1 or limit > 200:
        raise HTTPException(status_code=400, detail="Limit must be between 1 and 200")

    # Get jobs
    jobs = job_queue.list_jobs(status=job_status, limit=limit, offset=offset)

    return [JobResponse(**job.to_dict()) for job in jobs]


@router.delete("/jobs/{job_id}", status_code=200)
async def cancel_job(job_id: str):
    """
    Cancel a pending enrichment job

    Only jobs with status 'pending' can be cancelled.
    Running jobs cannot be cancelled (they will complete).

    **Path Parameters:**
    - `job_id`: Job identifier

    **Returns:**
    - Success message

    **Errors:**
    - 404: Job not found
    - 400: Job cannot be cancelled (already running/completed)
    """
    job = job_queue.get_job(job_id)

    if not job:
        raise HTTPException(status_code=404, detail=f"Job {job_id} not found")

    if job.status != JobStatus.PENDING:
        raise HTTPException(
            status_code=400,
            detail=f"Cannot cancel job with status '{job.status.value}'. Only pending jobs can be cancelled."
        )

    success = job_queue.cancel_job(job_id)

    if not success:
        raise HTTPException(status_code=500, detail="Failed to cancel job")

    return {
        "success": True,
        "message": f"Job {job_id} cancelled successfully",
        "job_id": job_id
    }


@router.get("/queue/stats", response_model=QueueStatsResponse)
async def get_queue_stats():
    """
    Get job queue statistics

    **Returns:**
    - Total counts by status
    - Queue health metrics

    **Example Response:**
    ```json
    {
        "pending_count": 5,
        "running_count": 1,
        "completed_count": 143,
        "failed_count": 2,
        "cancelled_count": 0,
        "total_jobs": 151,
        "memory_cached_jobs": 25,
        "pending_queue_size": 5
    }
    ```
    """
    stats = job_queue.get_queue_stats()
    return QueueStatsResponse(**stats)


@router.post("/queue/cleanup", status_code=200)
async def cleanup_old_jobs(days: int = 7):
    """
    Delete completed/failed jobs older than specified days

    This helps keep the database clean and reduces clutter.
    Only affects completed, failed, or cancelled jobs.
    Pending and running jobs are never deleted.

    **Query Parameters:**
    - `days` (optional): Number of days to keep (default: 7)

    **Example:**
    ```
    POST /api/v1/batch/queue/cleanup?days=30
    ```

    **Returns:**
    - Number of jobs deleted
    """
    if days < 1 or days > 365:
        raise HTTPException(status_code=400, detail="Days must be between 1 and 365")

    deleted_count = job_queue.cleanup_old_jobs(days=days)

    return {
        "success": True,
        "deleted_count": deleted_count,
        "message": f"Deleted {deleted_count} jobs older than {days} days"
    }


@router.post("/worker/start", status_code=200)
async def start_worker(background_tasks: BackgroundTasks):
    """
    Manually start a background worker to process pending jobs

    Normally, workers start automatically when jobs are created.
    Use this endpoint if you need to manually trigger job processing.

    **Returns:**
    - Confirmation that worker was started
    """
    # Check if there are pending jobs
    stats = job_queue.get_queue_stats()

    if stats['pending_count'] == 0:
        return {
            "success": True,
            "message": "No pending jobs to process",
            "pending_count": 0
        }

    # Start worker in background
    background_tasks.add_task(run_worker_task)

    return {
        "success": True,
        "message": f"Worker started to process {stats['pending_count']} pending job(s)",
        "pending_count": stats['pending_count']
    }


@router.get("/health", status_code=200)
async def batch_system_health():
    """
    Check batch processing system health

    **Returns:**
    - System status and diagnostics
    """
    stats = job_queue.get_queue_stats()

    # Determine health status
    health_status = "healthy"
    warnings = []

    if stats['failed_count'] > stats['completed_count'] * 0.1:
        health_status = "degraded"
        warnings.append(f"High failure rate: {stats['failed_count']} failed vs {stats['completed_count']} completed")

    if stats['pending_count'] > 100:
        health_status = "degraded"
        warnings.append(f"Large pending queue: {stats['pending_count']} jobs waiting")

    if stats['running_count'] > 10:
        warnings.append(f"Many concurrent jobs: {stats['running_count']} running")

    return {
        "status": health_status,
        "timestamp": datetime.utcnow().isoformat(),
        "queue_stats": stats,
        "warnings": warnings,
        "recommendations": [
            "Run /queue/cleanup regularly to remove old jobs",
            "Monitor failure rate and investigate common errors",
            "Adjust max_concurrent parameter based on system resources"
        ] if warnings else []
    }
