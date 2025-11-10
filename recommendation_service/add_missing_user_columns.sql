-- ================================================================================
-- ADD MISSING USER COLUMNS
-- ================================================================================
-- Backend expects profile_completed and onboarding_completed columns
-- This migration adds them if they don't exist
-- ================================================================================

-- Add profile_completed column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS profile_completed BOOLEAN DEFAULT FALSE;

-- Add onboarding_completed column
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS onboarding_completed BOOLEAN DEFAULT FALSE;

-- Add preferences column if missing (backend expects JSONB)
ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS preferences JSONB DEFAULT '{}'::jsonb;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ Missing user columns added: profile_completed, onboarding_completed, preferences';
END $$;
