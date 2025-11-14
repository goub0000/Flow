-- Create enrichment_jobs table for batch processing job queue
-- This table tracks background enrichment jobs and their progress

CREATE TABLE IF NOT EXISTS enrichment_jobs (
    -- Primary key
    job_id TEXT PRIMARY KEY,

    -- Status tracking
    status TEXT NOT NULL CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled')),

    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    started_at TIMESTAMP,
    completed_at TIMESTAMP,

    -- Job parameters
    university_limit INTEGER,  -- Max universities to enrich (NULL = all)
    university_ids INTEGER[],  -- Specific university IDs (NULL = use limit)
    max_concurrent INTEGER NOT NULL DEFAULT 5,

    -- Progress tracking
    total_universities INTEGER NOT NULL DEFAULT 0,
    processed_universities INTEGER NOT NULL DEFAULT 0,
    successful_updates INTEGER NOT NULL DEFAULT 0,
    total_fields_filled INTEGER NOT NULL DEFAULT 0,
    errors_count INTEGER NOT NULL DEFAULT 0,

    -- Results
    error_message TEXT,
    results JSONB DEFAULT '{}'::jsonb,

    -- Metadata
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Indexes for efficient queries
CREATE INDEX IF NOT EXISTS idx_enrichment_jobs_status
ON enrichment_jobs(status);

CREATE INDEX IF NOT EXISTS idx_enrichment_jobs_created_at
ON enrichment_jobs(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_enrichment_jobs_status_created
ON enrichment_jobs(status, created_at DESC);

-- Index for cleanup queries (old completed jobs)
CREATE INDEX IF NOT EXISTS idx_enrichment_jobs_cleanup
ON enrichment_jobs(status, completed_at)
WHERE status IN ('completed', 'failed', 'cancelled');

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_enrichment_jobs_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enrichment_jobs_updated_at
    BEFORE UPDATE ON enrichment_jobs
    FOR EACH ROW
    EXECUTE FUNCTION update_enrichment_jobs_updated_at();
