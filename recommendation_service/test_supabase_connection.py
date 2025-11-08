"""
Test Supabase Connection
Quick script to verify Supabase setup is correct
"""
import os
import logging
from dotenv import load_dotenv
from app.database.supabase_client import get_supabase_client

# Set up logging
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)

def test_connection():
    """Test Supabase connection and configuration"""
    print("=" * 80)
    print("TESTING SUPABASE CONNECTION")
    print("=" * 80)
    print()

    # Load environment
    load_dotenv()

    # Check environment variables
    print("[1/4] Checking environment variables...")
    supabase_url = os.getenv('SUPABASE_URL')
    supabase_key = os.getenv('SUPABASE_SERVICE_KEY') or os.getenv('SUPABASE_ANON_KEY')

    if not supabase_url:
        print("  ✗ SUPABASE_URL not found in .env file")
        print("  → Add: SUPABASE_URL=https://xxxxx.supabase.co")
        return False

    if not supabase_key:
        print("  ✗ SUPABASE_SERVICE_KEY or SUPABASE_ANON_KEY not found in .env file")
        print("  → Add: SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
        return False

    print(f"  ✓ SUPABASE_URL: {supabase_url[:30]}...")
    print(f"  ✓ SUPABASE_KEY: {supabase_key[:30]}...")
    print()

    # Test connection
    print("[2/4] Connecting to Supabase...")
    try:
        supabase = get_supabase_client()
        print("  ✓ Connected to Supabase successfully!")
    except Exception as e:
        print(f"  ✗ Failed to connect: {e}")
        return False
    print()

    # Test database access
    print("[3/4] Testing database access...")
    try:
        if supabase.test_connection():
            print("  ✓ Database access successful!")
        else:
            print("  ✗ Database access failed")
            return False
    except Exception as e:
        print(f"  ✗ Error: {e}")
        return False
    print()

    # Check tables
    print("[4/4] Checking database tables...")
    tables_to_check = ['universities', 'programs', 'student_profiles', 'recommendations']
    all_tables_exist = True

    for table in tables_to_check:
        try:
            count = supabase.get_table_count(table)
            print(f"  ✓ {table}: {count} records")
        except Exception as e:
            print(f"  ✗ {table}: Error - {e}")
            all_tables_exist = False

    print()
    print("=" * 80)
    if all_tables_exist:
        print("✅ SUPABASE SETUP COMPLETE!")
        print("=" * 80)
        print()
        print("Next steps:")
        print("  1. Import universities:")
        print("     python import_universities.py --kaggle latest --limit 100")
        print()
        print("  2. Or run the full import:")
        print("     python import_universities.py --kaggle latest")
        print()
        return True
    else:
        print("⚠️  SETUP INCOMPLETE")
        print("=" * 80)
        print()
        print("Missing tables detected. Please:")
        print("  1. Go to Supabase Dashboard → SQL Editor")
        print("  2. Run the SQL from: supabase_schema.sql")
        print("  3. Verify tables are created in Table Editor")
        print("  4. Run this test again")
        print()
        return False


if __name__ == "__main__":
    try:
        success = test_connection()
        exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\nTest interrupted by user")
        exit(1)
    except Exception as e:
        print(f"\n\nUnexpected error: {e}")
        import traceback
        traceback.print_exc()
        exit(1)
