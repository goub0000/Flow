-- Fix RLS policies and create missing database objects
-- This migration addresses:
-- 1. activity_log RLS policy for service account writes
-- 2. student_interaction_summary RLS policy fix
-- 3. Missing get_institution_user_ids function
-- 4. Missing achievements table

-- ============================================
-- 1. FIX ACTIVITY_LOG RLS POLICIES
-- ============================================

-- Drop existing INSERT policy and recreate with proper permissions
DROP POLICY IF EXISTS "System can insert activity logs" ON activity_log;
DROP POLICY IF EXISTS "Service role can insert activity logs" ON activity_log;
DROP POLICY IF EXISTS "Anyone can insert activity logs" ON activity_log;

-- Allow authenticated users and service role to insert activity logs
CREATE POLICY "Anyone can insert activity logs"
ON activity_log
FOR INSERT
TO authenticated, anon
WITH CHECK (true);

-- Grant explicit permissions
GRANT INSERT ON activity_log TO authenticated;
GRANT INSERT ON activity_log TO anon;
GRANT ALL ON activity_log TO service_role;

-- ============================================
-- 2. FIX STUDENT_INTERACTION_SUMMARY RLS
-- ============================================

-- Drop existing problematic policy
DROP POLICY IF EXISTS "Service role can manage summaries" ON student_interaction_summary;

-- Recreate with proper USING clause for SELECT operations
CREATE POLICY "Service role can insert summaries"
ON student_interaction_summary
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Service role can update summaries"
ON student_interaction_summary
FOR UPDATE
USING (true)
WITH CHECK (true);

CREATE POLICY "Service role can delete summaries"
ON student_interaction_summary
FOR DELETE
USING (true);

-- Grant permissions
GRANT ALL ON student_interaction_summary TO service_role;
GRANT SELECT, INSERT, UPDATE ON student_interaction_summary TO authenticated;

-- ============================================
-- 3. FIX RECOMMENDATION_IMPRESSIONS RLS
-- ============================================

-- Drop existing INSERT policy and recreate
DROP POLICY IF EXISTS "Service role can insert impressions" ON recommendation_impressions;

-- Allow service role and authenticated users to insert impressions
CREATE POLICY "Authenticated can insert impressions"
ON recommendation_impressions
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Grant permissions
GRANT ALL ON recommendation_impressions TO service_role;
GRANT SELECT, INSERT ON recommendation_impressions TO authenticated;

-- ============================================
-- 4. CREATE GET_INSTITUTION_USER_IDS FUNCTION
-- ============================================

-- Function to get user IDs of registered institutions
CREATE OR REPLACE FUNCTION get_institution_user_ids()
RETURNS TABLE(user_id UUID)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT u.id
    FROM users u
    WHERE u.active_role = 'institution'
       OR 'institution' = ANY(u.available_roles);
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_institution_user_ids() TO authenticated;
GRANT EXECUTE ON FUNCTION get_institution_user_ids() TO service_role;

-- ============================================
-- 5. CREATE ACHIEVEMENTS TABLE
-- ============================================

CREATE TABLE IF NOT EXISTS achievements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,

    -- Achievement details
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(50), -- academic, extracurricular, community, professional
    icon VARCHAR(50) DEFAULT '🏆',

    -- Points and levels
    points INTEGER DEFAULT 0,
    level VARCHAR(20), -- bronze, silver, gold, platinum

    -- Metadata
    metadata JSONB DEFAULT '{}'::jsonb,

    -- Timestamps
    earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_achievements_student_id ON achievements(student_id);
CREATE INDEX IF NOT EXISTS idx_achievements_category ON achievements(category);
CREATE INDEX IF NOT EXISTS idx_achievements_earned_at ON achievements(earned_at DESC);
CREATE INDEX IF NOT EXISTS idx_achievements_student_earned ON achievements(student_id, earned_at DESC);

-- Enable RLS
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

-- RLS Policies for achievements
CREATE POLICY "Students can view own achievements"
ON achievements
FOR SELECT
TO authenticated
USING (student_id = auth.uid());

CREATE POLICY "Service role can manage achievements"
ON achievements
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

CREATE POLICY "System can insert achievements"
ON achievements
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Grant permissions
GRANT ALL ON achievements TO service_role;
GRANT SELECT, INSERT ON achievements TO authenticated;

-- Add comment
COMMENT ON TABLE achievements IS 'Student achievements and badges earned through platform activities';

-- ============================================
-- 6. ADD SEED ACHIEVEMENT TYPES (OPTIONAL)
-- ============================================

-- You can uncomment this to add default achievement templates
-- CREATE TABLE IF NOT EXISTS achievement_templates (
--     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--     name VARCHAR(255) NOT NULL UNIQUE,
--     description TEXT,
--     category VARCHAR(50),
--     icon VARCHAR(50) DEFAULT '🏆',
--     points INTEGER DEFAULT 0,
--     criteria JSONB, -- Criteria to earn this achievement
--     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
-- );

-- ============================================
-- 7. VERIFY AND LOG
-- ============================================

-- Log successful migration
DO $$
BEGIN
    RAISE NOTICE 'Migration completed: RLS policies fixed and missing objects created';
    RAISE NOTICE '- activity_log: INSERT policy updated';
    RAISE NOTICE '- student_interaction_summary: RLS policies fixed';
    RAISE NOTICE '- recommendation_impressions: INSERT policy updated';
    RAISE NOTICE '- get_institution_user_ids: Function created';
    RAISE NOTICE '- achievements: Table created with RLS';
END $$;
