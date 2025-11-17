-- Migration: Create meetings and staff_availability tables
-- Description: Parent-Teacher/Counselor Meeting Scheduler System
-- Created: 2025-11-17
-- Author: Claude Code

-- ============================================================
-- Table: meetings
-- Description: Stores meeting requests between parents and staff
-- ============================================================

CREATE TABLE IF NOT EXISTS meetings (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Participants
    parent_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    staff_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Meeting details
    staff_type TEXT NOT NULL CHECK (staff_type IN ('teacher', 'counselor')),
    meeting_type TEXT NOT NULL CHECK (meeting_type IN ('parent_teacher', 'parent_counselor')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'declined', 'cancelled', 'completed')),

    -- Scheduling
    scheduled_date TIMESTAMPTZ,
    duration_minutes INTEGER NOT NULL DEFAULT 30 CHECK (duration_minutes IN (15, 30, 45, 60, 90, 120)),

    -- Meeting mode
    meeting_mode TEXT NOT NULL CHECK (meeting_mode IN ('in_person', 'video_call', 'phone_call')),
    meeting_link TEXT,
    location TEXT,

    -- Content
    subject TEXT NOT NULL,
    notes TEXT,
    parent_notes TEXT,
    staff_notes TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for meetings table
CREATE INDEX IF NOT EXISTS idx_meetings_parent_id ON meetings(parent_id);
CREATE INDEX IF NOT EXISTS idx_meetings_student_id ON meetings(student_id);
CREATE INDEX IF NOT EXISTS idx_meetings_staff_id ON meetings(staff_id);
CREATE INDEX IF NOT EXISTS idx_meetings_status ON meetings(status);
CREATE INDEX IF NOT EXISTS idx_meetings_scheduled_date ON meetings(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_meetings_created_at ON meetings(created_at DESC);

-- Composite indexes for common queries
CREATE INDEX IF NOT EXISTS idx_meetings_staff_status ON meetings(staff_id, status);
CREATE INDEX IF NOT EXISTS idx_meetings_parent_status ON meetings(parent_id, status);
CREATE INDEX IF NOT EXISTS idx_meetings_scheduled_upcoming ON meetings(scheduled_date, status) WHERE status = 'approved';

-- Comments for meetings table
COMMENT ON TABLE meetings IS 'Parent-teacher/counselor meeting requests and schedules';
COMMENT ON COLUMN meetings.id IS 'Unique meeting identifier';
COMMENT ON COLUMN meetings.parent_id IS 'Parent who requested the meeting';
COMMENT ON COLUMN meetings.student_id IS 'Student the meeting is about';
COMMENT ON COLUMN meetings.staff_id IS 'Teacher or counselor assigned to the meeting';
COMMENT ON COLUMN meetings.staff_type IS 'Type of staff: teacher or counselor';
COMMENT ON COLUMN meetings.meeting_type IS 'Type of meeting: parent_teacher or parent_counselor';
COMMENT ON COLUMN meetings.status IS 'Meeting status: pending, approved, declined, cancelled, completed';
COMMENT ON COLUMN meetings.scheduled_date IS 'Scheduled date and time for the meeting';
COMMENT ON COLUMN meetings.duration_minutes IS 'Meeting duration in minutes (15, 30, 45, 60, 90, 120)';
COMMENT ON COLUMN meetings.meeting_mode IS 'Mode: in_person, video_call, or phone_call';
COMMENT ON COLUMN meetings.meeting_link IS 'Video call link if meeting_mode is video_call';
COMMENT ON COLUMN meetings.location IS 'Physical location if meeting_mode is in_person';
COMMENT ON COLUMN meetings.subject IS 'Meeting subject/topic';
COMMENT ON COLUMN meetings.notes IS 'General notes about the meeting';
COMMENT ON COLUMN meetings.parent_notes IS 'Notes from parent';
COMMENT ON COLUMN meetings.staff_notes IS 'Notes from staff (teacher/counselor)';


-- ============================================================
-- Table: staff_availability
-- Description: Staff member availability schedules
-- ============================================================

CREATE TABLE IF NOT EXISTS staff_availability (
    -- Primary key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Staff member
    staff_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Schedule
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,

    -- Status
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_time_range CHECK (end_time > start_time),
    CONSTRAINT unique_staff_day UNIQUE (staff_id, day_of_week)
);

-- Indexes for staff_availability table
CREATE INDEX IF NOT EXISTS idx_staff_availability_staff_id ON staff_availability(staff_id);
CREATE INDEX IF NOT EXISTS idx_staff_availability_day_of_week ON staff_availability(day_of_week);
CREATE INDEX IF NOT EXISTS idx_staff_availability_is_active ON staff_availability(is_active);
CREATE INDEX IF NOT EXISTS idx_staff_availability_staff_active ON staff_availability(staff_id, is_active);

-- Comments for staff_availability table
COMMENT ON TABLE staff_availability IS 'Staff member availability schedules for meetings';
COMMENT ON COLUMN staff_availability.id IS 'Unique availability record identifier';
COMMENT ON COLUMN staff_availability.staff_id IS 'Staff member (teacher/counselor)';
COMMENT ON COLUMN staff_availability.day_of_week IS 'Day of week: 0=Sunday, 1=Monday, ..., 6=Saturday';
COMMENT ON COLUMN staff_availability.start_time IS 'Availability start time';
COMMENT ON COLUMN staff_availability.end_time IS 'Availability end time';
COMMENT ON COLUMN staff_availability.is_active IS 'Whether this availability slot is active';


-- ============================================================
-- Row Level Security (RLS) Policies
-- ============================================================

-- Enable RLS on meetings table
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;

-- Policy: Parents can view their own meetings
CREATE POLICY meetings_parent_select ON meetings
    FOR SELECT
    USING (
        auth.uid() = parent_id
        OR auth.uid() IN (
            SELECT id FROM users WHERE active_role = 'admin'
        )
    );

-- Policy: Staff can view meetings assigned to them
CREATE POLICY meetings_staff_select ON meetings
    FOR SELECT
    USING (
        auth.uid() = staff_id
        OR auth.uid() IN (
            SELECT id FROM users WHERE active_role = 'admin'
        )
    );

-- Policy: Parents can create meetings
CREATE POLICY meetings_parent_insert ON meetings
    FOR INSERT
    WITH CHECK (
        auth.uid() = parent_id
        AND auth.uid() IN (
            SELECT id FROM users WHERE active_role = 'parent'
        )
    );

-- Policy: Parents can update their own meetings (cancel, add notes)
CREATE POLICY meetings_parent_update ON meetings
    FOR UPDATE
    USING (auth.uid() = parent_id)
    WITH CHECK (
        auth.uid() = parent_id
        AND status IN ('pending', 'approved', 'cancelled')
    );

-- Policy: Staff can update meetings assigned to them (approve, decline, add notes)
CREATE POLICY meetings_staff_update ON meetings
    FOR UPDATE
    USING (auth.uid() = staff_id)
    WITH CHECK (
        auth.uid() = staff_id
        AND status IN ('pending', 'approved', 'declined', 'cancelled', 'completed')
    );

-- Policy: Admins can delete meetings
CREATE POLICY meetings_admin_delete ON meetings
    FOR DELETE
    USING (
        auth.uid() IN (
            SELECT id FROM users WHERE active_role = 'admin'
        )
    );


-- Enable RLS on staff_availability table
ALTER TABLE staff_availability ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view active availability
CREATE POLICY staff_availability_select ON staff_availability
    FOR SELECT
    USING (is_active = TRUE OR auth.uid() = staff_id);

-- Policy: Staff can manage their own availability
CREATE POLICY staff_availability_staff_manage ON staff_availability
    FOR ALL
    USING (auth.uid() = staff_id)
    WITH CHECK (auth.uid() = staff_id);

-- Policy: Admins can manage all availability
CREATE POLICY staff_availability_admin_manage ON staff_availability
    FOR ALL
    USING (
        auth.uid() IN (
            SELECT id FROM users WHERE active_role = 'admin'
        )
    );


-- ============================================================
-- Functions and Triggers
-- ============================================================

-- Function: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_meetings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger: Auto-update updated_at on meetings
CREATE TRIGGER trigger_meetings_updated_at
    BEFORE UPDATE ON meetings
    FOR EACH ROW
    EXECUTE FUNCTION update_meetings_updated_at();

-- Trigger: Auto-update updated_at on staff_availability
CREATE TRIGGER trigger_staff_availability_updated_at
    BEFORE UPDATE ON staff_availability
    FOR EACH ROW
    EXECUTE FUNCTION update_meetings_updated_at();


-- Function: Auto-complete past meetings
CREATE OR REPLACE FUNCTION auto_complete_past_meetings()
RETURNS void AS $$
BEGIN
    UPDATE meetings
    SET status = 'completed',
        updated_at = NOW()
    WHERE status = 'approved'
      AND scheduled_date IS NOT NULL
      AND scheduled_date + (duration_minutes || ' minutes')::INTERVAL < NOW();
END;
$$ LANGUAGE plpgsql;

-- You can run this function periodically via cron or scheduled job:
-- SELECT cron.schedule('auto-complete-meetings', '0 * * * *', 'SELECT auto_complete_past_meetings()');


-- ============================================================
-- Initial Data / Sample Data (Optional)
-- ============================================================

-- Sample availability for testing (uncomment to use)
/*
-- Example: Teacher available Monday-Friday 9 AM - 5 PM
-- Replace 'staff-user-id' with actual staff user ID
INSERT INTO staff_availability (staff_id, day_of_week, start_time, end_time) VALUES
('staff-user-id', 1, '09:00:00', '17:00:00'),  -- Monday
('staff-user-id', 2, '09:00:00', '17:00:00'),  -- Tuesday
('staff-user-id', 3, '09:00:00', '17:00:00'),  -- Wednesday
('staff-user-id', 4, '09:00:00', '17:00:00'),  -- Thursday
('staff-user-id', 5, '09:00:00', '17:00:00');  -- Friday
*/


-- ============================================================
-- Verification Queries
-- ============================================================

-- Verify tables created
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('meetings', 'staff_availability')
ORDER BY table_name;

-- Verify columns
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name IN ('meetings', 'staff_availability')
ORDER BY table_name, ordinal_position;

-- Verify indexes
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('meetings', 'staff_availability')
ORDER BY tablename, indexname;

-- Verify RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename IN ('meetings', 'staff_availability')
ORDER BY tablename, policyname;


-- ============================================================
-- Migration Complete
-- ============================================================
-- Tables created: meetings, staff_availability
-- Indexes created: 13 indexes for performance optimization
-- RLS policies: 11 policies for security
-- Functions: 2 utility functions
-- Triggers: 2 auto-update triggers
-- ============================================================
