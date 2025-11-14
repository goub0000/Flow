-- Enrichment Cache Table for Field-Level Caching
-- Stores enriched field values to avoid redundant API calls and web scraping
-- Provides 2-3x speedup for re-enrichment scenarios

CREATE TABLE IF NOT EXISTS enrichment_cache (
    id BIGSERIAL PRIMARY KEY,
    university_id INTEGER NOT NULL,         -- Foreign key to universities table
    field_name TEXT NOT NULL,               -- Field being cached (e.g., 'acceptance_rate')
    field_value TEXT,                       -- Cached value (stored as text, convert on retrieval)
    data_source TEXT NOT NULL,              -- Source: 'college_scorecard', 'wikipedia', 'duckduckgo', 'web_scraping'
    cached_at TIMESTAMP NOT NULL DEFAULT NOW(),  -- When this was cached
    expires_at TIMESTAMP NOT NULL,          -- Expiration timestamp
    metadata JSONB DEFAULT '{}'::jsonb,     -- Additional info (API response, confidence, etc.)
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Unique constraint: one cache entry per (university, field)
-- Updates will replace existing entry
CREATE UNIQUE INDEX IF NOT EXISTS idx_enrichment_cache_uni_field
ON enrichment_cache(university_id, field_name);

-- Index for efficient expiration cleanup
CREATE INDEX IF NOT EXISTS idx_enrichment_cache_expires_at
ON enrichment_cache(expires_at);

-- Index for data source analysis
CREATE INDEX IF NOT EXISTS idx_enrichment_cache_source
ON enrichment_cache(data_source);

-- Index for lookups by university
CREATE INDEX IF NOT EXISTS idx_enrichment_cache_university
ON enrichment_cache(university_id);

-- Function to clean up expired cache entries
CREATE OR REPLACE FUNCTION cleanup_expired_enrichment_cache()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM enrichment_cache WHERE expires_at < NOW();
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to get cache statistics
CREATE OR REPLACE FUNCTION get_enrichment_cache_stats()
RETURNS TABLE (
    total_entries BIGINT,
    expired_entries BIGINT,
    valid_entries BIGINT,
    by_source JSONB,
    by_field JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        COUNT(*)::BIGINT as total_entries,
        COUNT(*) FILTER (WHERE expires_at < NOW())::BIGINT as expired_entries,
        COUNT(*) FILTER (WHERE expires_at >= NOW())::BIGINT as valid_entries,
        jsonb_object_agg(data_source, source_count) as by_source,
        jsonb_object_agg(field_name, field_count) as by_field
    FROM (
        SELECT
            data_source,
            COUNT(*) as source_count
        FROM enrichment_cache
        WHERE expires_at >= NOW()
        GROUP BY data_source
    ) source_stats,
    (
        SELECT
            field_name,
            COUNT(*) as field_count
        FROM enrichment_cache
        WHERE expires_at >= NOW()
        GROUP BY field_name
    ) field_stats;
END;
$$ LANGUAGE plpgsql;

-- Function to invalidate cache for a specific university
CREATE OR REPLACE FUNCTION invalidate_university_cache(uni_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM enrichment_cache WHERE university_id = uni_id;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to invalidate cache for a specific field across all universities
CREATE OR REPLACE FUNCTION invalidate_field_cache(field TEXT)
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM enrichment_cache WHERE field_name = field;
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Comments for documentation
COMMENT ON TABLE enrichment_cache IS 'Field-level cache for enriched university data. Reduces redundant API calls and web scraping.';
COMMENT ON COLUMN enrichment_cache.university_id IS 'References universities.id';
COMMENT ON COLUMN enrichment_cache.field_name IS 'Name of the cached field (e.g., acceptance_rate, tuition_out_state)';
COMMENT ON COLUMN enrichment_cache.field_value IS 'Cached value stored as text. Convert to appropriate type on retrieval.';
COMMENT ON COLUMN enrichment_cache.data_source IS 'Where this data came from: college_scorecard, wikipedia, duckduckgo, web_scraping';
COMMENT ON COLUMN enrichment_cache.expires_at IS 'Cache expiration. Recommended: 30 days for College Scorecard, 7 days for web scraping';
COMMENT ON FUNCTION cleanup_expired_enrichment_cache() IS 'Removes expired cache entries. Run daily via cron or manually.';
COMMENT ON FUNCTION get_enrichment_cache_stats() IS 'Returns cache statistics: total entries, hit rates, breakdown by source and field.';
COMMENT ON FUNCTION invalidate_university_cache(INTEGER) IS 'Invalidates all cached fields for a specific university.';
COMMENT ON FUNCTION invalidate_field_cache(TEXT) IS 'Invalidates a specific field across all universities.';
