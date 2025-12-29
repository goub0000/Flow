-- ================================================================================
-- ADD USER PROFILE COLUMNS
-- ================================================================================
-- This migration adds role-specific profile columns to the users table.
-- Run this in Supabase SQL Editor.
-- ================================================================================

-- ================================================================================
-- STEP 1: Add columns for Student profiles
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS school VARCHAR(255),
ADD COLUMN IF NOT EXISTS grade VARCHAR(50),
ADD COLUMN IF NOT EXISTS graduation_year INTEGER;

-- ================================================================================
-- STEP 2: Add columns for Institution profiles
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS institution_type VARCHAR(100),
ADD COLUMN IF NOT EXISTS location VARCHAR(255),
ADD COLUMN IF NOT EXISTS website VARCHAR(255),
ADD COLUMN IF NOT EXISTS programs_count INTEGER DEFAULT 0;

-- ================================================================================
-- STEP 3: Add columns for Counselor profiles
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS specialty VARCHAR(255),
ADD COLUMN IF NOT EXISTS students_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS sessions_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS years_experience INTEGER;

-- ================================================================================
-- STEP 4: Add columns for Recommender profiles
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS recommender_type VARCHAR(100),
ADD COLUMN IF NOT EXISTS organization VARCHAR(255),
ADD COLUMN IF NOT EXISTS position VARCHAR(255),
ADD COLUMN IF NOT EXISTS requests_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS completed_count INTEGER DEFAULT 0;

-- ================================================================================
-- STEP 5: Add columns for Parent profiles
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS children_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS occupation VARCHAR(255);

-- ================================================================================
-- STEP 6: Add general profile columns
-- ================================================================================
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS bio TEXT,
ADD COLUMN IF NOT EXISTS address VARCHAR(500),
ADD COLUMN IF NOT EXISTS city VARCHAR(100),
ADD COLUMN IF NOT EXISTS country VARCHAR(100),
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT true;

-- ================================================================================
-- STEP 7: Create indexes for commonly queried columns
-- ================================================================================
CREATE INDEX IF NOT EXISTS idx_users_school ON public.users(school);
CREATE INDEX IF NOT EXISTS idx_users_institution_type ON public.users(institution_type);
CREATE INDEX IF NOT EXISTS idx_users_location ON public.users(location);
CREATE INDEX IF NOT EXISTS idx_users_specialty ON public.users(specialty);
CREATE INDEX IF NOT EXISTS idx_users_organization ON public.users(organization);
CREATE INDEX IF NOT EXISTS idx_users_country ON public.users(country);
CREATE INDEX IF NOT EXISTS idx_users_is_active ON public.users(is_active);

-- ================================================================================
-- STEP 8: Add comments for documentation
-- ================================================================================
COMMENT ON COLUMN public.users.school IS 'School name for student users';
COMMENT ON COLUMN public.users.grade IS 'Current grade/year for student users';
COMMENT ON COLUMN public.users.graduation_year IS 'Expected graduation year for students';
COMMENT ON COLUMN public.users.institution_type IS 'Type: University, College, High School, etc.';
COMMENT ON COLUMN public.users.location IS 'Physical location/address';
COMMENT ON COLUMN public.users.specialty IS 'Counselor specialization area';
COMMENT ON COLUMN public.users.recommender_type IS 'Type: Teacher, Professor, Employer, etc.';
COMMENT ON COLUMN public.users.organization IS 'Organization/company name';
COMMENT ON COLUMN public.users.is_active IS 'Whether the user account is active';

-- ================================================================================
-- SUCCESS MESSAGE
-- ================================================================================
DO $$
BEGIN
  RAISE NOTICE '================================================================================';
  RAISE NOTICE 'User profile columns added successfully!';
  RAISE NOTICE '';
  RAISE NOTICE 'New columns added:';
  RAISE NOTICE '  Students: school, grade, graduation_year';
  RAISE NOTICE '  Institutions: institution_type, location, website, programs_count';
  RAISE NOTICE '  Counselors: specialty, students_count, sessions_count, years_experience';
  RAISE NOTICE '  Recommenders: recommender_type, organization, position, requests_count, completed_count';
  RAISE NOTICE '  Parents: children_count, occupation';
  RAISE NOTICE '  General: bio, address, city, country, is_active';
  RAISE NOTICE '================================================================================';
END $$;
