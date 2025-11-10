-- Simple column verification
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'users'
  AND column_name IN ('email_verified', 'phone_verified', 'profile_completed', 'onboarding_completed', 'preferences')
ORDER BY column_name;
