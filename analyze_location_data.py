"""
Analyze country and state data quality in universities table
"""
import os
from collections import Counter
from app.database.config import get_supabase

def analyze_location_data():
    db = get_supabase()

    # Get sample of universities
    response = db.table('universities').select('name', 'country', 'state').limit(500).execute()
    universities = response.data

    print("=" * 100)
    print("LOCATION DATA ANALYSIS")
    print("=" * 100)
    print(f"\nTotal universities analyzed: {len(universities)}\n")

    # Analyze countries
    countries = [u.get('country') for u in universities if u.get('country')]
    country_counts = Counter(countries)

    print("\n" + "=" * 100)
    print("TOP 30 COUNTRY VALUES (sorted by frequency):")
    print("=" * 100)
    for country, count in country_counts.most_common(30):
        print(f"{country:30} : {count:5} universities")

    # Analyze states
    states = [u.get('state') for u in universities if u.get('state')]
    state_counts = Counter(states)

    print("\n" + "=" * 100)
    print("TOP 30 STATE VALUES (sorted by frequency):")
    print("=" * 100)
    for state, count in state_counts.most_common(30):
        print(f"{state:30} : {count:5} universities")

    # Show examples of problematic data
    print("\n" + "=" * 100)
    print("SAMPLE UNIVERSITIES WITH LOCATION DATA:")
    print("=" * 100)
    print(f"{'University Name':<50} {'Country':<15} {'State':<25}")
    print("-" * 100)
    for u in universities[:30]:
        name = u.get('name', 'N/A')[:48]
        country = str(u.get('country', 'NULL'))[:13]
        state = str(u.get('state', 'NULL'))[:23]
        print(f"{name:<50} {country:<15} {state:<25}")

    # Identify 2-letter codes (likely ISO codes)
    two_letter_countries = [c for c in countries if len(c) == 2]
    print(f"\n" + "=" * 100)
    print(f"STATISTICS:")
    print("=" * 100)
    print(f"Total unique countries: {len(country_counts)}")
    print(f"Countries with 2-letter codes: {len(set(two_letter_countries))} unique, {len(two_letter_countries)} total")
    print(f"Total unique states: {len(state_counts)}")
    print(f"NULL countries: {sum(1 for u in universities if not u.get('country'))}")
    print(f"NULL states: {sum(1 for u in universities if not u.get('state'))}")

if __name__ == "__main__":
    analyze_location_data()
