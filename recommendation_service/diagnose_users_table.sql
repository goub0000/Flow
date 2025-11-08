-- ================================================================================
-- DIAGNOSTIC: Check public.users table schema
-- Run this in Supabase SQL Editor to see the current state
-- ================================================================================

-- Check if public.users table exists and show its structure
SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'users'
ORDER BY ordinal_position;

-- If the query above returns no rows, the table doesn't exist
-- If it returns rows but is missing columns like 'active_role' or 'available_roles', the schema is incomplete

-- Check for existing users in auth.users (should show your registered user)
SELECT
    id,
    email,
    email_confirmed_at,
    created_at,
    raw_user_meta_data
FROM auth.users
ORDER BY created_at DESC
LIMIT 5;

-- Check for users in public.users (may be empty if table doesn't exist or has wrong schema)
-- This will fail if the table doesn't exist
SELECT
    id,
    email,
    display_name,
    active_role,
    available_roles,
    created_at
FROM public.users
ORDER BY created_at DESC
LIMIT 5;
