-- Setup automated location cleaning cron job in Supabase
-- This will automatically clean country codes and state values on a schedule
-- Useful for newly added universities or data quality maintenance

-- First, verify pg_cron and pg_net extensions are enabled
SELECT * FROM pg_extension WHERE extname IN ('pg_cron', 'pg_net');

-- Create cron job to run location cleaning weekly (every Sunday at 4 AM UTC)
-- Runs after enrichment (2 AM) and ML training (3 AM) to clean any new data
SELECT cron.schedule(
    'weekly-location-cleaning',
    '0 4 * * 0',  -- Every Sunday at 4:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 600000  -- 10 minutes timeout
    ) AS request_id;
    $$
);

-- Alternative: Run location cleaning daily at 4 AM UTC (more frequent)
-- Uncomment to use daily schedule instead of weekly:
/*
SELECT cron.schedule(
    'daily-location-cleaning',
    '0 4 * * *',  -- Every day at 4:00 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        body := '{}'::jsonb,
        timeout_milliseconds := 600000
    ) AS request_id;
    $$
);
*/

-- View all scheduled cron jobs
SELECT jobid, jobname, schedule, active
FROM cron.job
ORDER BY jobname;

-- View recent location cleaning job runs
SELECT jobid, runid, status, return_message, start_time, end_time
FROM cron.job_run_details
WHERE jobid = (SELECT jobid FROM cron.job WHERE jobname = 'weekly-location-cleaning')
ORDER BY start_time DESC
LIMIT 10;

-- To unschedule the location cleaning job (if needed):
-- SELECT cron.unschedule('weekly-location-cleaning');

-- To manually trigger location cleaning via SQL:
/*
SELECT net.http_post(
    url := 'https://web-production-bcafe.up.railway.app/api/v1/location-cleaning/clean-all',
    headers := '{"Content-Type": "application/json"}'::jsonb,
    body := '{}'::jsonb,
    timeout_milliseconds := 600000
) AS request_id;
*/
