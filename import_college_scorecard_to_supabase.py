"""
Import USA Universities from College Scorecard to Supabase
Fetches detailed data on 7,000+ US institutions from the Department of Education
"""
import logging
from app.database.supabase_client import get_supabase_client
from app.data_fetchers.college_scorecard import CollegeScorecardFetcher
from app.data_fetchers.supabase_normalizer import SupabaseUniversityDataNormalizer

logging.basicConfig(
    level=logging.INFO,
    format='%(levelname)s: %(message)s'
)
logger = logging.getLogger(__name__)


def import_college_scorecard_universities(limit=None):
    """Import USA universities from College Scorecard to Supabase"""

    print("=" * 80)
    print("IMPORTING USA UNIVERSITIES FROM COLLEGE SCORECARD TO SUPABASE")
    print("=" * 80)
    print()

    # Step 1: Initialize College Scorecard API
    print("[1/4] Initializing College Scorecard API...")
    try:
        fetcher = CollegeScorecardFetcher()
        print("  Connected to College Scorecard API successfully!")
    except Exception as e:
        print(f"  ERROR: {e}")
        return False

    print()

    # Step 2: Fetch universities from College Scorecard
    print(f"[2/4] Fetching USA universities from College Scorecard...")
    print("  This may take several minutes for large datasets...")
    try:
        raw_universities = fetcher.fetch_all_universities(max_results=limit)

        if not raw_universities:
            print("  ERROR: No universities fetched from College Scorecard")
            return False

        print(f"  Fetched: {len(raw_universities)} universities")
    except Exception as e:
        print(f"  ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

    print()

    # Step 3: Normalize data
    print("[3/4] Normalizing university data...")
    try:
        normalized_universities = []
        for raw_uni in raw_universities:
            normalized = fetcher.normalize_university_data(raw_uni)
            if normalized and normalized.get('name'):
                normalized_universities.append(normalized)

        print(f"  Normalized: {len(normalized_universities)} universities")
    except Exception as e:
        print(f"  ERROR: {e}")
        import traceback
        traceback.print_exc()
        return False

    print()

    # Step 4: Connect to Supabase
    print("[4/5] Connecting to Supabase...")
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

    # Step 5: Import to Supabase
    print(f"[5/5] Importing {len(normalized_universities)} universities to Supabase...")
    try:
        normalizer = SupabaseUniversityDataNormalizer()
        stats = normalizer.batch_save_universities(
            normalized_universities,
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
            print("Usage: python import_college_scorecard_to_supabase.py [limit]")
            print("Example: python import_college_scorecard_to_supabase.py 100")
            sys.exit(1)

    success = import_college_scorecard_universities(limit=limit)
    sys.exit(0 if success else 1)
