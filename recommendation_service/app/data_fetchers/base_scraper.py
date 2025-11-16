"""
Base Scraper Class
Abstract base class for all web scrapers with common functionality
"""

from abc import ABC, abstractmethod
from typing import List, Dict, Any, Optional
import logging
from time import sleep
import random
import re

logger = logging.getLogger(__name__)


class BaseScraper(ABC):
    """Abstract base class for all web scrapers"""

    def __init__(
        self,
        source_name: str,
        rate_limit_delay: float = 1.0,
        max_retries: int = 3,
        timeout: int = 30
    ):
        """
        Initialize the base scraper

        Args:
            source_name: Name of the data source (for logging)
            rate_limit_delay: Delay between requests in seconds
            max_retries: Maximum number of retry attempts
            timeout: Request timeout in seconds
        """
        self.source_name = source_name
        self.rate_limit_delay = rate_limit_delay
        self.max_retries = max_retries
        self.timeout = timeout
        self.logger = logging.getLogger(self.__class__.__name__)

    @abstractmethod
    def scrape(self) -> List[Dict[str, Any]]:
        """
        Main scraping method - must be implemented by subclasses

        Returns:
            List of university dictionaries
        """
        pass

    @abstractmethod
    def parse_university(self, element) -> Optional[Dict[str, Any]]:
        """
        Parse a single university entry - must be implemented by subclasses

        Args:
            element: The data element to parse (HTML element, JSON object, etc.)

        Returns:
            Dictionary with university data or None if parsing failed
        """
        pass

    def normalize_data(self, raw_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Normalize scraped data to match database schema

        Args:
            raw_data: Raw university data from scraper

        Returns:
            Normalized dictionary ready for database insertion
        """
        normalized = {
            'name': self._clean_text(raw_data.get('name', '')),
            'country': raw_data.get('country_code', ''),
            'state': self._clean_text(raw_data.get('state')),
            'city': self._clean_text(raw_data.get('city')),
            'website': self._clean_url(raw_data.get('website')),
            'description': self._clean_text(raw_data.get('description')),
            'phone': self._clean_text(raw_data.get('phone')),
            'email': self._clean_email(raw_data.get('email')),
        }

        # Remove None and empty string values
        return {k: v for k, v in normalized.items() if v is not None and v != ''}

    def _clean_text(self, text: Optional[str]) -> Optional[str]:
        """
        Clean and normalize text

        Args:
            text: Input text

        Returns:
            Cleaned text or None
        """
        if not text:
            return None

        # Remove extra whitespace
        text = ' '.join(text.strip().split())

        # Remove common artifacts
        text = text.replace('\n', ' ').replace('\r', ' ').replace('\t', ' ')

        return text if text else None

    def _clean_url(self, url: Optional[str]) -> Optional[str]:
        """
        Validate and clean URL

        Args:
            url: Input URL

        Returns:
            Cleaned URL or None
        """
        if not url:
            return None

        url = url.strip()

        # Remove trailing slashes
        url = url.rstrip('/')

        # Add protocol if missing
        if not url.startswith(('http://', 'https://')):
            url = 'https://' + url

        # Basic validation
        if not re.match(r'https?://[\w\-\.]+\.[a-z]{2,}', url, re.IGNORECASE):
            self.logger.debug(f"Invalid URL format: {url}")
            return None

        return url

    def _clean_email(self, email: Optional[str]) -> Optional[str]:
        """
        Validate and clean email address

        Args:
            email: Input email

        Returns:
            Cleaned email or None
        """
        if not email:
            return None

        email = email.strip().lower()

        # Basic email validation
        if not re.match(r'^[\w\.-]+@[\w\.-]+\.\w+$', email):
            self.logger.debug(f"Invalid email format: {email}")
            return None

        return email

    def rate_limit(self):
        """Apply rate limiting with random jitter to be more human-like"""
        jitter = random.uniform(0.8, 1.2)
        sleep(self.rate_limit_delay * jitter)

    def retry_on_error(self, func, *args, **kwargs):
        """
        Retry a function on failure with exponential backoff

        Args:
            func: Function to retry
            *args: Function arguments
            **kwargs: Function keyword arguments

        Returns:
            Function result or None on failure
        """
        for attempt in range(self.max_retries):
            try:
                return func(*args, **kwargs)
            except Exception as e:
                if attempt < self.max_retries - 1:
                    wait_time = (2 ** attempt) * self.rate_limit_delay
                    self.logger.warning(
                        f"Attempt {attempt + 1} failed: {e}. "
                        f"Retrying in {wait_time:.1f}s..."
                    )
                    sleep(wait_time)
                else:
                    self.logger.error(
                        f"All {self.max_retries} attempts failed: {e}"
                    )
                    return None

    def get_stats(self, universities: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        Calculate statistics for scraped universities

        Args:
            universities: List of university dictionaries

        Returns:
            Dictionary with statistics
        """
        if not universities:
            return {
                'total': 0,
                'with_website': 0,
                'with_email': 0,
                'with_phone': 0,
                'by_country': {}
            }

        stats = {
            'total': len(universities),
            'with_website': sum(1 for u in universities if u.get('website')),
            'with_email': sum(1 for u in universities if u.get('email')),
            'with_phone': sum(1 for u in universities if u.get('phone')),
            'by_country': {}
        }

        # Count by country
        for uni in universities:
            country = uni.get('country', 'Unknown')
            stats['by_country'][country] = stats['by_country'].get(country, 0) + 1

        return stats

    def log_stats(self, universities: List[Dict[str, Any]]):
        """
        Log statistics for scraped universities

        Args:
            universities: List of university dictionaries
        """
        stats = self.get_stats(universities)

        self.logger.info("=" * 80)
        self.logger.info(f"SCRAPING STATISTICS - {self.source_name}")
        self.logger.info("=" * 80)
        self.logger.info(f"Total universities: {stats['total']}")
        self.logger.info(f"With website: {stats['with_website']} ({stats['with_website']/stats['total']*100:.1f}%)")
        self.logger.info(f"With email: {stats['with_email']} ({stats['with_email']/stats['total']*100:.1f}%)")
        self.logger.info(f"With phone: {stats['with_phone']} ({stats['with_phone']/stats['total']*100:.1f}%)")
        self.logger.info("")
        self.logger.info("By country:")
        for country, count in sorted(stats['by_country'].items(), key=lambda x: x[1], reverse=True)[:10]:
            self.logger.info(f"  {country}: {count}")
        self.logger.info("=" * 80)
