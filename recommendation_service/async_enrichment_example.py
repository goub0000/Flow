"""
Async Enrichment Usage Example
Demonstrates the performance improvement of async enrichment
"""
import asyncio
import logging
from dotenv import load_dotenv
load_dotenv()

from app.database.config import get_supabase
from app.enrichment.async_auto_fill_orchestrator import AsyncAutoFillOrchestrator
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


async def test_async_enrichment():
    """Test async enrichment performance"""

    logger.info("=" * 80)
    logger.info("ASYNC ENRICHMENT PERFORMANCE TEST")
    logger.info("=" * 80)

    # Initialize database connection
    db = get_supabase()

    # Test parameters
    TEST_LIMIT = 30  # Number of universities to enrich
    MAX_CONCURRENT = 10  # Concurrent enrichments

    # ===== ASYNC VERSION =====
    logger.info("\n" + "=" * 80)
    logger.info("TESTING ASYNC VERSION")
    logger.info(f"Limit: {TEST_LIMIT} universities")
    logger.info(f"Max concurrent: {MAX_CONCURRENT}")
    logger.info("=" * 80 + "\n")

    async_orchestrator = AsyncAutoFillOrchestrator(
        db=db,
        rate_limit_delay=0.5,  # Reduced delay for async
        max_concurrent=MAX_CONCURRENT
    )

    async_stats = await async_orchestrator.run_enrichment_async(
        limit=TEST_LIMIT,
        dry_run=True  # Don't actually update DB for testing
    )

    # ===== SYNC VERSION (for comparison) =====
    logger.info("\n" + "=" * 80)
    logger.info("TESTING SYNC VERSION (for comparison)")
    logger.info(f"Limit: {TEST_LIMIT} universities")
    logger.info("=" * 80 + "\n")

    sync_orchestrator = AutoFillOrchestrator(
        db=db,
        rate_limit_delay=0.5
    )

    sync_stats = sync_orchestrator.run_enrichment(
        limit=TEST_LIMIT,
        dry_run=True  # Don't actually update DB for testing
    )

    # ===== PERFORMANCE COMPARISON =====
    logger.info("\n" + "=" * 80)
    logger.info("PERFORMANCE COMPARISON")
    logger.info("=" * 80)

    async_duration = (async_stats['end_time'] - async_stats['start_time']).total_seconds()
    sync_duration = (sync_stats['end_time'] - sync_stats['start_time']).total_seconds()

    speedup = sync_duration / async_duration if async_duration > 0 else 0

    logger.info(f"\nAsync Version:")
    logger.info(f"  Duration: {async_duration:.1f} seconds ({async_duration/60:.1f} minutes)")
    logger.info(f"  Speed: {async_stats['total_processed']/async_duration:.2f} universities/second")
    logger.info(f"  Fields filled: {sum(async_stats['fields_filled'].values())}")
    logger.info(f"  Errors: {async_stats['errors']}")

    logger.info(f"\nSync Version:")
    logger.info(f"  Duration: {sync_duration:.1f} seconds ({sync_duration/60:.1f} minutes)")
    logger.info(f"  Speed: {sync_stats['total_processed']/sync_duration:.2f} universities/second")
    logger.info(f"  Fields filled: {sum(sync_stats['fields_filled'].values())}")
    logger.info(f"  Errors: {sync_stats['errors']}")

    logger.info(f"\nSpeedup: {speedup:.2f}x faster")
    logger.info(f"Time saved: {sync_duration - async_duration:.1f} seconds")

    # Estimate full database enrichment time
    total_universities = 17137
    async_time_full = (total_universities / async_stats['total_processed']) * async_duration
    sync_time_full = (total_universities / sync_stats['total_processed']) * sync_duration

    logger.info(f"\nProjected Full Database Enrichment (17,137 universities):")
    logger.info(f"  Async: {async_time_full/3600:.1f} hours ({async_time_full/86400:.1f} days)")
    logger.info(f"  Sync: {sync_time_full/3600:.1f} hours ({sync_time_full/86400:.1f} days)")
    logger.info(f"  Time saved: {(sync_time_full - async_time_full)/3600:.1f} hours")

    logger.info("\n" + "=" * 80)
    logger.info("TEST COMPLETE")
    logger.info("=" * 80)


def run_async_enrichment_production(limit: int = 100, max_concurrent: int = 10):
    """
    Run async enrichment in production mode

    Args:
        limit: Number of universities to enrich
        max_concurrent: Maximum concurrent enrichments
    """

    async def _run():
        db = get_supabase()

        orchestrator = AsyncAutoFillOrchestrator(
            db=db,
            rate_limit_delay=1.0,  # 1 second delay to be polite
            max_concurrent=max_concurrent
        )

        stats = await orchestrator.run_enrichment_async(
            limit=limit,
            dry_run=False  # Actually update the database
        )

        return stats

    return asyncio.run(_run())


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "test":
        # Run performance test
        asyncio.run(test_async_enrichment())
    else:
        # Run production enrichment
        limit = int(sys.argv[1]) if len(sys.argv) > 1 else 100
        max_concurrent = int(sys.argv[2]) if len(sys.argv) > 2 else 10

        logger.info(f"Running async enrichment: {limit} universities, {max_concurrent} concurrent")
        stats = run_async_enrichment_production(limit, max_concurrent)

        logger.info("\nEnrichment complete!")
        logger.info(f"Universities processed: {stats['total_processed']}")
        logger.info(f"Universities updated: {stats['total_updated']}")
        logger.info(f"Fields filled: {sum(stats['fields_filled'].values())}")
