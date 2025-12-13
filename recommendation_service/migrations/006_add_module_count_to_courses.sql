-- Migration: Add module_count Column to Courses Table
-- Description: Adds module_count column referenced by course_modules triggers
-- Dependencies: Requires courses and course_modules tables to exist

-- =============================================================================
-- ADD COLUMN: module_count
-- =============================================================================

ALTER TABLE courses
ADD COLUMN IF NOT EXISTS module_count INTEGER NOT NULL DEFAULT 0;

-- Add check constraint for valid module count (with conditional creation)
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'valid_module_count'
        AND conrelid = 'courses'::regclass
    ) THEN
        ALTER TABLE courses
        ADD CONSTRAINT valid_module_count CHECK (module_count >= 0);
    END IF;
END $$;

-- =============================================================================
-- BACKFILL EXISTING DATA
-- =============================================================================

-- Update existing courses with their actual module counts
UPDATE courses
SET module_count = (
    SELECT COUNT(*)
    FROM course_modules
    WHERE course_modules.course_id = courses.id
);

-- =============================================================================
-- CREATE INDEX
-- =============================================================================

-- Index for filtering by module count (e.g., find empty courses)
CREATE INDEX IF NOT EXISTS idx_courses_module_count ON courses(module_count);

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON COLUMN courses.module_count IS 'Number of modules in this course (auto-calculated via trigger)';
