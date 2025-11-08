"""
Migrate Configuration from .env to Supabase
Uploads all .env values to app_config table
"""

import os
from pathlib import Path
from dotenv import load_dotenv

def migrate_config():
    """Migrate .env configuration to Supabase"""

    print("=" * 80)
    print("CONFIG MIGRATION - .env to Supabase")
    print("=" * 80)
    print()

    # Load .env file
    env_file = Path(".env")
    if not env_file.exists():
        print(f"ERROR: .env file not found at {env_file.absolute()}")
        return False

    load_dotenv()

    # Get Supabase credentials (bootstrap)
    supabase_url = os.environ.get("SUPABASE_URL")
    supabase_key = os.environ.get("SUPABASE_KEY")

    if not supabase_url or not supabase_key:
        print("ERROR: SUPABASE_URL and SUPABASE_KEY must be in .env file")
        return False

    try:
        from supabase import create_client

        print("Connecting to Supabase...")
        supabase = create_client(supabase_url, supabase_key)
        print("Connected successfully!\n")

        # Read all values from .env
        config_values = {}
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    key = key.strip()
                    value = value.strip().strip('"').strip("'")
                    config_values[key] = value

        print(f"Found {len(config_values)} configuration values in .env\n")

        # Upload each value to Supabase
        print("Uploading to Supabase app_config table...")
        print("-" * 80)

        uploaded = 0
        skipped = 0

        for key, value in config_values.items():
            try:
                # Check if it's a secret (contains sensitive keywords)
                is_secret = any(word in key.upper() for word in ['KEY', 'SECRET', 'PASSWORD', 'TOKEN'])

                # Upsert to app_config table
                data = {
                    'key': key,
                    'value': value,
                    'is_secret': is_secret
                }

                supabase.table('app_config').upsert(data).execute()

                # Show uploaded (hide secrets)
                display_value = value
                if is_secret and len(value) > 10:
                    display_value = value[:5] + '...' + value[-3:]

                print(f"[OK] {key}: {display_value}")
                uploaded += 1

            except Exception as e:
                print(f"[ERROR] {key}: {e}")
                skipped += 1

        print("-" * 80)
        print(f"\nUploaded: {uploaded}")
        print(f"Skipped: {skipped}")
        print()

        # Verify by reading back
        print("Verifying upload...")
        response = supabase.table('app_config').select('key').execute()

        if response.data:
            print(f"[OK] Verified: {len(response.data)} keys in Supabase")
        else:
            print("[ERROR] Verification failed: No keys found")
            return False

        print()
        print("=" * 80)
        print("MIGRATION COMPLETE!")
        print("=" * 80)
        print()
        print("Next steps:")
        print("1. The system will now read config from Supabase automatically")
        print("2. You still need SUPABASE_URL and SUPABASE_KEY in .env (bootstrap)")
        print("3. All other config is now in Supabase")
        print()
        print("To view config in Supabase:")
        print("  SELECT * FROM app_config;")
        print()

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


if __name__ == "__main__":
    success = migrate_config()
    exit(0 if success else 1)
