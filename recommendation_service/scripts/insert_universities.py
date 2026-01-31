"""
Insert Universities from Excel file into Supabase
"""
import os
import sys

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from dotenv import load_dotenv
load_dotenv()

import pandas as pd
from supabase import create_client


def get_supabase_client():
    """Get Supabase client"""
    url = os.environ.get('SUPABASE_URL')
    key = os.environ.get('SUPABASE_KEY') or os.environ.get('SUPABASE_SERVICE_ROLE_KEY')

    if not url or not key:
        raise ValueError("SUPABASE_URL and SUPABASE_KEY environment variables required")

    return create_client(url, key)


def parse_excel_data(file_path):
    """Parse the Excel file with tab-separated data"""
    df = pd.read_excel(file_path)
    first_col = df.columns[0]

    rows = []
    for val in df[first_col].dropna():
        parts = str(val).split('\t')
        if len(parts) >= 10:
            row = {
                'country': parts[0].strip(),
                'name': parts[1].strip(),
                'website': parts[2].strip() if parts[2].strip() else None,
                'state': parts[3].strip() if parts[3].strip() else None,
                'city': parts[4].strip() if parts[4].strip() else None,
                'university_type': parts[5].strip() if parts[5].strip() else None,
                'total_students': int(parts[6]) if parts[6].strip().isdigit() else None,
                'acceptance_rate': float(parts[7]) / 100 if parts[7].strip() and parts[7].strip().replace('.', '').isdigit() else None,
                'location_type': parts[8].strip() if parts[8].strip() and parts[8].strip() != 'Various' else None,
                'tuition_out_state': float(parts[9]) if parts[9].strip() and parts[9].strip().replace('.', '').isdigit() else None,
            }

            # Convert country codes to full names
            if row['country'] == 'USA':
                row['country'] = 'United States'

            # Skip entries with "Various" as city
            if row['city'] == 'Various':
                row['city'] = None

            rows.append(row)

    return rows


def insert_universities(file_path, dry_run=True):
    """Insert universities from Excel file"""
    db = get_supabase_client()

    print("=" * 60)
    print("University Insert Script")
    print("=" * 60)
    print(f"Mode: {'DRY RUN (no changes)' if dry_run else 'LIVE (making changes)'}")
    print(f"File: {file_path}")
    print()

    # Parse Excel data
    print("Parsing Excel file...")
    universities = parse_excel_data(file_path)
    print(f"Found {len(universities)} universities to insert")
    print()

    # Show sample data
    print("Sample data (first 5):")
    for i, univ in enumerate(universities[:5]):
        print(f"  {i+1}. {univ['name']} - {univ['city']}, {univ['state']} ({univ['university_type']})")
    print()

    print(f"Universities to upsert: {len(universities)}")
    print("  (Existing records with same name+country will be updated, new ones inserted)")
    print()

    if not universities:
        print("No universities to process.")
        return

    if not dry_run:
        print(f"Upserting {len(universities)} universities...")

        # Upsert in batches of 50 — uses ON CONFLICT (name, country) to avoid duplicates
        batch_size = 50
        upserted = 0

        for i in range(0, len(universities), batch_size):
            batch = universities[i:i + batch_size]
            try:
                db.table('universities').upsert(
                    batch, on_conflict='name,country'
                ).execute()
                upserted += len(batch)
                print(f"  Upserted batch {i // batch_size + 1}: {len(batch)} universities (total: {upserted})")
            except Exception as e:
                print(f"  Error upserting batch: {e}")
                # Try one by one
                for univ in batch:
                    try:
                        db.table('universities').upsert(
                            univ, on_conflict='name,country'
                        ).execute()
                        upserted += 1
                    except Exception as e2:
                        print(f"    Failed to upsert {univ['name']}: {e2}")

        print(f"\nSuccessfully upserted {upserted} universities")
    else:
        print(f"[DRY RUN] Would upsert {len(universities)} universities")
        print("\nUniversities to be upserted:")
        for univ in universities[:20]:
            print(f"  - {univ['name']} ({univ['city']}, {univ['state']})")
        if len(universities) > 20:
            print(f"  ... and {len(universities) - 20} more")

    print()
    print("=" * 60)
    print("Done!")
    print("=" * 60)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Insert universities from Excel file')
    parser.add_argument('file', help='Path to Excel file')
    parser.add_argument('--live', action='store_true', help='Actually make changes (default is dry-run)')
    args = parser.parse_args()

    insert_universities(args.file, dry_run=not args.live)
