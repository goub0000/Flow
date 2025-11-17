"""
Quick Smoke Test for Meeting Scheduler API
Tests basic endpoint accessibility without authentication
"""
import requests
import json

BASE_URL = "https://web-production-51e34.up.railway.app/api/v1"

def test_endpoint(endpoint, method="GET", description=""):
    """Test an endpoint and return result"""
    url = f"{BASE_URL}{endpoint}"

    try:
        if method == "GET":
            response = requests.get(url, timeout=10)
        elif method == "POST":
            response = requests.post(url, json={}, timeout=10)

        status = "[OK]" if response.status_code in [200, 201, 401, 422] else "[FAIL]"
        return {
            "endpoint": endpoint,
            "description": description,
            "status_code": response.status_code,
            "status": status,
            "accessible": True
        }
    except requests.exceptions.ConnectionError:
        return {
            "endpoint": endpoint,
            "description": description,
            "status": "[FAIL]",
            "error": "Connection Error",
            "accessible": False
        }
    except Exception as e:
        return {
            "endpoint": endpoint,
            "description": description,
            "status": "[FAIL]",
            "error": str(e),
            "accessible": False
        }


def run_smoke_tests():
    """Run smoke tests on all meeting endpoints"""
    print("="*70)
    print("MEETING SCHEDULER API - SMOKE TEST")
    print("="*70)
    print(f"Testing: {BASE_URL}")
    print()

    # Test health endpoint first
    print("Testing API Health...")
    health = test_endpoint("/health", description="Health Check")
    if not health["accessible"]:
        print("[FAIL] API is not accessible. Tests aborted.")
        return

    print(f"[OK] API is accessible (Status: {health['status_code']})")
    print()

    # List of meeting endpoints to test
    endpoints = [
        ("/staff/list", "GET", "Get Staff List"),
        ("/staff/availability", "POST", "Set Staff Availability"),
        ("/meetings/request", "POST", "Request Meeting"),
        ("/meetings/available-slots", "POST", "Get Available Slots"),
        ("/meetings/statistics/me", "GET", "Get My Meeting Statistics"),
    ]

    print("Testing Meeting Endpoints...")
    print("-"*70)
    print(f"{'Endpoint':<40} {'Description':<25} {'Status':<5}")
    print("-"*70)

    results = []
    for endpoint, method, description in endpoints:
        result = test_endpoint(endpoint, method, description)
        results.append(result)

        status_str = f"{result['status_code']}" if result['accessible'] else "N/A"
        print(f"{endpoint:<40} {description:<25} {result['status']:<5} ({status_str})")

    print("-"*70)
    print()

    # Summary
    accessible = [r for r in results if r['accessible']]
    print("Summary:")
    print(f"  Total endpoints tested: {len(results)}")
    print(f"  Accessible: {len(accessible)}/{len(results)}")
    print()

    # Expected responses
    print("Expected Response Codes:")
    print("  200/201: Success (authenticated)")
    print("  401: Unauthorized (expected without valid JWT)")
    print("  422: Validation Error (expected for incomplete data)")
    print()

    if len(accessible) == len(results):
        print("[SUCCESS] All endpoints are accessible!")
        print()
        print("Next Steps:")
        print("  1. Run: python get_test_tokens.py")
        print("  2. Update test_meetings_api.py with tokens and user IDs")
        print("  3. Run: python test_meetings_api.py")
    else:
        print("[WARNING] Some endpoints are not accessible")
        print("Check your Railway deployment and ensure the API is running")


if __name__ == "__main__":
    run_smoke_tests()
