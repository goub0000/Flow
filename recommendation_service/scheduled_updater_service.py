"""
Cloud-Based Scheduled Updater Service
Runs continuously and updates universities on schedule
Platform-independent, works anywhere Python runs
Logs to Supabase (cloud-based)
"""

import schedule
import time
import logging
from datetime import datetime
from smart_update_runner import SmartUpdateRunner
from app.utils.supabase_logger import setup_supabase_logging

# Setup Supabase logging (also logs to console)
logger = setup_supabase_logging('scheduler_service', level=logging.INFO, also_log_to_console=True)


class ScheduledUpdaterService:
    """
    Long-running service that schedules university updates

    Runs continuously and executes updates on schedule:
    - Daily: Critical priority universities
    - Weekly: High priority universities
    - Monthly: Medium priority universities
    """

    def __init__(self):
        self.runner = SmartUpdateRunner(rate_limit=5.0)
        self.is_running = False

    def daily_update(self):
        """Run daily critical priority update"""
        try:
            logger.info("=" * 80)
            logger.info("DAILY UPDATE - Critical Priority")
            logger.info("=" * 80)

            self.runner.run_priority_update(
                priority='critical',
                limit=30
            )

            logger.info("Daily update completed successfully")
        except Exception as e:
            logger.error(f"Daily update failed: {e}", exc_info=True)

    def weekly_update(self):
        """Run weekly high priority update"""
        try:
            logger.info("=" * 80)
            logger.info("WEEKLY UPDATE - High Priority")
            logger.info("=" * 80)

            self.runner.run_priority_update(
                priority='high',
                limit=100
            )

            logger.info("Weekly update completed successfully")
        except Exception as e:
            logger.error(f"Weekly update failed: {e}", exc_info=True)

    def monthly_update(self):
        """Run monthly medium priority update"""
        try:
            logger.info("=" * 80)
            logger.info("MONTHLY UPDATE - Medium Priority")
            logger.info("=" * 80)

            self.runner.run_priority_update(
                priority='medium',
                limit=300
            )

            logger.info("Monthly update completed successfully")
        except Exception as e:
            logger.error(f"Monthly update failed: {e}", exc_info=True)

    def setup_schedule(self):
        """Configure update schedule"""
        # Daily at 2:00 AM
        schedule.every().day.at("02:00").do(self.daily_update)

        # Weekly on Sundays at 3:00 AM
        schedule.every().sunday.at("03:00").do(self.weekly_update)

        # Monthly on 1st at 4:00 AM (approximated with weekly check)
        schedule.every().monday.at("04:00").do(self._monthly_check)

        logger.info("Schedule configured:")
        logger.info("  Daily:   02:00 - Critical priority (30 universities)")
        logger.info("  Weekly:  Sunday 03:00 - High priority (100 universities)")
        logger.info("  Monthly: 1st of month 04:00 - Medium priority (300 universities)")

    def _monthly_check(self):
        """Check if it's the 1st of the month and run update"""
        if datetime.now().day == 1:
            self.monthly_update()

    def run(self):
        """Start the scheduler service"""
        logger.info("=" * 80)
        logger.info("UNIVERSITY DATA UPDATE SERVICE STARTING")
        logger.info("=" * 80)

        self.setup_schedule()
        self.is_running = True

        logger.info("\nService is running. Press Ctrl+C to stop.")
        logger.info("=" * 80)

        try:
            while self.is_running:
                schedule.run_pending()
                time.sleep(60)  # Check every minute
        except KeyboardInterrupt:
            logger.info("\nService stopping...")
            self.is_running = False
        except Exception as e:
            logger.error(f"Service error: {e}", exc_info=True)
            self.is_running = False


def main():
    """Run the scheduler service"""
    service = ScheduledUpdaterService()
    service.run()


if __name__ == "__main__":
    main()
