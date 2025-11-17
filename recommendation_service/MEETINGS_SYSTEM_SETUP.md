# Parent Meeting Scheduler System - Setup Guide

## Overview

The Parent Meeting Scheduler System enables parents to request meetings with teachers and counselors, and allows staff to manage their availability and approve/decline meeting requests.

## Features

- **Meeting Requests**: Parents can request meetings with teachers or counselors
- **Staff Availability**: Teachers/counselors can set their weekly availability
- **Approval Workflow**: Staff can approve or decline meeting requests
- **Smart Scheduling**: System checks for conflicts and suggests available time slots
- **Activity Logging**: All meeting actions are logged for audit trails
- **Real-time Notifications**: Integration with activity log system
- **Row Level Security**: Supabase RLS ensures data privacy

## System Requirements

- Supabase account with PostgreSQL database
- Python 3.8+
- FastAPI application (already configured)
- Existing users table with roles: parent, teacher, counselor

## Installation Steps

### 1. Database Setup

**Option A: Quick Setup (Recommended)**

1. Open Supabase SQL Editor
2. Run the entire `MEETINGS_QUICK_SETUP.sql` script
3. Verify tables are created

**Option B: Migration Script**

1. Navigate to `migrations/` directory
2. Run `create_meetings_tables.sql`

### 2. Verify Database Setup

Run this query in Supabase SQL Editor:

```sql
-- Check tables
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN ('meetings', 'staff_availability');

-- Check RLS policies
SELECT tablename, policyname FROM pg_policies
WHERE tablename IN ('meetings', 'staff_availability');
```

Expected output:
- 2 tables created
- 9 RLS policies created

### 3. Register API Routes

In your FastAPI main application file (`worker.py` or `main.py`), add:

```python
from app.api import meetings

# Register meeting routes
app.include_router(
    meetings.router,
    prefix="/api/v1",
    tags=["meetings"]
)
```

### 4. Test API Endpoints

Use the test examples in `MEETINGS_API_DOCUMENTATION.md` or run:

```bash
# Test staff list endpoint
curl -X GET "http://localhost:8000/api/v1/staff/list" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 5. Optional: Configure Cron Job

To auto-complete past meetings, set up a cron job:

```sql
-- Run hourly to mark completed meetings
SELECT cron.schedule(
    'auto-complete-meetings',
    '0 * * * *',
    'SELECT auto_complete_past_meetings()'
);
```

## Configuration

### Environment Variables

No additional environment variables are required. The system uses your existing Supabase configuration:

- `SUPABASE_URL`
- `SUPABASE_SERVICE_KEY` or `SUPABASE_ANON_KEY`

### User Roles

Ensure your users table has these roles configured:
- `parent`: Can request meetings
- `teacher`: Can approve/decline meetings, set availability
- `counselor`: Can approve/decline meetings, set availability
- `admin`: Full access to all meetings

## Database Schema

### Tables Created

#### 1. `meetings`
Stores meeting requests and schedules.

**Key Fields:**
- `id`: UUID primary key
- `parent_id`: Parent who requested
- `student_id`: Student the meeting is about
- `staff_id`: Teacher/counselor assigned
- `status`: pending, approved, declined, cancelled, completed
- `scheduled_date`: Meeting date/time
- `meeting_mode`: in_person, video_call, phone_call

#### 2. `staff_availability`
Stores weekly availability schedules for staff.

**Key Fields:**
- `id`: UUID primary key
- `staff_id`: Staff member
- `day_of_week`: 0=Sunday, 1=Monday, ..., 6=Saturday
- `start_time`: Availability start
- `end_time`: Availability end
- `is_active`: Enable/disable slot

## Security

### Row Level Security (RLS)

The system implements comprehensive RLS policies:

**Parents can:**
- View their own meetings
- Create new meeting requests
- Cancel their meetings
- Add parent notes

**Teachers/Counselors can:**
- View meetings assigned to them
- Approve/decline meeting requests
- Set their availability
- Add staff notes

**Admins can:**
- View all meetings
- Delete meetings
- Manage all availability

### Data Privacy

- Parents cannot see other parents' meetings
- Staff can only see meetings assigned to them
- All meeting data is encrypted at rest (Supabase default)
- JWT authentication required for all endpoints

## Troubleshooting

### Issue: "Meeting not found"

**Cause**: RLS policy preventing access

**Solution**: Verify user has correct role and permissions

```sql
-- Check user role
SELECT id, email, active_role FROM users WHERE id = 'user-id';
```

### Issue: "This time slot conflicts with another meeting"

**Cause**: Double-booking detected

**Solution**:
1. Check existing meetings for staff member
2. Use available slots endpoint to find free times

```bash
curl -X POST "http://localhost:8000/api/v1/meetings/available-slots" \
  -H "Content-Type: application/json" \
  -d '{
    "staff_id": "staff-id",
    "start_date": "2025-01-20T00:00:00Z",
    "end_date": "2025-01-27T00:00:00Z",
    "duration_minutes": 30
  }'
```

### Issue: "Availability already set for this day"

**Cause**: Trying to create duplicate availability

**Solution**: Use update endpoint instead of create

### Issue: Tables not created

**Cause**: Users table doesn't exist or foreign key constraint fails

**Solution**: Ensure users table exists first:

```sql
-- Verify users table
SELECT * FROM information_schema.tables WHERE table_name = 'users';
```

## Performance Optimization

### Indexes

The system creates these indexes for optimal performance:
- `idx_meetings_parent_id`: Fast parent queries
- `idx_meetings_staff_id`: Fast staff queries
- `idx_meetings_status`: Filter by status
- `idx_meetings_scheduled_date`: Sort by date
- `idx_meetings_staff_status`: Composite for staff dashboard

### Query Optimization

For large datasets, use pagination:

```python
# Get meetings with pagination
GET /api/v1/meetings/parent/{parent_id}?limit=20&offset=0
```

## Monitoring

### Activity Logs

All meeting actions are logged in `activity_log` table:

```sql
-- View recent meeting activities
SELECT * FROM activity_log
WHERE action_type LIKE 'meeting_%'
ORDER BY timestamp DESC
LIMIT 10;
```

### Meeting Statistics

Check meeting statistics via API:

```bash
curl -X GET "http://localhost:8000/api/v1/meetings/statistics/me" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Backup and Recovery

### Backup Meeting Data

```sql
-- Export all meetings
COPY (SELECT * FROM meetings) TO '/tmp/meetings_backup.csv' CSV HEADER;

-- Export all availability
COPY (SELECT * FROM staff_availability) TO '/tmp/availability_backup.csv' CSV HEADER;
```

### Restore from Backup

```sql
-- Import meetings
COPY meetings FROM '/tmp/meetings_backup.csv' CSV HEADER;

-- Import availability
COPY staff_availability FROM '/tmp/availability_backup.csv' CSV HEADER;
```

## Next Steps

1. **Test the System**: Use API documentation to test all endpoints
2. **Configure Frontend**: Integrate with your React/Next.js application
3. **Set Up Notifications**: Configure email/SMS notifications for meeting approvals
4. **Add Calendar Integration**: Sync meetings with Google Calendar or Outlook
5. **Create Reports**: Build analytics dashboard for meeting statistics

## Support

For issues or questions:
1. Check `MEETINGS_API_DOCUMENTATION.md` for API details
2. Review `MEETINGS_DEPLOYMENT_CHECKLIST.md` for deployment steps
3. Examine logs in `activity_log` table
4. Test with sample data from `MEETINGS_QUICK_SETUP.sql`

## Related Documentation

- `MEETINGS_API_DOCUMENTATION.md`: Complete API reference
- `MEETINGS_DEPLOYMENT_CHECKLIST.md`: Production deployment guide
- `MEETINGS_QUICK_SETUP.sql`: Quick setup script
- `migrations/create_meetings_tables.sql`: Detailed migration

## Version History

- **v1.0** (2025-11-17): Initial release
  - Meeting request/approval workflow
  - Staff availability management
  - Available slots calculation
  - Activity logging integration
  - Row Level Security implementation
