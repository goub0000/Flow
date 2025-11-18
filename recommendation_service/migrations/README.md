# Database Migrations

This directory contains SQL migration scripts for the Find Your Path recommendation service database.

## Completed Migrations

### student_activities Table Migration

**File:** `create_student_activities_table.sql`
**Status:** ✅ COMPLETED
**Created:** 2025-11-17
**Executed:** 2025-11-17

#### Purpose
Creates the `student_activities` table for storing automatically generated activity feed events. This table supports the Student Activity Feed feature (Phase 3.1).

#### To Execute This Migration

1. Open your Supabase project dashboard:
   - URL: https://supabase.com/dashboard/project/wmuarotbdjhqbyjyslqg/editor

2. Navigate to SQL Editor:
   - Click "SQL Editor" in the left sidebar
   - Click "New Query"

3. Copy the SQL from `create_student_activities_table.sql`

4. Paste into the SQL Editor and click "Run" (or press Ctrl+Enter)

5. Verify the migration succeeded:
   - You should see a success message
   - The table `student_activities` should appear in your database schema
   - The table should have 4 indexes and 4 RLS policies

#### What This Migration Creates

- **Table:** `student_activities`
  - Stores activity records for student feeds
  - Includes columns: id, student_id, activity_type, title, description, icon, related_entity_id, metadata, timestamp, created_at

- **Indexes:** (for query performance)
  - `idx_student_activities_student_id`
  - `idx_student_activities_timestamp`
  - `idx_student_activities_type`
  - `idx_student_activities_student_timestamp`

- **RLS Policies:** (for security)
  - Students can view own activities
  - Parents can view children activities
  - Counselors can view student activities
  - Service role can insert activities

#### Verification

After running the migration, verify it worked:

```bash
cd recommendation_service
python -c "
from app.database.config import get_supabase
db = get_supabase()
result = db.table('student_activities').select('count', count='exact').limit(0).execute()
print(f'Table exists! Current record count: {result.count}')
"
```

## Completed Migrations

### grades Tables Migration

**File:** `create_grades_tables.sql`
**Status:** ✅ COMPLETED
**Created:** 2025-11-17
**Executed:** 2025-11-17
**Purpose:** Creates 6 tables for Phase 3.4 - Parent-Child Grade Sync API

#### To Execute This Migration

1. Open your Supabase project dashboard:
   - URL: https://supabase.com/dashboard/project/wmuarotbdjhqbyjyslqg/editor

2. Navigate to SQL Editor:
   - Click "SQL Editor" in the left sidebar
   - Click "New Query"

3. Copy the SQL from `create_grades_tables.sql`

4. Paste into the SQL Editor and click "Run" (or press Ctrl+Enter)

5. Verify the migration succeeded:
   - You should see a success message
   - The following 6 tables should appear in your database schema:
     - parent_children
     - courses
     - course_enrollments
     - grades
     - gpa_history
     - grade_alerts

#### What This Migration Creates

- **Tables (6):**
  - `parent_children` - Links parents/guardians to their student children with permissions
  - `courses` - School courses/classes catalog
  - `course_enrollments` - Student enrollment in courses
  - `grades` - Individual assignment/exam grades
  - `gpa_history` - Historical GPA tracking by semester/year
  - `grade_alerts` - Automated alerts for parents about grade changes

- **Indexes:** Multiple indexes for query performance on student_id, course_id, graded_date, etc.

- **RLS Policies:** Row-level security for students, parents, and service role access

#### Verification

After running the migration, verify it worked:

```bash
cd recommendation_service
python -c "
from app.database.config import get_supabase
db = get_supabase()
tables = ['parent_children', 'courses', 'course_enrollments', 'grades', 'gpa_history', 'grade_alerts']
for table in tables:
    result = db.table(table).select('count', count='exact').limit(0).execute()
    print(f'{table}: {result.count} records')
"
```

## Migration History

| Date       | Migration                           | Status      |
|------------|-------------------------------------|-------------|
| 2025-11-17 | create_student_activities_table.sql | ✅ COMPLETED |
| 2025-11-17 | create_grades_tables.sql            | ✅ COMPLETED |

