"""
Rate Limiting Middleware
Protects API endpoints from abuse using SlowAPI
"""
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
from fastapi import Request, Response
from typing import Callable
import logging

logger = logging.getLogger(__name__)

# Initialize rate limiter
limiter = Limiter(key_func=get_remote_address, default_limits=["200/minute"])

# Rate limit tiers for different endpoint types
RATE_LIMITS = {
    "auth": "10/minute",  # Strict for auth endpoints
    "write": "60/minute",  # Moderate for create/update operations
    "read": "200/minute",  # Generous for read operations
    "upload": "10/minute",  # Strict for file uploads
}


def get_rate_limit_handler():
    """Get rate limit exceeded handler"""
    return _rate_limit_exceeded_handler


def rate_limit_by_endpoint_type(endpoint_type: str = "read"):
    """
    Decorator for applying rate limits based on endpoint type

    Usage:
        @router.get("/endpoint")
        @limiter.limit(RATE_LIMITS["read"])
        async def endpoint(request: Request):
            pass
    """
    return RATE_LIMITS.get(endpoint_type, RATE_LIMITS["read"])
