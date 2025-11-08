"""
Smart Update Runner - Phase 1 Enhanced
Intelligent university data updates with:
- Staleness detection
- Quality tracking
- Fallback strategies
- Incremental updates
"""

import logging
from time import sleep
import random
from typing import Optional
from app.database.supabase_client import get_supabase_client
from app.utils.incremental_updater import IncrementalUpdater
from app.utils.fallback_scraper import FallbackScraper
from app.utils.data_quality_tracker import DataQualityTracker

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class SmartUpdateRunner:
    """
    Enhanced runner with intelligent update strategies
    """

    def __init__(self, rate_limit: float = 5.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.incremental_updater = IncrementalUpdater()
        self.fallback_scraper = FallbackScraper(rate_limit=rate_limit)
        self.stats = {
            'total_processed': 0,
            'successful_updates': 0,
            'failed_updates': 0,
            'skipped': 0,
            'fields_updated': {}
        }

    def run_incremental_update(
        self,
        limit: int = 100,
        field_name: Optional[str] = None,
        country: Optional[str] = None,
        priority: Optional[str] = None
    ):
        """
        Run intelligent incremental update targeting stale data

        Args:
            limit: Maximum universities to process
            field_name: Specific field to update (or None for all)
            country: Filter by country
            priority: University priority level
        """
        logger.info("=" * 80)
        logger.info("SMART INCREMENTAL UPDATE - PHASE 1")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        # Get stale universities
        logger.info("Finding universities with stale data...")
        stale_unis = self.incremental_updater.get_stale_universities(
            field_name=field_name,
            limit=limit,
            country=country,
            priority=priority
        )

        if not stale_unis:
            logger.info("No stale universities found!")
            self.incremental_updater.log_stats()
            return

        logger.info(f"Found {len(stale_unis)} universities needing updates\n")

        # Process each university
        for i, uni in enumerate(stale_unis, 1):
            logger.info(f"\n[{i}/{len(stale_unis)}] {uni['name']} ({uni['country']})")

            try:
                # Use fallback scraper for robust extraction
                data = self.fallback_scraper.scrape_university(
                    uni_id=uni['id'],
                    uni_name=uni['name'],
                    country=uni['country'],
                    website=uni.get('website'),
                    city=uni.get('city')
                )

                if data and len(data) > 0:
                    # Update database with quality metadata
                    self.db_client.client.table('universities').update(
                        data
                    ).eq('id', uni['id']).execute()

                    self.stats['successful_updates'] += 1

                    # Track field statistics
                    for field in data:
                        if field not in ['data_sources', 'data_confidence', 'field_last_updated', 'last_scraped_at']:
                            if field not in self.stats['fields_updated']:
                                self.stats['fields_updated'][field] = 0
                            self.stats['fields_updated'][field] += 1

                    logger.info(f"  ✓ Updated {len(data)-4} fields (+ metadata)")
                else:
                    logger.info(f"  - No new data extracted")
                    self.stats['skipped'] += 1

                self.stats['total_processed'] += 1

                # Rate limiting
                sleep(self.rate_limit + random.uniform(-0.5, 0.5))

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                self.stats['failed_updates'] += 1

        self._print_summary()

    def run_stale_field_update(
        self,
        field_name: str,
        limit: int = 100,
        country: Optional[str] = None
    ):
        """
        Update a specific field for universities where it's stale

        Args:
            field_name: Field to update (e.g., 'acceptance_rate')
            limit: Maximum universities to process
            country: Optional country filter
        """
        logger.info("=" * 80)
        logger.info(f"SMART FIELD UPDATE: {field_name}")
        logger.info("=" * 80)

        # Delegate to incremental update
        self.run_incremental_update(
            limit=limit,
            field_name=field_name,
            country=country
        )

    def run_priority_update(
        self,
        priority: str = 'critical',
        limit: int = 50
    ):
        """
        Update high-priority universities

        Args:
            priority: Priority level ('critical', 'high', 'medium', 'low')
            limit: Maximum universities to process
        """
        logger.info("=" * 80)
        logger.info(f"PRIORITY UPDATE: {priority.upper()}")
        logger.info("=" * 80)

        # Delegate to incremental update
        self.run_incremental_update(
            limit=limit,
            priority=priority
        )

    def show_update_schedule(self, total_universities: int = 17137):
        """
        Display recommended update schedule

        Args:
            total_universities: Total universities in database
        """
        logger.info("=" * 80)
        logger.info("RECOMMENDED UPDATE SCHEDULE")
        logger.info("=" * 80)

        schedule = self.incremental_updater.get_update_schedule(total_universities)

        logger.info(f"\nTotal Universities: {schedule['total_universities']}")
        logger.info(f"Daily Updates Needed: ~{schedule['total_daily_updates']}\n")

        logger.info("By Priority Level:")
        logger.info("-" * 80)
        for priority, details in schedule['priority_schedules'].items():
            logger.info(f"\n{priority.upper():12}")
            logger.info(f"  Count:             {details['count']:,}")
            logger.info(f"  Update Frequency:  Every {details['update_frequency_days']} days")
            logger.info(f"  Daily Updates:     ~{details['updates_per_day']}")

        logger.info("\n" + "=" * 80)

        logger.info("\nRecommended Commands:")
        logger.info("-" * 80)
        logger.info("# Daily - Critical universities")
        logger.info("python smart_update_runner.py --priority critical --limit 50")
        logger.info("\n# Weekly - High priority")
        logger.info("python smart_update_runner.py --priority high --limit 100")
        logger.info("\n# Monthly - Medium priority")
        logger.info("python smart_update_runner.py --priority medium --limit 200")
        logger.info("\n# Quarterly - Low priority")
        logger.info("python smart_update_runner.py --priority low --limit 500")
        logger.info("\n# Field-specific updates")
        logger.info("python smart_update_runner.py --field acceptance_rate --limit 200")
        logger.info("=" * 80)

    def _print_summary(self):
        """Print execution summary"""
        logger.info("\n" + "=" * 80)
        logger.info("EXECUTION SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:      {self.stats['total_processed']}")
        logger.info(f"Successful updates:   {self.stats['successful_updates']}")
        logger.info(f"Failed:               {self.stats['failed_updates']}")
        logger.info(f"Skipped (no data):    {self.stats['skipped']}")

        if self.stats['total_processed'] > 0:
            rate = (self.stats['successful_updates'] / self.stats['total_processed']) * 100
            logger.info(f"Success rate:         {rate:.1f}%")

        if self.stats['fields_updated']:
            logger.info("\nFields Updated:")
            for field, count in sorted(
                self.stats['fields_updated'].items(),
                key=lambda x: x[1],
                reverse=True
            ):
                logger.info(f"  {field:30} : {count}")

        logger.info("=" * 80)

        # Show component stats
        logger.info("\n")
        self.incremental_updater.log_stats()
        logger.info("\n")
        self.fallback_scraper.log_stats()


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Smart University Data Updater with Phase 1 Enhancements'
    )

    parser.add_argument(
        '--mode',
        type=str,
        choices=['incremental', 'field', 'priority', 'schedule'],
        default='incremental',
        help='Update mode'
    )

    parser.add_argument(
        '--limit',
        type=int,
        default=100,
        help='Number of universities to process'
    )

    parser.add_argument(
        '--field',
        type=str,
        help='Specific field to update (e.g., acceptance_rate)'
    )

    parser.add_argument(
        '--country',
        type=str,
        help='Filter by country code (e.g., US, UK)'
    )

    parser.add_argument(
        '--priority',
        type=str,
        choices=['critical', 'high', 'medium', 'low'],
        help='University priority level'
    )

    parser.add_argument(
        '--rate-limit',
        type=float,
        default=5.0,
        help='Seconds between requests'
    )

    parser.add_argument(
        '--total-unis',
        type=int,
        default=17137,
        help='Total universities in database (for schedule calculation)'
    )

    args = parser.parse_args()

    runner = SmartUpdateRunner(rate_limit=args.rate_limit)

    if args.mode == 'schedule':
        runner.show_update_schedule(args.total_unis)

    elif args.mode == 'field':
        if not args.field:
            logger.error("--field is required for field mode")
            return
        runner.run_stale_field_update(
            field_name=args.field,
            limit=args.limit,
            country=args.country
        )

    elif args.mode == 'priority':
        if not args.priority:
            logger.error("--priority is required for priority mode")
            return
        runner.run_priority_update(
            priority=args.priority,
            limit=args.limit
        )

    else:  # incremental
        runner.run_incremental_update(
            limit=args.limit,
            field_name=args.field,
            country=args.country,
            priority=args.priority
        )


if __name__ == "__main__":
    main()
