"""
Test script to verify performance optimizations
Tests pagination, selective fields, and caching improvements
"""

import time
import requests
from typing import Dict, Any, List
import json


class PerformanceTestSuite:
    """Test suite for verifying recommendation service performance optimizations"""

    def __init__(self, base_url: str = "http://localhost:8000/api/v1"):
        self.base_url = base_url
        self.results = []

    def measure_time(self, func):
        """Decorator to measure execution time"""
        def wrapper(*args, **kwargs):
            start = time.time()
            result = func(*args, **kwargs)
            elapsed = time.time() - start
            return result, elapsed
        return wrapper

    def test_pagination_recommendations(self):
        """Test pagination in recommendations API"""
        print("\n=== Testing Recommendations Pagination ===")

        # Test different page sizes
        page_sizes = [10, 20, 50]
        results = []

        for page_size in page_sizes:
            url = f"{self.base_url}/recommendations/test_user_123"
            params = {
                "page": 1,
                "page_size": page_size
            }

            try:
                start = time.time()
                response = requests.get(url, params=params)
                elapsed = time.time() - start

                if response.status_code == 200:
                    data = response.json()
                    results.append({
                        "page_size": page_size,
                        "response_time": elapsed,
                        "total_items": data.get("total", 0),
                        "has_pagination": "pagination" in data
                    })
                    print(f"✓ Page size {page_size}: {elapsed:.2f}s")
                else:
                    print(f"✗ Page size {page_size}: Status {response.status_code}")
            except Exception as e:
                print(f"✗ Page size {page_size}: {str(e)}")

        return results

    def test_university_field_selection(self):
        """Test selective field retrieval for universities"""
        print("\n=== Testing University Field Selection ===")

        # Test with different field selections
        test_cases = [
            ("all_fields", None),
            ("minimal", "id,name,country,state"),
            ("detailed", "id,name,country,state,acceptance_rate,total_cost,ranking")
        ]

        results = []

        for name, fields in test_cases:
            url = f"{self.base_url}/universities"
            params = {
                "page": 1,
                "page_size": 20
            }
            if fields:
                params["fields"] = fields

            try:
                start = time.time()
                response = requests.get(url, params=params)
                elapsed = time.time() - start

                if response.status_code == 200:
                    data = response.json()
                    # Calculate response size
                    response_size = len(json.dumps(data))

                    results.append({
                        "test": name,
                        "fields": fields,
                        "response_time": elapsed,
                        "response_size_bytes": response_size,
                        "num_results": len(data.get("universities", []))
                    })
                    print(f"✓ {name}: {elapsed:.2f}s, {response_size} bytes")
                else:
                    print(f"✗ {name}: Status {response.status_code}")
            except Exception as e:
                print(f"✗ {name}: {str(e)}")

        return results

    def test_caching_performance(self):
        """Test caching effectiveness"""
        print("\n=== Testing Cache Performance ===")

        url = f"{self.base_url}/universities/1"
        results = []

        # First request (cache miss)
        try:
            start = time.time()
            response1 = requests.get(url, params={"use_cache": True})
            time1 = time.time() - start

            # Second request (should be cache hit)
            start = time.time()
            response2 = requests.get(url, params={"use_cache": True})
            time2 = time.time() - start

            # Third request without cache
            start = time.time()
            response3 = requests.get(url, params={"use_cache": False})
            time3 = time.time() - start

            if all(r.status_code == 200 for r in [response1, response2, response3]):
                improvement = ((time1 - time2) / time1) * 100 if time1 > 0 else 0

                results = {
                    "first_request_ms": time1 * 1000,
                    "cached_request_ms": time2 * 1000,
                    "no_cache_request_ms": time3 * 1000,
                    "cache_improvement_percent": improvement
                }

                print(f"✓ First request: {time1*1000:.2f}ms")
                print(f"✓ Cached request: {time2*1000:.2f}ms")
                print(f"✓ No-cache request: {time3*1000:.2f}ms")
                print(f"✓ Cache improvement: {improvement:.1f}%")
            else:
                print("✗ Some requests failed")
        except Exception as e:
            print(f"✗ Cache test failed: {str(e)}")

        return results

    def test_bulk_fetch(self):
        """Test bulk university fetching"""
        print("\n=== Testing Bulk Fetch Performance ===")

        # Test fetching multiple universities
        university_ids = "1,2,3,4,5,6,7,8,9,10"

        # Individual requests
        individual_times = []
        for uid in university_ids.split(","):
            try:
                start = time.time()
                response = requests.get(f"{self.base_url}/universities/{uid}")
                individual_times.append(time.time() - start)
            except:
                pass

        # Bulk request
        try:
            start = time.time()
            response = requests.get(f"{self.base_url}/universities/bulk", params={"ids": university_ids})
            bulk_time = time.time() - start

            if response.status_code == 200:
                total_individual = sum(individual_times)
                improvement = ((total_individual - bulk_time) / total_individual) * 100 if total_individual > 0 else 0

                print(f"✓ Individual requests total: {total_individual*1000:.2f}ms")
                print(f"✓ Bulk request: {bulk_time*1000:.2f}ms")
                print(f"✓ Improvement: {improvement:.1f}%")

                return {
                    "individual_total_ms": total_individual * 1000,
                    "bulk_request_ms": bulk_time * 1000,
                    "improvement_percent": improvement
                }
        except Exception as e:
            print(f"✗ Bulk fetch failed: {str(e)}")

        return {}

    def test_search_with_filters(self):
        """Test search performance with multiple filters (using indexes)"""
        print("\n=== Testing Search with Indexed Filters ===")

        test_cases = [
            {
                "name": "No filters",
                "params": {"page": 1, "page_size": 20}
            },
            {
                "name": "Single filter",
                "params": {"country": "United States", "page": 1, "page_size": 20}
            },
            {
                "name": "Multiple filters",
                "params": {
                    "country": "United States",
                    "min_acceptance_rate": 0.3,
                    "max_acceptance_rate": 0.7,
                    "max_tuition": 50000,
                    "page": 1,
                    "page_size": 20
                }
            }
        ]

        results = []
        for test in test_cases:
            try:
                start = time.time()
                response = requests.get(f"{self.base_url}/universities", params=test["params"])
                elapsed = time.time() - start

                if response.status_code == 200:
                    data = response.json()
                    results.append({
                        "test": test["name"],
                        "response_time_ms": elapsed * 1000,
                        "total_results": data.get("total", 0)
                    })
                    print(f"✓ {test['name']}: {elapsed*1000:.2f}ms")
                else:
                    print(f"✗ {test['name']}: Status {response.status_code}")
            except Exception as e:
                print(f"✗ {test['name']}: {str(e)}")

        return results

    def run_all_tests(self):
        """Run all performance tests"""
        print("=" * 50)
        print("RECOMMENDATION SERVICE PERFORMANCE TESTS")
        print("=" * 50)

        all_results = {}

        # Run each test suite
        all_results["pagination"] = self.test_pagination_recommendations()
        all_results["field_selection"] = self.test_university_field_selection()
        all_results["caching"] = self.test_caching_performance()
        all_results["bulk_fetch"] = self.test_bulk_fetch()
        all_results["search_filters"] = self.test_search_with_filters()

        # Generate summary
        print("\n" + "=" * 50)
        print("PERFORMANCE TEST SUMMARY")
        print("=" * 50)

        # Check if optimizations are working
        optimizations_working = []

        # Check pagination
        if all_results.get("pagination"):
            optimizations_working.append("✓ Pagination is working")

        # Check field selection (smaller response with fewer fields)
        if all_results.get("field_selection"):
            field_results = all_results["field_selection"]
            if len(field_results) >= 2:
                full_size = next((r["response_size_bytes"] for r in field_results if r["test"] == "all_fields"), 0)
                minimal_size = next((r["response_size_bytes"] for r in field_results if r["test"] == "minimal"), 0)
                if minimal_size < full_size:
                    reduction = ((full_size - minimal_size) / full_size) * 100
                    optimizations_working.append(f"✓ Field selection reduces response size by {reduction:.1f}%")

        # Check caching
        if all_results.get("caching"):
            cache_data = all_results["caching"]
            if cache_data.get("cache_improvement_percent", 0) > 20:
                optimizations_working.append(f"✓ Caching improves response time by {cache_data['cache_improvement_percent']:.1f}%")

        # Check bulk fetch
        if all_results.get("bulk_fetch"):
            bulk_data = all_results["bulk_fetch"]
            if bulk_data.get("improvement_percent", 0) > 20:
                optimizations_working.append(f"✓ Bulk fetch improves performance by {bulk_data['improvement_percent']:.1f}%")

        # Print summary
        print("\nOptimizations Status:")
        for optimization in optimizations_working:
            print(optimization)

        # Save detailed results to file
        with open("performance_test_results.json", "w") as f:
            json.dump(all_results, f, indent=2)
        print(f"\nDetailed results saved to performance_test_results.json")

        return all_results


if __name__ == "__main__":
    # Run tests
    tester = PerformanceTestSuite()
    results = tester.run_all_tests()

    print("\n" + "=" * 50)
    print("EXPECTED PERFORMANCE IMPROVEMENTS")
    print("=" * 50)
    print("""
    After applying the optimizations, you should see:

    1. DATABASE INDEXES:
       - Faster query execution (especially with filters)
       - Reduced CPU usage on database server
       - Better performance with large datasets

    2. PAGINATION:
       - Reduced data transfer (only fetching needed pages)
       - Faster response times for large result sets
       - Lower memory usage on client side

    3. FIELD SELECTION:
       - Smaller response payloads (30-70% reduction)
       - Faster network transfer
       - Reduced bandwidth usage

    4. CACHING:
       - 50-90% faster response times for cached data
       - Reduced database load
       - Better user experience for frequently accessed data

    5. BULK OPERATIONS:
       - 60-80% reduction in total request time
       - Fewer network round trips
       - More efficient database queries

    To apply the database indexes, run:
    psql -U your_user -d your_database -f migrations/add_performance_indexes.sql
    """)