-- Clean migration for courses table
-- Drops existing table and recreates with correct structure

-- Step 1: Drop existing table and related objects (if they exist)
DROP TABLE IF EXISTS courses CASCADE;
DROP FUNCTION IF EXISTS update_courses_updated_at() CASCADE;

-- Step 2: Create courses table
CREATE TABLE courses (
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

-- Step 3: Create indexes
CREATE INDEX idx_courses_institution_id ON courses(institution_id);
CREATE INDEX idx_courses_status ON courses(status);
CREATE INDEX idx_courses_is_published ON courses(is_published);
CREATE INDEX idx_courses_category ON courses(category);
CREATE INDEX idx_courses_level ON courses(level);
CREATE INDEX idx_courses_course_type ON courses(course_type);
CREATE INDEX idx_courses_created_at ON courses(created_at DESC);
CREATE INDEX idx_courses_title_search ON courses USING gin(to_tsvector('english', title));

-- Step 4: Create updated_at trigger
CREATE FUNCTION update_courses_updated_at()
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

-- Step 5: Enable RLS and create simple policies
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;

-- Allow all operations for now (we'll refine later)
CREATE POLICY "Allow all operations on courses"
    ON courses
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Step 6: Add comments
COMMENT ON TABLE courses IS 'Stores course information for educational institutions';
COMMENT ON COLUMN courses.institution_id IS 'UUID of the institution offering this course';
COMMENT ON COLUMN courses.course_type IS 'Type of course delivery: video, text, interactive, live, or hybrid';
COMMENT ON COLUMN courses.level IS 'Difficulty level: beginner, intermediate, advanced, or expert';
