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

    # Get existing universities to avoid duplicates
    print("Checking for existing universities...")
    existing = set()

    # Fetch in batches
    offset = 0
    batch_size = 1000
    while True:
        response = db.table('universities').select('name').range(offset, offset + batch_size - 1).execute()
        if not response.data:
            break
        for uni in response.data:
            existing.add(uni['name'].lower().strip())
        offset += batch_size
        if len(response.data) < batch_size:
            break

    print(f"Found {len(existing)} existing universities in database")

    # Prepare records for insertion
    new_records = []
    skipped = 0

    for uni in universities:
        name = uni['university_name'].strip()

        # Check for duplicates
        if name.lower() in existing:
            skipped += 1
            continue

        # Map CSV columns to database schema
        record = {
            'name': name,
            'country': uni['country'].strip(),
            'state': uni.get('state', '').strip() or None,
            'city': uni.get('city', '').strip() or None,
            'website': uni.get('website', '').strip() or None,
            'university_type': uni.get('type', '').strip() or None,
            'total_students': parse_students(uni.get('total_students')),
            'acceptance_rate': parse_acceptance_rate(uni.get('acceptance_rate')),
            'location_type': uni.get('location_type', '').strip() or None,
            'tuition_out_state': parse_tuition(uni.get('tuition_intl_usd')),
            'created_at': datetime.utcnow().isoformat(),
            'updated_at': datetime.utcnow().isoformat(),
        }

        # Add https:// to website if missing
        if record['website'] and not record['website'].startswith('http'):
            record['website'] = f"https://{record['website']}"

        new_records.append(record)
        existing.add(name.lower())  # Prevent duplicates within CSV

    print(f"New universities to import: {len(new_records)}")
    print(f"Skipped (already exist): {skipped}")

    if dry_run:
        print("\n[DRY RUN] No changes made")
        print("\nSample records:")
        for r in new_records[:3]:
            print(f"  - {r['name']} ({r['country']})")
        return

    # Insert in batches
    batch_size = 100
    inserted = 0
    errors = 0

    for i in range(0, len(new_records), batch_size):
        batch = new_records[i:i + batch_size]
        try:
            db.table('universities').insert(batch).execute()
            inserted += len(batch)
            print(f"Inserted {inserted}/{len(new_records)} universities...")
        except Exception as e:
            print(f"Error inserting batch: {e}")
            # Try one by one
            for record in batch:
                try:
                    db.table('universities').insert(record).execute()
                    inserted += 1
                except Exception as e2:
                    print(f"  Failed: {record['name']} - {e2}")
                    errors += 1

    print(f"\n=== IMPORT COMPLETE ===")
    print(f"Inserted: {inserted}")
    print(f"Errors: {errors}")
    print(f"Skipped: {skipped}")
    print(f"Total in database: {len(existing)}")

if __name__ == "__main__":
    import sys

    csv_path = r"c:\Users\ogoub\Downloads\african_universities_comprehensive.csv"

    # Check for dry-run flag
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("Running in DRY RUN mode...")

    import_universities(csv_path, dry_run=dry_run)
