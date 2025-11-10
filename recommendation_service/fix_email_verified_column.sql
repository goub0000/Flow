-- ================================================================================
-- FIX: Add email_verified column to users table
-- ================================================================================
-- The backend expects 'email_verified' but the table has 'is_email_verified'
-- This migration adds the column or renames it if it exists
-- ================================================================================

-- Option 1: If you have 'is_email_verified', rename it to 'email_verified'
ALTER TABLE public.users
RENAME COLUMN is_email_verified TO email_verified;

-- Option 2: If column doesn't exist at all, add it
-- Uncomment this if the RENAME fails:
-- ALTER TABLE public.users
-- ADD COLUMN IF NOT EXISTS email_verified BOOLEAN DEFAULT FALSE;

-- Also check for is_phone_verified -> phone_verified
ALTER TABLE public.users
RENAME COLUMN is_phone_verified TO phone_verified;

-- Uncomment if needed:
-- ALTER TABLE public.users
-- ADD COLUMN IF NOT EXISTS phone_verified BOOLEAN DEFAULT FALSE;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ email_verified and phone_verified columns fixed!';
END $$;
