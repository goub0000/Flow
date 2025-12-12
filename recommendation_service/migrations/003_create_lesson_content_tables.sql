-- Migration: Create Lesson Content Tables
-- Description: Separate tables for different types of lesson content (video, text, quiz, assignment)
-- Dependencies: Requires course_lessons table to exist

-- =============================================================================
-- TABLE: lesson_videos
-- =============================================================================

CREATE TABLE IF NOT EXISTS lesson_videos (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to course_lessons table (one-to-one relationship)
    lesson_id UUID NOT NULL UNIQUE REFERENCES course_lessons(id) ON DELETE CASCADE,

    -- Video Information
    video_url TEXT NOT NULL,
    video_platform VARCHAR(50) DEFAULT 'youtube', -- youtube, vimeo, direct, etc.

    -- Video metadata
    thumbnail_url TEXT,
    duration_seconds INTEGER,

    -- Transcript (for accessibility and searchability)
    transcript TEXT,

    -- Settings
    allow_download BOOLEAN DEFAULT FALSE,
    auto_play BOOLEAN DEFAULT FALSE,
    show_controls BOOLEAN DEFAULT TRUE,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_duration CHECK (duration_seconds IS NULL OR duration_seconds >= 0)
);

-- Indexes for lesson_videos
CREATE INDEX idx_lesson_videos_lesson_id ON lesson_videos(lesson_id);
CREATE INDEX idx_lesson_videos_platform ON lesson_videos(video_platform);

-- =============================================================================
-- TABLE: lesson_texts
-- =============================================================================

CREATE TABLE IF NOT EXISTS lesson_texts (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to course_lessons table (one-to-one relationship)
    lesson_id UUID NOT NULL UNIQUE REFERENCES course_lessons(id) ON DELETE CASCADE,

    -- Text Content
    content TEXT NOT NULL, -- Rich text or Markdown
    content_format VARCHAR(20) DEFAULT 'markdown', -- markdown, html, plain

    -- Reading metadata
    estimated_reading_time INTEGER, -- in minutes

    -- Additional Resources
    attachments JSONB DEFAULT '[]'::JSONB, -- Array of {name, url, type, size}

    -- External links
    external_links JSONB DEFAULT '[]'::JSONB, -- Array of {title, url, description}

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_reading_time CHECK (estimated_reading_time IS NULL OR estimated_reading_time >= 0)
);

-- Indexes for lesson_texts
CREATE INDEX idx_lesson_texts_lesson_id ON lesson_texts(lesson_id);
CREATE INDEX idx_lesson_texts_format ON lesson_texts(content_format);

-- =============================================================================
-- TABLE: lesson_quizzes
-- =============================================================================

CREATE TABLE IF NOT EXISTS lesson_quizzes (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to course_lessons table (one-to-one relationship)
    lesson_id UUID NOT NULL UNIQUE REFERENCES course_lessons(id) ON DELETE CASCADE,

    -- Quiz Information
    title VARCHAR(255),
    instructions TEXT,

    -- Quiz Settings
    passing_score DECIMAL(5,2) DEFAULT 70.00, -- percentage
    max_attempts INTEGER, -- NULL = unlimited
    time_limit_minutes INTEGER, -- NULL = no time limit
    shuffle_questions BOOLEAN DEFAULT FALSE,
    shuffle_options BOOLEAN DEFAULT FALSE,
    show_correct_answers BOOLEAN DEFAULT TRUE, -- after submission
    show_feedback BOOLEAN DEFAULT TRUE, -- immediate feedback

    -- Scoring
    total_points INTEGER DEFAULT 0, -- auto-calculated from questions

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_passing_score CHECK (passing_score >= 0 AND passing_score <= 100),
    CONSTRAINT valid_max_attempts CHECK (max_attempts IS NULL OR max_attempts > 0),
    CONSTRAINT valid_time_limit CHECK (time_limit_minutes IS NULL OR time_limit_minutes > 0),
    CONSTRAINT valid_total_points CHECK (total_points >= 0)
);

-- Indexes for lesson_quizzes
CREATE INDEX idx_lesson_quizzes_lesson_id ON lesson_quizzes(lesson_id);

-- =============================================================================
-- TABLE: lesson_assignments
-- =============================================================================

DO $$ BEGIN
    CREATE TYPE submission_type AS ENUM ('text', 'file', 'url', 'both');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS lesson_assignments (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to course_lessons table (one-to-one relationship)
    lesson_id UUID NOT NULL UNIQUE REFERENCES course_lessons(id) ON DELETE CASCADE,

    -- Assignment Information
    title VARCHAR(255) NOT NULL,
    instructions TEXT NOT NULL,

    -- Submission Settings
    submission_type submission_type DEFAULT 'both',
    allowed_file_types JSONB DEFAULT '[]'::JSONB, -- Array of extensions: ["pdf", "docx", "zip"]
    max_file_size_mb INTEGER DEFAULT 10,

    -- Grading
    points_possible INTEGER NOT NULL DEFAULT 100,
    rubric JSONB DEFAULT '[]'::JSONB, -- Array of {criterion, points, description}

    -- Deadlines
    due_date TIMESTAMPTZ,
    allow_late_submission BOOLEAN DEFAULT TRUE,
    late_penalty_percent DECIMAL(5,2) DEFAULT 0.00, -- per day late

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_points_possible CHECK (points_possible > 0),
    CONSTRAINT valid_max_file_size CHECK (max_file_size_mb > 0),
    CONSTRAINT valid_late_penalty CHECK (late_penalty_percent >= 0 AND late_penalty_percent <= 100)
);

-- Indexes for lesson_assignments
CREATE INDEX idx_lesson_assignments_lesson_id ON lesson_assignments(lesson_id);
CREATE INDEX idx_lesson_assignments_due_date ON lesson_assignments(due_date);

-- =============================================================================
-- TRIGGERS: Auto-update updated_at timestamps
-- =============================================================================

-- Trigger for lesson_videos
CREATE OR REPLACE FUNCTION update_lesson_videos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lesson_videos_updated_at
    BEFORE UPDATE ON lesson_videos
    FOR EACH ROW
    EXECUTE FUNCTION update_lesson_videos_updated_at();

-- Trigger for lesson_texts
CREATE OR REPLACE FUNCTION update_lesson_texts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lesson_texts_updated_at
    BEFORE UPDATE ON lesson_texts
    FOR EACH ROW
    EXECUTE FUNCTION update_lesson_texts_updated_at();

-- Trigger for lesson_quizzes
CREATE OR REPLACE FUNCTION update_lesson_quizzes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lesson_quizzes_updated_at
    BEFORE UPDATE ON lesson_quizzes
    FOR EACH ROW
    EXECUTE FUNCTION update_lesson_quizzes_updated_at();

-- Trigger for lesson_assignments
CREATE OR REPLACE FUNCTION update_lesson_assignments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lesson_assignments_updated_at
    BEFORE UPDATE ON lesson_assignments
    FOR EACH ROW
    EXECUTE FUNCTION update_lesson_assignments_updated_at();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS on all content tables
ALTER TABLE lesson_videos ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_texts ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE lesson_assignments ENABLE ROW LEVEL SECURITY;

-- Policies for lesson_videos
CREATE POLICY lesson_videos_institution_manage
    ON lesson_videos
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cl.id = lesson_videos.lesson_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY lesson_videos_student_view
    ON lesson_videos
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE cl.id = lesson_videos.lesson_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- Policies for lesson_texts
CREATE POLICY lesson_texts_institution_manage
    ON lesson_texts
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cl.id = lesson_texts.lesson_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY lesson_texts_student_view
    ON lesson_texts
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE cl.id = lesson_texts.lesson_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- Policies for lesson_quizzes
CREATE POLICY lesson_quizzes_institution_manage
    ON lesson_quizzes
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cl.id = lesson_quizzes.lesson_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY lesson_quizzes_student_view
    ON lesson_quizzes
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE cl.id = lesson_quizzes.lesson_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- Policies for lesson_assignments
CREATE POLICY lesson_assignments_institution_manage
    ON lesson_assignments
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cl.id = lesson_assignments.lesson_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY lesson_assignments_student_view
    ON lesson_assignments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE cl.id = lesson_assignments.lesson_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE lesson_videos IS 'Stores video lesson content with platform-specific settings';
COMMENT ON TABLE lesson_texts IS 'Stores text/reading material lessons with attachments';
COMMENT ON TABLE lesson_quizzes IS 'Stores quiz/assessment lessons with settings';
COMMENT ON TABLE lesson_assignments IS 'Stores assignment/project lessons with submission requirements';

COMMENT ON COLUMN lesson_videos.video_url IS 'URL to the video (YouTube, Vimeo, direct link, etc.)';
COMMENT ON COLUMN lesson_videos.transcript IS 'Text transcript for accessibility and SEO';
COMMENT ON COLUMN lesson_texts.content IS 'Main lesson content in Markdown or HTML format';
COMMENT ON COLUMN lesson_texts.attachments IS 'JSONB array of file attachments';
COMMENT ON COLUMN lesson_quizzes.passing_score IS 'Minimum percentage score to pass the quiz';
COMMENT ON COLUMN lesson_assignments.rubric IS 'JSONB array defining grading criteria';
COMMENT ON COLUMN lesson_assignments.submission_type IS 'Type of submission allowed: text, file, url, or both';

-- =============================================================================
-- SAMPLE DATA (for testing - remove in production)
-- =============================================================================

-- Example video lesson:
-- INSERT INTO lesson_videos (lesson_id, video_url, video_platform, duration_seconds, allow_download)
-- VALUES (
--     'some-lesson-uuid',
--     'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
--     'youtube',
--     213,
--     FALSE
-- );

-- Example text lesson:
-- INSERT INTO lesson_texts (lesson_id, content, content_format, estimated_reading_time)
-- VALUES (
--     'some-lesson-uuid',
--     '# Introduction to Variables\n\nVariables are containers for storing data values...',
--     'markdown',
--     5
-- );

-- Example quiz lesson:
-- INSERT INTO lesson_quizzes (lesson_id, title, passing_score, max_attempts, time_limit_minutes)
-- VALUES (
--     'some-lesson-uuid',
--     'Chapter 1 Quiz',
--     80.00,
--     3,
--     30
-- );

-- Example assignment lesson:
-- INSERT INTO lesson_assignments (lesson_id, title, instructions, points_possible, due_date)
-- VALUES (
--     'some-lesson-uuid',
--     'Build a Calculator App',
--     'Create a simple calculator application using the concepts learned in this module.',
--     100,
--     NOW() + INTERVAL '7 days'
-- );
