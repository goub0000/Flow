# Parent Meeting Scheduler - API Documentation

## Base URL

```
http://localhost:8000/api/v1
```

Or for production:
```
https://your-domain.com/api/v1
```

## Authentication

All endpoints require JWT authentication via Bearer token.

```
Authorization: Bearer YOUR_JWT_TOKEN
```

Get token from login endpoint:
```bash
POST /api/v1/auth/login
```

## API Endpoints Overview

| Endpoint | Method | Role | Description |
|----------|--------|------|-------------|
| `/meetings/request` | POST | Parent | Request a meeting |
| `/meetings/parent/{parent_id}` | GET | Parent/Admin | Get parent's meetings |
| `/meetings/{meeting_id}/cancel` | PUT | Parent/Staff | Cancel a meeting |
| `/meetings/staff/{staff_id}` | GET | Staff/Admin | Get staff's meetings |
| `/meetings/{meeting_id}/approve` | PUT | Staff | Approve a meeting |
| `/meetings/{meeting_id}/decline` | PUT | Staff | Decline a meeting |
| `/staff/availability` | POST | Staff | Set availability |
| `/staff/{staff_id}/availability` | GET | Any | Get availability |
| `/staff/availability/{id}` | PUT | Staff | Update availability |
| `/staff/availability/{id}` | DELETE | Staff | Delete availability |
| `/meetings/{meeting_id}` | GET | Any | Get meeting details |
| `/meetings/available-slots` | POST | Any | Get available time slots |
| `/staff/list` | GET | Any | List teachers/counselors |
| `/meetings/statistics/me` | GET | Any | Get meeting statistics |

---

## Parent Endpoints

### 1. Request a Meeting

**Endpoint:** `POST /meetings/request`

**Role:** Parent

**Description:** Create a new meeting request with a teacher or counselor.

**Request Body:**

```json
{
  "staff_id": "uuid-of-teacher-or-counselor",
  "student_id": "uuid-of-student",
  "staff_type": "teacher",
  "meeting_type": "parent_teacher",
  "subject": "Discuss math progress",
  "scheduled_date": "2025-01-25T14:00:00Z",
  "duration_minutes": 30,
  "meeting_mode": "video_call",
  "meeting_link": null,
  "location": null,
  "notes": "Want to discuss improvement strategies",
  "parent_notes": "Concerned about recent test scores"
}
```

**Field Details:**

- `staff_type`: `"teacher"` or `"counselor"`
- `meeting_type`: `"parent_teacher"` or `"parent_counselor"`
- `duration_minutes`: 15, 30, 45, 60, 90, or 120
- `meeting_mode`: `"in_person"`, `"video_call"`, or `"phone_call"`
- `scheduled_date`: Optional preferred date/time (ISO 8601 format)

**Response:** `201 Created`

```json
{
  "id": "meeting-uuid",
  "parent_id": "parent-uuid",
  "parent_name": "John Doe",
  "student_id": "student-uuid",
  "student_name": "Jane Doe",
  "staff_id": "staff-uuid",
  "staff_name": "Ms. Smith",
  "staff_type": "teacher",
  "meeting_type": "parent_teacher",
  "status": "pending",
  "scheduled_date": "2025-01-25T14:00:00Z",
  "duration_minutes": 30,
  "meeting_mode": "video_call",
  "meeting_link": null,
  "location": null,
  "subject": "Discuss math progress",
  "notes": "Want to discuss improvement strategies",
  "parent_notes": "Concerned about recent test scores",
  "staff_notes": null,
  "created_at": "2025-01-20T10:30:00Z",
  "updated_at": "2025-01-20T10:30:00Z"
}
```

**cURL Example:**

```bash
curl -X POST "http://localhost:8000/api/v1/meetings/request" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "staff_id": "staff-uuid",
    "student_id": "student-uuid",
    "staff_type": "teacher",
    "meeting_type": "parent_teacher",
    "subject": "Discuss math progress",
    "duration_minutes": 30,
    "meeting_mode": "video_call",
    "notes": "Want to discuss improvement strategies"
  }'
```

---

### 2. Get Parent's Meetings

**Endpoint:** `GET /meetings/parent/{parent_id}`

**Role:** Parent (own data) or Admin

**Query Parameters:**

- `status` (optional): Filter by status (`pending`, `approved`, `declined`, `cancelled`, `completed`)
- `limit` (optional): Number of results (default: 50, max: 100)
- `offset` (optional): Pagination offset (default: 0)

**Response:** `200 OK`

```json
[
  {
    "id": "meeting-uuid-1",
    "parent_id": "parent-uuid",
    "parent_name": "John Doe",
    "student_id": "student-uuid",
    "student_name": "Jane Doe",
    "staff_id": "staff-uuid",
    "staff_name": "Ms. Smith",
    "staff_type": "teacher",
    "meeting_type": "parent_teacher",
    "status": "approved",
    "scheduled_date": "2025-01-25T14:00:00Z",
    "duration_minutes": 30,
    "meeting_mode": "video_call",
    "meeting_link": "https://meet.google.com/abc-defg-hij",
    "subject": "Discuss math progress",
    "created_at": "2025-01-20T10:30:00Z",
    "updated_at": "2025-01-21T09:15:00Z"
  }
]
```

**cURL Example:**

```bash
# Get all meetings
curl -X GET "http://localhost:8000/api/v1/meetings/parent/parent-uuid" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get pending meetings only
curl -X GET "http://localhost:8000/api/v1/meetings/parent/parent-uuid?status=pending" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get with pagination
curl -X GET "http://localhost:8000/api/v1/meetings/parent/parent-uuid?limit=20&offset=0" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 3. Cancel a Meeting

**Endpoint:** `PUT /meetings/{meeting_id}/cancel`

**Role:** Parent or Staff (for their own meetings)

**Query Parameters:**

- `cancellation_reason` (optional): Reason for cancellation

**Response:** `200 OK`

```json
{
  "id": "meeting-uuid",
  "status": "cancelled",
  "parent_notes": "Cancellation: Need to reschedule due to conflict",
  ...
}
```

**cURL Example:**

```bash
curl -X PUT "http://localhost:8000/api/v1/meetings/meeting-uuid/cancel?cancellation_reason=Need%20to%20reschedule" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## Staff Endpoints (Teachers/Counselors)

### 4. Get Staff's Meetings

**Endpoint:** `GET /meetings/staff/{staff_id}`

**Role:** Staff (own data) or Admin

**Query Parameters:** Same as parent meetings

**Response:** Same format as parent meetings

**cURL Example:**

```bash
# Get all meetings for staff
curl -X GET "http://localhost:8000/api/v1/meetings/staff/staff-uuid" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get only pending requests
curl -X GET "http://localhost:8000/api/v1/meetings/staff/staff-uuid?status=pending" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 5. Approve a Meeting

**Endpoint:** `PUT /meetings/{meeting_id}/approve`

**Role:** Teacher or Counselor

**Request Body:**

```json
{
  "scheduled_date": "2025-01-25T14:00:00Z",
  "duration_minutes": 30,
  "meeting_link": "https://meet.google.com/abc-defg-hij",
  "location": null,
  "staff_notes": "Looking forward to discussing Jane's progress"
}
```

**Response:** `200 OK`

```json
{
  "id": "meeting-uuid",
  "status": "approved",
  "scheduled_date": "2025-01-25T14:00:00Z",
  "meeting_link": "https://meet.google.com/abc-defg-hij",
  "staff_notes": "Looking forward to discussing Jane's progress",
  ...
}
```

**cURL Example:**

```bash
curl -X PUT "http://localhost:8000/api/v1/meetings/meeting-uuid/approve" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "scheduled_date": "2025-01-25T14:00:00Z",
    "duration_minutes": 30,
    "meeting_link": "https://meet.google.com/abc-defg-hij",
    "staff_notes": "Looking forward to discussing progress"
  }'
```

---

### 6. Decline a Meeting

**Endpoint:** `PUT /meetings/{meeting_id}/decline`

**Role:** Teacher or Counselor

**Request Body:**

```json
{
  "staff_notes": "Unfortunately, I'm not available that week. Please request a different time."
}
```

**Response:** `200 OK`

```json
{
  "id": "meeting-uuid",
  "status": "declined",
  "staff_notes": "Unfortunately, I'm not available that week...",
  ...
}
```

**cURL Example:**

```bash
curl -X PUT "http://localhost:8000/api/v1/meetings/meeting-uuid/decline" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "staff_notes": "Not available that week. Please request different time."
  }'
```

---

### 7. Set Availability

**Endpoint:** `POST /staff/availability`

**Role:** Teacher or Counselor

**Request Body:**

```json
{
  "day_of_week": 1,
  "start_time": "09:00:00",
  "end_time": "17:00:00"
}
```

**Field Details:**

- `day_of_week`: 0=Sunday, 1=Monday, 2=Tuesday, ..., 6=Saturday
- `start_time`: Format `HH:MM:SS`
- `end_time`: Format `HH:MM:SS`

**Response:** `201 Created`

```json
{
  "id": "availability-uuid",
  "staff_id": "staff-uuid",
  "day_of_week": 1,
  "day_name": "Monday",
  "start_time": "09:00:00",
  "end_time": "17:00:00",
  "is_active": true,
  "created_at": "2025-01-20T08:00:00Z",
  "updated_at": "2025-01-20T08:00:00Z"
}
```

**cURL Example:**

```bash
# Set Monday availability
curl -X POST "http://localhost:8000/api/v1/staff/availability" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "day_of_week": 1,
    "start_time": "09:00:00",
    "end_time": "17:00:00"
  }'
```

**Batch Setup Example:**

```bash
# Set availability for Monday-Friday
for day in {1..5}; do
  curl -X POST "http://localhost:8000/api/v1/staff/availability" \
    -H "Authorization: Bearer YOUR_JWT_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"day_of_week\": $day,
      \"start_time\": \"09:00:00\",
      \"end_time\": \"17:00:00\"
    }"
done
```

---

### 8. Get Staff Availability

**Endpoint:** `GET /staff/{staff_id}/availability`

**Role:** Any authenticated user

**Response:** `200 OK`

```json
[
  {
    "id": "availability-uuid-1",
    "staff_id": "staff-uuid",
    "day_of_week": 1,
    "day_name": "Monday",
    "start_time": "09:00:00",
    "end_time": "17:00:00",
    "is_active": true,
    "created_at": "2025-01-20T08:00:00Z",
    "updated_at": "2025-01-20T08:00:00Z"
  },
  {
    "id": "availability-uuid-2",
    "staff_id": "staff-uuid",
    "day_of_week": 2,
    "day_name": "Tuesday",
    "start_time": "09:00:00",
    "end_time": "17:00:00",
    "is_active": true,
    "created_at": "2025-01-20T08:00:00Z",
    "updated_at": "2025-01-20T08:00:00Z"
  }
]
```

**cURL Example:**

```bash
curl -X GET "http://localhost:8000/api/v1/staff/staff-uuid/availability" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 9. Update Availability

**Endpoint:** `PUT /staff/availability/{availability_id}`

**Role:** Teacher or Counselor (own availability)

**Request Body:**

```json
{
  "start_time": "10:00:00",
  "end_time": "16:00:00",
  "is_active": true
}
```

**Response:** `200 OK`

**cURL Example:**

```bash
curl -X PUT "http://localhost:8000/api/v1/staff/availability/availability-uuid" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "start_time": "10:00:00",
    "end_time": "16:00:00"
  }'
```

---

### 10. Delete Availability

**Endpoint:** `DELETE /staff/availability/{availability_id}`

**Role:** Teacher or Counselor (own availability)

**Response:** `200 OK`

```json
{
  "message": "Availability deleted successfully"
}
```

**cURL Example:**

```bash
curl -X DELETE "http://localhost:8000/api/v1/staff/availability/availability-uuid" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## Common Endpoints

### 11. Get Meeting Details

**Endpoint:** `GET /meetings/{meeting_id}`

**Role:** Any (with permission)

**Response:** `200 OK`

```json
{
  "id": "meeting-uuid",
  "parent_id": "parent-uuid",
  "parent_name": "John Doe",
  ...
}
```

**cURL Example:**

```bash
curl -X GET "http://localhost:8000/api/v1/meetings/meeting-uuid" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 12. Get Available Time Slots

**Endpoint:** `POST /meetings/available-slots`

**Role:** Any authenticated user

**Request Body:**

```json
{
  "staff_id": "staff-uuid",
  "start_date": "2025-01-20T00:00:00Z",
  "end_date": "2025-01-27T00:00:00Z",
  "duration_minutes": 30
}
```

**Response:** `200 OK`

```json
[
  {
    "date": "2025-01-20T00:00:00Z",
    "start_time": "2025-01-20T09:00:00Z",
    "end_time": "2025-01-20T09:30:00Z",
    "day_of_week": 1,
    "day_name": "Monday"
  },
  {
    "date": "2025-01-20T00:00:00Z",
    "start_time": "2025-01-20T09:45:00Z",
    "end_time": "2025-01-20T10:15:00Z",
    "day_of_week": 1,
    "day_name": "Monday"
  }
]
```

**cURL Example:**

```bash
curl -X POST "http://localhost:8000/api/v1/meetings/available-slots" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "staff_id": "staff-uuid",
    "start_date": "2025-01-20T00:00:00Z",
    "end_date": "2025-01-27T00:00:00Z",
    "duration_minutes": 30
  }'
```

---

### 13. List Staff Members

**Endpoint:** `GET /staff/list`

**Role:** Any authenticated user

**Query Parameters:**

- `role` (optional): Filter by role (`teacher` or `counselor`)

**Response:** `200 OK`

```json
[
  {
    "id": "staff-uuid-1",
    "display_name": "Ms. Smith",
    "email": "smith@school.com",
    "active_role": "teacher",
    "avatar_url": "https://...",
    "bio": "Math teacher with 10 years experience"
  },
  {
    "id": "staff-uuid-2",
    "display_name": "Dr. Johnson",
    "email": "johnson@school.com",
    "active_role": "counselor",
    "avatar_url": "https://...",
    "bio": "College counseling specialist"
  }
]
```

**cURL Example:**

```bash
# Get all staff
curl -X GET "http://localhost:8000/api/v1/staff/list" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get only teachers
curl -X GET "http://localhost:8000/api/v1/staff/list?role=teacher" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# Get only counselors
curl -X GET "http://localhost:8000/api/v1/staff/list?role=counselor" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

### 14. Get Meeting Statistics

**Endpoint:** `GET /meetings/statistics/me`

**Role:** Any authenticated user

**Response:** `200 OK`

```json
{
  "total_meetings": 15,
  "pending_meetings": 2,
  "approved_meetings": 8,
  "declined_meetings": 1,
  "cancelled_meetings": 2,
  "completed_meetings": 2,
  "upcoming_meetings": 5,
  "meetings_by_type": {
    "parent_teacher": 10,
    "parent_counselor": 5
  },
  "meetings_by_mode": {
    "video_call": 8,
    "in_person": 5,
    "phone_call": 2
  }
}
```

**cURL Example:**

```bash
curl -X GET "http://localhost:8000/api/v1/meetings/statistics/me" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

---

## Error Responses

### 400 Bad Request

```json
{
  "detail": "Invalid meeting_type. Must be 'parent_teacher' or 'parent_counselor'"
}
```

### 401 Unauthorized

```json
{
  "detail": "Not authenticated"
}
```

### 403 Forbidden

```json
{
  "detail": "Only teachers and counselors can approve meetings"
}
```

### 404 Not Found

```json
{
  "detail": "Meeting not found"
}
```

---

## Complete Workflow Example

### 1. Parent Requests Meeting

```bash
curl -X POST "http://localhost:8000/api/v1/meetings/request" \
  -H "Authorization: Bearer PARENT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "staff_id": "teacher-uuid",
    "student_id": "student-uuid",
    "staff_type": "teacher",
    "meeting_type": "parent_teacher",
    "subject": "Discuss math progress",
    "duration_minutes": 30,
    "meeting_mode": "video_call"
  }'
```

### 2. Teacher Views Pending Requests

```bash
curl -X GET "http://localhost:8000/api/v1/meetings/staff/teacher-uuid?status=pending" \
  -H "Authorization: Bearer TEACHER_TOKEN"
```

### 3. Teacher Approves Meeting

```bash
curl -X PUT "http://localhost:8000/api/v1/meetings/meeting-uuid/approve" \
  -H "Authorization: Bearer TEACHER_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "scheduled_date": "2025-01-25T14:00:00Z",
    "duration_minutes": 30,
    "meeting_link": "https://meet.google.com/abc-defg-hij"
  }'
```

### 4. Parent Views Approved Meeting

```bash
curl -X GET "http://localhost:8000/api/v1/meetings/parent/parent-uuid?status=approved" \
  -H "Authorization: Bearer PARENT_TOKEN"
```

---

## Best Practices

1. **Always check available slots** before requesting a meeting
2. **Use pagination** for large result sets
3. **Filter by status** to reduce response size
4. **Handle errors gracefully** in your frontend
5. **Log all API calls** for debugging
6. **Use appropriate meeting durations** (30 min is standard)
7. **Provide clear subjects** for meetings
8. **Include meeting links** when approving video calls

## Rate Limiting

Currently no rate limiting is implemented. For production, consider:
- 100 requests per minute per user
- 1000 requests per hour per IP

## Changelog

**v1.0** (2025-11-17)
- Initial API release
- All 14 endpoints implemented
- JWT authentication required
- RLS policies enabled
