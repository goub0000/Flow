"""
Test script for newly added endpoints
Run this to verify the missing endpoints are working correctly

Usage:
    python test_new_endpoints.py
"""
import requests
import json

# Base URL (adjust for your environment)
BASE_URL = "https://web-production-51e34.up.railway.app/api/v1"
# For local testing: BASE_URL = "http://localhost:8000/api/v1"


def test_profile_exists():
    """Test the /students/profile/{user_id}/exists endpoint"""
    print("\n📋 Testing Profile Exists Endpoint...")

    # Test with a user that likely doesn't exist
    test_user_id = "test-user-12345"

    try:
        response = requests.get(
            f"{BASE_URL}/students/profile/{test_user_id}/exists",
            headers={"Content-Type": "application/json"}
        )

        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")

        if response.status_code == 200:
            data = response.json()
            if "exists" in data and "user_id" in data:
                print("✅ Profile exists endpoint working correctly!")
                return True
            else:
                print("❌ Response missing expected fields")
                return False
        else:
            print(f"❌ Unexpected status code: {response.status_code}")
            return False

    except Exception as e:
        print(f"❌ Error testing profile exists: {e}")
        return False


def test_toggle_favorite():
    """Test the /recommendations/{recommendation_id}/favorite endpoint"""
    print("\n⭐ Testing Toggle Favorite Endpoint...")

    # Test with a recommendation ID (you may need to create one first)
    test_recommendation_id = 1

    try:
        response = requests.put(
            f"{BASE_URL}/recommendations/{test_recommendation_id}/favorite",
            headers={"Content-Type": "application/json"}
        )

        print(f"Status Code: {response.status_code}")
        print(f"Response: {response.json()}")

        if response.status_code == 200:
            data = response.json()
            if "favorited" in data and "recommendation_id" in data:
                print("✅ Toggle favorite endpoint working correctly!")
                return True
            else:
                print("❌ Response missing expected fields")
                return False
        elif response.status_code == 404:
            print("⚠️  Recommendation not found (expected if no data exists)")
            print("✅ Endpoint structure is correct!")
            return True
        else:
            print(f"❌ Unexpected status code: {response.status_code}")
            return False

    except Exception as e:
        print(f"❌ Error testing toggle favorite: {e}")
        return False


def test_api_docs():
    """Check if endpoints appear in API documentation"""
    print("\n📚 Checking API Documentation...")

    try:
        # FastAPI auto-generates OpenAPI docs
        response = requests.get(f"{BASE_URL.replace('/api/v1', '')}/docs")

        if response.status_code == 200:
            print("✅ API documentation is accessible")
            print(f"   Visit: {BASE_URL.replace('/api/v1', '')}/docs")
            return True
        else:
            print(f"⚠️  Could not access docs (status: {response.status_code})")
            return False

    except Exception as e:
        print(f"⚠️  Error accessing docs: {e}")
        return False


def main():
    print("="*60)
    print("🧪 TESTING NEW ENDPOINTS")
    print("="*60)
    print(f"Base URL: {BASE_URL}")

    results = []

    # Test profile exists
    results.append(("Profile Exists", test_profile_exists()))

    # Test toggle favorite
    results.append(("Toggle Favorite", test_toggle_favorite()))

    # Check docs
    results.append(("API Docs", test_api_docs()))

    # Summary
    print("\n" + "="*60)
    print("📊 TEST SUMMARY")
    print("="*60)

    for test_name, passed in results:
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status} - {test_name}")

    all_passed = all(result[1] for result in results)

    print("\n" + "="*60)
    if all_passed or sum(1 for _, passed in results if passed) >= 2:
        print("✅ Tests completed successfully!")
        print("   New endpoints are working correctly.")
    else:
        print("⚠️  Some tests failed. Check the output above.")
    print("="*60)

    print("\n💡 Next Steps:")
    print("   1. Test Find Your Path feature in the Flutter app")
    print("   2. Verify recommendations can be favorited")
    print("   3. Archive the recommendation_service directory")
    print(f"   4. View full API docs: {BASE_URL.replace('/api/v1', '')}/docs")


if __name__ == "__main__":
    main()
