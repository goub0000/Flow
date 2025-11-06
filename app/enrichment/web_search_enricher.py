"""
Web Search-Based Data Enricher
Automatically searches the web for missing university information
"""
import requests
import time
import logging
from typing import Dict, Optional, List
from bs4 import BeautifulSoup
import re

logger = logging.getLogger(__name__)


class WebSearchEnricher:
    """
    Uses multiple web sources to find and fill missing university data
    """

    def __init__(self, rate_limit_delay: float = 2.0):
        self.rate_limit_delay = rate_limit_delay
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

    def search_university_info(self, university_name: str, country: str = None) -> Dict:
        """
        Search web for comprehensive university information

        Args:
            university_name: Name of the university
            country: Country code (optional, helps with disambiguation)

        Returns:
            Dictionary with found information
        """
        logger.info(f"Searching web for: {university_name}")

        enriched_data = {}

        # Try multiple sources
        try:
            # 1. Wikipedia
            wiki_data = self._search_wikipedia(university_name, country)
            enriched_data.update(wiki_data)
            time.sleep(self.rate_limit_delay)

            # 2. DuckDuckGo instant answers
            ddg_data = self._search_duckduckgo(university_name)
            enriched_data.update(ddg_data)
            time.sleep(self.rate_limit_delay)

            # 3. Guess and validate website
            if not enriched_data.get('website'):
                website = self._guess_and_validate_website(university_name, country)
                if website:
                    enriched_data['website'] = website
                    time.sleep(self.rate_limit_delay)

            # 4. If we have website, scrape it for details
            if enriched_data.get('website'):
                site_data = self._scrape_university_website(enriched_data['website'])
                enriched_data.update(site_data)

        except Exception as e:
            logger.error(f"Error searching for {university_name}: {e}")

        return enriched_data

    def _search_wikipedia(self, university_name: str, country: str = None) -> Dict:
        """Search Wikipedia for university information"""
        data = {}

        try:
            # Search Wikipedia API
            search_url = "https://en.wikipedia.org/w/api.php"
            search_params = {
                'action': 'query',
                'list': 'search',
                'srsearch': university_name,
                'format': 'json',
                'srlimit': 3
            }

            response = self.session.get(search_url, params=search_params, timeout=10)
            if response.status_code != 200:
                return data

            search_results = response.json()
            if not search_results.get('query', {}).get('search'):
                return data

            # Get first result
            page_title = search_results['query']['search'][0]['title']

            # Get page content
            content_params = {
                'action': 'query',
                'titles': page_title,
                'prop': 'extracts|pageimages|coordinates|info',
                'exintro': True,
                'explaintext': True,
                'piprop': 'original',
                'inprop': 'url',
                'format': 'json'
            }

            content_response = self.session.get(search_url, params=content_params, timeout=10)
            if content_response.status_code != 200:
                return data

            pages = content_response.json().get('query', {}).get('pages', {})
            if not pages:
                return data

            page = list(pages.values())[0]

            # Extract information
            if 'extract' in page:
                extract = page['extract']
                data['description'] = extract[:500] if len(extract) > 500 else extract

                # Try to extract location from text
                city_match = re.search(r'located in ([A-Z][a-z]+(?:\s[A-Z][a-z]+)*)', extract)
                if city_match:
                    data['city'] = city_match.group(1)

                # Try to extract student count
                students_match = re.search(r'(\d{1,3}(?:,\d{3})*)\s+students', extract)
                if students_match:
                    students_str = students_match.group(1).replace(',', '')
                    data['total_students'] = int(students_str)

            # Get website URL if available
            if 'fullurl' in page:
                # Try to get official website from Wikipedia
                # This would require parsing the actual page HTML
                pass

            logger.info(f"Found {len(data)} fields from Wikipedia for {university_name}")

        except Exception as e:
            logger.warning(f"Wikipedia search failed for {university_name}: {e}")

        return data

    def _search_duckduckgo(self, university_name: str) -> Dict:
        """Search DuckDuckGo instant answer API"""
        data = {}

        try:
            url = "https://api.duckduckgo.com/"
            params = {
                'q': university_name,
                'format': 'json',
                'no_redirect': 1
            }

            response = self.session.get(url, params=params, timeout=10)
            if response.status_code != 200:
                return data

            result = response.json()

            # Extract abstract/description
            if result.get('Abstract'):
                data['description'] = result['Abstract']

            # Extract official website
            if result.get('AbstractURL'):
                # Sometimes DuckDuckGo returns the official site
                url = result['AbstractURL']
                if 'wikipedia' not in url.lower():
                    data['website'] = url

            logger.info(f"Found {len(data)} fields from DuckDuckGo for {university_name}")

        except Exception as e:
            logger.warning(f"DuckDuckGo search failed for {university_name}: {e}")

        return data

    def _guess_and_validate_website(self, university_name: str, country: str = None) -> Optional[str]:
        """Generate possible website URLs and validate them"""

        # Clean university name
        name_parts = university_name.lower().replace('university of', '').replace('the', '').strip().split()

        # Common patterns
        patterns = []

        # Pattern 1: firstword.edu (US)
        if country in ['US', 'USA', 'United States']:
            patterns.append(f"https://{name_parts[0]}.edu")
            patterns.append(f"https://www.{name_parts[0]}.edu")

        # Pattern 2: firstword.ac.country
        country_domains = {
            'GB': 'ac.uk', 'UK': 'ac.uk',
            'CA': 'ca', 'AU': 'edu.au',
            'NZ': 'ac.nz', 'ZA': 'ac.za',
            'IN': 'ac.in', 'SG': 'edu.sg'
        }

        if country in country_domains:
            patterns.append(f"https://{name_parts[0]}.{country_domains[country]}")
            patterns.append(f"https://www.{name_parts[0]}.{country_domains[country]}")

        # Pattern 3: abbreviation.edu
        if len(name_parts) > 1:
            abbrev = ''.join([word[0] for word in name_parts[:3]])
            patterns.append(f"https://{abbrev}.edu")
            patterns.append(f"https://www.{abbrev}.edu")

        # Pattern 4: fullname.edu (for shorter names)
        if len(name_parts) <= 2:
            combined = ''.join(name_parts)
            patterns.append(f"https://{combined}.edu")

        # Try each pattern
        for pattern in patterns:
            try:
                response = self.session.head(pattern, timeout=5, allow_redirects=True)
                if response.status_code == 200:
                    logger.info(f"Found valid website: {pattern}")
                    return pattern
            except:
                continue

        return None

    def _scrape_university_website(self, website: str) -> Dict:
        """Scrape university website for additional information"""
        data = {}

        try:
            response = self.session.get(website, timeout=10)
            if response.status_code != 200:
                return data

            soup = BeautifulSoup(response.content, 'html.parser')

            # Try to find logo
            logo = soup.find('link', rel='icon') or soup.find('link', rel='shortcut icon')
            if logo and logo.get('href'):
                href = logo['href']
                if href.startswith('http'):
                    data['logo_url'] = href
                elif href.startswith('/'):
                    from urllib.parse import urljoin
                    data['logo_url'] = urljoin(website, href)

            # Try to find address/location in footer or contact page
            footer = soup.find('footer')
            if footer:
                # Look for city, state patterns
                text = footer.get_text()
                # Simple pattern matching for US addresses
                state_match = re.search(r',\s*([A-Z]{2})\s*\d{5}', text)
                if state_match:
                    data['state'] = state_match.group(1)

            # Try to find acceptance rate or admissions data
            text = soup.get_text().lower()
            acceptance_match = re.search(r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%', text)
            if acceptance_match:
                rate = float(acceptance_match.group(1)) / 100
                data['acceptance_rate'] = rate

            # Look for student enrollment numbers
            enrollment_match = re.search(r'enrollment[:\s]+(\d{1,3}(?:,\d{3})*)', text, re.IGNORECASE)
            if enrollment_match:
                students = int(enrollment_match.group(1).replace(',', ''))
                data['total_students'] = students

            logger.info(f"Scraped {len(data)} fields from {website}")

        except Exception as e:
            logger.warning(f"Failed to scrape {website}: {e}")

        return data

    def enrich_university(self, university: Dict) -> Dict:
        """
        Enrich a single university record with missing data

        Args:
            university: University dict from database

        Returns:
            Dictionary with enriched fields only (non-NULL values)
        """
        enriched = {}

        # Search for comprehensive info
        search_results = self.search_university_info(
            university['name'],
            university.get('country')
        )

        # Only include fields that have values and are currently NULL
        for field, value in search_results.items():
            if value and not university.get(field):
                enriched[field] = value

        return enriched
