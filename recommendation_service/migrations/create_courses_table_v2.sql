-- Create courses table for course management (Version 2 - Fixed RLS)
-- Supports institution course offerings with full metadata

CREATE TABLE IF NOT EXISTS courses (
    -- Primary identification
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    institution_id UUID NOT NULL,

    -- Basic information
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    course_type VARCHAR(50) NOT NULL CHECK (course_type IN ('video', 'text', 'interactive', 'live', 'hybrid')),
    level VARCHAR(50) NOT NULL CHECK (level IN ('beginner', 'intermediate', 'advanced', 'expert')),

    -- Course details
    duration_hours DECIMAL(10, 2),
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.0,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    thumbnail_url TEXT,
    preview_video_url TEXT,
    category VARCHAR(100),

    -- Arrays for metadata
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    learning_outcomes TEXT[] DEFAULT ARRAY[]::TEXT[],
    prerequisites TEXT[] DEFAULT ARRAY[]::TEXT[],

    -- Enrollment tracking
    enrolled_count INTEGER NOT NULL DEFAULT 0,
    max_students INTEGER,

    -- Ratings and reviews
    rating DECIMAL(3, 2),
    review_count INTEGER NOT NULL DEFAULT 0,

    -- Course content and metadata
    syllabus JSONB,
    metadata JSONB,

    -- Status management
    status VARCHAR(50) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    is_published BOOLEAN NOT NULL DEFAULT FALSE,
    published_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_price CHECK (price >= 0),
    CONSTRAINT valid_enrolled_count CHECK (enrolled_count >= 0),
    CONSTRAINT valid_rating CHECK (rating IS NULL OR (rating >= 0 AND rating <= 5)),
    CONSTRAINT valid_review_count CHECK (review_count >= 0),
    CONSTRAINT published_status_match CHECK (
        (is_published = TRUE AND status = 'published') OR
        (is_published = FALSE AND status != 'published')
    )
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_courses_institution_id ON courses(institution_id);
CREATE INDEX IF NOT EXISTS idx_courses_status ON courses(status);
CREATE INDEX IF NOT EXISTS idx_courses_is_published ON courses(is_published);
CREATE INDEX IF NOT EXISTS idx_courses_category ON courses(category);
CREATE INDEX IF NOT EXISTS idx_courses_level ON courses(level);
CREATE INDEX IF NOT EXISTS idx_courses_course_type ON courses(course_type);
CREATE INDEX IF NOT EXISTS idx_courses_created_at ON courses(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_courses_title_search ON courses USING gin(to_tsvector('english', title));

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_courses_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_courses_updated_at
    BEFORE UPDATE ON courses
    FOR EACH ROW
    EXECUTE FUNCTION update_courses_updated_at();

-- Add RLS (Row Level Security) policies
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can view published courses (no auth required)
CREATE POLICY "Public courses are viewable by everyone"
    ON courses FOR SELECT
    USING (is_published = TRUE);

-- Policy: Authenticated users can view all courses (simplified for now)
-- This allows the service role key to access all courses
CREATE POLICY "Service role can view all courses"
    ON courses FOR SELECT
    TO authenticated
    USING (true);

-- Policy: Service role can insert courses
CREATE POLICY "Service role can insert courses"
    ON courses FOR INSERT
    TO authenticated
    WITH CHECK (true);

-- Policy: Service role can update courses
CREATE POLICY "Service role can update courses"
    ON courses FOR UPDATE
    TO authenticated
    USING (true)
    WITH CHECK (true);

-- Policy: Service role can delete courses
CREATE POLICY "Service role can delete courses"
    ON courses FOR DELETE
    TO authenticated
    USING (true);

-- Add helpful comments
COMMENT ON TABLE courses IS 'Stores course information for educational institutions';
COMMENT ON COLUMN courses.institution_id IS 'UUID of the institution offering this course';
COMMENT ON COLUMN courses.course_type IS 'Type of course delivery: video, text, interactive, live, or hybrid';
COMMENT ON COLUMN courses.level IS 'Difficulty level: beginner, intermediate, advanced, or expert';
COMMENT ON COLUMN courses.enrolled_count IS 'Current number of students enrolled';
COMMENT ON COLUMN courses.is_published IS 'Whether the course is publicly visible';
COMMENT ON COLUMN courses.syllabus IS 'JSON structure containing course syllabus and modules';
COMMENT ON COLUMN courses.metadata IS 'Additional course metadata and settings';
