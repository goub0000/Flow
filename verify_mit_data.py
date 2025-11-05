"""
Verify data improvements for MIT after parser fixes
"""
from app.database.supabase_client import get_supabase_client

client = get_supabase_client()

# Get MIT data
response = client.client.table('universities').select('*').ilike('name', '%Massachusetts Institute of Technology%').execute()

if response.data:
    uni = response.data[0]
    print('=' * 80)
    print('MIT DATA AFTER PARSER FIXES')
    print('=' * 80)
    print()

    # Show all fields
    for field, value in sorted(uni.items()):
        if value is not None:
            if isinstance(value, str) and len(str(value)) > 100:
                print(f'{field}: {str(value)[:100]}...')
            else:
                print(f'{field}: {value}')

    print()
    print('-' * 80)

    # Count non-NULL fields
    non_null = len([v for v in uni.values() if v is not None])
    total = len(uni)
    print(f'Non-NULL fields: {non_null}/{total} ({non_null/total*100:.1f}%)')
    print()

    # Highlight key improvements
    print('KEY DATA POINTS:')
    print(f'  Global Rank: {uni.get("global_rank", "NULL")}')
    print(f'  Website: {uni.get("website", "NULL")}')
    print(f'  Country Code: {uni.get("country", "NULL")}')
    print(f'  Description: {uni.get("description", "NULL")[:80]}...')
    print()
else:
    print('ERROR: MIT not found in database')
