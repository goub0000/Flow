# University Data Import Guide

This guide explains how to import real-time university data into the Find Your Path recommendation system.

## Overview

The system can fetch university data from various sources, starting with the **US Department of Education's College Scorecard API** which provides information on 7,000+ US institutions.

## Quick Start

### 1. Get a College Scorecard API Key (Required)

The College Scorecard API requires an API key for all requests. It's free and takes less than a minute to set up:

1. **Visit**: https://api.data.gov/signup/
2. **Fill out the form** with:
   - First Name
   - Last Name
   - Email Address
   - (Optional) Organization
3. **Submit** - Your API key will be emailed to you instantly
4. **Check your email** for the API key

### 2. Configure Your API Key

Create a `.env` file in the `recommendation_service` directory:

```bash
cd recommendation_service
cp .env.example .env
```

Then edit `.env` and add your API key:

```env
COLLEGE_SCORECARD_API_KEY=your_actual_api_key_here
```

**Important**:
- Never commit `.env` to version control (it's already in `.gitignore`)
- Keep your API key secure

### 3. Install Dependencies

Make sure you have the required Python packages:

```bash
pip install -r requirements.txt
```

This will install:
- `requests` - For API calls
- `python-dotenv` - For environment variable management
- Other required dependencies

### 4. Import Universities

Now you can import university data using the CLI tool:

#### Import 100 universities (quick test):
```bash
python import_universities.py --source collegecard --limit 100
```

#### Import universities from a specific state:
```bash
python import_universities.py --source collegecard --state CA --limit 50
```

#### Import ALL universities (may take a while):
```bash
python import_universities.py --source collegecard --all
```

#### Import specific universities by name:
```bash
python import_universities.py --names "Stanford University" "MIT" "Harvard"
```

#### Show database statistics:
```bash
python import_universities.py --stats
```

## CLI Options

| Option | Description | Example |
|--------|-------------|---------|
| `--source` | Data source (currently only 'collegecard') | `--source collegecard` |
| `--limit N` | Maximum number of universities to import | `--limit 100` |
| `--state XX` | Filter by US state code (2 letters) | `--state CA` |
| `--all` | Import all available universities | `--all` |
| `--names` | Import specific universities by name | `--names "Stanford" "MIT"` |
| `--no-update` | Skip updating existing universities | `--no-update` |
| `--stats` | Show database statistics | `--stats` |

## Data Sources

### College Scorecard API

**Source**: US Department of Education
**Coverage**: 7,000+ US institutions
**Data Includes**:
- Basic information (name, location, website)
- Student body size
- Admissions data (acceptance rate, test scores)
- Financial information (tuition, cost of attendance)
- Outcomes (graduation rates, median earnings)

**Rate Limits**:
- 1,000 requests per hour (default)
- Contact scorecarddata@rti.org for higher limits

**Quality Filters Applied**:
- Only 4-year institutions (predominantly bachelor's degrees)
- Currently operating schools
- At least 100 students
- Public, private nonprofit, and private for-profit institutions

### Future Data Sources (Coming Soon)

- **International universities** - Global rankings and data
- **QS World University Rankings** - Top global institutions
- **Times Higher Education** - International university data
- **Custom CSV imports** - Manual data uploads

## How It Works

### 1. Data Fetching
The `CollegeScorecardFetcher` class (`app/data_fetchers/college_scorecard.py`):
- Connects to the College Scorecard API
- Handles pagination and rate limiting
- Fetches university data in batches

### 2. Data Normalization
The `UniversityDataNormalizer` class (`app/data_fetchers/data_normalizer.py`):
- Validates required fields
- Cleans and converts data types
- Maps API fields to our database schema
- Handles missing or invalid data gracefully

### 3. Database Storage
Universities are saved to the SQLite database with:
- Duplicate detection (by name and country)
- Batch commits (50 records at a time)
- Update existing vs. create new logic

## Troubleshooting

### "API key is required but not found"

**Problem**: The fetcher can't find your API key.

**Solution**:
1. Make sure you created a `.env` file (not `.env.example`)
2. Check that your `.env` file is in the `recommendation_service` directory
3. Verify the API key line: `COLLEGE_SCORECARD_API_KEY=your_key`
4. No spaces around the `=` sign
5. No quotes around the key

### "403 Forbidden" Error

**Problem**: API request is being rejected.

**Solution**:
- Make sure your API key is valid
- Check you haven't exceeded rate limits (1,000 requests/hour)
- Try requesting a new API key if the old one expired

### "No universities found"

**Problem**: API returned zero results.

**Solution**:
- Check your filters (state code, etc.)
- Try without filters: `--limit 10` only
- Check the College Scorecard API status

### Import is Very Slow

**Problem**: Importing thousands of universities takes time.

**Solution**:
- This is normal - rate limiting is in place (0.1s between requests)
- Start with a smaller batch: `--limit 100`
- Consider importing by state if you only need specific regions
- The process can be interrupted with Ctrl+C and resumed later

## Database Schema

Universities are stored with the following fields:

### Basic Information
- `name` - University name
- `country` - Country code (e.g., 'USA')
- `state` - State/province code
- `city` - City name
- `website` - University website
- `description` - Brief description
- `university_type` - Public, Private, etc.
- `location_type` - Urban, Suburban, Rural

### Admissions
- `acceptance_rate` - Overall acceptance rate
- `gpa_average` - Average GPA of admitted students
- `sat_math_25th`, `sat_math_75th` - SAT math score range
- `sat_ebrw_25th`, `sat_ebrw_75th` - SAT reading/writing range
- `act_composite_25th`, `act_composite_75th` - ACT score range

### Financial
- `tuition_out_state` - Out-of-state tuition
- `total_cost` - Total cost of attendance

### Outcomes
- `graduation_rate_4year` - 4-year graduation rate
- `median_earnings_10year` - Median earnings 10 years after entry

### Student Body
- `total_students` - Total enrollment

### Rankings
- `global_rank` - Global ranking (if available)
- `national_rank` - National ranking (if available)

## Examples

### Import top California universities:
```bash
python import_universities.py --source collegecard --state CA --limit 20
```

### Import and view stats:
```bash
python import_universities.py --source collegecard --limit 100
python import_universities.py --stats
```

### Import specific Ivy League schools:
```bash
python import_universities.py --names \
  "Harvard University" \
  "Yale University" \
  "Princeton University" \
  "Columbia University" \
  "University of Pennsylvania" \
  "Brown University" \
  "Dartmouth College" \
  "Cornell University"
```

## Scheduling Automatic Updates

To keep university data up-to-date, you can schedule regular imports:

### Windows (Task Scheduler):
Create a batch file `update_universities.bat`:
```batch
cd C:\path\to\recommendation_service
python import_universities.py --source collegecard --all --update
```

### Linux/Mac (Cron):
Add to crontab:
```bash
0 0 * * 0 cd /path/to/recommendation_service && python import_universities.py --source collegecard --all
```

This runs every Sunday at midnight.

## Support

For issues or questions:
1. Check this README
2. Review error messages - they often include solutions
3. Check the College Scorecard API documentation: https://collegescorecard.ed.gov/data/api-documentation/
4. Contact: scorecarddata@rti.org (for API-specific issues)

## Next Steps

After importing universities:
1. Run `python import_universities.py --stats` to verify data
2. Test recommendations with different student profiles
3. Monitor which universities are being recommended
4. Consider adding international universities (coming soon)
