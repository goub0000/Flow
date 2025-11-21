"""
Cache module for Redis caching functionality
"""
from .redis_cache import cache, get_cache, RedisCache

__all__ = ['cache', 'get_cache', 'RedisCache']
