-- Add RLS policies for cookie_consents table
-- This migration adds the missing Row Level Security policies for the cookie_consents table

-- Drop existing policies if they exist (to make this idempotent)
DROP POLICY IF EXISTS "Users can view own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Users can manage own consent" ON public.cookie_consents;
DROP POLICY IF EXISTS "Admin can view all consents" ON public.cookie_consents;

-- Cookie consent policies
CREATE POLICY "Users can view own consent"
  ON public.cookie_consents
  FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY "Users can manage own consent"
  ON public.cookie_consents
  FOR ALL
  USING (user_id = auth.uid());

CREATE POLICY "Admin can view all consents"
  ON public.cookie_consents
  FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.admin_users WHERE id = auth.uid())
  );
