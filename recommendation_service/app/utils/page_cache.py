"""
Page Caching Layer
Caches fetched pages to avoid redundant HTTP requests
Phase 2 Enhancement - Cloud-based (Supabase)
"""

from typing import Optional, Dict, Any
import hashlib
import json
import logging
import os
from datetime import datetime, timedelta
from pathlib import Path
import threading

logger = logging.getLogger(__name__)


class PageCache:
    """
    Cloud-based page cache using Supabase with automatic expiration

    Features:
    - Caches HTML content and metadata in Supabase
    - Automatic expiration based on cache duration
    - Thread-safe operations
    - Cache statistics tracking
    - No local storage required

    Falls back gracefully if caching fails
    """

    def __init__(
        self,
        cache_dir: str = "cache/pages",  # Ignored (kept for API compatibility)
        cache_duration_days: int = 7,
        enabled: bool = True
    ):
        """
        Initialize page cache

        Args:
            cache_dir: [DEPRECATED] Ignored - kept for API compatibility
            cache_duration_days: How long to keep cached pages
            enabled: Whether caching is enabled
        """
        self.enabled = enabled
        self.cache_duration = timedelta(days=cache_duration_days)
        self.lock = threading.Lock()
        self.supabase = None

        # Statistics
        self.stats = {
            'hits': 0,
            'misses': 0,
            'stores': 0,
            'errors': 0,
            'expired': 0
        }

        if self.enabled:
            try:
                from supabase import create_client

                url = os.environ.get("SUPABASE_URL")
                key = os.environ.get("SUPABASE_KEY")

                if not url or not key:
                    logger.warning("Supabase credentials not found in environment. Cache disabled.")
                    self.enabled = False
                else:
                    self.supabase = create_client(url, key)
                    logger.info(f"Page cache initialized: Supabase ({cache_duration_days} days)")
            except Exception as e:
                logger.error(f"Failed to initialize Supabase cache: {e}")
                self.enabled = False

    def _get_cache_key(self, url: str) -> str:
        """
        Generate cache key from URL

        Args:
            url: URL to cache

        Returns:
            Cache key (hash of URL)
        """
        return hashlib.md5(url.encode('utf-8')).hexdigest()

    def get(self, url: str) -> Optional[str]:
        """
        Get cached page content from Supabase

        Args:
            url: URL to retrieve

        Returns:
            Cached HTML content or None if not cached/expired
        """
        if not self.enabled or not self.supabase:
            return None

        try:
            with self.lock:
                cache_key = self._get_cache_key(url)

                # Query Supabase for cached entry
                response = self.supabase.table('page_cache').select('*').eq('url_hash', cache_key).execute()

                if not response.data or len(response.data) == 0:
                    self.stats['misses'] += 1
                    return None

                entry = response.data[0]
                expires_at = datetime.fromisoformat(entry['expires_at'].replace('Z', '+00:00'))

                # Check expiration
                if datetime.now(expires_at.tzinfo) > expires_at:
                    logger.debug(f"Cache expired for {url}")
                    self.stats['expired'] += 1
                    self.stats['misses'] += 1
                    # Clean up expired entry
                    try:
                        self.supabase.table('page_cache').delete().eq('url_hash', cache_key).execute()
                    except:
                        pass
                    return None

                # Cache hit
                self.stats['hits'] += 1
                cached_at = datetime.fromisoformat(entry['cached_at'].replace('Z', '+00:00'))
                age_days = (datetime.now(cached_at.tzinfo) - cached_at).days
                logger.debug(f"Cache HIT for {url} (age: {age_days} days)")
                return entry['content']

        except Exception as e:
            logger.error(f"Cache read error for {url}: {e}")
            self.stats['errors'] += 1
            return None

    def put(self, url: str, content: str, metadata: Optional[Dict[str, Any]] = None):
        """
        Store page content in Supabase cache

        Args:
            url: URL being cached
            content: HTML content
            metadata: Optional metadata to store
        """
        if not self.enabled or not content or not self.supabase:
            return

        try:
            with self.lock:
                cache_key = self._get_cache_key(url)
                now = datetime.now()
                expires_at = now + self.cache_duration

                entry = {
                    'url_hash': cache_key,
                    'url': url,
                    'content': content,
                    'cached_at': now.isoformat(),
                    'expires_at': expires_at.isoformat(),
                    'metadata': metadata or {},
                    'content_size': len(content)
                }

                # Upsert to Supabase (insert or update if exists)
                self.supabase.table('page_cache').upsert(entry).execute()

                self.stats['stores'] += 1
                logger.debug(f"Cached: {url} ({len(content)} bytes)")

        except Exception as e:
            logger.error(f"Cache write error for {url}: {e}")
            self.stats['errors'] += 1

    def invalidate(self, url: str):
        """
        Remove specific URL from Supabase cache

        Args:
            url: URL to invalidate
        """
        if not self.enabled or not self.supabase:
            return

        try:
            with self.lock:
                cache_key = self._get_cache_key(url)
                self.supabase.table('page_cache').delete().eq('url_hash', cache_key).execute()
                logger.debug(f"Invalidated cache for {url}")

        except Exception as e:
            logger.error(f"Cache invalidation error for {url}: {e}")
            self.stats['errors'] += 1

    def clear(self):
        """Clear all cached pages from Supabase"""
        if not self.enabled or not self.supabase:
            return

        try:
            with self.lock:
                # Count entries before deletion
                response = self.supabase.table('page_cache').select('url_hash', count='exact').execute()
                count = response.count if hasattr(response, 'count') else 0

                # Delete all entries
                self.supabase.table('page_cache').delete().neq('url_hash', '').execute()

                logger.info(f"Cleared {count} cached pages from Supabase")

        except Exception as e:
            logger.error(f"Cache clear error: {e}")

    def get_stats(self) -> Dict[str, Any]:
        """
        Get cache statistics

        Returns:
            Dictionary with cache statistics
        """
        total_requests = self.stats['hits'] + self.stats['misses']
        hit_rate = (self.stats['hits'] / total_requests * 100) if total_requests > 0 else 0

        return {
            'enabled': self.enabled,
            'hits': self.stats['hits'],
            'misses': self.stats['misses'],
            'stores': self.stats['stores'],
            'expired': self.stats['expired'],
            'errors': self.stats['errors'],
            'total_requests': total_requests,
            'hit_rate': hit_rate,
            'cache_duration_days': self.cache_duration.days
        }

    def log_stats(self):
        """Log cache statistics"""
        stats = self.get_stats()

        logger.info("=" * 80)
        logger.info("PAGE CACHE STATISTICS")
        logger.info("=" * 80)
        logger.info(f"Enabled:              {stats['enabled']}")
        logger.info(f"Total requests:       {stats['total_requests']}")
        logger.info(f"Cache hits:           {stats['hits']}")
        logger.info(f"Cache misses:         {stats['misses']}")
        logger.info(f"Hit rate:             {stats['hit_rate']:.1f}%")
        logger.info(f"Stored:               {stats['stores']}")
        logger.info(f"Expired:              {stats['expired']}")
        logger.info(f"Errors:               {stats['errors']}")
        logger.info(f"Cache duration:       {stats['cache_duration_days']} days")
        logger.info("=" * 80)


class CachedPageFetcher:
    """
    Wrapper for page fetching with caching support

    Usage:
        cache = PageCache()
        fetcher = CachedPageFetcher(cache)

        html = fetcher.fetch(url, fetch_function)
    """

    def __init__(self, cache: Optional[PageCache] = None):
        """
        Initialize cached fetcher

        Args:
            cache: PageCache instance (or None to disable caching)
        """
        self.cache = cache or PageCache(enabled=False)

    def fetch(self, url: str, fetch_function, force_refresh: bool = False):
        """
        Fetch page with caching

        Args:
            url: URL to fetch
            fetch_function: Function to call if cache miss (must accept url and return html)
            force_refresh: Force bypass cache and fetch fresh content

        Returns:
            HTML content
        """
        # Try cache first (unless force refresh)
        if not force_refresh:
            cached = self.cache.get(url)
            if cached:
                return cached

        # Cache miss - fetch fresh content
        content = fetch_function(url)

        # Store in cache if successful
        if content:
            self.cache.put(url, content)

        return content


# Global cache instance
_global_cache = None
_cache_lock = threading.Lock()


def get_global_cache(
    cache_dir: str = "cache/pages",
    cache_duration_days: int = 7,
    enabled: bool = True
) -> PageCache:
    """
    Get or create global cache instance

    Args:
        cache_dir: Cache directory
        cache_duration_days: Cache duration
        enabled: Whether caching is enabled

    Returns:
        Global PageCache instance
    """
    global _global_cache

    with _cache_lock:
        if _global_cache is None:
            _global_cache = PageCache(
                cache_dir=cache_dir,
                cache_duration_days=cache_duration_days,
                enabled=enabled
            )

        return _global_cache


# Example usage
if __name__ == "__main__":
    import requests
    import os
    from dotenv import load_dotenv

    # Load environment variables
    load_dotenv()

    # Initialize Supabase cache
    cache = PageCache(cache_duration_days=7)

    # Example fetch function
    def fetch_page(url):
        print(f"Fetching {url}...")
        response = requests.get(url, timeout=10)
        return response.text

    # Test caching
    fetcher = CachedPageFetcher(cache)

    print("\nFirst fetch (cache miss - will store in Supabase):")
    html1 = fetcher.fetch("https://www.example.com", fetch_page)
    print(f"Got {len(html1)} bytes")

    print("\nSecond fetch (cache hit - from Supabase):")
    html2 = fetcher.fetch("https://www.example.com", fetch_page)
    print(f"Got {len(html2)} bytes")

    print("\nForce refresh:")
    html3 = fetcher.fetch("https://www.example.com", fetch_page, force_refresh=True)
    print(f"Got {len(html3)} bytes")

    # Show stats
    print()
    cache.log_stats()

    # Optional: Clean up (removes all cached entries from Supabase)
    # cache.clear()
