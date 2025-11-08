-- Migration: Create Programs Table
-- Cloud-based Programs Enrichment System
-- Date: 2025-01-05

-- Create programs table
CREATE TABLE IF NOT EXISTS programs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    institution_id UUID NOT NULL,
    institution_name TEXT NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT NOT NULL,
    level TEXT NOT NULL CHECK (level IN ('certificate', 'diploma', 'undergraduate', 'postgraduate', 'doctoral')),
    duration_days INTEGER NOT NULL,
    fee DECIMAL(12, 2) NOT NULL,
    currency TEXT DEFAULT 'USD',
    max_students INTEGER NOT NULL,
    enrolled_students INTEGER DEFAULT 0,
    requirements JSONB DEFAULT '[]'::jsonb,
    application_deadline TIMESTAMP,
    start_date TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_programs_institution_id ON programs(institution_id);
CREATE INDEX IF NOT EXISTS idx_programs_category ON programs(category);
CREATE INDEX IF NOT EXISTS idx_programs_level ON programs(level);
CREATE INDEX IF NOT EXISTS idx_programs_is_active ON programs(is_active);
CREATE INDEX IF NOT EXISTS idx_programs_application_deadline ON programs(application_deadline);
CREATE INDEX IF NOT EXISTS idx_programs_start_date ON programs(start_date);
CREATE INDEX IF NOT EXISTS idx_programs_created_at ON programs(created_at DESC);

-- Create GIN index on requirements for JSON queries
CREATE INDEX IF NOT EXISTS idx_programs_requirements ON programs USING GIN(requirements);

-- Create computed columns for program statistics
ALTER TABLE programs ADD COLUMN IF NOT EXISTS available_slots INTEGER GENERATED ALWAYS AS (max_students - enrolled_students) STORED;
ALTER TABLE programs ADD COLUMN IF NOT EXISTS fill_percentage DECIMAL(5, 2) GENERATED ALWAYS AS (
    CASE
        WHEN max_students > 0 THEN ROUND((enrolled_students::DECIMAL / max_students * 100), 2)
        ELSE 0
    END
) STORED;

-- Create function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_programs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to auto-update updated_at
DROP TRIGGER IF EXISTS trigger_programs_updated_at ON programs;
CREATE TRIGGER trigger_programs_updated_at
    BEFORE UPDATE ON programs
    FOR EACH ROW
    EXECUTE FUNCTION update_programs_updated_at();

-- Add comments for documentation
COMMENT ON TABLE programs IS 'Academic programs offered by institutions';
COMMENT ON COLUMN programs.id IS 'Unique program identifier';
COMMENT ON COLUMN programs.institution_id IS 'ID of the institution offering this program';
COMMENT ON COLUMN programs.institution_name IS 'Name of the institution (denormalized for performance)';
COMMENT ON COLUMN programs.name IS 'Program name';
COMMENT ON COLUMN programs.description IS 'Detailed program description';
COMMENT ON COLUMN programs.category IS 'Program category (e.g., Technology, Business, Health Sciences)';
COMMENT ON COLUMN programs.level IS 'Academic level (certificate, diploma, undergraduate, postgraduate, doctoral)';
COMMENT ON COLUMN programs.duration_days IS 'Program duration in days';
COMMENT ON COLUMN programs.fee IS 'Program fee amount';
COMMENT ON COLUMN programs.currency IS 'Currency code (e.g., USD, GHS, EUR)';
COMMENT ON COLUMN programs.max_students IS 'Maximum student capacity';
COMMENT ON COLUMN programs.enrolled_students IS 'Current number of enrolled students';
COMMENT ON COLUMN programs.requirements IS 'Array of program requirements (JSONB)';
COMMENT ON COLUMN programs.application_deadline IS 'Application deadline';
COMMENT ON COLUMN programs.start_date IS 'Program start date';
COMMENT ON COLUMN programs.is_active IS 'Whether program is accepting applications';
COMMENT ON COLUMN programs.created_at IS 'Record creation timestamp';
COMMENT ON COLUMN programs.updated_at IS 'Record last update timestamp';
COMMENT ON COLUMN programs.available_slots IS 'Computed: Available spots (max_students - enrolled_students)';
COMMENT ON COLUMN programs.fill_percentage IS 'Computed: Enrollment percentage';

-- Create program_enrichment_logs table for tracking enrichment activities
CREATE TABLE IF NOT EXISTS program_enrichment_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    program_id UUID REFERENCES programs(id) ON DELETE CASCADE,
    enrichment_type TEXT NOT NULL,
    data_source TEXT NOT NULL,
    fields_updated JSONB DEFAULT '[]'::jsonb,
    success BOOLEAN NOT NULL,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create index for enrichment logs
CREATE INDEX IF NOT EXISTS idx_program_enrichment_logs_program_id ON program_enrichment_logs(program_id);
CREATE INDEX IF NOT EXISTS idx_program_enrichment_logs_created_at ON program_enrichment_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_program_enrichment_logs_success ON program_enrichment_logs(success);

COMMENT ON TABLE program_enrichment_logs IS 'Logs for program data enrichment activities';
COMMENT ON COLUMN program_enrichment_logs.enrichment_type IS 'Type of enrichment performed (e.g., web_scrape, api_import)';
COMMENT ON COLUMN program_enrichment_logs.data_source IS 'Source of the enriched data (e.g., university_website, external_api)';
COMMENT ON COLUMN program_enrichment_logs.fields_updated IS 'Array of field names that were updated';
