-- Add RLS policies for cookie_consents table
-- This migration adds the missing Row Level Security policies for the cookie_consents table

-- Drop existing policies if they exist (to make this idempotent)
DROP POLICY IF EXISTS "Users can view own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Users can manage own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Users can insert own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Users can update own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Admin can view all consents" ON public.cookie_consents;
DROP POLICY IF EXISTS "Service role full access" ON public.cookie_consents;

-- Cookie consent policies
-- SELECT: Users can view their own consent
CREATE POLICY "Users can view own consent"
  ON public.cookie_consents
  FOR SELECT
  USING (user_id = auth.uid());

-- INSERT: Users can insert their own consent (WITH CHECK for new rows)
CREATE POLICY "Users can insert own consent"
  ON public.cookie_consents
  FOR INSERT
  WITH CHECK (user_id = auth.uid());

-- UPDATE: Users can update their own consent
CREATE POLICY "Users can update own consent"
  ON public.cookie_consents
  FOR UPDATE
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- Admin can view all consents
CREATE POLICY "Admin can view all consents"
  ON public.cookie_consents
  FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.admin_users WHERE id = auth.uid())
  );

-- Grant permissions to authenticated users
GRANT SELECT, INSERT, UPDATE ON public.cookie_consents TO authenticated;
GRANT ALL ON public.cookie_consents TO service_role;
