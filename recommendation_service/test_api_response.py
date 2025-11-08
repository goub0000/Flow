import json
from app.data_fetchers.college_scorecard import CollegeScorecardFetcher

fetcher = CollegeScorecardFetcher()
data = fetcher.fetch_universities(page=0, per_page=1)

if data['results']:
    print("=== SAMPLE API RESPONSE ===")
    print(json.dumps(data['results'][0], indent=2))
else:
    print("No results found")
