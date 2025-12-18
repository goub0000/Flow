-- Create student_invite_codes table for Parent-Student Linking
-- Run this SQL in Supabase SQL Editor

-- Create the table
CREATE TABLE IF NOT EXISTS public.student_invite_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(12) NOT NULL UNIQUE,
    student_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    expires_at TIMESTAMPTZ NOT NULL,
    max_uses INT NOT NULL DEFAULT 1,
    uses_remaining INT NOT NULL DEFAULT 1,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_invite_codes_student_id ON public.student_invite_codes(student_id);
CREATE INDEX IF NOT EXISTS idx_invite_codes_code ON public.student_invite_codes(code);
CREATE INDEX IF NOT EXISTS idx_invite_codes_is_active ON public.student_invite_codes(is_active);
CREATE INDEX IF NOT EXISTS idx_invite_codes_expires_at ON public.student_invite_codes(expires_at);

-- Enable Row Level Security
ALTER TABLE public.student_invite_codes ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Students can view their own codes
CREATE POLICY "Students can view own codes" ON public.student_invite_codes
    FOR SELECT
    USING (auth.uid() = student_id);

-- Students can create codes (with themselves as student)
CREATE POLICY "Students can create codes" ON public.student_invite_codes
    FOR INSERT
    WITH CHECK (auth.uid() = student_id);

-- Students can update their own codes (deactivate)
CREATE POLICY "Students can update own codes" ON public.student_invite_codes
    FOR UPDATE
    USING (auth.uid() = student_id);

-- Students can delete their own codes
CREATE POLICY "Students can delete own codes" ON public.student_invite_codes
    FOR DELETE
    USING (auth.uid() = student_id);

-- Service role can do everything (for backend API)
CREATE POLICY "Service role full access on codes" ON public.student_invite_codes
    FOR ALL
    USING (auth.role() = 'service_role');

-- Add comment for documentation
COMMENT ON TABLE public.student_invite_codes IS 'Stores invite codes that students can generate for parents to link their accounts';

-- Grant permissions
GRANT ALL ON public.student_invite_codes TO authenticated;
GRANT ALL ON public.student_invite_codes TO service_role;

-- Function to generate random invite code
CREATE OR REPLACE FUNCTION generate_invite_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    result TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Comment on function
COMMENT ON FUNCTION generate_invite_code() IS 'Generates an 8-character alphanumeric invite code (excludes confusing characters like 0, O, 1, I)';
