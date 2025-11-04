"""
Import THE World University Rankings from Kaggle to Supabase

This script downloads THE Rankings data from Kaggle
and imports it into the Supabase database.

Coverage: 1,500+ universities globally
Data Source: Kaggle (raymondtoo/the-world-university-rankings-2016-2024)
"""

import sys
import logging
from dotenv import load_dotenv

# Add app directory to path
sys.path.insert(0, '.')

from app.data_fetchers.kaggle_downloader import KaggleDatasetDownloader
from app.data_fetchers.the_rankings import THERankingsCSVImporter
from app.data_fetchers.supabase_normalizer import SupabaseUniversityDataNormalizer
from app.database.supabase_client import get_supabase_client

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)


def import_the_rankings(test_mode=False):
    """
    Import THE World University Rankings from Kaggle to Supabase

    Args:
        test_mode: If True, only import first 100 universities for testing
    """
    print("=" * 80)
    print("IMPORTING THE WORLD UNIVERSITY RANKINGS FROM KAGGLE")
    print("=" * 80)
    print()

    # Step 1: Download from Kaggle
    print("[1/4] Downloading THE Rankings from Kaggle...")
    try:
        downloader = KaggleDatasetDownloader()
        csv_file = downloader.download_the_rankings(force=False)

        if not csv_file:
            print("  ERROR: Failed to find THE Rankings CSV file")
            return False

        print(f"  Downloaded: {csv_file.name}")
    except Exception as e:
        print(f"  ERROR: {e}")
        print()
        return False
    print()

    # Step 2: Parse CSV
    print("[2/4] Parsing THE Rankings CSV...")
    try:
        importer = THERankingsCSVImporter()
        universities = importer.import_from_csv(str(csv_file))

        if test_mode:
            universities = universities[:100]
            print(f"  TEST MODE: Limited to first 100 universities")

        print(f"  Parsed: {len(universities)} universities")
    except Exception as e:
        print(f"  ERROR: {e}")
        print()
        return False
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
        universities,
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
    success = import_the_rankings(test_mode=test_mode)

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
