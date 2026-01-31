"""
Wikipedia Universities Import Script
Scrapes universities from Wikipedia and imports them to Supabase database
"""

import logging
import sys
from typing import List, Dict, Any, Optional
from app.data_fetchers.wikipedia_scraper import WikipediaUniversityScraper
from app.services.data_validator import DataValidator
from app.database.supabase_client import get_supabase_client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class WikipediaUniversityImporter:
    """
    Orchestrates the Wikipedia scraping and database import process
    """

    def __init__(self, batch_size: int = 50, test_mode: bool = False):
        """
        Initialize the importer

        Args:
            batch_size: Number of records to commit at once
            test_mode: If True, only scrape/import test countries
        """
        self.batch_size = batch_size
        self.test_mode = test_mode
        self.validator = DataValidator()
        self.db_client = None

        # Statistics
        self.stats = {
            'scraped': 0,
            'validated': 0,
            'added': 0,
            'updated': 0,
            'failed': 0
        }

    def run(self, countries: Optional[List[str]] = None):
        """
        Run the full import process

        Args:
            countries: Optional list of specific countries to scrape
        """
        try:
            logger.info("=" * 80)
            logger.info("WIKIPEDIA UNIVERSITY IMPORT")
            logger.info("=" * 80)
            logger.info("")

            # Step 1: Scrape universities from Wikipedia
            logger.info("[1/4] Scraping universities from Wikipedia...")
            universities = self._scrape_universities(countries)
            self.stats['scraped'] = len(universities)

            if not universities:
                logger.warning("No universities scraped. Exiting.")
                return

            logger.info(f"  Scraped {len(universities)} universities")
            logger.info("")

            # Step 2: Validate data
            logger.info("[2/4] Validating university data...")
            validated_universities = self._validate_universities(universities)
            self.stats['validated'] = len(validated_universities)

            if not validated_universities:
                logger.warning("No universities passed validation. Exiting.")
                return

            logger.info(f"  {len(validated_universities)} universities passed validation")
            logger.info(f"  {len(universities) - len(validated_universities)} universities failed validation")
            logger.info("")

            # Step 3: Connect to database
            logger.info("[3/4] Connecting to Supabase...")
            self.db_client = get_supabase_client()
            logger.info("  Connected successfully")
            logger.info("")

            # Step 4: Import to database
            logger.info(f"[4/4] Importing {len(validated_universities)} universities to Supabase...")
            self._import_to_database(validated_universities)
            logger.info("")

            # Print final statistics
            self._print_final_stats()

        except KeyboardInterrupt:
            logger.warning("\nImport cancelled by user")
            sys.exit(1)
        except Exception as e:
            logger.error(f"Import failed: {e}", exc_info=True)
            sys.exit(1)

    def _scrape_universities(self, countries: Optional[List[str]] = None) -> List[Dict[str, Any]]:
        """Scrape universities from Wikipedia"""
        if self.test_mode and not countries:
            # Default test countries
            countries = ['Nigeria', 'Kenya', 'Ghana', 'Peru', 'Bangladesh']

        scraper = WikipediaUniversityScraper(
            rate_limit_delay=2.0,  # Be respectful to Wikipedia
            countries=countries
        )

        universities = scraper.scrape()

        return universities

    def _validate_universities(self, universities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Validate scraped universities"""
        validated = self.validator.validate_batch(universities)

        # Log validation stats
        self.validator.log_stats()

        return validated

    def _import_to_database(self, universities: List[Dict[str, Any]]):
        """Import validated universities to Supabase using upsert"""
        total = len(universities)
        processed = 0

        for i, uni in enumerate(universities, 1):
            try:
                # Upsert: insert or update on conflict (name, country)
                result = self.db_client.client.table('universities').upsert(
                    uni, on_conflict='name,country'
                ).execute()

                if result.data:
                    self.stats['updated'] += 1
                    logger.debug(f"Upserted: {uni['name']}")

                processed += 1

                # Log progress in batches
                if processed % self.batch_size == 0:
                    logger.info(f"  Progress: {processed}/{total} ({processed/total*100:.1f}%)")

            except Exception as e:
                logger.error(f"Failed to save {uni.get('name', 'Unknown')}: {e}")
                self.stats['failed'] += 1

        logger.info(f"  Completed: {processed}/{total} universities processed")

    def _print_final_stats(self):
        """Print final import statistics"""
        logger.info("=" * 80)
        logger.info("IMPORT COMPLETE")
        logger.info("=" * 80)
        logger.info("")
        logger.info(f"  Universities scraped:  {self.stats['scraped']}")
        logger.info(f"  Validated:             {self.stats['validated']} ({self.stats['validated']/self.stats['scraped']*100:.1f}%)")
        logger.info(f"  Added to database:     {self.stats['added']}")
        logger.info(f"  Updated in database:   {self.stats['updated']}")
        logger.info(f"  Failed:                {self.stats['failed']}")
        logger.info("")

        # Get total count from database
        try:
            count_result = self.db_client.client.table('universities').select(
                'id', count='exact'
            ).execute()
            total_in_db = count_result.count
            logger.info(f"Total universities in database: {total_in_db}")
        except Exception as e:
            logger.warning(f"Could not get total count: {e}")

        logger.info("=" * 80)


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Import universities from Wikipedia to Supabase'
    )
    parser.add_argument(
        '--countries',
        nargs='+',
        help='Specific countries to scrape (e.g., Nigeria Kenya Ghana)'
    )
    parser.add_argument(
        '--test',
        action='store_true',
        help='Test mode - scrape only a few countries'
    )
    parser.add_argument(
        '--batch-size',
        type=int,
        default=50,
        help='Batch size for database commits (default: 50)'
    )

    args = parser.parse_args()

    importer = WikipediaUniversityImporter(
        batch_size=args.batch_size,
        test_mode=args.test
    )

    importer.run(countries=args.countries)


if __name__ == "__main__":
    main()
