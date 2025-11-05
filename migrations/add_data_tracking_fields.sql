-- Migration: Add Data Quality Tracking Fields
-- Phase 1 Enhancement for University Data Collection System
-- Date: 2024-11-04

-- Add data source tracking (JSONB to track which source provided each field)
ALTER TABLE universities
ADD COLUMN IF NOT EXISTS data_sources JSONB DEFAULT '{}';

-- Add confidence scoring (JSONB to track confidence level for each field)
ALTER TABLE universities
ADD COLUMN IF NOT EXISTS data_confidence JSONB DEFAULT '{}';

-- Add last scraped timestamp (when university was last processed)
ALTER TABLE universities
ADD COLUMN IF NOT EXISTS last_scraped_at TIMESTAMP;

-- Add per-field update timestamps (JSONB to track when each field was last updated)
ALTER TABLE universities
ADD COLUMN IF NOT EXISTS field_last_updated JSONB DEFAULT '{}';

-- Create index on last_scraped_at for efficient staleness queries
CREATE INDEX IF NOT EXISTS idx_universities_last_scraped
ON universities(last_scraped_at);

-- Create GIN index on data_sources for efficient JSON queries
CREATE INDEX IF NOT EXISTS idx_universities_data_sources
ON universities USING GIN(data_sources);

-- Create GIN index on field_last_updated for efficient staleness queries
CREATE INDEX IF NOT EXISTS idx_universities_field_updates
ON universities USING GIN(field_last_updated);

-- Comments for documentation
COMMENT ON COLUMN universities.data_sources IS 'Tracks which data source provided each field (e.g., {"acceptance_rate": "direct_website", "tuition": "college_scorecard"})';
COMMENT ON COLUMN universities.data_confidence IS 'Confidence score (0-1) for each field (e.g., {"acceptance_rate": 0.95, "tuition": 0.8})';
COMMENT ON COLUMN universities.last_scraped_at IS 'Timestamp when university data was last scraped/updated';
COMMENT ON COLUMN universities.field_last_updated IS 'Per-field timestamps (e.g., {"acceptance_rate": "2024-11-04T12:00:00", "tuition": "2024-10-15T08:30:00"})';
