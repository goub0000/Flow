-- Verify applications table schema
-- Run this in Supabase SQL Editor to see all columns

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'applications'
ORDER BY ordinal_position;
