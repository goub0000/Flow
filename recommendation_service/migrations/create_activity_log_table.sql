-- Activity Log Table for Admin Dashboard
-- Tracks user activities and system events for auditing and monitoring

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

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_activity_log_timestamp ON activity_log(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_activity_log_user_id ON activity_log(user_id);
CREATE INDEX IF NOT EXISTS idx_activity_log_action_type ON activity_log(action_type);
CREATE INDEX IF NOT EXISTS idx_activity_log_created_at ON activity_log(created_at DESC);

-- Add composite index for common query patterns
CREATE INDEX IF NOT EXISTS idx_activity_log_user_action ON activity_log(user_id, action_type, timestamp DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Admins can read all activity logs
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

-- RLS Policy: System can insert activity logs (via service role key)
CREATE POLICY "System can insert activity logs"
ON activity_log
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Add comments for documentation
COMMENT ON TABLE activity_log IS 'Audit log for tracking user activities and system events';
COMMENT ON COLUMN activity_log.id IS 'Unique identifier for the activity log entry';
COMMENT ON COLUMN activity_log.timestamp IS 'When the activity occurred';
COMMENT ON COLUMN activity_log.user_id IS 'Reference to the user who performed the action (nullable for system events)';
COMMENT ON COLUMN activity_log.user_name IS 'Denormalized user name for display';
COMMENT ON COLUMN activity_log.user_email IS 'Denormalized user email for display';
COMMENT ON COLUMN activity_log.user_role IS 'User role at the time of the activity';
COMMENT ON COLUMN activity_log.action_type IS 'Type of action (e.g., user_registration, login, application_submitted)';
COMMENT ON COLUMN activity_log.description IS 'Human-readable description of the activity';
COMMENT ON COLUMN activity_log.metadata IS 'Additional structured data about the activity';
COMMENT ON COLUMN activity_log.ip_address IS 'IP address of the user (optional)';
COMMENT ON COLUMN activity_log.user_agent IS 'User agent string (optional)';
COMMENT ON COLUMN activity_log.created_at IS 'When this log entry was created';

-- Create a function to automatically clean old activity logs (optional, for data retention)
CREATE OR REPLACE FUNCTION cleanup_old_activity_logs()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN
    -- Delete activity logs older than 365 days
    DELETE FROM activity_log
    WHERE created_at < NOW() - INTERVAL '365 days';
END;
$$;

-- Create a scheduled job to run cleanup (this requires pg_cron extension)
-- Uncomment if pg_cron is available:
-- SELECT cron.schedule(
--     'cleanup-activity-logs',
--     '0 2 * * *',  -- Run at 2 AM every day
--     $$SELECT cleanup_old_activity_logs();$$
-- );
