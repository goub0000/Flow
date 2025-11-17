"""
Test script for Meeting Scheduler API
This script provides examples for testing all meeting endpoints
"""
import requests
import json
from datetime import datetime, timedelta

# Configuration
BASE_URL = "http://localhost:8000/api/v1"
# Replace with actual tokens from your auth system
PARENT_TOKEN = "your-parent-jwt-token"
TEACHER_TOKEN = "your-teacher-jwt-token"
COUNSELOR_TOKEN = "your-counselor-jwt-token"

# Replace with actual user IDs from your database
PARENT_ID = "parent-user-uuid"
STUDENT_ID = "student-user-uuid"
TEACHER_ID = "teacher-user-uuid"
COUNSELOR_ID = "counselor-user-uuid"


def get_headers(token):
    """Get request headers with auth token"""
    return {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }


def print_response(response, title):
    """Pretty print response"""
    print(f"\n{'='*60}")
    print(f"{title}")
    print(f"{'='*60}")
    print(f"Status Code: {response.status_code}")
    try:
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except:
        print(f"Response: {response.text}")
    print(f"{'='*60}\n")


# ============================================================
# Test 1: Get Staff List
# ============================================================
def test_get_staff_list():
    """Test getting list of available staff"""
    print("\n🧪 TEST 1: Get Staff List")

    url = f"{BASE_URL}/staff/list"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get All Staff")

    # Get only teachers
    url = f"{BASE_URL}/staff/list?role=teacher"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get Teachers Only")

    # Get only counselors
    url = f"{BASE_URL}/staff/list?role=counselor"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get Counselors Only")


# ============================================================
# Test 2: Set Staff Availability
# ============================================================
def test_set_availability():
    """Test setting staff availability"""
    print("\n🧪 TEST 2: Set Staff Availability")

    url = f"{BASE_URL}/staff/availability"

    # Set Monday availability
    data = {
        "day_of_week": 1,  # Monday
        "start_time": "09:00:00",
        "end_time": "17:00:00"
    }

    response = requests.post(url, headers=get_headers(TEACHER_TOKEN), json=data)
    print_response(response, "Set Monday Availability")

    # Set multiple days
    days = {
        1: "Monday",
        2: "Tuesday",
        3: "Wednesday",
        4: "Thursday",
        5: "Friday"
    }

    print("\nSetting availability for weekdays...")
    for day_num, day_name in days.items():
        data = {
            "day_of_week": day_num,
            "start_time": "09:00:00",
            "end_time": "17:00:00"
        }
        response = requests.post(url, headers=get_headers(TEACHER_TOKEN), json=data)
        if response.status_code == 201:
            print(f"✓ {day_name} availability set")
        else:
            print(f"✗ {day_name} failed: {response.json()}")


# ============================================================
# Test 3: Get Staff Availability
# ============================================================
def test_get_availability():
    """Test getting staff availability"""
    print("\n🧪 TEST 3: Get Staff Availability")

    url = f"{BASE_URL}/staff/{TEACHER_ID}/availability"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, f"Get Teacher Availability")


# ============================================================
# Test 4: Get Available Time Slots
# ============================================================
def test_get_available_slots():
    """Test getting available time slots"""
    print("\n🧪 TEST 4: Get Available Time Slots")

    url = f"{BASE_URL}/meetings/available-slots"

    # Get slots for next week
    start_date = datetime.now() + timedelta(days=1)
    end_date = start_date + timedelta(days=7)

    data = {
        "staff_id": TEACHER_ID,
        "start_date": start_date.isoformat(),
        "end_date": end_date.isoformat(),
        "duration_minutes": 30
    }

    response = requests.post(url, headers=get_headers(PARENT_TOKEN), json=data)
    print_response(response, "Get Available Slots (Next 7 Days)")


# ============================================================
# Test 5: Request a Meeting (Parent)
# ============================================================
def test_request_meeting():
    """Test requesting a meeting"""
    print("\n🧪 TEST 5: Request a Meeting")

    url = f"{BASE_URL}/meetings/request"

    # Request meeting with teacher
    scheduled_date = datetime.now() + timedelta(days=3)
    scheduled_date = scheduled_date.replace(hour=14, minute=0, second=0, microsecond=0)

    data = {
        "staff_id": TEACHER_ID,
        "student_id": STUDENT_ID,
        "staff_type": "teacher",
        "meeting_type": "parent_teacher",
        "subject": "Discuss math progress",
        "scheduled_date": scheduled_date.isoformat(),
        "duration_minutes": 30,
        "meeting_mode": "video_call",
        "notes": "Want to discuss improvement strategies",
        "parent_notes": "Concerned about recent test scores"
    }

    response = requests.post(url, headers=get_headers(PARENT_TOKEN), json=data)
    print_response(response, "Request Meeting with Teacher")

    # Save meeting ID for later tests
    if response.status_code == 201:
        meeting_id = response.json().get('id')
        print(f"📝 Meeting ID: {meeting_id}")
        return meeting_id

    return None


# ============================================================
# Test 6: Get Parent Meetings
# ============================================================
def test_get_parent_meetings():
    """Test getting parent's meetings"""
    print("\n🧪 TEST 6: Get Parent Meetings")

    # Get all meetings
    url = f"{BASE_URL}/meetings/parent/{PARENT_ID}"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get All Parent Meetings")

    # Get pending meetings only
    url = f"{BASE_URL}/meetings/parent/{PARENT_ID}?status=pending"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get Pending Meetings")


# ============================================================
# Test 7: Get Staff Meetings
# ============================================================
def test_get_staff_meetings():
    """Test getting staff's meetings"""
    print("\n🧪 TEST 7: Get Staff Meetings")

    # Get all meetings
    url = f"{BASE_URL}/meetings/staff/{TEACHER_ID}"
    response = requests.get(url, headers=get_headers(TEACHER_TOKEN))
    print_response(response, "Get All Staff Meetings")

    # Get pending requests
    url = f"{BASE_URL}/meetings/staff/{TEACHER_ID}?status=pending"
    response = requests.get(url, headers=get_headers(TEACHER_TOKEN))
    print_response(response, "Get Pending Meeting Requests")


# ============================================================
# Test 8: Approve a Meeting (Staff)
# ============================================================
def test_approve_meeting(meeting_id):
    """Test approving a meeting"""
    print("\n🧪 TEST 8: Approve a Meeting")

    if not meeting_id:
        print("⚠️  No meeting ID provided. Skipping approval test.")
        return

    url = f"{BASE_URL}/meetings/{meeting_id}/approve"

    scheduled_date = datetime.now() + timedelta(days=3)
    scheduled_date = scheduled_date.replace(hour=14, minute=0, second=0, microsecond=0)

    data = {
        "scheduled_date": scheduled_date.isoformat(),
        "duration_minutes": 30,
        "meeting_link": "https://meet.google.com/abc-defg-hij",
        "staff_notes": "Looking forward to discussing your child's progress"
    }

    response = requests.put(url, headers=get_headers(TEACHER_TOKEN), json=data)
    print_response(response, "Approve Meeting")


# ============================================================
# Test 9: Decline a Meeting (Staff)
# ============================================================
def test_decline_meeting(meeting_id):
    """Test declining a meeting"""
    print("\n🧪 TEST 9: Decline a Meeting")

    if not meeting_id:
        print("⚠️  No meeting ID provided. Skipping decline test.")
        return

    url = f"{BASE_URL}/meetings/{meeting_id}/decline"

    data = {
        "staff_notes": "Unfortunately, I'm not available that week. Please request a different time."
    }

    response = requests.put(url, headers=get_headers(TEACHER_TOKEN), json=data)
    print_response(response, "Decline Meeting")


# ============================================================
# Test 10: Get Meeting Details
# ============================================================
def test_get_meeting_details(meeting_id):
    """Test getting meeting details"""
    print("\n🧪 TEST 10: Get Meeting Details")

    if not meeting_id:
        print("⚠️  No meeting ID provided. Skipping get details test.")
        return

    url = f"{BASE_URL}/meetings/{meeting_id}"
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Get Meeting Details")


# ============================================================
# Test 11: Cancel a Meeting
# ============================================================
def test_cancel_meeting(meeting_id):
    """Test canceling a meeting"""
    print("\n🧪 TEST 11: Cancel a Meeting")

    if not meeting_id:
        print("⚠️  No meeting ID provided. Skipping cancel test.")
        return

    url = f"{BASE_URL}/meetings/{meeting_id}/cancel"
    params = {
        "cancellation_reason": "Need to reschedule due to conflict"
    }

    response = requests.put(url, headers=get_headers(PARENT_TOKEN), params=params)
    print_response(response, "Cancel Meeting")


# ============================================================
# Test 12: Get Meeting Statistics
# ============================================================
def test_get_statistics():
    """Test getting meeting statistics"""
    print("\n🧪 TEST 12: Get Meeting Statistics")

    url = f"{BASE_URL}/meetings/statistics/me"

    # Parent statistics
    response = requests.get(url, headers=get_headers(PARENT_TOKEN))
    print_response(response, "Parent Meeting Statistics")

    # Staff statistics
    response = requests.get(url, headers=get_headers(TEACHER_TOKEN))
    print_response(response, "Staff Meeting Statistics")


# ============================================================
# Test 13: Update Availability
# ============================================================
def test_update_availability(availability_id):
    """Test updating availability"""
    print("\n🧪 TEST 13: Update Availability")

    if not availability_id:
        print("⚠️  No availability ID provided. Skipping update test.")
        return

    url = f"{BASE_URL}/staff/availability/{availability_id}"

    data = {
        "start_time": "10:00:00",
        "end_time": "16:00:00"
    }

    response = requests.put(url, headers=get_headers(TEACHER_TOKEN), json=data)
    print_response(response, "Update Availability")


# ============================================================
# Test 14: Delete Availability
# ============================================================
def test_delete_availability(availability_id):
    """Test deleting availability"""
    print("\n🧪 TEST 14: Delete Availability")

    if not availability_id:
        print("⚠️  No availability ID provided. Skipping delete test.")
        return

    url = f"{BASE_URL}/staff/availability/{availability_id}"

    response = requests.delete(url, headers=get_headers(TEACHER_TOKEN))
    print_response(response, "Delete Availability")


# ============================================================
# Run All Tests
# ============================================================
def run_all_tests():
    """Run all test cases"""
    print("\n" + "="*60)
    print("MEETING SCHEDULER API - TEST SUITE")
    print("="*60)

    print("\n⚠️  SETUP REQUIRED:")
    print("1. Update BASE_URL if not running on localhost:8000")
    print("2. Replace PARENT_TOKEN, TEACHER_TOKEN with actual JWT tokens")
    print("3. Replace user IDs with actual UUIDs from your database")
    print("4. Ensure database is set up (run MEETINGS_QUICK_SETUP.sql)")

    input("\nPress Enter to continue...")

    try:
        # Basic tests (no dependencies)
        test_get_staff_list()
        test_set_availability()
        test_get_availability()
        test_get_available_slots()

        # Meeting workflow tests
        meeting_id = test_request_meeting()
        test_get_parent_meetings()
        test_get_staff_meetings()

        if meeting_id:
            test_get_meeting_details(meeting_id)

            # Choose to test approve OR decline (not both)
            choice = input("\nTest APPROVE or DECLINE? (a/d): ").lower()
            if choice == 'a':
                test_approve_meeting(meeting_id)
            elif choice == 'd':
                test_decline_meeting(meeting_id)

            # Optionally test cancel
            if input("\nTest CANCEL? (y/n): ").lower() == 'y':
                test_cancel_meeting(meeting_id)

        # Statistics
        test_get_statistics()

        print("\n" + "="*60)
        print("✅ ALL TESTS COMPLETED")
        print("="*60)

    except Exception as e:
        print(f"\n❌ ERROR: {e}")
        import traceback
        traceback.print_exc()


# ============================================================
# Individual Test Menu
# ============================================================
def test_menu():
    """Interactive test menu"""
    print("\n" + "="*60)
    print("MEETING SCHEDULER API - TEST MENU")
    print("="*60)

    tests = {
        "1": ("Get Staff List", test_get_staff_list),
        "2": ("Set Availability", test_set_availability),
        "3": ("Get Availability", test_get_availability),
        "4": ("Get Available Slots", test_get_available_slots),
        "5": ("Request Meeting", test_request_meeting),
        "6": ("Get Parent Meetings", test_get_parent_meetings),
        "7": ("Get Staff Meetings", test_get_staff_meetings),
        "8": ("Approve Meeting", lambda: test_approve_meeting(input("Meeting ID: "))),
        "9": ("Decline Meeting", lambda: test_decline_meeting(input("Meeting ID: "))),
        "10": ("Get Meeting Details", lambda: test_get_meeting_details(input("Meeting ID: "))),
        "11": ("Cancel Meeting", lambda: test_cancel_meeting(input("Meeting ID: "))),
        "12": ("Get Statistics", test_get_statistics),
        "13": ("Update Availability", lambda: test_update_availability(input("Availability ID: "))),
        "14": ("Delete Availability", lambda: test_delete_availability(input("Availability ID: "))),
        "all": ("Run All Tests", run_all_tests),
    }

    while True:
        print("\n" + "-"*60)
        print("Select a test to run:")
        for key, (name, _) in tests.items():
            print(f"  {key}: {name}")
        print("  q: Quit")
        print("-"*60)

        choice = input("\nChoice: ").strip().lower()

        if choice == 'q':
            print("\nGoodbye!")
            break

        if choice in tests:
            try:
                tests[choice][1]()
            except Exception as e:
                print(f"\n❌ ERROR: {e}")
                import traceback
                traceback.print_exc()
        else:
            print("Invalid choice. Try again.")


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "--all":
        run_all_tests()
    else:
        test_menu()
