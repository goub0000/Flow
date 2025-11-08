"""
Wikipedia University List Scraper
Scrapes university lists from Wikipedia articles for various countries
"""

import requests
from bs4 import BeautifulSoup
from typing import List, Dict, Any, Optional
import logging
from .base_scraper import BaseScraper

logger = logging.getLogger(__name__)


class WikipediaUniversityScraper(BaseScraper):
    """
    Scrapes university lists from Wikipedia
    Format: "List of universities in [Country]"
    """

    BASE_URL = "https://en.wikipedia.org/wiki"

    # Target countries with their ISO alpha-2 codes
    TARGET_COUNTRIES = {
        # Africa
        'Nigeria': 'NG',
        'Kenya': 'KE',
        'Ghana': 'GH',
        'Ethiopia': 'ET',
        'Tanzania': 'TZ',
        'Uganda': 'UG',
        'Zimbabwe': 'ZW',
        'Zambia': 'ZM',
        'Senegal': 'SN',
        'Cameroon': 'CM',
        'Rwanda': 'RW',
        'Botswana': 'BW',
        'Namibia': 'NA',
        'Mozambique': 'MZ',
        'Madagascar': 'MG',
        'Mali': 'ML',
        'Burkina Faso': 'BF',
        'Ivory Coast': 'CI',
        'Benin': 'BJ',
        'Togo': 'TG',

        # South America
        'Peru': 'PE',
        'Venezuela': 'VE',
        'Ecuador': 'EC',
        'Bolivia': 'BO',
        'Paraguay': 'PY',
        'Uruguay': 'UY',
        'Guyana': 'GY',
        'Suriname': 'SR',

        # Asia
        'Bangladesh': 'BD',
        'Vietnam': 'VN',
        'Myanmar': 'MM',
        'Cambodia': 'KH',
        'Laos': 'LA',
        'Nepal': 'NP',
        'Sri Lanka': 'LK',
        'Afghanistan': 'AF',
        'Mongolia': 'MN',
        'Uzbekistan': 'UZ',
        'Kazakhstan': 'KZ',
        'Kyrgyzstan': 'KG',
        'Tajikistan': 'TJ',
        'Turkmenistan': 'TM',
        'Yemen': 'YE',
        'Jordan': 'JO',
        'Lebanon': 'LB',
        'Iraq': 'IQ',
    }

    def __init__(self, rate_limit_delay: float = 2.0, countries: Optional[List[str]] = None):
        """
        Initialize Wikipedia scraper

        Args:
            rate_limit_delay: Delay between requests (default 2 seconds for Wikipedia)
            countries: Optional list of countries to scrape. If None, scrape all.
        """
        super().__init__(
            source_name="Wikipedia",
            rate_limit_delay=rate_limit_delay,
            max_retries=3,
            timeout=30
        )

        if countries:
            # Filter TARGET_COUNTRIES to only include specified countries
            self.countries_to_scrape = {
                k: v for k, v in self.TARGET_COUNTRIES.items()
                if k in countries
            }
        else:
            self.countries_to_scrape = self.TARGET_COUNTRIES

    def scrape(self) -> List[Dict[str, Any]]:
        """Scrape universities from all target countries"""
        all_universities = []

        self.logger.info(f"Starting Wikipedia scrape for {len(self.countries_to_scrape)} countries...")
        self.logger.info("=" * 80)

        for country_name, country_code in self.countries_to_scrape.items():
            self.logger.info(f"Scraping {country_name}...")

            universities = self.scrape_country(country_name, country_code)

            if universities:
                all_universities.extend(universities)
                self.logger.info(f"  ✓ Found {len(universities)} universities")
            else:
                self.logger.warning(f"  ✗ No universities found")

            self.rate_limit()

        self.logger.info("=" * 80)
        self.logger.info(f"Total universities scraped: {len(all_universities)}")

        return all_universities

    def scrape_country(self, country_name: str, country_code: str) -> List[Dict[str, Any]]:
        """
        Scrape university list for a specific country

        Args:
            country_name: Full country name
            country_code: ISO alpha-2 country code

        Returns:
            List of university dictionaries
        """
        # Try different URL formats
        url_formats = [
            f"{self.BASE_URL}/List_of_universities_in_{country_name.replace(' ', '_')}",
            f"{self.BASE_URL}/List_of_universities_and_colleges_in_{country_name.replace(' ', '_')}",
            f"{self.BASE_URL}/Higher_education_in_{country_name.replace(' ', '_')}",
            f"{self.BASE_URL}/Education_in_{country_name.replace(' ', '_')}",
        ]

        for url in url_formats:
            try:
                response = requests.get(url, timeout=self.timeout, headers={
                    'User-Agent': 'FlowApp University Database Bot/1.0 (Educational Research; contact@flowapp.com)'
                })

                if response.status_code == 200:
                    universities = self._parse_page(response.text, country_name, country_code)
                    if universities:
                        return universities
                elif response.status_code == 404:
                    self.logger.debug(f"Page not found: {url}")
                else:
                    self.logger.debug(f"HTTP {response.status_code} for {url}")

            except requests.exceptions.RequestException as e:
                self.logger.debug(f"Failed to fetch {url}: {e}")
                continue

        self.logger.warning(f"No Wikipedia page found for {country_name}")
        return []

    def _parse_page(self, html: str, country_name: str, country_code: str) -> List[Dict[str, Any]]:
        """
        Parse Wikipedia page to extract universities

        Args:
            html: Page HTML content
            country_name: Country name
            country_code: ISO country code

        Returns:
            List of university dictionaries
        """
        soup = BeautifulSoup(html, 'lxml')
        universities = []

        # Try to parse from tables first (most common format)
        universities.extend(self._parse_tables(soup, country_name, country_code))

        # If no results from tables, try lists
        if not universities:
            universities.extend(self._parse_lists(soup, country_name, country_code))

        # Deduplicate by name
        seen = set()
        unique_universities = []
        for uni in universities:
            name = uni['name']
            if name not in seen and len(name) > 3:
                seen.add(name)
                unique_universities.append(uni)

        return unique_universities

    def _parse_tables(self, soup: BeautifulSoup, country_name: str, country_code: str) -> List[Dict[str, Any]]:
        """Parse universities from Wikipedia tables"""
        universities = []

        # Find all tables (universities are usually in tables with class "wikitable")
        tables = soup.find_all('table', {'class': 'wikitable'})

        for table in tables:
            rows = table.find_all('tr')[1:]  # Skip header row

            for row in rows:
                cells = row.find_all(['td', 'th'])
                if not cells:
                    continue

                uni_data = self._extract_from_table_row(cells, country_name, country_code)
                if uni_data:
                    universities.append(uni_data)

        return universities

    def _extract_from_table_row(
        self,
        cells: List,
        country_name: str,
        country_code: str
    ) -> Optional[Dict[str, Any]]:
        """Extract university data from a table row"""
        if not cells:
            return None

        # University name is usually in the first or second cell
        name_cell = cells[0] if len(cells) > 0 else None
        if not name_cell:
            return None

        # Get text and clean it
        name = name_cell.get_text(strip=True)

        # Remove footnote markers like [1], [2], etc.
        name = self._clean_footnotes(name)

        # Skip empty names or headers
        if not name or len(name) < 3:
            return None

        # Skip if it's a header row
        if name.lower() in ['name', 'university', 'institution', 'college', 'no.', '#']:
            return None

        # Try to find website link
        website = None
        link = name_cell.find('a', href=True)
        if link:
            href = link.get('href', '')
            # External links start with http
            if href.startswith('http'):
                website = href
            # Wikipedia articles might link to university pages
            elif href.startswith('/wiki/') and not ':' in href:
                # Try to extract actual website from the linked Wikipedia page later
                pass

        # Extract location if available (usually second or third cell)
        city = None
        state = None
        if len(cells) >= 2:
            location_text = cells[1].get_text(strip=True)
            location_text = self._clean_footnotes(location_text)

            # Try to parse location (often "City" or "City, State" format)
            if location_text and location_text.lower() not in ['location', 'city', 'type', 'founded']:
                if ',' in location_text:
                    parts = location_text.split(',')
                    city = parts[0].strip()
                    state = parts[1].strip() if len(parts) > 1 else None
                else:
                    city = location_text

        return {
            'name': name,
            'country_code': country_code,
            'city': city,
            'state': state,
            'website': website,
            'description': f"{name} is a university in {country_name}.",
        }

    def _parse_lists(self, soup: BeautifulSoup, country_name: str, country_code: str) -> List[Dict[str, Any]]:
        """Parse universities from Wikipedia bullet lists"""
        universities = []

        # Find content div (main article content)
        content_divs = soup.find_all('div', {'class': ['mw-parser-output', 'mw-content']})

        for content_div in content_divs:
            # Find all unordered lists
            lists = content_div.find_all('ul')

            for ul in lists:
                items = ul.find_all('li', recursive=False)  # Only direct children

                for item in items:
                    uni_data = self._extract_from_list_item(item, country_name, country_code)
                    if uni_data:
                        universities.append(uni_data)

        return universities

    def _extract_from_list_item(
        self,
        item,
        country_name: str,
        country_code: str
    ) -> Optional[Dict[str, Any]]:
        """Extract university data from a list item"""
        text = item.get_text(strip=True)

        # Clean footnotes
        text = self._clean_footnotes(text)

        # Check if it looks like a university
        if not self._is_university_name(text):
            return None

        # Extract name (remove parenthetical info)
        name = text.split('(')[0].strip() if '(' in text else text

        # Skip if too short
        if len(name) < 3:
            return None

        # Try to find website link
        website = None
        link = item.find('a', href=True)
        if link:
            href = link.get('href', '')
            if href.startswith('http'):
                website = href

        return {
            'name': name,
            'country_code': country_code,
            'website': website,
            'description': f"{name} is a university in {country_name}.",
        }

    def _is_university_name(self, text: str) -> bool:
        """Check if text looks like a university name"""
        if not text or len(text) < 3:
            return False

        # Common keywords
        keywords = [
            'university', 'college', 'institute', 'school', 'academy',
            'universidad', 'universidade', 'université', 'universität',
            'polytechnic', 'technological'
        ]

        text_lower = text.lower()
        return any(keyword in text_lower for keyword in keywords)

    def _clean_footnotes(self, text: str) -> str:
        """Remove footnote markers like [1], [2], [a], etc."""
        import re
        # Remove [1], [2], [a], [note 1], etc.
        text = re.sub(r'\[\d+\]', '', text)
        text = re.sub(r'\[[a-z]\]', '', text)
        text = re.sub(r'\[note \d+\]', '', text)
        text = re.sub(r'\[citation needed\]', '', text, flags=re.IGNORECASE)
        return text.strip()

    def parse_university(self, element) -> Optional[Dict[str, Any]]:
        """
        Required by base class - not used directly in this implementation
        as we parse tables and lists differently
        """
        pass


if __name__ == "__main__":
    # Test the scraper
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )

    # Test with a few countries
    scraper = WikipediaUniversityScraper(countries=['Nigeria', 'Kenya', 'Peru'])
    universities = scraper.scrape()

    print("\n" + "=" * 80)
    print("SAMPLE RESULTS")
    print("=" * 80)

    for uni in universities[:10]:
        print(f"Name: {uni['name']}")
        print(f"Country: {uni.get('country_code', 'N/A')}")
        print(f"City: {uni.get('city', 'N/A')}")
        print(f"Website: {uni.get('website', 'N/A')}")
        print("-" * 40)

    # Log statistics
    scraper.log_stats(universities)
