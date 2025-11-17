"""
Automated RLS Policy Setup Script
Programmatically configures Row Level Security policies in Supabase
"""
import os
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Supabase configuration
SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_SERVICE_ROLE_KEY = os.getenv('SUPABASE_KEY')  # Service role key (not anon key)

if not SUPABASE_URL or not SUPABASE_SERVICE_ROLE_KEY:
    print("Error: SUPABASE_URL and SUPABASE_KEY environment variables required")
    print("Make sure they're set in your .env file")
    exit(1)

# Initialize Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

# Read SQL file
sql_file_path = "setup_rls_policies.sql"

print("=" * 80)
print(" " * 20 + "RLS POLICY SETUP SCRIPT")
print(" " * 15 + "Flow EdTech Platform - Supabase")
print("=" * 80)
print()

try:
    # Read the SQL file
    print(f"[1/3] Reading SQL file: {sql_file_path}")
    with open(sql_file_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    print(f"✓ SQL file loaded ({len(sql_content)} characters)")
    print()

    # Split into individual statements (basic splitting by semicolon)
    print("[2/3] Parsing SQL statements...")
    statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]

    # Filter out comments and DO blocks
    executable_statements = []
    for stmt in statements:
        # Skip pure comment blocks
        if stmt.strip().startswith('--') or stmt.strip().startswith('/*'):
            continue
        # Keep ALTER, DROP, CREATE, DO statements
        if any(stmt.upper().startswith(cmd) for cmd in ['ALTER', 'DROP', 'CREATE', 'DO']):
            executable_statements.append(stmt)

    print(f"✓ Found {len(executable_statements)} executable statements")
    print()

    # Execute statements
    print("[3/3] Executing SQL statements...")
    print()

    success_count = 0
    error_count = 0

    for i, statement in enumerate(executable_statements, 1):
        # Get first line for display
        first_line = statement.split('\n')[0][:60]
        print(f"  [{i}/{len(executable_statements)}] {first_line}...")

        try:
            # Use Supabase REST API to execute SQL via PostgREST
            # Note: This requires the service_role key with elevated permissions
            response = supabase.postgrest.rpc('exec_sql', {'query': statement}).execute()
            print(f"      ✓ Success")
            success_count += 1
        except Exception as e:
            # Some statements might fail gracefully (like DROP IF EXISTS on non-existent policies)
            error_message = str(e)
            if 'does not exist' in error_message or 'already exists' in error_message:
                print(f"      ℹ Skipped (already handled)")
            else:
                print(f"      ✗ Error: {error_message[:80]}")
                error_count += 1

    print()
    print("=" * 80)
    print("EXECUTION SUMMARY")
    print("=" * 80)
    print(f"Total statements: {len(executable_statements)}")
    print(f"Successful: {success_count}")
    print(f"Errors: {error_count}")
    print()

    if error_count == 0:
        print("✓ All policies configured successfully!")
        print()
        print("Next steps:")
        print("1. Go to Supabase Dashboard → Database → applications table")
        print("2. Click 'Policies' tab to verify policies are active")
        print("3. Run your application tests")
    else:
        print("⚠ Some statements failed. This might be normal if:")
        print("  - Policies already existed (DROP IF EXISTS is idempotent)")
        print("  - Tables are already configured")
        print()
        print("To apply manually:")
        print("1. Go to Supabase Dashboard → SQL Editor")
        print("2. Paste contents of setup_rls_policies.sql")
        print("3. Click 'Run' to execute")

    print()
    print("=" * 80)

except FileNotFoundError:
    print(f"✗ Error: SQL file not found: {sql_file_path}")
    print("Make sure setup_rls_policies.sql is in the current directory")
    exit(1)
except Exception as e:
    print(f"✗ Error: {e}")
    print()
    print("ALTERNATIVE METHOD:")
    print("=" * 80)
    print("Since programmatic execution failed, use manual method:")
    print()
    print("1. Open Supabase Dashboard")
    print("2. Go to SQL Editor")
    print("3. Create new query")
    print("4. Copy and paste the entire contents of 'setup_rls_policies.sql'")
    print("5. Click 'Run' button")
    print()
    print("The SQL file contains all necessary policies and is ready to execute.")
    print("=" * 80)
    exit(1)
