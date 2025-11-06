-- Supabase Cron Job for Weekly ML Model Training
-- This will retrain models every Sunday at 3 AM UTC to incorporate newly enriched data
-- Run this in Supabase SQL Editor

-- Ensure pg_cron and pg_net extensions are enabled
CREATE EXTENSION IF NOT EXISTS pg_cron;
CREATE EXTENSION IF NOT EXISTS pg_net;

-- Schedule weekly ML model training (every Sunday at 3 AM)
SELECT cron.schedule(
    'weekly-ml-training',
    '0 3 * * 0',  -- Every Sunday at 3 AM UTC
    $$
    SELECT net.http_post(
        url := 'https://web-production-bcafe.up.railway.app/api/v1/ml/train',
        headers := '{"Content-Type": "application/json"}'::jsonb,
        timeout_milliseconds := 600000  -- 10 minutes timeout for training
    );
    $$
);

-- Verify cron job was created
SELECT
    jobid,
    schedule,
    command,
    nodename,
    active
FROM cron.job
WHERE jobname = 'weekly-ml-training';
