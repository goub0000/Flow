"""
Async Field-Specific Web Scrapers
High-performance async version for targeted field extraction
"""
import aiohttp
import asyncio
import logging
from typing import Dict, Optional
from bs4 import BeautifulSoup
import re

logger = logging.getLogger(__name__)


class AsyncFieldScrapers:
    """
    Async specialized scrapers for specific university data fields
    Uses aiohttp for concurrent requests
    """

    def __init__(self):
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        }

    async def find_acceptance_rate_async(
        self,
        university_name: str,
        website: str = None,
        session: aiohttp.ClientSession = None
    ) -> Optional[float]:
        """
        Async find acceptance rate from multiple sources

        Returns:
            Acceptance rate as decimal (0.0-1.0) or None
        """
        try:
            # Strategy 1: Web search
            search_query = f"{university_name} acceptance rate"
            rate = await self._web_search_extract_async(
                search_query,
                r'(\d+(?:\.\d+)?)\s*%',
                session
            )

            if rate:
                return float(rate) / 100

            # Strategy 2: Check university website
            if website:
                rate = await self._scrape_admissions_page_async(website, session)
                if rate:
                    return rate

        except Exception as e:
            logger.warning(f"Failed to find acceptance rate for {university_name}: {e}")

        return None

    async def find_tuition_costs_async(
        self,
        university_name: str,
        website: str = None,
        session: aiohttp.ClientSession = None
    ) -> Dict[str, Optional[float]]:
        """
        Async find tuition and cost information

        Returns:
            Dict with tuition_out_state, total_cost
        """
        costs = {'tuition_out_state': None, 'total_cost': None}

        try:
            # Strategy 1: Search for tuition
            search_query = f"{university_name} tuition cost"
            text = await self._web_search_async(search_query, session)

            if text:
                tuition_match = re.search(r'\$\s*(\d{1,3}(?:,\d{3})*)', text)
                if tuition_match:
                    amount = int(tuition_match.group(1).replace(',', ''))
                    costs['tuition_out_state'] = float(amount)
                    costs['total_cost'] = float(amount * 1.5)

            # Strategy 2: Check tuition page on website
            if website:
                site_costs = await self._scrape_tuition_page_async(website, session)
                costs.update(site_costs)

        except Exception as e:
            logger.warning(f"Failed to find costs for {university_name}: {e}")

        return costs

    async def find_test_scores_async(
        self,
        university_name: str,
        website: str = None,
        session: aiohttp.ClientSession = None
    ) -> Dict[str, Optional[int]]:
        """
        Async find SAT/ACT score ranges

        Returns:
            Dict with SAT and ACT scores
        """
        scores = {
            'sat_math_25th': None, 'sat_math_75th': None,
            'sat_ebrw_25th': None, 'sat_ebrw_75th': None,
            'act_composite_25th': None, 'act_composite_75th': None
        }

        try:
            search_query = f"{university_name} SAT ACT scores range"
            text = await self._web_search_async(search_query, session)

            if text:
                # SAT ranges
                sat_range = re.search(r'SAT.*?(\d{3,4})\s*-\s*(\d{3,4})', text, re.IGNORECASE)
                if sat_range:
                    low = int(sat_range.group(1))
                    high = int(sat_range.group(2))

                    # Estimate component scores (roughly 50/50 split)
                    scores['sat_math_25th'] = int(low * 0.5)
                    scores['sat_math_75th'] = int(high * 0.5)
                    scores['sat_ebrw_25th'] = int(low * 0.5)
                    scores['sat_ebrw_75th'] = int(high * 0.5)

                # ACT ranges
                act_range = re.search(r'ACT.*?(\d{1,2})\s*-\s*(\d{1,2})', text, re.IGNORECASE)
                if act_range:
                    scores['act_composite_25th'] = int(act_range.group(1))
                    scores['act_composite_75th'] = int(act_range.group(2))

        except Exception as e:
            logger.warning(f"Failed to find test scores for {university_name}: {e}")

        return scores

    async def find_graduation_rate_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[float]:
        """
        Async find 4-year graduation rate

        Returns:
            Graduation rate as decimal (0.0-1.0) or None
        """
        try:
            search_query = f"{university_name} 4 year graduation rate"
            rate = await self._web_search_extract_async(
                search_query,
                r'(\d+(?:\.\d+)?)\s*%',
                session
            )

            if rate:
                return float(rate) / 100

        except Exception as e:
            logger.warning(f"Failed to find graduation rate for {university_name}: {e}")

        return None

    async def find_student_count_async(
        self,
        university_name: str,
        website: str = None,
        session: aiohttp.ClientSession = None
    ) -> Optional[int]:
        """
        Async find total student enrollment

        Returns:
            Number of students or None
        """
        try:
            search_query = f"{university_name} total enrollment students"
            text = await self._web_search_async(search_query, session)

            if text:
                enrollment_match = re.search(r'(\d{1,3}(?:,\d{3})*)\s+students', text, re.IGNORECASE)
                if enrollment_match:
                    return int(enrollment_match.group(1).replace(',', ''))

        except Exception as e:
            logger.warning(f"Failed to find student count for {university_name}: {e}")

        return None

    async def find_location_details_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Dict[str, Optional[str]]:
        """
        Async find city, state, location type

        Returns:
            Dict with city, state, location_type
        """
        location = {'city': None, 'state': None, 'location_type': None}

        try:
            search_query = f"{university_name} location city state"
            text = await self._web_search_async(search_query, session)

            if text:
                # City, State pattern
                location_match = re.search(r'(?:located in|in)\s+([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),\s*([A-Z]{2})', text)
                if location_match:
                    location['city'] = location_match.group(1)
                    location['state'] = location_match.group(2)

                # Location type
                text_lower = text.lower()
                if any(word in text_lower for word in ['urban', 'city', 'metropolitan']):
                    location['location_type'] = 'Urban'
                elif any(word in text_lower for word in ['suburban', 'suburb']):
                    location['location_type'] = 'Suburban'
                elif any(word in text_lower for word in ['rural', 'countryside']):
                    location['location_type'] = 'Rural'

        except Exception as e:
            logger.warning(f"Failed to find location for {university_name}: {e}")

        return location

    async def find_university_type_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[str]:
        """
        Async find university type (Public/Private/For-profit)

        Returns:
            'Public', 'Private', or 'For-profit'
        """
        try:
            search_query = f"{university_name} public or private university"
            text = await self._web_search_async(search_query, session)

            if text:
                text_lower = text.lower()
                if 'private' in text_lower and 'for-profit' in text_lower:
                    return 'For-profit'
                elif 'private' in text_lower:
                    return 'Private'
                elif 'public' in text_lower:
                    return 'Public'

        except Exception as e:
            logger.warning(f"Failed to find university type for {university_name}: {e}")

        return None

    async def find_gpa_average_async(
        self,
        university_name: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[float]:
        """
        Async find average admitted student GPA

        Returns:
            GPA (0.0-4.0) or None
        """
        try:
            search_query = f"{university_name} average GPA admitted students"
            rate = await self._web_search_extract_async(
                search_query,
                r'GPA.*?(\d\.\d{1,2})',
                session
            )

            if rate:
                return float(rate)

        except Exception as e:
            logger.warning(f"Failed to find GPA average for {university_name}: {e}")

        return None

    # Helper methods

    async def _web_search_async(
        self,
        query: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[str]:
        """Async web search using DuckDuckGo HTML"""
        try:
            url = "https://html.duckduckgo.com/html/"
            data = {'q': query}

            async with session.post(url, data=data, timeout=10, headers=self.headers) as response:
                if response.status == 200:
                    html = await response.text()
                    soup = BeautifulSoup(html, 'html.parser')

                    # Extract snippet from first result
                    snippet = soup.find('a', class_='result__snippet')
                    if snippet:
                        return snippet.get_text()

        except Exception as e:
            logger.debug(f"Web search failed: {e}")

        return None

    async def _web_search_extract_async(
        self,
        query: str,
        pattern: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[str]:
        """Async search and extract using regex pattern"""
        text = await self._web_search_async(query, session)
        if text:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1)
        return None

    async def _scrape_admissions_page_async(
        self,
        website: str,
        session: aiohttp.ClientSession = None
    ) -> Optional[float]:
        """Async scrape university admissions page"""
        try:
            # Try common admissions URLs
            urls = [
                f"{website}/admissions",
                f"{website}/apply",
                f"{website}/undergraduate/admissions"
            ]

            async def try_url(url):
                try:
                    async with session.get(url, timeout=10, headers=self.headers) as response:
                        if response.status == 200:
                            text = await response.text()
                            match = re.search(r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%', text.lower())
                            if match:
                                return float(match.group(1)) / 100
                except:
                    pass
                return None

            tasks = [try_url(url) for url in urls]
            results = await asyncio.gather(*tasks, return_exceptions=True)

            for result in results:
                if result and isinstance(result, float):
                    return result

        except Exception as e:
            logger.debug(f"Failed to scrape admissions page: {e}")

        return None

    async def _scrape_tuition_page_async(
        self,
        website: str,
        session: aiohttp.ClientSession = None
    ) -> Dict[str, Optional[float]]:
        """Async scrape university tuition page"""
        costs = {}

        try:
            # Try common tuition URLs
            urls = [
                f"{website}/tuition",
                f"{website}/costs",
                f"{website}/financial-aid/costs"
            ]

            async def try_url(url):
                try:
                    async with session.get(url, timeout=10, headers=self.headers) as response:
                        if response.status == 200:
                            text = await response.text()

                            # Look for tuition amounts
                            tuition_matches = re.findall(r'\$\s*(\d{1,3}(?:,\d{3})*)', text)
                            if tuition_matches:
                                amounts = [int(m.replace(',', '')) for m in tuition_matches]
                                tuition_amounts = [a for a in amounts if 10000 <= a <= 80000]

                                if tuition_amounts:
                                    return {
                                        'tuition_out_state': float(max(tuition_amounts)),
                                        'total_cost': float(max(tuition_amounts) * 1.5)
                                    }
                except:
                    pass
                return {}

            tasks = [try_url(url) for url in urls]
            results = await asyncio.gather(*tasks, return_exceptions=True)

            for result in results:
                if isinstance(result, dict) and result:
                    costs.update(result)
                    break

        except Exception as e:
            logger.debug(f"Failed to scrape tuition page: {e}")

        return costs
