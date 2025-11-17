-- ============================================================
-- QUICK SETUP: Parent Meeting Scheduler System
-- ============================================================
-- This script sets up all necessary tables, indexes, and policies
-- for the parent-teacher/counselor meeting scheduler system.
--
-- Usage:
--   1. Run this entire script in Supabase SQL Editor
--   2. Verify tables are created
--   3. Test with sample data (optional section below)
-- ============================================================

-- ============================================================
-- STEP 1: Create Tables
-- ============================================================

-- Table: meetings
CREATE TABLE IF NOT EXISTS meetings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    staff_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    staff_type TEXT NOT NULL CHECK (staff_type IN ('teacher', 'counselor')),
    meeting_type TEXT NOT NULL CHECK (meeting_type IN ('parent_teacher', 'parent_counselor')),
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'declined', 'cancelled', 'completed')),
    scheduled_date TIMESTAMPTZ,
    duration_minutes INTEGER NOT NULL DEFAULT 30 CHECK (duration_minutes IN (15, 30, 45, 60, 90, 120)),
    meeting_mode TEXT NOT NULL CHECK (meeting_mode IN ('in_person', 'video_call', 'phone_call')),
    meeting_link TEXT,
    location TEXT,
    subject TEXT NOT NULL,
    notes TEXT,
    parent_notes TEXT,
    staff_notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Table: staff_availability
CREATE TABLE IF NOT EXISTS staff_availability (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    day_of_week INTEGER NOT NULL CHECK (day_of_week >= 0 AND day_of_week <= 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT valid_time_range CHECK (end_time > start_time),
    CONSTRAINT unique_staff_day UNIQUE (staff_id, day_of_week)
);


-- ============================================================
-- STEP 2: Create Indexes
-- ============================================================

-- Meetings indexes
CREATE INDEX IF NOT EXISTS idx_meetings_parent_id ON meetings(parent_id);
CREATE INDEX IF NOT EXISTS idx_meetings_student_id ON meetings(student_id);
CREATE INDEX IF NOT EXISTS idx_meetings_staff_id ON meetings(staff_id);
CREATE INDEX IF NOT EXISTS idx_meetings_status ON meetings(status);
CREATE INDEX IF NOT EXISTS idx_meetings_scheduled_date ON meetings(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_meetings_created_at ON meetings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_meetings_staff_status ON meetings(staff_id, status);
CREATE INDEX IF NOT EXISTS idx_meetings_parent_status ON meetings(parent_id, status);
CREATE INDEX IF NOT EXISTS idx_meetings_scheduled_upcoming ON meetings(scheduled_date, status) WHERE status = 'approved';

-- Staff availability indexes
CREATE INDEX IF NOT EXISTS idx_staff_availability_staff_id ON staff_availability(staff_id);
CREATE INDEX IF NOT EXISTS idx_staff_availability_day_of_week ON staff_availability(day_of_week);
CREATE INDEX IF NOT EXISTS idx_staff_availability_is_active ON staff_availability(is_active);
CREATE INDEX IF NOT EXISTS idx_staff_availability_staff_active ON staff_availability(staff_id, is_active);


-- ============================================================
-- STEP 3: Row Level Security (RLS)
-- ============================================================

-- Enable RLS
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff_availability ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist (for clean setup)
DROP POLICY IF EXISTS meetings_parent_select ON meetings;
DROP POLICY IF EXISTS meetings_staff_select ON meetings;
DROP POLICY IF EXISTS meetings_parent_insert ON meetings;
DROP POLICY IF EXISTS meetings_parent_update ON meetings;
DROP POLICY IF EXISTS meetings_staff_update ON meetings;
DROP POLICY IF EXISTS meetings_admin_delete ON meetings;
DROP POLICY IF EXISTS staff_availability_select ON staff_availability;
DROP POLICY IF EXISTS staff_availability_staff_manage ON staff_availability;
DROP POLICY IF EXISTS staff_availability_admin_manage ON staff_availability;

-- Meetings policies
CREATE POLICY meetings_parent_select ON meetings
    FOR SELECT USING (
        auth.uid() = parent_id OR
        auth.uid() IN (SELECT id FROM users WHERE active_role = 'admin')
    );

CREATE POLICY meetings_staff_select ON meetings
    FOR SELECT USING (
        auth.uid() = staff_id OR
        auth.uid() IN (SELECT id FROM users WHERE active_role = 'admin')
    );

CREATE POLICY meetings_parent_insert ON meetings
    FOR INSERT WITH CHECK (
        auth.uid() = parent_id AND
        auth.uid() IN (SELECT id FROM users WHERE active_role = 'parent')
    );

CREATE POLICY meetings_parent_update ON meetings
    FOR UPDATE USING (auth.uid() = parent_id) WITH CHECK (
        auth.uid() = parent_id AND status IN ('pending', 'approved', 'cancelled')
    );

CREATE POLICY meetings_staff_update ON meetings
    FOR UPDATE USING (auth.uid() = staff_id) WITH CHECK (
        auth.uid() = staff_id AND status IN ('pending', 'approved', 'declined', 'cancelled', 'completed')
    );

CREATE POLICY meetings_admin_delete ON meetings
    FOR DELETE USING (
        auth.uid() IN (SELECT id FROM users WHERE active_role = 'admin')
    );

-- Staff availability policies
CREATE POLICY staff_availability_select ON staff_availability
    FOR SELECT USING (is_active = TRUE OR auth.uid() = staff_id);

CREATE POLICY staff_availability_staff_manage ON staff_availability
    FOR ALL USING (auth.uid() = staff_id) WITH CHECK (auth.uid() = staff_id);

CREATE POLICY staff_availability_admin_manage ON staff_availability
    FOR ALL USING (
        auth.uid() IN (SELECT id FROM users WHERE active_role = 'admin')
    );


-- ============================================================
-- STEP 4: Functions and Triggers
-- ============================================================

-- Function: Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_meetings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop existing triggers if they exist
DROP TRIGGER IF EXISTS trigger_meetings_updated_at ON meetings;
DROP TRIGGER IF EXISTS trigger_staff_availability_updated_at ON staff_availability;

-- Create triggers
CREATE TRIGGER trigger_meetings_updated_at
    BEFORE UPDATE ON meetings
    FOR EACH ROW
    EXECUTE FUNCTION update_meetings_updated_at();

CREATE TRIGGER trigger_staff_availability_updated_at
    BEFORE UPDATE ON staff_availability
    FOR EACH ROW
    EXECUTE FUNCTION update_meetings_updated_at();

-- Function: Auto-complete past meetings
CREATE OR REPLACE FUNCTION auto_complete_past_meetings()
RETURNS void AS $$
BEGIN
    UPDATE meetings
    SET status = 'completed', updated_at = NOW()
    WHERE status = 'approved'
      AND scheduled_date IS NOT NULL
      AND scheduled_date + (duration_minutes || ' minutes')::INTERVAL < NOW();
END;
$$ LANGUAGE plpgsql;


-- ============================================================
-- STEP 5: Verification
-- ============================================================

-- Check tables
SELECT 'Tables Created:' as info;
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' AND table_name IN ('meetings', 'staff_availability');

-- Check indexes
SELECT 'Indexes Created:' as info;
SELECT COUNT(*) as index_count FROM pg_indexes
WHERE tablename IN ('meetings', 'staff_availability');

-- Check RLS policies
SELECT 'RLS Policies Created:' as info;
SELECT COUNT(*) as policy_count FROM pg_policies
WHERE tablename IN ('meetings', 'staff_availability');


-- ============================================================
-- OPTIONAL: Sample Test Data
-- ============================================================
-- Uncomment this section to add sample data for testing

/*
-- First, create test users (if not already present)
-- You'll need to replace these IDs with actual user IDs from your system

-- Sample Parent User
-- INSERT INTO users (id, email, display_name, active_role, available_roles) VALUES
-- ('parent-user-123', 'parent@example.com', 'John Parent', 'parent', ARRAY['parent']);

-- Sample Student User
-- INSERT INTO users (id, email, display_name, active_role, available_roles) VALUES
-- ('student-user-123', 'student@example.com', 'Jane Student', 'student', ARRAY['student']);

-- Sample Teacher User
-- INSERT INTO users (id, email, display_name, active_role, available_roles) VALUES
-- ('teacher-user-123', 'teacher@example.com', 'Ms. Smith', 'teacher', ARRAY['teacher']);

-- Sample Counselor User
-- INSERT INTO users (id, email, display_name, active_role, available_roles) VALUES
-- ('counselor-user-123', 'counselor@example.com', 'Dr. Johnson', 'counselor', ARRAY['counselor']);


-- Sample Staff Availability (Teacher)
INSERT INTO staff_availability (staff_id, day_of_week, start_time, end_time) VALUES
('teacher-user-123', 1, '09:00:00', '17:00:00'),  -- Monday
('teacher-user-123', 2, '09:00:00', '17:00:00'),  -- Tuesday
('teacher-user-123', 3, '09:00:00', '17:00:00'),  -- Wednesday
('teacher-user-123', 4, '09:00:00', '17:00:00'),  -- Thursday
('teacher-user-123', 5, '09:00:00', '17:00:00');  -- Friday

-- Sample Staff Availability (Counselor)
INSERT INTO staff_availability (staff_id, day_of_week, start_time, end_time) VALUES
('counselor-user-123', 1, '10:00:00', '16:00:00'),  -- Monday
('counselor-user-123', 3, '10:00:00', '16:00:00'),  -- Wednesday
('counselor-user-123', 5, '10:00:00', '16:00:00');  -- Friday


-- Sample Meeting Request
INSERT INTO meetings (
    parent_id, student_id, staff_id,
    staff_type, meeting_type, status,
    duration_minutes, meeting_mode,
    subject, notes, parent_notes
) VALUES (
    'parent-user-123',
    'student-user-123',
    'teacher-user-123',
    'teacher',
    'parent_teacher',
    'pending',
    30,
    'video_call',
    'Discuss math progress',
    'Parent would like to discuss improvement strategies',
    'Concerned about recent test scores'
);

-- Sample Approved Meeting
INSERT INTO meetings (
    parent_id, student_id, staff_id,
    staff_type, meeting_type, status,
    scheduled_date, duration_minutes, meeting_mode,
    meeting_link, subject, notes, staff_notes
) VALUES (
    'parent-user-123',
    'student-user-123',
    'counselor-user-123',
    'counselor',
    'parent_counselor',
    'approved',
    NOW() + INTERVAL '3 days',
    45,
    'video_call',
    'https://meet.google.com/abc-defg-hij',
    'College application guidance',
    'Discuss college application timeline and strategy',
    'Will prepare list of recommended colleges'
);
*/


-- ============================================================
-- Setup Complete!
-- ============================================================

SELECT '
============================================================
MEETING SCHEDULER SETUP COMPLETE!
============================================================

Tables Created:
  - meetings
  - staff_availability

Features Enabled:
  - Row Level Security (RLS)
  - Auto-updating timestamps
  - Data validation constraints
  - Performance indexes

Next Steps:
  1. Register API routes in your FastAPI application
  2. Test API endpoints with Postman or similar
  3. Configure frontend to consume the API
  4. Set up cron job for auto-completing past meetings:
     SELECT cron.schedule(''auto-complete-meetings'', ''0 * * * *'', ''SELECT auto_complete_past_meetings()'');

API Documentation: See MEETINGS_API_DOCUMENTATION.md
Setup Guide: See MEETINGS_SYSTEM_SETUP.md

============================================================
' as setup_complete;
