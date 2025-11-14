"""
Test script for Cache Management API endpoints
Tests all 6 cache management endpoints with comprehensive validation
"""
import requests
import sys
import json
from typing import Dict, Any

# Configuration
API_BASE_URL = "https://web-production-51e34.up.railway.app/api/v1/enrichment"
# API_BASE_URL = "http://localhost:8000/api/v1/enrichment"  # For local testing

class CacheAPITester:
    def __init__(self, base_url: str):
        self.base_url = base_url
        self.results = []

    def log_result(self, endpoint: str, success: bool, details: str, response: Any = None):
        """Log test result"""
        status = "✅ PASS" if success else "❌ FAIL"
        self.results.append({
            'endpoint': endpoint,
            'success': success,
            'details': details,
            'response': response
        })
        print(f"{status} - {endpoint}: {details}")
        if response:
            print(f"  Response: {json.dumps(response, indent=2)[:200]}...")
        print()

    def test_cache_stats(self):
        """Test GET /cache/stats"""
        print("=" * 80)
        print("TEST 1: GET /cache/stats")
        print("=" * 80)

        try:
            response = requests.get(f"{self.base_url}/cache/stats", timeout=10)

            if response.status_code == 200:
                data = response.json()
                required_fields = ['total_entries', 'valid_entries', 'expired_entries',
                                  'by_source', 'by_field', 'message']

                if all(field in data for field in required_fields):
                    self.log_result(
                        "GET /cache/stats",
                        True,
                        f"Retrieved stats: {data['total_entries']} total, {data['valid_entries']} valid",
                        data
                    )
                    return True
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        "GET /cache/stats",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    "GET /cache/stats",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result("GET /cache/stats", False, f"Exception: {e}", None)
            return False

    def test_cache_health(self):
        """Test GET /cache/health"""
        print("=" * 80)
        print("TEST 2: GET /cache/health")
        print("=" * 80)

        try:
            response = requests.get(f"{self.base_url}/cache/health", timeout=10)

            if response.status_code == 200:
                data = response.json()
                required_fields = ['status', 'metrics', 'recommendations', 'message']

                if all(field in data for field in required_fields):
                    valid_statuses = ['healthy', 'needs_attention', 'critical']
                    if data['status'] in valid_statuses:
                        self.log_result(
                            "GET /cache/health",
                            True,
                            f"Health status: {data['status']}, {len(data['recommendations'])} recommendations",
                            data
                        )
                        return True
                    else:
                        self.log_result(
                            "GET /cache/health",
                            False,
                            f"Invalid status: {data['status']} (expected: {valid_statuses})",
                            data
                        )
                        return False
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        "GET /cache/health",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    "GET /cache/health",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result("GET /cache/health", False, f"Exception: {e}", None)
            return False

    def test_cleanup_expired(self):
        """Test POST /cache/cleanup"""
        print("=" * 80)
        print("TEST 3: POST /cache/cleanup")
        print("=" * 80)

        try:
            response = requests.post(f"{self.base_url}/cache/cleanup", timeout=15)

            if response.status_code == 200:
                data = response.json()
                required_fields = ['deleted_count', 'message']

                if all(field in data for field in required_fields):
                    self.log_result(
                        "POST /cache/cleanup",
                        True,
                        f"Cleaned up {data['deleted_count']} expired entries",
                        data
                    )
                    return True
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        "POST /cache/cleanup",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    "POST /cache/cleanup",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result("POST /cache/cleanup", False, f"Exception: {e}", None)
            return False

    def test_invalidate_university(self, university_id: int = 1):
        """Test DELETE /cache/university/{id}"""
        print("=" * 80)
        print(f"TEST 4: DELETE /cache/university/{university_id}")
        print("=" * 80)

        try:
            response = requests.delete(
                f"{self.base_url}/cache/university/{university_id}",
                timeout=10
            )

            if response.status_code == 200:
                data = response.json()
                required_fields = ['deleted_count', 'university_id', 'message']

                if all(field in data for field in required_fields):
                    if data['university_id'] == university_id:
                        self.log_result(
                            f"DELETE /cache/university/{university_id}",
                            True,
                            f"Invalidated {data['deleted_count']} entries for university {university_id}",
                            data
                        )
                        return True
                    else:
                        self.log_result(
                            f"DELETE /cache/university/{university_id}",
                            False,
                            f"University ID mismatch: {data['university_id']} != {university_id}",
                            data
                        )
                        return False
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        f"DELETE /cache/university/{university_id}",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    f"DELETE /cache/university/{university_id}",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result(
                f"DELETE /cache/university/{university_id}",
                False,
                f"Exception: {e}",
                None
            )
            return False

    def test_invalidate_field(self, field_name: str = "test_field"):
        """Test DELETE /cache/field/{name}"""
        print("=" * 80)
        print(f"TEST 5: DELETE /cache/field/{field_name}")
        print("=" * 80)

        try:
            response = requests.delete(
                f"{self.base_url}/cache/field/{field_name}",
                timeout=10
            )

            if response.status_code == 200:
                data = response.json()
                required_fields = ['deleted_count', 'field_name', 'message']

                if all(field in data for field in required_fields):
                    if data['field_name'] == field_name:
                        self.log_result(
                            f"DELETE /cache/field/{field_name}",
                            True,
                            f"Invalidated {data['deleted_count']} entries for field '{field_name}'",
                            data
                        )
                        return True
                    else:
                        self.log_result(
                            f"DELETE /cache/field/{field_name}",
                            False,
                            f"Field name mismatch: {data['field_name']} != {field_name}",
                            data
                        )
                        return False
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        f"DELETE /cache/field/{field_name}",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    f"DELETE /cache/field/{field_name}",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result(
                f"DELETE /cache/field/{field_name}",
                False,
                f"Exception: {e}",
                None
            )
            return False

    def test_clear_all_cache(self, confirm: bool = False):
        """Test DELETE /cache/all (DESTRUCTIVE - disabled by default)"""
        print("=" * 80)
        print("TEST 6: DELETE /cache/all")
        print("=" * 80)

        if not confirm:
            self.log_result(
                "DELETE /cache/all",
                True,
                "SKIPPED - destructive operation (use --confirm-clear-all to run)",
                None
            )
            return True

        try:
            response = requests.delete(f"{self.base_url}/cache/all", timeout=15)

            if response.status_code == 200:
                data = response.json()
                required_fields = ['deleted_count', 'warning', 'message']

                if all(field in data for field in required_fields):
                    self.log_result(
                        "DELETE /cache/all",
                        True,
                        f"CLEARED ALL CACHE: {data['deleted_count']} entries deleted",
                        data
                    )
                    return True
                else:
                    missing = [f for f in required_fields if f not in data]
                    self.log_result(
                        "DELETE /cache/all",
                        False,
                        f"Missing required fields: {missing}",
                        data
                    )
                    return False
            else:
                self.log_result(
                    "DELETE /cache/all",
                    False,
                    f"HTTP {response.status_code}: {response.text}",
                    None
                )
                return False

        except Exception as e:
            self.log_result("DELETE /cache/all", False, f"Exception: {e}", None)
            return False

    def run_all_tests(self, confirm_clear_all: bool = False):
        """Run all cache API tests"""
        print("\n")
        print("╔" + "=" * 78 + "╗")
        print("║" + " " * 20 + "CACHE API ENDPOINT TESTS" + " " * 34 + "║")
        print("╚" + "=" * 78 + "╝")
        print(f"\nTesting API: {self.base_url}\n")

        # Run tests
        results = []
        results.append(self.test_cache_stats())
        results.append(self.test_cache_health())
        results.append(self.test_cleanup_expired())
        results.append(self.test_invalidate_university(university_id=999999))  # Non-existent ID
        results.append(self.test_invalidate_field(field_name="nonexistent_test_field"))  # Non-existent field
        results.append(self.test_clear_all_cache(confirm=confirm_clear_all))

        # Summary
        print("=" * 80)
        print("TEST SUMMARY")
        print("=" * 80)

        passed = sum(1 for r in results if r)
        failed = len(results) - passed

        print(f"\nTotal Tests: {len(results)}")
        print(f"✅ Passed: {passed}")
        print(f"❌ Failed: {failed}")

        if failed == 0:
            print("\n🎉 All tests passed! Cache API is working correctly.")
            return 0
        else:
            print(f"\n⚠️  {failed} test(s) failed. Check logs above for details.")
            return 1


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Test Cache Management API endpoints")
    parser.add_argument(
        '--url',
        default=API_BASE_URL,
        help=f"API base URL (default: {API_BASE_URL})"
    )
    parser.add_argument(
        '--confirm-clear-all',
        action='store_true',
        help="Enable DELETE /cache/all test (DESTRUCTIVE)"
    )

    args = parser.parse_args()

    tester = CacheAPITester(args.url)
    exit_code = tester.run_all_tests(confirm_clear_all=args.confirm_clear_all)

    sys.exit(exit_code)


if __name__ == "__main__":
    main()
