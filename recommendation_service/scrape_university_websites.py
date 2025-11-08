"""
Direct University Website Scraper Runner
Fetches universities with websites from database and scrapes them directly
Works in parallel with search engine-based fillers
"""

import logging
from time import sleep
import random
from app.database.supabase_client import get_supabase_client
from app.data_fetchers.university_website_scraper import UniversityWebsiteScraper

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class WebsiteScraperRunner:
    """Runs direct website scraping for universities"""

    def __init__(self, rate_limit: float = 5.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.scraper = UniversityWebsiteScraper(rate_limit_delay=rate_limit)
        self.stats = {
            'total': 0,
            'success': 0,
            'failed': 0,
            'skipped': 0,
            'fields_filled': {
                'acceptance_rate': 0,
                'tuition_out_state': 0,
                'graduation_rate_4year': 0,
                'total_students': 0,
                'university_type': 0,
                'location_type': 0,
            }
        }

        # Fields to exclude (not in database schema yet)
        self.excluded_fields = ['phone', 'email', 'sat_math_25th', 'sat_math_75th',
                                'sat_ebrw_25th', 'sat_ebrw_75th', 'act_composite', 'avg_gpa']

    def run(self, limit: int = 100, country_filter: str = None):
        """
        Run website scraping for universities with websites

        Args:
            limit: Maximum number of universities to process
            country_filter: Optional country code filter (e.g., 'US')
        """
        logger.info("=" * 80)
        logger.info("DIRECT UNIVERSITY WEBSITE SCRAPER")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        # Fetch universities with websites
        query = self.db_client.client.table('universities').select(
            'id, name, country, website'
        ).not_.is_('website', 'null')

        if country_filter:
            query = query.eq('country', country_filter)
            logger.info(f"Filtering to {country_filter} universities\n")

        result = query.limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities with websites found!")
            return

        logger.info(f"Found {len(universities)} universities with websites\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"\n[{i}/{len(universities)}] {uni['name']} ({uni['country']})")
            logger.info(f"  Website: {uni['website']}")

            try:
                # Scrape university website
                data = self.scraper.scrape_university(uni['website'], uni['name'])

                if data and len(data) > 0:
                    # Filter out excluded fields
                    filtered_data = {k: v for k, v in data.items() if k not in self.excluded_fields}

                    if filtered_data:
                        # Update database
                        update_result = self.db_client.client.table('universities').update(
                            filtered_data
                        ).eq('id', uni['id']).execute()

                        # Track statistics
                        self.stats['success'] += 1
                        logger.info(f"  ✓ Updated {len(filtered_data)} fields:")
                        for field, value in filtered_data.items():
                            logger.info(f"    - {field}: {value}")
                            if field in self.stats['fields_filled']:
                                self.stats['fields_filled'][field] += 1
                    else:
                        logger.info(f"  - Only found excluded fields")
                        self.stats['skipped'] += 1
                else:
                    logger.info(f"  - No data extracted")
                    self.stats['skipped'] += 1

                self.stats['total'] += 1

                # Rate limiting
                sleep(self.rate_limit + random.uniform(-0.5, 0.5))

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                self.stats['failed'] += 1

        self._print_summary()

    def _print_summary(self):
        """Print summary statistics"""
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:     {self.stats['total']}")
        logger.info(f"Successfully scraped: {self.stats['success']}")
        logger.info(f"No data found:       {self.stats['skipped']}")
        logger.info(f"Failed:              {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['success'] / self.stats['total']) * 100
            logger.info(f"Success rate:        {rate:.1f}%")

        logger.info("\nFields filled:")
        for field, count in sorted(self.stats['fields_filled'].items(), key=lambda x: x[1], reverse=True):
            if count > 0:
                logger.info(f"  {field}: {count}")

        logger.info("=" * 80)


def main():
    import argparse

    parser = argparse.ArgumentParser(description='Scrape university websites directly')
    parser.add_argument('--limit', type=int, default=100, help='Number of universities to process')
    parser.add_argument('--country', type=str, help='Filter by country code (e.g., US, UK, AU)')
    parser.add_argument('--rate-limit', type=float, default=5.0, help='Seconds between requests')

    args = parser.parse_args()

    runner = WebsiteScraperRunner(rate_limit=args.rate_limit)
    runner.run(limit=args.limit, country_filter=args.country)


if __name__ == "__main__":
    main()
