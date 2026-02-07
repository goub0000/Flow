-- Fix infinite recursion in admin_users RLS policies
-- Problem: Policies query admin_users to check if user is superadmin, which triggers RLS again
-- Solution: Use SECURITY DEFINER function to bypass RLS when checking admin status

-- Step 1: Create a security definer function to check if user is superadmin
-- This function runs with elevated privileges and bypasses RLS
CREATE OR REPLACE FUNCTION public.is_superadmin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admin_users
    WHERE id = auth.uid()
      AND admin_role = 'superadmin'
      AND is_active = true
  );
$$;

-- Step 2: Create a function to check if user is any type of admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.admin_users
    WHERE id = auth.uid()
      AND is_active = true
  );
$$;

-- Step 3: Drop existing problematic policies
DROP POLICY IF EXISTS "Admin can read own record" ON public.admin_users;
DROP POLICY IF EXISTS "Super admin can read all admin records" ON public.admin_users;
DROP POLICY IF EXISTS "Super admin can create admin records" ON public.admin_users;
DROP POLICY IF EXISTS "Super admin can update admin records" ON public.admin_users;
DROP POLICY IF EXISTS "Admin can update own record" ON public.admin_users;

-- Step 4: Recreate policies using the security definer functions

-- Policy: Admin can read own record (no recursion - just checks id)
CREATE POLICY "Admin can read own record"
ON public.admin_users FOR SELECT TO authenticated
USING (id = auth.uid());

-- Policy: Super admin can read all admin records (uses function to avoid recursion)
CREATE POLICY "Super admin can read all admin records"
ON public.admin_users FOR SELECT TO authenticated
USING (public.is_superadmin());

-- Policy: Super admin can create admin records
CREATE POLICY "Super admin can create admin records"
ON public.admin_users FOR INSERT TO authenticated
WITH CHECK (public.is_superadmin());

-- Policy: Super admin can update any admin record
CREATE POLICY "Super admin can update admin records"
ON public.admin_users FOR UPDATE TO authenticated
USING (public.is_superadmin());

-- Policy: Admin can update own record
CREATE POLICY "Admin can update own record"
ON public.admin_users FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Grant execute on functions to authenticated users
GRANT EXECUTE ON FUNCTION public.is_superadmin() TO authenticated;
GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated;

-- Note: service_role bypasses RLS entirely, so backend API calls work without issues
