"""
Auto-Fill Tuition (Out-of-State)
Finds university tuition costs (primarily US universities)
"""

import logging
import requests
import re
from bs4 import BeautifulSoup
from typing import Optional
from time import sleep
import random
from app.database.supabase_client import get_supabase_client
from search_engine_helper import SearchEngineHelper

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class TuitionFiller:
    """Find university tuition costs"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.search_helper = SearchEngineHelper()
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL TUITION (OUT-OF-STATE)")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        # Focus on US universities where tuition data is more readily available
        result = self.db_client.client.table('universities').select(
            'id, name, country'
        ).is_('tuition_out_state', 'null').eq('country', 'US').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No US universities need tuition data!")
            return

        logger.info(f"Found {len(universities)} US universities without tuition data\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']}")

            try:
                tuition = self._find_tuition(uni['name'])

                if tuition:
                    self.db_client.client.table('universities').update(
                        {'tuition_out_state': tuition}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: ${tuition:,}")
                    self.stats['filled'] += 1
                else:
                    logger.info(f"  - Not found")
                    self.stats['skipped'] += 1

                self.stats['total'] += 1
                sleep(self.rate_limit + random.uniform(-0.5, 0.5))

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                self.stats['failed'] += 1

        self._print_summary()

    def _find_tuition(self, uni_name: str) -> Optional[int]:
        """Find tuition cost using web search"""
        try:
            query = f"{uni_name} university tuition cost out of state 2024 2025"

            # Use search helper with multi-engine fallback
            text = self.search_helper.search(query)
            if not text:
                return None

            # Patterns for tuition costs
            patterns = [
                r'\$(\d{1,3}(?:,\d{3})+).*?tuition',
                r'tuition.*?\$(\d{1,3}(?:,\d{3})+)',
                r'out.*?state.*?\$(\d{1,3}(?:,\d{3})+)',
                r'\$(\d{1,3}(?:,\d{3})+).*?out.*?state',
                r'annual.*?tuition.*?\$(\d{1,3}(?:,\d{3})+)',
                r'\$(\d{1,3}(?:,\d{3})+).*?per.*?year',
            ]

            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    tuition_str = match.group(1).replace(',', '')
                    tuition = int(tuition_str)
                    # Validate reasonable range ($5,000 to $80,000)
                    if 5000 <= tuition <= 80000:
                        return tuition

            return None

        except Exception as e:
            logger.debug(f"Tuition search failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total']}")
        logger.info(f"Tuition filled:   {self.stats['filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:     {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill tuition costs')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = TuitionFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
