# Supabase Integration Setup Guide

This guide will walk you through setting up Supabase for the Find Your Path recommendation service.

---

## Step 1: Create Supabase Project

1. **Go to** [https://supabase.com](https://supabase.com)
2. **Sign up** or **log in** to your account
3. **Click** "New Project"
4. **Fill in:**
   - Project name: `find-your-path` (or your preferred name)
   - Database password: (save this - you'll need it!)
   - Region: Choose closest to you
   - Pricing plan: Free tier is fine to start
5. **Click** "Create new project"
6. **Wait** 1-2 minutes for setup to complete

---

## Step 2: Get Your Supabase Credentials

Once your project is created:

1. **Click** on the **Settings** icon (gear) in the left sidebar
2. **Click** "API" in the settings menu
3. **Copy** the following values:

   ```
   Project URL: https://xxxxxxxxxxxxx.supabase.co
   anon/public key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   service_role key: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

4. **Save these** - you'll add them to your `.env` file

---

## Step 3: Create Database Tables

1. **Click** on the **SQL Editor** icon in the left sidebar
2. **Click** "New query"
3. **Copy and paste** the entire contents of `supabase_schema.sql`
4. **Click** "Run" or press `Ctrl+Enter`
5. **Verify** you see: "Success. No rows returned"
6. **Check tables created:**
   - Click "Table Editor" in left sidebar
   - You should see: `universities`, `programs`, `student_profiles`, `recommendations`

---

## Step 4: Configure Environment Variables

1. **Open** or **create** `.env` file in `recommendation_service/` directory

2. **Add** Supabase credentials:

   ```bash
   # Supabase Configuration
   SUPABASE_URL=<YOUR_SUPABASE_PROJECT_URL>
   SUPABASE_ANON_KEY=<YOUR_SUPABASE_ANON_KEY>
   SUPABASE_SERVICE_KEY=<YOUR_SUPABASE_SERVICE_ROLE_KEY>

   # Database mode: 'supabase' or 'sqlite'
   DATABASE_MODE=supabase

   # Kaggle API (get from https://www.kaggle.com/settings/account → API → Create New Token)
   KAGGLE_USERNAME=<YOUR_KAGGLE_USERNAME>
   KAGGLE_KEY=<YOUR_KAGGLE_API_KEY>
   ```

   **SECURITY NOTE:** Never commit these credentials to git. Keep them in .env files only.

3. **Save** the file

---

## Step 5: Install Supabase Python Client

Run in terminal:

```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
pip install supabase
```

---

## Step 6: Test Connection

Test that your Supabase connection works:

```bash
python test_supabase_connection.py
```

Expected output:
```
✓ Connected to Supabase successfully!
✓ Found 4 tables
✓ Ready to import universities
```

---

## Step 7: Import Universities to Supabase

Import QS Rankings data to your Supabase database:

```bash
# Import latest QS Rankings
python import_universities.py --kaggle latest --limit 100

# Or import all 1,500+ universities
python import_universities.py --kaggle latest
```

---

## Understanding Supabase vs SQLite

### Current Setup (SQLite)
- Local database file (`find_your_path.db`)
- Data stored on your computer only
- Good for development/testing
- No cloud access

### New Setup (Supabase)
- Cloud PostgreSQL database
- Data accessible from anywhere
- Your Flutter app can connect directly
- Real-time subscriptions available
- Row Level Security (RLS) for user privacy
- Scales automatically

---

## Supabase Features Enabled

### 1. **Row Level Security (RLS)**
- Students can only see their own profiles and recommendations
- Universities are publicly readable
- Secure by default

### 2. **Automatic Timestamps**
- `created_at` and `updated_at` automatically managed
- Triggers keep timestamps in sync

### 3. **Indexes**
- Optimized for fast searches by:
  - University name
  - Country
  - Global rank
  - Student user_id

### 4. **JSONB Fields**
- Flexible data storage for:
  - Test scores
  - Preferred regions
  - Features desired
  - Recommendation strengths/concerns

---

## Connecting Your Flutter App

Once data is imported, connect your Flutter app:

1. **Add** `supabase_flutter` package to `pubspec.yaml`:
   ```yaml
   dependencies:
     supabase_flutter: ^2.0.0
   ```

2. **Initialize** in `main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'https://xxxxxxxxxxxxx.supabase.co',
     anonKey: 'your-anon-key',
   );
   ```

3. **Query universities**:
   ```dart
   final response = await Supabase.instance.client
       .from('universities')
       .select()
       .eq('country', 'US')
       .limit(10);
   ```

---

## Database Management

### View Data in Supabase Dashboard:
1. Go to https://supabase.com/dashboard
2. Select your project
3. Click "Table Editor"
4. Browse your tables

### Run SQL Queries:
1. Click "SQL Editor"
2. Write custom queries
3. Export results as CSV

### Monitor Performance:
1. Click "Database"
2. View connection pooling
3. Check slow queries

---

## Backup and Export

### Export Data:
```sql
-- In Supabase SQL Editor
COPY universities TO '/tmp/universities.csv' CSV HEADER;
```

### Automatic Backups:
- Supabase automatically backs up your database
- Point-in-time recovery available (Pro plan)
- Free tier: Daily backups for 7 days

---

## Switching Between SQLite and Supabase

You can switch between databases using the `DATABASE_MODE` environment variable:

### Use Supabase (production):
```bash
DATABASE_MODE=supabase
```

### Use SQLite (local development):
```bash
DATABASE_MODE=sqlite
```

The import scripts will automatically use the correct database based on this setting.

---

## Troubleshooting

### Error: "Invalid API key"
- Check your `.env` file has correct `SUPABASE_ANON_KEY`
- Make sure there are no quotes around the key
- Verify you copied the full key (very long string)

### Error: "relation 'universities' does not exist"
- Run the `supabase_schema.sql` in SQL Editor
- Check Table Editor to verify tables exist
- Make sure SQL ran without errors

### Error: "Connection timeout"
- Check your internet connection
- Verify `SUPABASE_URL` is correct
- Try accessing the Supabase dashboard

### Import is slow
- Supabase Free tier has connection limits
- Use `--limit` to import in batches
- Consider upgrading to Pro for better performance

---

## Next Steps

1. ✅ Create Supabase project
2. ✅ Run schema SQL
3. ✅ Add credentials to `.env`
4. ✅ Install `supabase` package
5. ✅ Test connection
6. ✅ Import universities
7. ✅ Connect Flutter app
8. ✅ Deploy recommendation service

Your database is now in the cloud and ready to scale! 🚀
