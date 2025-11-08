"""
Auto-Fill Total Students
Finds university enrollment numbers
"""

import logging
import requests
import re
from bs4 import BeautifulSoup
from typing import Optional
from time import sleep
import random
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class StudentsFiller:
    """Find university enrollment numbers"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL TOTAL STUDENTS")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        result = self.db_client.client.table('universities').select(
            'id, name, country'
        ).is_('total_students', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need student numbers!")
            return

        logger.info(f"Found {len(universities)} universities without student numbers\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']} ({uni['country']})")

            try:
                students = self._find_students(uni['name'], uni['country'])

                if students:
                    self.db_client.client.table('universities').update(
                        {'total_students': students}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {students:,} students")
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

    def _find_students(self, uni_name: str, country: str) -> Optional[int]:
        """Find total student enrollment"""
        try:
            query = f"{uni_name} university {country} enrollment students total number"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')
            snippets = soup.find_all('a', class_='result__snippet')
            text = ' '.join([s.get_text() for s in snippets[:5]])

            # Patterns for enrollment numbers
            patterns = [
                r'(\d{1,3}(?:,\d{3})+)\s+students',
                r'enrollment.*?(\d{1,3}(?:,\d{3})+)',
                r'(\d{1,3}(?:,\d{3})+).*?enrolled',
                r'(\d{1,3}(?:,\d{3})+).*?undergrad',
                r'total.*?(\d{1,3}(?:,\d{3})+)',
            ]

            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    num_str = match.group(1).replace(',', '')
                    num = int(num_str)
                    # Validate reasonable range (100 to 1 million)
                    if 100 <= num <= 1000000:
                        return num

            return None

        except Exception as e:
            logger.debug(f"Students search failed: {e}")
            return None

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total']}")
        logger.info(f"Students filled:  {self.stats['filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:     {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill student enrollment')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = StudentsFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
