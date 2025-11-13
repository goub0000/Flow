-- Verify institution_name and program_name columns exist
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'applications'
  AND column_name IN ('institution_name', 'program_name', 'application_fee')
ORDER BY column_name;
