-- ================================================================================
-- ADD REMAINING MISSING COLUMNS
-- ================================================================================
-- Add onboarding_completed and preferences columns
-- ================================================================================

-- Add onboarding_completed column
ALTER TABLE public.users
ADD COLUMN onboarding_completed BOOLEAN DEFAULT FALSE;

-- Add preferences column
ALTER TABLE public.users
ADD COLUMN preferences JSONB DEFAULT '{}'::jsonb;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Added onboarding_completed and preferences columns!';
END $$;
