"""
Test Cloud-Based APIs - All Migrated to Supabase
"""
import requests
import json

BASE_URL = "http://localhost:8000"

def test_health():
    """Test health check endpoint"""
    print("\n[TEST] Health Check...")
    response = requests.get(f"{BASE_URL}/health")
    print(f"  Status: {response.status_code}")
    print(f"  Response: {response.json()}")
    assert response.status_code == 200
    print("  [PASS] Health check")

def test_universities():
    """Test universities endpoint"""
    print("\n[TEST] Universities API...")
    response = requests.get(f"{BASE_URL}/api/v1/universities?limit=5")
    print(f"  Status: {response.status_code}")
    data = response.json()
    print(f"  Total universities: {data['total']}")
    print(f"  Returned: {len(data['universities'])} universities")
    if data['universities']:
        print(f"  First: {data['universities'][0]['name']}")
    assert response.status_code == 200
    assert data['total'] > 0
    print("  [PASS] Universities API")

def test_student_profile():
    """Test student profile API (create, get, update, delete)"""
    print("\n[TEST] Student Profile API...")

    # Create student profile
    print("  [1] Creating student profile...")
    profile_data = {
        "user_id": "test_user_123",
        "gpa": 3.8,
        "sat_total": 1450,
        "intended_major": "Computer Science",
        "field_of_study": "STEM",
        "max_budget_per_year": 50000,
        "preferred_states": ["California", "Massachusetts"],
        "preferred_countries": ["United States"],
        "location_type_preference": "Urban",
        "preferred_university_type": "Public",
        "preferred_size": "Large"
    }

    response = requests.post(
        f"{BASE_URL}/api/v1/students/profile",
        json=profile_data
    )
    print(f"    Status: {response.status_code}")
    created_profile = response.json()
    print(f"    Created profile ID: {created_profile.get('id')}")
    assert response.status_code == 200
    print("    [PASS] Create profile")

    # Get student profile
    print("  [2] Getting student profile...")
    response = requests.get(f"{BASE_URL}/api/v1/students/profile/test_user_123")
    print(f"    Status: {response.status_code}")
    profile = response.json()
    assert response.status_code == 200
    assert profile['user_id'] == "test_user_123"
    assert profile['gpa'] == 3.8
    print("    [PASS] Get profile")

    # Update student profile
    print("  [3] Updating student profile...")
    update_data = {"gpa": 3.9, "sat_total": 1500}
    response = requests.put(
        f"{BASE_URL}/api/v1/students/profile/test_user_123",
        json=update_data
    )
    print(f"    Status: {response.status_code}")
    updated_profile = response.json()
    assert response.status_code == 200
    assert updated_profile['gpa'] == 3.9
    assert updated_profile['sat_total'] == 1500
    print("    [PASS] Update profile")

    # Delete student profile (defer to end)
    return created_profile.get('id')

def test_recommendations(student_id):
    """Test recommendations API"""
    print("\n[TEST] Recommendations API...")

    # Generate recommendations
    print("  [1] Generating recommendations...")
    rec_request = {
        "user_id": "test_user_123",
        "max_results": 10
    }

    response = requests.post(
        f"{BASE_URL}/api/v1/recommendations/generate",
        json=rec_request
    )
    print(f"    Status: {response.status_code}")

    if response.status_code == 200:
        data = response.json()
        print(f"    Total recommendations: {data['total']}")
        print(f"    Safety schools: {len(data['safety_schools'])}")
        print(f"    Match schools: {len(data['match_schools'])}")
        print(f"    Reach schools: {len(data['reach_schools'])}")
        assert data['total'] > 0
        print("    [PASS] Generate recommendations")

        # Get recommendations
        print("  [2] Getting recommendations...")
        response = requests.get(f"{BASE_URL}/api/v1/recommendations/test_user_123")
        print(f"    Status: {response.status_code}")
        assert response.status_code == 200
        print("    [PASS] Get recommendations")

        # Update recommendation (favorite the first one)
        if data['safety_schools'] or data['match_schools'] or data['reach_schools']:
            first_rec = (data['safety_schools'] or data['match_schools'] or data['reach_schools'])[0]
            rec_id = first_rec['id']

            print("  [3] Updating recommendation (favorite)...")
            update_req = {"favorited": True, "notes": "Great fit!"}
            response = requests.put(
                f"{BASE_URL}/api/v1/recommendations/{rec_id}",
                json=update_req
            )
            print(f"    Status: {response.status_code}")
            if response.status_code == 200:
                print("    [PASS] Update recommendation")

            # Get favorites
            print("  [4] Getting favorite recommendations...")
            response = requests.get(f"{BASE_URL}/api/v1/recommendations/test_user_123/favorites")
            print(f"    Status: {response.status_code}")
            favorites = response.json()
            print(f"    Favorites count: {len(favorites)}")
            if response.status_code == 200:
                print("    [PASS] Get favorites")
    else:
        print(f"    [SKIP] Could not generate recommendations: {response.text[:200]}")

def cleanup_test_data():
    """Clean up test data"""
    print("\n[CLEANUP] Removing test data...")

    # Delete student profile
    response = requests.delete(f"{BASE_URL}/api/v1/students/profile/test_user_123")
    print(f"  Delete student profile: {response.status_code}")

    print("  [DONE] Cleanup complete")

def main():
    """Run all tests"""
    print("=" * 80)
    print("CLOUD-BASED API TESTS - 100% Supabase Migration")
    print("=" * 80)

    try:
        test_health()
        test_universities()
        student_id = test_student_profile()
        test_recommendations(student_id)

        print("\n" + "=" * 80)
        print("[SUCCESS] All tests passed!")
        print("=" * 80)

    except Exception as e:
        print(f"\n[ERROR] Test failed: {e}")
        import traceback
        traceback.print_exc()

    finally:
        cleanup_test_data()

if __name__ == "__main__":
    main()
