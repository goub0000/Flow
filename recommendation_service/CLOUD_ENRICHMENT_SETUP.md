# Cloud-Based University Data Enrichment System

## Overview

Your enrichment system is now **fully cloud-based** and can be triggered via API endpoints. It will automatically search the web and fill NULL values in your 17,137 universities.

---

## Quick Start

### 1. Check Data Quality

```bash
curl https://your-railway-app.railway.app/api/v1/enrichment/analyze
```

This shows:
- Total universities: 17,137
- NULL values per field
- Priority levels (CRITICAL, HIGH, MEDIUM)

### 2. Test Enrichment (Dry Run)

```bash
curl -X POST https://your-railway-app.railway.app/api/v1/enrichment/start \
  -H "Content-Type: application/json" \
  -d '{
    "limit": 10,
    "dry_run": true
  }'
```

Returns a job ID to track progress.

### 3. Run Real Enrichment

```bash
curl -X POST https://your-railway-app.railway.app/api/v1/enrichment/start \
  -H "Content-Type: application/json" \
  -d '{
    "limit": 50,
    "priority": "critical",
    "dry_run": false
  }'
```

### 4. Check Job Status

```bash
curl https://your-railway-app.railway.app/api/v1/enrichment/status/enrich_20250105_120000
```

---

## API Endpoints

### `GET /api/v1/enrichment/analyze`
Analyze data quality - shows NULL value statistics

**Response:**
```json
{
  "total_universities": 17137,
  "total_null_values": 89432,
  "fields": [
    {
      "field": "acceptance_rate",
      "null_count": 12543,
      "null_percentage": 73.2,
      "priority": "CRITICAL"
    }
    // ... more fields
  ],
  "summary": {
    "critical_nulls": 45234,
    "high_nulls": 28456,
    "medium_nulls": 15742
  }
}
```

### `POST /api/v1/enrichment/start`
Start an enrichment job

**Request Body:**
```json
{
  "limit": 50,              // Max universities to process
  "priority": "critical",    // "critical", "high", or "medium"
  "dry_run": false,         // true = don't update database
  "fields": ["acceptance_rate", "tuition"]  // Optional: specific fields
}
```

**Response:**
```json
{
  "job_id": "enrich_20250105_120000",
  "status": "starting",
  "started_at": "2025-01-05T12:00:00",
  "universities_processed": 0,
  "universities_updated": 0,
  "errors": 0,
  "message": "Enrichment job queued"
}
```

### `GET /api/v1/enrichment/status/{job_id}`
Get status of a specific job

### `GET /api/v1/enrichment/status`
Get status of all jobs

### `POST /api/v1/enrichment/daily`
Run daily enrichment (30 critical priority universities)

### `POST /api/v1/enrichment/weekly`
Run weekly enrichment (100 high priority universities)

### `POST /api/v1/enrichment/monthly`
Run monthly enrichment (300 medium priority universities)

---

## Automated Scheduling Options

### Option 1: Railway Cron Jobs (Recommended)

Railway doesn't have built-in cron, but you can use external cron services:

#### A. **EasyCron** (Free tier available)
1. Sign up at https://www.easycron.com/
2. Create new cron job:
   - **URL**: `https://your-app.railway.app/api/v1/enrichment/daily`
   - **Method**: POST
   - **Schedule**: Daily at 2:00 AM
   - **Timezone**: Your timezone

#### B. **Cron-Job.org** (Free)
1. Sign up at https://cron-job.org/
2. Create cron job:
   - **URL**: `https://your-app.railway.app/api/v1/enrichment/daily`
   - **Method**: POST
   - **Schedule**: `0 2 * * *` (Daily 2 AM)

#### C. **GitHub Actions** (Free for public repos)

Create `.github/workflows/daily-enrichment.yml`:

```yaml
name: Daily University Enrichment

on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC
  workflow_dispatch:      # Manual trigger

jobs:
  enrich:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Daily Enrichment
        run: |
          curl -X POST ${{ secrets.RAILWAY_API_URL }}/api/v1/enrichment/daily \
            -H "Content-Type: application/json"
```

### Option 2: Run Continuous Service on Railway

Deploy a separate "worker" service that runs the scheduler continuously:

**File**: `worker.py`
```python
from scheduled_updater_service import ScheduledUpdaterService

if __name__ == "__main__":
    service = ScheduledUpdaterService()
    service.run()  # Runs forever
```

Add to Railway as a separate service with start command:
```
python worker.py
```

### Option 3: Cloud Functions (AWS Lambda, Google Cloud Functions)

Deploy enrichment triggers as serverless functions:

```python
# lambda_function.py
import requests

def lambda_handler(event, context):
    response = requests.post(
        'https://your-app.railway.app/api/v1/enrichment/daily'
    )
    return {
        'statusCode': 200,
        'body': response.text
    }
```

Configure CloudWatch Events to trigger daily.

---

## Monitoring

### Check Current Status

```bash
# View all enrichment jobs
curl https://your-app.railway.app/api/v1/enrichment/status

# Check specific job
curl https://your-app.railway.app/api/v1/enrichment/status/enrich_20250105_120000
```

### View Logs

**Railway Dashboard:**
1. Go to your Railway project
2. Click on your service
3. Go to "Logs" tab
4. Filter by "enrichment" to see enrichment logs

### Database Monitoring

Check Supabase directly:
```sql
-- Recent enrichment activity
SELECT * FROM system_logs
WHERE source = 'enrichment'
ORDER BY timestamp DESC
LIMIT 100;

-- Data quality improvement over time
SELECT
    DATE(updated_at) as date,
    COUNT(*) as updates
FROM universities
WHERE updated_at > NOW() - INTERVAL '7 days'
GROUP BY DATE(updated_at)
ORDER BY date;
```

---

## Best Practices

### 1. Start Small
```bash
# Test with 10 universities first
curl -X POST .../enrichment/start -d '{"limit": 10, "dry_run": true}'
```

### 2. Check Progress Regularly
```bash
# Run daily analysis
curl .../enrichment/analyze > data_quality_$(date +%Y%m%d).json
```

### 3. Prioritize Critical Fields
```bash
# Focus on ML-important fields first
curl -X POST .../enrichment/start -d '{
  "limit": 100,
  "fields": ["acceptance_rate", "gpa_average", "graduation_rate_4year"]
}'
```

### 4. Rate Limiting
The system includes built-in rate limiting (3 seconds between requests) to respect web servers.

### 5. Monitor Errors
Check logs for failures and retry failed universities.

---

## Troubleshooting

### Issue: Job not starting
**Solution:** Check Railway logs for errors

### Issue: Job stuck in "starting"
**Solution:** Restart Railway service

### Issue: High error rate
**Solution:**
- Increase rate limiting
- Check internet connectivity
- Verify Supabase connection

### Issue: No data being filled
**Solution:**
- Check dry_run is set to false
- Verify Supabase write permissions
- Check field names are correct

---

## Example Workflow

### Daily Routine
```bash
# Morning: Check data quality
curl .../enrichment/analyze | jq '.summary'

# Evening: Run enrichment if needed
curl -X POST .../enrichment/daily
```

### Weekly Review
```bash
# Check all jobs from past week
curl .../enrichment/status | jq '.jobs[] | select(.status == "completed")'

# Analyze improvement
curl .../enrichment/analyze > quality_report.json
```

### Monthly Deep Dive
```bash
# Run large enrichment batch
curl -X POST .../enrichment/monthly

# Export results for review
curl .../enrichment/status > monthly_report.json
```

---

## Cost Optimization

### Rate Limiting
- Default: 3 seconds between requests
- Adjust in code: `rate_limit_delay=3.0`

### Batch Sizes
- **Daily**: 30 universities (safe, consistent)
- **Weekly**: 100 universities (moderate load)
- **Monthly**: 300 universities (deep cleanup)

### Priority System
Focus on fields that matter most for ML:
1. **CRITICAL**: acceptance_rate, gpa_average, graduation_rate
2. **HIGH**: tuition, total_students, university_type
3. **MEDIUM**: logo, website, location details

---

## Architecture

```
┌─────────────────────────────────────────┐
│   External Cron Service (EasyCron)      │
│   Triggers: Daily/Weekly/Monthly        │
└──────────────┬──────────────────────────┘
               │ HTTP POST
               ▼
┌─────────────────────────────────────────┐
│   Railway - FastAPI App                 │
│   /api/v1/enrichment/* endpoints        │
│   ├─ Start enrichment job               │
│   ├─ Check status                       │
│   └─ Analyze data quality               │
└──────────────┬──────────────────────────┘
               │ Background Task
               ▼
┌─────────────────────────────────────────┐
│   Auto-Fill Orchestrator                │
│   ├─ Prioritize universities            │
│   ├─ Search web (Wikipedia, DDG)        │
│   ├─ Scrape university websites         │
│   └─ Extract data with AI patterns      │
└──────────────┬──────────────────────────┘
               │ Supabase Client
               ▼
┌─────────────────────────────────────────┐
│   Supabase PostgreSQL                   │
│   ├─ universities table (17,137 rows)   │
│   ├─ system_logs (enrichment tracking)  │
│   └─ Real-time updates                  │
└─────────────────────────────────────────┘
```

---

## Success! 🎉

Your enrichment system is now:
- ✅ **Cloud-based** - Runs on Railway
- ✅ **Automated** - Can be scheduled with cron
- ✅ **Monitored** - Track progress via API
- ✅ **Scalable** - Handle 17k+ universities
- ✅ **Intelligent** - Prioritizes important fields

Next step: **Set up your preferred cron solution** and let it run automatically!

---

**Created:** 2025-01-05
**System:** University Data Enrichment - Cloud Edition
