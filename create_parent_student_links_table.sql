-- Create parent_student_links table for Parent Monitoring feature
-- Run this SQL in Supabase SQL Editor

-- Create the table
CREATE TABLE IF NOT EXISTS public.parent_student_links (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    relationship VARCHAR(50) NOT NULL DEFAULT 'parent',
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'declined', 'revoked')),
    can_view_grades BOOLEAN NOT NULL DEFAULT true,
    can_view_activity BOOLEAN NOT NULL DEFAULT true,
    can_view_messages BOOLEAN NOT NULL DEFAULT false,
    can_receive_alerts BOOLEAN NOT NULL DEFAULT true,
    linked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- Ensure unique parent-student pairs
    UNIQUE(parent_id, student_id)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_parent_student_links_parent_id ON public.parent_student_links(parent_id);
CREATE INDEX IF NOT EXISTS idx_parent_student_links_student_id ON public.parent_student_links(student_id);
CREATE INDEX IF NOT EXISTS idx_parent_student_links_status ON public.parent_student_links(status);

-- Enable Row Level Security
ALTER TABLE public.parent_student_links ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Parents can view their own links
CREATE POLICY "Parents can view own links" ON public.parent_student_links
    FOR SELECT
    USING (auth.uid() = parent_id);

-- Students can view links where they are the student
CREATE POLICY "Students can view their links" ON public.parent_student_links
    FOR SELECT
    USING (auth.uid() = student_id);

-- Parents can create links (with themselves as parent)
CREATE POLICY "Parents can create links" ON public.parent_student_links
    FOR INSERT
    WITH CHECK (auth.uid() = parent_id);

-- Parents can update their own links
CREATE POLICY "Parents can update own links" ON public.parent_student_links
    FOR UPDATE
    USING (auth.uid() = parent_id);

-- Students can update links where they are the student (for approval/decline)
CREATE POLICY "Students can update their links" ON public.parent_student_links
    FOR UPDATE
    USING (auth.uid() = student_id);

-- Service role can do everything (for backend API)
CREATE POLICY "Service role full access" ON public.parent_student_links
    FOR ALL
    USING (auth.role() = 'service_role');

-- Add comment for documentation
COMMENT ON TABLE public.parent_student_links IS 'Stores parent-student relationship links for the Parent Monitoring feature';

-- Grant permissions
GRANT ALL ON public.parent_student_links TO authenticated;
GRANT ALL ON public.parent_student_links TO service_role;
