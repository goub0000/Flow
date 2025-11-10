-- ================================================================================
-- Supabase Automated Data Enrichment System
-- Complete setup for automated university data enrichment using pg_cron
-- ================================================================================
--
-- This SQL script sets up automated enrichment jobs in Supabase that will:
-- 1. Fill NULL values in university data daily/weekly/monthly
-- 2. Clean location data weekly
-- 3. Retrain ML models weekly
-- 4. Enrich specific high-value fields more frequently
--
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ================================================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- ================================================================================
-- PART 1: DAILY ENRICHMENTS (Critical Priority Fields)
-- ================================================================================

-- Daily Enrichment: 30 critical priority universities (2:00 AM UTC)
-- Fills: acceptance_rate, gpa_average, graduation_rate_4year, tuition_out_state
SELECT cron.schedule(
    'daily-critical-enrichment',
    '0 2 * * *',  -- Every day at 2:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/daily',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 1800000  -- 30 minutes (30 unis * ~1 min each)
    ) AS request_id;
    $$
);

-- ================================================================================
-- PART 2: WEEKLY ENRICHMENTS (High Priority Fields)
-- ================================================================================

-- Weekly Enrichment: 100 high priority universities (Sunday 3:00 AM UTC)
-- Fills: total_students, total_cost, university_type, location_type
SELECT cron.schedule(
    'weekly-high-priority-enrichment',
    '0 3 * * 0',  -- Every Sunday at 3:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/weekly',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 3600000  -- 60 minutes (100 unis)
    ) AS request_id;
    $$
);

-- Weekly ML Model Training (Sunday 3:30 AM UTC - after enrichment)
-- Retrains recommendation models with newly enriched data
SELECT cron.schedule(
    'weekly-ml-training',
    '30 3 * * 0',  -- Every Sunday at 3:30 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/ml/train',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 600000  -- 10 minutes for training
    ) AS request_id;
    $$
);

-- Weekly Location Cleaning (Sunday 4:00 AM UTC - after ML training)
-- Standardizes country codes and state values
SELECT cron.schedule(
    'weekly-location-cleaning',
    '0 4 * * 0',  -- Every Sunday at 4:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/location-cleaning/clean-all',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 600000  -- 10 minutes
    ) AS request_id;
    $$
);

-- ================================================================================
-- PART 3: MONTHLY ENRICHMENTS (Medium Priority Fields)
-- ================================================================================

-- Monthly Enrichment: 300 medium priority universities (1st of month, 4:00 AM UTC)
-- Comprehensive enrichment of all fields including SAT/ACT scores, rankings
SELECT cron.schedule(
    'monthly-medium-priority-enrichment',
    '0 4 1 * *',  -- 1st of each month at 4:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/monthly',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 7200000  -- 120 minutes (300 unis)
    ) AS request_id;
    $$
);

-- ================================================================================
-- PART 4: FIELD-SPECIFIC ENRICHMENTS (Targeted Updates)
-- ================================================================================

-- Bi-Weekly: Acceptance Rate enrichment (1st and 15th at 5:00 AM UTC)
-- Focus on filling acceptance_rate field specifically
SELECT cron.schedule(
    'biweekly-acceptance-rate-enrichment',
    '0 5 1,15 * *',  -- 1st and 15th of month at 5:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/start',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{"limit": 50, "fields": ["acceptance_rate"], "dry_run": false}'::jsonb,
        timeout_milliseconds := 1800000
    ) AS request_id;
    $$
);

-- Bi-Weekly: Tuition enrichment (8th and 22nd at 5:00 AM UTC)
-- Focus on filling tuition_out_state and total_cost fields
SELECT cron.schedule(
    'biweekly-tuition-enrichment',
    '0 5 8,22 * *',  -- 8th and 22nd of month at 5:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/start',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{"limit": 50, "fields": ["tuition_out_state", "total_cost"], "dry_run": false}'::jsonb,
        timeout_milliseconds := 1800000
    ) AS request_id;
    $$
);

-- ================================================================================
-- PART 5: MANAGEMENT & MONITORING QUERIES
-- ================================================================================

-- View all scheduled cron jobs
SELECT
    jobid,
    jobname,
    schedule,
    active,
    command
FROM cron.job
ORDER BY jobname;

-- View recent job execution history (last 20 runs)
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

-- Check status of specific job (replace 'daily-critical-enrichment' with job name)
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

-- ================================================================================
-- PART 6: MANUAL TRIGGERS (For Testing)
-- ================================================================================

-- Manually trigger daily enrichment (for testing)
/*
SELECT net.http_post(
    url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/daily',
    headers := '{"Content-Type": "application/json"}'::jsonb,
    body := '{}'::jsonb,
    timeout_milliseconds := 1800000
) AS request_id;
*/

-- Manually trigger a small test enrichment (5 universities)
/*
SELECT net.http_post(
    url := 'https://web-production-51e34.up.railway.app/api/v1/enrichment/start',
    headers := '{"Content-Type": "application/json"}'::jsonb,
    body := '{"limit": 5, "priority": "critical", "dry_run": false}'::jsonb,
    timeout_milliseconds := 600000
) AS request_id;
*/

-- ================================================================================
-- PART 7: UNSCHEDULING JOBS (If Needed)
-- ================================================================================

-- To remove a specific cron job, uncomment and run:
-- SELECT cron.unschedule('daily-critical-enrichment');
-- SELECT cron.unschedule('weekly-high-priority-enrichment');
-- SELECT cron.unschedule('weekly-ml-training');
-- SELECT cron.unschedule('weekly-location-cleaning');
-- SELECT cron.unschedule('monthly-medium-priority-enrichment');
-- SELECT cron.unschedule('biweekly-acceptance-rate-enrichment');
-- SELECT cron.unschedule('biweekly-tuition-enrichment');

-- To remove ALL enrichment cron jobs:
/*
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
*/

-- ================================================================================
-- ENRICHMENT SCHEDULE SUMMARY
-- ================================================================================
/*
DAILY (2:00 AM UTC):
  - Critical enrichment: 30 universities
  - Fields: acceptance_rate, gpa_average, graduation_rate, tuition
  - Impact: ~900 universities/month for critical fields

WEEKLY (Sunday):
  - 3:00 AM: High priority enrichment (100 universities)
  - 3:30 AM: ML model retraining
  - 4:00 AM: Location data cleaning
  - Impact: ~400 universities/month for high-priority fields

MONTHLY (1st at 4:00 AM):
  - Medium priority enrichment: 300 universities
  - Comprehensive field coverage
  - Impact: 300 universities/month with full data

BI-WEEKLY:
  - 1st & 15th (5:00 AM): Acceptance rate focus (50 universities)
  - 8th & 22nd (5:00 AM): Tuition focus (50 universities)
  - Impact: 200 universities/month for specific fields

TOTAL MONTHLY ENRICHMENT:
  - Daily critical: ~900 universities
  - Weekly high: ~400 universities
  - Monthly medium: ~300 universities
  - Bi-weekly targeted: ~200 universities
  - TOTAL: ~1,800 university updates/month

At this rate, all 17,137 universities will have critical fields filled within ~10 months
Complete coverage of all fields estimated within ~18-24 months
*/

-- ================================================================================
-- SETUP COMPLETE
-- ================================================================================
-- All automated enrichment cron jobs are now scheduled in Supabase!
--
-- Next steps:
-- 1. Monitor job execution with the queries above
-- 2. Check Railway backend logs for enrichment activity
-- 3. Verify data quality improvements over time
-- 4. Adjust schedules or limits as needed
-- ================================================================================
