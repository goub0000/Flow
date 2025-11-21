-- ========================================
-- Performance Optimization Indexes (Supabase Version)
-- ========================================
-- Migration: add_performance_indexes_supabase.sql
-- Purpose: Add indexes to improve query performance for the recommendation service
-- Date: 2025-11-21
-- Note: This version works in Supabase SQL Editor (no CONCURRENTLY keyword)
-- ========================================

-- ========================================
-- Universities Table Indexes
-- ========================================

-- Index for acceptance rate filtering (commonly used in recommendations)
CREATE INDEX IF NOT EXISTS idx_universities_acceptance_rate
ON universities(acceptance_rate)
WHERE acceptance_rate IS NOT NULL;

-- Index for total cost filtering (price is a major filter criterion)
CREATE INDEX IF NOT EXISTS idx_universities_total_cost
ON universities(total_cost)
WHERE total_cost IS NOT NULL;

-- Composite index for country and state filtering (location-based queries)
CREATE INDEX IF NOT EXISTS idx_universities_country_state
ON universities(country, state);

-- Index for university type filtering
CREATE INDEX IF NOT EXISTS idx_universities_type
ON universities(university_type)
WHERE university_type IS NOT NULL;

-- Index for location type filtering (urban/suburban/rural)
CREATE INDEX IF NOT EXISTS idx_universities_location_type
ON universities(location_type)
WHERE location_type IS NOT NULL;

-- Index for ranking (used in scoring and sorting)
CREATE INDEX IF NOT EXISTS idx_universities_ranking
ON universities(ranking)
WHERE ranking IS NOT NULL;

-- Index for student population size filtering
CREATE INDEX IF NOT EXISTS idx_universities_students
ON universities(students)
WHERE students IS NOT NULL;

-- Composite index for common filter combinations
CREATE INDEX IF NOT EXISTS idx_universities_filters
ON universities(country, university_type, acceptance_rate, total_cost)
WHERE country IS NOT NULL;

-- Text search index for university name (for search functionality)
CREATE INDEX IF NOT EXISTS idx_universities_name_search
ON universities USING gin(to_tsvector('english', name));

-- ========================================
-- Programs Table Indexes
-- ========================================

-- Composite index for field and university lookup
CREATE INDEX IF NOT EXISTS idx_programs_field_university
ON programs(field, university_id);

-- Index for program level filtering
CREATE INDEX IF NOT EXISTS idx_programs_level
ON programs(level)
WHERE level IS NOT NULL;

-- Index for duration filtering
CREATE INDEX IF NOT EXISTS idx_programs_duration_years
ON programs(duration_years)
WHERE duration_years IS NOT NULL;

-- Index for tuition cost filtering
CREATE INDEX IF NOT EXISTS idx_programs_tuition
ON programs(tuition)
WHERE tuition IS NOT NULL;

-- Index for university_id foreign key (improves JOIN performance)
CREATE INDEX IF NOT EXISTS idx_programs_university_id
ON programs(university_id);

-- ========================================
-- Recommendations Table Indexes
-- ========================================

-- Composite index for user recommendations with score ordering
CREATE INDEX IF NOT EXISTS idx_recommendations_user_score
ON recommendations(user_id, match_score DESC);

-- Index for student_id foreign key
CREATE INDEX IF NOT EXISTS idx_recommendations_student_id
ON recommendations(student_id);

-- Index for university_id foreign key
CREATE INDEX IF NOT EXISTS idx_recommendations_university_id
ON recommendations(university_id);

-- Index for category filtering (Safety/Match/Reach)
CREATE INDEX IF NOT EXISTS idx_recommendations_category
ON recommendations(category)
WHERE category IS NOT NULL;

-- Index for favorited recommendations
CREATE INDEX IF NOT EXISTS idx_recommendations_favorited
ON recommendations(favorited)
WHERE favorited = true;

-- Composite index for student recommendations by category
CREATE INDEX IF NOT EXISTS idx_recommendations_student_category
ON recommendations(student_id, category, match_score DESC);

-- ========================================
-- Student Profiles Table Indexes
-- ========================================

-- Index for user_id lookup (primary access pattern)
CREATE INDEX IF NOT EXISTS idx_student_profiles_user_id
ON student_profiles(user_id);

-- Index for GPA range queries
CREATE INDEX IF NOT EXISTS idx_student_profiles_gpa
ON student_profiles(gpa)
WHERE gpa IS NOT NULL;

-- Index for SAT score range queries
CREATE INDEX IF NOT EXISTS idx_student_profiles_sat_score
ON student_profiles(sat_score)
WHERE sat_score IS NOT NULL;

-- Index for budget filtering
CREATE INDEX IF NOT EXISTS idx_student_profiles_budget
ON student_profiles(budget)
WHERE budget IS NOT NULL;

-- ========================================
-- Recommendation Tracking Tables Indexes (if they exist)
-- ========================================

-- Impressions table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_impressions') THEN
        CREATE INDEX IF NOT EXISTS idx_impressions_student_id
        ON recommendation_impressions(student_id);

        CREATE INDEX IF NOT EXISTS idx_impressions_session_id
        ON recommendation_impressions(session_id);

        CREATE INDEX IF NOT EXISTS idx_impressions_created_at
        ON recommendation_impressions(created_at DESC);
    END IF;
END $$;

-- Clicks table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_clicks') THEN
        CREATE INDEX IF NOT EXISTS idx_clicks_student_university
        ON recommendation_clicks(student_id, university_id);

        CREATE INDEX IF NOT EXISTS idx_clicks_impression_id
        ON recommendation_clicks(impression_id)
        WHERE impression_id IS NOT NULL;

        CREATE INDEX IF NOT EXISTS idx_clicks_action_type
        ON recommendation_clicks(action_type);

        CREATE INDEX IF NOT EXISTS idx_clicks_created_at
        ON recommendation_clicks(created_at DESC);
    END IF;
END $$;

-- Feedback table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_feedback') THEN
        CREATE INDEX IF NOT EXISTS idx_feedback_student_university
        ON recommendation_feedback(student_id, university_id);

        CREATE INDEX IF NOT EXISTS idx_feedback_type
        ON recommendation_feedback(feedback_type);

        CREATE INDEX IF NOT EXISTS idx_feedback_rating
        ON recommendation_feedback(rating)
        WHERE rating IS NOT NULL;

        CREATE INDEX IF NOT EXISTS idx_feedback_created_at
        ON recommendation_feedback(created_at DESC);
    END IF;
END $$;

-- ========================================
-- Courses Table Indexes (if exists)
-- ========================================

DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'courses') THEN
        -- Index for program_id foreign key
        CREATE INDEX IF NOT EXISTS idx_courses_program_id
        ON courses(program_id);

        -- Index for course code lookup
        CREATE INDEX IF NOT EXISTS idx_courses_code
        ON courses(course_code);

        -- Index for credits filtering
        CREATE INDEX IF NOT EXISTS idx_courses_credits
        ON courses(credits)
        WHERE credits IS NOT NULL;
    END IF;
END $$;

-- ========================================
-- Enrollments Table Indexes (if exists)
-- ========================================

DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'enrollments') THEN
        -- Composite index for student course lookup
        CREATE INDEX IF NOT EXISTS idx_enrollments_student_course
        ON enrollments(student_id, course_id);

        -- Index for enrollment status
        CREATE INDEX IF NOT EXISTS idx_enrollments_status
        ON enrollments(status);

        -- Index for semester filtering
        CREATE INDEX IF NOT EXISTS idx_enrollments_semester_year
        ON enrollments(semester, year);
    END IF;
END $$;

-- ========================================
-- Performance Statistics Views
-- ========================================

-- Create a materialized view for recommendation statistics (refreshed periodically)
DROP MATERIALIZED VIEW IF EXISTS recommendation_stats;
CREATE MATERIALIZED VIEW recommendation_stats AS
SELECT
    r.student_id,
    r.category,
    COUNT(*) as total_recommendations,
    AVG(r.match_score) as avg_match_score,
    SUM(CASE WHEN r.favorited = true THEN 1 ELSE 0 END) as favorited_count,
    MAX(r.created_at) as last_recommendation_date
FROM recommendations r
GROUP BY r.student_id, r.category;

-- Index the materialized view
CREATE INDEX IF NOT EXISTS idx_recommendation_stats_student
ON recommendation_stats(student_id);

-- ========================================
-- Analyze Tables for Query Planner
-- ========================================

-- Update statistics for query planner optimization
ANALYZE universities;
ANALYZE programs;
ANALYZE recommendations;
ANALYZE student_profiles;

-- Analyze tracking tables if they exist
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_impressions') THEN
        ANALYZE recommendation_impressions;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_clicks') THEN
        ANALYZE recommendation_clicks;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_feedback') THEN
        ANALYZE recommendation_feedback;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'courses') THEN
        ANALYZE courses;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'enrollments') THEN
        ANALYZE enrollments;
    END IF;
END $$;

-- ========================================
-- Query Performance Monitoring Function
-- ========================================

-- Create an index statistics monitoring function
CREATE OR REPLACE FUNCTION get_index_usage_stats()
RETURNS TABLE(
    table_name text,
    index_name text,
    index_scans bigint,
    index_size text,
    table_size text
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        schemaname||'.'||tablename AS table_name,
        indexrelname AS index_name,
        idx_scan AS index_scans,
        pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
        pg_size_pretty(pg_relation_size(tablename::regclass)) AS table_size
    FROM pg_stat_user_indexes
    WHERE schemaname = 'public'
    ORDER BY idx_scan DESC;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- Migration Completion
-- ========================================

SELECT 'Performance indexes migration completed successfully at ' || NOW() as status;

-- Show created indexes
SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname = 'public'
AND indexname LIKE 'idx_%'
ORDER BY tablename, indexname;
