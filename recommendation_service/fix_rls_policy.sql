-- ================================================================================
-- FIX ROW LEVEL SECURITY FOR USER REGISTRATION
-- ================================================================================
-- Allow the backend service to insert new users during registration
-- ================================================================================

-- Enable RLS on users table (if not already enabled)
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Drop existing insert policy if it exists
DROP POLICY IF EXISTS "Allow service role to insert users" ON public.users;
DROP POLICY IF EXISTS "Allow authenticated insert users" ON public.users;
DROP POLICY IF EXISTS "Enable insert for registration" ON public.users;

-- Create policy to allow user registration
-- This allows inserts when authenticated (service role or anon key with proper JWT)
CREATE POLICY "Enable insert for registration"
ON public.users
FOR INSERT
TO authenticated, anon
WITH CHECK (true);

-- Also allow service role full access
CREATE POLICY "Service role has full access"
ON public.users
FOR ALL
TO service_role
USING (true)
WITH CHECK (true);

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ RLS policies configured for user registration!';
END $$;
