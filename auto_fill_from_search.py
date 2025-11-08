"""
Automated University Data Filler
Searches online for each university and automatically fills missing data
Uses web search to extract location information
"""

import logging
import sys
import requests
import re
from bs4 import BeautifulSoup
from typing import Dict, Optional, Any, List
from time import sleep
import random
from app.database.supabase_client import get_supabase_client

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class AutomatedDataFiller:
    """Automatically searches and fills university data"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

        self.stats = {
            'total_processed': 0,
            'city_filled': 0,
            'state_filled': 0,
            'website_filled': 0,
            'failed': 0,
            'skipped': 0
        }

    def run(self, limit: int = 100):
        """Run the automated filling process"""
        logger.info("=" * 80)
        logger.info("AUTOMATED UNIVERSITY DATA FILLING")
        logger.info("=" * 80)
        logger.info("")

        # Connect to database
        logger.info("Connecting to Supabase...")
        self.db_client = get_supabase_client()
        logger.info("Connected!")
        logger.info("")

        # Get universities
        logger.info(f"Fetching universities with missing data (limit: {limit})...")
        universities = self._get_universities(limit)

        if not universities:
            logger.info("No universities found with missing data!")
            return

        logger.info(f"Found {len(universities)} universities to process")
        logger.info("")

        # Process each
        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']} ({uni['country']})")

            try:
                updates = self._search_and_extract(uni)

                if updates:
                    self._save_updates(uni['id'], updates)
                    filled_fields = ', '.join(updates.keys())
                    logger.info(f"  ✓ Filled: {filled_fields}")
                    self.stats['total_processed'] += 1

                    if 'city' in updates:
                        self.stats['city_filled'] += 1
                    if 'state' in updates:
                        self.stats['state_filled'] += 1
                    if 'website' in updates:
                        self.stats['website_filled'] += 1
                else:
                    logger.info(f"  - No data found")
                    self.stats['skipped'] += 1

                # Rate limiting
                sleep(self.rate_limit + random.uniform(-0.5, 0.5))

            except Exception as e:
                logger.error(f"  ✗ Error: {e}")
                self.stats['failed'] += 1

        # Print summary
        self._print_summary()

    def _get_universities(self, limit: int) -> List[Dict]:
        """Get universities with missing data"""
        result = self.db_client.client.table('universities').select(
            'id, name, country, city, state, website'
        ).or_(
            'city.is.null,state.is.null'
        ).limit(limit).execute()

        return result.data

    def _search_and_extract(self, uni: Dict) -> Dict[str, Any]:
        """Search online and extract university information"""
        updates = {}

        # Try multiple search strategies
        if not uni.get('city'):
            city = self._find_city(uni['name'], uni['country'])
            if city:
                updates['city'] = city

        if not uni.get('state'):
            state = self._find_state(uni['name'], uni['country'])
            if state:
                updates['state'] = state

        return updates

    def _find_city(self, uni_name: str, country: str) -> Optional[str]:
        """Find university city using web search"""
        try:
            # Use DuckDuckGo HTML search
            query = f"{uni_name} university {country} location city"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Extract text from search results
            snippets = soup.find_all('a', class_='result__snippet')
            text = ' '.join([s.get_text() for s in snippets[:3]])

            # Common patterns for extracting city
            patterns = [
                # "located in City"
                rf'located in ([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)',
                # "in City, Country"
                rf'in ([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*{re.escape(country)}',
                # "City, Country"
                rf'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*{re.escape(country)}',
                # "based in City"
                rf'based in ([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)',
                # Just look for "City" after university name
                rf'{re.escape(uni_name)}.*?([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)',
            ]

            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    city = match.group(1).strip()
                    # Validate it's a reasonable city name
                    if self._is_valid_city_name(city):
                        return city

            return None

        except Exception as e:
            logger.debug(f"City search failed: {e}")
            return None

    def _find_state(self, uni_name: str, country: str) -> Optional[str]:
        """Find university state/region using web search"""
        try:
            query = f"{uni_name} university {country} state region"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')
            snippets = soup.find_all('a', class_='result__snippet')
            text = ' '.join([s.get_text() for s in snippets[:3]])

            # Patterns for state/region
            patterns = [
                rf'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*{re.escape(country)}',
                rf'in ([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)\s+(?:state|province|region)',
            ]

            for pattern in patterns:
                match = re.search(pattern, text, re.IGNORECASE)
                if match:
                    # Get the second capture group (state/region)
                    state = match.group(2) if match.lastindex >= 2 else match.group(1)
                    if self._is_valid_state_name(state):
                        return state

            return None

        except Exception as e:
            logger.debug(f"State search failed: {e}")
            return None

    def _is_valid_city_name(self, name: str) -> bool:
        """Check if string is a valid city name"""
        if not name or len(name) < 3 or len(name) > 50:
            return False

        # Check for numbers (cities rarely have numbers)
        if any(char.isdigit() for char in name):
            return False

        # Check for common false positives
        invalid_words = ['university', 'college', 'institute', 'school', 'the', 'and', 'of']
        if name.lower() in invalid_words:
            return False

        return True

    def _is_valid_state_name(self, name: str) -> bool:
        """Check if string is a valid state/region name"""
        if not name or len(name) < 3 or len(name) > 50:
            return False

        if any(char.isdigit() for char in name):
            return False

        return True

    def _save_updates(self, uni_id: int, updates: Dict):
        """Save updates to database"""
        try:
            self.db_client.client.table('universities').update(updates).eq(
                'id', uni_id
            ).execute()
        except Exception as e:
            logger.error(f"Failed to save: {e}")
            raise

    def _print_summary(self):
        """Print summary statistics"""
        logger.info("")
        logger.info("=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total_processed']}")
        logger.info(f"Cities filled:    {self.stats['city_filled']}")
        logger.info(f"States filled:    {self.stats['state_filled']}")
        logger.info(f"Websites filled:  {self.stats['website_filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total_processed'] > 0:
            success_rate = (self.stats['total_processed'] /
                          (self.stats['total_processed'] + self.stats['skipped'] + self.stats['failed'])) * 100
            logger.info(f"Success rate:     {success_rate:.1f}%")

        logger.info("=" * 80)


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Automatically fill university data from web search'
    )
    parser.add_argument(
        '--limit',
        type=int,
        default=100,
        help='Number of universities to process (default: 100)'
    )

    args = parser.parse_args()

    filler = AutomatedDataFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
