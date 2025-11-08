-- Run these in Supabase SQL Editor to verify your cron setup

-- 1. Check your cron job exists
SELECT
    jobid,
    schedule,
    command,
    nodename,
    active
FROM cron.job;

-- 2. Check job run history (once it starts running)
SELECT
    jobid,
    runid,
    job_pid,
    database,
    username,
    command,
    status,
    return_message,
    start_time,
    end_time
FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 10;

-- 3. Check if pg_net extension is enabled (needed for http_post)
SELECT * FROM pg_extension WHERE extname = 'pg_net';

-- If pg_net is not shown, enable it:
-- CREATE EXTENSION IF NOT EXISTS pg_net;
