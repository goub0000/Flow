"""
Data Enricher Service
Automatically fills missing university data by searching multiple online sources

Data Sources (in priority order):
1. Wikidata API - Structured data with high reliability
2. Wikipedia API - Text extraction from articles
3. Website validation - Test guessed URLs
4. DuckDuckGo Instant Answer API - Free search fallback
"""

import logging
import requests
import re
from typing import Dict, Optional, Any, List
from time import sleep
import random
from urllib.parse import urlparse, quote

logger = logging.getLogger(__name__)


class DataEnricher:
    """
    Enriches university data by searching multiple online sources with fallback mechanisms
    """

    def __init__(self, rate_limit_delay: float = 2.0, validate_websites: bool = True):
        self.rate_limit_delay = rate_limit_delay
        self.validate_websites = validate_websites
        self.stats = {
            'total_processed': 0,
            'city_filled': 0,
            'state_filled': 0,
            'website_filled': 0,
            'logo_filled': 0,
            'failed': 0,
            'wikidata_success': 0,
            'wikipedia_success': 0,
            'validation_success': 0,
            'search_fallback': 0
        }

        # HTTP session for reusing connections
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'FlowApp-UniversityEnricher/1.0 (Educational Project; Python/requests)'
        })

    def enrich_university(self, university: Dict[str, Any]) -> Dict[str, Any]:
        """
        Enrich a single university's data using multiple sources with fallback

        Args:
            university: Dictionary with university data

        Returns:
            Dictionary with enriched data (only fields that were filled)
        """
        self.stats['total_processed'] += 1
        enriched_data = {}

        name = university.get('name', '')
        country = university.get('country', '')

        if not name or not country:
            logger.warning(f"Skipping university with missing name or country")
            self.stats['failed'] += 1
            return enriched_data

        logger.debug(f"Enriching: {name} ({country})")

        try:
            # Strategy 1: Try Wikidata first (most structured and reliable)
            wikidata_result = self._search_wikidata(name, country)
            if wikidata_result:
                enriched_data.update(wikidata_result)
                self.stats['wikidata_success'] += 1
                logger.debug(f"  ✓ Wikidata: {list(wikidata_result.keys())}")

            # Strategy 2: Fall back to Wikipedia for missing data
            if not enriched_data.get('website') or not enriched_data.get('city'):
                wiki_data = self._search_wikipedia(name, country)
                if wiki_data:
                    # Only add data that's still missing
                    for key, value in wiki_data.items():
                        if not enriched_data.get(key) and value:
                            enriched_data[key] = value
                    self.stats['wikipedia_success'] += 1
                    logger.debug(f"  ✓ Wikipedia: {list(wiki_data.keys())}")

            # Strategy 3: Try guessing and validating website
            if not university.get('website') and not enriched_data.get('website'):
                website = self._guess_and_validate_website(name, country)
                if website:
                    enriched_data['website'] = website
                    self.stats['validation_success'] += 1
                    logger.debug(f"  ✓ Validated website: {website}")

            # Strategy 4: DuckDuckGo instant answer as last resort
            if not enriched_data.get('website'):
                ddg_data = self._search_duckduckgo(name, country)
                if ddg_data and ddg_data.get('website'):
                    enriched_data['website'] = ddg_data['website']
                    self.stats['search_fallback'] += 1
                    logger.debug(f"  ✓ DuckDuckGo: {ddg_data['website']}")

            # Update field statistics
            if not university.get('city') and enriched_data.get('city'):
                self.stats['city_filled'] += 1
            if not university.get('state') and enriched_data.get('state'):
                self.stats['state_filled'] += 1
            if not university.get('website') and enriched_data.get('website'):
                self.stats['website_filled'] += 1
            if not university.get('logo_url') and enriched_data.get('logo_url'):
                self.stats['logo_filled'] += 1

            # Rate limiting
            self.rate_limit()

        except Exception as e:
            logger.error(f"Failed to enrich {name}: {e}")
            self.stats['failed'] += 1

        return enriched_data

    def _search_wikidata(self, name: str, country: str) -> Dict[str, Any]:
        """
        Search Wikidata for structured university information

        Wikidata properties:
        - P856: official website
        - P131: located in administrative territory
        - P625: coordinate location
        - P17: country
        - P154: logo image

        Returns dict with: website, city, state, logo_url
        """
        try:
            # Search for the entity
            search_url = "https://www.wikidata.org/w/api.php"
            search_params = {
                'action': 'wbsearchentities',
                'format': 'json',
                'language': 'en',
                'type': 'item',
                'search': f"{name} university {country}",
                'limit': 3
            }

            response = self.session.get(search_url, params=search_params, timeout=10)
            search_results = response.json()

            if not search_results.get('search'):
                return {}

            # Try the top results until we find university data
            for result in search_results['search']:
                entity_id = result['id']

                # Get entity data
                entity_params = {
                    'action': 'wbgetentities',
                    'format': 'json',
                    'ids': entity_id,
                    'props': 'claims|labels',
                    'languages': 'en'
                }

                entity_response = self.session.get(search_url, params=entity_params, timeout=10)
                entity_data = entity_response.json()

                if 'entities' not in entity_data or entity_id not in entity_data['entities']:
                    continue

                entity = entity_data['entities'][entity_id]
                claims = entity.get('claims', {})

                enriched = {}

                # Extract official website (P856)
                if 'P856' in claims and claims['P856']:
                    website = claims['P856'][0]['mainsnak'].get('datavalue', {}).get('value')
                    if website:
                        # Ensure proper URL format
                        if not website.startswith('http'):
                            website = f"https://{website}"
                        enriched['website'] = website

                # Extract location (P131 - located in administrative territory)
                if 'P131' in claims and claims['P131']:
                    location_id = claims['P131'][0]['mainsnak'].get('datavalue', {}).get('value', {}).get('id')
                    if location_id:
                        # Get location label
                        loc_response = self.session.get(search_url, params={
                            'action': 'wbgetentities',
                            'format': 'json',
                            'ids': location_id,
                            'props': 'labels',
                            'languages': 'en'
                        }, timeout=10)
                        loc_data = loc_response.json()
                        if location_id in loc_data.get('entities', {}):
                            city_label = loc_data['entities'][location_id].get('labels', {}).get('en', {}).get('value')
                            if city_label:
                                enriched['city'] = city_label

                # Extract logo (P154)
                if 'P154' in claims and claims['P154']:
                    logo_filename = claims['P154'][0]['mainsnak'].get('datavalue', {}).get('value')
                    if logo_filename:
                        # Construct Wikimedia Commons URL
                        logo_filename_safe = logo_filename.replace(' ', '_')
                        enriched['logo_url'] = f"https://commons.wikimedia.org/wiki/Special:FilePath/{logo_filename_safe}"

                # If we found useful data, return it
                if enriched:
                    logger.debug(f"Wikidata found: {enriched}")
                    return enriched

            return {}

        except Exception as e:
            logger.debug(f"Wikidata search failed: {e}")
            return {}

    def _guess_and_validate_website(self, name: str, country: str) -> Optional[str]:
        """
        Guess website URL and validate it actually works

        Returns validated website URL or None
        """
        if not self.validate_websites:
            return self._guess_website(name, country)

        # Generate candidate URLs
        candidates = self._generate_website_candidates(name, country)

        # Try each candidate
        for url in candidates:
            if self._validate_url(url):
                logger.debug(f"Validated URL: {url}")
                return url

        return None

    def _generate_website_candidates(self, name: str, country: str) -> List[str]:
        """Generate list of candidate website URLs"""
        # Clean university name
        clean_name = re.sub(r'[^\w\s]', '', name.lower())
        clean_name = clean_name.replace(' university', '').replace(' of ', '').strip()

        # Create URL-friendly version
        name_parts = clean_name.split()

        # Common variations
        variations = [
            ''.join(name_parts),  # universitylagos
            ''.join([p[0] for p in name_parts if p]),  # ul
            name_parts[0] if name_parts else clean_name,  # university
            '-'.join(name_parts),  # university-lagos
        ]

        # Get country TLD patterns
        country_tlds = {
            'US': ['.edu'],
            'GB': ['.ac.uk', '.edu'],
            'AU': ['.edu.au', '.edu'],
            'CA': ['.ca', '.edu'],
            'IN': ['.ac.in', '.edu.in', '.edu'],
            'NG': ['.edu.ng', '.edu'],
            'KE': ['.ac.ke', '.edu'],
            'GH': ['.edu.gh', '.edu'],
            'ZA': ['.ac.za', '.edu'],
            'BD': ['.edu.bd', '.edu'],
            'PK': ['.edu.pk', '.edu'],
            'EG': ['.edu.eg', '.edu'],
            'ET': ['.edu.et', '.edu'],
        }

        tlds = country_tlds.get(country, ['.edu', f'.edu.{country.lower()}'])

        # Generate all combinations
        candidates = []
        for variation in variations[:3]:  # Limit to top 3 variations
            for tld in tlds:
                candidates.append(f"https://www.{variation}{tld}")
                candidates.append(f"https://{variation}{tld}")

        return candidates[:10]  # Return top 10 candidates

    def _validate_url(self, url: str) -> bool:
        """Check if URL is accessible"""
        try:
            response = self.session.head(url, timeout=5, allow_redirects=True)
            return response.status_code < 400
        except:
            try:
                # Some servers don't support HEAD, try GET
                response = self.session.get(url, timeout=5, allow_redirects=True, stream=True)
                return response.status_code < 400
            except:
                return False

    def _search_duckduckgo(self, name: str, country: str) -> Dict[str, Any]:
        """
        Use DuckDuckGo Instant Answer API for website search
        Free API, no key required
        """
        try:
            query = f"{name} {country} university official website"
            ddg_url = "https://api.duckduckgo.com/"
            params = {
                'q': query,
                'format': 'json',
                'no_redirect': 1,
                'skip_disambig': 1
            }

            response = self.session.get(ddg_url, params=params, timeout=10)
            data = response.json()

            enriched = {}

            # Check for direct answer with URL
            if data.get('AbstractURL'):
                url = data['AbstractURL']
                if self._looks_like_university_site(url):
                    enriched['website'] = url

            # Check related topics
            if not enriched and data.get('RelatedTopics'):
                for topic in data['RelatedTopics'][:3]:
                    if isinstance(topic, dict) and topic.get('FirstURL'):
                        url = topic['FirstURL']
                        if self._looks_like_university_site(url):
                            enriched['website'] = url
                            break

            return enriched

        except Exception as e:
            logger.debug(f"DuckDuckGo search failed: {e}")
            return {}

    def _looks_like_university_site(self, url: str) -> bool:
        """Check if URL looks like an educational institution"""
        parsed = urlparse(url)
        domain = parsed.netloc.lower()

        # Check for educational TLDs
        edu_patterns = ['.edu', '.ac.', '.edu.']
        return any(pattern in domain for pattern in edu_patterns)

    def _search_wikipedia(self, name: str, country: str) -> Dict[str, Any]:
        """
        Search Wikipedia for university information

        Returns dict with: city, state, website, logo_url
        """
        try:
            # Wikipedia API search
            search_url = "https://en.wikipedia.org/w/api.php"
            search_params = {
                'action': 'query',
                'format': 'json',
                'list': 'search',
                'srsearch': f"{name} university {country}",
                'srlimit': 1
            }

            response = requests.get(search_url, params=search_params, timeout=10)
            search_results = response.json()

            if not search_results.get('query', {}).get('search'):
                return {}

            # Get page title
            page_title = search_results['query']['search'][0]['title']

            # Get page content
            content_params = {
                'action': 'query',
                'format': 'json',
                'titles': page_title,
                'prop': 'extracts|pageimages',
                'exintro': True,
                'explaintext': True,
                'piprop': 'thumbnail',
                'pithumbsize': 300
            }

            response = requests.get(search_url, params=content_params, timeout=10)
            content_data = response.json()

            pages = content_data.get('query', {}).get('pages', {})
            if not pages:
                return {}

            page_data = next(iter(pages.values()))
            extract = page_data.get('extract', '')

            enriched = {}

            # Extract city from text (usually mentioned early)
            city_match = re.search(r'(?:located in|based in|in)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*)', extract)
            if city_match:
                enriched['city'] = city_match.group(1).strip()

            # Extract state (for US universities)
            state_match = re.search(r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s+([A-Z]{2}|[A-Z][a-z]+)', extract)
            if state_match:
                enriched['state'] = state_match.group(2).strip()

            # Get logo/image
            if 'thumbnail' in page_data:
                enriched['logo_url'] = page_data['thumbnail'].get('source')

            logger.debug(f"Wikipedia enrichment: {enriched}")
            return enriched

        except Exception as e:
            logger.debug(f"Wikipedia search failed: {e}")
            return {}

    def _guess_website(self, name: str, country: str) -> Optional[str]:
        """
        Attempt to guess the university website URL

        Common patterns:
        - www.universityname.edu
        - www.universityname.ac.countrycode
        - www.universityname.edu.countrycode
        """
        # Clean university name
        clean_name = re.sub(r'[^\w\s]', '', name.lower())
        clean_name = clean_name.replace(' ', '')

        # Get country TLD
        country_tlds = {
            'US': '.edu',
            'GB': '.ac.uk',
            'AU': '.edu.au',
            'CA': '.ca',
            'IN': '.ac.in',
            'NG': '.edu.ng',
            'KE': '.ac.ke',
            'GH': '.edu.gh',
            'ZA': '.ac.za',
            'BD': '.edu.bd',
            'PK': '.edu.pk'
        }

        tld = country_tlds.get(country, f'.edu.{country.lower()}')

        # Try common patterns
        patterns = [
            f"www.{clean_name}{tld}",
            f"{clean_name}{tld}",
            f"www.{clean_name}.edu",
        ]

        # Just return the most likely pattern without verification
        # (verification would require actual HTTP requests which are slow)
        return f"https://{patterns[0]}"

    def rate_limit(self):
        """Apply rate limiting with random jitter"""
        jitter = random.uniform(0.8, 1.2)
        sleep(self.rate_limit_delay * jitter)

    def get_stats(self) -> Dict[str, int]:
        """Get enrichment statistics"""
        return self.stats.copy()

    def log_stats(self):
        """Log enrichment statistics"""
        stats = self.get_stats()
        logger.info("=" * 80)
        logger.info("DATA ENRICHMENT STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Total processed: {stats['total_processed']}")
        logger.info(f"")
        logger.info(f"Fields filled:")
        logger.info(f"  City:    {stats['city_filled']}")
        logger.info(f"  State:   {stats['state_filled']}")
        logger.info(f"  Website: {stats['website_filled']}")
        logger.info(f"  Logo:    {stats['logo_filled']}")
        logger.info(f"")
        logger.info(f"Data sources used:")
        logger.info(f"  Wikidata:          {stats['wikidata_success']}")
        logger.info(f"  Wikipedia:         {stats['wikipedia_success']}")
        logger.info(f"  URL validation:    {stats['validation_success']}")
        logger.info(f"  Search fallback:   {stats['search_fallback']}")
        logger.info(f"")
        logger.info(f"Failed: {stats['failed']}")

        # Calculate success rate
        if stats['total_processed'] > 0:
            success_rate = ((stats['total_processed'] - stats['failed']) / stats['total_processed']) * 100
            logger.info(f"Success rate: {success_rate:.1f}%")

        logger.info("=" * 80)


if __name__ == "__main__":
    # Test the enricher
    logging.basicConfig(level=logging.INFO)

    enricher = DataEnricher()

    test_uni = {
        'name': 'University of Lagos',
        'country': 'NG',
        'city': None,
        'state': None,
        'website': None
    }

    enriched = enricher.enrich_university(test_uni)
    print(f"\nEnriched data: {enriched}")
    enricher.log_stats()
