-- Complete programs table schema migration
-- Adds all required columns if they don't exist

-- Add all missing columns
DO $$
BEGIN
    -- Basic info columns
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'institution_name') THEN
        ALTER TABLE programs ADD COLUMN institution_name TEXT NOT NULL DEFAULT 'Unknown Institution';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'name') THEN
        ALTER TABLE programs ADD COLUMN name TEXT NOT NULL DEFAULT 'Unnamed Program';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'description') THEN
        ALTER TABLE programs ADD COLUMN description TEXT;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'category') THEN
        ALTER TABLE programs ADD COLUMN category TEXT NOT NULL DEFAULT 'General';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'level') THEN
        ALTER TABLE programs ADD COLUMN level TEXT NOT NULL DEFAULT 'undergraduate';
        ALTER TABLE programs ADD CONSTRAINT programs_level_check CHECK (level IN ('certificate', 'diploma', 'undergraduate', 'postgraduate', 'doctoral'));
    END IF;

    -- Duration and fees
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'duration_days') THEN
        ALTER TABLE programs ADD COLUMN duration_days INTEGER NOT NULL DEFAULT 365;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'fee') THEN
        ALTER TABLE programs ADD COLUMN fee DECIMAL(12, 2) NOT NULL DEFAULT 0;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'currency') THEN
        ALTER TABLE programs ADD COLUMN currency TEXT DEFAULT 'USD';
    END IF;

    -- Student capacity
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'max_students') THEN
        ALTER TABLE programs ADD COLUMN max_students INTEGER NOT NULL DEFAULT 100;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'enrolled_students') THEN
        ALTER TABLE programs ADD COLUMN enrolled_students INTEGER DEFAULT 0;
    END IF;

    -- Requirements and dates
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'requirements') THEN
        ALTER TABLE programs ADD COLUMN requirements JSONB DEFAULT '[]'::jsonb;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'application_deadline') THEN
        ALTER TABLE programs ADD COLUMN application_deadline TIMESTAMP;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'start_date') THEN
        ALTER TABLE programs ADD COLUMN start_date TIMESTAMP;
    END IF;

    -- Status and timestamps
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'is_active') THEN
        ALTER TABLE programs ADD COLUMN is_active BOOLEAN DEFAULT true;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'created_at') THEN
        ALTER TABLE programs ADD COLUMN created_at TIMESTAMP DEFAULT NOW();
    END IF;

    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'programs' AND column_name = 'updated_at') THEN
        ALTER TABLE programs ADD COLUMN updated_at TIMESTAMP DEFAULT NOW();
    END IF;
END $$;

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_programs_institution_id ON programs(institution_id);
CREATE INDEX IF NOT EXISTS idx_programs_category ON programs(category);
CREATE INDEX IF NOT EXISTS idx_programs_level ON programs(level);
CREATE INDEX IF NOT EXISTS idx_programs_is_active ON programs(is_active);
CREATE INDEX IF NOT EXISTS idx_programs_application_deadline ON programs(application_deadline);
CREATE INDEX IF NOT EXISTS idx_programs_start_date ON programs(start_date);
CREATE INDEX IF NOT EXISTS idx_programs_created_at ON programs(created_at DESC);

-- Create GIN index on requirements for JSON queries
CREATE INDEX IF NOT EXISTS idx_programs_requirements ON programs USING GIN(requirements);

-- Create trigger function for updated_at
CREATE OR REPLACE FUNCTION update_programs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_programs_updated_at ON programs;
CREATE TRIGGER trigger_programs_updated_at
    BEFORE UPDATE ON programs
    FOR EACH ROW
    EXECUTE FUNCTION update_programs_updated_at();

-- Remove default constraints after adding (so new rows don't get these defaults)
ALTER TABLE programs ALTER COLUMN institution_name DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN name DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN category DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN level DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN duration_days DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN fee DROP DEFAULT;
ALTER TABLE programs ALTER COLUMN max_students DROP DEFAULT;
