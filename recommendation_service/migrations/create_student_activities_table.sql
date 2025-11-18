-- Create student_activities table for storing activity feed events
-- This table stores automatically generated activity records when events occur

CREATE TABLE IF NOT EXISTS student_activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    icon VARCHAR(10) NOT NULL,
    related_entity_id UUID,
    metadata JSONB DEFAULT '{}'::jsonb,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign key to auth.users
    CONSTRAINT fk_student_activities_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- Create indexes for common queries
CREATE INDEX IF NOT EXISTS idx_student_activities_student_id
    ON student_activities(student_id);

CREATE INDEX IF NOT EXISTS idx_student_activities_timestamp
    ON student_activities(timestamp DESC);

CREATE INDEX IF NOT EXISTS idx_student_activities_type
    ON student_activities(activity_type);

CREATE INDEX IF NOT EXISTS idx_student_activities_student_timestamp
    ON student_activities(student_id, timestamp DESC);

-- Add RLS (Row Level Security) policies
ALTER TABLE student_activities ENABLE ROW LEVEL SECURITY;

-- Students can view their own activities
CREATE POLICY "Students can view own activities"
    ON student_activities
    FOR SELECT
    USING (auth.uid() = student_id);

-- System/Service role can insert activities (for automated logging)
CREATE POLICY "Service role can insert activities"
    ON student_activities
    FOR INSERT
    WITH CHECK (true);

-- Add comments to table
COMMENT ON TABLE student_activities IS 'Stores student activity feed events automatically created when actions occur';
COMMENT ON COLUMN student_activities.activity_type IS 'Type of activity: application_submitted, achievement_earned, etc.';
COMMENT ON COLUMN student_activities.metadata IS 'Additional context data stored as JSON';
COMMENT ON COLUMN student_activities.related_entity_id IS 'ID of related entity (application_id, achievement_id, etc.)';
