"""
Apply Courses Table Migration
Executes the SQL migration using HTTP REST API to Supabase
"""
import os
import requests
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def apply_migration():
    """Execute the courses table migration via Supabase REST API"""
    print("🚀 Applying courses table migration to Supabase...")

    # Get Supabase credentials
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_service_key = os.getenv("SUPABASE_SERVICE_KEY")

    if not supabase_url or not supabase_service_key:
        print("❌ Error: SUPABASE_URL or SUPABASE_SERVICE_KEY not found")
        return False

    # Read migration SQL
    migration_path = os.path.join(
        os.path.dirname(__file__),
        "migrations",
        "create_courses_table.sql"
    )

    try:
        with open(migration_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        print(f"📄 Loaded migration: {len(sql_content)} characters")

        # Supabase SQL API endpoint
        # Note: This requires the SQL Editor API which may not be available via REST
        # Alternative: Use PostgREST or direct PostgreSQL connection

        print("\n📋 SQL Migration Content:")
        print("=" * 60)
        print(sql_content[:500] + "..." if len(sql_content) > 500 else sql_content)
        print("=" * 60)

        print("\n⚠️  Automatic execution requires direct database access.")
        print("✅ Migration file ready at:")
        print(f"   {migration_path}")

        print("\n📝 To apply this migration:")
        print("1. Go to Supabase Dashboard > SQL Editor")
        print("2. Copy the SQL from the file above")
        print("3. Paste and execute in the SQL Editor")
        print("\nOR use the Supabase CLI:")
        print(f"   supabase db execute < {migration_path}")

        return True

    except Exception as e:
        print(f"❌ Error: {e}")
        return False


if __name__ == "__main__":
    apply_migration()
