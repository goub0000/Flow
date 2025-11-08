"""
Auto-Fill Location Type
Determines if university is in Urban, Suburban, or Rural setting
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


class LocationTypeFiller:
    """Determine university location type (Urban/Suburban/Rural)"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.search_helper = SearchEngineHelper()
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL LOCATION TYPE (Urban/Suburban/Rural)")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        result = self.db_client.client.table('universities').select(
            'id, name, country, city'
        ).is_('location_type', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need location type!")
            return

        logger.info(f"Found {len(universities)} universities without location type\n")

        for i, uni in enumerate(universities, 1):
            city_info = f" in {uni['city']}" if uni.get('city') else ""
            logger.info(f"[{i}/{len(universities)}] {uni['name']}{city_info} ({uni['country']})")

            try:
                location_type = self._find_location_type(uni['name'], uni['country'], uni.get('city'))

                if location_type:
                    self.db_client.client.table('universities').update(
                        {'location_type': location_type}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {location_type}")
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

    def _find_location_type(self, uni_name: str, country: str, city: Optional[str]) -> Optional[str]:
        """Determine location type using web search"""
        try:
            city_part = f"{city}" if city else ""
            query = f"{uni_name} university {city_part} {country} campus urban suburban rural setting location"

            # Use search helper with multi-engine fallback
            text = self.search_helper.search(query)
            if not text:
                return None

            text_lower = text.lower()

            # Scoring system for each type
            urban_score = 0
            suburban_score = 0
            rural_score = 0

            # Urban patterns
            urban_patterns = [
                r'\burban\s+(?:campus|setting|location|environment)\b',
                r'\bcity\s+(?:campus|setting)\b',
                r'\bdowntown\b',
                r'\bin\s+the\s+heart\s+of\b',
                r'\bmetropolitan\b',
                r'\bcity\s+center\b',
            ]

            # Suburban patterns
            suburban_patterns = [
                r'\bsuburban\s+(?:campus|setting|location|environment)\b',
                r'\bresidential\s+area\b',
                r'\boutskirts\b',
                r'\bsuburbs\b',
            ]

            # Rural patterns
            rural_patterns = [
                r'\brural\s+(?:campus|setting|location|environment)\b',
                r'\bcountry\s+setting\b',
                r'\bsmall\s+town\b',
                r'\bremote\b',
                r'\bcountryside\b',
            ]

            for pattern in urban_patterns:
                if re.search(pattern, text_lower):
                    urban_score += 1

            for pattern in suburban_patterns:
                if re.search(pattern, text_lower):
                    suburban_score += 1

            for pattern in rural_patterns:
                if re.search(pattern, text_lower):
                    rural_score += 1

            # Decide based on scores
            if urban_score > suburban_score and urban_score > rural_score and urban_score > 0:
                return 'Urban'
            elif suburban_score > urban_score and suburban_score > rural_score and suburban_score > 0:
                return 'Suburban'
            elif rural_score > urban_score and rural_score > suburban_score and rural_score > 0:
                return 'Rural'

            # Fallback: simple keyword matching
            if 'urban campus' in text_lower or 'city campus' in text_lower:
                return 'Urban'
            elif 'suburban campus' in text_lower:
                return 'Suburban'
            elif 'rural campus' in text_lower or 'small town' in text_lower:
                return 'Rural'

            return None

        except Exception as e:
            logger.debug(f"Location type search failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:      {self.stats['total']}")
        logger.info(f"Location types filled: {self.stats['filled']}")
        logger.info(f"Skipped:              {self.stats['skipped']}")
        logger.info(f"Failed:               {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:         {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill location type (urban/suburban/rural)')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = LocationTypeFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
