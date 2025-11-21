-- Clean migration for enrollments table
-- Drops existing table and recreates with correct structure

-- Step 1: Drop existing objects
DROP TABLE IF EXISTS enrollments CASCADE;
DROP FUNCTION IF EXISTS update_enrollments_updated_at() CASCADE;
DROP FUNCTION IF EXISTS update_course_enrolled_count() CASCADE;

-- Step 2: Create enrollments table
CREATE TABLE enrollments (
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

-- Step 3: Create indexes
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_enrollments_status ON enrollments(status);
CREATE INDEX idx_enrollments_enrolled_at ON enrollments(enrolled_at DESC);
CREATE INDEX idx_enrollments_student_status ON enrollments(student_id, status);

-- Step 4: Create updated_at trigger
CREATE FUNCTION update_enrollments_updated_at()
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

-- Step 5: Create trigger to update course enrolled_count automatically
CREATE FUNCTION update_course_enrolled_count()
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

-- Step 6: Enable RLS
ALTER TABLE enrollments ENABLE ROW LEVEL SECURITY;

-- Allow all operations (authorization handled in backend)
CREATE POLICY "Allow all operations on enrollments"
    ON enrollments
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Step 7: Add comments
COMMENT ON TABLE enrollments IS 'Tracks student enrollment in courses';
COMMENT ON COLUMN enrollments.student_id IS 'UUID of the enrolled student';
COMMENT ON COLUMN enrollments.course_id IS 'UUID of the course';
COMMENT ON COLUMN enrollments.status IS 'Enrollment status: active, completed, dropped, suspended';
COMMENT ON COLUMN enrollments.progress_percentage IS 'Course completion progress (0-100)';
