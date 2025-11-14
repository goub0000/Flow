"""
Retry Logic with Exponential Backoff
Handles transient failures gracefully
"""
import asyncio
import logging
from functools import wraps
from typing import Callable, Optional, Tuple, Type
import aiohttp
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)


class RetryConfig:
    """Configuration for retry behavior"""

    # Default retry settings
    DEFAULT_MAX_ATTEMPTS = 3
    DEFAULT_INITIAL_DELAY = 1.0  # seconds
    DEFAULT_MAX_DELAY = 30.0  # seconds
    DEFAULT_EXPONENTIAL_BASE = 2  # delay doubles each retry
    DEFAULT_TIMEOUT = 10.0  # seconds

    # Retryable HTTP status codes
    RETRYABLE_STATUS_CODES = {
        408,  # Request Timeout
        429,  # Too Many Requests
        500,  # Internal Server Error
        502,  # Bad Gateway
        503,  # Service Unavailable
        504,  # Gateway Timeout
    }

    # Non-retryable errors (fail fast)
    NON_RETRYABLE_STATUS_CODES = {
        400,  # Bad Request
        401,  # Unauthorized
        403,  # Forbidden
        404,  # Not Found
        405,  # Method Not Allowed
    }


def is_retryable_error(error: Exception) -> bool:
    """
    Determine if an error should be retried

    Args:
        error: Exception that occurred

    Returns:
        True if error is retryable, False otherwise
    """
    # Network/connection errors are retryable
    if isinstance(error, (
        aiohttp.ClientConnectionError,
        aiohttp.ClientConnectorError,
        asyncio.TimeoutError,
    )):
        return True

    # Check HTTP status codes
    if isinstance(error, aiohttp.ClientResponseError):
        return error.status in RetryConfig.RETRYABLE_STATUS_CODES

    # Default: don't retry unknown errors
    return False


def calculate_backoff_delay(
    attempt: int,
    initial_delay: float = RetryConfig.DEFAULT_INITIAL_DELAY,
    exponential_base: float = RetryConfig.DEFAULT_EXPONENTIAL_BASE,
    max_delay: float = RetryConfig.DEFAULT_MAX_DELAY,
    jitter: bool = True
) -> float:
    """
    Calculate delay before next retry using exponential backoff

    Args:
        attempt: Current attempt number (0-indexed)
        initial_delay: Initial delay in seconds
        exponential_base: Base for exponential growth
        max_delay: Maximum delay cap
        jitter: Add randomness to prevent thundering herd

    Returns:
        Delay in seconds
    """
    import random

    # Exponential backoff: delay = initial_delay * (base ^ attempt)
    delay = initial_delay * (exponential_base ** attempt)

    # Cap at max delay
    delay = min(delay, max_delay)

    # Add jitter (randomness) to prevent all clients retrying simultaneously
    if jitter:
        delay = delay * (0.5 + random.random())  # Random between 50-150% of delay

    return delay


def retry_async(
    max_attempts: int = RetryConfig.DEFAULT_MAX_ATTEMPTS,
    initial_delay: float = RetryConfig.DEFAULT_INITIAL_DELAY,
    max_delay: float = RetryConfig.DEFAULT_MAX_DELAY,
    exponential_base: float = RetryConfig.DEFAULT_EXPONENTIAL_BASE,
    retryable_exceptions: Optional[Tuple[Type[Exception], ...]] = None,
    on_retry: Optional[Callable] = None
):
    """
    Decorator for async functions to add retry logic with exponential backoff

    Usage:
        @retry_async(max_attempts=5, initial_delay=1.0)
        async def fetch_data():
            # Your async code here
            pass

    Args:
        max_attempts: Maximum number of attempts (including first try)
        initial_delay: Initial delay between retries in seconds
        max_delay: Maximum delay between retries
        exponential_base: Base for exponential backoff calculation
        retryable_exceptions: Tuple of exception types to retry (None = auto-detect)
        on_retry: Optional callback function called on each retry
    """
    def decorator(func: Callable):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            last_exception = None

            for attempt in range(max_attempts):
                try:
                    # Execute the function
                    return await func(*args, **kwargs)

                except Exception as e:
                    last_exception = e

                    # Check if we should retry this error
                    should_retry = False
                    if retryable_exceptions:
                        should_retry = isinstance(e, retryable_exceptions)
                    else:
                        should_retry = is_retryable_error(e)

                    # If not retryable or last attempt, raise immediately
                    if not should_retry or attempt == max_attempts - 1:
                        logger.warning(
                            f"{func.__name__} failed after {attempt + 1} attempt(s): {e}"
                        )
                        raise

                    # Calculate backoff delay
                    delay = calculate_backoff_delay(
                        attempt,
                        initial_delay=initial_delay,
                        exponential_base=exponential_base,
                        max_delay=max_delay
                    )

                    logger.info(
                        f"{func.__name__} attempt {attempt + 1}/{max_attempts} failed: {e}. "
                        f"Retrying in {delay:.2f}s..."
                    )

                    # Call retry callback if provided
                    if on_retry:
                        on_retry(attempt, e, delay)

                    # Wait before retrying
                    await asyncio.sleep(delay)

            # Should never reach here, but just in case
            raise last_exception

        return wrapper
    return decorator


class RateLimiter:
    """
    Token bucket rate limiter for controlling API request rates

    Prevents overwhelming external APIs with too many requests
    """

    def __init__(
        self,
        requests_per_second: float = 1.0,
        burst_size: Optional[int] = None
    ):
        """
        Initialize rate limiter

        Args:
            requests_per_second: Maximum sustained request rate
            burst_size: Maximum burst of requests (default: 2x rate)
        """
        self.rate = requests_per_second
        self.burst_size = burst_size or int(requests_per_second * 2)

        # Token bucket state
        self.tokens = float(self.burst_size)
        self.last_update = datetime.utcnow()
        self._lock = asyncio.Lock()

    async def acquire(self, tokens: int = 1):
        """
        Acquire tokens before making a request

        Blocks until enough tokens are available

        Args:
            tokens: Number of tokens to acquire (usually 1 per request)
        """
        async with self._lock:
            while True:
                now = datetime.utcnow()

                # Refill tokens based on elapsed time
                elapsed = (now - self.last_update).total_seconds()
                self.tokens = min(
                    self.burst_size,
                    self.tokens + (elapsed * self.rate)
                )
                self.last_update = now

                # If enough tokens available, consume and return
                if self.tokens >= tokens:
                    self.tokens -= tokens
                    return

                # Not enough tokens, calculate wait time
                tokens_needed = tokens - self.tokens
                wait_time = tokens_needed / self.rate

                logger.debug(
                    f"Rate limit: waiting {wait_time:.2f}s for {tokens_needed:.1f} tokens"
                )

                await asyncio.sleep(wait_time)


class CircuitBreaker:
    """
    Circuit breaker pattern for failing fast when API is down

    Prevents wasting time on APIs that are consistently failing

    States:
    - CLOSED: Normal operation, requests pass through
    - OPEN: API is failing, reject requests immediately
    - HALF_OPEN: Testing if API has recovered
    """

    def __init__(
        self,
        failure_threshold: int = 5,
        recovery_timeout: float = 60.0,
        expected_exception: Type[Exception] = Exception
    ):
        """
        Initialize circuit breaker

        Args:
            failure_threshold: Number of failures before opening circuit
            recovery_timeout: Seconds to wait before trying again (half-open)
            expected_exception: Exception type to track
        """
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.expected_exception = expected_exception

        # State tracking
        self.failure_count = 0
        self.last_failure_time: Optional[datetime] = None
        self.state = "CLOSED"  # CLOSED, OPEN, HALF_OPEN
        self._lock = asyncio.Lock()

    async def call(self, func: Callable, *args, **kwargs):
        """
        Execute function with circuit breaker protection

        Args:
            func: Async function to call
            *args, **kwargs: Arguments to pass to function

        Returns:
            Function result

        Raises:
            Exception: If circuit is open or function fails
        """
        async with self._lock:
            # Check if circuit should transition from OPEN to HALF_OPEN
            if self.state == "OPEN":
                if self.last_failure_time:
                    elapsed = (datetime.utcnow() - self.last_failure_time).total_seconds()
                    if elapsed >= self.recovery_timeout:
                        logger.info(
                            f"Circuit breaker: Attempting recovery (half-open) after {elapsed:.0f}s"
                        )
                        self.state = "HALF_OPEN"
                    else:
                        raise Exception(
                            f"Circuit breaker OPEN: API failing, try again in "
                            f"{self.recovery_timeout - elapsed:.0f}s"
                        )

        try:
            # Execute the function
            result = await func(*args, **kwargs)

            # Success - reset failure count
            async with self._lock:
                if self.state == "HALF_OPEN":
                    logger.info("Circuit breaker: Recovery successful, closing circuit")
                self.failure_count = 0
                self.state = "CLOSED"

            return result

        except self.expected_exception as e:
            async with self._lock:
                self.failure_count += 1
                self.last_failure_time = datetime.utcnow()

                # Open circuit if threshold exceeded
                if self.failure_count >= self.failure_threshold:
                    if self.state != "OPEN":
                        logger.warning(
                            f"Circuit breaker: Opening circuit after {self.failure_count} failures"
                        )
                    self.state = "OPEN"

            raise


# Global rate limiters for common APIs
WIKIPEDIA_RATE_LIMITER = RateLimiter(requests_per_second=1.0)  # 1 req/sec
DUCKDUCKGO_RATE_LIMITER = RateLimiter(requests_per_second=0.5)  # 1 req per 2 sec
COLLEGE_SCORECARD_RATE_LIMITER = RateLimiter(requests_per_second=2.0)  # 2 req/sec

# Global circuit breakers
WIKIPEDIA_CIRCUIT_BREAKER = CircuitBreaker(failure_threshold=10, recovery_timeout=300)
DUCKDUCKGO_CIRCUIT_BREAKER = CircuitBreaker(failure_threshold=10, recovery_timeout=300)
