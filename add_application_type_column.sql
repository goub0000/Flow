-- Add application_type column to applications table
-- Run this in Supabase SQL Editor

-- Add the column with a default value
ALTER TABLE public.applications
ADD COLUMN IF NOT EXISTS application_type TEXT DEFAULT 'undergraduate';

-- Add a check constraint for valid values
ALTER TABLE public.applications
ADD CONSTRAINT check_application_type
CHECK (application_type IN ('undergraduate', 'graduate', 'certificate', 'diploma', 'exchange'));

-- Update existing rows if any (set to undergraduate as default)
UPDATE public.applications
SET application_type = 'undergraduate'
WHERE application_type IS NULL;

-- Add additional columns that the backend expects but are missing
ALTER TABLE public.applications
ADD COLUMN IF NOT EXISTS essay TEXT,
ADD COLUMN IF NOT EXISTS references JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS extracurricular JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS work_experience JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS is_submitted BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}'::jsonb,
ADD COLUMN IF NOT EXISTS reviewed_by UUID REFERENCES public.users(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS reviewer_notes TEXT,
ADD COLUMN IF NOT EXISTS decision_date TIMESTAMPTZ;
