-- Add RLS policies for cookie_consents table
-- This migration adds the missing Row Level Security policies for the cookie_consents table

-- Cookie consent policies
CREATE POLICY IF NOT EXISTS "Users can view own consent"
  ON public.cookie_consents
  FOR SELECT
  USING (user_id = auth.uid());

CREATE POLICY IF NOT EXISTS "Users can manage own consent"
  ON public.cookie_consents
  FOR ALL
  USING (user_id = auth.uid());

CREATE POLICY IF NOT EXISTS "Admin can view all consents"
  ON public.cookie_consents
  FOR SELECT
  USING (
    EXISTS (SELECT 1 FROM public.admin_users WHERE id = auth.uid())
  );
