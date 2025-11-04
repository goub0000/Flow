"""
Import Universities to Supabase
Quick script to import QS Rankings to your Supabase cloud database
"""
import logging
from app.database.supabase_client import get_supabase_client
from app.data_fetchers.supabase_normalizer import SupabaseUniversityDataNormalizer
from app.data_fetchers.kaggle_downloader import KaggleDatasetDownloader
from app.data_fetchers.qs_rankings import QSRankingsCSVImporter

logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)


def import_universities(limit=None):
    """Import universities from Kaggle to Supabase"""

    print("=" * 80)
    print("IMPORTING UNIVERSITIES TO SUPABASE")
    print("=" * 80)
    print()

    # Step 1: Download QS Rankings from Kaggle
    print("[1/4] Downloading QS Rankings from Kaggle...")
    try:
        downloader = KaggleDatasetDownloader()
        csv_file = downloader.download_qs_rankings_2025(force=False)

        if not csv_file:
            print("  ERROR: Failed to download CSV file")
            return False

        print(f"  Downloaded: {csv_file.name}")
    except Exception as e:
        print(f"  ERROR: {e}")
        return False

    print()

    # Step 2: Parse CSV
    print("[2/4] Parsing CSV file...")
    try:
        importer = QSRankingsCSVImporter()
        universities = importer.import_from_csv(str(csv_file), limit=limit)

        if not universities:
            print("  ERROR: No universities found in CSV")
            return False

        print(f"  Parsed: {len(universities)} universities")
    except Exception as e:
        print(f"  ERROR: {e}")
        return False

    print()

    # Step 3: Connect to Supabase
    print("[3/4] Connecting to Supabase...")
    try:
        client = get_supabase_client()
        print("  Connected successfully!")
    except Exception as e:
        print(f"  ERROR: {e}")
        print()
        print("  Make sure you have:")
        print("  1. Created Supabase project")
        print("  2. Run the SQL schema")
        print("  3. Added credentials to .env file")
        return False

    print()

    # Step 4: Import to Supabase
    print(f"[4/4] Importing {len(universities)} universities to Supabase...")
    try:
        normalizer = SupabaseUniversityDataNormalizer()
        stats = normalizer.batch_save_universities(
            universities,
            update_existing=True,
            commit_batch_size=50
        )

        print()
        print("=" * 80)
        print("IMPORT COMPLETE!")
        print("=" * 80)
        print(f"  Added: {stats['added']}")
        print(f"  Updated: {stats['updated']}")
        print(f"  Failed: {stats['failed']}")
        print()

        # Show total count
        total = client.get_table_count('universities')
        print(f"Total universities in Supabase: {total}")
        print("=" * 80)

        return True

    except Exception as e:
        print(f"  ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False


if __name__ == "__main__":
    import sys

    # Check for --limit argument
    limit = None
    if len(sys.argv) > 1:
        try:
            limit = int(sys.argv[1])
            print(f"Limiting import to {limit} universities")
            print()
        except ValueError:
            print("Usage: python import_to_supabase.py [limit]")
            print("Example: python import_to_supabase.py 100")
            sys.exit(1)

    success = import_universities(limit=limit)
    sys.exit(0 if success else 1)
