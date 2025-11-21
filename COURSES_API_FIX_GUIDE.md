# Courses API Fix Guide

## Issue Identified

The courses API endpoint is returning a 500 Internal Server Error:
```bash
curl https://web-production-51e34.up.railway.app/api/v1/courses
# Returns: {"error":{"code":500,"message":"Internal server error"...}}
```

**Root Cause:** The `courses` table does not exist in the Supabase database.

## Solution

A complete SQL migration has been created to add the courses table with all necessary fields, indexes, and Row Level Security (RLS) policies.

### Migration File Location
```
C:\Flow_App (1)\Flow\recommendation_service\migrations\create_courses_table.sql
```

## How to Apply the Migration

### Option 1: Supabase Dashboard (Recommended)

1. Open your Supabase project dashboard
2. Navigate to: **SQL Editor** (left sidebar)
3. Click **New Query**
4. Copy the entire contents of `migrations/create_courses_table.sql`
5. Paste into the SQL Editor
6. Click **Run** (or press Ctrl+Enter)

**Direct Link:**
https://app.supabase.com/project/wmuarotbdjhqbyjyslqg/sql

### Option 2: Supabase CLI

If you have the Supabase CLI installed:

```bash
cd recommendation_service
supabase db execute < migrations/create_courses_table.sql
```

### Option 3: Direct PostgreSQL Connection

Using psql or any PostgreSQL client:

1. Get your database connection string from Supabase Dashboard > Settings > Database
2. Connect and execute:
```bash
psql [CONNECTION_STRING] < migrations/create_courses_table.sql
```

## What the Migration Creates

### Table: `courses`

**Core Fields:**
- `id` (UUID, Primary Key)
- `institution_id` (UUID) - Links to institution
- `title` (VARCHAR 200)
- `description` (TEXT)
- `course_type` (ENUM: video, text, interactive, live, hybrid)
- `level` (ENUM: beginner, intermediate, advanced, expert)

**Course Details:**
- `duration_hours` (DECIMAL)
- `price` (DECIMAL, default 0.0)
- `currency` (VARCHAR, default 'USD')
- `thumbnail_url`, `preview_video_url` (TEXT)
- `category` (VARCHAR)

**Arrays:**
- `tags` (TEXT[])
- `learning_outcomes` (TEXT[])
- `prerequisites` (TEXT[])

**Enrollment & Ratings:**
- `enrolled_count` (INTEGER, default 0)
- `max_students` (INTEGER, nullable)
- `rating` (DECIMAL 3,2)
- `review_count` (INTEGER, default 0)

**Content:**
- `syllabus` (JSONB)
- `metadata` (JSONB)

**Status:**
- `status` (ENUM: draft, published, archived)
- `is_published` (BOOLEAN)
- `published_at` (TIMESTAMPTZ)

**Timestamps:**
- `created_at`, `updated_at` (TIMESTAMPTZ, auto-managed)

### Indexes Created

- `idx_courses_institution_id` - Fast institution lookups
- `idx_courses_status` - Status filtering
- `idx_courses_is_published` - Published courses
- `idx_courses_category` - Category filtering
- `idx_courses_level` - Level filtering
- `idx_courses_course_type` - Type filtering
- `idx_courses_created_at` - Date ordering
- `idx_courses_title_search` - Full-text search on titles

### Row Level Security (RLS) Policies

1. **Anyone can view published courses** - Public access to published content
2. **Institutions can view their own courses** - Full access to own courses
3. **Institutions can insert/update/delete their own courses** - Ownership-based CRUD

### Triggers

- `trigger_update_courses_updated_at` - Automatically updates `updated_at` on changes

## Verification Steps

After applying the migration:

### 1. Check Table Exists
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name = 'courses';
```

### 2. Check Table Structure
```sql
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'courses'
ORDER BY ordinal_position;
```

### 3. Test API Endpoint
```bash
# Should return empty list instead of 500 error
curl https://web-production-51e34.up.railway.app/api/v1/courses

# Expected response:
{
  "courses": [],
  "total": 0,
  "page": 1,
  "page_size": 20,
  "has_more": false
}
```

### 4. Create Test Course (Optional)

Using the API with institution authentication:

```bash
curl -X POST https://web-production-51e34.up.railway.app/api/v1/courses \
  -H "Authorization: Bearer YOUR_INSTITUTION_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Introduction to Programming",
    "description": "Learn programming fundamentals with Python",
    "course_type": "video",
    "level": "beginner",
    "price": 49.99,
    "currency": "USD",
    "category": "Computer Science",
    "tags": ["programming", "python", "beginner"],
    "learning_outcomes": [
      "Understand basic programming concepts",
      "Write simple Python programs"
    ]
  }'
```

## Troubleshooting

### Migration Fails with Permission Error

**Solution:** Make sure you're using the Service Role Key (not Anon Key) in Supabase Dashboard or have proper database permissions.

### RLS Policies Block Access

**Solution:** Ensure your JWT token includes the correct `auth.uid()` that matches `institution_id` for institution operations.

### Duplicate Table Error

**Solution:** The migration uses `IF NOT EXISTS` clauses, but if the table exists with different schema, you may need to drop it first:
```sql
DROP TABLE IF EXISTS courses CASCADE;
```
Then re-run the migration.

## Next Steps After Migration

1. ✅ Verify API returns 200 OK
2. 🎨 Test the Flutter courses UI
3. 📝 Create test courses via institution dashboard
4. 👨‍🎓 Browse courses as a student
5. 📊 Monitor API logs for any issues

## Support

If you encounter issues:
1. Check Railway logs: https://railway.app/project/[your-project-id]/logs
2. Check Supabase logs: Dashboard > Logs
3. Verify environment variables in Railway match Supabase credentials

---

**Migration Created:** 2025-01-20
**Status:** Ready to apply
**Estimated Time:** < 1 minute
