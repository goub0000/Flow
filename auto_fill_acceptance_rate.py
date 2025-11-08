"""
Auto-Fill Acceptance Rate
Finds university acceptance/admission rates
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


class AcceptanceRateFiller:
    """Find university acceptance rates"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.search_helper = SearchEngineHelper()
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL ACCEPTANCE RATE")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        result = self.db_client.client.table('universities').select(
            'id, name, country'
        ).is_('acceptance_rate', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need acceptance rates!")
            return

        logger.info(f"Found {len(universities)} universities without acceptance rates\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']} ({uni['country']})")

            try:
                rate = self._find_acceptance_rate(uni['name'], uni['country'])

                if rate:
                    self.db_client.client.table('universities').update(
                        {'acceptance_rate': rate}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {rate}%")
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

    def _find_acceptance_rate(self, uni_name: str, country: str) -> Optional[float]:
        """Find acceptance rate using web search"""
        try:
            query = f"{uni_name} university {country} acceptance rate admission rate"

            # Use search helper with multi-engine fallback
            text = self.search_helper.search(query)
            if not text:
                return None

            # Patterns for acceptance rate
            patterns = [
                r'acceptance rate.*?(\d+(?:\.\d+)?)[\s]*%',
                r'(\d+(?:\.\d+)?)[\s]*%.*?acceptance',
                r'admit.*?(\d+(?:\.\d+)?)[\s]*%',
                r'admission rate.*?(\d+(?:\.\d+)?)[\s]*%',
                r'(\d+(?:\.\d+)?)[\s]*%.*?admitted',
                r'acceptance.*?rate.*?is.*?(\d+(?:\.\d+)?)[\s]*%',
            ]

            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    rate = float(match.group(1))
                    # Validate reasonable range (1% to 100%)
                    if 1 <= rate <= 100:
                        return rate

            return None

        except Exception as e:
            logger.debug(f"Acceptance rate search failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:       {self.stats['total']}")
        logger.info(f"Acceptance rates filled: {self.stats['filled']}")
        logger.info(f"Skipped:               {self.stats['skipped']}")
        logger.info(f"Failed:                {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:          {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill acceptance rates')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = AcceptanceRateFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
