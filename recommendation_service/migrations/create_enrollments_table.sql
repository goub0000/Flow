-- Create enrollments table for course enrollment management
-- Tracks student enrollment in courses with progress and status

CREATE TABLE IF NOT EXISTS enrollments (
    -- Primary identification
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,

    -- Status tracking
    status VARCHAR(50) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'completed', 'dropped', 'suspended')),

    -- Progress tracking
    progress_percentage DECIMAL(5, 2) NOT NULL DEFAULT 0.0 CHECK (progress_percentage >= 0 AND progress_percentage <= 100),

    -- Timestamps
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    dropped_at TIMESTAMPTZ,
    last_accessed_at TIMESTAMPTZ,

    -- Metadata
    metadata JSONB,

    -- Audit timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT unique_student_course UNIQUE (student_id, course_id),
    CONSTRAINT valid_completion CHECK (
        (status = 'completed' AND completed_at IS NOT NULL AND progress_percentage = 100) OR
        (status != 'completed')
    )
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollments_status ON enrollments(status);
CREATE INDEX IF NOT EXISTS idx_enrollments_enrolled_at ON enrollments(enrolled_at DESC);
CREATE INDEX IF NOT EXISTS idx_enrollments_student_status ON enrollments(student_id, status);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_enrollments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_enrollments_updated_at
    BEFORE UPDATE ON enrollments
    FOR EACH ROW
    EXECUTE FUNCTION update_enrollments_updated_at();

-- Enable RLS
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- Simple policy: Allow all operations (authorization handled in backend)
CREATE POLICY "Allow all operations on enrollments"
    ON enrollments
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Create trigger to update course enrolled_count
CREATE OR REPLACE FUNCTION update_course_enrolled_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' AND NEW.status IN ('active', 'completed') THEN
        -- Increment enrolled_count when student enrolls
        UPDATE courses
        SET enrolled_count = enrolled_count + 1
        WHERE id = NEW.course_id;
    ELSIF TG_OP = 'UPDATE' THEN
        -- Handle status changes
        IF OLD.status IN ('active', 'completed') AND NEW.status NOT IN ('active', 'completed') THEN
            -- Decrement when student drops/suspends
            UPDATE courses
            SET enrolled_count = GREATEST(enrolled_count - 1, 0)
            WHERE id = OLD.course_id;
        ELSIF OLD.status NOT IN ('active', 'completed') AND NEW.status IN ('active', 'completed') THEN
            -- Increment when re-enrolling
            UPDATE courses
            SET enrolled_count = enrolled_count + 1
            WHERE id = NEW.course_id;
        END IF;
    ELSIF TG_OP = 'DELETE' AND OLD.status IN ('active', 'completed') THEN
        -- Decrement when enrollment is deleted
        UPDATE courses
        SET enrolled_count = GREATEST(enrolled_count - 1, 0)
        WHERE id = OLD.course_id;
    END IF;
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_enrolled_count
    AFTER INSERT OR UPDATE OR DELETE ON enrollments
    FOR EACH ROW
    EXECUTE FUNCTION update_course_enrolled_count();

-- Add comments
COMMENT ON TABLE enrollments IS 'Tracks student enrollment in courses';
COMMENT ON COLUMN enrollments.student_id IS 'UUID of the enrolled student';
COMMENT ON COLUMN enrollments.course_id IS 'UUID of the course';
COMMENT ON COLUMN enrollments.status IS 'Enrollment status: active, completed, dropped, suspended';
COMMENT ON COLUMN enrollments.progress_percentage IS 'Course completion progress (0-100)';
COMMENT ON COLUMN enrollments.enrolled_at IS 'When the student enrolled';
COMMENT ON COLUMN enrollments.completed_at IS 'When the course was completed';
COMMENT ON COLUMN enrollments.metadata IS 'Additional enrollment data';
