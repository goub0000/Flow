# Supabase Automated Enrichment Setup Guide

## Overview

This guide will help you set up **automated data enrichment directly in Supabase** using `pg_cron` (PostgreSQL cron jobs). This is more reliable than external cron services and runs entirely within your database.

## What Gets Automated

The SQL setup creates **7 automated enrichment jobs** that run on schedule:

### 1. Daily Critical Enrichment (2:00 AM UTC)
- Processes 30 critical priority universities daily
- Fills: acceptance_rate, gpa_average, graduation_rate, tuition
- **Impact**: ~900 universities/month

### 2. Weekly High Priority Enrichment (Sunday 3:00 AM UTC)
- Processes 100 high priority universities weekly
- Fills: total_students, total_cost, university_type, location_type
- **Impact**: ~400 universities/month

### 3. Weekly ML Training (Sunday 3:30 AM UTC)
- Retrains recommendation models with newly enriched data
- Improves recommendation accuracy

### 4. Weekly Location Cleaning (Sunday 4:00 AM UTC)
- Standardizes country codes and state values
- Fixes data quality issues

### 5. Monthly Medium Priority Enrichment (1st of month, 4:00 AM UTC)
- Processes 300 universities with comprehensive enrichment
- Fills all fields including SAT/ACT scores, rankings
- **Impact**: 300 universities/month

### 6. Bi-Weekly Acceptance Rate Focus (1st & 15th, 5:00 AM UTC)
- Specifically targets acceptance_rate field
- Processes 50 universities
- **Impact**: 100 universities/month

### 7. Bi-Weekly Tuition Focus (8th & 22nd, 5:00 AM UTC)
- Specifically targets tuition_out_state and total_cost fields
- Processes 50 universities
- **Impact**: 100 universities/month

**Total Monthly Impact**: ~1,800 university updates across all schedules

## Prerequisites

1. Supabase account with access to SQL Editor
2. Your Supabase project must be on a **Pro plan** or higher (pg_cron requires Pro/Team/Enterprise)
3. Backend API running at: `https://web-production-51e34.up.railway.app`

## Step-by-Step Setup

### Step 1: Enable Required Extensions

1. Go to your Supabase Dashboard
2. Navigate to: **Database** → **Extensions**
3. Search for and enable:
   - ✅ **pg_cron** (for scheduled jobs)
   - ✅ **pg_net** (for HTTP requests)

Or run in SQL Editor:
```sql
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;
```

### Step 2: Run the Setup SQL

1. Go to: **SQL Editor** → **New Query**
2. Copy the entire contents of `setup_supabase_automated_enrichments.sql`
3. Paste into the SQL Editor
4. Click **Run** (or press Ctrl+Enter)

The script will create all 7 cron jobs automatically.

### Step 3: Verify Jobs Were Created

Run this query to see all scheduled jobs:

```sql
SELECT
    jobid,
    jobname,
    schedule,
    active,
    command
FROM cron.job
ORDER BY jobname;
```

You should see:
- ✅ biweekly-acceptance-rate-enrichment
- ✅ biweekly-tuition-enrichment
- ✅ daily-critical-enrichment
- ✅ monthly-medium-priority-enrichment
- ✅ weekly-high-priority-enrichment
- ✅ weekly-location-cleaning
- ✅ weekly-ml-training

### Step 4: Test a Job Manually (Optional)

To test if everything is working, manually trigger a small enrichment:

```sql
SELECT net.http_post(
    url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/start',
    headers := '{"Content-Type": "application/json"}'::jsonb,
    body := '{"limit": 5, "priority": "critical", "dry_run": false}'::jsonb,
    timeout_milliseconds := 600000
) AS request_id;
```

This will process 5 universities immediately as a test.

### Step 5: Monitor Job Execution

**View recent job runs:**

```sql
SELECT
    j.jobname,
    r.runid,
    r.status,
    r.return_message,
    r.start_time,
    r.end_time,
    EXTRACT(EPOCH FROM (r.end_time - r.start_time)) as duration_seconds
FROM cron.job_run_details r
JOIN cron.job j ON j.jobid = r.jobid
ORDER BY r.start_time DESC
LIMIT 20;
```

**Check specific job history:**

```sql
SELECT
    r.runid,
    r.status,
    r.return_message,
    r.start_time,
    r.end_time
FROM cron.job_run_details r
WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'daily-critical-enrichment')
ORDER BY start_time DESC
LIMIT 10;
```

## Monitoring & Verification

### 1. Check Data Quality Improvements

Monitor NULL value reduction over time:

```bash
curl https://web-production-51e34.up.railway.app/api/v1/enrichment/analyze
```

### 2. Check Enrichment Job Status

```bash
curl https://web-production-51e34.up.railway.app/api/v1/enrichment/status
```

### 3. Railway Backend Logs

Go to Railway dashboard → Select recommendation service → View logs

Search for keywords:
- "enrichment"
- "Successful updates"
- "universities processed"

### 4. Supabase Logs

In Supabase Dashboard:
- Navigate to **Logs** → **Postgres Logs**
- Filter by "cron" to see cron job activity

## Troubleshooting

### Jobs Not Running?

**Check if pg_cron extension is enabled:**

```sql
SELECT * FROM pg_extension WHERE extname = 'pg_cron';
```

If not found, enable it:

```sql
CREATE EXTENSION pg_cron;
```

**Check if jobs are active:**

```sql
SELECT jobid, jobname, active FROM cron.job;
```

If `active = false`, enable with:

```sql
UPDATE cron.job SET active = true WHERE jobname = 'daily-critical-enrichment';
```

### Jobs Failing?

**Check error messages:**

```sql
SELECT
    j.jobname,
    r.status,
    r.return_message
FROM cron.job_run_details r
JOIN cron.job j ON j.jobid = r.jobid
WHERE r.status = 'failed'
ORDER BY r.start_time DESC
LIMIT 10;
```

**Common issues:**
1. **Timeout**: Increase `timeout_milliseconds` in job definition
2. **URL incorrect**: Verify backend URL is correct
3. **Backend down**: Check Railway service status
4. **Rate limiting**: Adjust enrichment limit

### Need to Modify a Job?

**Unschedule the old job:**

```sql
SELECT cron.unschedule('daily-critical-enrichment');
```

**Schedule new version:**

```sql
SELECT cron.schedule(
    'daily-critical-enrichment',
    '0 2 * * *',
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/daily',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 1800000
    ) AS request_id;
    $$
);
```

## Adjusting Schedules

### Cron Schedule Format

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday to Saturday)
│ │ │ │ │
* * * * *
```

### Examples:

- `0 2 * * *` - Every day at 2:00 AM
- `0 3 * * 0` - Every Sunday at 3:00 AM
- `0 4 1 * *` - 1st of every month at 4:00 AM
- `0 5 1,15 * *` - 1st and 15th of month at 5:00 AM
- `*/30 * * * *` - Every 30 minutes

### To Change Schedule:

1. Unschedule the old job
2. Create new job with desired schedule
3. Verify with `SELECT * FROM cron.job`

## Removing All Jobs (If Needed)

To completely remove all enrichment automation:

```sql
DO $$
DECLARE
    job_name TEXT;
BEGIN
    FOR job_name IN
        SELECT jobname FROM cron.job
        WHERE jobname LIKE '%enrichment%'
           OR jobname LIKE '%ml-training%'
           OR jobname LIKE '%location-cleaning%'
    LOOP
        PERFORM cron.unschedule(job_name);
        RAISE NOTICE 'Unscheduled job: %', job_name;
    END LOOP;
END $$;
```

## Expected Results

### Timeline for Data Completeness

At the current enrichment rate (~1,800 universities/month):

- **3 months**: Critical fields (acceptance_rate, GPA, tuition) 50% complete
- **6 months**: Critical fields 85% complete
- **10 months**: All critical fields filled
- **18-24 months**: Comprehensive data coverage for all fields

### Data Quality Metrics to Track

Monitor these monthly:
- NULL value count (should decrease)
- Universities with complete critical fields (should increase)
- Average data confidence scores (should improve)
- Enrichment success rate (target: >80%)

## Advantages of Supabase pg_cron

✅ **No external dependencies** - Runs entirely in your database
✅ **More reliable** - No reliance on external services
✅ **Better monitoring** - Native PostgreSQL logging
✅ **Cost effective** - Included with Supabase Pro plan
✅ **Centralized** - All automation in one place
✅ **Timezone consistent** - Always UTC, no confusion
✅ **Persistent** - Jobs survive database restarts

## Next Steps

1. ✅ Run the setup SQL in Supabase
2. ✅ Verify all 7 jobs are scheduled
3. ✅ Test with manual trigger
4. ✅ Monitor first scheduled run
5. ✅ Check data quality improvements weekly
6. ✅ Adjust schedules/limits as needed based on results

## Support

If you encounter issues:

1. Check Supabase Pro plan is active
2. Verify extensions are enabled
3. Review job execution logs
4. Check Railway backend logs
5. Test API endpoints manually with curl

For questions about specific enrichment logic, see: `ENRICHMENT_AUTOMATION.md`
