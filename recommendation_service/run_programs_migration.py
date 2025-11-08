"""
Run Programs Table Migration on Supabase
"""
import os
from dotenv import load_dotenv
from app.database.config import get_supabase

# Load environment variables
load_dotenv()

def run_migration():
    """Run the programs table migration"""
    print("Running programs table migration...")

    # Read the migration SQL file
    with open('migrations/create_programs_table.sql', 'r') as f:
        migration_sql = f.read()

    # Get Supabase client
    supabase = get_supabase()

    try:
        # Execute the migration using RPC call
        # Note: Supabase Python client doesn't directly support executing raw SQL
        # We need to execute this through the SQL Editor in Supabase dashboard
        # OR use psycopg2 with connection string

        print("\nMigration SQL:")
        print("=" * 80)
        print(migration_sql)
        print("=" * 80)

        print("\nTo run this migration:")
        print("1. Go to your Supabase dashboard: https://app.supabase.com/project/wmuarotbdjhqbyjyslqg/editor")
        print("2. Go to SQL Editor")
        print("3. Copy and paste the migration SQL above")
        print("4. Click 'Run'")
        print("\nAlternatively, you can run it using psycopg2:")
        print("  python -c \"import psycopg2; conn = psycopg2.connect('YOUR_CONNECTION_STRING'); ...\"")

        # Try using postgrest directly to check if table exists
        try:
            result = supabase.table('programs').select('id').limit(1).execute()
            print("\n✅ Programs table already exists!")
            print(f"   Found {len(result.data)} rows")
        except Exception as e:
            print(f"\n⚠️  Programs table does not exist yet. Please run the migration in Supabase SQL Editor.")
            print(f"   Error: {e}")

    except Exception as e:
        print(f"Error: {e}")
        return False

    return True

if __name__ == "__main__":
    run_migration()
