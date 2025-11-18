"""
Scheduled Reports Cron Job
Runs scheduled report processing on a regular interval
"""
import asyncio
import logging
import os
import sys
from datetime import datetime
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger
from dotenv import load_dotenv

# Add the parent directory to the path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.services.scheduled_reports_service import get_scheduled_reports_service

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('scheduled_reports.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)


async def process_scheduled_reports_job():
    """Main job function that processes scheduled reports"""
    logger.info("=" * 60)
    logger.info(f"Starting scheduled reports processing at {datetime.now()}")
    logger.info("=" * 60)

    try:
        service = get_scheduled_reports_service()
        stats = await service.process_due_reports()

        logger.info("Processing complete!")
        logger.info(f"Statistics: {stats}")

        # Log any errors
        if stats["errors"]:
            logger.error("Errors encountered:")
            for error in stats["errors"]:
                logger.error(f"  - {error}")

    except Exception as e:
        logger.error(f"Critical error in scheduled reports job: {str(e)}", exc_info=True)

    logger.info("=" * 60)


def main():
    """Main entry point for the cron service"""
    logger.info("🚀 Starting Scheduled Reports Cron Service")
    logger.info(f"Environment: {os.getenv('ENVIRONMENT', 'development')}")
    logger.info(f"Supabase URL: {os.getenv('SUPABASE_URL', 'Not configured')}")
    logger.info(f"SendGrid configured: {'Yes' if os.getenv('SENDGRID_API_KEY') else 'No'}")

    # Validate environment variables
    required_env_vars = ['SUPABASE_URL', 'SUPABASE_SERVICE_KEY']
    missing_vars = [var for var in required_env_vars if not os.getenv(var)]

    if missing_vars:
        logger.error(f"Missing required environment variables: {', '.join(missing_vars)}")
        logger.error("Please configure these in your .env file")
        sys.exit(1)

    if not os.getenv('SENDGRID_API_KEY'):
        logger.warning("⚠️  SendGrid API key not configured - emails will not be sent")
        logger.warning("   Set SENDGRID_API_KEY environment variable to enable email delivery")

    # Create scheduler
    scheduler = AsyncIOScheduler()

    # Schedule the job to run every hour at minute 0
    # You can customize this cron expression:
    # - "0 * * * *" = Every hour at minute 0
    # - "*/30 * * * *" = Every 30 minutes
    # - "0 */6 * * *" = Every 6 hours
    # - "0 9 * * *" = Every day at 9 AM
    cron_schedule = os.getenv('CRON_SCHEDULE', '0 * * * *')

    scheduler.add_job(
        process_scheduled_reports_job,
        trigger=CronTrigger.from_crontab(cron_schedule),
        id='scheduled_reports_processor',
        name='Process Scheduled Reports',
        replace_existing=True
    )

    logger.info(f"📅 Scheduled to run: {cron_schedule}")
    logger.info("   (Cron format: minute hour day month day_of_week)")

    # Run immediately on startup (optional - uncomment to enable)
    run_on_startup = os.getenv('RUN_ON_STARTUP', 'false').lower() == 'true'
    if run_on_startup:
        logger.info("🏃 Running initial processing on startup...")
        asyncio.run(process_scheduled_reports_job())

    # Start the scheduler
    scheduler.start()
    logger.info("✅ Scheduler started successfully!")
    logger.info("Press Ctrl+C to stop")

    # Keep the script running
    try:
        asyncio.get_event_loop().run_forever()
    except (KeyboardInterrupt, SystemExit):
        logger.info("🛑 Shutting down scheduled reports cron service...")
        scheduler.shutdown()
        logger.info("👋 Goodbye!")


if __name__ == "__main__":
    main()
