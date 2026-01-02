-- ================================================================================
-- MIGRATION: Create content_assignments table
-- ================================================================================
-- Run this in Supabase SQL Editor to create the content assignments table
-- This table tracks which content/courses are assigned to which users
-- ================================================================================

-- Create the content_assignments table if it doesn't exist
CREATE TABLE IF NOT EXISTS public.content_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content_id UUID NOT NULL REFERENCES public.courses(id) ON DELETE CASCADE,
    target_id UUID REFERENCES public.users(id) ON DELETE CASCADE,  -- NULL for all_students
    target_type VARCHAR(50) NOT NULL DEFAULT 'student',  -- 'student', 'institution', 'all_students'
    is_required BOOLEAN DEFAULT FALSE,
    due_date TIMESTAMPTZ,
    assigned_by UUID REFERENCES public.users(id),
    assigned_at TIMESTAMPTZ DEFAULT NOW(),
    status VARCHAR(50) DEFAULT 'assigned',  -- 'assigned', 'in_progress', 'completed', 'overdue'
    progress INTEGER DEFAULT 0,  -- 0-100
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for efficient querying
CREATE INDEX IF NOT EXISTS idx_content_assignments_content_id ON public.content_assignments(content_id);
CREATE INDEX IF NOT EXISTS idx_content_assignments_target_id ON public.content_assignments(target_id);
CREATE INDEX IF NOT EXISTS idx_content_assignments_target_type ON public.content_assignments(target_type);
CREATE INDEX IF NOT EXISTS idx_content_assignments_status ON public.content_assignments(status);

-- Enable Row Level Security
ALTER TABLE public.content_assignments ENABLE ROW LEVEL SECURITY;

-- Policy: Admins can do everything
CREATE POLICY "Admins can manage all assignments" ON public.content_assignments
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM public.users
            WHERE users.id = auth.uid()
            AND users.active_role IN ('superadmin', 'admin', 'contentadmin')
        )
    );

-- Policy: Users can see their own assignments
CREATE POLICY "Users can view their assignments" ON public.content_assignments
    FOR SELECT
    USING (
        target_id = auth.uid()
        OR target_type = 'all_students'
    );

-- Policy: Users can update their own assignment progress
CREATE POLICY "Users can update their assignment progress" ON public.content_assignments
    FOR UPDATE
    USING (target_id = auth.uid())
    WITH CHECK (target_id = auth.uid());

-- Grant permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON public.content_assignments TO authenticated;
GRANT SELECT ON public.content_assignments TO anon;

-- ================================================================================
-- VERIFICATION
-- ================================================================================
-- Run this to verify the table was created correctly:
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'content_assignments';
-- ================================================================================

