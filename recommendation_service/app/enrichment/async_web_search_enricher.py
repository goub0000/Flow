"""
Async Web Search-Based Data Enricher
High-performance async version using aiohttp
WITH RETRY LOGIC AND RATE LIMITING
"""
import aiohttp
import asyncio
import logging
from typing import Dict, Optional
from bs4 import BeautifulSoup
import re

from app.utils.retry import (
    retry_async,
    WIKIPEDIA_RATE_LIMITER,
    DUCKDUCKGO_RATE_LIMITER,
    WIKIPEDIA_CIRCUIT_BREAKER,
    DUCKDUCKGO_CIRCUIT_BREAKER,
)

logger = logging.getLogger(__name__)


class AsyncWebSearchEnricher:
    """
    Async version of WebSearchEnricher
    Uses aiohttp for concurrent web requests
    """

    def __init__(self, rate_limit_delay: float = 1.0):
        self.rate_limit_delay = rate_limit_delay
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }

    async def search_university_info_async(
        self,
        university_name: str,
        country: str = None,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """
        Asynchronously search web for comprehensive university information

        Args:
            university_name: Name of the university
            country: Country code (optional)
            session: aiohttp ClientSession

        Returns:
            Dictionary with found information
        """
        logger.info(f"Searching web for: {university_name}")

        enriched_data = {}

        try:
            # Run all searches concurrently
            tasks = [
                self._search_wikipedia_async(university_name, country, session),
                self._search_duckduckgo_async(university_name, session),
            ]

            # Wait for all tasks to complete
            results = await asyncio.gather(*tasks, return_exceptions=True)

            # Merge results
            for result in results:
                if isinstance(result, dict):
                    enriched_data.update(result)
                elif isinstance(result, Exception):
                    logger.warning(f"Search task failed: {result}")

            # Guess and validate website if not found
            if not enriched_data.get('website'):
                website = await self._guess_and_validate_website_async(
                    university_name, country, session
                )
                if website:
                    enriched_data['website'] = website

            # If we have website, scrape it for details
            if enriched_data.get('website'):
                site_data = await self._scrape_university_website_async(
                    enriched_data['website'], session
                )
                enriched_data.update(site_data)

        except Exception as e:
            logger.error(f"Error searching for {university_name}: {e}")

        return enriched_data

    @retry_async(max_attempts=3, initial_delay=1.0, max_delay=10.0)
    async def _search_wikipedia_async(
        self,
        university_name: str,
        country: str = None,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """Async Wikipedia search with retry logic and rate limiting"""
        data = {}

        try:
            # Rate limiting - wait for token before making request
            await WIKIPEDIA_RATE_LIMITER.acquire()

            # Search Wikipedia API
            search_url = "https://en.wikipedia.org/w/api.php"
            search_params = {
                'action': 'query',
                'list': 'search',
                'srsearch': university_name,
                'format': 'json',
                'srlimit': 3
            }

            async with session.get(search_url, params=search_params, timeout=10, headers=self.headers) as response:
                if response.status != 200:
                    return data

                search_results = await response.json()
                if not search_results:
                    return data

                query = search_results.get('query')
                if not query or not query.get('search'):
                    return data

                # Get first result
                page_title = query['search'][0]['title']

                # Get page content
                content_params = {
                    'action': 'query',
                    'titles': page_title,
                    'prop': 'extracts|pageimages|coordinates|info',
                    'exintro': '1',  # Must be string, not boolean
                    'explaintext': '1',  # Must be string, not boolean
                    'piprop': 'original',
                    'inprop': 'url',
                    'format': 'json'
                }

                async with session.get(search_url, params=content_params, timeout=10, headers=self.headers) as content_response:
                    if content_response.status != 200:
                        return data

                    content_json = await content_response.json()
                    if not content_json:
                        return data

                    query_data = content_json.get('query')
                    if not query_data:
                        return data

                    pages = query_data.get('pages', {})
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

            logger.info(f"Found {len(data)} fields from Wikipedia for {university_name}")

        except Exception as e:
            logger.warning(f"Wikipedia search failed for {university_name}: {e}")

        return data

    @retry_async(max_attempts=3, initial_delay=2.0, max_delay=15.0)
    async def _search_duckduckgo_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """Async DuckDuckGo instant answer API with retry logic and rate limiting"""
        data = {}

        try:
            # Rate limiting - wait for token before making request
            await DUCKDUCKGO_RATE_LIMITER.acquire()

            url = "https://api.duckduckgo.com/"
            params = {
                'q': university_name,
                'format': 'json',
                'no_redirect': 1
            }

            async with session.get(url, params=params, timeout=10, headers=self.headers) as response:
                if response.status != 200:
                    return data

                # Check content type before parsing
                content_type = response.headers.get('Content-Type', '')
                if 'json' not in content_type.lower():
                    logger.warning(f"DuckDuckGo returned non-JSON content type: {content_type}")
                    return data

                result = await response.json()

                # Ensure result is not None
                if not result:
                    return data

                # Extract abstract/description
                abstract = result.get('Abstract')
                if abstract:
                    data['description'] = abstract

                # Extract official website
                abstract_url = result.get('AbstractURL')
                if abstract_url and 'wikipedia' not in abstract_url.lower():
                    data['website'] = abstract_url

            logger.info(f"Found {len(data)} fields from DuckDuckGo for {university_name}")

        except Exception as e:
            logger.warning(f"DuckDuckGo search failed for {university_name}: {e}")

        return data

    async def _guess_and_validate_website_async(
        self,
        university_name: str,
        country: str = None,
        session: aiohttp.ClientSession = None
    ) -> Optional[str]:
        """Async website guessing and validation"""

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

        # Try each pattern concurrently
        async def try_pattern(pattern):
            try:
                async with session.head(pattern, timeout=5, allow_redirects=True) as response:
                    if response.status == 200:
                        return pattern
            except:
                pass
            return None

        tasks = [try_pattern(pattern) for pattern in patterns]
        results = await asyncio.gather(*tasks, return_exceptions=True)

        for result in results:
            if result and isinstance(result, str):
                logger.info(f"Found valid website: {result}")
                return result

        return None

    async def _scrape_university_website_async(
        self,
        website: str,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """Async university website scraping"""
        data = {}

        try:
            async with session.get(website, timeout=10, headers=self.headers) as response:
                if response.status != 200:
                    return data

                html = await response.text()
                soup = BeautifulSoup(html, 'html.parser')

                # Try to find logo
                logo = soup.find('link', rel='icon') or soup.find('link', rel='shortcut icon')
                if logo and logo.get('href'):
                    href = logo['href']
                    if href.startswith('http'):
                        data['logo_url'] = href
                    elif href.startswith('/'):
                        from urllib.parse import urljoin
                        data['logo_url'] = urljoin(website, href)

                # Try to find address/location in footer
                footer = soup.find('footer')
                if footer:
                    text = footer.get_text()
                    state_match = re.search(r',\s*([A-Z]{2})\s*\d{5}', text)
                    if state_match:
                        data['state'] = state_match.group(1)

                # Try to find acceptance rate
                text = soup.get_text().lower()
                acceptance_match = re.search(r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%', text)
                if acceptance_match:
                    rate = float(acceptance_match.group(1)) / 100
                    data['acceptance_rate'] = rate

                # Look for student enrollment
                enrollment_match = re.search(r'enrollment[:\s]+(\d{1,3}(?:,\d{3})*)', text, re.IGNORECASE)
                if enrollment_match:
                    students = int(enrollment_match.group(1).replace(',', ''))
                    data['total_students'] = students

            logger.info(f"Scraped {len(data)} fields from {website}")

        except Exception as e:
            logger.warning(f"Failed to scrape {website}: {e}")

        return data

    async def enrich_university_async(
        self,
        university: Dict,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """
        Asynchronously enrich a single university record

        Args:
            university: University dict from database
            session: aiohttp ClientSession

        Returns:
            Dictionary with enriched fields only (non-NULL values)
        """
        enriched = {}

        # Search for comprehensive info
        search_results = await self.search_university_info_async(
            university['name'],
            university.get('country'),
            session
        )

        # Only include fields that have values and are currently NULL
        for field, value in search_results.items():
            if value and not university.get(field):
                enriched[field] = value

        return enriched
