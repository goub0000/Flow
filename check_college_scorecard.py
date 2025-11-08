from app.database.supabase_client import get_supabase_client

client = get_supabase_client()

# Check if we have any universities with College Scorecard data (tuition)
response = client.client.table('universities').select('name, country, tuition_out_state, acceptance_rate').not_.is_('tuition_out_state', 'null').limit(5).execute()

if response.data:
    print('College Scorecard data found in database:')
    for uni in response.data:
        print(f'  - {uni["name"]} ({uni["country"]}): Tuition=${uni.get("tuition_out_state", "N/A")}')
    print(f'\nTotal universities with tuition data: at least {len(response.data)}')
else:
    print('No College Scorecard data found in database')
    print('\nThis means College Scorecard import likely failed or data was not extracted properly')
