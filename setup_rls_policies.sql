-- ============================================================================
-- Row Level Security (RLS) Policies Setup Script
-- Flow EdTech Platform - Applications Table
-- ============================================================================
--
-- This script sets up comprehensive RLS policies for the applications table
-- to ensure proper data access control across different user roles.
--
-- Run this script in Supabase SQL Editor:
-- 1. Go to Supabase Dashboard → SQL Editor
-- 2. Paste this entire script
-- 3. Click "Run" to execute
--
-- ============================================================================

-- Step 1: Enable RLS on applications table (if not already enabled)
-- ============================================================================
ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

-- Step 2: Drop existing policies (clean slate)
-- ============================================================================
DROP POLICY IF EXISTS "Students can create their own applications" ON applications;
DROP POLICY IF EXISTS "Students can view their own applications" ON applications;
DROP POLICY IF EXISTS "Students can update their draft applications" ON applications;
DROP POLICY IF EXISTS "Students can delete their draft applications" ON applications;
DROP POLICY IF EXISTS "Institutions can view their applications" ON applications;
DROP POLICY IF EXISTS "Institutions can update their applications" ON applications;
DROP POLICY IF EXISTS "Admins can view all applications" ON applications;
DROP POLICY IF EXISTS "Admins can update all applications" ON applications;

-- Step 3: Student Policies
-- ============================================================================

-- Policy 1: Students can INSERT their own applications
CREATE POLICY "Students can create their own applications"
ON applications FOR INSERT
TO authenticated
WITH CHECK (
  -- The student_id in the application must match the authenticated user's ID
  auth.uid()::text = student_id
);

-- Policy 2: Students can SELECT (view) their own applications
CREATE POLICY "Students can view their own applications"
ON applications FOR SELECT
TO authenticated
USING (
  -- Can view if they are the student who created the application
  auth.uid()::text = student_id
);

-- Policy 3: Students can UPDATE their own applications (before submission only)
CREATE POLICY "Students can update their draft applications"
ON applications FOR UPDATE
TO authenticated
USING (
  -- Can update only their own applications
  auth.uid()::text = student_id
  -- And only if not yet submitted or if still in draft/pending status
  AND is_submitted = false
)
WITH CHECK (
  -- Ensure they can't change ownership
  auth.uid()::text = student_id
);

-- Policy 4: Students can DELETE their own applications (before submission only)
CREATE POLICY "Students can delete their draft applications"
ON applications FOR DELETE
TO authenticated
USING (
  -- Can delete only their own applications
  auth.uid()::text = student_id
  -- And only if not yet submitted
  AND is_submitted = false
);

-- Step 4: Institution Policies
-- ============================================================================

-- Policy 5: Institutions can SELECT applications submitted to them
CREATE POLICY "Institutions can view their applications"
ON applications FOR SELECT
TO authenticated
USING (
  -- Can view if they are the institution receiving the application
  auth.uid()::text = institution_id
);

-- Policy 6: Institutions can UPDATE applications submitted to them
CREATE POLICY "Institutions can update their applications"
ON applications FOR UPDATE
TO authenticated
USING (
  -- Can update applications submitted to them
  auth.uid()::text = institution_id
)
WITH CHECK (
  -- Ensure they can't change institution_id or student_id
  auth.uid()::text = institution_id
);

-- Step 5: Admin Policies (Super Admin, Content Admin)
-- ============================================================================

-- Policy 7: Admins can view all applications
CREATE POLICY "Admins can view all applications"
ON applications FOR SELECT
TO authenticated
USING (
  -- Check if user has admin role
  EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid()::text
    AND (
      active_role = 'admin_super'
      OR active_role = 'admin_content'
      OR 'admin_super' = ANY(available_roles)
    )
  )
);

-- Policy 8: Admins can update all applications
CREATE POLICY "Admins can update all applications"
ON applications FOR UPDATE
TO authenticated
USING (
  -- Check if user has admin role
  EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid()::text
    AND (
      active_role = 'admin_super'
      OR active_role = 'admin_content'
      OR 'admin_super' = ANY(available_roles)
    )
  )
)
WITH CHECK (
  -- Same check for WITH CHECK
  EXISTS (
    SELECT 1 FROM users
    WHERE id = auth.uid()::text
    AND (
      active_role = 'admin_super'
      OR active_role = 'admin_content'
      OR 'admin_super' = ANY(available_roles)
    )
  )
);

-- ============================================================================
-- Additional RLS Policies for Related Tables
-- ============================================================================

-- Programs Table
-- ============================================================================
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can view active programs" ON programs;
DROP POLICY IF EXISTS "Institutions can create their programs" ON programs;
DROP POLICY IF EXISTS "Institutions can update their programs" ON programs;
DROP POLICY IF EXISTS "Institutions can delete their programs" ON programs;

-- Anyone (including anonymous) can view active programs
CREATE POLICY "Anyone can view active programs"
ON programs FOR SELECT
TO authenticated, anon
USING (is_active = true);

-- Institutions can create their own programs
CREATE POLICY "Institutions can create their programs"
ON programs FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid()::text = institution_id::text
);

-- Institutions can update their own programs
CREATE POLICY "Institutions can update their programs"
ON programs FOR UPDATE
TO authenticated
USING (auth.uid()::text = institution_id::text)
WITH CHECK (auth.uid()::text = institution_id::text);

-- Institutions can delete their own programs
CREATE POLICY "Institutions can delete their programs"
ON programs FOR DELETE
TO authenticated
USING (auth.uid()::text = institution_id::text);

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Verify RLS is enabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE tablename IN ('applications', 'programs')
ORDER BY tablename;

-- View all policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename IN ('applications', 'programs')
ORDER BY tablename, policyname;

-- ============================================================================
-- Test Queries (Run these to verify policies work)
-- ============================================================================

-- Test 1: Check applications table structure
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'applications'
-- ORDER BY ordinal_position;

-- Test 2: Verify RLS policies count
-- SELECT tablename, COUNT(*) as policy_count
-- FROM pg_policies
-- WHERE tablename = 'applications'
-- GROUP BY tablename;

-- ============================================================================
-- Success Message
-- ============================================================================
DO $$
BEGIN
  RAISE NOTICE '✓ RLS policies successfully configured!';
  RAISE NOTICE '✓ Applications table: 8 policies created';
  RAISE NOTICE '✓ Programs table: 4 policies created';
  RAISE NOTICE '✓ Run verification queries above to confirm';
END $$;

-- ============================================================================
-- Troubleshooting
-- ============================================================================
--
-- If you get "permission denied" errors:
-- 1. Make sure you're authenticated as a user with proper role
-- 2. Check that auth.uid() matches the student_id/institution_id in your data
-- 3. Verify the users table has the correct active_role and available_roles
--
-- To temporarily disable RLS for debugging:
-- ALTER TABLE applications DISABLE ROW LEVEL SECURITY;
--
-- To re-enable:
-- ALTER TABLE applications ENABLE ROW LEVEL SECURITY;
--
-- ============================================================================
