-- ================================================================================
-- MIGRATION: Update users table role constraint to include all admin roles
-- ================================================================================
-- Run this in Supabase SQL Editor to fix the admin role validation
-- Issue: The CHECK constraint on active_role doesn't include all admin types
-- ================================================================================

-- Step 1: Drop the existing constraint
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_active_role_check;

-- Step 2: Add new constraint with ALL valid roles
-- Including both snake_case and camelCase naming conventions for compatibility
ALTER TABLE public.users ADD CONSTRAINT users_active_role_check CHECK (
  active_role IN (
    -- Standard user roles
    'student',
    'counselor',
    'parent',
    'institution',
    'recommender',
    -- Admin roles (camelCase - frontend naming)
    'superadmin',
    'regionaladmin',
    'contentadmin',
    'supportadmin',
    'financeadmin',
    'analyticsadmin',
    -- Admin roles (mixed case - legacy)
    'superAdmin',
    'regionalAdmin',
    'contentAdmin',
    'supportAdmin',
    'financeAdmin',
    'analyticsAdmin',
    -- Admin roles (snake_case - backend naming)
    'admin_super',
    'admin_regional',
    'admin_content',
    'admin_support',
    'admin_finance',
    'admin_analytics'
  )
);

-- Step 3: Also update the admin_users table constraint if it exists
ALTER TABLE public.admin_users DROP CONSTRAINT IF EXISTS admin_users_admin_role_check;

ALTER TABLE public.admin_users ADD CONSTRAINT admin_users_admin_role_check CHECK (
  admin_role IN (
    -- Admin roles (camelCase - frontend naming)
    'superadmin',
    'regionaladmin',
    'contentadmin',
    'supportadmin',
    'financeadmin',
    'analyticsadmin',
    -- Admin roles (mixed case - legacy)
    'superAdmin',
    'regionalAdmin',
    'contentAdmin',
    'supportAdmin',
    'financeAdmin',
    'analyticsAdmin',
    -- Admin roles (snake_case - backend naming)
    'admin_super',
    'admin_regional',
    'admin_content',
    'admin_support',
    'admin_finance',
    'admin_analytics'
  )
);

-- Step 4: Verify the constraints were updated
DO $$
DECLARE
  constraint_def TEXT;
BEGIN
  -- Check users table constraint
  SELECT pg_get_constraintdef(oid) INTO constraint_def
  FROM pg_constraint
  WHERE conname = 'users_active_role_check' AND conrelid = 'public.users'::regclass;

  IF constraint_def IS NOT NULL THEN
    RAISE NOTICE '✅ users_active_role_check constraint updated successfully';
    RAISE NOTICE 'Constraint definition: %', constraint_def;
  ELSE
    RAISE WARNING '⚠️ users_active_role_check constraint not found after update';
  END IF;

  -- Check admin_users table constraint
  SELECT pg_get_constraintdef(oid) INTO constraint_def
  FROM pg_constraint
  WHERE conname = 'admin_users_admin_role_check' AND conrelid = 'public.admin_users'::regclass;

  IF constraint_def IS NOT NULL THEN
    RAISE NOTICE '✅ admin_users_admin_role_check constraint updated successfully';
  END IF;
END $$;

-- ================================================================================
-- DONE! All admin roles should now be accepted:
-- - superadmin/superAdmin/admin_super (Super Admin)
-- - regionaladmin/regionalAdmin/admin_regional (Regional Admin)
-- - contentadmin/contentAdmin/admin_content (Content Admin)
-- - supportadmin/supportAdmin/admin_support (Support Admin)
-- - financeadmin/financeAdmin/admin_finance (Finance Admin)
-- - analyticsadmin/analyticsAdmin/admin_analytics (Analytics Admin)
-- ================================================================================
