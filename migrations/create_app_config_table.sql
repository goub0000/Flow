-- Application Configuration Table
-- Stores all configuration values in Supabase
-- Eliminates need for local .env files
-- Phase 2 Enhancement - Cloud Migration

CREATE TABLE IF NOT EXISTS app_config (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    description TEXT,
    is_secret BOOLEAN DEFAULT false,
    updated_at TIMESTAMP DEFAULT NOW(),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Index for faster lookups
CREATE INDEX IF NOT EXISTS idx_app_config_key ON app_config(key);

-- Function to get config value
CREATE OR REPLACE FUNCTION get_config(config_key TEXT)
RETURNS TEXT AS $$
DECLARE
    config_value TEXT;
BEGIN
    SELECT value INTO config_value FROM app_config WHERE key = config_key;
    RETURN config_value;
END;
$$ LANGUAGE plpgsql;

-- Function to set config value
CREATE OR REPLACE FUNCTION set_config(config_key TEXT, config_value TEXT, config_description TEXT DEFAULT NULL)
RETURNS VOID AS $$
BEGIN
    INSERT INTO app_config (key, value, description, updated_at)
    VALUES (config_key, config_value, config_description, NOW())
    ON CONFLICT (key)
    DO UPDATE SET value = config_value, description = config_description, updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- Insert default configuration values
-- These will be populated by migration script

COMMENT ON TABLE app_config IS 'Application configuration stored in Supabase. Replaces .env files.';
COMMENT ON COLUMN app_config.key IS 'Configuration key (e.g., SUPABASE_URL)';
COMMENT ON COLUMN app_config.value IS 'Configuration value';
COMMENT ON COLUMN app_config.is_secret IS 'Whether this is a sensitive value (API keys, passwords)';
COMMENT ON FUNCTION get_config(TEXT) IS 'Retrieve configuration value by key';
COMMENT ON FUNCTION set_config(TEXT, TEXT, TEXT) IS 'Set configuration value';
