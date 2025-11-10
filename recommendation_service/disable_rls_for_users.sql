-- ================================================================================
-- TEMPORARILY DISABLE RLS FOR USERS TABLE
-- ================================================================================
-- This allows user registration to work
-- You can re-enable with more specific policies later
-- ================================================================================

-- Disable RLS on users table
ALTER TABLE public.users DISABLE ROW LEVEL SECURITY;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ RLS disabled for users table - registration should now work!';
  RAISE NOTICE 'ℹ️  You can re-enable RLS later with specific policies for security.';
END $$;
