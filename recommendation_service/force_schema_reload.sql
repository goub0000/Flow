-- ================================================================================
-- FORCE POSTGREST SCHEMA CACHE RELOAD
-- ================================================================================
-- This notifies PostgREST to reload its schema cache immediately
-- Run this after making schema changes (adding/renaming columns)
-- ================================================================================

-- Send reload signal to PostgREST
NOTIFY pgrst, 'reload schema';

-- Success message
DO $$
BEGIN
  RAISE NOTICE '✅ PostgREST schema reload signal sent!';
  RAISE NOTICE 'Wait 2-3 seconds for the schema cache to refresh.';
END $$;
