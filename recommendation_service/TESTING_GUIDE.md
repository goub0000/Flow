# Meeting Scheduler API - Testing Guide

## Overview
This guide walks you through testing the Meeting Scheduler API endpoints on the production Railway deployment.

## Prerequisites
- Python 3.8+ with `requests` package installed
- Active user accounts in the system (Parent, Teacher, and optionally Counselor)
- Database setup completed (MEETINGS_QUICK_SETUP.sql executed)

## API Status
✅ **API Base URL**: https://web-production-51e34.up.railway.app/api/v1
✅ **Health Status**: Connected
✅ **Database**: Connected

## Step 1: Obtain JWT Tokens

### Method 1: Using the Helper Script (Recommended)
```bash
cd recommendation_service
python get_test_tokens.py
```

The script will:
1. Prompt you to login as different user types (parent, teacher, counselor)
2. Generate JWT tokens for each user
3. Extract user IDs
4. Save configuration to `test_config.txt`

### Method 2: Manual Login via API
```bash
# Login as parent
curl -X POST https://web-production-51e34.up.railway.app/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"parent@example.com","password":"yourpassword"}'

# Extract access_token and user.id from response
```

### Method 3: Using Postman/Insomnia
1. Create a POST request to `/api/v1/auth/login`
2. Body (JSON):
   ```json
   {
     "email": "user@example.com",
     "password": "yourpassword"
   }
   ```
3. Copy `access_token` from response

## Step 2: Configure Test Suite

Open `test_meetings_api.py` and update the following variables:

```python
# JWT Tokens (from Step 1)
PARENT_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
TEACHER_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
COUNSELOR_TOKEN = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# User IDs (from Step 1)
PARENT_ID = "550e8400-e29b-41d4-a716-446655440000"
STUDENT_ID = "550e8400-e29b-41d4-a716-446655440001"
TEACHER_ID = "550e8400-e29b-41d4-a716-446655440002"
COUNSELOR_ID = "550e8400-e29b-41d4-a716-446655440003"
```

**Note**: STUDENT_ID should be a student that belongs to the parent (parent-child relationship).

## Step 3: Run Tests

### Option A: Interactive Test Menu
```bash
python test_meetings_api.py
```

This launches an interactive menu where you can:
- Run individual tests
- Test specific endpoints
- Run the complete test suite

### Option B: Run All Tests
```bash
python test_meetings_api.py --all
```

This runs all tests in sequence.

## Test Scenarios

### Scenario 1: Basic Availability Setup (Staff)
Tests the staff availability management:
1. Set availability for weekdays
2. Get availability for a staff member
3. Update availability time slots
4. Delete availability slots

**Endpoints tested**:
- `POST /api/v1/staff/availability`
- `GET /api/v1/staff/{staff_id}/availability`
- `PUT /api/v1/staff/availability/{id}`
- `DELETE /api/v1/staff/availability/{id}`

### Scenario 2: Meeting Request Flow (Parent → Staff)
Tests the complete meeting request workflow:
1. Parent requests a meeting
2. Parent views their meetings
3. Staff views pending requests
4. Staff approves/declines the meeting
5. Both parties view the scheduled meeting

**Endpoints tested**:
- `POST /api/v1/meetings/request`
- `GET /api/v1/meetings/parent/{parent_id}`
- `GET /api/v1/meetings/staff/{staff_id}`
- `PUT /api/v1/meetings/{id}/approve`
- `PUT /api/v1/meetings/{id}/decline`
- `GET /api/v1/meetings/{id}`

### Scenario 3: Available Slots Calculation
Tests the smart slot availability algorithm:
1. Set staff availability
2. Create some meetings
3. Request available slots
4. Verify slots avoid conflicts with 15-min buffer

**Endpoints tested**:
- `POST /api/v1/meetings/available-slots`

### Scenario 4: Meeting Management
Tests meeting lifecycle:
1. Request meeting
2. Approve meeting
3. Cancel meeting (parent or staff)
4. Complete meeting (auto or manual)

**Endpoints tested**:
- `PUT /api/v1/meetings/{id}/cancel`
- `PUT /api/v1/meetings/{id}/complete`

### Scenario 5: Statistics and Reporting
Tests analytics endpoints:
1. Get parent meeting statistics
2. Get staff meeting statistics
3. Verify counts and status breakdown

**Endpoints tested**:
- `GET /api/v1/meetings/statistics/me`

## Expected Results

### Successful Test Outputs

#### Test 1: Get Staff List
```
Status Code: 200
Response: {
  "staff": [
    {
      "id": "...",
      "display_name": "Ms. Smith",
      "email": "teacher@example.com",
      "role": "teacher",
      "has_availability": true
    }
  ]
}
```

#### Test 5: Request Meeting
```
Status Code: 201
Response: {
  "id": "meeting-uuid",
  "parent_id": "...",
  "student_id": "...",
  "staff_id": "...",
  "status": "pending",
  "subject": "Discuss math progress",
  ...
}
```

#### Test 8: Approve Meeting
```
Status Code: 200
Response: {
  "id": "meeting-uuid",
  "status": "approved",
  "scheduled_date": "2025-11-20T14:00:00Z",
  "meeting_link": "https://meet.google.com/...",
  ...
}
```

## Common Issues and Solutions

### Issue 1: 401 Unauthorized
**Cause**: Invalid or expired JWT token
**Solution**: Re-run `get_test_tokens.py` to obtain fresh tokens

### Issue 2: 403 Forbidden
**Cause**: RLS policy blocking access (user trying to access another user's data)
**Solution**: Verify user IDs match the logged-in user

### Issue 3: 404 Not Found
**Cause**: Meeting ID or user ID doesn't exist
**Solution**: Verify IDs are correct UUIDs from your database

### Issue 4: 409 Conflict
**Cause**: Scheduling conflict detected
**Solution**: Expected behavior - choose a different time slot

### Issue 5: 422 Validation Error
**Cause**: Invalid request data (e.g., invalid date format, duration not allowed)
**Solution**: Check request data matches schema requirements

## Validation Checklist

After running tests, verify:

- [ ] Staff can set and update availability
- [ ] Parents can request meetings
- [ ] Staff can see pending requests
- [ ] Staff can approve meetings with scheduled date
- [ ] Conflict detection prevents double-booking
- [ ] Available slots calculation works correctly
- [ ] Both parties can view scheduled meetings
- [ ] Meetings can be cancelled
- [ ] Statistics show correct counts
- [ ] Activity logs are created for all actions
- [ ] RLS policies prevent unauthorized access

## Next Steps

Once API testing is complete:
1. ✅ Backend API verified working
2. 🔲 Frontend Integration (Flutter app)
3. 🔲 Set up cron job for auto-completing past meetings
4. 🔲 End-to-end testing with Flutter app
5. 🔲 User acceptance testing

## API Documentation

For detailed API documentation, visit:
https://web-production-51e34.up.railway.app/docs

This provides:
- Interactive API testing (Swagger UI)
- Complete request/response schemas
- Authentication examples
- Error response formats

## Support

If you encounter issues:
1. Check API health: `curl https://web-production-51e34.up.railway.app/health`
2. Review API logs in Railway dashboard
3. Check Supabase database for data integrity
4. Verify JWT token is valid (decode at jwt.io)
5. Review MEETINGS_API_DOCUMENTATION.md for endpoint details
