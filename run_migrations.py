"""
Database Migration Runner
Applies SQL migrations to Supabase database
"""

import os
import sys
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()


def run_migrations():
    """Run all pending migrations"""
    try:
        from supabase import create_client

        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")

        if not url or not key:
            print("ERROR: Supabase credentials not found in environment variables")
            print("Please ensure SUPABASE_URL and SUPABASE_KEY are set in .env file")
            return False

        print("Connecting to Supabase...")
        supabase = create_client(url, key)

        # Get all migration files
        migrations_dir = Path("migrations")
        if not migrations_dir.exists():
            print(f"ERROR: Migrations directory not found: {migrations_dir}")
            return False

        migration_files = sorted(migrations_dir.glob("*.sql"))

        if not migration_files:
            print("No migration files found")
            return True

        print(f"Found {len(migration_files)} migration file(s)\n")

        # Execute each migration
        for migration_file in migration_files:
            print(f"Running migration: {migration_file.name}")

            try:
                # Read migration SQL
                with open(migration_file, 'r', encoding='utf-8') as f:
                    sql = f.read()

                # Execute SQL
                # Note: Supabase Python client doesn't have direct SQL execution
                # We need to use the REST API or PostgREST
                print(f"  [!] Migration SQL prepared")
                print(f"  [!] Please run this SQL manually in Supabase SQL Editor:")
                print(f"     https://supabase.com/dashboard/project/_/sql\n")
                print("="*80)
                print(sql)
                print("="*80 + "\n")

            except Exception as e:
                print(f"  [X] ERROR: {e}\n")
                return False

        print("\n" + "="*80)
        print("MIGRATION INSTRUCTIONS")
        print("="*80)
        print("\nTo apply these migrations:")
        print("1. Go to https://supabase.com/dashboard")
        print("2. Select your project")
        print("3. Go to SQL Editor (left sidebar)")
        print("4. Copy and paste each SQL migration above")
        print("5. Click 'Run' to execute")
        print("\nAlternatively, you can run migrations using Supabase CLI:")
        print("  supabase db push")
        print("\n" + "="*80)

        return True

    except ImportError:
        print("ERROR: supabase-py not installed")
        print("Install with: pip install supabase")
        return False
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False


def check_migration_status():
    """Check if migrations have been applied"""
    try:
        from supabase import create_client

        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")

        if not url or not key:
            return False

        supabase = create_client(url, key)

        print("\nChecking migration status...\n")

        # Check if page_cache table exists
        try:
            result = supabase.table('page_cache').select('url_hash', count='exact').limit(0).execute()
            print("[OK] page_cache table exists")
        except Exception:
            print("[--] page_cache table does NOT exist")

        # Check if system_logs table exists
        try:
            result = supabase.table('system_logs').select('id', count='exact').limit(0).execute()
            print("[OK] system_logs table exists")
        except Exception:
            print("[--] system_logs table does NOT exist")

        print()
        return True

    except Exception as e:
        print(f"ERROR checking status: {e}")
        return False


if __name__ == "__main__":
    print("="*80)
    print("CLOUD MIGRATION - DATABASE SETUP")
    print("="*80)
    print("\nThis will set up cloud-based storage for:")
    print("  • Page caching (replaces local cache/ directory)")
    print("  • System logging (replaces local logs/ directory)")
    print()

    # Check current status
    check_migration_status()

    # Show migrations
    print("="*80)
    print("MIGRATIONS TO APPLY")
    print("="*80)
    print()

    success = run_migrations()

    if success:
        print("\n[OK] Migration instructions displayed above")
        sys.exit(0)
    else:
        print("\n[X] Migration failed")
        sys.exit(1)
