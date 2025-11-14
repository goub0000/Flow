"""
Async College Scorecard Enricher
Uses official U.S. Department of Education API for authoritative university data
Priority source for U.S. universities before web scraping
"""
import aiohttp
import asyncio
import logging
import os
from typing import Dict, Optional, List
from dotenv import load_dotenv

from app.utils.retry import (
    retry_async,
    COLLEGE_SCORECARD_RATE_LIMITER,
)

load_dotenv()
logger = logging.getLogger(__name__)


class AsyncCollegeScorecardEnricher:
    """
    Async enricher using College Scorecard API for U.S. universities

    Benefits:
    - Official government data (high accuracy)
    - Covers 7,000+ U.S. institutions
    - Free API with 1,000 requests/hour
    - More reliable than web scraping
    """

    BASE_URL = "https://api.data.gov/ed/collegescorecard/v1/schools"

    # Field mappings from College Scorecard to our schema
    SCORECARD_FIELDS = [
        'id',
        'school.name',
        'school.city',
        'school.state',
        'school.school_url',
        'school.locale',
        'school.ownership',
        'latest.student.size',
        'latest.admissions.admission_rate.overall',
        'latest.admissions.sat_scores.average.overall',
        'latest.admissions.sat_scores.25th_percentile.math',
        'latest.admissions.sat_scores.75th_percentile.math',
        'latest.admissions.sat_scores.25th_percentile.critical_reading',
        'latest.admissions.sat_scores.75th_percentile.critical_reading',
        'latest.admissions.act_scores.25th_percentile.cumulative',
        'latest.admissions.act_scores.75th_percentile.cumulative',
        'latest.cost.tuition.out_of_state',
        'latest.cost.attendance.academic_year',
        'latest.completion.completion_rate_4yr_150nt',
        'latest.earnings.10_yrs_after_entry.median',
    ]

    def __init__(self, api_key: Optional[str] = None):
        """
        Initialize async College Scorecard enricher

        Args:
            api_key: College Scorecard API key (from env if not provided)
        """
        self.api_key = api_key or os.getenv('COLLEGE_SCORECARD_API_KEY')

        if not self.api_key:
            logger.warning(
                "College Scorecard API key not found. "
                "Get free key at: https://api.data.gov/signup/"
            )

    @retry_async(max_attempts=3, initial_delay=1.0, max_delay=10.0)
    async def search_university_async(
        self,
        university_name: str,
        state: Optional[str] = None,
        session: Optional[aiohttp.ClientSession] = None
    ) -> Optional[Dict]:
        """
        Search College Scorecard for university by name
        WITH RETRY LOGIC AND RATE LIMITING

        Args:
            university_name: University name to search
            state: Optional state filter (e.g., 'CA', 'NY')
            session: Optional aiohttp session

        Returns:
            Best matching university data or None
        """
        if not self.api_key:
            logger.debug("Skipping College Scorecard (no API key)")
            return None

        try:
            # Rate limiting - wait for token before making request
            await COLLEGE_SCORECARD_RATE_LIMITER.acquire()
            params = {
                'school.name': university_name,
                'api_key': self.api_key,
                'fields': ','.join(self.SCORECARD_FIELDS),
                'per_page': 5,  # Get top 5 matches
            }

            # Add state filter if provided
            if state:
                params['school.state'] = state

            # Filter for quality institutions
            params.update({
                'school.degrees_awarded.predominant': '3',  # Bachelor's degree
                'school.operating': '1',  # Currently operating
            })

            close_session = False
            if not session:
                session = aiohttp.ClientSession()
                close_session = True

            try:
                async with session.get(
                    self.BASE_URL,
                    params=params,
                    timeout=aiohttp.ClientTimeout(total=10)
                ) as response:
                    if response.status == 200:
                        data = await response.json()
                        results = data.get('results', [])

                        if results:
                            # Return best match (first result is most relevant)
                            logger.info(
                                f"Found College Scorecard data for {university_name}"
                            )
                            return results[0]
                        else:
                            logger.debug(
                                f"No College Scorecard match for {university_name}"
                            )
                    else:
                        logger.warning(
                            f"College Scorecard API error: {response.status}"
                        )
            finally:
                if close_session:
                    await session.close()

        except asyncio.TimeoutError:
            logger.warning(f"College Scorecard timeout for {university_name}")
        except Exception as e:
            logger.warning(f"College Scorecard error for {university_name}: {e}")

        return None

    def extract_enrichment_data(self, scorecard_data: Dict) -> Dict:
        """
        Extract enrichment fields from College Scorecard response

        Args:
            scorecard_data: Raw College Scorecard API response

        Returns:
            Dictionary of enriched fields
        """
        enriched = {}

        try:
            # Location data
            if scorecard_data.get('school.city'):
                enriched['city'] = scorecard_data['school.city']

            if scorecard_data.get('school.state'):
                enriched['state'] = scorecard_data['school.state']

            # Website
            if scorecard_data.get('school.school_url'):
                url = scorecard_data['school.school_url']
                # Ensure URL has protocol
                if not url.startswith(('http://', 'https://')):
                    url = f"https://{url}"
                enriched['website'] = url

            # Location type (Urban/Suburban/Rural)
            locale_code = scorecard_data.get('school.locale')
            if locale_code:
                enriched['location_type'] = self._map_locale_to_type(locale_code)

            # University type (Public/Private)
            ownership = scorecard_data.get('school.ownership')
            if ownership:
                enriched['university_type'] = self._map_ownership_to_type(ownership)

            # Student enrollment
            students = scorecard_data.get('latest.student.size')
            if students:
                enriched['total_students'] = int(students)

            # Acceptance rate
            acceptance = scorecard_data.get('latest.admissions.admission_rate.overall')
            if acceptance is not None:
                enriched['acceptance_rate'] = float(acceptance)

            # SAT scores
            sat_math_25 = scorecard_data.get('latest.admissions.sat_scores.25th_percentile.math')
            if sat_math_25:
                enriched['sat_math_25th'] = int(sat_math_25)

            sat_math_75 = scorecard_data.get('latest.admissions.sat_scores.75th_percentile.math')
            if sat_math_75:
                enriched['sat_math_75th'] = int(sat_math_75)

            sat_reading_25 = scorecard_data.get('latest.admissions.sat_scores.25th_percentile.critical_reading')
            if sat_reading_25:
                enriched['sat_ebrw_25th'] = int(sat_reading_25)

            sat_reading_75 = scorecard_data.get('latest.admissions.sat_scores.75th_percentile.critical_reading')
            if sat_reading_75:
                enriched['sat_ebrw_75th'] = int(sat_reading_75)

            # ACT scores
            act_25 = scorecard_data.get('latest.admissions.act_scores.25th_percentile.cumulative')
            if act_25:
                enriched['act_composite_25th'] = int(act_25)

            act_75 = scorecard_data.get('latest.admissions.act_scores.75th_percentile.cumulative')
            if act_75:
                enriched['act_composite_75th'] = int(act_75)

            # Tuition and costs
            tuition = scorecard_data.get('latest.cost.tuition.out_of_state')
            if tuition:
                enriched['tuition_out_state'] = float(tuition)

            total_cost = scorecard_data.get('latest.cost.attendance.academic_year')
            if total_cost:
                enriched['total_cost'] = float(total_cost)

            # Graduation rate
            grad_rate = scorecard_data.get('latest.completion.completion_rate_4yr_150nt')
            if grad_rate is not None:
                enriched['graduation_rate_4year'] = float(grad_rate)

            # Median earnings
            earnings = scorecard_data.get('latest.earnings.10_yrs_after_entry.median')
            if earnings:
                enriched['median_earnings_10year'] = float(earnings)

            logger.info(
                f"College Scorecard filled {len(enriched)} fields: "
                f"{', '.join(enriched.keys())}"
            )

        except Exception as e:
            logger.error(f"Error extracting College Scorecard data: {e}")

        return enriched

    async def enrich_university_async(
        self,
        university: Dict,
        session: Optional[aiohttp.ClientSession] = None
    ) -> Dict:
        """
        Enrich a U.S. university using College Scorecard API

        Args:
            university: University dict with name, state, country
            session: Optional aiohttp session

        Returns:
            Dictionary of enriched fields
        """
        # Only enrich U.S. universities
        if university.get('country') not in ['USA', 'United States', 'US', None]:
            logger.debug(
                f"Skipping College Scorecard for non-U.S. university: "
                f"{university.get('name')}"
            )
            return {}

        university_name = university.get('name')
        state = university.get('state')

        if not university_name:
            return {}

        # Search College Scorecard
        scorecard_data = await self.search_university_async(
            university_name,
            state=state,
            session=session
        )

        if not scorecard_data:
            return {}

        # Extract enrichment data
        return self.extract_enrichment_data(scorecard_data)

    @staticmethod
    def _map_locale_to_type(locale_code: int) -> str:
        """Map College Scorecard locale codes to location types"""
        code_str = str(locale_code)
        if code_str.startswith('1'):
            return "Urban"
        elif code_str.startswith('2'):
            return "Suburban"
        elif code_str.startswith('3') or code_str.startswith('4'):
            return "Rural"
        return "Unknown"

    @staticmethod
    def _map_ownership_to_type(ownership: int) -> str:
        """Map College Scorecard ownership codes to university types"""
        ownership_map = {
            1: "Public",
            2: "Private",
            3: "Private",  # For-profit still labeled as Private
        }
        return ownership_map.get(ownership, "Unknown")


if __name__ == "__main__":
    # Test the enricher
    import asyncio

    logging.basicConfig(level=logging.INFO)

    async def test():
        enricher = AsyncCollegeScorecardEnricher()

        # Test with a U.S. university
        test_uni = {
            'name': 'Stanford University',
            'country': 'USA',
            'state': 'CA'
        }

        print(f"\nTesting College Scorecard enrichment for: {test_uni['name']}")
        print("=" * 60)

        enriched = await enricher.enrich_university_async(test_uni)

        print(f"\nEnriched {len(enriched)} fields:")
        for field, value in enriched.items():
            print(f"  {field}: {value}")

    asyncio.run(test())
