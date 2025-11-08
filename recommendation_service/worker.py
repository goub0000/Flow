"""
Background Worker for Railway
Runs enrichment on schedule - no external cron needed!
"""
import schedule
import time
import logging
from datetime import datetime
from dotenv import load_dotenv
from app.enrichment.auto_fill_orchestrator import AutoFillOrchestrator
from app.database.config import get_supabase

# Load environment
load_dotenv()

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def daily_enrichment():
    """Run daily enrichment - 30 critical priority universities"""
    try:
        logger.info("=" * 80)
        logger.info(f"DAILY ENRICHMENT STARTED - {datetime.now()}")
        logger.info("=" * 80)

        orchestrator = AutoFillOrchestrator(
            rate_limit_delay=3.0,
            dry_run=False
        )

        # Enrich 30 critical priority universities
        results = orchestrator.fill_missing_data(
            limit=30,
            priority_fields=['acceptance_rate', 'gpa_average', 'graduation_rate_4year', 'tuition_out_state']
        )

        logger.info("=" * 80)
        logger.info(f"DAILY ENRICHMENT COMPLETED")
        logger.info(f"Processed: {results.get('processed', 0)}")
        logger.info(f"Updated: {results.get('updated', 0)}")
        logger.info(f"Errors: {results.get('errors', 0)}")
        logger.info("=" * 80)

    except Exception as e:
        logger.error(f"Daily enrichment failed: {e}", exc_info=True)


def weekly_enrichment():
    """Run weekly enrichment - 100 high priority universities"""
    try:
        logger.info("=" * 80)
        logger.info(f"WEEKLY ENRICHMENT STARTED - {datetime.now()}")
        logger.info("=" * 80)

        orchestrator = AutoFillOrchestrator(
            rate_limit_delay=3.0,
            dry_run=False
        )

        # Enrich 100 high priority universities
        results = orchestrator.fill_missing_data(
            limit=100,
            priority_fields=['total_students', 'total_cost', 'university_type', 'location_type']
        )

        logger.info("=" * 80)
        logger.info(f"WEEKLY ENRICHMENT COMPLETED")
        logger.info(f"Processed: {results.get('processed', 0)}")
        logger.info(f"Updated: {results.get('updated', 0)}")
        logger.info(f"Errors: {results.get('errors', 0)}")
        logger.info("=" * 80)

    except Exception as e:
        logger.error(f"Weekly enrichment failed: {e}", exc_info=True)


def monthly_enrichment():
    """Run monthly enrichment - 300 medium priority universities"""
    try:
        logger.info("=" * 80)
        logger.info(f"MONTHLY ENRICHMENT STARTED - {datetime.now()}")
        logger.info("=" * 80)

        orchestrator = AutoFillOrchestrator(
            rate_limit_delay=3.0,
            dry_run=False
        )

        # Enrich 300 medium priority universities
        results = orchestrator.fill_missing_data(
            limit=300,
            priority_fields=['website', 'logo_url', 'state', 'city']
        )

        logger.info("=" * 80)
        logger.info(f"MONTHLY ENRICHMENT COMPLETED")
        logger.info(f"Processed: {results.get('processed', 0)}")
        logger.info(f"Updated: {results.get('updated', 0)}")
        logger.info(f"Errors: {results.get('errors', 0)}")
        logger.info("=" * 80)

    except Exception as e:
        logger.error(f"Monthly enrichment failed: {e}", exc_info=True)


def check_monthly():
    """Run on 1st of month only"""
    if datetime.now().day == 1:
        monthly_enrichment()


def main():
    """Main worker loop"""
    logger.info("=" * 80)
    logger.info("RAILWAY ENRICHMENT WORKER STARTED")
    logger.info("=" * 80)
    logger.info("Schedule:")
    logger.info("  Daily:   02:00 AM - 30 critical universities")
    logger.info("  Weekly:  Sunday 03:00 AM - 100 high priority universities")
    logger.info("  Monthly: 1st of month 04:00 AM - 300 medium priority universities")
    logger.info("=" * 80)

    # Test connection
    try:
        db = get_supabase()
        result = db.table('universities').select('id', count='exact').limit(1).execute()
        logger.info(f"✓ Connected to Supabase - {result.count} universities found")
    except Exception as e:
        logger.error(f"✗ Failed to connect to Supabase: {e}")
        logger.error("Worker cannot start without database connection")
        return

    # Setup schedule
    schedule.every().day.at("02:00").do(daily_enrichment)
    schedule.every().sunday.at("03:00").do(weekly_enrichment)
    schedule.every().monday.at("04:00").do(check_monthly)

    logger.info("✓ Schedule configured - worker running...")
    logger.info("  Press Ctrl+C to stop")

    # Run forever
    while True:
        try:
            schedule.run_pending()
            time.sleep(60)  # Check every minute
        except KeyboardInterrupt:
            logger.info("Worker stopped by user")
            break
        except Exception as e:
            logger.error(f"Worker error: {e}", exc_info=True)
            time.sleep(60)  # Wait before retrying


if __name__ == "__main__":
    main()
