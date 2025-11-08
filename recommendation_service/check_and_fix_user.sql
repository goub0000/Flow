-- ================================================================================
-- Step 1: Check if user exists in public.users
-- ================================================================================
SELECT
  id,
  email,
  display_name,
  active_role,
  available_roles,
  is_email_verified,
  created_at
FROM public.users
WHERE email = 'oumarou.gouba-1@ou.edu';

-- ================================================================================
-- Step 2: If no results above, run this to create the user record
-- ================================================================================
-- This migrates your auth.users record to public.users
INSERT INTO public.users (id, email, display_name, active_role, available_roles, is_email_verified, created_at)
SELECT
  au.id,
  au.email,
  COALESCE(au.raw_user_meta_data->>'display_name', split_part(au.email, '@', 1)) as display_name,
  COALESCE(au.raw_user_meta_data->>'role', 'student') as active_role,
  ARRAY[COALESCE(au.raw_user_meta_data->>'role', 'student')]::TEXT[] as available_roles,
  au.email_confirmed_at IS NOT NULL as is_email_verified,
  au.created_at
FROM auth.users au
WHERE au.email = 'oumarou.gouba-1@ou.edu'
  AND NOT EXISTS (
    SELECT 1 FROM public.users pu WHERE pu.id = au.id
  )
ON CONFLICT (id) DO NOTHING;

-- ================================================================================
-- Step 3: Verify the user now exists
-- ================================================================================
SELECT
  id,
  email,
  display_name,
  active_role,
  available_roles,
  is_email_verified,
  created_at
FROM public.users
WHERE email = 'oumarou.gouba-1@ou.edu';
