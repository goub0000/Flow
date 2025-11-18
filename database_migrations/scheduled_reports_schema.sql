-- Scheduled Reports Schema
-- Database schema for automated report generation and delivery

-- Scheduled Reports Table
CREATE TABLE IF NOT EXISTS scheduled_reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    frequency TEXT NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly')),
    format TEXT NOT NULL CHECK (format IN ('pdf', 'csv', 'json')),
    recipients TEXT[] NOT NULL, -- Array of email addresses
    metrics TEXT[] NOT NULL, -- Array of metric keys to include
    next_run_at TIMESTAMPTZ NOT NULL,
    last_run_at TIMESTAMPTZ,
    is_active BOOLEAN DEFAULT true,
    created_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Report Execution History Table
CREATE TABLE IF NOT EXISTS scheduled_report_executions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    scheduled_report_id UUID NOT NULL REFERENCES scheduled_reports(id) ON DELETE CASCADE,
    status TEXT NOT NULL CHECK (status IN ('pending', 'running', 'completed', 'failed')),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    error_message TEXT,
    report_data JSONB, -- The generated report data
    file_url TEXT, -- URL to the generated file (if stored)
    recipients_notified TEXT[], -- List of recipients who were sent the report
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_scheduled_reports_next_run
    ON scheduled_reports(next_run_at)
    WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_scheduled_reports_created_by
    ON scheduled_reports(created_by);

CREATE INDEX IF NOT EXISTS idx_report_executions_scheduled_report
    ON scheduled_report_executions(scheduled_report_id);

CREATE INDEX IF NOT EXISTS idx_report_executions_status
    ON scheduled_report_executions(status);

-- Row Level Security (RLS) Policies
ALTER TABLE scheduled_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE scheduled_report_executions ENABLE ROW LEVEL SECURITY;

-- Admins can manage all scheduled reports
CREATE POLICY admin_all_scheduled_reports
    ON scheduled_reports
    FOR ALL
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Admins can view all report executions
CREATE POLICY admin_view_report_executions
    ON scheduled_report_executions
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM profiles
            WHERE profiles.id = auth.uid()
            AND profiles.role = 'admin'
        )
    );

-- Function to update next_run_at based on frequency
CREATE OR REPLACE FUNCTION calculate_next_run(
    current_run TIMESTAMPTZ,
    freq TEXT
) RETURNS TIMESTAMPTZ AS $$
BEGIN
    CASE freq
        WHEN 'daily' THEN
            RETURN current_run + INTERVAL '1 day';
        WHEN 'weekly' THEN
            RETURN current_run + INTERVAL '1 week';
        WHEN 'monthly' THEN
            RETURN current_run + INTERVAL '1 month';
        ELSE
            RETURN current_run + INTERVAL '1 week'; -- Default to weekly
    END CASE;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_scheduled_reports_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_scheduled_reports_timestamp
    BEFORE UPDATE ON scheduled_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_scheduled_reports_timestamp();

-- Function to mark report as executed and calculate next run
CREATE OR REPLACE FUNCTION mark_report_executed(
    report_id UUID,
    execution_status TEXT,
    error_msg TEXT DEFAULT NULL
) RETURNS VOID AS $$
DECLARE
    current_freq TEXT;
    current_next_run TIMESTAMPTZ;
BEGIN
    -- Get current frequency and next_run
    SELECT frequency, next_run_at
    INTO current_freq, current_next_run
    FROM scheduled_reports
    WHERE id = report_id;

    -- Update last_run_at and calculate new next_run_at
    UPDATE scheduled_reports
    SET
        last_run_at = NOW(),
        next_run_at = calculate_next_run(current_next_run, current_freq)
    WHERE id = report_id;

    -- Create execution record
    INSERT INTO scheduled_report_executions (
        scheduled_report_id,
        status,
        started_at,
        completed_at,
        error_message
    ) VALUES (
        report_id,
        execution_status,
        NOW(),
        NOW(),
        error_msg
    );
END;
$$ LANGUAGE plpgsql;

-- Sample data for testing (optional - comment out for production)
/*
INSERT INTO scheduled_reports (
    title,
    description,
    frequency,
    format,
    recipients,
    metrics,
    next_run_at,
    is_active
) VALUES
(
    'Weekly User Activity Report',
    'Overview of user registrations and activity metrics',
    'weekly',
    'pdf',
    ARRAY['admin@flow.com', 'manager@flow.com'],
    ARRAY['total_users', 'new_registrations', 'active_sessions'],
    NOW() + INTERVAL '2 days',
    true
),
(
    'Monthly Application Analytics',
    'Application submission and acceptance statistics',
    'monthly',
    'csv',
    ARRAY['analytics@flow.com'],
    ARRAY['total_applications', 'application_acceptance_rate'],
    NOW() + INTERVAL '15 days',
    true
);
*/

-- Comments
COMMENT ON TABLE scheduled_reports IS 'Stores scheduled report configurations for automated generation';
COMMENT ON TABLE scheduled_report_executions IS 'Tracks execution history of scheduled reports';
COMMENT ON COLUMN scheduled_reports.frequency IS 'How often the report runs: daily, weekly, or monthly';
COMMENT ON COLUMN scheduled_reports.format IS 'Export format: pdf, csv, or json';
COMMENT ON COLUMN scheduled_reports.recipients IS 'Array of email addresses to send the report to';
COMMENT ON COLUMN scheduled_reports.metrics IS 'Array of metric keys to include in the report';
COMMENT ON COLUMN scheduled_reports.next_run_at IS 'Timestamp when this report should next be generated';
COMMENT ON COLUMN scheduled_reports.is_active IS 'Whether this scheduled report is currently active';
