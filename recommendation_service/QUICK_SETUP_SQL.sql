-- ============================================
-- ACTIVITY LOG SYSTEM - QUICK SETUP
-- ============================================
-- Copy and paste this ENTIRE file into Supabase SQL Editor and click "Run"
-- This will set up the complete activity logging system

-- Step 1: Create the activity_log table
CREATE TABLE IF NOT EXISTS activity_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    user_name TEXT,
    user_email TEXT,
    user_role TEXT,
    action_type TEXT NOT NULL,
    description TEXT NOT NULL,
    metadata JSONB DEFAULT '{}'::jsonb,
    ip_address TEXT,
    user_agent TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Step 2: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_activity_log_timestamp ON activity_log(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_action_type ON activity_log(action_type);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON activity_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_action ON activity_log(user_id, action_type, timestamp DESC);

-- Step 3: Enable Row Level Security
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policy for admin read access
DO $$
BEGIN
    -- Drop policy if exists
    IF EXISTS (
        SELECT 1 FROM pg_policies
        WHERE tablename = 'activity_log'
        AND policyname = 'Admins can read all activity logs'
    ) THEN
        DROP POLICY "Admins can read all activity logs" ON activity_log;
    END IF;
END $$;

CREATE POLICY "Admins can read all activity logs"
ON activity_log
FOR SELECT
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM users
        WHERE users.id = auth.uid()
        AND users.active_role IN ('admin_super', 'admin_content', 'admin_support')
    )
);

-- Step 5: Create RLS policy for system inserts
DO $$
BEGIN
    -- Drop policy if exists
    IF EXISTS (
        SELECT 1 FROM pg_policies
        WHERE tablename = 'activity_log'
        AND policyname = 'System can insert activity logs'
    ) THEN
        DROP POLICY "System can insert activity logs" ON activity_log;
    END IF;
END $$;

CREATE POLICY "System can insert activity logs"
ON activity_log
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Step 6: Add helpful comments
COMMENT ON TABLE activity_log IS 'Audit log for tracking user activities and system events';
COMMENT ON COLUMN activity_log.id IS 'Unique identifier for the activity log entry';
COMMENT ON COLUMN activity_log.timestamp IS 'When the activity occurred';
COMMENT ON COLUMN activity_log.user_id IS 'Reference to the user who performed the action';
COMMENT ON COLUMN activity_log.user_name IS 'Denormalized user name for display';
COMMENT ON COLUMN activity_log.user_email IS 'Denormalized user email for display';
COMMENT ON COLUMN activity_log.user_role IS 'User role at the time of the activity';
COMMENT ON COLUMN activity_log.action_type IS 'Type of action (e.g., user_registration, login, application_submitted)';
COMMENT ON COLUMN activity_log.description IS 'Human-readable description of the activity';
COMMENT ON COLUMN activity_log.metadata IS 'Additional structured data about the activity';

-- Step 7: Create cleanup function (optional - for data retention)
CREATE OR REPLACE FUNCTION cleanup_old_activity_logs()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Delete activity logs older than 365 days
    DELETE FROM activity_log
    WHERE created_at < NOW() - INTERVAL '365 days';

    RAISE NOTICE 'Cleaned up old activity logs';
END;
$$;

-- Step 8: Insert a test activity log entry
INSERT INTO activity_log (action_type, description, user_name, metadata)
VALUES (
    'system_test',
    'Activity log system successfully installed',
    'System',
    jsonb_build_object('installation_date', NOW()::text, 'version', '1.0.0')
);

-- ============================================
-- VERIFICATION QUERIES (run these to verify setup)
-- ============================================

-- Check table exists
SELECT 'Table created successfully' AS status
FROM information_schema.tables
WHERE table_schema = 'public' AND table_name = 'activity_log';

-- Check indexes
SELECT
    'Indexes created: ' || COUNT(*) AS status
FROM pg_indexes
WHERE tablename = 'activity_log';

-- Check RLS policies
SELECT
    'RLS policies created: ' || COUNT(*) AS status
FROM pg_policies
WHERE tablename = 'activity_log';

-- View test activity log
SELECT
    'Test activity log created at: ' || timestamp::text AS status,
    description,
    metadata
FROM activity_log
WHERE action_type = 'system_test'
ORDER BY created_at DESC
LIMIT 1;

-- Show table structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'activity_log'
ORDER BY ordinal_position;

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- You can now use the activity logging system.
--
-- Next steps:
-- 1. The API endpoints are already implemented
-- 2. Activity logging is integrated into auth and applications services
-- 3. Test by registering a new user or logging in
-- 4. View activities at: GET /api/v1/admin/dashboard/recent-activity
--
-- For full documentation, see:
-- - ACTIVITY_LOG_SYSTEM_SETUP.md
-- - ACTIVITY_LOG_IMPLEMENTATION_SUMMARY.md
-- ============================================
