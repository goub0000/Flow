-- ================================================================================
-- VERIFY COLUMNS EXIST
-- ================================================================================
-- Check that all required columns are present in the users table
-- ================================================================================

SELECT
    column_name,
    data_type,
    is_nullable,
    column_default
FROM
    information_schema.columns
WHERE
    table_schema = 'public'
    AND table_name = 'users'
    AND column_name IN (
        'email_verified',
        'phone_verified',
        'profile_completed',
        'onboarding_completed',
        'preferences'
    )
ORDER BY
    column_name;
