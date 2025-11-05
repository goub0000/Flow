-- System Logs Table for Supabase-based logging
-- Replaces local file-based logging with cloud storage
-- Phase 2 Enhancement - Cloud Migration

CREATE TABLE IF NOT EXISTS system_logs (
    id BIGSERIAL PRIMARY KEY,
    timestamp TIMESTAMP NOT NULL DEFAULT NOW(),
    level TEXT NOT NULL,                    -- DEBUG, INFO, WARNING, ERROR, CRITICAL
    logger_name TEXT NOT NULL,              -- Name of the logger (e.g., 'page_cache', 'scheduler')
    message TEXT NOT NULL,                  -- Log message
    module TEXT,                            -- Python module name
    function_name TEXT,                     -- Function that generated the log
    line_number INTEGER,                    -- Line number in source code
    exception_type TEXT,                    -- Exception class name if applicable
    exception_message TEXT,                 -- Exception message if applicable
    stack_trace TEXT,                       -- Full stack trace if applicable
    extra_data JSONB DEFAULT '{}'::jsonb,  -- Additional structured data
    process_id INTEGER,                     -- Process ID
    thread_id BIGINT,                       -- Thread ID
    created_at TIMESTAMP DEFAULT NOW()
);

-- Index for timestamp-based queries (most common)
CREATE INDEX IF NOT EXISTS idx_system_logs_timestamp ON system_logs(timestamp DESC);

-- Index for level filtering
CREATE INDEX IF NOT EXISTS idx_system_logs_level ON system_logs(level);

-- Index for logger name filtering
CREATE INDEX IF NOT EXISTS idx_system_logs_logger ON system_logs(logger_name);

-- Composite index for common queries (logger + level + timestamp)
CREATE INDEX IF NOT EXISTS idx_system_logs_logger_level_time
ON system_logs(logger_name, level, timestamp DESC);

-- Index for error tracking
CREATE INDEX IF NOT EXISTS idx_system_logs_errors
ON system_logs(timestamp DESC) WHERE level IN ('ERROR', 'CRITICAL');

-- Function to clean up old logs (keep last 30 days)
CREATE OR REPLACE FUNCTION cleanup_old_logs()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM system_logs WHERE timestamp < NOW() - INTERVAL '30 days';
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to get log statistics
CREATE OR REPLACE FUNCTION get_log_statistics(days INTEGER DEFAULT 7)
RETURNS TABLE (
    level TEXT,
    count BIGINT,
    first_occurrence TIMESTAMP,
    last_occurrence TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        l.level,
        COUNT(*) as count,
        MIN(l.timestamp) as first_occurrence,
        MAX(l.timestamp) as last_occurrence
    FROM system_logs l
    WHERE l.timestamp > NOW() - (days || ' days')::INTERVAL
    GROUP BY l.level
    ORDER BY count DESC;
END;
$$ LANGUAGE plpgsql;

-- Optional: Create a scheduled job to clean up old logs daily
-- (This requires pg_cron extension - may not be available in all Supabase plans)
-- SELECT cron.schedule('cleanup-old-logs', '0 3 * * *', 'SELECT cleanup_old_logs()');

COMMENT ON TABLE system_logs IS 'Cloud-based system logs for monitoring and debugging. Replaces local log files.';
COMMENT ON COLUMN system_logs.level IS 'Log level: DEBUG, INFO, WARNING, ERROR, CRITICAL';
COMMENT ON COLUMN system_logs.extra_data IS 'Additional context data in JSON format';
COMMENT ON FUNCTION cleanup_old_logs() IS 'Removes logs older than 30 days. Call periodically to maintain performance.';
COMMENT ON FUNCTION get_log_statistics(INTEGER) IS 'Returns log statistics for the specified number of days (default 7).';
