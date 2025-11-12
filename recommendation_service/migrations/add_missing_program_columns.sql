-- Add missing columns to programs table
-- These columns are required by the API but may not exist in production

-- Add application_deadline if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'programs' AND column_name = 'application_deadline'
    ) THEN
        ALTER TABLE programs ADD COLUMN application_deadline TIMESTAMP;
        CREATE INDEX IF NOT EXISTS idx_programs_application_deadline ON programs(application_deadline);
    END IF;
END $$;

-- Add start_date if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'programs' AND column_name = 'start_date'
    ) THEN
        ALTER TABLE programs ADD COLUMN start_date TIMESTAMP;
        CREATE INDEX IF NOT EXISTS idx_programs_start_date ON programs(start_date);
    END IF;
END $$;

-- Add updated_at if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns
        WHERE table_name = 'programs' AND column_name = 'updated_at'
    ) THEN
        ALTER TABLE programs ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();
    END IF;
END $$;

-- Ensure trigger exists
CREATE OR REPLACE FUNCTION update_programs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_programs_updated_at ON programs;
CREATE TRIGGER trigger_programs_updated_at
    BEFORE UPDATE ON programs
    FOR EACH ROW
    EXECUTE FUNCTION update_programs_updated_at();
