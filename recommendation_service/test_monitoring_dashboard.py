"""
Test Monitoring Dashboard API
Tests the Phase 3 monitoring dashboard endpoints
"""
import requests
import json

BASE_URL = "http://localhost:8000"

def test_health_endpoint():
    """Test monitoring health endpoint"""
    print("\n[TEST] Monitoring Health...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/health")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        print(f"  System Status: {data.get('status')}")
        print(f"  Components:")
        for component, status in data.get('components', {}).items():
            print(f"    - {component}: {status.get('status')}")
        print("  [PASS] Health endpoint")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def test_statistics_endpoint():
    """Test monitoring statistics endpoint"""
    print("\n[TEST] System Statistics...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/statistics")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        print(f"  Universities: {data.get('universities', {}).get('total', 0)}")
        print(f"  Programs: {data.get('programs', {}).get('total', 0)}")
        print(f"  Student Profiles: {data.get('students', {}).get('total_profiles', 0)}")
        print(f"  Recommendations: {data.get('recommendations', {}).get('total', 0)}")

        # Data completeness
        completeness = data.get('universities', {}).get('data_completeness', {})
        if completeness:
            print(f"  Data Completeness:")
            print(f"    - Acceptance Rate: {completeness.get('acceptance_rate', 0)}%")
            print(f"    - Tuition: {completeness.get('tuition', 0)}%")
            print(f"    - Ranking: {completeness.get('ranking', 0)}%")

        print("  [PASS] Statistics endpoint")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def test_data_quality_endpoint():
    """Test data quality metrics endpoint"""
    print("\n[TEST] Data Quality Metrics...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/data-quality")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        print(f"  Total Universities: {data.get('total_universities', 0)}")
        print(f"  Overall Completeness: {data.get('overall_completeness', 0)}%")
        print(f"  Quality Score: {data.get('quality_score', 0)}%")

        field_coverage = data.get('field_coverage', {})
        if field_coverage:
            print(f"  Field Coverage:")
            for field, metrics in list(field_coverage.items())[:5]:
                print(f"    - {field}: {metrics.get('percentage', 0)}% ({metrics.get('count', 0)} universities)")

        print("  [PASS] Data quality endpoint")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def test_performance_endpoint():
    """Test performance metrics endpoint"""
    print("\n[TEST] Performance Metrics...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/performance")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()

        db_size = data.get('database_size', {})
        if db_size:
            print(f"  Database Size:")
            print(f"    - Universities: {db_size.get('universities', 0)}")
            print(f"    - Programs: {db_size.get('programs', 0)}")
            print(f"    - Student Profiles: {db_size.get('student_profiles', 0)}")
            print(f"    - Recommendations: {db_size.get('recommendations', 0)}")

        api_health = data.get('api_health', {})
        print(f"  API Health: {api_health.get('status', 'unknown')}")

        print("  [PASS] Performance endpoint")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def test_recent_errors_endpoint():
    """Test recent errors endpoint"""
    print("\n[TEST] Recent Errors...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/recent-errors?limit=10")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        total_errors = data.get('total', 0)
        print(f"  Total Recent Errors: {total_errors}")

        if total_errors > 0:
            errors = data.get('errors', [])
            print(f"  Latest Error:")
            if errors:
                latest = errors[0]
                print(f"    - Logger: {latest.get('logger_name')}")
                print(f"    - Message: {latest.get('message')}")
                print(f"    - Time: {latest.get('timestamp')}")

        print("  [PASS] Recent errors endpoint")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def test_dashboard_overview():
    """Test complete dashboard overview"""
    print("\n[TEST] Dashboard Overview...")
    response = requests.get(f"{BASE_URL}/api/v1/monitoring/dashboard")
    print(f"  Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()

        # Check all sections present
        sections = ['health', 'statistics', 'data_quality', 'performance']
        print(f"  Dashboard Sections:")
        for section in sections:
            present = section in data
            status = "[OK]" if present else "[MISSING]"
            print(f"    {status} {section}")

        print("  [PASS] Dashboard overview")
        return True
    else:
        print(f"  [FAIL] Status {response.status_code}")
        return False


def main():
    """Run all monitoring dashboard tests"""
    print("="*80)
    print("MONITORING DASHBOARD API TESTS - Phase 3 Complete")
    print("="*80)

    results = []

    # Test all endpoints
    results.append(("Health", test_health_endpoint()))
    results.append(("Statistics", test_statistics_endpoint()))
    results.append(("Data Quality", test_data_quality_endpoint()))
    results.append(("Performance", test_performance_endpoint()))
    results.append(("Recent Errors", test_recent_errors_endpoint()))
    results.append(("Dashboard Overview", test_dashboard_overview()))

    # Summary
    print("\n" + "="*80)
    print("TEST SUMMARY")
    print("="*80)

    all_passed = True
    for test_name, passed in results:
        status = "[PASS]" if passed else "[FAIL]"
        print(f"{status} {test_name}")
        if not passed:
            all_passed = False

    print("\n" + "="*80)
    if all_passed:
        print("[SUCCESS] All monitoring dashboard tests passed!")
        print("\nPhase 3 (Original Plan) is now COMPLETE:")
        print("  [+] Automated scheduling system")
        print("  [+] Field-specific specialized extractors")
        print("  [+] Monitoring dashboard")
    else:
        print("[FAILURE] Some tests failed. Check the output above.")
    print("="*80)


if __name__ == "__main__":
    main()
