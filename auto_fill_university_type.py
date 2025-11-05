"""
Auto-Fill University Type
Determines if university is Public or Private
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


class UniversityTypeFiller:
    """Determine if university is public or private"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.search_helper = SearchEngineHelper()
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL UNIVERSITY TYPE (Public/Private)")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        result = self.db_client.client.table('universities').select(
            'id, name, country'
        ).is_('university_type', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need type classification!")
            return

        logger.info(f"Found {len(universities)} universities without type\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']} ({uni['country']})")

            try:
                uni_type = self._find_university_type(uni['name'], uni['country'])

                if uni_type:
                    self.db_client.client.table('universities').update(
                        {'university_type': uni_type}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {uni_type}")
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

    def _find_university_type(self, uni_name: str, country: str) -> Optional[str]:
        """Determine if university is public or private"""
        try:
            query = f"{uni_name} university {country} public private state"

            # Use search helper with multi-engine fallback
            text = self.search_helper.search(query)
            if not text:
                return None

            text_lower = text.lower()

            # Strong indicators for public
            public_patterns = [
                r'\bpublic\s+university\b',
                r'\bstate\s+university\b',
                r'\bpublicly\s+funded\b',
                r'\bpublic\s+institution\b',
                r'\bstate-funded\b',
                r'\bgovernment\s+university\b',
            ]

            # Strong indicators for private
            private_patterns = [
                r'\bprivate\s+university\b',
                r'\bprivate\s+institution\b',
                r'\bindependent\s+university\b',
                r'\bprivately\s+funded\b',
                r'\bprivate\s+research\s+university\b',
            ]

            public_score = 0
            private_score = 0

            for pattern in public_patterns:
                if re.search(pattern, text_lower):
                    public_score += 1

            for pattern in private_patterns:
                if re.search(pattern, text_lower):
                    private_score += 1

            # Decide based on scores
            if public_score > private_score and public_score > 0:
                return 'Public'
            elif private_score > public_score and private_score > 0:
                return 'Private'

            # Fallback: look for simple mentions
            if 'public university' in text_lower or 'state university' in text_lower:
                return 'Public'
            elif 'private university' in text_lower:
                return 'Private'

            return None

        except Exception as e:
            logger.debug(f"Type search failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total']}")
        logger.info(f"Types filled:     {self.stats['filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:     {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill university type (public/private)')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = UniversityTypeFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
