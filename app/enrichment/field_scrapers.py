"""
Field-Specific Web Scrapers
Targeted scrapers for specific university data fields
"""
import requests
import logging
from typing import Dict, Optional, List
from bs4 import BeautifulSoup
import re

logger = logging.getLogger(__name__)


class FieldSpecificScrapers:
    """
    Specialized scrapers for specific university data fields
    Uses multiple strategies per field type
    """

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

    def find_acceptance_rate(self, university_name: str, website: str = None) -> Optional[float]:
        """
        Find acceptance rate from multiple sources

        Returns:
            Acceptance rate as decimal (0.0-1.0) or None
        """
        try:
            # Strategy 1: Search "university name acceptance rate"
            search_query = f"{university_name} acceptance rate"
            rate = self._google_search_extract(search_query, r'(\d+(?:\.\d+)?)\s*%')

            if rate:
                return float(rate) / 100

            # Strategy 2: Check university website
            if website:
                rate = self._scrape_admissions_page(website)
                if rate:
                    return rate

        except Exception as e:
            logger.warning(f"Failed to find acceptance rate for {university_name}: {e}")

        return None

    def find_tuition_costs(self, university_name: str, website: str = None) -> Dict[str, Optional[float]]:
        """
        Find tuition and cost information

        Returns:
            Dict with tuition_out_state, total_cost
        """
        costs = {'tuition_out_state': None, 'total_cost': None}

        try:
            # Strategy 1: Search for tuition
            search_query = f"{university_name} tuition cost"
            text = self._web_search(search_query)

            if text:
                # Look for tuition amounts
                tuition_match = re.search(r'\$\s*(\d{1,3}(?:,\d{3})*)', text)
                if tuition_match:
                    amount = int(tuition_match.group(1).replace(',', ''))
                    costs['tuition_out_state'] = float(amount)
                    costs['total_cost'] = float(amount * 1.5)  # Estimate total with living

            # Strategy 2: Check tuition/cost page on website
            if website:
                site_costs = self._scrape_tuition_page(website)
                costs.update(site_costs)

        except Exception as e:
            logger.warning(f"Failed to find costs for {university_name}: {e}")

        return costs

    def find_test_scores(self, university_name: str, website: str = None) -> Dict[str, Optional[int]]:
        """
        Find SAT/ACT score ranges

        Returns:
            Dict with sat_math_25th, sat_math_75th, sat_ebrw_25th, sat_ebrw_75th,
            act_composite_25th, act_composite_75th
        """
        scores = {
            'sat_math_25th': None, 'sat_math_75th': None,
            'sat_ebrw_25th': None, 'sat_ebrw_75th': None,
            'act_composite_25th': None, 'act_composite_75th': None
        }

        try:
            # Search for SAT scores
            search_query = f"{university_name} SAT scores range"
            text = self._web_search(search_query)

            if text:
                # Look for SAT ranges: "1400-1550"
                sat_range = re.search(r'SAT.*?(\d{3,4})\s*-\s*(\d{3,4})', text, re.IGNORECASE)
                if sat_range:
                    low = int(sat_range.group(1))
                    high = int(sat_range.group(2))

                    # Estimate component scores (roughly 50/50 split)
                    scores['sat_math_25th'] = int(low * 0.5)
                    scores['sat_math_75th'] = int(high * 0.5)
                    scores['sat_ebrw_25th'] = int(low * 0.5)
                    scores['sat_ebrw_75th'] = int(high * 0.5)

                # Look for ACT ranges: "30-34"
                act_range = re.search(r'ACT.*?(\d{1,2})\s*-\s*(\d{1,2})', text, re.IGNORECASE)
                if act_range:
                    scores['act_composite_25th'] = int(act_range.group(1))
                    scores['act_composite_75th'] = int(act_range.group(2))

        except Exception as e:
            logger.warning(f"Failed to find test scores for {university_name}: {e}")

        return scores

    def find_graduation_rate(self, university_name: str) -> Optional[float]:
        """
        Find 4-year graduation rate

        Returns:
            Graduation rate as decimal (0.0-1.0) or None
        """
        try:
            search_query = f"{university_name} 4 year graduation rate"
            rate = self._google_search_extract(search_query, r'(\d+(?:\.\d+)?)\s*%')

            if rate:
                return float(rate) / 100

        except Exception as e:
            logger.warning(f"Failed to find graduation rate for {university_name}: {e}")

        return None

    def find_student_count(self, university_name: str, website: str = None) -> Optional[int]:
        """
        Find total student enrollment

        Returns:
            Number of students or None
        """
        try:
            # Search for enrollment
            search_query = f"{university_name} total enrollment students"
            text = self._web_search(search_query)

            if text:
                # Look for enrollment numbers
                enrollment_match = re.search(r'(\d{1,3}(?:,\d{3})*)\s+students', text, re.IGNORECASE)
                if enrollment_match:
                    return int(enrollment_match.group(1).replace(',', ''))

        except Exception as e:
            logger.warning(f"Failed to find student count for {university_name}: {e}")

        return None

    def find_location_details(self, university_name: str) -> Dict[str, Optional[str]]:
        """
        Find city, state, location type

        Returns:
            Dict with city, state, location_type
        """
        location = {'city': None, 'state': None, 'location_type': None}

        try:
            search_query = f"{university_name} location city state"
            text = self._web_search(search_query)

            if text:
                # Look for "City, State" pattern
                location_match = re.search(r'(?:located in|in)\s+([A-Z][a-z]+(?:\s[A-Z][a-z]+)*),\s*([A-Z]{2})', text)
                if location_match:
                    location['city'] = location_match.group(1)
                    location['state'] = location_match.group(2)

                # Determine location type from context
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

    def find_university_type(self, university_name: str) -> Optional[str]:
        """
        Find university type (Public/Private/For-profit)

        Returns:
            'Public', 'Private', or 'For-profit'
        """
        try:
            search_query = f"{university_name} public or private university"
            text = self._web_search(search_query)

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

    def find_gpa_average(self, university_name: str) -> Optional[float]:
        """
        Find average admitted student GPA

        Returns:
            GPA (0.0-4.0) or None
        """
        try:
            search_query = f"{university_name} average GPA admitted students"
            rate = self._google_search_extract(search_query, r'GPA.*?(\d\.\d{1,2})')

            if rate:
                return float(rate)

        except Exception as e:
            logger.warning(f"Failed to find GPA average for {university_name}: {e}")

        return None

    # Helper methods

    def _web_search(self, query: str) -> Optional[str]:
        """Perform web search and return text (using DuckDuckGo for simplicity)"""
        try:
            # Use DuckDuckGo HTML search
            url = "https://html.duckduckgo.com/html/"
            data = {'q': query}

            response = self.session.post(url, data=data, timeout=10)
            if response.status_code == 200:
                soup = BeautifulSoup(response.content, 'html.parser')
                # Extract text from search results
                results = soup.find_all('a', class_='result__a')
                if results:
                    # Get first result snippet
                    snippet = soup.find('a', class_='result__snippet')
                    if snippet:
                        return snippet.get_text()

        except Exception as e:
            logger.debug(f"Web search failed: {e}")

        return None

    def _google_search_extract(self, query: str, pattern: str) -> Optional[str]:
        """Search and extract using regex pattern"""
        text = self._web_search(query)
        if text:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                return match.group(1)
        return None

    def _scrape_admissions_page(self, website: str) -> Optional[float]:
        """Scrape university admissions page for acceptance rate"""
        try:
            # Try common admissions page URLs
            urls = [
                f"{website}/admissions",
                f"{website}/apply",
                f"{website}/undergraduate/admissions"
            ]

            for url in urls:
                try:
                    response = self.session.get(url, timeout=10)
                    if response.status_code == 200:
                        text = response.text.lower()
                        match = re.search(r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%', text)
                        if match:
                            return float(match.group(1)) / 100
                except:
                    continue

        except Exception as e:
            logger.debug(f"Failed to scrape admissions page: {e}")

        return None

    def _scrape_tuition_page(self, website: str) -> Dict[str, Optional[float]]:
        """Scrape university tuition/cost page"""
        costs = {}

        try:
            # Try common tuition page URLs
            urls = [
                f"{website}/tuition",
                f"{website}/costs",
                f"{website}/financial-aid/costs"
            ]

            for url in urls:
                try:
                    response = self.session.get(url, timeout=10)
                    if response.status_code == 200:
                        text = response.text

                        # Look for tuition amounts
                        tuition_matches = re.findall(r'\$\s*(\d{1,3}(?:,\d{3})*)', text)
                        if tuition_matches:
                            # Take the largest reasonable amount (likely tuition)
                            amounts = [int(m.replace(',', '')) for m in tuition_matches]
                            tuition_amounts = [a for a in amounts if 10000 <= a <= 80000]

                            if tuition_amounts:
                                costs['tuition_out_state'] = float(max(tuition_amounts))
                                costs['total_cost'] = float(max(tuition_amounts) * 1.5)
                                break

                except:
                    continue

        except Exception as e:
            logger.debug(f"Failed to scrape tuition page: {e}")

        return costs
