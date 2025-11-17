# Activity Log System - Deployment Checklist

## Pre-Deployment Verification

### Code Files ✓
- [x] `app/utils/activity_logger.py` - Created and syntax verified
- [x] `app/schemas/activity.py` - Created and syntax verified
- [x] `app/api/admin.py` - Modified with new endpoints and syntax verified
- [x] `app/services/auth_service.py` - Modified with activity logging and syntax verified
- [x] `app/services/applications_service.py` - Modified with activity logging and syntax verified

### Database Files ✓
- [x] `migrations/create_activity_log_table.sql` - Complete SQL migration
- [x] `QUICK_SETUP_SQL.sql` - Quick copy-paste setup script

### Documentation Files ✓
- [x] `ACTIVITY_LOG_SYSTEM_SETUP.md` - Comprehensive setup guide
- [x] `ACTIVITY_LOG_IMPLEMENTATION_SUMMARY.md` - Implementation summary
- [x] `DEPLOYMENT_CHECKLIST.md` - This file

## Deployment Steps

### Step 1: Database Setup (Supabase)

1. Open Supabase Dashboard for your project
   - URL: https://app.supabase.com/project/{your-project-id}

2. Navigate to SQL Editor
   - Click "SQL Editor" in the left sidebar

3. Execute the SQL migration
   - Click "New Query"
   - Option A: Copy contents of `QUICK_SETUP_SQL.sql`
   - Option B: Copy contents of `migrations/create_activity_log_table.sql`
   - Click "Run" or press Ctrl+Enter

4. Verify table creation
   ```sql
   -- Run this query to verify
   SELECT * FROM activity_log WHERE action_type = 'system_test';
   ```
   You should see 1 test record

5. Check indexes
   ```sql
   SELECT indexname FROM pg_indexes WHERE tablename = 'activity_log';
   ```
   You should see 5 indexes

6. Verify RLS policies
   ```sql
   SELECT policyname FROM pg_policies WHERE tablename = 'activity_log';
   ```
   You should see 2 policies

### Step 2: Code Deployment

The code is already in the repository. If deploying to production:

1. **Railway Deployment** (if using Railway):
   ```bash
   git add .
   git commit -m "Add activity log system for admin dashboard"
   git push origin main
   ```
   Railway will automatically deploy

2. **Manual Deployment**:
   - Ensure all files are uploaded to production server
   - Restart the FastAPI application
   ```bash
   # Example
   uvicorn app.main:app --reload
   ```

### Step 3: Environment Variables

Verify these are set (should already be configured):

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-service-role-key
SUPABASE_JWT_SECRET=your-jwt-secret
```

Check in production:
```bash
echo $SUPABASE_URL
echo $SUPABASE_KEY
echo $SUPABASE_JWT_SECRET
```

### Step 4: Testing

#### Test 1: Create Test Activities

1. **Register a new user**:
   ```bash
   curl -X POST "http://localhost:8000/api/v1/auth/register" \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test-activity@example.com",
       "password": "Test1234!",
       "display_name": "Activity Test User",
       "role": "student"
     }'
   ```
   Expected: Success response + activity log created

2. **Login**:
   ```bash
   curl -X POST "http://localhost:8000/api/v1/auth/login" \
     -H "Content-Type: application/json" \
     -d '{
       "email": "test-activity@example.com",
       "password": "Test1234!"
     }'
   ```
   Expected: Success + access token + activity log created

3. **Verify activities in database**:
   ```sql
   SELECT
     action_type,
     user_name,
     description,
     created_at
   FROM activity_log
   ORDER BY created_at DESC
   LIMIT 5;
   ```
   Expected: See registration and login activities

#### Test 2: Admin Dashboard Endpoints

1. **Get admin access token**:
   - Login as admin user
   - Copy the access_token from response

2. **Test recent activities endpoint**:
   ```bash
   curl -X GET "http://localhost:8000/api/v1/admin/dashboard/recent-activity?limit=10" \
     -H "Authorization: Bearer {admin_access_token}"
   ```
   Expected: JSON with activities array

3. **Test activity stats endpoint**:
   ```bash
   curl -X GET "http://localhost:8000/api/v1/admin/dashboard/activity-stats" \
     -H "Authorization: Bearer {admin_access_token}"
   ```
   Expected: JSON with statistics

4. **Test user activity endpoint**:
   ```bash
   curl -X GET "http://localhost:8000/api/v1/admin/dashboard/user-activity/{user_id}?limit=20" \
     -H "Authorization: Bearer {admin_access_token}"
   ```
   Expected: JSON with user's activities

#### Test 3: Security Verification

1. **Test as non-admin user**:
   ```bash
   curl -X GET "http://localhost:8000/api/v1/admin/dashboard/recent-activity" \
     -H "Authorization: Bearer {student_access_token}"
   ```
   Expected: 403 Forbidden error

2. **Test without authentication**:
   ```bash
   curl -X GET "http://localhost:8000/api/v1/admin/dashboard/recent-activity"
   ```
   Expected: 401 Unauthorized error

#### Test 4: Application Activity Logging

1. **Submit an application** (as student):
   ```bash
   curl -X POST "http://localhost:8000/api/v1/applications/{app_id}/submit" \
     -H "Authorization: Bearer {student_access_token}"
   ```
   Expected: Success + activity log created

2. **Verify in database**:
   ```sql
   SELECT * FROM activity_log
   WHERE action_type = 'application_submitted'
   ORDER BY created_at DESC
   LIMIT 1;
   ```

### Step 5: API Documentation Verification

1. Open FastAPI docs:
   - Development: http://localhost:8000/docs
   - Production: https://your-domain.com/docs

2. Navigate to "Admin" section

3. Verify these endpoints are visible:
   - GET /api/v1/admin/dashboard/recent-activity
   - GET /api/v1/admin/dashboard/activity-stats
   - GET /api/v1/admin/dashboard/user-activity/{user_id}

4. Test directly from Swagger UI:
   - Click "Try it out"
   - Click "Authorize" and enter admin JWT token
   - Execute request
   - Verify response

### Step 6: Monitoring Setup

1. **Check activity log table size**:
   ```sql
   SELECT
     pg_size_pretty(pg_total_relation_size('activity_log')) as total_size,
     COUNT(*) as row_count
   FROM activity_log;
   ```

2. **Set up alerts** (optional):
   - Monitor table growth
   - Alert on high error rates
   - Track unusual activity patterns

3. **Configure cleanup job** (optional):
   ```sql
   -- Schedule daily cleanup at 2 AM (requires pg_cron extension)
   SELECT cron.schedule(
       'cleanup-activity-logs',
       '0 2 * * *',
       $$SELECT cleanup_old_activity_logs();$$
   );
   ```

## Post-Deployment Verification

### Functional Tests
- [ ] User registration creates activity log
- [ ] User login creates activity log
- [ ] User logout creates activity log
- [ ] Password change creates activity log
- [ ] Role switch creates activity log
- [ ] Application submission creates activity log
- [ ] Application status change creates activity log

### API Tests
- [ ] GET /api/v1/admin/dashboard/recent-activity returns data
- [ ] GET /api/v1/admin/dashboard/activity-stats returns statistics
- [ ] GET /api/v1/admin/dashboard/user-activity/{user_id} returns user activities
- [ ] Non-admin users get 403 Forbidden
- [ ] Unauthenticated requests get 401 Unauthorized

### Performance Tests
- [ ] Activity logging doesn't slow down main operations
- [ ] Query response times are acceptable (< 1 second)
- [ ] Indexes are being used (check EXPLAIN ANALYZE)

### Security Tests
- [ ] RLS policies prevent non-admin access
- [ ] Activity logs are immutable (no update/delete)
- [ ] Sensitive data not logged in metadata

## Rollback Plan

If issues occur:

### Database Rollback
```sql
-- Drop RLS policies
DROP POLICY IF EXISTS "Admins can read all activity logs" ON activity_log;
DROP POLICY IF EXISTS "System can insert activity logs" ON activity_log;

-- Drop indexes
DROP INDEX IF EXISTS idx_activity_log_timestamp;
DROP INDEX IF EXISTS idx_activity_log_user_id;
DROP INDEX IF EXISTS idx_activity_log_action_type;
DROP INDEX IF EXISTS idx_activity_log_created_at;
DROP INDEX IF EXISTS idx_activity_log_user_action;

-- Drop table
DROP TABLE IF EXISTS activity_log;

-- Drop cleanup function
DROP FUNCTION IF EXISTS cleanup_old_activity_logs();
```

### Code Rollback
```bash
# Revert commits
git revert HEAD
git push origin main

# Or restore specific files
git checkout HEAD~1 -- app/utils/activity_logger.py
git checkout HEAD~1 -- app/schemas/activity.py
git checkout HEAD~1 -- app/api/admin.py
git checkout HEAD~1 -- app/services/auth_service.py
git checkout HEAD~1 -- app/services/applications_service.py
```

## Success Criteria

Deployment is successful when:

1. ✓ Database table created with all indexes and policies
2. ✓ Test activity log entry visible in database
3. ✓ User registration/login creates activity logs
4. ✓ Admin endpoints return data without errors
5. ✓ Non-admin users cannot access activity logs
6. ✓ API documentation shows new endpoints
7. ✓ No performance degradation in main operations
8. ✓ All syntax checks pass
9. ✓ No errors in application logs

## Support Resources

- **Setup Guide**: ACTIVITY_LOG_SYSTEM_SETUP.md
- **Implementation Summary**: ACTIVITY_LOG_IMPLEMENTATION_SUMMARY.md
- **API Documentation**: {your-domain}/docs
- **Database Schema**: migrations/create_activity_log_table.sql

## Troubleshooting

### Issue: Table creation fails
**Solution**: Check if table already exists, verify permissions, review SQL syntax

### Issue: RLS policy errors
**Solution**: Ensure users table exists, verify admin roles are correct

### Issue: Activity logs not appearing
**Solution**: Check service role key is configured, verify RLS policies

### Issue: 403 Forbidden for admin users
**Solution**: Verify user's active_role is one of: admin_super, admin_content, admin_support

### Issue: Performance issues
**Solution**: Verify indexes are created, add date range filters to queries

## Sign-Off

- [ ] Database migration executed successfully
- [ ] All tests passed
- [ ] API documentation verified
- [ ] Security tests passed
- [ ] Performance acceptable
- [ ] Monitoring configured
- [ ] Documentation reviewed
- [ ] Team notified of new endpoints

**Deployment Date**: _________________

**Deployed By**: _________________

**Verified By**: _________________

**Production URL**: _________________

---

**Status**: READY FOR DEPLOYMENT
**Version**: 1.0.0
**Last Updated**: 2025-01-17
