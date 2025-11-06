# 🌍 Location Data Cleaning System

## System Overview

Automated cloud-based system to clean and normalize country and state data in the universities database. Converts ISO country codes to full names, fixes state abbreviations, and removes invalid values.

---

## ✅ What Gets Cleaned

### Country Data
- **2-letter ISO codes → Full names**: `US` → `United States`, `GB` → `United Kingdom`
- **"XX" placeholders → NULL**: Removes unknown country placeholders
- **Comprehensive mapping**: 50+ countries supported

### State Data (USA & Canada)
- **US state codes → Full names**: `CA` → `California`, `TX` → `Texas`, `NY` → `New York`
- **Canadian provinces → Full names**: `ON` → `Ontario`, `QC` → `Quebec`, `BC` → `British Columbia`
- **Invalid values removed**: Scraped text fragments like "the", "the United", "each", "our"
- **City names in state field → NULL**: Removes misplaced city names

---

## 📊 Data Quality (Before Cleaning)

From analysis of sample 1000 universities:

| Metric | Count | Percentage |
|--------|-------|------------|
| 2-letter country codes | 965 | 96.5% |
| "XX" placeholder countries | 229 | 22.9% |
| NULL states | 812 | 81.2% |
| Invalid state values | ~50 | ~5% |

**Top invalid state values**: "the", "the United", "each", "our", "achieved"

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│             Supabase PostgreSQL Database                 │
│          17,137 Universities with Location Data          │
│              pg_cron Extension Enabled                   │
└────────────────┬────────────────────────────────────────┘
                 │
        Weekly 4 AM Sun UTC (or on-demand)
                 │
     ┌───────────▼──────────────┐
     │  Location Cleaning       │
     │  Cron Job                │
     └───────────┬──────────────┘
                 │
                 │   HTTP POST
                 ▼
┌─────────────────────────────────────────────────────────┐
│          Railway: FastAPI Service (Python)              │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Location Cleaning API                            │  │
│  │ - Country code mapping (ISO → full names)        │  │
│  │ - State code mapping (US states, CA provinces)   │  │
│  │ - Invalid value detection & removal              │  │
│  │ - Batch processing (100 universities per batch)  │  │
│  │ - Progress tracking & status reporting           │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 Technical Implementation

### Files Created

1. **`app/enrichment/location_cleaner.py`** - Core cleaning logic
   - `COUNTRY_CODE_MAP`: ISO 3166-1 alpha-2 codes → full country names
   - `US_STATE_MAP`: 2-letter state codes → full state names (50 states + territories)
   - `CANADIAN_PROVINCE_MAP`: 2-letter province codes → full province names (13 provinces/territories)
   - `INVALID_STATE_VALUES`: Set of known invalid scraped text fragments
   - `clean_country()`: Converts country codes
   - `clean_state()`: Converts state codes and removes invalid values
   - `clean_all_locations()`: Processes all universities in batches

2. **`app/api/location_cleaning.py`** - REST API endpoints
   - `POST /api/v1/location-cleaning/start` - Start cleaning job
   - `GET /api/v1/location-cleaning/status/{job_id}` - Check job progress
   - `GET /api/v1/location-cleaning/preview` - Preview changes (no update)
   - `POST /api/v1/location-cleaning/clean-all` - Quick start endpoint
   - `GET /api/v1/location-cleaning/analyze` - Analyze data quality

3. **`setup_location_cleaning_cron.sql`** - Supabase cron job setup

---

## 📡 API Endpoints

### Start Cleaning
```bash
POST https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all

Response:
{
  "job_id": "clean_20251106_170000_abc12345",
  "status": "pending",
  "message": "Location cleaning job started..."
}
```

### Check Status
```bash
GET https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/status/{job_id}

Response:
{
  "job_id": "clean_20251106_170000_abc12345",
  "status": "completed",
  "total_processed": 17137,
  "countries_updated": 16500,
  "states_updated": 150,
  "states_nullified": 400,
  "errors": 0,
  "message": "Cleaned 16500 countries and 150 states"
}
```

### Preview Changes (No Update)
```bash
GET https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/preview?limit=20

Response:
{
  "total_changes": 19,
  "sample_changes": [
    {
      "name": "University of Chicago",
      "country_before": "US",
      "country_after": "United States",
      "state_before": "the United",
      "state_after": null
    }
  ]
}
```

### Analyze Data Quality
```bash
GET https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/analyze

Response:
{
  "total_analyzed": 1000,
  "countries": {
    "total_with_country": 1000,
    "total_null": 0,
    "unique_values": 54,
    "two_letter_codes": 965,
    "xx_placeholder": 229,
    "top_10_values": {"XX": 229, "US": 109, "GB": 67, ...}
  },
  "states": {
    "total_with_state": 188,
    "total_null": 812,
    "unique_values": 125,
    "top_10_values": {"the": 37, "the United": 9, ...}
  }
}
```

---

## 📅 Automated Schedule

### Supabase pg_cron Job

**Schedule**: Every Sunday at 4:00 AM UTC
**Frequency**: Weekly (runs after enrichment and ML training)
**Purpose**: Clean newly added universities and maintain data quality

To set up the cron job, run the SQL script:

```bash
# Copy SQL from setup_location_cleaning_cron.sql
# Paste and execute in Supabase SQL Editor
```

### Automation Flow

```
1. Sunday 2:00 AM UTC → Data Enrichment (fills NULL values)
2. Sunday 3:00 AM UTC → ML Training (retrains models)
3. Sunday 4:00 AM UTC → Location Cleaning (normalizes country/state data)
```

**Why after enrichment?**
Enrichment may add new university data with country/state codes that need cleaning.

---

## 🎯 Cleaning Rules

### Country Cleaning

1. **2-letter code → Full name**
   ```
   US → United States
   GB → United Kingdom
   DE → Germany
   ```

2. **"XX" placeholder → NULL**
   ```
   XX → NULL (represents unknown country)
   ```

3. **Keep existing full names**
   ```
   "Portugal" → "Portugal" (no change)
   ```

### State Cleaning

1. **For USA (country = "United States")**
   - Convert 2-letter codes: `CA → California`, `TX → Texas`
   - Keep full state names: `"California" → "California"`
   - Remove invalid values: `"the" → NULL`, `"each" → NULL`

2. **For Canada (country = "Canada")**
   - Convert province codes: `ON → Ontario`, `QC → Quebec`
   - Keep full province names: `"Ontario" → "Ontario"`

3. **For other countries**
   - Keep valid-looking state/province names (capitalized, alphabetic)
   - Remove invalid fragments and NULL

4. **Invalid state patterns removed**
   - Text fragments: "the", "the United", "each", "our"
   - Too short (< 2 chars) or too long (> 50 chars)
   - Non-alphabetic characters (except spaces and hyphens)

---

## 📈 Expected Results

### After First Run (17,137 universities)

| Metric | Expected Change |
|--------|----------------|
| Country codes converted | ~16,500 (96% of database) |
| "XX" placeholders removed | ~3,900 (23% of database) |
| Invalid states removed | ~500-600 |
| US state codes converted | ~50-100 |
| Canadian province codes converted | ~20-30 |

### Processing Time
- **Batch size**: 100 universities per batch
- **Total batches**: ~172 batches
- **Estimated time**: 5-10 minutes (depending on database response time)

---

## 🔍 Monitoring

### Check Progress During Run
```bash
# Check job status every 30 seconds
curl https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/status/{job_id}
```

### Verify Results After Completion
```bash
# Analyze data quality
curl https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/analyze

# Should show:
# - Reduced 2-letter country codes (from 96% to <5%)
# - Removed "XX" placeholders (from 23% to 0%)
# - Reduced invalid state values
```

### View Cron Job History (Supabase SQL)
```sql
SELECT jobid, runid, status, return_message, start_time, end_time
FROM cron.job_run_details
WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'weekly-location-cleaning')
ORDER BY start_time DESC
LIMIT 10;
```

---

## ✅ Benefits

### Data Quality
- ✅ **Consistent country names**: All country codes converted to full names
- ✅ **Standardized state values**: US states and Canadian provinces fully spelled out
- ✅ **Removed invalid data**: Scraped text fragments and placeholders cleaned

### User Experience
- ✅ **Readable location data**: Students see "United States" not "US"
- ✅ **Better filtering**: Can filter by full country/state names
- ✅ **Improved search**: Location search works with full names

### System Integration
- ✅ **Better recommendations**: Location matching uses clean, consistent data
- ✅ **Accurate statistics**: Location-based analytics more reliable
- ✅ **ML improvements**: Clean features for machine learning models

---

## 🛠️ Maintenance

### Zero Maintenance Required
- Runs automatically weekly via Supabase pg_cron
- Cleans newly added universities automatically
- Error tracking and status reporting built-in

### Optional Manual Triggers

**Run cleaning immediately:**
```bash
curl -X POST https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all
```

**Preview changes before running:**
```bash
curl https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/preview?limit=50
```

### Troubleshooting

**Job stuck or slow:**
- Check Railway logs for errors
- Verify Supabase connection is stable
- Batch size can be adjusted in code (currently 100)

**Incorrect mappings:**
- Add new country codes to `COUNTRY_CODE_MAP` in `location_cleaner.py`
- Add new state patterns to `INVALID_STATE_VALUES` if needed
- Redeploy to Railway

---

## 🌐 Cloud-Based Execution

**100% cloud-based** - No local dependencies:

- ✅ **Database**: Supabase PostgreSQL (cloud)
- ✅ **API**: Railway FastAPI containers (cloud)
- ✅ **Scheduling**: Supabase pg_cron (cloud)
- ✅ **Monitoring**: REST API endpoints (cloud)

**Accessible from anywhere:**
```bash
curl https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/analyze
```

---

## 📝 Setup Instructions

### 1. Deploy Code (Already Done)
```bash
git add app/api/location_cleaning.py app/enrichment/location_cleaner.py
git commit -m "Add location cleaning system"
git push origin main
# Railway auto-deploys
```

### 2. Set Up Cron Job
1. Open Supabase SQL Editor
2. Copy SQL from `setup_location_cleaning_cron.sql`
3. Execute to create weekly cron job
4. Verify: `SELECT * FROM cron.job WHERE jobname = 'weekly-location-cleaning';`

### 3. Test
```bash
# Preview changes
curl https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/preview

# Run manual cleaning
curl -X POST https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all
```

---

## 📊 System Status

**Deployment**: ✅ Deployed to Railway
**API Endpoints**: ✅ Working
**Cron Job**: ⏳ Needs Supabase SQL execution
**Testing**: ✅ Preview endpoint verified

**Next Action**: Execute `setup_location_cleaning_cron.sql` in Supabase to enable automatic weekly cleaning.

---

**Last Updated**: November 6, 2025
**Status**: 🟢 **DEPLOYED & READY FOR SCHEDULING**
