"""
Background Worker for Enrichment Jobs
Processes jobs from the queue asynchronously
"""
import asyncio
import logging
from typing import Optional
from datetime import datetime

from app.database.config import get_supabase
from app.enrichment.async_auto_fill_orchestrator import AsyncAutoFillOrchestrator
from app.enrichment.async_web_search_enricher import AsyncWebSearchEnricher
from app.enrichment.async_college_scorecard_enricher import AsyncCollegeScorecardEnricher
from app.enrichment.async_enrichment_cache import AsyncEnrichmentCache
from app.enrichment.field_scrapers import FIELD_SCRAPERS
from .job_queue import job_queue, JobStatus, EnrichmentJob

logger = logging.getLogger(__name__)


class EnrichmentWorker:
    """
    Background worker that processes enrichment jobs from the queue
    Runs continuously and picks up pending jobs
    """

    def __init__(self):
        self.db = get_supabase()
        self.orchestrator = AsyncAutoFillOrchestrator(self.db)
        self.is_running = False
        self.current_job_id: Optional[str] = None

    async def process_job(self, job: EnrichmentJob):
        """
        Process a single enrichment job

        Args:
            job: EnrichmentJob instance
        """
        logger.info(f"Starting job {job.job_id}")
        self.current_job_id = job.job_id

        try:
            # Mark job as running
            job_queue.update_job_status(job.job_id, JobStatus.RUNNING)

            # Initialize enrichers
            web_enricher = AsyncWebSearchEnricher()
            scorecard_enricher = AsyncCollegeScorecardEnricher()
            cache = AsyncEnrichmentCache(self.db)

            # Determine universities to enrich
            if job.university_ids:
                # Specific universities
                universities = []
                for uni_id in job.university_ids:
                    response = self.db.table('universities')\
                        .select('*')\
                        .eq('id', uni_id)\
                        .execute()
                    if response.data:
                        universities.extend(response.data)

                job.total_universities = len(universities)
                job_queue.update_job_status(
                    job.job_id,
                    JobStatus.RUNNING,
                    total_universities=len(universities)
                )

            else:
                # Find universities needing enrichment
                logger.info(f"Finding universities to enrich (limit={job.university_limit})")

                query = self.db.table('universities').select('*')

                # Add limit if specified
                if job.university_limit:
                    query = query.limit(job.university_limit)

                response = query.execute()
                universities = response.data if response.data else []

                job.total_universities = len(universities)
                job_queue.update_job_status(
                    job.job_id,
                    JobStatus.RUNNING,
                    total_universities=len(universities)
                )

            logger.info(f"Job {job.job_id}: Processing {len(universities)} universities")

            # Process universities with progress callbacks
            results = {
                'universities_processed': 0,
                'universities_updated': 0,
                'total_fields_filled': 0,
                'errors': [],
                'processing_details': []
            }

            # Create progress callback
            def progress_callback(university_name: str, fields_filled: int, error: Optional[str] = None):
                """Called after each university is processed"""
                results['universities_processed'] += 1

                if error:
                    results['errors'].append({
                        'university': university_name,
                        'error': error
                    })
                    job_queue.update_job_progress(
                        job.job_id,
                        processed=1,
                        errors=1
                    )
                else:
                    if fields_filled > 0:
                        results['universities_updated'] += 1
                        results['total_fields_filled'] += fields_filled

                    job_queue.update_job_progress(
                        job.job_id,
                        processed=1,
                        successful=1 if fields_filled > 0 else 0,
                        fields_filled=fields_filled
                    )

                # Log progress every 10 universities
                if results['universities_processed'] % 10 == 0:
                    logger.info(
                        f"Job {job.job_id}: Progress {results['universities_processed']}/{len(universities)} "
                        f"({results['total_fields_filled']} fields filled)"
                    )

            # Process universities concurrently
            semaphore = asyncio.Semaphore(job.max_concurrent)

            async def process_university(university):
                """Process single university with semaphore"""
                async with semaphore:
                    try:
                        enriched = await self.orchestrator.enrich_university_async(
                            university=university,
                            session=None,  # Session created internally
                            web_enricher=web_enricher,
                            field_scrapers=FIELD_SCRAPERS,
                            scorecard_enricher=scorecard_enricher,
                            cache=cache
                        )

                        fields_filled = len(enriched) if enriched else 0

                        # Update database if fields were enriched
                        if enriched:
                            try:
                                self.db.table('universities')\
                                    .update(enriched)\
                                    .eq('id', university['id'])\
                                    .execute()

                                progress_callback(university['name'], fields_filled)

                                results['processing_details'].append({
                                    'university': university['name'],
                                    'fields_filled': fields_filled,
                                    'fields': list(enriched.keys())
                                })
                            except Exception as e:
                                logger.error(f"Failed to update {university['name']}: {e}")
                                progress_callback(university['name'], 0, str(e))
                        else:
                            progress_callback(university['name'], 0)

                    except Exception as e:
                        logger.error(f"Error enriching {university['name']}: {e}")
                        progress_callback(university['name'], 0, str(e))

            # Run all enrichments concurrently
            await asyncio.gather(*[process_university(uni) for uni in universities])

            # Job completed successfully
            job_queue.update_job_status(
                job.job_id,
                JobStatus.COMPLETED,
                results=results
            )

            logger.info(
                f"Job {job.job_id} completed successfully: "
                f"{results['universities_updated']}/{results['universities_processed']} updated, "
                f"{results['total_fields_filled']} fields filled"
            )

        except Exception as e:
            # Job failed
            error_msg = str(e)
            logger.error(f"Job {job.job_id} failed: {error_msg}")
            job_queue.update_job_status(
                job.job_id,
                JobStatus.FAILED,
                error_message=error_msg
            )

        finally:
            self.current_job_id = None

    async def run(self, continuous: bool = True):
        """
        Run the worker

        Args:
            continuous: If True, runs continuously checking for jobs.
                       If False, processes one job and exits.
        """
        self.is_running = True
        logger.info(f"EnrichmentWorker started (continuous={continuous})")

        try:
            while self.is_running:
                # Get next pending job
                job = job_queue.get_next_pending_job()

                if job:
                    await self.process_job(job)
                else:
                    # No pending jobs
                    if not continuous:
                        logger.info("No pending jobs, exiting")
                        break

                    # Wait before checking again
                    await asyncio.sleep(5)

        except KeyboardInterrupt:
            logger.info("Worker interrupted by user")
        except Exception as e:
            logger.error(f"Worker error: {e}")
        finally:
            self.is_running = False
            logger.info("EnrichmentWorker stopped")

    def stop(self):
        """Stop the worker gracefully"""
        logger.info("Stopping worker...")
        self.is_running = False


# Standalone worker script support
if __name__ == "__main__":
    import sys

    # Configure logging
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

    # Parse command line arguments
    continuous = "--continuous" in sys.argv or "-c" in sys.argv

    # Run worker
    worker = EnrichmentWorker()

    try:
        asyncio.run(worker.run(continuous=continuous))
    except KeyboardInterrupt:
        logger.info("Worker stopped by user")
