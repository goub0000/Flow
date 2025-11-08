-- ================================================================================
-- FIX: Create/Update public.users table and migrate existing auth users
-- ================================================================================
-- Run this in Supabase SQL Editor to fix the authentication issue
-- ================================================================================

-- Step 1: Create the public.users table with correct schema
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  phone_number TEXT,
  photo_url TEXT,
  active_role TEXT NOT NULL DEFAULT 'student' CHECK (active_role IN ('student', 'counselor', 'parent', 'institution', 'recommender', 'superAdmin', 'regionalAdmin', 'contentAdmin')),
  available_roles TEXT[] NOT NULL DEFAULT ARRAY['student'],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login_at TIMESTAMPTZ,
  is_email_verified BOOLEAN DEFAULT FALSE,
  is_phone_verified BOOLEAN DEFAULT FALSE,
  metadata JSONB DEFAULT '{}'::jsonb,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 2: Create index for performance
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_active_role ON public.users(active_role);

-- Step 3: Enable Row Level Security
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policies
DROP POLICY IF EXISTS "Users can view own profile" ON public.users;
CREATE POLICY "Users can view own profile" ON public.users FOR SELECT USING (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);

-- Step 5: Create trigger for updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_users_updated_at ON public.users;
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Step 6: Migrate existing auth.users to public.users
-- This will create public.users records for any auth users that don't have one yet
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
WHERE NOT EXISTS (
  SELECT 1 FROM public.users pu WHERE pu.id = au.id
)
ON CONFLICT (id) DO NOTHING;

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ public.users table created/updated successfully!';
  RAISE NOTICE '✅ Existing auth users migrated to public.users';
END $$;
