"""
Enhanced Data Enricher - Simplified and more reliable approach
Uses multiple strategies to achieve high success rate:

1. Scrape university's own website for location data
2. Use OpenStreetMap Nominatim geocoding (free, no API key)
3. Pattern-based extraction from text content
4. Website validation and guessing
"""

import logging
import requests
import re
from typing import Dict, Optional, Any
from time import sleep
import random
from urllib.parse import urlparse
from bs4 import BeautifulSoup

logger = logging.getLogger(__name__)


class EnhancedDataEnricher:
    """
    Enhanced enricher with focus on reliability and high success rate
    """

    def __init__(self, rate_limit_delay: float = 1.5):
        self.rate_limit_delay = rate_limit_delay
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept-Encoding': 'gzip, deflate',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1'
        })

        self.stats = {
            'total_processed': 0,
            'city_filled': 0,
            'state_filled': 0,
            'website_filled': 0,
            'website_scraped': 0,
            'geocoded': 0,
            'failed': 0
        }

    def enrich_university(self, university: Dict[str, Any]) -> Dict[str, Any]:
        """Enrich a single university's data"""
        self.stats['total_processed'] += 1
        enriched_data = {}

        name = university.get('name', '')
        country = university.get('country', '')
        website = university.get('website', '')

        if not name:
            logger.warning(f"Skipping university with missing name")
            self.stats['failed'] += 1
            return enriched_data

        try:
            # Strategy 1: If university has a website, scrape it for location data
            if website and (not university.get('city') or not university.get('state')):
                scraped_data = self._scrape_university_website(website, name)
                if scraped_data:
                    enriched_data.update(scraped_data)
                    self.stats['website_scraped'] += 1
                    logger.debug(f"  ✓ Scraped from website: {list(scraped_data.keys())}")

            # Strategy 2: Use geocoding API to find location
            if not enriched_data.get('city') and country:
                geocoded_data = self._geocode_university(name, country)
                if geocoded_data:
                    # Only add data that's still missing
                    for key, value in geocoded_data.items():
                        if not enriched_data.get(key) and value:
                            enriched_data[key] = value
                    self.stats['geocoded'] += 1
                    logger.debug(f"  ✓ Geocoded: {list(geocoded_data.keys())}")

            # Strategy 3: Guess and validate website if missing
            if not website:
                guessed_website = self._guess_and_validate_website(name, country)
                if guessed_website:
                    enriched_data['website'] = guessed_website
                    self.stats['website_filled'] += 1
                    logger.debug(f"  ✓ Found website: {guessed_website}")

            # Update field statistics
            if not university.get('city') and enriched_data.get('city'):
                self.stats['city_filled'] += 1
            if not university.get('state') and enriched_data.get('state'):
                self.stats['state_filled'] += 1

            # Rate limiting
            self.rate_limit()

        except Exception as e:
            logger.error(f"Failed to enrich {name}: {e}")
            self.stats['failed'] += 1

        return enriched_data

    def _scrape_university_website(self, url: str, uni_name: str) -> Dict[str, Any]:
        """Scrape university website for location/contact information"""
        try:
            # Try to fetch the homepage
            response = self.session.get(url, timeout=10, allow_redirects=True)
            if response.status_code >= 400:
                return {}

            soup = BeautifulSoup(response.text, 'html.parser')
            enriched = {}

            # Look for common patterns in text
            text = soup.get_text()

            # Extract city from common patterns
            # Pattern: "City, State" or "City, Country"
            city_patterns = [
                r'(?:located in|based in|in)\s+([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*([A-Z]{2,}|\w+)',
                r'Address:.*?([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*([A-Z]{2,})',
                r'([A-Z][a-z]+(?:\s+[A-Z][a-z]+)*),\s*([A-Z]{2}|[A-Z][a-z]+)\s*\d{5}',  # US zip code pattern
            ]

            for pattern in city_patterns:
                match = re.search(pattern, text[:5000])  # Only search first 5000 chars
                if match:
                    city = match.group(1).strip()
                    state_or_country = match.group(2).strip() if len(match.groups()) > 1 else None

                    # Verify it's a reasonable city name
                    if len(city) >= 3 and len(city) <= 30 and not any(char.isdigit() for char in city):
                        enriched['city'] = city
                        if state_or_country and len(state_or_country) <= 30:
                            enriched['state'] = state_or_country
                        break

            # Look in meta tags
            if not enriched.get('city'):
                # Check schema.org structured data
                address_tags = soup.find_all(attrs={'itemtype': 'http://schema.org/PostalAddress'})
                for tag in address_tags:
                    city_tag = tag.find(attrs={'itemprop': 'addressLocality'})
                    if city_tag:
                        enriched['city'] = city_tag.get_text().strip()

                    state_tag = tag.find(attrs={'itemprop': 'addressRegion'})
                    if state_tag:
                        enriched['state'] = state_tag.get_text().strip()

                    if enriched.get('city'):
                        break

            return enriched

        except Exception as e:
            logger.debug(f"Website scraping failed for {url}: {e}")
            return {}

    def _geocode_university(self, name: str, country: str) -> Dict[str, Any]:
        """
        Use OpenStreetMap Nominatim to geocode university location
        Free API, no key required, but rate limited to 1 request/second
        """
        try:
            # Nominatim search
            search_url = "https://nominatim.openstreetmap.org/search"
            params = {
                'q': f"{name} university {country}",
                'format': 'json',
                'limit': 1,
                'addressdetails': 1
            }

            response = self.session.get(search_url, params=params, timeout=10)
            if response.status_code != 200:
                return {}

            results = response.json()
            if not results:
                return {}

            result = results[0]
            address = result.get('address', {})

            enriched = {}

            # Extract city (try multiple fields)
            city = (address.get('city') or
                   address.get('town') or
                   address.get('village') or
                   address.get('municipality'))

            if city:
                enriched['city'] = city

            # Extract state/region
            state = (address.get('state') or
                    address.get('region') or
                    address.get('province'))

            if state:
                enriched['state'] = state

            return enriched

        except Exception as e:
            logger.debug(f"Geocoding failed for {name}: {e}")
            return {}

    def _guess_and_validate_website(self, name: str, country: str) -> Optional[str]:
        """Guess website URL and validate it works"""
        candidates = self._generate_website_candidates(name, country)

        for url in candidates:
            if self._validate_url(url):
                return url

        return None

    def _generate_website_candidates(self, name: str, country: str) -> list:
        """Generate list of candidate website URLs"""
        clean_name = re.sub(r'[^\w\s]', '', name.lower())
        clean_name = clean_name.replace(' university', '').replace(' of ', '').strip()
        name_parts = clean_name.split()

        variations = [
            ''.join(name_parts),
            ''.join([p[0] for p in name_parts if p]),
            name_parts[0] if name_parts else clean_name,
        ]

        country_tlds = {
            'US': ['.edu'],
            'GB': ['.ac.uk'],
            'AU': ['.edu.au'],
            'CA': ['.ca'],
            'IN': ['.ac.in', '.edu.in'],
            'NG': ['.edu.ng'],
            'KE': ['.ac.ke'],
            'GH': ['.edu.gh'],
            'ZA': ['.ac.za'],
            'PT': ['.pt'],
            'PE': ['.edu.pe'],
        }

        tlds = country_tlds.get(country, ['.edu'])

        candidates = []
        for variation in variations[:2]:
            for tld in tlds:
                candidates.append(f"https://www.{variation}{tld}")
                candidates.append(f"https://{variation}{tld}")

        return candidates[:8]

    def _validate_url(self, url: str) -> bool:
        """Check if URL is accessible"""
        try:
            response = self.session.head(url, timeout=5, allow_redirects=True)
            return response.status_code < 400
        except:
            return False

    def rate_limit(self):
        """Apply rate limiting"""
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
        logger.info(f"")
        logger.info(f"Data sources used:")
        logger.info(f"  Website scraped:   {stats['website_scraped']}")
        logger.info(f"  Geocoding API:     {stats['geocoded']}")
        logger.info(f"")
        logger.info(f"Failed: {stats['failed']}")

        if stats['total_processed'] > 0:
            success_rate = ((stats['total_processed'] - stats['failed']) / stats['total_processed']) * 100
            logger.info(f"Success rate: {success_rate:.1f}%")

        logger.info("=" * 80)
