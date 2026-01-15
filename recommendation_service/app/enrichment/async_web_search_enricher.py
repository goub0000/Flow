"""
Async Web Search-Based Data Enricher
High-performance async version using aiohttp
WITH RETRY LOGIC AND RATE LIMITING
Enhanced with multiple data sources and rotating user agents
"""
import aiohttp
import asyncio
import logging
import random
from typing import Dict, Optional, List
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

# Rotating user agents to avoid blocking
USER_AGENTS = [
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0',
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15',
    'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Edge/120.0.0.0 Safari/537.36',
]


class AsyncWebSearchEnricher:
    """
    Async version of WebSearchEnricher
    Uses aiohttp for concurrent web requests
    Enhanced with Wikidata, improved Wikipedia parsing, and rotating user agents
    """

    def __init__(self, rate_limit_delay: float = 1.0):
        self.rate_limit_delay = rate_limit_delay

    def _get_headers(self) -> Dict[str, str]:
        """Get headers with a random user agent"""
        return {
            'User-Agent': random.choice(USER_AGENTS),
            'Accept': 'application/json, text/html, */*',
            'Accept-Language': 'en-US,en;q=0.9',
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

        # Create session if not provided
        close_session = False
        if session is None:
            session = aiohttp.ClientSession()
            close_session = True

        try:
            # Run all searches concurrently - prioritize reliable sources
            tasks = [
                self._search_wikidata_async(university_name, country, session),
                self._search_wikipedia_async(university_name, country, session),
                self._search_duckduckgo_html_async(university_name, session),
            ]

            # Wait for all tasks to complete
            results = await asyncio.gather(*tasks, return_exceptions=True)

            # Merge results (later results override earlier ones)
            for result in results:
                if isinstance(result, dict):
                    # Only update fields that aren't already set
                    for key, value in result.items():
                        if value and not enriched_data.get(key):
                            enriched_data[key] = value
                elif isinstance(result, Exception):
                    logger.debug(f"Search task failed: {result}")

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
                # Only update fields not already found
                for key, value in site_data.items():
                    if value and not enriched_data.get(key):
                        enriched_data[key] = value

        except Exception as e:
            logger.error(f"Error searching for {university_name}: {e}")

        finally:
            # Close session if we created it
            if close_session and session:
                await session.close()

        return enriched_data

    @retry_async(max_attempts=2, initial_delay=1.0, max_delay=5.0)
    async def _search_wikidata_async(
        self,
        university_name: str,
        country: str = None,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """
        Search Wikidata for structured university information
        More reliable than Wikipedia for specific data points
        """
        data = {}

        try:
            await WIKIPEDIA_RATE_LIMITER.acquire()

            # Search for entity
            search_url = "https://www.wikidata.org/w/api.php"
            search_params = {
                'action': 'wbsearchentities',
                'search': university_name,
                'language': 'en',
                'format': 'json',
                'limit': 3,
                'type': 'item'
            }

            headers = self._get_headers()
            async with session.get(search_url, params=search_params, timeout=15, headers=headers) as response:
                if response.status != 200:
                    return data

                result = await response.json()
                if not result or not result.get('search'):
                    return data

                # Find best match (prefer universities)
                entity_id = None
                for item in result['search']:
                    desc = item.get('description', '').lower()
                    if 'university' in desc or 'college' in desc or 'institute' in desc:
                        entity_id = item['id']
                        break

                if not entity_id and result['search']:
                    entity_id = result['search'][0]['id']

                if not entity_id:
                    return data

                # Get entity details
                entity_params = {
                    'action': 'wbgetentities',
                    'ids': entity_id,
                    'format': 'json',
                    'props': 'claims|sitelinks',
                    'languages': 'en'
                }

                async with session.get(search_url, params=entity_params, timeout=15, headers=headers) as entity_response:
                    if entity_response.status != 200:
                        return data

                    entity_data = await entity_response.json()
                    if not entity_data or not entity_data.get('entities'):
                        return data

                    entity = entity_data['entities'].get(entity_id, {})
                    claims = entity.get('claims', {})

                    # P856 = official website
                    if 'P856' in claims:
                        website_claim = claims['P856'][0]
                        if 'mainsnak' in website_claim and 'datavalue' in website_claim['mainsnak']:
                            data['website'] = website_claim['mainsnak']['datavalue']['value']

                    # P131 = located in administrative territory (city/state)
                    if 'P131' in claims:
                        loc_claim = claims['P131'][0]
                        if 'mainsnak' in loc_claim and 'datavalue' in loc_claim['mainsnak']:
                            loc_id = loc_claim['mainsnak']['datavalue']['value'].get('id')
                            if loc_id:
                                # Get location name
                                loc_name = await self._get_wikidata_label(loc_id, session)
                                if loc_name:
                                    data['city'] = loc_name

                    # P625 = coordinates (can determine urban/rural)
                    if 'P625' in claims:
                        coord_claim = claims['P625'][0]
                        if 'mainsnak' in coord_claim and 'datavalue' in coord_claim['mainsnak']:
                            coords = coord_claim['mainsnak']['datavalue']['value']
                            # Just having coordinates suggests established institution
                            data['_has_coords'] = True

                    # P154 = logo image
                    if 'P154' in claims:
                        logo_claim = claims['P154'][0]
                        if 'mainsnak' in logo_claim and 'datavalue' in logo_claim['mainsnak']:
                            logo_name = logo_claim['mainsnak']['datavalue']['value']
                            data['logo_url'] = f"https://commons.wikimedia.org/wiki/Special:FilePath/{logo_name}"

                    # P31 = instance of (determine type)
                    if 'P31' in claims:
                        for type_claim in claims['P31']:
                            if 'mainsnak' in type_claim and 'datavalue' in type_claim['mainsnak']:
                                type_id = type_claim['mainsnak']['datavalue']['value'].get('id')
                                if type_id in ['Q3918', 'Q902104']:  # university, private university
                                    data['university_type'] = 'Private'
                                elif type_id in ['Q875538', 'Q62078547']:  # public university
                                    data['university_type'] = 'Public'

            logger.info(f"Found {len(data)} fields from Wikidata for {university_name}")

        except Exception as e:
            logger.debug(f"Wikidata search failed for {university_name}: {e}")

        return data

    async def _get_wikidata_label(self, entity_id: str, session: aiohttp.ClientSession) -> Optional[str]:
        """Get label for a Wikidata entity"""
        try:
            url = "https://www.wikidata.org/w/api.php"
            params = {
                'action': 'wbgetentities',
                'ids': entity_id,
                'format': 'json',
                'props': 'labels',
                'languages': 'en'
            }
            headers = self._get_headers()
            async with session.get(url, params=params, timeout=10, headers=headers) as response:
                if response.status == 200:
                    data = await response.json()
                    if data and 'entities' in data:
                        entity = data['entities'].get(entity_id, {})
                        labels = entity.get('labels', {})
                        if 'en' in labels:
                            return labels['en']['value']
        except:
            pass
        return None

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

            headers = self._get_headers()

            # Search Wikipedia API
            search_url = "https://en.wikipedia.org/w/api.php"
            search_params = {
                'action': 'query',
                'list': 'search',
                'srsearch': f'{university_name} university',
                'format': 'json',
                'srlimit': 5
            }

            async with session.get(search_url, params=search_params, timeout=15, headers=headers) as response:
                if response.status != 200:
                    return data

                search_results = await response.json()
                if not search_results:
                    return data

                query = search_results.get('query')
                if not query or not query.get('search'):
                    return data

                # Find best match
                page_title = None
                for result in query['search']:
                    title_lower = result['title'].lower()
                    if 'university' in title_lower or 'college' in title_lower or 'institute' in title_lower:
                        page_title = result['title']
                        break

                if not page_title:
                    page_title = query['search'][0]['title']

                # Get page content with infobox data
                content_params = {
                    'action': 'query',
                    'titles': page_title,
                    'prop': 'extracts|pageimages|revisions|info',
                    'exintro': '1',
                    'explaintext': '1',
                    'piprop': 'original',
                    'inprop': 'url',
                    'rvprop': 'content',
                    'rvslots': 'main',
                    'format': 'json'
                }

                async with session.get(search_url, params=content_params, timeout=15, headers=headers) as content_response:
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

                    # Extract from intro text
                    if 'extract' in page:
                        extract = page['extract']
                        data['description'] = extract[:500] if len(extract) > 500 else extract

                        # Enhanced location extraction
                        location_patterns = [
                            r'located in ([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),?\s*([A-Z][a-z]+(?:\s[A-Z][a-z]+)*)?',
                            r'in ([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),\s*([A-Z]{2})',
                            r'([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),\s*([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),?\s*(?:United States|USA|U\.S\.)',
                        ]
                        for pattern in location_patterns:
                            match = re.search(pattern, extract)
                            if match:
                                data['city'] = match.group(1)
                                if match.lastindex >= 2 and match.group(2):
                                    state_val = match.group(2)
                                    if len(state_val) == 2:
                                        data['state'] = state_val
                                break

                        # Student count extraction
                        student_patterns = [
                            r'(\d{1,3}(?:,\d{3})*)\s+(?:total\s+)?students',
                            r'enrollment\s+(?:of\s+)?(\d{1,3}(?:,\d{3})*)',
                            r'(\d{1,3}(?:,\d{3})*)\s+(?:undergraduate|graduate)',
                        ]
                        for pattern in student_patterns:
                            match = re.search(pattern, extract, re.IGNORECASE)
                            if match:
                                students_str = match.group(1).replace(',', '')
                                data['total_students'] = int(students_str)
                                break

                        # University type
                        if 'public university' in extract.lower() or 'public research university' in extract.lower():
                            data['university_type'] = 'Public'
                        elif 'private university' in extract.lower() or 'private research university' in extract.lower():
                            data['university_type'] = 'Private'

                        # Location type
                        if 'urban' in extract.lower():
                            data['location_type'] = 'Urban'
                        elif 'suburban' in extract.lower():
                            data['location_type'] = 'Suburban'
                        elif 'rural' in extract.lower():
                            data['location_type'] = 'Rural'

                    # Try to get image
                    if 'original' in page.get('pageimage', {}):
                        data['logo_url'] = page['original']['source']

            logger.info(f"Found {len(data)} fields from Wikipedia for {university_name}")

        except Exception as e:
            logger.debug(f"Wikipedia search failed for {university_name}: {e}")

        return data

    @retry_async(max_attempts=2, initial_delay=2.0, max_delay=10.0)
    async def _search_duckduckgo_html_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Dict:
        """
        DuckDuckGo HTML scraping (more reliable than API which is often blocked)
        """
        data = {}

        try:
            await DUCKDUCKGO_RATE_LIMITER.acquire()

            # Use HTML search instead of API
            url = "https://html.duckduckgo.com/html/"
            form_data = {
                'q': f'{university_name} university official website',
                'b': ''
            }

            headers = self._get_headers()
            headers['Content-Type'] = 'application/x-www-form-urlencoded'

            async with session.post(url, data=form_data, timeout=15, headers=headers) as response:
                if response.status != 200:
                    return data

                html = await response.text()
                soup = BeautifulSoup(html, 'html.parser')

                # Find result links
                results = soup.find_all('a', class_='result__url')
                for result in results[:5]:
                    href = result.get('href', '')
                    text = result.get_text(strip=True)

                    # Look for .edu or educational domains
                    if '.edu' in href or '.ac.' in href:
                        # Clean up the URL
                        if href.startswith('//'):
                            href = 'https:' + href
                        elif not href.startswith('http'):
                            href = 'https://' + href

                        # Extract domain
                        from urllib.parse import urlparse
                        parsed = urlparse(href)
                        clean_url = f"{parsed.scheme}://{parsed.netloc}"
                        data['website'] = clean_url
                        break

                # Extract snippets for additional info
                snippets = soup.find_all('a', class_='result__snippet')
                for snippet in snippets[:3]:
                    text = snippet.get_text()

                    # Try to find acceptance rate
                    if not data.get('acceptance_rate'):
                        rate_match = re.search(r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%', text, re.IGNORECASE)
                        if rate_match:
                            data['acceptance_rate'] = float(rate_match.group(1)) / 100

                    # Try to find enrollment
                    if not data.get('total_students'):
                        enroll_match = re.search(r'(\d{1,3}(?:,\d{3})*)\s+students', text, re.IGNORECASE)
                        if enroll_match:
                            data['total_students'] = int(enroll_match.group(1).replace(',', ''))

            logger.info(f"Found {len(data)} fields from DuckDuckGo HTML for {university_name}")

        except Exception as e:
            logger.debug(f"DuckDuckGo HTML search failed for {university_name}: {e}")

        return data

    async def _guess_and_validate_website_async(
        self,
        university_name: str,
        country: str = None,
        session: aiohttp.ClientSession = None
    ) -> Optional[str]:
        """Async website guessing and validation"""

        # Clean university name
        name_clean = university_name.lower()
        name_clean = re.sub(r'\([^)]*\)', '', name_clean)  # Remove parentheses
        name_clean = name_clean.replace('university of', '').replace('the', '')
        name_clean = name_clean.replace('university', '').replace('college', '')
        name_parts = name_clean.strip().split()

        if not name_parts:
            return None

        # Common patterns
        patterns = []

        # Country-specific domains
        country_domains = {
            'US': 'edu', 'USA': 'edu', 'United States': 'edu',
            'GB': 'ac.uk', 'UK': 'ac.uk', 'United Kingdom': 'ac.uk',
            'CA': 'ca', 'Canada': 'ca',
            'AU': 'edu.au', 'Australia': 'edu.au',
            'NZ': 'ac.nz', 'New Zealand': 'ac.nz',
            'ZA': 'ac.za', 'South Africa': 'ac.za',
            'IN': 'ac.in', 'India': 'ac.in',
            'SG': 'edu.sg', 'Singapore': 'edu.sg',
            'DE': 'de', 'Germany': 'de',
            'FR': 'fr', 'France': 'fr',
            'JP': 'ac.jp', 'Japan': 'ac.jp',
            'KR': 'ac.kr', 'South Korea': 'ac.kr',
        }

        domain = country_domains.get(country, 'edu')

        # Pattern 1: firstword.domain
        patterns.append(f"https://www.{name_parts[0]}.{domain}")
        patterns.append(f"https://{name_parts[0]}.{domain}")

        # Pattern 2: abbreviation.domain
        if len(name_parts) > 1:
            abbrev = ''.join([word[0] for word in name_parts[:3] if word])
            if len(abbrev) >= 2:
                patterns.append(f"https://www.{abbrev}.{domain}")
                patterns.append(f"https://{abbrev}.{domain}")

        # Pattern 3: combined name
        if len(name_parts) <= 3:
            combined = ''.join(name_parts)
            patterns.append(f"https://www.{combined}.{domain}")

        # Pattern 4: hyphenated
        if len(name_parts) > 1:
            hyphenated = '-'.join(name_parts[:2])
            patterns.append(f"https://www.{hyphenated}.{domain}")

        headers = self._get_headers()

        # Try each pattern concurrently
        async def try_pattern(pattern):
            try:
                async with session.head(pattern, timeout=8, allow_redirects=True, headers=headers) as response:
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
        """Async university website scraping with enhanced extraction"""
        data = {}

        try:
            headers = self._get_headers()
            async with session.get(website, timeout=15, headers=headers) as response:
                if response.status != 200:
                    return data

                html = await response.text()
                soup = BeautifulSoup(html, 'html.parser')

                # Try to find logo (multiple strategies)
                logo_selectors = [
                    ('link', {'rel': 'icon'}),
                    ('link', {'rel': 'shortcut icon'}),
                    ('link', {'rel': 'apple-touch-icon'}),
                    ('img', {'class': re.compile(r'logo', re.I)}),
                    ('img', {'alt': re.compile(r'logo', re.I)}),
                ]
                for tag, attrs in logo_selectors:
                    element = soup.find(tag, attrs)
                    if element:
                        href = element.get('href') or element.get('src')
                        if href:
                            if href.startswith('http'):
                                data['logo_url'] = href
                            elif href.startswith('//'):
                                data['logo_url'] = 'https:' + href
                            elif href.startswith('/'):
                                from urllib.parse import urljoin
                                data['logo_url'] = urljoin(website, href)
                            break

                # Get full page text
                text = soup.get_text()
                text_lower = text.lower()

                # Try to find address/location
                address_patterns = [
                    r',\s*([A-Z]{2})\s*\d{5}',  # State + ZIP
                    r'([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),\s*([A-Z]{2})\s*\d{5}',  # City, State ZIP
                ]
                for pattern in address_patterns:
                    match = re.search(pattern, text)
                    if match:
                        if match.lastindex >= 2:
                            data['city'] = match.group(1)
                            data['state'] = match.group(2)
                        else:
                            data['state'] = match.group(1)
                        break

                # Try to find acceptance rate
                acceptance_patterns = [
                    r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%',
                    r'(\d+(?:\.\d+)?)\s*%\s+acceptance',
                    r'admit[s]?\s+(\d+(?:\.\d+)?)\s*%',
                ]
                for pattern in acceptance_patterns:
                    match = re.search(pattern, text_lower)
                    if match:
                        rate = float(match.group(1)) / 100
                        if 0.01 <= rate <= 1.0:  # Sanity check
                            data['acceptance_rate'] = rate
                            break

                # Look for student enrollment
                enrollment_patterns = [
                    r'enrollment[:\s]+(\d{1,3}(?:,\d{3})*)',
                    r'(\d{1,3}(?:,\d{3})*)\s+(?:total\s+)?students',
                    r'student\s+(?:body|population)[:\s]+(\d{1,3}(?:,\d{3})*)',
                ]
                for pattern in enrollment_patterns:
                    match = re.search(pattern, text_lower)
                    if match:
                        students = int(match.group(1).replace(',', ''))
                        if 100 <= students <= 500000:  # Sanity check
                            data['total_students'] = students
                            break

                # Look for tuition
                tuition_patterns = [
                    r'tuition[:\s]+\$\s*(\d{1,3}(?:,\d{3})*)',
                    r'\$\s*(\d{1,3}(?:,\d{3})*)\s*(?:per\s+year|/year|annually)',
                ]
                for pattern in tuition_patterns:
                    match = re.search(pattern, text_lower)
                    if match:
                        tuition = int(match.group(1).replace(',', ''))
                        if 1000 <= tuition <= 100000:  # Sanity check
                            data['tuition_out_state'] = float(tuition)
                            break

            logger.info(f"Scraped {len(data)} fields from {website}")

        except Exception as e:
            logger.debug(f"Failed to scrape {website}: {e}")

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
