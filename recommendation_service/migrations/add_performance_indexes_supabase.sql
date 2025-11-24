-- ========================================
-- Performance Optimization Indexes (Supabase Version - COMPLETE)
-- ========================================
-- Migration: add_performance_indexes_supabase.sql
-- Purpose: Add indexes to improve query performance for the recommendation service
-- Date: 2025-11-21
-- Note: This version matches the actual Supabase schema exactly
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

-- Index for global ranking (used in scoring and sorting)
CREATE INDEX IF NOT EXISTS idx_universities_global_rank
ON universities(global_rank)
WHERE global_rank IS NOT NULL;

-- Index for national ranking
CREATE INDEX IF NOT EXISTS idx_universities_national_rank
ON universities(national_rank)
WHERE national_rank IS NOT NULL;

-- Index for student population size filtering
CREATE INDEX IF NOT EXISTS idx_universities_total_students
ON universities(total_students)
WHERE total_students IS NOT NULL;

-- Index for tuition filtering
CREATE INDEX IF NOT EXISTS idx_universities_tuition
ON universities(tuition_out_state)
WHERE tuition_out_state IS NOT NULL;

-- Composite index for common filter combinations
CREATE INDEX IF NOT EXISTS idx_universities_filters
ON universities(country, university_type, acceptance_rate, total_cost)
WHERE country IS NOT NULL;

-- Text search index for university name (for search functionality)
CREATE INDEX IF NOT EXISTS idx_universities_name_search
ON universities USING gin(to_tsvector('english', name));

-- Index for GPA average (used in academic matching)
CREATE INDEX IF NOT EXISTS idx_universities_gpa_average
ON universities(gpa_average)
WHERE gpa_average IS NOT NULL;

-- Index for graduation rate
CREATE INDEX IF NOT EXISTS idx_universities_graduation_rate
ON universities(graduation_rate_4year)
WHERE graduation_rate_4year IS NOT NULL;

-- Index for SAT math scores
CREATE INDEX IF NOT EXISTS idx_universities_sat_math
ON universities(sat_math_25th, sat_math_75th)
WHERE sat_math_25th IS NOT NULL;

-- Index for median earnings
CREATE INDEX IF NOT EXISTS idx_universities_median_earnings
ON universities(median_earnings_10year)
WHERE median_earnings_10year IS NOT NULL;

-- ========================================
-- Programs Table Indexes (if exists)
-- ========================================

DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'programs') THEN
        -- Composite index for category and institution lookup
        CREATE INDEX IF NOT EXISTS idx_programs_category_institution
        ON programs(category, institution_id);

        -- Index for level filtering
        CREATE INDEX IF NOT EXISTS idx_programs_level_optimized
        ON programs(level)
        WHERE level IS NOT NULL;

        -- Index for active programs
        CREATE INDEX IF NOT EXISTS idx_programs_is_active_optimized
        ON programs(is_active)
        WHERE is_active = true;

        -- Index for fee filtering
        CREATE INDEX IF NOT EXISTS idx_programs_fee
        ON programs(fee)
        WHERE fee IS NOT NULL;

        -- Index for application deadline
        CREATE INDEX IF NOT EXISTS idx_programs_application_deadline_optimized
        ON programs(application_deadline)
        WHERE application_deadline IS NOT NULL;

        -- Composite index for active programs by institution
        CREATE INDEX IF NOT EXISTS idx_programs_institution_active
        ON programs(institution_id, is_active, created_at DESC);

        -- Text search index for program name
        CREATE INDEX IF NOT EXISTS idx_programs_name_search
        ON programs USING gin(to_tsvector('english', name));
    END IF;
END $$;

-- ========================================
-- Recommendations Table Indexes
-- ========================================

-- Composite index for student recommendations with score ordering
CREATE INDEX IF NOT EXISTS idx_recommendations_student_score
ON recommendations(student_id, match_score DESC);

-- Index for university_id foreign key
CREATE INDEX IF NOT EXISTS idx_recommendations_university_id_optimized
ON recommendations(university_id);

-- Index for category filtering (Safety/Match/Reach)
CREATE INDEX IF NOT EXISTS idx_recommendations_category
ON recommendations(category)
WHERE category IS NOT NULL;

-- Index for favorited recommendations (using integer 1)
CREATE INDEX IF NOT EXISTS idx_recommendations_favorited
ON recommendations(favorited)
WHERE favorited = 1;

-- Composite index for student recommendations by category
CREATE INDEX IF NOT EXISTS idx_recommendations_student_category
ON recommendations(student_id, category, match_score DESC);

-- Index for academic score
CREATE INDEX IF NOT EXISTS idx_recommendations_academic_score
ON recommendations(academic_score)
WHERE academic_score IS NOT NULL;

-- Index for financial score
CREATE INDEX IF NOT EXISTS idx_recommendations_financial_score
ON recommendations(financial_score)
WHERE financial_score IS NOT NULL;

-- Index for program score
CREATE INDEX IF NOT EXISTS idx_recommendations_program_score
ON recommendations(program_score)
WHERE program_score IS NOT NULL;

-- Composite index for retrieving recent recommendations
CREATE INDEX IF NOT EXISTS idx_recommendations_created_at
ON recommendations(student_id, created_at DESC);

-- ========================================
-- Student Profiles Table Indexes
-- ========================================

-- Index for GPA filtering (legacy field)
CREATE INDEX IF NOT EXISTS idx_student_profiles_gpa
ON student_profiles(gpa)
WHERE gpa IS NOT NULL;

-- Index for SAT total score filtering
CREATE INDEX IF NOT EXISTS idx_student_profiles_sat_total
ON student_profiles(sat_total)
WHERE sat_total IS NOT NULL;

-- Index for ACT composite score filtering
CREATE INDEX IF NOT EXISTS idx_student_profiles_act_composite
ON student_profiles(act_composite)
WHERE act_composite IS NOT NULL;

-- Index for intended major
CREATE INDEX IF NOT EXISTS idx_student_profiles_intended_major
ON student_profiles(intended_major)
WHERE intended_major IS NOT NULL;

-- Index for field of study
CREATE INDEX IF NOT EXISTS idx_student_profiles_field_of_study
ON student_profiles(field_of_study)
WHERE field_of_study IS NOT NULL;

-- Index for grading system
CREATE INDEX IF NOT EXISTS idx_student_profiles_grading_system
ON student_profiles(grading_system)
WHERE grading_system IS NOT NULL;

-- Index for nationality
CREATE INDEX IF NOT EXISTS idx_student_profiles_nationality
ON student_profiles(nationality)
WHERE nationality IS NOT NULL;

-- GIN index for preferred countries (JSONB)
CREATE INDEX IF NOT EXISTS idx_student_profiles_preferred_countries
ON student_profiles USING gin(preferred_countries);

-- GIN index for test scores (JSONB)
CREATE INDEX IF NOT EXISTS idx_student_profiles_test_scores
ON student_profiles USING gin(test_scores);

-- ========================================
-- Recommendation Tracking Tables Indexes
-- ========================================

-- Impressions table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_impressions') THEN
        -- Index for recommendation_session_id (correct column name)
        CREATE INDEX IF NOT EXISTS idx_impressions_recommendation_session_id
        ON recommendation_impressions(recommendation_session_id);

        -- Index for shown_at timestamp
        CREATE INDEX IF NOT EXISTS idx_impressions_shown_at
        ON recommendation_impressions(shown_at DESC);

        -- Composite index for student and shown_at
        CREATE INDEX IF NOT EXISTS idx_impressions_student_shown
        ON recommendation_impressions(student_id, shown_at DESC);

        -- Index for source
        CREATE INDEX IF NOT EXISTS idx_impressions_source
        ON recommendation_impressions(source);

        -- Index for category
        CREATE INDEX IF NOT EXISTS idx_impressions_category
        ON recommendation_impressions(category);

        -- GIN index for match_reasons JSONB
        CREATE INDEX IF NOT EXISTS idx_impressions_match_reasons
        ON recommendation_impressions USING gin(match_reasons);
    END IF;
END $$;

-- Clicks table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_clicks') THEN
        -- Composite index for student and university
        CREATE INDEX IF NOT EXISTS idx_clicks_student_university_perf
        ON recommendation_clicks(student_id, university_id);

        -- Index for clicked_at timestamp
        CREATE INDEX IF NOT EXISTS idx_clicks_clicked_at
        ON recommendation_clicks(clicked_at DESC);

        -- Index for time_to_click for analytics
        CREATE INDEX IF NOT EXISTS idx_clicks_time_to_click
        ON recommendation_clicks(time_to_click_seconds)
        WHERE time_to_click_seconds IS NOT NULL;

        -- Index for device_type
        CREATE INDEX IF NOT EXISTS idx_clicks_device_type
        ON recommendation_clicks(device_type);
    END IF;
END $$;

-- Feedback table indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_feedback') THEN
        -- Composite index for student and university
        CREATE INDEX IF NOT EXISTS idx_feedback_student_university_perf
        ON recommendation_feedback(student_id, university_id);

        -- Index for submitted_at timestamp
        CREATE INDEX IF NOT EXISTS idx_feedback_submitted_at
        ON recommendation_feedback(submitted_at DESC);

        -- GIN index for reasons JSONB
        CREATE INDEX IF NOT EXISTS idx_feedback_reasons
        ON recommendation_feedback USING gin(reasons);
    END IF;
END $$;

-- Student interaction summary indexes
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'student_interaction_summary') THEN
        -- Index for CTR percentage
        CREATE INDEX IF NOT EXISTS idx_interaction_ctr
        ON student_interaction_summary(ctr_percentage DESC)
        WHERE ctr_percentage IS NOT NULL;

        -- GIN indexes for preference JSONB fields
        CREATE INDEX IF NOT EXISTS idx_interaction_preferred_categories
        ON student_interaction_summary USING gin(preferred_categories);

        CREATE INDEX IF NOT EXISTS idx_interaction_preferred_locations
        ON student_interaction_summary USING gin(preferred_locations);
    END IF;
END $$;

-- ========================================
-- Courses Table Indexes (if exists)
-- ========================================

DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'courses') THEN
        -- Index for price filtering
        CREATE INDEX IF NOT EXISTS idx_courses_price_perf
        ON courses(price)
        WHERE price IS NOT NULL;

        -- Index for rating filtering
        CREATE INDEX IF NOT EXISTS idx_courses_rating_perf
        ON courses(rating)
        WHERE rating IS NOT NULL;

        -- Composite index for published courses by institution
        CREATE INDEX IF NOT EXISTS idx_courses_institution_published_perf
        ON courses(institution_id, is_published, created_at DESC);

        -- Index for enrolled count
        CREATE INDEX IF NOT EXISTS idx_courses_enrolled_count
        ON courses(enrolled_count DESC);
    END IF;
END $$;

-- ========================================
-- Enrollments Table Indexes (if exists)
-- ========================================

DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'enrollments') THEN
        -- Index for completion tracking
        CREATE INDEX IF NOT EXISTS idx_enrollments_completed_at_perf
        ON enrollments(completed_at DESC)
        WHERE completed_at IS NOT NULL;

        -- Index for progress percentage
        CREATE INDEX IF NOT EXISTS idx_enrollments_progress_perf
        ON enrollments(progress_percentage)
        WHERE status = 'active';

        -- Index for last accessed
        CREATE INDEX IF NOT EXISTS idx_enrollments_last_accessed
        ON enrollments(last_accessed_at DESC)
        WHERE last_accessed_at IS NOT NULL;
    END IF;
END $$;

-- ========================================
-- Performance Statistics Views
-- ========================================

-- Drop existing materialized view if it exists
DROP MATERIALIZED VIEW IF EXISTS recommendation_stats;

-- Create a materialized view for recommendation statistics (refreshed periodically)
CREATE MATERIALIZED VIEW recommendation_stats AS
SELECT
    r.student_id,
    r.category,
    COUNT(*) as total_recommendations,
    AVG(r.match_score) as avg_match_score,
    SUM(CASE WHEN r.favorited = 1 THEN 1 ELSE 0 END) as favorited_count,
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
ANALYZE student_profiles;
ANALYZE recommendations;

-- Analyze optional tables if they exist
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'programs') THEN
        ANALYZE programs;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_impressions') THEN
        ANALYZE recommendation_impressions;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_clicks') THEN
        ANALYZE recommendation_clicks;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'recommendation_feedback') THEN
        ANALYZE recommendation_feedback;
    END IF;
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'student_interaction_summary') THEN
        ANALYZE student_interaction_summary;
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
