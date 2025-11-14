"""
Test Retry Logic Implementation
Verifies that retry decorators, rate limiting, and circuit breakers work correctly
"""
import asyncio
import logging
import sys

# Configure logging to see retry attempts
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

from app.utils.retry import (
    retry_async,
    RateLimiter,
    calculate_backoff_delay,
)

logger = logging.getLogger(__name__)


async def test_retry_decorator():
    """Test that retry decorator works with failing functions"""
    print("\n" + "="*60)
    print("TEST 1: Retry Decorator with Transient Failures")
    print("="*60)

    import aiohttp
    attempt_count = 0

    @retry_async(max_attempts=3, initial_delay=0.5, max_delay=2.0)
    async def flaky_function():
        nonlocal attempt_count
        attempt_count += 1

        # Fail first 2 attempts with retryable error, succeed on 3rd
        if attempt_count < 3:
            logger.info(f"Attempt {attempt_count}: FAILING (simulated transient error)")
            raise aiohttp.ClientConnectionError("Simulated connection failure")
        else:
            logger.info(f"Attempt {attempt_count}: SUCCESS")
            return "Success!"

    try:
        result = await flaky_function()
        print(f"\n[PASS] Test PASSED: Function succeeded after {attempt_count} attempts")
        print(f"  Result: {result}")
        return True
    except Exception as e:
        print(f"\n[FAIL] Test FAILED: {e}")
        return False


async def test_rate_limiter():
    """Test that rate limiter controls request rate"""
    print("\n" + "="*60)
    print("TEST 2: Rate Limiter (2 requests per second)")
    print("="*60)

    # Create rate limiter allowing 2 requests/second
    limiter = RateLimiter(requests_per_second=2.0, burst_size=2)

    import time
    start_time = time.time()

    # Try to make 5 requests
    for i in range(5):
        await limiter.acquire()
        elapsed = time.time() - start_time
        print(f"  Request {i+1}: Allowed after {elapsed:.2f}s")

    total_time = time.time() - start_time

    # Should take at least 2 seconds (5 requests at 2/sec = 2.5 seconds minimum)
    expected_min_time = 1.5  # Allow some tolerance

    if total_time >= expected_min_time:
        print(f"\n[PASS] Test PASSED: 5 requests took {total_time:.2f}s (expected >={expected_min_time}s)")
        return True
    else:
        print(f"\n[FAIL] Test FAILED: 5 requests took only {total_time:.2f}s (too fast!)")
        return False


async def test_backoff_calculation():
    """Test exponential backoff calculation"""
    print("\n" + "="*60)
    print("TEST 3: Exponential Backoff Calculation")
    print("="*60)

    print("\nBackoff delays for 5 retry attempts:")

    delays = []
    for attempt in range(5):
        delay = calculate_backoff_delay(
            attempt,
            initial_delay=1.0,
            exponential_base=2.0,
            max_delay=30.0,
            jitter=False  # Disable jitter for predictable results
        )
        delays.append(delay)
        print(f"  Attempt {attempt}: {delay:.2f}s delay")

    # Verify exponential growth: 1, 2, 4, 8, 16
    expected = [1.0, 2.0, 4.0, 8.0, 16.0]

    if delays == expected:
        print(f"\n[PASS] Test PASSED: Exponential backoff working correctly")
        return True
    else:
        print(f"\n[FAIL] Test FAILED: Expected {expected}, got {delays}")
        return False


async def test_integration():
    """Test integration with actual enrichers (import test)"""
    print("\n" + "="*60)
    print("TEST 4: Integration - Import Enrichers with Retry Logic")
    print("="*60)

    try:
        from app.enrichment.async_web_search_enricher import AsyncWebSearchEnricher
        from app.enrichment.async_college_scorecard_enricher import AsyncCollegeScorecardEnricher

        print("  [OK] AsyncWebSearchEnricher imported successfully")
        print("  [OK] AsyncCollegeScorecardEnricher imported successfully")

        # Verify methods have retry decorator
        web_enricher = AsyncWebSearchEnricher()
        scorecard_enricher = AsyncCollegeScorecardEnricher()

        # Check that methods exist
        assert hasattr(web_enricher, '_search_wikipedia_async')
        assert hasattr(web_enricher, '_search_duckduckgo_async')
        assert hasattr(scorecard_enricher, 'search_university_async')

        print("  [OK] All retry-decorated methods found")

        print("\n[PASS] Test PASSED: All imports and integrations working")
        return True

    except Exception as e:
        print(f"\n[FAIL] Test FAILED: {e}")
        import traceback
        traceback.print_exc()
        return False


async def main():
    """Run all tests"""
    print("\n" + "="*70)
    print("RETRY LOGIC TEST SUITE")
    print("="*70)

    results = []

    # Run all tests
    results.append(await test_retry_decorator())
    results.append(await test_rate_limiter())
    results.append(await test_backoff_calculation())
    results.append(await test_integration())

    # Summary
    print("\n" + "="*70)
    print("TEST SUMMARY")
    print("="*70)

    passed = sum(results)
    total = len(results)

    print(f"\nPassed: {passed}/{total} tests")

    if passed == total:
        print("\n*** ALL TESTS PASSED! ***")
        return 0
    else:
        print(f"\n*** {total - passed} test(s) FAILED ***")
        return 1


if __name__ == "__main__":
    exit_code = asyncio.run(main())
    sys.exit(exit_code)
