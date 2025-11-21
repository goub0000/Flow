"""
Redis Cache Implementation
Provides caching layer for expensive operations
"""
import redis
import json
import os
from typing import Optional, Any
from datetime import timedelta
import logging

logger = logging.getLogger(__name__)


class RedisCache:
    """Redis cache manager for API responses and expensive computations"""

    def __init__(self):
        """Initialize Redis connection from environment variable"""
        redis_url = os.getenv("REDIS_URL")

        if not redis_url:
            logger.warning("REDIS_URL not set. Caching disabled.")
            self.client = None
            self.enabled = False
            return

        try:
            self.client = redis.from_url(
                redis_url,
                decode_responses=True,
                socket_connect_timeout=5,
                socket_timeout=5
            )
            # Test connection
            self.client.ping()
            self.enabled = True
            self.default_ttl = 3600  # 1 hour default
            logger.info(f"✅ Redis cache initialized successfully")
        except Exception as e:
            logger.error(f"❌ Redis connection failed: {e}. Caching disabled.")
            self.client = None
            self.enabled = False

    def get(self, key: str) -> Optional[Any]:
        """
        Get cached value by key

        Args:
            key: Cache key

        Returns:
            Cached value or None if not found/error
        """
        if not self.enabled or not self.client:
            return None

        try:
            value = self.client.get(key)
            if value:
                logger.debug(f"Cache HIT: {key}")
                return json.loads(value)
            logger.debug(f"Cache MISS: {key}")
            return None
        except Exception as e:
            logger.warning(f"Cache get error for key '{key}': {e}")
            return None

    def set(
        self,
        key: str,
        value: Any,
        ttl: Optional[int] = None,
        ex: Optional[int] = None
    ) -> bool:
        """
        Set cached value with optional TTL

        Args:
            key: Cache key
            value: Value to cache (will be JSON serialized)
            ttl: Time-to-live in seconds (deprecated, use ex)
            ex: Expiration time in seconds

        Returns:
            True if successful, False otherwise
        """
        if not self.enabled or not self.client:
            return False

        try:
            expiration = ex or ttl or self.default_ttl
            serialized = json.dumps(value, default=str)  # default=str for datetime serialization
            self.client.setex(key, expiration, serialized)
            logger.debug(f"Cache SET: {key} (TTL: {expiration}s)")
            return True
        except Exception as e:
            logger.warning(f"Cache set error for key '{key}': {e}")
            return False

    def delete(self, key: str) -> bool:
        """
        Delete cached value

        Args:
            key: Cache key to delete

        Returns:
            True if deleted, False otherwise
        """
        if not self.enabled or not self.client:
            return False

        try:
            self.client.delete(key)
            logger.debug(f"Cache DELETE: {key}")
            return True
        except Exception as e:
            logger.warning(f"Cache delete error for key '{key}': {e}")
            return False

    def clear_pattern(self, pattern: str) -> int:
        """
        Clear all keys matching pattern (e.g., "user:*")

        Args:
            pattern: Redis key pattern with wildcards

        Returns:
            Number of keys deleted
        """
        if not self.enabled or not self.client:
            return 0

        try:
            keys = self.client.keys(pattern)
            if keys:
                deleted = self.client.delete(*keys)
                logger.info(f"Cache CLEAR: {deleted} keys matching '{pattern}'")
                return deleted
            return 0
        except Exception as e:
            logger.warning(f"Cache clear pattern error for '{pattern}': {e}")
            return 0

    def exists(self, key: str) -> bool:
        """
        Check if key exists in cache

        Args:
            key: Cache key

        Returns:
            True if exists, False otherwise
        """
        if not self.enabled or not self.client:
            return False

        try:
            return bool(self.client.exists(key))
        except Exception as e:
            logger.warning(f"Cache exists error for key '{key}': {e}")
            return False

    def get_ttl(self, key: str) -> int:
        """
        Get remaining TTL for a key

        Args:
            key: Cache key

        Returns:
            Remaining seconds or -1 if not found/-2 if no expiry
        """
        if not self.enabled or not self.client:
            return -1

        try:
            return self.client.ttl(key)
        except Exception as e:
            logger.warning(f"Cache TTL error for key '{key}': {e}")
            return -1

    def increment(self, key: str, amount: int = 1) -> Optional[int]:
        """
        Increment counter (useful for rate limiting)

        Args:
            key: Cache key
            amount: Amount to increment by

        Returns:
            New value or None if error
        """
        if not self.enabled or not self.client:
            return None

        try:
            return self.client.incrby(key, amount)
        except Exception as e:
            logger.warning(f"Cache increment error for key '{key}': {e}")
            return None

    def expire(self, key: str, seconds: int) -> bool:
        """
        Set expiration on existing key

        Args:
            key: Cache key
            seconds: Seconds until expiration

        Returns:
            True if successful, False otherwise
        """
        if not self.enabled or not self.client:
            return False

        try:
            return bool(self.client.expire(key, seconds))
        except Exception as e:
            logger.warning(f"Cache expire error for key '{key}': {e}")
            return False

    def health_check(self) -> dict:
        """
        Check Redis health and return stats

        Returns:
            Dictionary with health status and stats
        """
        if not self.enabled or not self.client:
            return {
                "status": "disabled",
                "message": "Redis caching is not configured"
            }

        try:
            # Ping Redis
            self.client.ping()

            # Get info
            info = self.client.info()

            return {
                "status": "healthy",
                "connected": True,
                "used_memory_mb": round(info.get("used_memory", 0) / (1024 ** 2), 2),
                "connected_clients": info.get("connected_clients", 0),
                "total_commands_processed": info.get("total_commands_processed", 0),
                "uptime_seconds": info.get("uptime_in_seconds", 0)
            }
        except Exception as e:
            logger.error(f"Redis health check failed: {e}")
            return {
                "status": "unhealthy",
                "connected": False,
                "error": str(e)
            }


# Singleton instance
_cache_instance: Optional[RedisCache] = None


def get_cache() -> RedisCache:
    """
    Get singleton Redis cache instance

    Returns:
        RedisCache instance
    """
    global _cache_instance
    if _cache_instance is None:
        _cache_instance = RedisCache()
    return _cache_instance


# Convenience reference
cache = get_cache()
