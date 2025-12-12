-- Migration: Create Course Modules Table
-- Description: Stores course modules with ordering and learning objectives
-- Dependencies: Requires courses table to exist

-- =============================================================================
-- CREATE TABLE: course_modules
-- =============================================================================

CREATE TABLE IF NOT EXISTS course_modules (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to courses table
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,

    -- Module Information
    title VARCHAR(255) NOT NULL,
    description TEXT,

    -- Ordering - determines sequence of modules in the course
    order_index INTEGER NOT NULL DEFAULT 0,

    -- Duration in minutes (auto-calculated from lessons)
    duration_minutes INTEGER DEFAULT 0,

    -- Lesson count (auto-calculated via trigger)
    lesson_count INTEGER DEFAULT 0,

    -- Learning objectives (JSONB array of strings)
    learning_objectives JSONB DEFAULT '[]'::JSONB,

    -- Publishing status
    is_published BOOLEAN DEFAULT FALSE,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_order_index CHECK (order_index >= 0),
    CONSTRAINT valid_duration CHECK (duration_minutes >= 0),
    CONSTRAINT valid_lesson_count CHECK (lesson_count >= 0),
    CONSTRAINT unique_course_order UNIQUE(course_id, order_index)
);

-- =============================================================================
-- CREATE INDEXES
-- =============================================================================

-- Index for querying modules by course
CREATE INDEX idx_course_modules_course_id ON course_modules(course_id);

-- Index for ordering modules within a course
CREATE INDEX idx_course_modules_order ON course_modules(course_id, order_index);

-- Index for published modules
CREATE INDEX idx_course_modules_published ON course_modules(course_id, is_published);

-- Index for efficient timestamp queries
CREATE INDEX idx_course_modules_created_at ON course_modules(created_at);
CREATE INDEX idx_course_modules_updated_at ON course_modules(updated_at);

-- =============================================================================
-- CREATE TRIGGER: Auto-update updated_at timestamp
-- =============================================================================

CREATE OR REPLACE FUNCTION update_course_modules_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_modules_updated_at
    BEFORE UPDATE ON course_modules
    FOR EACH ROW
    EXECUTE FUNCTION update_course_modules_updated_at();

-- =============================================================================
-- CREATE TRIGGER: Auto-update module count in courses table
-- =============================================================================

CREATE OR REPLACE FUNCTION update_course_module_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the course's module_count
    UPDATE courses
    SET module_count = (
        SELECT COUNT(*)
        FROM course_modules
        WHERE course_id = COALESCE(NEW.course_id, OLD.course_id)
    )
    WHERE id = COALESCE(NEW.course_id, OLD.course_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_module_count_insert
    AFTER INSERT ON course_modules
    FOR EACH ROW
    EXECUTE FUNCTION update_course_module_count();

CREATE TRIGGER trigger_update_course_module_count_delete
    AFTER DELETE ON course_modules
    FOR EACH ROW
    EXECUTE FUNCTION update_course_module_count();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS
ALTER TABLE course_modules ENABLE ROW LEVEL SECURITY;

-- Policy: Institutions can manage modules for their own courses
CREATE POLICY course_modules_institution_manage
    ON course_modules
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM courses
            WHERE courses.id = course_modules.course_id
            AND courses.institution_id = auth.uid()
        )
    );

-- Policy: Students can view published modules for enrolled courses
CREATE POLICY course_modules_student_view
    ON course_modules
    FOR SELECT
    USING (
        is_published = TRUE
        AND EXISTS (
            SELECT 1 FROM enrollments
            WHERE enrollments.course_id = course_modules.course_id
            AND enrollments.student_id = auth.uid()
            AND enrollments.status = 'active'
        )
    );

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE course_modules IS 'Stores modules that organize course content into logical sections';
COMMENT ON COLUMN course_modules.id IS 'Unique identifier for the module';
COMMENT ON COLUMN course_modules.course_id IS 'Reference to the parent course';
COMMENT ON COLUMN course_modules.title IS 'Module title (e.g., "Introduction to Python")';
COMMENT ON COLUMN course_modules.description IS 'Detailed description of what this module covers';
COMMENT ON COLUMN course_modules.order_index IS 'Position of module in the course sequence (0-based)';
COMMENT ON COLUMN course_modules.duration_minutes IS 'Total duration of all lessons in this module (auto-calculated)';
COMMENT ON COLUMN course_modules.lesson_count IS 'Number of lessons in this module (auto-calculated via trigger)';
COMMENT ON COLUMN course_modules.learning_objectives IS 'Array of learning objectives for this module';
COMMENT ON COLUMN course_modules.is_published IS 'Whether this module is visible to students';

-- =============================================================================
-- SAMPLE DATA (for testing - remove in production)
-- =============================================================================

-- Note: Sample data should be inserted after courses table is populated
-- Example:
-- INSERT INTO course_modules (course_id, title, description, order_index, learning_objectives, is_published)
-- VALUES (
--     'some-course-uuid',
--     'Introduction to Programming',
--     'Learn the fundamentals of programming including variables, data types, and control structures.',
--     0,
--     '["Understand variables and data types", "Write conditional statements", "Create loops and iterations"]'::JSONB,
--     TRUE
-- );
