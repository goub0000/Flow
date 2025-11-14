"""
In-Memory Job Queue with Database Persistence
Lightweight alternative to Redis/Celery for background jobs
"""
import asyncio
import uuid
from datetime import datetime, timedelta
from enum import Enum
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
import json
import logging
from threading import Lock

from app.database.config import get_supabase

logger = logging.getLogger(__name__)


class JobStatus(str, Enum):
    """Job execution status"""
    PENDING = "pending"      # Job queued, waiting to start
    RUNNING = "running"      # Job currently executing
    COMPLETED = "completed"  # Job finished successfully
    FAILED = "failed"        # Job failed with error
    CANCELLED = "cancelled"  # Job cancelled by user


@dataclass
class EnrichmentJob:
    """Represents an enrichment job"""
    job_id: str
    status: JobStatus
    created_at: datetime
    started_at: Optional[datetime] = None
    completed_at: Optional[datetime] = None

    # Job parameters
    university_limit: Optional[int] = None
    university_ids: Optional[List[int]] = None
    max_concurrent: int = 5

    # Progress tracking
    total_universities: int = 0
    processed_universities: int = 0
    successful_updates: int = 0
    total_fields_filled: int = 0
    errors_count: int = 0

    # Results
    error_message: Optional[str] = None
    results: Optional[Dict[str, Any]] = None

    def to_dict(self) -> Dict:
        """Convert to dictionary for JSON serialization"""
        data = asdict(self)
        # Convert datetime objects to ISO strings
        for key in ['created_at', 'started_at', 'completed_at']:
            if data[key]:
                data[key] = data[key].isoformat()
        # Convert enum to string
        data['status'] = self.status.value
        return data

    @classmethod
    def from_dict(cls, data: Dict) -> 'EnrichmentJob':
        """Create from dictionary"""
        # Convert ISO strings to datetime
        for key in ['created_at', 'started_at', 'completed_at']:
            if data.get(key):
                data[key] = datetime.fromisoformat(data[key])
        # Convert string to enum
        if isinstance(data.get('status'), str):
            data['status'] = JobStatus(data['status'])
        return cls(**data)


class JobQueue:
    """
    In-memory job queue with database persistence
    Singleton pattern to ensure single queue instance
    """
    _instance = None
    _lock = Lock()

    def __new__(cls):
        if cls._instance is None:
            with cls._lock:
                if cls._instance is None:
                    cls._instance = super().__new__(cls)
                    cls._instance._initialized = False
        return cls._instance

    def __init__(self):
        if self._initialized:
            return

        self.jobs: Dict[str, EnrichmentJob] = {}
        self.pending_queue: List[str] = []  # Job IDs in FIFO order
        self.db = get_supabase()
        self._initialized = True

        # Load pending jobs from database on startup
        self._load_pending_jobs()

        logger.info("JobQueue initialized")

    def _load_pending_jobs(self):
        """Load pending/running jobs from database on startup"""
        try:
            response = self.db.table('enrichment_jobs')\
                .select('*')\
                .in_('status', ['pending', 'running'])\
                .order('created_at')\
                .execute()

            if response.data:
                for job_data in response.data:
                    job = EnrichmentJob.from_dict(job_data)
                    self.jobs[job.job_id] = job
                    if job.status == JobStatus.PENDING:
                        self.pending_queue.append(job.job_id)

                logger.info(f"Loaded {len(response.data)} pending/running jobs from database")
        except Exception as e:
            logger.warning(f"Could not load pending jobs from database: {e}")

    def create_job(
        self,
        limit: Optional[int] = None,
        university_ids: Optional[List[int]] = None,
        max_concurrent: int = 5
    ) -> EnrichmentJob:
        """
        Create a new enrichment job

        Args:
            limit: Maximum number of universities to enrich
            university_ids: Specific university IDs to enrich (overrides limit)
            max_concurrent: Maximum concurrent enrichment operations

        Returns:
            EnrichmentJob instance
        """
        job_id = str(uuid.uuid4())

        job = EnrichmentJob(
            job_id=job_id,
            status=JobStatus.PENDING,
            created_at=datetime.utcnow(),
            university_limit=limit,
            university_ids=university_ids,
            max_concurrent=max_concurrent
        )

        # Save to memory
        self.jobs[job_id] = job
        self.pending_queue.append(job_id)

        # Persist to database
        try:
            self.db.table('enrichment_jobs').insert(job.to_dict()).execute()
        except Exception as e:
            logger.error(f"Failed to persist job {job_id} to database: {e}")

        logger.info(f"Created enrichment job {job_id} (limit={limit}, ids={university_ids})")
        return job

    def get_job(self, job_id: str) -> Optional[EnrichmentJob]:
        """Get job by ID"""
        # Check memory first
        if job_id in self.jobs:
            return self.jobs[job_id]

        # Fallback to database
        try:
            response = self.db.table('enrichment_jobs')\
                .select('*')\
                .eq('job_id', job_id)\
                .execute()

            if response.data:
                job = EnrichmentJob.from_dict(response.data[0])
                self.jobs[job_id] = job  # Cache in memory
                return job
        except Exception as e:
            logger.error(f"Failed to fetch job {job_id} from database: {e}")

        return None

    def get_next_pending_job(self) -> Optional[EnrichmentJob]:
        """Get next pending job from queue (FIFO)"""
        while self.pending_queue:
            job_id = self.pending_queue[0]
            job = self.jobs.get(job_id)

            if job and job.status == JobStatus.PENDING:
                return job

            # Remove stale entry
            self.pending_queue.pop(0)

        return None

    def update_job_status(
        self,
        job_id: str,
        status: JobStatus,
        **kwargs
    ):
        """
        Update job status and other fields

        Args:
            job_id: Job identifier
            status: New status
            **kwargs: Additional fields to update (error_message, results, etc.)
        """
        job = self.jobs.get(job_id)
        if not job:
            logger.warning(f"Job {job_id} not found")
            return

        # Update status
        old_status = job.status
        job.status = status

        # Update timestamps
        if status == JobStatus.RUNNING and not job.started_at:
            job.started_at = datetime.utcnow()
        elif status in [JobStatus.COMPLETED, JobStatus.FAILED, JobStatus.CANCELLED]:
            job.completed_at = datetime.utcnow()
            # Remove from pending queue if present
            if job_id in self.pending_queue:
                self.pending_queue.remove(job_id)

        # Update additional fields
        for key, value in kwargs.items():
            if hasattr(job, key):
                setattr(job, key, value)

        # Persist to database
        try:
            self.db.table('enrichment_jobs')\
                .update(job.to_dict())\
                .eq('job_id', job_id)\
                .execute()
        except Exception as e:
            logger.error(f"Failed to update job {job_id} in database: {e}")

        logger.info(f"Job {job_id} status: {old_status.value} -> {status.value}")

    def update_job_progress(
        self,
        job_id: str,
        processed: int = 0,
        successful: int = 0,
        fields_filled: int = 0,
        errors: int = 0
    ):
        """
        Update job progress counters (incremental)

        Args:
            job_id: Job identifier
            processed: Number of universities processed (increment)
            successful: Number of successful updates (increment)
            fields_filled: Number of fields filled (increment)
            errors: Number of errors encountered (increment)
        """
        job = self.jobs.get(job_id)
        if not job:
            return

        job.processed_universities += processed
        job.successful_updates += successful
        job.total_fields_filled += fields_filled
        job.errors_count += errors

        # Persist to database (less frequent updates to reduce DB load)
        # Only update every 10 universities or on completion
        if job.processed_universities % 10 == 0 or job.processed_universities == job.total_universities:
            try:
                self.db.table('enrichment_jobs')\
                    .update({
                        'processed_universities': job.processed_universities,
                        'successful_updates': job.successful_updates,
                        'total_fields_filled': job.total_fields_filled,
                        'errors_count': job.errors_count
                    })\
                    .eq('job_id', job_id)\
                    .execute()
            except Exception as e:
                logger.error(f"Failed to update job progress in database: {e}")

    def list_jobs(
        self,
        status: Optional[JobStatus] = None,
        limit: int = 50,
        offset: int = 0
    ) -> List[EnrichmentJob]:
        """
        List jobs with optional filtering

        Args:
            status: Filter by status (None = all)
            limit: Maximum number of jobs to return
            offset: Offset for pagination

        Returns:
            List of EnrichmentJob instances
        """
        try:
            query = self.db.table('enrichment_jobs').select('*')

            if status:
                query = query.eq('status', status.value)

            response = query.order('created_at', desc=True)\
                .range(offset, offset + limit - 1)\
                .execute()

            if response.data:
                jobs = [EnrichmentJob.from_dict(job_data) for job_data in response.data]
                # Update memory cache
                for job in jobs:
                    self.jobs[job.job_id] = job
                return jobs
        except Exception as e:
            logger.error(f"Failed to list jobs: {e}")

        return []

    def get_queue_stats(self) -> Dict[str, Any]:
        """Get queue statistics"""
        try:
            # Count by status
            response = self.db.table('enrichment_jobs')\
                .select('status', count='exact')\
                .execute()

            status_counts = {status.value: 0 for status in JobStatus}
            if response.data:
                for job in response.data:
                    status = job.get('status', 'unknown')
                    if status in status_counts:
                        status_counts[status] += 1

            return {
                'pending_count': status_counts['pending'],
                'running_count': status_counts['running'],
                'completed_count': status_counts['completed'],
                'failed_count': status_counts['failed'],
                'cancelled_count': status_counts['cancelled'],
                'total_jobs': sum(status_counts.values()),
                'memory_cached_jobs': len(self.jobs),
                'pending_queue_size': len(self.pending_queue)
            }
        except Exception as e:
            logger.error(f"Failed to get queue stats: {e}")
            return {'error': str(e)}

    def cancel_job(self, job_id: str) -> bool:
        """
        Cancel a pending job

        Args:
            job_id: Job identifier

        Returns:
            True if cancelled successfully, False otherwise
        """
        job = self.jobs.get(job_id)
        if not job:
            return False

        if job.status != JobStatus.PENDING:
            logger.warning(f"Cannot cancel job {job_id} with status {job.status.value}")
            return False

        self.update_job_status(job_id, JobStatus.CANCELLED)
        return True

    def cleanup_old_jobs(self, days: int = 7) -> int:
        """
        Delete completed/failed jobs older than specified days

        Args:
            days: Number of days to keep

        Returns:
            Number of jobs deleted
        """
        try:
            cutoff_date = datetime.utcnow() - timedelta(days=days)

            response = self.db.table('enrichment_jobs')\
                .delete()\
                .in_('status', ['completed', 'failed', 'cancelled'])\
                .lt('completed_at', cutoff_date.isoformat())\
                .execute()

            deleted_count = len(response.data) if response.data else 0

            # Remove from memory cache
            deleted_ids = [job['job_id'] for job in response.data] if response.data else []
            for job_id in deleted_ids:
                self.jobs.pop(job_id, None)

            logger.info(f"Cleaned up {deleted_count} old jobs")
            return deleted_count
        except Exception as e:
            logger.error(f"Failed to cleanup old jobs: {e}")
            return 0


# Global singleton instance
job_queue = JobQueue()
