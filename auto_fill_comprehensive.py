"""
Comprehensive University Data Filler
Automatically fills: website, logo_url, total_students, acceptance_rate, university_type
Uses web search to extract information from multiple sources
"""

import logging
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


class ComprehensiveDataFiller:
    """Automatically searches and fills comprehensive university data"""

    def __init__(self, rate_limit: float = 3.0):
        self.rate_limit = rate_limit
        self.db_client = None
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

        self.stats = {
            'total_processed': 0,
            'website_filled': 0,
            'logo_filled': 0,
            'students_filled': 0,
            'acceptance_filled': 0,
            'type_filled': 0,
            'failed': 0,
            'skipped': 0
        }

    def run(self, limit: int = 100):
        """Run the automated filling process"""
        logger.info("=" * 80)
        logger.info("COMPREHENSIVE UNIVERSITY DATA FILLING")
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

                    # Update field stats
                    if 'website' in updates:
                        self.stats['website_filled'] += 1
                    if 'logo_url' in updates:
                        self.stats['logo_filled'] += 1
                    if 'total_students' in updates:
                        self.stats['students_filled'] += 1
                    if 'acceptance_rate' in updates:
                        self.stats['acceptance_filled'] += 1
                    if 'university_type' in updates:
                        self.stats['type_filled'] += 1
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
            'id, name, country, website, logo_url, total_students, acceptance_rate, university_type'
        ).or_(
            'website.is.null,logo_url.is.null,total_students.is.null,acceptance_rate.is.null,university_type.is.null'
        ).limit(limit).execute()

        return result.data

    def _search_and_extract(self, uni: Dict) -> Dict[str, Any]:
        """Search online and extract university information"""
        updates = {}

        # Try to find missing fields
        if not uni.get('website'):
            website = self._find_website(uni['name'], uni['country'])
            if website:
                updates['website'] = website

        # Use website to find logo if website is available
        website_url = updates.get('website') or uni.get('website')
        if website_url and not uni.get('logo_url'):
            logo = self._find_logo(website_url, uni['name'])
            if logo:
                updates['logo_url'] = logo

        # Find enrollment/students
        if not uni.get('total_students'):
            students = self._find_total_students(uni['name'], uni['country'])
            if students:
                updates['total_students'] = students

        # Find acceptance rate
        if not uni.get('acceptance_rate'):
            rate = self._find_acceptance_rate(uni['name'], uni['country'])
            if rate:
                updates['acceptance_rate'] = rate

        # Find university type
        if not uni.get('university_type'):
            uni_type = self._find_university_type(uni['name'], uni['country'])
            if uni_type:
                updates['university_type'] = uni_type

        return updates

    def _find_website(self, uni_name: str, country: str) -> Optional[str]:
        """Find university website using web search"""
        try:
            query = f"{uni_name} university {country} official website"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Look for URLs in search results
            links = soup.find_all('a', class_='result__url')
            for link in links[:5]:
                url = link.get('href', '')
                # Common university domain patterns
                if any(domain in url.lower() for domain in ['.edu', '.ac.', 'university', 'college']):
                    # Validate it's accessible
                    if self._validate_url(url):
                        return url

            return None

        except Exception as e:
            logger.debug(f"Website search failed: {e}")
            return None

    def _validate_url(self, url: str) -> bool:
        """Check if URL is accessible"""
        try:
            if not url.startswith('http'):
                url = f"https://{url}"
            response = self.session.head(url, timeout=5, allow_redirects=True)
            return response.status_code < 400
        except:
            return False

    def _find_logo(self, website_url: str, uni_name: str) -> Optional[str]:
        """Extract university logo from website"""
        try:
            response = self.session.get(website_url, timeout=10, allow_redirects=True)
            if response.status_code >= 400:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Try multiple strategies to find logo

            # 1. Look for logo in common class names
            logo_classes = ['logo', 'header-logo', 'site-logo', 'brand-logo', 'navbar-brand']
            for cls in logo_classes:
                img = soup.find('img', class_=re.compile(cls, re.I))
                if img and img.get('src'):
                    logo_url = img['src']
                    if not logo_url.startswith('http'):
                        from urllib.parse import urljoin
                        logo_url = urljoin(website_url, logo_url)
                    return logo_url

            # 2. Look for logo in link rel
            link = soup.find('link', rel=re.compile('icon|logo', re.I))
            if link and link.get('href'):
                logo_url = link['href']
                if not logo_url.startswith('http'):
                    from urllib.parse import urljoin
                    logo_url = urljoin(website_url, logo_url)
                return logo_url

            # 3. Look for any img with "logo" in src or alt
            imgs = soup.find_all('img', src=re.compile('logo', re.I))
            if imgs:
                logo_url = imgs[0]['src']
                if not logo_url.startswith('http'):
                    from urllib.parse import urljoin
                    logo_url = urljoin(website_url, logo_url)
                return logo_url

            return None

        except Exception as e:
            logger.debug(f"Logo extraction failed: {e}")
            return None

    def _find_total_students(self, uni_name: str, country: str) -> Optional[int]:
        """Find total student enrollment"""
        try:
            query = f"{uni_name} university {country} enrollment students total"
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

    def _find_acceptance_rate(self, uni_name: str, country: str) -> Optional[float]:
        """Find acceptance rate"""
        try:
            query = f"{uni_name} university {country} acceptance rate admission"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')
            snippets = soup.find_all('a', class_='result__snippet')
            text = ' '.join([s.get_text() for s in snippets[:5]])

            # Patterns for acceptance rate
            patterns = [
                r'acceptance rate.*?(\d+(?:\.\d+)?)\s*%',
                r'(\d+(?:\.\d+)?)\s*%.*?acceptance',
                r'admit.*?(\d+(?:\.\d+)?)\s*%',
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

    def _find_university_type(self, uni_name: str, country: str) -> Optional[str]:
        """Find university type (public/private)"""
        try:
            query = f"{uni_name} university {country} public private type"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')
            snippets = soup.find_all('a', class_='result__snippet')
            text = ' '.join([s.get_text() for s in snippets[:3]])

            # Look for type indicators
            text_lower = text.lower()

            # Check for explicit mentions
            if 'public university' in text_lower or 'state university' in text_lower:
                return 'Public'
            elif 'private university' in text_lower:
                return 'Private'

            return None

        except Exception as e:
            logger.debug(f"Type search failed: {e}")
            return None

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
        logger.info(f"Total processed:     {self.stats['total_processed']}")
        logger.info(f"Websites filled:     {self.stats['website_filled']}")
        logger.info(f"Logos filled:        {self.stats['logo_filled']}")
        logger.info(f"Students filled:     {self.stats['students_filled']}")
        logger.info(f"Acceptance filled:   {self.stats['acceptance_filled']}")
        logger.info(f"Type filled:         {self.stats['type_filled']}")
        logger.info(f"Skipped:             {self.stats['skipped']}")
        logger.info(f"Failed:              {self.stats['failed']}")

        if self.stats['total_processed'] > 0:
            success_rate = (self.stats['total_processed'] /
                          (self.stats['total_processed'] + self.stats['skipped'] + self.stats['failed'])) * 100
            logger.info(f"Success rate:        {success_rate:.1f}%")

        logger.info("=" * 80)


def main():
    """Main entry point"""
    import argparse

    parser = argparse.ArgumentParser(
        description='Automatically fill comprehensive university data from web search'
    )
    parser.add_argument(
        '--limit',
        type=int,
        default=100,
        help='Number of universities to process (default: 100)'
    )

    args = parser.parse_args()

    filler = ComprehensiveDataFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
