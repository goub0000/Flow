"""
Universities List API Fetcher
Fetches university data from the Hipolabs Universities API

API Documentation: http://universities.hipolabs.com/
Free API with 9,000+ universities globally

Example: http://universities.hipolabs.com/search?country=Canada
"""

import requests
import logging
from typing import List, Dict, Any, Optional
from time import sleep

logger = logging.getLogger(__name__)

class UniversitiesListAPIFetcher:
    """Fetches university data from Universities List API (Hipolabs)"""

    BASE_URL = "http://universities.hipolabs.com/search"

    # Target countries for comprehensive coverage
    TARGET_COUNTRIES = [
        # North America
        "Canada", "Mexico",

        # South America
        "Brazil", "Argentina", "Chile", "Colombia", "Peru",
        "Venezuela", "Ecuador", "Bolivia", "Paraguay", "Uruguay",

        # Europe (additional to QS)
        "France", "Germany", "Italy", "Spain", "Netherlands",
        "Sweden", "Switzerland", "Belgium", "Austria", "Portugal",
        "Poland", "Czech Republic", "Greece", "Denmark", "Norway",
        "Finland", "Ireland", "Hungary", "Romania",

        # Asia
        "China", "India", "Japan", "South Korea", "Indonesia",
        "Thailand", "Vietnam", "Philippines", "Malaysia", "Singapore",
        "Pakistan", "Bangladesh", "Iran", "Turkey", "Saudi Arabia",
        "United Arab Emirates", "Israel", "Kazakhstan", "Uzbekistan",

        # Africa
        "South Africa", "Egypt", "Nigeria", "Kenya", "Ghana",
        "Ethiopia", "Tanzania", "Uganda", "Morocco", "Algeria",
        "Tunisia", "Senegal", "Cameroon", "Zimbabwe", "Zambia",

        # Oceania
        "Australia", "New Zealand", "Fiji", "Papua New Guinea"
    ]

    def __init__(self, rate_limit_delay: float = 0.5):
        """
        Initialize the Universities List API fetcher

        Args:
            rate_limit_delay: Delay between API requests in seconds (default 0.5)
        """
        self.rate_limit_delay = rate_limit_delay
        logger.info("Initialized Universities List API fetcher")

    def fetch_universities_by_country(self, country: str) -> List[Dict[str, Any]]:
        """
        Fetch universities for a specific country

        Args:
            country: Country name (e.g., "Canada", "Brazil")

        Returns:
            List of university dictionaries with structure:
            {
                'name': str,
                'country': str,
                'alpha_two_code': str,
                'state-province': Optional[str],
                'domains': List[str],
                'web_pages': List[str]
            }
        """
        try:
            logger.info(f"Fetching universities for {country}...")

            params = {'country': country}
            response = requests.get(self.BASE_URL, params=params, timeout=30)
            response.raise_for_status()

            universities = response.json()
            logger.info(f"✓ Found {len(universities)} universities in {country}")

            # Rate limiting
            sleep(self.rate_limit_delay)

            return universities

        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to fetch universities for {country}: {e}")
            return []
        except Exception as e:
            logger.error(f"Unexpected error fetching universities for {country}: {e}")
            return []

    def fetch_all_target_countries(self) -> List[Dict[str, Any]]:
        """
        Fetch universities from all target countries

        Returns:
            List of all universities from target countries
        """
        all_universities = []

        logger.info(f"Fetching universities from {len(self.TARGET_COUNTRIES)} countries...")
        logger.info("=" * 80)

        for country in self.TARGET_COUNTRIES:
            universities = self.fetch_universities_by_country(country)
            all_universities.extend(universities)
            logger.info(f"Total collected so far: {len(all_universities)}")

        logger.info("=" * 80)
        logger.info(f"✓ Fetched {len(all_universities)} universities from {len(self.TARGET_COUNTRIES)} countries")

        return all_universities

    def normalize_university_data(self, uni_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Normalize Universities List API data to match Supabase schema

        Args:
            uni_data: Raw university data from API

        Returns:
            Normalized dictionary ready for Supabase
        """
        # Extract state/province if available
        state_province = uni_data.get('state-province')

        # Get website (first web page)
        website = uni_data.get('web_pages', [None])[0]

        # Get domain (first domain)
        domain = uni_data.get('domains', [None])[0]

        # Get ISO alpha-2 country code
        country_code = uni_data.get('alpha_two_code', '').strip()
        country_name = uni_data.get('country', '').strip()

        normalized = {
            'name': uni_data.get('name', '').strip(),
            'country': country_code,  # Use ISO alpha-2 code
            'state': state_province,
            'website': website,
            # Store domain and country name in description
            'description': f"{uni_data.get('name', '')} is a higher education institution in {country_name}. Domain: {domain}",
        }

        # Remove None values
        return {k: v for k, v in normalized.items() if v is not None and v != ''}

    def fetch_and_normalize_all(self) -> List[Dict[str, Any]]:
        """
        Fetch universities from all target countries and normalize them

        Returns:
            List of normalized university dictionaries
        """
        logger.info("Fetching and normalizing universities from Universities List API...")

        # Fetch raw data
        raw_universities = self.fetch_all_target_countries()

        # Normalize data
        normalized_universities = []
        for uni in raw_universities:
            try:
                normalized = self.normalize_university_data(uni)
                if normalized and normalized.get('name'):
                    normalized_universities.append(normalized)
            except Exception as e:
                logger.warning(f"Error normalizing university {uni.get('name', 'Unknown')}: {e}")
                continue

        logger.info(f"✓ Normalized {len(normalized_universities)} universities")

        return normalized_universities


def main():
    """Test the Universities List API fetcher"""
    print("Testing Universities List API Fetcher")
    print("=" * 80)

    fetcher = UniversitiesListAPIFetcher()

    # Test with a few countries
    test_countries = ["Canada", "Brazil", "South Africa", "India"]

    for country in test_countries:
        print(f"\nFetching {country}...")
        universities = fetcher.fetch_universities_by_country(country)
        print(f"Found {len(universities)} universities")

        if universities:
            print(f"\nSample university from {country}:")
            sample = universities[0]
            print(f"  Name: {sample.get('name')}")
            print(f"  Country: {sample.get('country')}")
            print(f"  Website: {sample.get('web_pages', ['N/A'])[0]}")
            print(f"  Domain: {sample.get('domains', ['N/A'])[0]}")

            # Test normalization
            normalized = fetcher.normalize_university_data(sample)
            print(f"\nNormalized:")
            for key, value in normalized.items():
                print(f"  {key}: {value}")


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()
