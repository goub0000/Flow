# Data Enrichment Automation Guide

## Overview

The data enrichment system automatically fills NULL values in the university database by scraping web sources. It's designed to run on a schedule:

- **Daily**: 30 critical priority universities (acceptance rate, GPA, graduation rate)
- **Weekly**: 100 high priority universities
- **Monthly**: 300 medium priority universities

## Current Status

**Backend URL**: `https://web-production-51e34.up.railway.app`

**Enrichment Endpoints**:
- Daily: `POST /api/v1/enrichment/daily`
- Weekly: `POST /api/v1/enrichment/weekly`
- Monthly: `POST /api/v1/enrichment/monthly`
- Status: `GET /api/v1/enrichment/status`
- Analyze: `GET /api/v1/enrichment/analyze`

## Automated Schedule (GitHub Actions)

The enrichment is now automated using GitHub Actions in `.github/workflows/data-enrichment-cron.yml`:

- ⏰ **Daily** at 2:00 AM UTC
- ⏰ **Weekly** every Sunday at 3:00 AM UTC
- ⏰ **Monthly** on the 1st at 4:00 AM UTC

### How it works:

1. GitHub Actions runs on schedule
2. Makes POST request to the enrichment API
3. Backend processes universities in background
4. Results are stored in Supabase

### Manual Triggering:

You can manually trigger enrichment from GitHub:

1. Go to: https://github.com/goub0000/Flow/actions
2. Select "Data Enrichment Automation"
3. Click "Run workflow"
4. Choose enrichment type (daily/weekly/monthly)

## Alternative: External Cron Service

If you prefer using an external service instead of GitHub Actions:

### Option 1: cron-job.org (Free)

1. Go to https://cron-job.org/
2. Create free account
3. Add these cron jobs:

**Daily (2:00 AM UTC)**:
```
Schedule: 0 2 * * *
URL: https://web-production-51e34.up.railway.app/api/v1/enrichment/daily
Method: POST
```

**Weekly (Sunday 3:00 AM UTC)**:
```
Schedule: 0 3 * * 0
URL: https://web-production-51e34.up.railway.app/api/v1/enrichment/weekly
Method: POST
```

**Monthly (1st of month, 4:00 AM UTC)**:
```
Schedule: 0 4 1 * *
URL: https://web-production-51e34.up.railway.app/api/v1/enrichment/monthly
Method: POST
```

### Option 2: Railway Cron Jobs

Railway Pro plan supports cron jobs. Add to `railway.toml`:

```toml
[deploy.cron]
daily = "0 2 * * *"
weekly = "0 3 * * 0"
monthly = "0 4 1 * *"
```

Then create separate worker services that call the API endpoints.

### Option 3: EasyCron (Paid)

1. Go to https://www.easycron.com/
2. Create account
3. Set up HTTP POST requests to the enrichment endpoints

## Manual Testing

### Test the enrichment API:

```bash
# Check data quality
curl https://web-production-51e34.up.railway.app/api/v1/enrichment/analyze

# Trigger daily enrichment
curl -X POST https://web-production-51e34.up.railway.app/api/v1/enrichment/daily

# Check status
curl https://web-production-51e34.up.railway.app/api/v1/enrichment/status
```

### Test locally:

```bash
cd recommendation_service

# Start the API server
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000

# In another terminal, test enrichment
curl -X POST http://localhost:8000/api/v1/enrichment/start \
  -H "Content-Type: application/json" \
  -d '{"limit": 10, "dry_run": true}'
```

## Monitoring

### Check if enrichment is working:

1. **View job status**:
   ```bash
   curl https://web-production-51e34.up.railway.app/api/v1/enrichment/status
   ```

2. **Check data quality improvements**:
   ```bash
   curl https://web-production-51e34.up.railway.app/api/v1/enrichment/analyze
   ```
   Monitor the NULL counts decreasing over time.

3. **Railway Logs**:
   - Go to Railway dashboard
   - Select the recommendation service
   - View deployment logs
   - Search for "enrichment" to see activity

4. **Supabase Logs**:
   The enrichment service logs to Supabase `logs` table for cloud-based monitoring.

## Troubleshooting

### Enrichment not running?

1. **Check GitHub Actions**:
   - Go to https://github.com/goub0000/Flow/actions
   - Verify workflows are enabled
   - Check recent runs for errors

2. **Check backend health**:
   ```bash
   curl https://web-production-51e34.up.railway.app/health
   ```

3. **Verify environment variables** in Railway:
   - `SUPABASE_URL` ✅
   - `SUPABASE_KEY` ✅
   - `COLLEGE_SCORECARD_API_KEY` (optional)

4. **Check Railway logs** for errors

### Enrichment failing?

1. Check the job status for error messages
2. Verify rate limits aren't being exceeded
3. Check if data sources are accessible
4. Review Railway logs for Python exceptions

## Environment Variables

Required in Railway:

```env
SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
SUPABASE_KEY=<your-service-role-key>
ALLOWED_ORIGINS=<your-allowed-origins>
```

Optional for enhanced enrichment:

```env
COLLEGE_SCORECARD_API_KEY=<your-api-key>
KAGGLE_USERNAME=<your-username>
KAGGLE_KEY=<your-key>
```

## Current Data Quality

As of last check:
- **Total NULL values**: 287,241 across 17,137 universities
- **Critical fields missing**:
  - GPA Average: 99.9% missing
  - Acceptance Rate: 90.2% missing
  - Graduation Rate: 89.8% missing
  - Tuition: 89.7% missing

With daily enrichment (30 universities/day), it will take approximately:
- **Critical fields**: ~5-6 months to fill
- **All fields**: ~1-2 years for complete coverage

This is why automation is crucial!

## Next Steps

1. ✅ Verify GitHub Actions workflow is enabled and running
2. ✅ Monitor first automated run in GitHub Actions
3. ✅ Check Railway logs to confirm enrichment is processing
4. ✅ Review data quality improvements weekly
5. ✅ Optionally set up additional external cron jobs for redundancy
