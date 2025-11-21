"""
Run Courses Table Migration
Executes the SQL migration to create the courses table in Supabase
"""
import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Load environment variables
load_dotenv()

def run_migration():
    """Execute the courses table migration"""
    print("🚀 Starting courses table migration...")

    # Get Supabase credentials
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_SERVICE_KEY")  # Use service key for admin operations

    if not supabase_url or not supabase_key:
        print("❌ Error: SUPABASE_URL or SUPABASE_SERVICE_KEY not found in environment")
        return False

    # Create Supabase client
    supabase: Client = create_client(supabase_url, supabase_key)

    # Read migration SQL
    migration_path = os.path.join(
        os.path.dirname(__file__),
        "migrations",
        "create_courses_table.sql"
    )

    try:
        with open(migration_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        print(f"📄 Loaded migration from: {migration_path}")
        print(f"📝 SQL length: {len(sql_content)} characters")

        # Execute migration using RPC or direct SQL
        # Note: Supabase Python client doesn't have direct SQL execution
        # We need to use the REST API or PostgreSQL connection

        print("\n⚠️  Migration file created successfully!")
        print("📋 Please execute this migration manually using one of these methods:")
        print("\n1. Supabase Dashboard:")
        print("   - Go to: https://app.supabase.com/project/wmuarotbdjhqbyjyslqg/sql")
        print("   - Copy and paste the contents of:")
        print(f"     {migration_path}")
        print("   - Click 'Run' to execute")

        print("\n2. Direct PostgreSQL connection:")
        print("   - Use psql or any PostgreSQL client")
        print("   - Connect to your Supabase database")
        print(f"   - Execute: \\i {migration_path}")

        print("\n3. Python with psycopg2:")
        print("   - Install: pip install psycopg2-binary")
        print("   - Use the DATABASE_URL from Supabase settings")

        return True

    except FileNotFoundError:
        print(f"❌ Error: Migration file not found at {migration_path}")
        return False
    except Exception as e:
        print(f"❌ Error reading migration file: {e}")
        return False


if __name__ == "__main__":
    success = run_migration()
    if success:
        print("\n✅ Next steps:")
        print("1. Execute the SQL migration in Supabase Dashboard")
        print("2. Verify the table was created: SELECT * FROM courses LIMIT 1;")
        print("3. Test the API: curl https://web-production-51e34.up.railway.app/api/v1/courses")
    else:
        print("\n❌ Migration preparation failed")
