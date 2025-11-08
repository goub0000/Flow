"""
Auto-Fill Website URLs
Specialized program to find and validate university websites
"""

import logging
import requests
import re
from bs4 import BeautifulSoup
from typing import Dict, Optional, List
from time import sleep
import random
from app.database.supabase_client import get_supabase_client

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)


class WebsiteFiller:
    """Find and validate university websites"""

    def __init__(self, rate_limit: float = 2.5):
        self.rate_limit = rate_limit
        self.db_client = None
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.stats = {'total': 0, 'filled': 0, 'failed': 0, 'skipped': 0}

    def run(self, limit: int = 100):
        logger.info("=" * 80)
        logger.info("AUTO-FILL WEBSITE URLs")
        logger.info("=" * 80)

        self.db_client = get_supabase_client()
        logger.info("Connected to database\n")

        # Get universities without websites
        result = self.db_client.client.table('universities').select(
            'id, name, country'
        ).is_('website', 'null').limit(limit).execute()

        universities = result.data
        if not universities:
            logger.info("No universities need websites!")
            return

        logger.info(f"Found {len(universities)} universities without websites\n")

        for i, uni in enumerate(universities, 1):
            logger.info(f"[{i}/{len(universities)}] {uni['name']} ({uni['country']})")

            try:
                website = self._find_website(uni['name'], uni['country'])

                if website:
                    self.db_client.client.table('universities').update(
                        {'website': website}
                    ).eq('id', uni['id']).execute()

                    logger.info(f"  ✓ Found: {website}")
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

    def _find_website(self, uni_name: str, country: str) -> Optional[str]:
        """Find university website using multiple strategies"""

        # Strategy 1: Try constructed URLs (fastest and most reliable)
        constructed_url = self._try_constructed_urls(uni_name, country)
        if constructed_url:
            return constructed_url

        # Strategy 2: Try web search (if construction fails)
        searched_url = self._search_for_website(uni_name, country)
        if searched_url:
            return searched_url

        return None

    def _try_constructed_urls(self, uni_name: str, country: str) -> Optional[str]:
        """Try to construct likely university URLs"""
        try:
            # Special cases and common abbreviations
            special_cases = {
                'University of Pennsylvania': 'upenn.edu',
                'University of California, Los Angeles (UCLA)': 'ucla.edu',
                'University of California, Los Angeles': 'ucla.edu',
                'UCLA': 'ucla.edu',
                'University of Chicago': 'uchicago.edu',
                'University of Michigan': 'umich.edu',
                'University of Virginia': 'virginia.edu',
                'University of Washington': 'washington.edu',
                'University of Wisconsin': 'wisc.edu',
                'University of Illinois': 'illinois.edu',
                'University of California, Berkeley': 'berkeley.edu',
                'UC Berkeley': 'berkeley.edu',
                'MIT': 'mit.edu',
                'Caltech': 'caltech.edu',
                'Carnegie Mellon': 'cmu.edu',
                'NYU': 'nyu.edu',
                'USC': 'usc.edu',
                'The University of Melbourne': 'unimelb.edu.au',
                'Peking University': 'pku.edu.cn',
            }

            # Check special cases first
            if uni_name in special_cases:
                url = f"https://{special_cases[uni_name]}"
                if self._validate_url(url):
                    logger.debug(f"Found via special case: {url}")
                    return url

            # Generate possible domain names
            possible_domains = []

            # Clean the university name
            name_lower = uni_name.lower()
            name_lower = re.sub(r'\bthe\b', '', name_lower).strip()
            name_lower = re.sub(r'\buniversity\b', '', name_lower).strip()
            name_lower = re.sub(r'\bcollege\b', '', name_lower).strip()
            name_lower = re.sub(r'\bof\b', '', name_lower).strip()
            name_lower = re.sub(r'\(.*?\)', '', name_lower).strip()  # Remove parentheses
            name_lower = re.sub(r'[^\w\s]', '', name_lower)  # Remove punctuation

            # Get primary words
            words = name_lower.split()
            if not words:
                return None

            # US universities (.edu)
            if country == 'US':
                # Single word: stanford -> stanford.edu
                if len(words) == 1:
                    possible_domains.append(f"{words[0]}.edu")
                # Multiple words
                elif len(words) >= 2:
                    # Try first word (princeton, stanford)
                    possible_domains.append(f"{words[0]}.edu")
                    # Try acronym (UCLA = uclaw)
                    acronym = ''.join([w[0] for w in words])
                    possible_domains.append(f"{acronym}.edu")
                    # Try concatenation (uchicago)
                    if len(words) == 2:
                        possible_domains.append(f"{words[0]}{words[1]}.edu")
                        possible_domains.append(f"u{words[1]}.edu")  # uchicago
                    # Try common patterns for "University of X"
                    if len(words) >= 2:
                        # Last word (washington, michigan)
                        possible_domains.append(f"{words[-1]}.edu")
                        # First + last (umich, uva)
                        possible_domains.append(f"u{words[-1][:4]}.edu")

            # UK universities (.ac.uk)
            elif country == 'GB' or country == 'UK':
                if len(words) >= 1:
                    possible_domains.append(f"{words[0]}.ac.uk")
                    if len(words) >= 2:
                        acronym = ''.join([w[0] for w in words])
                        possible_domains.append(f"{acronym}.ac.uk")

            # Australian universities (.edu.au or .ac.au)
            elif country == 'AU':
                if len(words) >= 1:
                    possible_domains.append(f"{words[0]}.edu.au")
                    possible_domains.append(f"{words[0]}.ac.au")
                    # Melbourne -> unimelb
                    if 'melbourne' in words:
                        possible_domains.append(f"unimelb.edu.au")

            # Canadian universities (.ca)
            elif country == 'CA':
                if len(words) >= 1:
                    possible_domains.append(f"{words[0]}.ca")
                    if len(words) >= 2:
                        acronym = ''.join([w[0] for w in words])
                        possible_domains.append(f"{acronym}.ca")

            # Chinese universities (.edu.cn)
            elif country in ['CN', 'XX']:  # XX for unknown countries that might be China
                if 'peking' in words or 'beijing' in words:
                    possible_domains.append('pku.edu.cn')
                if 'tsinghua' in words:
                    possible_domains.append('tsinghua.edu.cn')
                if 'fudan' in words:
                    possible_domains.append('fudan.edu.cn')

            # Try each possible domain
            for domain in possible_domains:
                url = f"https://{domain}"
                if self._validate_url(url):
                    logger.debug(f"Found via construction: {url}")
                    return url

            return None

        except Exception as e:
            logger.debug(f"URL construction failed: {e}")
            return None

    def _search_for_website(self, uni_name: str, country: str) -> Optional[str]:
        """Search for university website using DuckDuckGo"""
        try:
            # Search query
            query = f"{uni_name} university {country} official website"
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"

            response = self.session.get(search_url, timeout=10)
            if response.status_code != 200:
                logger.debug(f"Search returned status {response.status_code}")
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Extract URLs from search results
            result_links = soup.find_all('a', class_='result__a')

            for link in result_links[:10]:
                href = link.get('href', '')

                # DuckDuckGo wraps URLs
                if 'uddg=' in href:
                    import urllib.parse
                    params = urllib.parse.parse_qs(urllib.parse.urlparse(href).query)
                    if 'uddg' in params:
                        url = params['uddg'][0]
                    else:
                        continue
                else:
                    url = href

                # Skip non-university domains
                if any(skip in url.lower() for skip in ['wikipedia', 'facebook', 'linkedin', 'youtube', 'instagram', 'twitter']):
                    continue

                # Prioritize university domains
                if any(domain in url.lower() for domain in ['.edu', '.ac.', 'university', 'college', 'institut', '.edu.', 'uni-']):
                    clean_url = self._clean_url(url)
                    if clean_url and self._validate_url(clean_url):
                        logger.debug(f"Found via search: {clean_url}")
                        return clean_url

            return None

        except Exception as e:
            logger.debug(f"Search failed: {e}")
            return None

    def _clean_url(self, url: str) -> str:
        """Clean and normalize URL"""
        # Remove tracking parameters
        if '?' in url:
            url = url.split('?')[0]

        # Ensure https
        if not url.startswith('http'):
            url = f"https://{url}"

        # Remove trailing slash
        url = url.rstrip('/')

        return url

    def _validate_url(self, url: str) -> bool:
        """Check if URL is accessible"""
        try:
            response = self.session.head(url, timeout=5, allow_redirects=True)
            return response.status_code < 400
        except:
            return False

    def _print_summary(self):
        logger.info("\n" + "=" * 80)
        logger.info("SUMMARY")
        logger.info("=" * 80)
        logger.info(f"Total processed:  {self.stats['total']}")
        logger.info(f"Websites filled:  {self.stats['filled']}")
        logger.info(f"Skipped:          {self.stats['skipped']}")
        logger.info(f"Failed:           {self.stats['failed']}")

        if self.stats['total'] > 0:
            rate = (self.stats['filled'] / self.stats['total']) * 100
            logger.info(f"Success rate:     {rate:.1f}%")
        logger.info("=" * 80)


def main():
    import argparse
    parser = argparse.ArgumentParser(description='Auto-fill university websites')
    parser.add_argument('--limit', type=int, default=100, help='Number to process')
    args = parser.parse_args()

    filler = WebsiteFiller()
    filler.run(limit=args.limit)


if __name__ == "__main__":
    main()
