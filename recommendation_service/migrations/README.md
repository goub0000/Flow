# Database Migrations

This directory contains SQL migration scripts for the Find Your Path recommendation service database.

## Pending Migrations

### student_activities Table Migration

**File:** `create_student_activities_table.sql`
**Status:** PENDING - Requires Manual Execution
**Created:** 2025-11-17

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

## Migration History

| Date       | Migration                           | Status    |
|------------|-------------------------------------|-----------|
| 2025-11-17 | create_student_activities_table.sql | PENDING   |

