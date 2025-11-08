# Setting Up Automated Enrichment on Railway (No External Cron Needed!)

## Two Options - Both Use Only Railway + Supabase

---

## Option 1: Railway Worker Service (Recommended)

Run enrichment continuously as a separate Railway service.

### Step 1: Create Worker Service in Railway

1. Go to your Railway project
2. Click **"+ New Service"**
3. Select **"GitHub Repo"** (same repo as your API)
4. Name it: **"enrichment-worker"**

### Step 2: Configure Worker Service

In the worker service settings:

**Start Command:**
```
python worker.py
```

**Environment Variables** (copy from main service):
- `SUPABASE_URL` = `https://wmuarotbdjhqbyjyslqg.supabase.co`
- `SUPABASE_KEY` = `your_service_key`

**Build Command:**
```
pip install -r requirements.txt
```

### Step 3: Deploy

Railway will deploy the worker automatically. It will:
- Run continuously 24/7
- Execute daily enrichment at 2:00 AM (30 universities)
- Execute weekly enrichment on Sundays at 3:00 AM (100 universities)
- Execute monthly enrichment on 1st of month at 4:00 AM (300 universities)

### Step 4: Monitor

Check logs in Railway dashboard:
```
Railway → enrichment-worker → Logs
```

You'll see:
```
RAILWAY ENRICHMENT WORKER STARTED
✓ Connected to Supabase - 17137 universities found
✓ Schedule configured - worker running...
```

### Cost

**Railway Free Tier:**
- 500 hours/month included
- Worker + API = ~2 services
- Should stay within free tier limits

**If you exceed:**
- ~$5/month for hobby plan

---

## Option 2: Supabase pg_cron (PostgreSQL Built-in Cron)

Use Supabase's built-in cron functionality - no Railway worker needed!

### Step 1: Enable pg_cron in Supabase

1. Go to Supabase Dashboard
2. Navigate to **SQL Editor**
3. Run this:

```sql
-- Enable pg_cron extension
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Grant permissions
GRANT USAGE ON SCHEMA cron TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA cron TO postgres;
```

### Step 2: Create Cron Job to Call Your API

```sql
-- Daily enrichment at 2 AM
SELECT cron.schedule(
    'daily-enrichment',           -- Job name
    '0 2 * * *',                  -- Cron schedule (2 AM daily)
    $$
    SELECT net.http_post(
        url := 'https://your-app.railway.app/api/v1/enrichment/daily',
        headers := '{"Content-Type": "application/json"}'::jsonb
    );
    $$
);

-- Weekly enrichment on Sundays at 3 AM
SELECT cron.schedule(
    'weekly-enrichment',
    '0 3 * * 0',                  -- Sunday 3 AM
    $$
    SELECT net.http_post(
        url := 'https://your-app.railway.app/api/v1/enrichment/weekly',
        headers := '{"Content-Type": "application/json"}'::jsonb
    );
    $$
);

-- Monthly enrichment on 1st at 4 AM
SELECT cron.schedule(
    'monthly-enrichment',
    '0 4 1 * *',                  -- 1st of month, 4 AM
    $$
    SELECT net.http_post(
        url := 'https://your-app.railway.app/api/v1/enrichment/monthly',
        headers := '{"Content-Type": "application/json"}'::jsonb
    );
    $$
);
```

### Step 3: Verify Cron Jobs

```sql
-- View all cron jobs
SELECT * FROM cron.job;

-- View job run history
SELECT * FROM cron.job_run_details
ORDER BY start_time DESC
LIMIT 10;
```

### Step 4: Manage Cron Jobs

```sql
-- Disable a job
SELECT cron.unschedule('daily-enrichment');

-- Re-enable
SELECT cron.schedule(
    'daily-enrichment',
    '0 2 * * *',
    $$ SELECT net.http_post(...) $$
);

-- Delete a job permanently
SELECT cron.unschedule('daily-enrichment');
```

### Cost

**Supabase Free Tier:**
- pg_cron included for free!
- No additional cost

---

## Option 3: Hybrid - API Triggers Manual Runs

Don't use cron at all - just trigger enrichment manually or via simple script.

### Manual Triggers

```bash
# Run whenever you want
curl -X POST https://your-app.railway.app/api/v1/enrichment/start \
  -d '{"limit": 50, "priority": "critical"}'
```

### Simple Local Script

Run this on your computer daily:

**`local_trigger.sh`**
```bash
#!/bin/bash
# Save this on your computer
curl -X POST https://your-app.railway.app/api/v1/enrichment/daily
```

**Windows Task Scheduler:**
1. Open Task Scheduler
2. Create Basic Task
3. Trigger: Daily at 2 AM
4. Action: Start Program → `bash local_trigger.sh`

**Mac/Linux cron:**
```bash
# Add to crontab (crontab -e)
0 2 * * * curl -X POST https://your-app.railway.app/api/v1/enrichment/daily
```

---

## Comparison

| Option | Cost | Setup Difficulty | Reliability |
|--------|------|------------------|-------------|
| **Railway Worker** | ~$5/month | Easy | ⭐⭐⭐⭐⭐ |
| **Supabase pg_cron** | Free | Medium | ⭐⭐⭐⭐ |
| **Manual/Local** | Free | Very Easy | ⭐⭐⭐ (depends on your computer) |

---

## Recommended Choice

### For Production → **Option 1: Railway Worker**
- Most reliable (runs 24/7 in cloud)
- Easy to monitor via Railway dashboard
- No external dependencies
- Worth the $5/month for peace of mind

### For Testing/Budget → **Option 2: Supabase pg_cron**
- Completely free
- Good reliability
- Runs inside Supabase (trusted infrastructure)

### For Quick Start → **Option 3: Manual**
- Zero cost
- Zero setup
- Run enrichment whenever you want
- Good for initial testing phase

---

## Step-by-Step: Railway Worker Setup (Recommended)

### 1. Deploy Worker to Railway

```bash
# Your worker.py file is already created
# Just deploy it as a new service
```

**In Railway Dashboard:**

1. Click **"New"** → **"Empty Service"**
2. Select your GitHub repo
3. Railway will detect the code
4. Go to **Settings** → **Deploy**
5. Set **Custom Start Command**:
   ```
   python worker.py
   ```

6. **Environment Variables** → Add:
   - `SUPABASE_URL` = `https://wmuarotbdjhqbyjyslqg.supabase.co`
   - `SUPABASE_KEY` = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

7. Click **Deploy**

### 2. Verify It's Running

**Check Logs:**
```
Railway Dashboard → Worker Service → Logs
```

You should see:
```
RAILWAY ENRICHMENT WORKER STARTED
✓ Connected to Supabase - 17137 universities found
✓ Schedule configured - worker running...
```

### 3. Wait for First Run

- First run: Next day at 2:00 AM
- You'll see logs:
```
DAILY ENRICHMENT STARTED
Processed: 30
Updated: 28
Errors: 2
DAILY ENRICHMENT COMPLETED
```

### 4. Monitor Progress

```bash
# Check data quality weekly
curl https://your-app.railway.app/api/v1/enrichment/analyze
```

---

## Troubleshooting

### Worker not starting
**Check:** Environment variables are set correctly

### Worker crashes
**Check:** Railway logs for error details
**Fix:** Increase memory if needed (Settings → Resources)

### Enrichment not running
**Check:** Worker logs show "Schedule configured"
**Check:** Time zone (Railway uses UTC)

### Database not updating
**Check:** SUPABASE_KEY has write permissions
**Check:** dry_run is set to False in worker.py

---

## Files Created

- ✅ `worker.py` - Background worker script
- ✅ `RAILWAY_WORKER_SETUP.md` - This guide
- ✅ `app/api/enrichment.py` - API endpoints (already created)

---

## Summary

You now have **3 options** to automate enrichment using only Railway + Supabase:

1. **Railway Worker Service** (Recommended) - $5/month, most reliable
2. **Supabase pg_cron** - Free, built into Supabase
3. **Manual Triggers** - Free, simple, run when you want

**All three keep everything within Railway + Supabase ecosystem - no external services needed!** 🎉

---

**Next Step:** Choose your option and set it up following the guide above!
