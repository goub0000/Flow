-- Enable RLS on admin_users table (if not already enabled)
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

-- Revoke anon access entirely
REVOKE ALL ON public.admin_users FROM anon;

-- Policy: Admin can read own record
CREATE POLICY "Admin can read own record"
ON public.admin_users FOR SELECT TO authenticated
USING (id = auth.uid());

-- Policy: Super admin can read all admin records
CREATE POLICY "Super admin can read all admin records"
ON public.admin_users FOR SELECT TO authenticated
USING (EXISTS (
  SELECT 1 FROM public.admin_users au
  WHERE au.id = auth.uid() AND au.admin_role = 'superadmin' AND au.is_active = true
));

-- Policy: Super admin can create admin records
CREATE POLICY "Super admin can create admin records"
ON public.admin_users FOR INSERT TO authenticated
WITH CHECK (EXISTS (
  SELECT 1 FROM public.admin_users au
  WHERE au.id = auth.uid() AND au.admin_role = 'superadmin' AND au.is_active = true
));

-- Policy: Super admin can update any admin record
CREATE POLICY "Super admin can update admin records"
ON public.admin_users FOR UPDATE TO authenticated
USING (EXISTS (
  SELECT 1 FROM public.admin_users au
  WHERE au.id = auth.uid() AND au.admin_role = 'superadmin' AND au.is_active = true
));

-- Policy: Admin can update own record
CREATE POLICY "Admin can update own record"
ON public.admin_users FOR UPDATE TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- No DELETE policy: use soft-delete via is_active flag
