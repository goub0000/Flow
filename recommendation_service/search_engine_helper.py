"""
Search Engine Helper
Provides fallback search functionality across multiple search engines
"""

import requests
from bs4 import BeautifulSoup
from typing import Optional
import logging

logger = logging.getLogger(__name__)


class SearchEngineHelper:
    """Helper class to search across multiple search engines with fallback"""

    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })

    def search(self, query: str) -> Optional[str]:
        """
        Search across multiple engines with fallback
        Returns concatenated text from search result snippets
        """
        # Try DuckDuckGo first (fastest when working)
        result = self._search_duckduckgo(query)
        if result:
            return result

        # Fallback to Bing
        result = self._search_bing(query)
        if result:
            return result

        # Fallback to Yahoo (uses Bing results but different endpoint)
        result = self._search_yahoo(query)
        if result:
            return result

        return None

    def _search_duckduckgo(self, query: str) -> Optional[str]:
        """Search using DuckDuckGo HTML interface"""
        try:
            search_url = f"https://html.duckduckgo.com/html/?q={requests.utils.quote(query)}"
            response = self.session.get(search_url, timeout=10)

            if response.status_code == 403:
                logger.debug("DuckDuckGo blocked (403)")
                return None

            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')
            snippets = soup.find_all('a', class_='result__snippet')

            if not snippets:
                return None

            text = ' '.join([s.get_text() for s in snippets[:5]])
            logger.debug("DuckDuckGo search successful")
            return text

        except Exception as e:
            logger.debug(f"DuckDuckGo search failed: {e}")
            return None

    def _search_bing(self, query: str) -> Optional[str]:
        """Search using Bing"""
        try:
            search_url = f"https://www.bing.com/search?q={requests.utils.quote(query)}"
            response = self.session.get(search_url, timeout=10)

            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Bing uses different classes for results
            snippets = soup.find_all('p', class_='b_lineclamp')

            if not snippets:
                # Try alternative Bing result format
                snippets = soup.find_all('div', class_='b_caption')

            if not snippets:
                return None

            text = ' '.join([s.get_text() for s in snippets[:5]])
            logger.debug("Bing search successful")
            return text

        except Exception as e:
            logger.debug(f"Bing search failed: {e}")
            return None

    def _search_yahoo(self, query: str) -> Optional[str]:
        """Search using Yahoo"""
        try:
            search_url = f"https://search.yahoo.com/search?p={requests.utils.quote(query)}"
            response = self.session.get(search_url, timeout=10)

            if response.status_code != 200:
                return None

            soup = BeautifulSoup(response.text, 'html.parser')

            # Yahoo result snippets
            snippets = soup.find_all('p', class_='fz-ms')

            if not snippets:
                # Try alternative format
                snippets = soup.find_all('div', class_='compText')

            if not snippets:
                return None

            text = ' '.join([s.get_text() for s in snippets[:5]])
            logger.debug("Yahoo search successful")
            return text

        except Exception as e:
            logger.debug(f"Yahoo search failed: {e}")
            return None
