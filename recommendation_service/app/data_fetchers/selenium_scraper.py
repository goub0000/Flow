"""
Selenium-Enhanced Website Scraper
Handles JavaScript-heavy university websites
Phase 2 Enhancement
"""

from typing import Dict, Any, Optional
import logging
from time import sleep
from bs4 import BeautifulSoup
from app.data_fetchers.university_website_scraper import UniversityWebsiteScraper
from app.utils.page_cache import PageCache

# Selenium imports (optional dependency)
try:
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    from selenium.webdriver.chrome.service import Service
    from selenium.webdriver.common.by import By
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.support import expected_conditions as EC
    from selenium.common.exceptions import TimeoutException, WebDriverException
    SELENIUM_AVAILABLE = True
except ImportError:
    SELENIUM_AVAILABLE = False

logger = logging.getLogger(__name__)


class SeleniumUniversityScraper(UniversityWebsiteScraper):
    """
    Enhanced scraper using Selenium for JavaScript-rendered content

    Falls back to regular HTTP requests if Selenium is unavailable
    """

    def __init__(
        self,
        rate_limit_delay: float = 5.0,
        use_selenium: bool = True,
        headless: bool = True,
        page_load_timeout: int = 20,
        cache: Optional[PageCache] = None,
        enable_cache: bool = True
    ):
        """
        Initialize Selenium scraper

        Args:
            rate_limit_delay: Delay between requests
            use_selenium: Whether to use Selenium (requires installation)
            headless: Run browser in headless mode
            page_load_timeout: Maximum time to wait for page load
            cache: Optional PageCache instance
            enable_cache: Whether to enable caching
        """
        super().__init__(
            rate_limit_delay=rate_limit_delay,
            cache=cache,
            enable_cache=enable_cache
        )

        self.use_selenium = use_selenium and SELENIUM_AVAILABLE
        self.headless = headless
        self.page_load_timeout = page_load_timeout
        self.driver = None

        if self.use_selenium:
            self._init_driver()
        elif use_selenium and not SELENIUM_AVAILABLE:
            logger.warning(
                "Selenium requested but not available. "
                "Install with: pip install selenium"
            )
            logger.info("Falling back to standard HTTP requests")

    def _init_driver(self):
        """Initialize Selenium WebDriver"""
        try:
            options = Options()

            if self.headless:
                options.add_argument('--headless')
                options.add_argument('--headless=new')  # New headless mode

            # Performance optimizations
            options.add_argument('--disable-gpu')
            options.add_argument('--no-sandbox')
            options.add_argument('--disable-dev-shm-usage')
            options.add_argument('--disable-blink-features=AutomationControlled')

            # Stealth mode
            options.add_experimental_option("excludeSwitches", ["enable-automation"])
            options.add_experimental_option('useAutomationExtension', False)

            # User agent
            options.add_argument(
                'user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                'AppleWebKit/537.36 (KHTML, like Gecko) '
                'Chrome/120.0.0.0 Safari/537.36'
            )

            # Disable images for faster loading
            prefs = {'profile.managed_default_content_settings.images': 2}
            options.add_experimental_option('prefs', prefs)

            self.driver = webdriver.Chrome(options=options)
            self.driver.set_page_load_timeout(self.page_load_timeout)

            logger.info("Selenium WebDriver initialized successfully")

        except Exception as e:
            logger.error(f"Failed to initialize Selenium: {e}")
            logger.info("Falling back to standard HTTP requests")
            self.use_selenium = False
            self.driver = None

    def _fetch_page_selenium(self, url: str) -> Optional[str]:
        """
        Fetch page content using Selenium

        Args:
            url: URL to fetch

        Returns:
            Page HTML content or None
        """
        if not self.driver:
            return None

        try:
            logger.debug(f"Fetching with Selenium: {url}")

            # Navigate to page
            self.driver.get(url)

            # Wait for basic page load
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.TAG_NAME, "body"))
            )

            # Additional wait for JavaScript to execute
            sleep(2)

            # Scroll to load lazy content
            self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight/2);")
            sleep(0.5)

            # Get page source
            html = self.driver.page_source

            logger.debug(f"Successfully fetched with Selenium: {url}")
            return html

        except TimeoutException:
            logger.warning(f"Timeout fetching {url} with Selenium")
            return None
        except WebDriverException as e:
            logger.warning(f"Selenium error for {url}: {e}")
            return None
        except Exception as e:
            logger.error(f"Unexpected error fetching {url}: {e}")
            return None

    def _fetch_page(self, url: str, force_refresh: bool = False) -> Optional[str]:
        """
        Override parent method to use Selenium when available with caching support

        Args:
            url: URL to fetch
            force_refresh: Force bypass cache

        Returns:
            Page HTML or None
        """
        # Try cache first (unless force refresh)
        if not force_refresh and hasattr(self, 'cache'):
            cached = self.cache.get(url)
            if cached:
                return cached

        # Cache miss - try Selenium first if available
        if self.use_selenium and self.driver:
            html = self._fetch_page_selenium(url)
            if html:
                # Store in cache
                if hasattr(self, 'cache'):
                    self.cache.put(url, html)
                return html
            else:
                logger.debug("Selenium failed, trying standard HTTP request")

        # Fall back to parent's HTTP request method (which also uses cache)
        return super()._fetch_page(url, force_refresh=force_refresh)

    def scrape_university(
        self,
        website_url: str,
        uni_name: str
    ) -> Optional[Dict[str, Any]]:
        """
        Scrape university with Selenium support

        Args:
            website_url: University website URL
            uni_name: University name

        Returns:
            Extracted data dictionary
        """
        logger.info(f"Scraping {uni_name}: {website_url}")

        if self.use_selenium:
            logger.info("  Using Selenium for JavaScript rendering")
        else:
            logger.info("  Using standard HTTP requests")

        return super().scrape_university(website_url, uni_name)

    def close(self):
        """Clean up Selenium driver"""
        if self.driver:
            try:
                self.driver.quit()
                logger.info("Selenium driver closed")
            except Exception as e:
                logger.error(f"Error closing Selenium driver: {e}")

    def __del__(self):
        """Destructor to ensure driver is closed"""
        self.close()

    def __enter__(self):
        """Context manager entry"""
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager exit"""
        self.close()


class SeleniumScrapeRunner:
    """
    Runner for Selenium-enhanced scraping

    Usage:
        runner = SeleniumScrapeRunner()
        data = runner.scrape_universities(['https://stanford.edu'], ['Stanford'])
    """

    def __init__(
        self,
        use_selenium: bool = True,
        headless: bool = True,
        rate_limit: float = 5.0
    ):
        self.scraper = SeleniumUniversityScraper(
            use_selenium=use_selenium,
            headless=headless,
            rate_limit_delay=rate_limit
        )

    def scrape_universities(
        self,
        websites: list,
        names: list
    ) -> list:
        """
        Scrape multiple universities

        Args:
            websites: List of university URLs
            names: List of university names

        Returns:
            List of extracted data dictionaries
        """
        results = []

        for website, name in zip(websites, names):
            try:
                data = self.scraper.scrape_university(website, name)
                results.append({
                    'name': name,
                    'website': website,
                    'data': data or {},
                    'success': data is not None and len(data) > 0
                })
            except Exception as e:
                logger.error(f"Error scraping {name}: {e}")
                results.append({
                    'name': name,
                    'website': website,
                    'data': {},
                    'success': False,
                    'error': str(e)
                })

        return results

    def close(self):
        """Close the scraper"""
        self.scraper.close()


def check_selenium_setup():
    """
    Check if Selenium is properly set up

    Returns:
        Dictionary with setup status
    """
    status = {
        'selenium_installed': SELENIUM_AVAILABLE,
        'chrome_driver': False,
        'ready': False
    }

    if not SELENIUM_AVAILABLE:
        status['message'] = "Selenium not installed. Run: pip install selenium"
        return status

    # Try to initialize driver
    try:
        options = Options()
        options.add_argument('--headless')
        driver = webdriver.Chrome(options=options)
        driver.quit()
        status['chrome_driver'] = True
        status['ready'] = True
        status['message'] = "Selenium is ready to use"
    except Exception as e:
        status['message'] = f"Chrome driver issue: {e}. Install ChromeDriver for your system"

    return status


if __name__ == "__main__":
    # Test Selenium setup
    print("Checking Selenium setup...")
    status = check_selenium_setup()

    print(f"Selenium installed: {status['selenium_installed']}")
    print(f"Chrome driver available: {status['chrome_driver']}")
    print(f"Ready: {status['ready']}")
    print(f"Message: {status['message']}")

    if status['ready']:
        print("\nSelenium is ready for use!")
        print("The system will automatically use Selenium for JavaScript-heavy websites")
    else:
        print("\nSelenium not ready, but system will fall back to standard HTTP requests")
