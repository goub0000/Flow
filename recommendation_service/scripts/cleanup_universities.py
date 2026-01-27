"""
Database Cleanup Script: Universities
Removes duplicates and cleans special characters from university names
"""
import os
import sys
import re
from collections import defaultdict

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

from supabase import create_client


def get_supabase_client():
    """Get Supabase client"""
    url = os.environ.get('SUPABASE_URL')
    key = os.environ.get('SUPABASE_KEY') or os.environ.get('SUPABASE_SERVICE_ROLE_KEY')

    if not url or not key:
        raise ValueError("SUPABASE_URL and SUPABASE_KEY environment variables required")

    return create_client(url, key)


def clean_university_name(name: str) -> str:
    """Clean special characters from university name"""
    if not name:
        return name

    # Remove various quote characters
    cleaned = name.replace('"', '')
    cleaned = cleaned.replace('"', '')  # Left double quote
    cleaned = cleaned.replace('"', '')  # Right double quote
    cleaned = cleaned.replace("'", "'")  # Smart single quote to regular
    cleaned = cleaned.replace("'", "'")  # Smart single quote to regular
    cleaned = cleaned.replace('„', '')   # Low double quote
    cleaned = cleaned.replace('«', '')   # Left guillemet
    cleaned = cleaned.replace('»', '')   # Right guillemet

    # Strip extra whitespace
    cleaned = ' '.join(cleaned.split())

    return cleaned.strip()


def find_duplicates(universities):
    """Find duplicate universities by name"""
    name_to_universities = defaultdict(list)

    for univ in universities:
        # Normalize name for comparison
        normalized = clean_university_name(univ.get('name', '')).lower().strip()
        if normalized:
            name_to_universities[normalized].append(univ)

    # Return groups with more than one university
    duplicates = {name: univs for name, univs in name_to_universities.items() if len(univs) > 1}
    return duplicates


def calculate_completeness(university):
    """Calculate how complete a university record is"""
    important_fields = [
        'name', 'country', 'state', 'city', 'website',
        'total_cost', 'acceptance_rate', 'gpa_average',
        'sat_math_25th', 'sat_math_75th', 'sat_ebrw_25th', 'sat_ebrw_75th',
        'graduation_rate_4year', 'median_earnings_10year',
        'university_type', 'location_type', 'total_students'
    ]

    score = 0
    for field in important_fields:
        if university.get(field) is not None:
            score += 1

    return score


def cleanup_universities(dry_run=True):
    """Main cleanup function"""
    db = get_supabase_client()

    print("=" * 60)
    print("University Database Cleanup Script")
    print("=" * 60)
    print(f"Mode: {'DRY RUN (no changes)' if dry_run else 'LIVE (making changes)'}")
    print()

    # Fetch all universities
    print("Fetching universities...")
    response = db.table('universities').select('*').execute()
    universities = response.data
    print(f"Total universities in database: {len(universities)}")
    print()

    # Step 1: Find duplicates
    print("-" * 60)
    print("STEP 1: Finding duplicate universities")
    print("-" * 60)

    duplicates = find_duplicates(universities)

    if duplicates:
        print(f"Found {len(duplicates)} duplicate groups:")

        ids_to_delete = []

        for name, univs in duplicates.items():
            print(f"\n  '{name}' - {len(univs)} copies:")

            # Sort by completeness (most complete first)
            univs_sorted = sorted(univs, key=calculate_completeness, reverse=True)

            # Keep the most complete one
            keep = univs_sorted[0]
            delete = univs_sorted[1:]

            print(f"    KEEP: ID {keep['id']} (completeness: {calculate_completeness(keep)})")
            for d in delete:
                print(f"    DELETE: ID {d['id']} (completeness: {calculate_completeness(d)})")
                ids_to_delete.append(d['id'])

        if ids_to_delete and not dry_run:
            print(f"\nDeleting {len(ids_to_delete)} duplicate records...")
            for univ_id in ids_to_delete:
                try:
                    # First delete related programs (column is institution_id)
                    db.table('programs').delete().eq('institution_id', univ_id).execute()
                except Exception as e:
                    print(f"  Note: No programs to delete for ID {univ_id}")
                # Then delete the university
                db.table('universities').delete().eq('id', univ_id).execute()
            print(f"Deleted {len(ids_to_delete)} duplicates")
        elif ids_to_delete:
            print(f"\n[DRY RUN] Would delete {len(ids_to_delete)} duplicate records")
    else:
        print("No duplicates found")

    print()

    # Step 2: Clean special characters
    print("-" * 60)
    print("STEP 2: Cleaning special characters from names")
    print("-" * 60)

    names_to_clean = []

    for univ in universities:
        original_name = univ.get('name', '')
        cleaned_name = clean_university_name(original_name)

        if original_name != cleaned_name:
            names_to_clean.append({
                'id': univ['id'],
                'original': original_name,
                'cleaned': cleaned_name
            })

    if names_to_clean:
        print(f"Found {len(names_to_clean)} names with special characters:")

        for item in names_to_clean[:20]:  # Show first 20
            print(f"  ID {item['id']}: '{item['original']}' -> '{item['cleaned']}'")

        if len(names_to_clean) > 20:
            print(f"  ... and {len(names_to_clean) - 20} more")

        if not dry_run:
            print(f"\nUpdating {len(names_to_clean)} university names...")
            for item in names_to_clean:
                db.table('universities').update({'name': item['cleaned']}).eq('id', item['id']).execute()
            print(f"Updated {len(names_to_clean)} names")
        else:
            print(f"\n[DRY RUN] Would update {len(names_to_clean)} university names")
    else:
        print("No names with special characters found")

    print()
    print("=" * 60)
    print("Cleanup complete!")
    print("=" * 60)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Clean up university database')
    parser.add_argument('--live', action='store_true', help='Actually make changes (default is dry-run)')
    args = parser.parse_args()

    cleanup_universities(dry_run=not args.live)
