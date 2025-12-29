-- ================================================================================
-- CREATE SUPER ADMIN ACCOUNT
-- ================================================================================
-- This script creates the initial Super Admin account directly in the database.
-- Run this in Supabase SQL Editor after setting up your database.
--
-- SECURITY: Admin accounts should ONLY be created through this SQL script,
-- never through the web interface.
-- ================================================================================

-- ================================================================================
-- STEP 1: First, update the users table constraint to allow all admin roles
-- ================================================================================

-- Drop the existing constraint
ALTER TABLE public.users DROP CONSTRAINT IF EXISTS users_active_role_check;

-- Add new constraint with ALL valid roles
ALTER TABLE public.users ADD CONSTRAINT users_active_role_check CHECK (
  active_role IN (
    -- Standard user roles
    'student',
    'counselor',
    'parent',
    'institution',
    'recommender',
    -- Admin roles (lowercase - frontend naming)
    'superadmin',
    'regionaladmin',
    'contentadmin',
    'supportadmin',
    'financeadmin',
    'analyticsadmin'
  )
);

-- Also update admin_users table if exists
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'admin_users') THEN
    ALTER TABLE public.admin_users DROP CONSTRAINT IF EXISTS admin_users_admin_role_check;

    ALTER TABLE public.admin_users ADD CONSTRAINT admin_users_admin_role_check CHECK (
      admin_role IN (
        'superadmin',
        'regionaladmin',
        'contentadmin',
        'supportadmin',
        'financeadmin',
        'analyticsadmin'
      )
    );
  END IF;
END $$;

-- ================================================================================
-- STEP 2: Create the Super Admin account
-- ================================================================================
-- IMPORTANT: Replace the values below with your actual Super Admin details
--
-- To use this script:
-- 1. First create the user in Supabase Auth (Dashboard > Authentication > Users > Add User)
--    - Email: your-super-admin@example.com
--    - Password: (set a secure password)
-- 2. Copy the user's UUID from the auth.users table
-- 3. Replace 'YOUR-USER-UUID-HERE' below with that UUID
-- 4. Replace the email and display_name as needed
-- 5. Run this script in SQL Editor
-- ================================================================================

-- Example: Create Super Admin (REPLACE VALUES!)
-- Uncomment and modify the following block:

/*
INSERT INTO public.users (
  id,
  email,
  display_name,
  active_role,
  available_roles,
  is_email_verified,
  created_at,
  updated_at
) VALUES (
  'YOUR-USER-UUID-HERE',  -- Replace with UUID from auth.users
  'superadmin@yourdomain.com',  -- Replace with admin email
  'Super Administrator',  -- Replace with admin name
  'superadmin',
  ARRAY['superadmin'],
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  active_role = 'superadmin',
  available_roles = ARRAY['superadmin'],
  updated_at = NOW();

-- Optionally, add to admin_users table for additional admin metadata
INSERT INTO public.admin_users (
  id,
  admin_role,
  permissions,
  mfa_enabled,
  is_active,
  created_at,
  updated_at
) VALUES (
  'YOUR-USER-UUID-HERE',  -- Same UUID as above
  'superadmin',
  ARRAY['*'],  -- Super admin has all permissions
  false,
  true,
  NOW(),
  NOW()
) ON CONFLICT (id) DO UPDATE SET
  admin_role = 'superadmin',
  permissions = ARRAY['*'],
  is_active = true,
  updated_at = NOW();
*/

-- ================================================================================
-- STEP 3: Verify the Super Admin was created
-- ================================================================================

-- Run this to check your admin users:
-- SELECT id, email, display_name, active_role, available_roles FROM public.users WHERE active_role LIKE '%admin%';

-- ================================================================================
-- HELPER: Promote an existing user to admin
-- ================================================================================
-- If you already have a user account and want to make them an admin:

/*
-- Replace 'user-email@example.com' with the user's email
UPDATE public.users
SET
  active_role = 'superadmin',
  available_roles = array_append(available_roles, 'superadmin'),
  updated_at = NOW()
WHERE email = 'user-email@example.com';

-- Also add to admin_users table
INSERT INTO public.admin_users (id, admin_role, permissions, is_active)
SELECT id, 'superadmin', ARRAY['*'], true
FROM public.users
WHERE email = 'user-email@example.com'
ON CONFLICT (id) DO UPDATE SET
  admin_role = 'superadmin',
  permissions = ARRAY['*'],
  is_active = true;
*/

-- ================================================================================
-- SUCCESS MESSAGE
-- ================================================================================
DO $$
BEGIN
  RAISE NOTICE '================================================================================';
  RAISE NOTICE 'Super Admin SQL script loaded successfully!';
  RAISE NOTICE '';
  RAISE NOTICE 'NEXT STEPS:';
  RAISE NOTICE '1. Create a user in Supabase Auth (Dashboard > Authentication > Users)';
  RAISE NOTICE '2. Copy their UUID from the auth.users table';
  RAISE NOTICE '3. Uncomment and modify the INSERT statement above';
  RAISE NOTICE '4. Run the INSERT to create the Super Admin';
  RAISE NOTICE '';
  RAISE NOTICE 'Or use the HELPER section to promote an existing user.';
  RAISE NOTICE '================================================================================';
END $$;
