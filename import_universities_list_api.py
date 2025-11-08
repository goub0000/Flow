"""
Import universities from Universities List API to Supabase

This script fetches university data from the Hipolabs Universities API
and imports it into the Supabase database.

Coverage: 60+ countries globally (9,000+ universities)
Free API, no authentication required
"""

import sys
import logging
from dotenv import load_dotenv

# Add app directory to path
sys.path.insert(0, '.')

from app.data_fetchers.universities_list_api import UniversitiesListAPIFetcher
from app.data_fetchers.supabase_normalizer import SupabaseUniversityDataNormalizer
from app.database.supabase_client import get_supabase_client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)


def import_universities_list_api(test_mode=False):
    """
    Import universities from Universities List API to Supabase

    Args:
        test_mode: If True, only import first 100 universities for testing
    """
    print("=" * 80)
    print("IMPORTING UNIVERSITIES FROM UNIVERSITIES LIST API")
    print("=" * 80)
    print()

    # Step 1: Initialize API fetcher
    print("[1/4] Initializing Universities List API fetcher...")
    fetcher = UniversitiesListAPIFetcher()
    print(f"  Target: {len(fetcher.TARGET_COUNTRIES)} countries")
    print()

    # Step 2: Fetch universities from API
    print("[2/4] Fetching universities from Universities List API...")
    print("  This may take 2-3 minutes...")
    normalized_universities = fetcher.fetch_and_normalize_all()

    if test_mode:
        normalized_universities = normalized_universities[:100]
        print(f"  TEST MODE: Limited to first 100 universities")

    print(f"  Fetched: {len(normalized_universities)} universities")
    print()

    # Step 3: Connect to Supabase
    print("[3/4] Connecting to Supabase...")
    try:
        client = get_supabase_client()
        print("  Connected to Supabase successfully")
    except ValueError as e:
        print(f"  ERROR: {e}")
        print()
        return False
    print()

    # Step 4: Import to Supabase
    print("[4/4] Importing to Supabase...")
    print("  This may take several minutes...")

    normalizer = SupabaseUniversityDataNormalizer()
    stats = normalizer.batch_save_universities(
        normalized_universities,
        update_existing=True,
        commit_batch_size=50
    )

    print()
    print("=" * 80)
    print("IMPORT COMPLETE")
    print("=" * 80)
    print()
    print(f"  Universities added: {stats['added']}")
    print(f"  Universities updated: {stats['updated']}")
    print(f"  Universities skipped: {stats['skipped']}")
    print(f"  Failed: {stats['failed']}")
    print()

    # Get total count
    total = client.get_table_count('universities')
    print(f"Total universities in Supabase: {total}")
    print()

    return True


def main():
    """Main entry point"""
    # Load environment variables
    load_dotenv()

    # Check for test mode
    test_mode = '--test' in sys.argv or '-t' in sys.argv

    if test_mode:
        print("Running in TEST MODE (first 100 universities only)")
        print()

    # Import universities
    success = import_universities_list_api(test_mode=test_mode)

    if success:
        print("Import completed successfully!")
        print()
        print("Next steps:")
        print("  1. Check Supabase dashboard to verify data")
        print("  2. Run without --test flag to import all universities")
        print("  3. Update GitHub Actions workflow to include this import")
        sys.exit(0)
    else:
        print("Import failed. Check the error messages above.")
        sys.exit(1)


if __name__ == "__main__":
    main()
