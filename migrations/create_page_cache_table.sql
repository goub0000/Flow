-- Page Cache Table for Supabase-based caching
-- Replaces local file-based cache with cloud storage
-- Phase 2 Enhancement - Cloud Migration

CREATE TABLE IF NOT EXISTS page_cache (
    url_hash TEXT PRIMARY KEY,              -- MD5 hash of URL (for fast lookup)
    url TEXT NOT NULL,                      -- Original URL
    content TEXT NOT NULL,                  -- Cached HTML content
    cached_at TIMESTAMP NOT NULL DEFAULT NOW(),  -- When cached
    expires_at TIMESTAMP NOT NULL,          -- Expiration time
    metadata JSONB DEFAULT '{}'::jsonb,     -- Additional metadata
    content_size INTEGER,                   -- Size of content in bytes
    created_at TIMESTAMP DEFAULT NOW()
);

-- Index for efficient expiration cleanup
CREATE INDEX IF NOT EXISTS idx_page_cache_expires_at ON page_cache(expires_at);

-- Index for URL lookups (in case we need it)
CREATE INDEX IF NOT EXISTS idx_page_cache_url ON page_cache(url);

-- Function to automatically clean up expired cache entries
CREATE OR REPLACE FUNCTION cleanup_expired_page_cache()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM page_cache WHERE expires_at < NOW();
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Optional: Create a scheduled job to clean up expired entries daily
-- (This requires pg_cron extension - may not be available in all Supabase plans)
-- SELECT cron.schedule('cleanup-expired-cache', '0 2 * * *', 'SELECT cleanup_expired_page_cache()');

COMMENT ON TABLE page_cache IS 'Cloud-based page cache for web scraping. Replaces local file storage.';
COMMENT ON COLUMN page_cache.url_hash IS 'MD5 hash of URL for fast lookups';
COMMENT ON COLUMN page_cache.expires_at IS 'Automatic expiration timestamp (default 7 days)';
COMMENT ON FUNCTION cleanup_expired_page_cache() IS 'Removes expired cache entries. Call periodically to maintain performance.';
