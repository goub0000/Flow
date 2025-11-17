# Activity Log System Setup Guide

## Overview

The Activity Log System provides comprehensive audit logging for the Find Your Path platform. It tracks user activities, system events, and administrative actions for monitoring, compliance, and analytics purposes.

## Features

- **Comprehensive Activity Tracking**: Logs user registrations, logins, application submissions, status changes, and more
- **Admin Dashboard Integration**: Real-time activity feed and statistics for administrators
- **Flexible Filtering**: Filter activities by user, action type, date range, and more
- **Secure Access Control**: Role-based access with RLS policies (admin-only read access)
- **Performance Optimized**: Indexed queries for fast retrieval of large activity datasets
- **Automatic Cleanup**: Optional scheduled job to maintain data retention policies

## Architecture

### Components

1. **Database Layer**
   - `activity_log` table in Supabase PostgreSQL
   - RLS policies for secure access control
   - Optimized indexes for query performance

2. **Utility Layer**
   - `app/utils/activity_logger.py`: Core logging functions
   - Sync and async logging support
   - Activity type constants

3. **API Layer**
   - `app/api/admin.py`: Admin dashboard endpoints
   - `GET /api/v1/admin/dashboard/recent-activity`: Recent activity feed
   - `GET /api/v1/admin/dashboard/activity-stats`: Activity statistics
   - `GET /api/v1/admin/dashboard/user-activity/{user_id}`: User-specific activity

4. **Schema Layer**
   - `app/schemas/activity.py`: Pydantic models for request/response validation

5. **Integration Layer**
   - Activity logging integrated into:
     - Authentication service (login, registration, logout, password changes)
     - Application service (submission, status changes, withdrawals)
     - Other key services (can be expanded)

## Setup Instructions

### Step 1: Create Database Table

Run the SQL migration in Supabase SQL Editor:

```bash
# Location: migrations/create_activity_log_table.sql
```

Execute the SQL file in your Supabase project:

1. Go to Supabase Dashboard → SQL Editor
2. Click "New Query"
3. Copy and paste the contents of `migrations/create_activity_log_table.sql`
4. Click "Run"

This will:
- Create the `activity_log` table
- Add indexes for performance
- Set up RLS policies for security
- Create cleanup function (optional)

### Step 2: Verify Table Creation

```sql
-- Verify table exists
SELECT * FROM activity_log LIMIT 1;

-- Check indexes
SELECT indexname, indexdef FROM pg_indexes
WHERE tablename = 'activity_log';

-- Verify RLS policies
SELECT policyname, cmd, roles, qual
FROM pg_policies
WHERE tablename = 'activity_log';
```

### Step 3: Test Activity Logging

The system is already integrated. Test by:

1. **Register a new user**:
   ```bash
   POST /api/v1/auth/register
   ```
   This should create an activity log entry with `action_type: user_registration`

2. **Login**:
   ```bash
   POST /api/v1/auth/login
   ```
   This should create an activity log entry with `action_type: user_login`

3. **Submit an application** (as student):
   ```bash
   POST /api/v1/applications/{application_id}/submit
   ```
   This should create an activity log entry with `action_type: application_submitted`

### Step 4: Test Admin Dashboard Endpoints

As an admin user, test the dashboard endpoints:

#### Get Recent Activities
```bash
GET /api/v1/admin/dashboard/recent-activity?limit=10
Authorization: Bearer {admin_access_token}
```

**Response:**
```json
{
  "activities": [
    {
      "id": "uuid",
      "timestamp": "2025-01-17T10:30:00Z",
      "user_name": "John Doe",
      "user_email": "john@example.com",
      "user_role": "student",
      "action_type": "application_submitted",
      "description": "Application submitted to Harvard University for Computer Science",
      "metadata": {
        "application_id": "app-123",
        "institution_name": "Harvard University",
        "program_name": "Computer Science"
      }
    }
  ],
  "total_count": 150,
  "limit": 10,
  "has_more": true
}
```

#### Get Activity Statistics
```bash
GET /api/v1/admin/dashboard/activity-stats
Authorization: Bearer {admin_access_token}
```

**Response:**
```json
{
  "total_activities": 1520,
  "activities_today": 45,
  "activities_this_week": 312,
  "activities_this_month": 1245,
  "top_action_types": {
    "user_login": 450,
    "application_submitted": 120,
    "user_registration": 85
  },
  "top_users": [
    {
      "user_id": "uuid",
      "user_name": "John Doe",
      "user_email": "john@example.com",
      "activity_count": 45
    }
  ],
  "recent_registrations": 12,
  "recent_logins": 45,
  "recent_applications": 8
}
```

#### Get User Activity History
```bash
GET /api/v1/admin/dashboard/user-activity/{user_id}?limit=20
Authorization: Bearer {admin_access_token}
```

## Activity Types Reference

The system tracks the following activity types (defined in `app/utils/activity_logger.py`):

### User Management
- `user_registration`: New user registered
- `user_login`: User logged in
- `user_logout`: User logged out
- `user_password_changed`: Password changed
- `user_profile_updated`: Profile information updated
- `user_role_changed`: Active role switched
- `user_deleted`: Account deleted

### Application Management
- `application_submitted`: Application submitted for review
- `application_updated`: Application information updated
- `application_status_changed`: Application status changed (by institution)
- `application_withdrawn`: Application withdrawn by student
- `application_deleted`: Application deleted

### Program Management
- `program_created`: New program created
- `program_updated`: Program information updated
- `program_deleted`: Program deleted

### University Management
- `university_created`: New university added
- `university_updated`: University information updated
- `university_deleted`: University removed

### Course Management
- `course_created`: New course created
- `course_updated`: Course information updated
- `course_deleted`: Course deleted
- `enrollment_created`: Student enrolled in course
- `enrollment_updated`: Enrollment status changed

### System Events
- `system_error`: System error occurred
- `system_maintenance`: Maintenance event
- `system_backup`: Backup performed
- `data_import`: Data imported
- `data_export`: Data exported

## Adding New Activity Logging

To log activities in new services or endpoints:

### Option 1: Async Context (in async functions)
```python
from app.utils.activity_logger import log_activity, ActivityType

async def my_service_function(user_id: str):
    # Your business logic here

    # Log activity
    await log_activity(
        action_type=ActivityType.CUSTOM_ACTION,
        description="User performed custom action",
        user_id=user_id,
        user_name="John Doe",
        user_email="john@example.com",
        user_role="student",
        metadata={
            "additional_data": "value"
        }
    )
```

### Option 2: Sync Context (in sync functions or FastAPI endpoints)
```python
from app.utils.activity_logger import log_activity_sync, ActivityType

def my_sync_function(user_id: str):
    # Your business logic here

    # Log activity
    log_activity_sync(
        action_type=ActivityType.CUSTOM_ACTION,
        description="User performed custom action",
        user_id=user_id,
        user_name="John Doe",
        user_email="john@example.com",
        user_role="student",
        metadata={
            "additional_data": "value"
        }
    )
```

### Best Practices

1. **Always wrap activity logging in try-except**: Activity logging should never break the main flow
   ```python
   try:
       log_activity_sync(...)
   except Exception as log_error:
       logger.warning(f"Failed to log activity: {log_error}")
   ```

2. **Use descriptive descriptions**: Make descriptions human-readable and informative
   - Good: "User John Doe submitted application to Harvard University"
   - Bad: "Application submitted"

3. **Include relevant metadata**: Store structured data in the metadata field for filtering and analysis
   ```python
   metadata={
       "application_id": "app-123",
       "institution_id": "inst-456",
       "program_name": "Computer Science"
   }
   ```

4. **Log user context**: Always include user_id, user_name, user_email, and user_role when available

5. **Use appropriate activity types**: Use predefined constants from `ActivityType` class

## Data Retention

The system includes an optional cleanup function to maintain data retention policies:

```sql
-- Manually run cleanup (deletes logs older than 365 days)
SELECT cleanup_old_activity_logs();
```

To automate cleanup (requires pg_cron extension):
```sql
-- Schedule daily cleanup at 2 AM
SELECT cron.schedule(
    'cleanup-activity-logs',
    '0 2 * * *',
    $$SELECT cleanup_old_activity_logs();$$
);
```

## Security Considerations

1. **RLS Policies**: Only admin users can read activity logs
2. **Sensitive Data**: Avoid logging passwords, tokens, or PII in metadata
3. **Access Control**: Activity logging uses service role key to bypass RLS for inserts
4. **Audit Trail**: Activity logs are immutable (no update/delete operations in normal flow)

## Performance Optimization

The system includes several optimizations:

1. **Indexed Queries**:
   - `idx_activity_log_timestamp`: Fast time-based queries
   - `idx_activity_log_user_id`: Fast user filtering
   - `idx_activity_log_action_type`: Fast action type filtering
   - `idx_activity_log_user_action`: Composite index for complex queries

2. **Async Logging**: Non-blocking activity logging (optional)

3. **Batch Queries**: Statistics endpoints use efficient aggregation queries

4. **Limit Results**: All endpoints enforce reasonable limits (default: 10-20 records)

## Monitoring & Alerts

Consider setting up alerts for:

- High error rates (system_error activity type)
- Unusual login patterns (many failed logins)
- Bulk operations (many activities in short time)
- Application status changes (for SLA monitoring)

## API Documentation

All endpoints are documented in the FastAPI interactive docs:
- Development: `http://localhost:8000/docs`
- Production: `https://your-domain.com/docs`

Navigate to the "Admin" tag to see activity log endpoints.

## Troubleshooting

### Issue: Activity logs not appearing

**Solution:**
1. Check RLS policies are set up correctly
2. Verify admin user has correct role (`admin_super`, `admin_content`, or `admin_support`)
3. Check Supabase service key is configured in environment variables
4. Review application logs for errors

### Issue: Permission denied when querying activity_log

**Solution:**
1. Ensure you're authenticated as an admin user
2. Verify RLS policy allows your role to read from activity_log
3. Check JWT token is valid and contains correct role

### Issue: Activity logging failing silently

**Solution:**
1. Check application logs for warnings
2. Verify Supabase connection is working
3. Ensure activity_log table exists
4. Test with a simple manual insert

### Issue: Slow query performance

**Solution:**
1. Verify indexes are created (check with `\d activity_log` in psql)
2. Add date range filters to queries
3. Use pagination with limit/offset
4. Consider archiving old logs

## Future Enhancements

Potential improvements to consider:

1. **Real-time Activity Stream**: WebSocket connection for live updates
2. **Advanced Analytics**: Dashboards with charts and visualizations
3. **Export Functionality**: CSV/PDF export for audit reports
4. **Activity Filters**: More granular filtering options
5. **Activity Notifications**: Alert admins of critical activities
6. **Anomaly Detection**: ML-based detection of unusual patterns
7. **Integration with External Services**: Send logs to Datadog, Sentry, etc.

## Support

For questions or issues:
1. Check the FastAPI docs at `/docs`
2. Review application logs
3. Consult the Supabase dashboard
4. Contact the development team

---

**Last Updated**: 2025-01-17
**Version**: 1.0.0
**Author**: Development Team
