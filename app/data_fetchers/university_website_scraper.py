"""
University Website Direct Scraper
Scrapes data directly from university websites by crawling admissions/about pages
"""

import requests
from bs4 import BeautifulSoup
from typing import List, Dict, Any, Optional, Set
import logging
import re
from urllib.parse import urljoin, urlparse
from .base_scraper import BaseScraper
from app.utils.page_cache import PageCache

logger = logging.getLogger(__name__)


class UniversityWebsiteScraper(BaseScraper):
    """
    Scrapes data directly from university websites
    More accurate than search engines but slower
    """

    # Common URL patterns for admissions pages
    ADMISSIONS_PATTERNS = [
        'admissions', 'admission', 'apply', 'applying', 'undergraduate',
        'graduate', 'prospective', 'future-students', 'enroll', 'enrollment'
    ]

    # Common URL patterns for about/facts pages
    ABOUT_PATTERNS = [
        'about', 'facts', 'glance', 'overview', 'mission', 'profile',
        'information', 'quick-facts', 'at-a-glance'
    ]

    # Common URL patterns for tuition/cost pages
    COST_PATTERNS = [
        'tuition', 'cost', 'fees', 'financial', 'afford', 'price',
        'expenses', 'costs-and-aid'
    ]

    def __init__(
        self,
        rate_limit_delay: float = 5.0,
        max_pages_per_site: int = 10,
        cache: Optional[PageCache] = None,
        enable_cache: bool = True
    ):
        """
        Initialize university website scraper

        Args:
            rate_limit_delay: Delay between requests (longer for politeness)
            max_pages_per_site: Maximum pages to crawl per university
            cache: Optional PageCache instance (or None to create default)
            enable_cache: Whether to enable caching (default True)
        """
        super().__init__(
            source_name="University Websites",
            rate_limit_delay=rate_limit_delay,
            max_retries=2,
            timeout=15
        )
        self.max_pages_per_site = max_pages_per_site
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'FlowApp University Data Bot/2.0 (Educational Research; https://flowapp.com)'
        })

        # Initialize caching (Phase 2 enhancement)
        if cache is not None:
            self.cache = cache
        elif enable_cache:
            self.cache = PageCache(cache_dir="cache/pages", cache_duration_days=7)
        else:
            self.cache = PageCache(enabled=False)

    def scrape_university(self, website_url: str, uni_name: str) -> Optional[Dict[str, Any]]:
        """
        Scrape a single university website for data

        Args:
            website_url: University website URL
            uni_name: University name (for logging)

        Returns:
            Dictionary with scraped data or None
        """
        self.logger.info(f"Scraping {uni_name}: {website_url}")

        try:
            # Parse base URL
            parsed_url = urlparse(website_url)
            if not parsed_url.scheme:
                website_url = 'https://' + website_url

            # Get homepage
            homepage_html = self._fetch_page(website_url)
            if not homepage_html:
                self.logger.warning(f"  Could not fetch homepage")
                return None

            # Find relevant pages
            relevant_pages = self._find_relevant_pages(website_url, homepage_html)
            self.logger.info(f"  Found {len(relevant_pages)} relevant pages")

            # Extract data from all pages
            extracted_data = {
                'website': website_url,
                'name': uni_name
            }

            # Process homepage first
            self._extract_from_page(homepage_html, website_url, extracted_data)

            # Process other pages
            for page_url in relevant_pages[:self.max_pages_per_site]:
                self.rate_limit()
                page_html = self._fetch_page(page_url)
                if page_html:
                    self._extract_from_page(page_html, page_url, extracted_data)

            # Clean and validate extracted data
            cleaned_data = self._clean_extracted_data(extracted_data)

            if len(cleaned_data) > 2:  # More than just website and name
                self.logger.info(f"  ✓ Extracted {len(cleaned_data)} fields")
                return cleaned_data
            else:
                self.logger.info(f"  - No additional data found")
                return None

        except Exception as e:
            self.logger.error(f"  Error scraping {uni_name}: {e}")
            return None

    def _fetch_page(self, url: str, force_refresh: bool = False) -> Optional[str]:
        """
        Fetch a single page with retry logic and caching (Phase 2)

        Args:
            url: URL to fetch
            force_refresh: Force bypass cache and fetch fresh content

        Returns:
            Page HTML or None
        """
        # Try cache first (unless force refresh)
        if not force_refresh and hasattr(self, 'cache'):
            cached = self.cache.get(url)
            if cached:
                return cached

        # Cache miss or force refresh - fetch fresh content
        try:
            response = self.session.get(url, timeout=self.timeout, allow_redirects=True)
            if response.status_code == 200:
                content = response.text

                # Store in cache if successful
                if hasattr(self, 'cache'):
                    self.cache.put(url, content)

                return content
            else:
                self.logger.debug(f"HTTP {response.status_code} for {url}")
                return None
        except requests.exceptions.RequestException as e:
            self.logger.debug(f"Failed to fetch {url}: {e}")
            return None

    def _find_relevant_pages(self, base_url: str, html: str) -> List[str]:
        """
        Find relevant pages (admissions, about, costs) from homepage

        Args:
            base_url: University website base URL
            html: Homepage HTML

        Returns:
            List of relevant page URLs
        """
        soup = BeautifulSoup(html, 'html.parser')
        relevant_urls = set()

        # Find all links
        for link in soup.find_all('a', href=True):
            href = link.get('href', '').lower()

            # Skip external links, anchors, and non-relevant links
            if href.startswith('#') or href.startswith('mailto:') or href.startswith('tel:'):
                continue

            # Convert relative URLs to absolute
            absolute_url = urljoin(base_url, link['href'])

            # Check if URL is still on the same domain
            if not self._is_same_domain(base_url, absolute_url):
                continue

            # Check if URL matches relevant patterns
            href_lower = absolute_url.lower()
            if any(pattern in href_lower for pattern in
                   self.ADMISSIONS_PATTERNS + self.ABOUT_PATTERNS + self.COST_PATTERNS):
                relevant_urls.add(absolute_url)

        return list(relevant_urls)

    def _is_same_domain(self, url1: str, url2: str) -> bool:
        """Check if two URLs are on the same domain"""
        domain1 = urlparse(url1).netloc
        domain2 = urlparse(url2).netloc

        # Remove www. for comparison
        domain1 = domain1.replace('www.', '')
        domain2 = domain2.replace('www.', '')

        return domain1 == domain2

    def _extract_from_page(self, html: str, url: str, data: Dict[str, Any]):
        """
        Extract data from a single page

        Args:
            html: Page HTML
            url: Page URL
            data: Dictionary to update with extracted data
        """
        soup = BeautifulSoup(html, 'html.parser')
        text = soup.get_text(separator=' ', strip=True)

        # Extract acceptance rate
        if 'acceptance_rate' not in data:
            acceptance_rate = self._extract_acceptance_rate(text)
            if acceptance_rate:
                data['acceptance_rate'] = acceptance_rate

        # Extract tuition
        if 'tuition_out_state' not in data:
            tuition = self._extract_tuition(text)
            if tuition:
                data['tuition_out_state'] = tuition

        # Extract graduation rate
        if 'graduation_rate_4year' not in data:
            grad_rate = self._extract_graduation_rate(text)
            if grad_rate:
                data['graduation_rate_4year'] = grad_rate

        # Extract total students
        if 'total_students' not in data:
            students = self._extract_total_students(text)
            if students:
                data['total_students'] = students

        # Extract university type (public/private)
        if 'university_type' not in data:
            uni_type = self._extract_university_type(text)
            if uni_type:
                data['university_type'] = uni_type

        # Extract location type (urban/suburban/rural)
        if 'location_type' not in data:
            location_type = self._extract_location_type(text)
            if location_type:
                data['location_type'] = location_type

        # Extract phone
        if 'phone' not in data:
            phone = self._extract_phone(text)
            if phone:
                data['phone'] = phone

        # Extract email
        if 'email' not in data:
            email = self._extract_email(html)
            if email:
                data['email'] = email

        # Extract SAT scores
        sat_scores = self._extract_sat_scores(text)
        if sat_scores:
            data.update(sat_scores)

        # Extract ACT scores
        act_score = self._extract_act_score(text)
        if act_score:
            data['act_composite'] = act_score

        # Extract GPA
        gpa = self._extract_gpa(text)
        if gpa:
            data['avg_gpa'] = gpa

    def _extract_acceptance_rate(self, text: str) -> Optional[float]:
        """Extract acceptance rate from text"""
        patterns = [
            r'acceptance rate[:\s]+(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%\s+acceptance',
            r'admit[^\.]{0,20}?(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%[^\.]{0,20}?admitted',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                rate = float(match.group(1))
                if 1 <= rate <= 100:
                    return rate
        return None

    def _extract_tuition(self, text: str) -> Optional[int]:
        """Extract tuition cost from text"""
        patterns = [
            r'\$\s*(\d{1,3}(?:,\d{3})+)[^\.]{0,30}(?:tuition|annual|per year)',
            r'tuition[^\.]{0,30}\$\s*(\d{1,3}(?:,\d{3})+)',
            r'out[- ]of[- ]state[^\.]{0,30}\$\s*(\d{1,3}(?:,\d{3})+)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                tuition_str = match.group(1).replace(',', '')
                tuition = int(tuition_str)
                if 5000 <= tuition <= 90000:
                    return tuition
        return None

    def _extract_graduation_rate(self, text: str) -> Optional[float]:
        """Extract 4-year graduation rate from text"""
        patterns = [
            r'4[- ]year graduation rate[:\s]+(\d+(?:\.\d+)?)\s*%',
            r'graduation rate[^\.]{0,30}(\d+(?:\.\d+)?)\s*%',
            r'(\d+(?:\.\d+)?)\s*%[^\.]{0,30}graduate',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                rate = float(match.group(1))
                if 10 <= rate <= 100:
                    return rate
        return None

    def _extract_total_students(self, text: str) -> Optional[int]:
        """Extract total student enrollment from text"""
        patterns = [
            r'(\d{1,3}(?:,\d{3})+)\s+(?:total\s+)?students',
            r'enrollment[:\s]+(\d{1,3}(?:,\d{3})+)',
            r'(\d{1,3}(?:,\d{3})+)\s+(?:enrolled|undergraduates)',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                num_str = match.group(1).replace(',', '')
                num = int(num_str)
                if 100 <= num <= 1000000:
                    return num
        return None

    def _extract_university_type(self, text: str) -> Optional[str]:
        """Determine if public or private"""
        text_lower = text.lower()

        public_score = 0
        private_score = 0

        # Public indicators
        if 'public university' in text_lower:
            public_score += 3
        if 'state university' in text_lower:
            public_score += 3
        if 'publicly funded' in text_lower:
            public_score += 2
        if 'public institution' in text_lower:
            public_score += 2

        # Private indicators
        if 'private university' in text_lower:
            private_score += 3
        if 'private institution' in text_lower:
            private_score += 3
        if 'independent university' in text_lower:
            private_score += 2
        if 'privately funded' in text_lower:
            private_score += 2

        if public_score > private_score and public_score >= 2:
            return 'Public'
        elif private_score > public_score and private_score >= 2:
            return 'Private'
        return None

    def _extract_location_type(self, text: str) -> Optional[str]:
        """Determine urban/suburban/rural"""
        text_lower = text.lower()

        urban_score = 0
        suburban_score = 0
        rural_score = 0

        # Urban indicators
        if re.search(r'\burban\s+(?:campus|setting)', text_lower):
            urban_score += 3
        if 'city campus' in text_lower or 'downtown' in text_lower:
            urban_score += 2
        if 'metropolitan' in text_lower:
            urban_score += 1

        # Suburban indicators
        if re.search(r'\bsuburban\s+(?:campus|setting)', text_lower):
            suburban_score += 3
        if 'residential area' in text_lower:
            suburban_score += 2

        # Rural indicators
        if re.search(r'\brural\s+(?:campus|setting)', text_lower):
            rural_score += 3
        if 'small town' in text_lower or 'countryside' in text_lower:
            rural_score += 2

        max_score = max(urban_score, suburban_score, rural_score)
        if max_score >= 2:
            if urban_score == max_score:
                return 'Urban'
            elif suburban_score == max_score:
                return 'Suburban'
            elif rural_score == max_score:
                return 'Rural'
        return None

    def _extract_phone(self, text: str) -> Optional[str]:
        """Extract phone number from text"""
        patterns = [
            r'(?:phone|tel|telephone)[:\s]+(\+?[\d\s\-\(\)\.]{10,20})',
            r'(\+?1?\s*\(?\d{3}\)?[\s\-\.]?\d{3}[\s\-\.]?\d{4})',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                phone = match.group(1).strip()
                # Basic validation
                digits = re.sub(r'\D', '', phone)
                if 10 <= len(digits) <= 15:
                    return phone
        return None

    def _extract_email(self, html: str) -> Optional[str]:
        """Extract email from HTML"""
        soup = BeautifulSoup(html, 'html.parser')

        # Look for mailto links
        for link in soup.find_all('a', href=True):
            href = link['href']
            if href.startswith('mailto:'):
                email = href.replace('mailto:', '').split('?')[0]
                if self._clean_email(email):
                    return email

        # Look for email patterns in text
        text = soup.get_text()
        pattern = r'\b[\w\.-]+@[\w\.-]+\.\w+\b'
        matches = re.findall(pattern, text)

        for match in matches:
            if self._clean_email(match):
                # Prefer admissions/info emails
                if any(word in match.lower() for word in ['admissions', 'info', 'contact', 'admis']):
                    return match

        # Return first valid email if no admissions email found
        if matches and self._clean_email(matches[0]):
            return matches[0]

        return None

    def _extract_sat_scores(self, text: str) -> Dict[str, int]:
        """Extract SAT score ranges"""
        scores = {}

        # SAT Math
        match = re.search(r'SAT\s+Math[:\s]+(\d{3})[^\d]+(\d{3})', text, re.IGNORECASE)
        if match:
            scores['sat_math_25th'] = int(match.group(1))
            scores['sat_math_75th'] = int(match.group(2))

        # SAT EBRW (Evidence-Based Reading and Writing)
        match = re.search(r'SAT\s+(?:EBRW|Reading|Verbal)[:\s]+(\d{3})[^\d]+(\d{3})', text, re.IGNORECASE)
        if match:
            scores['sat_ebrw_25th'] = int(match.group(1))
            scores['sat_ebrw_75th'] = int(match.group(2))

        return scores

    def _extract_act_score(self, text: str) -> Optional[int]:
        """Extract ACT composite score"""
        match = re.search(r'ACT\s+(?:Composite)?[:\s]+(\d{1,2})', text, re.IGNORECASE)
        if match:
            score = int(match.group(1))
            if 1 <= score <= 36:
                return score
        return None

    def _extract_gpa(self, text: str) -> Optional[float]:
        """Extract average GPA"""
        patterns = [
            r'average\s+GPA[:\s]+([\d\.]+)',
            r'GPA[:\s]+([\d\.]+)',
            r'([\d\.]+)\s+GPA',
        ]

        for pattern in patterns:
            match = re.search(pattern, text, re.IGNORECASE)
            if match:
                gpa = float(match.group(1))
                if 0.0 <= gpa <= 4.0:
                    return gpa
        return None

    def _clean_extracted_data(self, data: Dict[str, Any]) -> Dict[str, Any]:
        """Clean and validate extracted data"""
        cleaned = {}

        for key, value in data.items():
            if value is not None and value != '':
                # Skip name and website (always included)
                if key in ['name', 'website']:
                    continue
                cleaned[key] = value

        return cleaned

    def scrape(self) -> List[Dict[str, Any]]:
        """
        Not used for this scraper - use scrape_university() instead
        This is here to satisfy the abstract base class
        """
        raise NotImplementedError("Use scrape_university() for direct website scraping")

    def parse_university(self, element) -> Optional[Dict[str, Any]]:
        """
        Not used for this scraper
        This is here to satisfy the abstract base class
        """
        raise NotImplementedError("Use scrape_university() for direct website scraping")
