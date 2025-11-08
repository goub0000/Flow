"""
University Data Enrichment Script
Automatically fills missing data (city, state, website) by searching online
"""

import logging
import sys
from typing import List, Dict, Any
from app.services.enhanced_enricher import EnhancedDataEnricher
from app.database.supabase_client import get_supabase_client

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class UniversityDataEnrichment:
    """Orchestrates the data enrichment process"""

    def __init__(self, batch_size: int = 50, limit: int = None):
        self.batch_size = batch_size
        self.limit = limit
        self.enricher = EnhancedDataEnricher(rate_limit_delay=1.5)
        self.db_client = None
        self.stats = {
            'total_candidates': 0,
            'processed': 0,
            'enriched': 0,
            'updated': 0,
            'failed': 0
        }

    def run(self, test_mode: bool = False):
        """Run the enrichment process"""
        try:
            logger.info("=" * 80)
            logger.info("UNIVERSITY DATA ENRICHMENT")
            logger.info("=" * 80)
            logger.info("")

            # Step 1: Connect to database
            logger.info("[1/4] Connecting to Supabase...")
            self.db_client = get_supabase_client()
            logger.info("  Connected successfully")
            logger.info("")

            # Step 2: Find universities with missing data
            logger.info("[2/4] Finding universities with missing data...")
            universities = self._get_universities_needing_enrichment(test_mode)
            self.stats['total_candidates'] = len(universities)

            if not universities:
                logger.info("  No universities need enrichment!")
                return

            logger.info(f"  Found {len(universities)} universities to enrich")
            logger.info("")

            # Step 3: Enrich data
            logger.info(f"[3/4] Enriching {len(universities)} universities...")
            enriched_universities = self._enrich_universities(universities)
            logger.info(f"  Enriched {len(enriched_universities)} universities")
            logger.info("")

            # Step 4: Update database
            logger.info(f"[4/4] Updating database...")
            self._update_database(enriched_universities)
            logger.info("")

            # Print final statistics
            self._print_final_stats()

        except KeyboardInterrupt:
            logger.warning("\nEnrichment cancelled by user")
            sys.exit(1)
        except Exception as e:
            logger.error(f"Enrichment failed: {e}", exc_info=True)
            sys.exit(1)

    def _get_universities_needing_enrichment(self, test_mode: bool = False) -> List[Dict[str, Any]]:
        """
        Get universities that have NULL values in key fields

        Priority: website, city, state
        """
        # Query universities with missing data
        query = self.db_client.client.table('universities').select(
            'id, name, country, city, state, website'
        )

        # Filter for NULL values (at least one field missing)
        # Using OR conditions: missing website OR city OR state
        query = query.or_('website.is.null,city.is.null,state.is.null')

        # Limit for test mode
        if test_mode:
            query = query.limit(10)
        elif self.limit:
            query = query.limit(self.limit)
        else:
            query = query.limit(1000)  # Process 1000 at a time to avoid overwhelming

        result = query.execute()
        return result.data

    def _enrich_universities(self, universities: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Enrich a list of universities"""
        enriched = []

        for i, uni in enumerate(universities, 1):
            try:
                logger.info(f"  [{i}/{len(universities)}] {uni['name']} ({uni['country']})")

                # Enrich the university
                enriched_data = self.enricher.enrich_university(uni)

                if enriched_data:
                    enriched.append({
                        'id': uni['id'],
                        **enriched_data
                    })
                    self.stats['enriched'] += 1
                    logger.info(f"    ✓ Enriched: {list(enriched_data.keys())}")
                else:
                    logger.info(f"    - No new data found")

                self.stats['processed'] += 1

                # Progress update every 10 universities
                if i % 10 == 0:
                    logger.info(f"\n  Progress: {i}/{len(universities)} ({i/len(universities)*100:.1f}%)\n")

            except Exception as e:
                logger.error(f"  ✗ Failed to enrich {uni['name']}: {e}")
                self.stats['failed'] += 1

        return enriched

    def _update_database(self, enriched_universities: List[Dict[str, Any]]):
        """Update database with enriched data"""
        total = len(enriched_universities)

        if total == 0:
            logger.info("  No updates to make")
            return

        for i, uni in enumerate(enriched_universities, 1):
            try:
                uni_id = uni.pop('id')

                # Update the university
                self.db_client.client.table('universities').update(uni).eq(
                    'id', uni_id
                ).execute()

                self.stats['updated'] += 1

                # Progress update
                if i % self.batch_size == 0:
                    logger.info(f"  Progress: {i}/{total} ({i/total*100:.1f}%)")

            except Exception as e:
                logger.error(f"Failed to update university {uni.get('id')}: {e}")
                self.stats['failed'] += 1

        logger.info(f"  Completed: {self.stats['updated']}/{total} universities updated")

    def _print_final_stats(self):
        """Print final enrichment statistics"""
        logger.info("=" * 80)
        logger.info("ENRICHMENT COMPLETE")
        logger.info("=" * 80)
        logger.info("")
        logger.info(f"  Candidates found:     {self.stats['total_candidates']}")
        logger.info(f"  Processed:            {self.stats['processed']}")
        logger.info(f"  Successfully enriched:{self.stats['enriched']} ({self.stats['enriched']/max(self.stats['processed'],1)*100:.1f}%)")
        logger.info(f"  Database updated:     {self.stats['updated']}")
        logger.info(f"  Failed:               {self.stats['failed']}")
        logger.info("")

        # Show enricher stats
        self.enricher.log_stats()

        # Get updated quality
        logger.info("\nChecking updated data quality...")
        self._check_updated_quality()

        logger.info("=" * 80)

    def _check_updated_quality(self):
        """Check updated data quality for the fields we enriched"""
        total_result = self.db_client.client.table('universities').select('id', count='exact').execute()
        total = total_result.count

        # Check each field
        for field in ['website', 'city', 'state']:
            result = self.db_client.client.table('universities').select(field, count='exact').not_.is_(field, 'null').execute()
            filled = result.count
            percentage = (filled / total) * 100
            logger.info(f"  {field:10}: {filled:6}/{total:6} ({percentage:.1f}% filled)")


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Enrich university data by searching online sources'
    )
    parser.add_argument(
        '--test',
        action='store_true',
        help='Test mode - process only 10 universities'
    )
    parser.add_argument(
        '--limit',
        type=int,
        help='Limit number of universities to process'
    )
    parser.add_argument(
        '--batch-size',
        type=int,
        default=50,
        help='Batch size for database updates (default: 50)'
    )

    args = parser.parse_args()

    enrichment = UniversityDataEnrichment(
        batch_size=args.batch_size,
        limit=args.limit
    )

    enrichment.run(test_mode=args.test)


if __name__ == "__main__":
    main()
