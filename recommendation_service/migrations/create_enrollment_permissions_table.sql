-- ================================================================================
-- Enrollment Permissions Table
-- Manages which students can enroll in which courses
-- Run this SQL in your Supabase SQL Editor
-- ================================================================================

-- Step 1: Create the enrollment_permissions table
CREATE TABLE IF NOT EXISTS enrollment_permissions (
    -- Primary identification
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Relationships
    student_id UUID NOT NULL,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    institution_id UUID NOT NULL,

    -- Status tracking
    status VARCHAR(50) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'approved', 'denied', 'revoked', 'expired')),

    -- Grant information
    granted_by VARCHAR(50), -- 'institution', 'student_request', 'auto', 'admin'
    granted_by_user_id UUID,

    -- Review information
    reviewed_at TIMESTAMPTZ,
    reviewed_by_user_id UUID,

    -- Validity period
    valid_from TIMESTAMPTZ DEFAULT NOW(),
    valid_until TIMESTAMPTZ,

    -- Additional info
    notes TEXT,
    denial_reason TEXT,

    -- Audit timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Constraints
    CONSTRAINT unique_student_course_permission UNIQUE (student_id, course_id)
);

-- Step 2: Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_student_id
    ON enrollment_permissions(student_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_course_id
    ON enrollment_permissions(course_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_institution_id
    ON enrollment_permissions(institution_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_status
    ON enrollment_permissions(status);
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_student_course
    ON enrollment_permissions(student_id, course_id);
CREATE INDEX IF NOT EXISTS idx_enrollment_permissions_course_status
    ON enrollment_permissions(course_id, status);

-- Step 3: Create updated_at trigger
CREATE OR REPLACE FUNCTION update_enrollment_permissions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_update_enrollment_permissions_updated_at ON enrollment_permissions;
CREATE TRIGGER trigger_update_enrollment_permissions_updated_at
    BEFORE UPDATE ON enrollment_permissions
    FOR EACH ROW
    EXECUTE FUNCTION update_enrollment_permissions_updated_at();

-- Step 4: Enable RLS
ALTER TABLE enrollment_permissions ENABLE ROW LEVEL SECURITY;

-- Step 5: Create RLS policies (permissive for backend-controlled access)
DROP POLICY IF EXISTS "Allow all operations on enrollment_permissions" ON enrollment_permissions;
CREATE POLICY "Allow all operations on enrollment_permissions"
    ON enrollment_permissions
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Step 6: Add comments
COMMENT ON TABLE enrollment_permissions IS 'Manages student enrollment permissions for courses';
COMMENT ON COLUMN enrollment_permissions.student_id IS 'UUID of the student requesting/granted enrollment';
COMMENT ON COLUMN enrollment_permissions.course_id IS 'UUID of the course';
COMMENT ON COLUMN enrollment_permissions.institution_id IS 'UUID of the institution that owns the course';
COMMENT ON COLUMN enrollment_permissions.status IS 'Permission status: pending, approved, denied, revoked, expired';
COMMENT ON COLUMN enrollment_permissions.granted_by IS 'How the permission was granted: institution, student_request, auto, admin';
COMMENT ON COLUMN enrollment_permissions.valid_until IS 'When the permission expires (null = never expires)';

-- ================================================================================
-- Verification query - run this to confirm the table was created
-- ================================================================================
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_name = 'enrollment_permissions'
-- ORDER BY ordinal_position;
