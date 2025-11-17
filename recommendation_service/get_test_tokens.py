"""
Helper script to obtain JWT tokens for testing
This script logs in as different users and returns their JWT tokens
"""
import requests
import json
from getpass import getpass

# API Configuration
BASE_URL = "https://web-production-51e34.up.railway.app/api/v1"

def get_token(email, password):
    """Login and get JWT token"""
    url = f"{BASE_URL}/auth/login"

    data = {
        "email": email,
        "password": password
    }

    try:
        response = requests.post(url, json=data)

        if response.status_code == 200:
            result = response.json()
            return {
                "success": True,
                "token": result.get("access_token"),
                "user": result.get("user"),
                "message": "Login successful"
            }
        else:
            return {
                "success": False,
                "error": response.json(),
                "message": f"Login failed: {response.status_code}"
            }
    except Exception as e:
        return {
            "success": False,
            "error": str(e),
            "message": f"Request failed: {e}"
        }


def interactive_login():
    """Interactive login to get tokens"""
    print("\n" + "="*60)
    print("JWT TOKEN GENERATOR FOR TESTING")
    print("="*60)

    print("\nThis script will help you obtain JWT tokens for testing.")
    print("You'll need to login as different user types (parent, teacher, counselor)")

    tokens = {}
    user_data = {}

    # Get tokens for each user type
    user_types = {
        "parent": "Parent User (for requesting meetings)",
        "teacher": "Teacher User (for approving meetings)",
        "counselor": "Counselor User (optional, for counselor meetings)"
    }

    for user_type, description in user_types.items():
        print(f"\n{'-'*60}")
        print(f"{description}")
        print(f"{'-'*60}")

        email = input(f"Email: ").strip()
        if not email:
            print(f"⚠️  Skipping {user_type}")
            continue

        password = getpass(f"Password: ")

        print(f"\nLogging in as {user_type}...")
        result = get_token(email, password)

        if result["success"]:
            print(f"✅ {result['message']}")
            tokens[user_type] = result["token"]
            user_data[user_type] = result["user"]

            # Display user info
            user = result["user"]
            print(f"\nUser Info:")
            print(f"  ID: {user.get('id')}")
            print(f"  Name: {user.get('display_name') or user.get('full_name')}")
            print(f"  Role: {user.get('active_role')}")
        else:
            print(f"❌ {result['message']}")
            if result.get('error'):
                print(f"   Error: {result['error']}")

    # Generate test configuration
    if tokens:
        print("\n" + "="*60)
        print("TEST CONFIGURATION")
        print("="*60)

        print("\nCopy these values to test_meetings_api.py:\n")

        # Print tokens
        print("# JWT Tokens")
        for user_type, token in tokens.items():
            var_name = f"{user_type.upper()}_TOKEN"
            print(f'{var_name} = "{token}"')

        # Print user IDs
        print("\n# User IDs")
        for user_type, user in user_data.items():
            var_name = f"{user_type.upper()}_ID"
            print(f'{var_name} = "{user.get("id")}"')

        # Save to file
        config_file = "test_config.txt"
        with open(config_file, 'w') as f:
            f.write("# JWT Tokens\n")
            for user_type, token in tokens.items():
                var_name = f"{user_type.upper()}_TOKEN"
                f.write(f'{var_name} = "{token}"\n')

            f.write("\n# User IDs\n")
            for user_type, user in user_data.items():
                var_name = f"{user_type.upper()}_ID"
                f.write(f'{var_name} = "{user.get("id")}"\n')

        print(f"\n✅ Configuration saved to {config_file}")

        # Print next steps
        print("\n" + "="*60)
        print("NEXT STEPS")
        print("="*60)
        print("1. Copy the configuration above to test_meetings_api.py")
        print("2. Update STUDENT_ID with an actual student ID from your database")
        print("3. Run: python test_meetings_api.py")
        print("="*60)

    else:
        print("\n⚠️  No tokens obtained. Please try again.")


def quick_login():
    """Quick login with provided credentials"""
    import sys

    if len(sys.argv) < 3:
        print("Usage: python get_test_tokens.py <email> <password>")
        return

    email = sys.argv[1]
    password = sys.argv[2]

    print(f"Logging in as {email}...")
    result = get_token(email, password)

    if result["success"]:
        print(f"\n✅ Login successful!")
        print(f"\nJWT Token:")
        print(result["token"])
        print(f"\nUser Info:")
        print(json.dumps(result["user"], indent=2))
    else:
        print(f"\n❌ Login failed")
        print(json.dumps(result, indent=2))


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1:
        # Quick mode with command line args
        quick_login()
    else:
        # Interactive mode
        interactive_login()
