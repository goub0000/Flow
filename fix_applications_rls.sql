-- Fix Row-Level Security (RLS) policies for applications table

-- Drop existing policies if any
DROP POLICY IF EXISTS "Students can view their own applications" ON public.applications;
DROP POLICY IF EXISTS "Students can create their own applications" ON public.applications;
DROP POLICY IF EXISTS "Students can update their own applications before submission" ON public.applications;
DROP POLICY IF EXISTS "Institutions can view applications to them" ON public.applications;
DROP POLICY IF EXISTS "Institutions can update application status" ON public.applications;

-- Enable RLS on applications table
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;

-- Policy 1: Students can view their own applications
CREATE POLICY "Students can view their own applications"
ON public.applications
FOR SELECT
TO authenticated
USING (
  auth.uid() = student_id::uuid
);

-- Policy 2: Students can create their own applications
CREATE POLICY "Students can create their own applications"
ON public.applications
FOR INSERT
TO authenticated
WITH CHECK (
  auth.uid() = student_id::uuid
);

-- Policy 3: Students can update their own applications (before submission)
CREATE POLICY "Students can update their own applications before submission"
ON public.applications
FOR UPDATE
TO authenticated
USING (
  auth.uid() = student_id::uuid AND is_submitted = false
)
WITH CHECK (
  auth.uid() = student_id::uuid AND is_submitted = false
);

-- Policy 4: Institutions can view applications to them
CREATE POLICY "Institutions can view applications to them"
ON public.applications
FOR SELECT
TO authenticated
USING (
  auth.uid() = institution_id::uuid
);

-- Policy 5: Institutions can update application status
CREATE POLICY "Institutions can update application status"
ON public.applications
FOR UPDATE
TO authenticated
USING (
  auth.uid() = institution_id::uuid
)
WITH CHECK (
  auth.uid() = institution_id::uuid
);

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.applications TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.applications TO service_role;
