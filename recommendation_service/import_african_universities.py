"""
Import African Universities from CSV to Supabase
"""
import csv
import os
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables
os.chdir(os.path.dirname(os.path.abspath(__file__)))
load_dotenv()

from app.database.config import get_supabase

def parse_acceptance_rate(value):
    """Convert acceptance rate to decimal"""
    if not value or value.lower() == 'open':
        return None  # Open admission = no specific rate
    try:
        # Remove % and convert to decimal
        if '%' in str(value):
            return float(value.replace('%', '')) / 100
        return float(value)
    except:
        return None

def parse_students(value):
    """Parse student count"""
    try:
        return int(str(value).replace(',', ''))
    except:
        return None

def parse_tuition(value):
    """Parse tuition as float"""
    try:
        return float(str(value).replace(',', '').replace('$', ''))
    except:
        return None

def import_universities(csv_path: str, dry_run: bool = False):
    """Import universities from CSV"""

    db = get_supabase()

    # Read CSV
    universities = []
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            universities.append(row)

    print(f"Found {len(universities)} universities in CSV")

    # Prepare records for upsert (dedup handled by DB unique constraint on name+country)
    records = []
    seen = set()  # Deduplicate within the CSV itself

    for uni in universities:
        name = uni['university_name'].strip()
        country = uni['country'].strip()
        key = (name.lower(), country.lower())

        if key in seen:
            continue
        seen.add(key)

        # Map CSV columns to database schema
        record = {
            'name': name,
            'country': country,
            'state': uni.get('state', '').strip() or None,
            'city': uni.get('city', '').strip() or None,
            'website': uni.get('website', '').strip() or None,
            'university_type': uni.get('type', '').strip() or None,
            'total_students': parse_students(uni.get('total_students')),
            'acceptance_rate': parse_acceptance_rate(uni.get('acceptance_rate')),
            'location_type': uni.get('location_type', '').strip() or None,
            'tuition_out_state': parse_tuition(uni.get('tuition_intl_usd')),
            'updated_at': datetime.utcnow().isoformat(),
        }

        # Add https:// to website if missing
        if record['website'] and not record['website'].startswith('http'):
            record['website'] = f"https://{record['website']}"

        records.append(record)

    print(f"Universities to upsert: {len(records)}")
    print(f"Duplicates within CSV: {len(universities) - len(records)}")

    if dry_run:
        print("\n[DRY RUN] No changes made")
        print("\nSample records:")
        for r in records[:3]:
            print(f"  - {r['name']} ({r['country']})")
        return

    # Upsert in batches — ON CONFLICT (name, country) updates existing records
    batch_size = 100
    upserted = 0
    errors = 0

    for i in range(0, len(records), batch_size):
        batch = records[i:i + batch_size]
        try:
            db.table('universities').upsert(
                batch, on_conflict='name,country'
            ).execute()
            upserted += len(batch)
            print(f"Upserted {upserted}/{len(records)} universities...")
        except Exception as e:
            print(f"Error upserting batch: {e}")
            # Try one by one
            for record in batch:
                try:
                    db.table('universities').upsert(
                        record, on_conflict='name,country'
                    ).execute()
                    upserted += 1
                except Exception as e2:
                    print(f"  Failed: {record['name']} - {e2}")
                    errors += 1

    print(f"\n=== IMPORT COMPLETE ===")
    print(f"Upserted: {upserted}")
    print(f"Errors: {errors}")

if __name__ == "__main__":
    import sys

    csv_path = r"c:\Users\ogoub\Downloads\african_universities_comprehensive.csv"

    # Check for dry-run flag
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("Running in DRY RUN mode...")

    import_universities(csv_path, dry_run=dry_run)
