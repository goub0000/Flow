-- Migration: Create Course Lessons Table
-- Description: Stores individual lessons within course modules
-- Dependencies: Requires course_modules table to exist

-- =============================================================================
-- CREATE TYPE: Lesson Type Enum
-- =============================================================================

DO $$ BEGIN
    CREATE TYPE lesson_type AS ENUM ('video', 'text', 'quiz', 'assignment');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- =============================================================================
-- CREATE TABLE: course_lessons
-- =============================================================================

CREATE TABLE IF NOT EXISTS course_lessons (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to course_modules table
    module_id UUID NOT NULL REFERENCES course_modules(id) ON DELETE CASCADE,

    -- Lesson Information
    title VARCHAR(255) NOT NULL,
    description TEXT,

    -- Lesson Type - determines which content table to look up
    lesson_type lesson_type NOT NULL,

    -- Ordering - determines sequence of lessons in the module
    order_index INTEGER NOT NULL DEFAULT 0,

    -- Duration in minutes
    duration_minutes INTEGER DEFAULT 0,

    -- Optional video/content URL (for quick access)
    content_url TEXT,

    -- Flags
    is_mandatory BOOLEAN DEFAULT TRUE,  -- Must be completed to progress
    is_published BOOLEAN DEFAULT FALSE,  -- Visible to students
    allow_preview BOOLEAN DEFAULT FALSE, -- Can view without enrollment

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_order_index CHECK (order_index >= 0),
    CONSTRAINT valid_duration CHECK (duration_minutes >= 0),
    CONSTRAINT unique_module_order UNIQUE(module_id, order_index)
);

-- =============================================================================
-- CREATE INDEXES
-- =============================================================================

-- Index for querying lessons by module
CREATE INDEX idx_course_lessons_module_id ON course_lessons(module_id);

-- Index for ordering lessons within a module
CREATE INDEX idx_course_lessons_order ON course_lessons(module_id, order_index);

-- Index for published lessons
CREATE INDEX idx_course_lessons_published ON course_lessons(module_id, is_published);

-- Index for lesson type filtering
CREATE INDEX idx_course_lessons_type ON course_lessons(lesson_type);

-- Index for efficient timestamp queries
CREATE INDEX idx_course_lessons_created_at ON course_lessons(created_at);
CREATE INDEX idx_course_lessons_updated_at ON course_lessons(updated_at);

-- =============================================================================
-- CREATE TRIGGER: Auto-update updated_at timestamp
-- =============================================================================

CREATE OR REPLACE FUNCTION update_course_lessons_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_course_lessons_updated_at
    BEFORE UPDATE ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_course_lessons_updated_at();

-- =============================================================================
-- CREATE TRIGGER: Auto-update lesson count in course_modules table
-- =============================================================================

CREATE OR REPLACE FUNCTION update_module_lesson_count()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the module's lesson_count
    UPDATE course_modules
    SET lesson_count = (
        SELECT COUNT(*)
        FROM course_lessons
        WHERE module_id = COALESCE(NEW.module_id, OLD.module_id)
    )
    WHERE id = COALESCE(NEW.module_id, OLD.module_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_module_lesson_count_insert
    AFTER INSERT ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_module_lesson_count();

CREATE TRIGGER trigger_update_module_lesson_count_delete
    AFTER DELETE ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_module_lesson_count();

-- =============================================================================
-- CREATE TRIGGER: Auto-update duration in course_modules table
-- =============================================================================

CREATE OR REPLACE FUNCTION update_module_duration()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the module's total duration
    UPDATE course_modules
    SET duration_minutes = (
        SELECT COALESCE(SUM(duration_minutes), 0)
        FROM course_lessons
        WHERE module_id = COALESCE(NEW.module_id, OLD.module_id)
    )
    WHERE id = COALESCE(NEW.module_id, OLD.module_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_module_duration_insert
    AFTER INSERT ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_module_duration();

CREATE TRIGGER trigger_update_module_duration_update
    AFTER UPDATE OF duration_minutes ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_module_duration();

CREATE TRIGGER trigger_update_module_duration_delete
    AFTER DELETE ON course_lessons
    FOR EACH ROW
    EXECUTE FUNCTION update_module_duration();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS
ALTER TABLE course_lessons ENABLE ROW LEVEL SECURITY;

-- Policy: Institutions can manage lessons for their own courses
CREATE POLICY course_lessons_institution_manage
    ON course_lessons
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM course_modules cm
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cm.id = course_lessons.module_id
            AND c.institution_id = auth.uid()
        )
    );

-- Policy: Students can view published lessons for enrolled courses
CREATE POLICY course_lessons_student_view
    ON course_lessons
    FOR SELECT
    USING (
        is_published = TRUE
        AND EXISTS (
            SELECT 1 FROM course_modules cm
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE cm.id = course_lessons.module_id
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- =============================================================================
-- CREATE VIEW: Lessons with Course and Module Info
-- =============================================================================

CREATE OR REPLACE VIEW course_lessons_detailed AS
SELECT
    cl.id,
    cl.module_id,
    cl.title,
    cl.description,
    cl.lesson_type,
    cl.order_index,
    cl.duration_minutes,
    cl.content_url,
    cl.is_mandatory,
    cl.is_published,
    cl.allow_preview,
    cl.created_at,
    cl.updated_at,
    -- Module info
    cm.title AS module_title,
    cm.course_id,
    -- Course info
    c.title AS course_title,
    c.institution_id
FROM course_lessons cl
INNER JOIN course_modules cm ON cl.module_id = cm.id
INNER JOIN courses c ON cm.course_id = c.id;

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE course_lessons IS 'Stores individual lessons within course modules';
COMMENT ON COLUMN course_lessons.id IS 'Unique identifier for the lesson';
COMMENT ON COLUMN course_lessons.module_id IS 'Reference to the parent module';
COMMENT ON COLUMN course_lessons.title IS 'Lesson title (e.g., "Variables and Data Types")';
COMMENT ON COLUMN course_lessons.description IS 'Brief description of lesson content';
COMMENT ON COLUMN course_lessons.lesson_type IS 'Type of content: video, text, quiz, or assignment';
COMMENT ON COLUMN course_lessons.order_index IS 'Position of lesson in the module sequence (0-based)';
COMMENT ON COLUMN course_lessons.duration_minutes IS 'Expected time to complete this lesson';
COMMENT ON COLUMN course_lessons.content_url IS 'Optional direct URL to content (e.g., YouTube video)';
COMMENT ON COLUMN course_lessons.is_mandatory IS 'Whether completion is required to progress';
COMMENT ON COLUMN course_lessons.is_published IS 'Whether this lesson is visible to students';
COMMENT ON COLUMN course_lessons.allow_preview IS 'Whether non-enrolled users can view this lesson';

COMMENT ON TYPE lesson_type IS 'Types of lesson content: video, text (reading material), quiz (assessment), assignment (project/homework)';

-- =============================================================================
-- SAMPLE DATA (for testing - remove in production)
-- =============================================================================

-- Note: Sample data should be inserted after course_modules table is populated
-- Example:
-- INSERT INTO course_lessons (module_id, title, description, lesson_type, order_index, duration_minutes, is_published, is_mandatory)
-- VALUES (
--     'some-module-uuid',
--     'Introduction to Variables',
--     'Learn what variables are and how to use them in programming.',
--     'video',
--     0,
--     15,
--     TRUE,
--     TRUE
-- );
