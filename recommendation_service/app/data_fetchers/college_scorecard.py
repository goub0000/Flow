"""
College Scorecard API Fetcher
Fetches university data from US Department of Education's College Scorecard API
Free, official source with 7,000+ US institutions
API Docs: https://collegescorecard.ed.gov/data/api-documentation/

NOTE: An API key is REQUIRED for all requests.
Get your free API key at: https://api.data.gov/signup/
"""
import requests
import logging
import time
import os
from typing import List, Dict, Optional, Any
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

logger = logging.getLogger(__name__)


class CollegeScorecardFetcher:
    """
    Fetches university data from College Scorecard API

    IMPORTANT: An API key is REQUIRED for all requests.
    Get your free API key at: https://api.data.gov/signup/

    Rate limit: 1,000 requests per hour (default)
    """

    BASE_URL = "https://api.data.gov/ed/collegescorecard/v1/schools"

    # Field mappings from College Scorecard to our schema
    FIELD_MAPPINGS = {
        'id': 'id',
        'school.name': 'name',
        'school.city': 'city',
        'school.state': 'state',
        'school.school_url': 'website',
        'school.locale': 'locale',  # Urban/suburban/rural code
        'school.ownership': 'ownership',  # Public/private
        'latest.student.size': 'total_students',
        'latest.admissions.admission_rate.overall': 'acceptance_rate',
        'latest.admissions.sat_scores.average.overall': 'sat_average',
        'latest.admissions.sat_scores.midpoint.math': 'sat_math_midpoint',
        'latest.admissions.sat_scores.midpoint.critical_reading': 'sat_reading_midpoint',
        'latest.admissions.act_scores.midpoint.cumulative': 'act_composite_midpoint',
        'latest.cost.tuition.out_of_state': 'tuition_out_state',
        'latest.cost.attendance.academic_year': 'total_cost',
        'latest.completion.completion_rate_4yr_150nt': 'graduation_rate_4year',
        'latest.earnings.10_yrs_after_entry.median': 'median_earnings_10year',
        'latest.academics.program_percentage.business_marketing': 'business_pct',
        'latest.academics.program_percentage.computer': 'cs_pct',
        'latest.academics.program_percentage.engineering': 'engineering_pct',
    }

    def __init__(self, api_key: Optional[str] = None, rate_limit_delay: float = 0.1):
        """
        Initialize fetcher

        Args:
            api_key: API key for College Scorecard. If not provided, will try to load from
                    COLLEGE_SCORECARD_API_KEY environment variable.
            rate_limit_delay: Delay between requests in seconds

        Raises:
            ValueError: If no API key is provided or found in environment
        """
        # Try to get API key from parameter, then environment variable
        self.api_key = api_key or os.getenv('COLLEGE_SCORECARD_API_KEY')

        if not self.api_key:
            error_msg = (
                "\n" + "="*80 + "\n"
                "ERROR: College Scorecard API key is required but not found!\n"
                + "="*80 + "\n"
                "To fix this:\n"
                "1. Get a free API key at: https://api.data.gov/signup/\n"
                "2. Create a .env file in the recommendation_service directory\n"
                "3. Add this line to .env: COLLEGE_SCORECARD_API_KEY=your_api_key_here\n"
                "4. Or pass api_key parameter when creating the fetcher\n"
                + "="*80 + "\n"
            )
            logger.error(error_msg)
            raise ValueError(error_msg)

        self.rate_limit_delay = rate_limit_delay
        self.session = requests.Session()
        logger.info("College Scorecard API fetcher initialized with API key")

    def fetch_universities(
        self,
        page: int = 0,
        per_page: int = 100,
        filters: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Fetch universities from College Scorecard API

        Args:
            page: Page number (0-indexed)
            per_page: Results per page (max 100)
            filters: Additional filters (e.g., {'school.state': 'CA'})

        Returns:
            Dict with 'results' and 'metadata' keys
        """
        # Build query parameters
        params = {
            'page': page,
            'per_page': min(per_page, 100),
            'fields': ','.join(self.FIELD_MAPPINGS.keys()),
        }

        # Add API key if provided
        if self.api_key:
            params['api_key'] = self.api_key

        # Add filters
        if filters:
            params.update(filters)

        # Default filters for quality data
        # Only include: 4-year institutions, currently operating, mainly undergrad
        params.update({
            'school.degrees_awarded.predominant': '3',  # Predominantly bachelor's
            'school.operating': '1',  # Currently operating
            'latest.student.size__range': '100..',  # At least 100 students
        })

        try:
            logger.info(f"Fetching page {page} (up to {per_page} results)")
            response = self.session.get(self.BASE_URL, params=params, timeout=30)
            response.raise_for_status()

            data = response.json()

            # Rate limiting
            time.sleep(self.rate_limit_delay)

            return {
                'results': data.get('results', []),
                'metadata': data.get('metadata', {}),
                'total': data.get('metadata', {}).get('total', 0),
                'page': data.get('metadata', {}).get('page', 0),
                'per_page': data.get('metadata', {}).get('per_page', 0),
            }

        except requests.exceptions.RequestException as e:
            logger.error(f"Error fetching from College Scorecard API: {e}")
            return {'results': [], 'metadata': {}, 'total': 0}

    def fetch_all_universities(
        self,
        max_results: Optional[int] = None,
        filters: Optional[Dict[str, Any]] = None,
        batch_callback: Optional[callable] = None
    ) -> List[Dict[str, Any]]:
        """
        Fetch all universities (paginated)

        Args:
            max_results: Maximum number of results to fetch (None for all)
            filters: Additional filters
            batch_callback: Optional callback function called after each batch
                          Signature: callback(batch_data, total_fetched)

        Returns:
            List of university dictionaries
        """
        all_universities = []
        page = 0
        total_fetched = 0

        while True:
            # Check if we've reached max_results
            if max_results and total_fetched >= max_results:
                break

            # Fetch page
            data = self.fetch_universities(page=page, filters=filters)
            results = data['results']

            if not results:
                break

            all_universities.extend(results)
            total_fetched += len(results)

            logger.info(f"Fetched {len(results)} universities (total: {total_fetched}/{data['total']})")

            # Call batch callback if provided
            if batch_callback:
                batch_callback(results, total_fetched)

            # Check if there are more pages
            if len(results) < data.get('per_page', 100):
                break

            page += 1

        logger.info(f"Finished fetching {total_fetched} universities")
        return all_universities

    def fetch_by_state(self, state_code: str, max_results: Optional[int] = None) -> List[Dict[str, Any]]:
        """
        Fetch universities by state

        Args:
            state_code: Two-letter state code (e.g., 'CA', 'NY')
            max_results: Maximum number of results

        Returns:
            List of university dictionaries
        """
        filters = {'school.state': state_code}
        return self.fetch_all_universities(max_results=max_results, filters=filters)

    def search_by_name(self, name: str) -> List[Dict[str, Any]]:
        """
        Search universities by name

        Args:
            name: University name (partial match supported)

        Returns:
            List of matching universities
        """
        filters = {'school.name': name}
        data = self.fetch_universities(per_page=20, filters=filters)
        return data['results']

    @staticmethod
    def map_locale_to_location_type(locale_code: Optional[int]) -> str:
        """
        Map College Scorecard locale codes to our location types

        Locale codes:
        11-13: City (Large, Midsize, Small)
        21-23: Suburb (Large, Midsize, Small)
        31-33: Town (Fringe, Distant, Remote)
        41-43: Rural (Fringe, Distant, Remote)
        """
        if not locale_code:
            return "Unknown"

        code_str = str(locale_code)
        if code_str.startswith('1'):
            return "Urban"
        elif code_str.startswith('2'):
            return "Suburban"
        elif code_str.startswith('3') or code_str.startswith('4'):
            return "Rural"
        return "Unknown"

    @staticmethod
    def map_ownership_to_type(ownership: Optional[int]) -> str:
        """
        Map College Scorecard ownership codes to university types

        Ownership codes:
        1: Public
        2: Private nonprofit
        3: Private for-profit
        """
        ownership_map = {
            1: "Public",
            2: "Private",
            3: "Private",
        }
        return ownership_map.get(ownership, "Unknown")

    def normalize_university_data(self, raw_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Normalize College Scorecard data to our schema

        Args:
            raw_data: Raw data from College Scorecard API (with flat dot-notation keys)

        Returns:
            Normalized university dictionary
        """
        # API returns flat keys like "school.name", not nested objects
        normalized = {
            'name': raw_data.get('school.name'),
            'country': 'USA',
            'state': raw_data.get('school.state'),
            'city': raw_data.get('school.city'),
            'website': raw_data.get('school.school_url'),
            'description': f"{raw_data.get('school.name', 'University')} is a higher education institution located in {raw_data.get('school.city', '')}, {raw_data.get('school.state', '')}.",
            'university_type': self.map_ownership_to_type(raw_data.get('school.ownership')),
            'location_type': self.map_locale_to_location_type(raw_data.get('school.locale')),

            # Student body
            'total_students': raw_data.get('latest.student.size'),

            # Admissions
            'acceptance_rate': raw_data.get('latest.admissions.admission_rate.overall'),
            'gpa_average': None,  # Not available in College Scorecard
            'sat_math_25th': None,
            'sat_math_75th': raw_data.get('latest.admissions.sat_scores.midpoint.math'),
            'sat_ebrw_25th': None,
            'sat_ebrw_75th': raw_data.get('latest.admissions.sat_scores.midpoint.critical_reading'),
            'act_composite_25th': None,
            'act_composite_75th': raw_data.get('latest.admissions.act_scores.midpoint.cumulative'),

            # Financial
            'tuition_out_state': raw_data.get('latest.cost.tuition.out_of_state'),
            'total_cost': raw_data.get('latest.cost.attendance.academic_year'),

            # Outcomes
            'graduation_rate_4year': raw_data.get('latest.completion.completion_rate_4yr_150nt'),
            'median_earnings_10year': raw_data.get('latest.earnings.10_yrs_after_entry.median'),

            # Rankings (not available in College Scorecard, set to None)
            'global_rank': None,
            'national_rank': None,
        }

        # Remove None values for cleaner data
        return {k: v for k, v in normalized.items() if v is not None}


if __name__ == "__main__":
    # Example usage
    logging.basicConfig(level=logging.INFO)

    fetcher = CollegeScorecardFetcher()

    # Fetch first 10 universities
    print("Fetching universities from California...")
    universities = fetcher.fetch_by_state('CA', max_results=10)

    for uni in universities:
        normalized = fetcher.normalize_university_data(uni)
        print(f"\n{normalized.get('name')}")
        print(f"  Location: {normalized.get('city')}, {normalized.get('state')}")
        print(f"  Type: {normalized.get('university_type')} - {normalized.get('location_type')}")
        print(f"  Students: {normalized.get('total_students')}")
        print(f"  Acceptance Rate: {normalized.get('acceptance_rate', 'N/A')}")
