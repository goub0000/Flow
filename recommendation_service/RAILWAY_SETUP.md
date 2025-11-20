# Railway Production Deployment Guide

**Service:** Recommendation Service API
**Date:** November 2025
**Status:** Configuration Guide for Production Deployment

---

## Prerequisites

- Railway account with project created
- Supabase project with PostgreSQL database
- GitHub repository connected to Railway

---

## Step 1: Configure Environment Variables in Railway

### Required Variables (CRITICAL)

Navigate to Railway Dashboard → Your Service → Variables tab

Add the following environment variables:

```bash
# Database Connection (REQUIRED)
DATABASE_URL=postgresql://postgres:[YOUR_PASSWORD]@db.wmuarotbdjhqbyjyslqg.supabase.co:5432/postgres

# Supabase Configuration (REQUIRED)
SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
SUPABASE_KEY=your_supabase_service_role_key_here
SUPABASE_JWT_SECRET=your_supabase_jwt_secret_here

# CORS Origins (REQUIRED)
# Include both frontend and backend Railway URLs
CORS_ORIGINS=https://web-production-bcafe.up.railway.app,https://web-production-51e34.up.railway.app

# Environment Configuration (REQUIRED)
ENVIRONMENT=production
LOG_LEVEL=INFO

# API Configuration (REQUIRED)
API_HOST=0.0.0.0
API_PORT=8000
```

### Optional Variables

```bash
# Redis Caching (if using)
REDIS_URL=redis://your-redis-host:6379/0

# Data Enrichment APIs (for background scripts)
COLLEGE_SCORECARD_API_KEY=your_api_key
```

---

## Step 2: Get Supabase Credentials

### Database URL

1. Go to Supabase Dashboard
2. Navigate to **Settings** → **Database**
3. Find **Connection String** section
4. Copy the **URI** format string
5. Replace `[YOUR-PASSWORD]` with your actual database password

Example:
```
postgresql://postgres.wmuarotbdjhqbyjyslqg:[password]@aws-0-us-east-1.pooler.supabase.com:6543/postgres
```

### Supabase URL and Keys

1. Go to Supabase Dashboard
2. Navigate to **Settings** → **API**
3. Copy:
   - **Project URL** → `SUPABASE_URL`
   - **service_role** key → `SUPABASE_KEY`
   - **JWT Secret** → `SUPABASE_JWT_SECRET`

**WARNING:** Never use `anon` key for backend services. Always use `service_role` key.

---

## Step 3: Deploy to Railway

### Option A: Automatic Deployment (Recommended)

Railway will automatically detect changes when you push to GitHub:

```bash
cd C:\Flow_App (1)\Flow
git add recommendation_service/
git commit -m "Update environment configuration"
git push origin main
```

Railway will:
1. Detect the push
2. Build using Dockerfile
3. Apply environment variables
4. Deploy the service
5. Assign a public URL

### Option B: Manual Deployment

```bash
# Using Railway CLI
railway up
```

---

## Step 4: Verify Deployment

### Check Service Logs

```bash
railway logs
```

Look for these success indicators:

```
INFO: Started server process
INFO: Waiting for application startup
INFO: Database tables created
INFO: CORS configured with 2 allowed origins: ['https://...', 'https://...']
INFO: Application startup complete
INFO: Uvicorn running on http://0.0.0.0:8000
```

### Test Health Endpoint

```bash
curl https://your-railway-service.up.railway.app/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "recommendation-service",
  "version": "1.2.0",
  "environment": "production"
}
```

### Test CORS Configuration

From browser console on your frontend domain:

```javascript
fetch('https://your-api.railway.app/health')
  .then(r => r.json())
  .then(console.log)
```

Should return data without CORS errors.

---

## Step 5: Database Migration (if needed)

If database tables don't exist, run migrations:

```bash
# SSH into Railway service or use Railway CLI
railway run python -m app.database.init_schema

# Or if using Alembic
railway run alembic upgrade head
```

---

## Troubleshooting

### Problem: CORS Errors in Frontend

**Symptom:** Browser console shows "Access-Control-Allow-Origin" error

**Solution:**
1. Check `CORS_ORIGINS` environment variable in Railway
2. Ensure it includes your frontend URL
3. Restart the service after changing variables

### Problem: Database Connection Fails

**Symptom:** Logs show "connection refused" or "authentication failed"

**Solution:**
1. Verify `DATABASE_URL` format is correct
2. Check password is correct (no special characters unescaped)
3. Ensure Supabase allows connections from Railway IPs
4. Test connection string locally first

### Problem: 500 Errors on API Calls

**Symptom:** All endpoints return 500 Internal Server Error

**Solution:**
1. Check Railway logs for error details
2. Verify all REQUIRED environment variables are set
3. Check `SUPABASE_JWT_SECRET` is at least 32 characters
4. Ensure `ENVIRONMENT=production` is set

### Problem: Service Crashes on Startup

**Symptom:** Railway shows "Deployment Failed" or restarts loop

**Solution:**
1. Check logs for Python errors
2. Verify Dockerfile is present and correct
3. Ensure all dependencies in requirements.txt
4. Check environment variables don't have trailing spaces

---

## Security Checklist

- [ ] `.env` file is NOT committed to git (check `.gitignore`)
- [ ] Using `service_role` key, NOT `anon` key
- [ ] `DATABASE_URL` contains production password
- [ ] `SUPABASE_JWT_SECRET` is at least 32 characters
- [ ] CORS origins list does NOT include `*` (wildcard)
- [ ] Environment variables set in Railway, not hardcoded
- [ ] Log level is INFO or WARNING in production (not DEBUG)

---

## Monitoring

### Check Service Health

```bash
# Via curl
curl https://your-api.railway.app/health

# Via Railway dashboard
railway status
```

### View Logs

```bash
# Last 100 lines
railway logs --tail 100

# Follow logs in real-time
railway logs --follow
```

### Check Database Connection

```bash
# Test query via Railway
railway run python -c "from app.database import engine; print(engine.connect())"
```

---

## Rollback Procedure

If deployment fails:

```bash
# View recent deployments
railway deployments

# Rollback to previous deployment
railway rollback [deployment-id]
```

---

## Environment Variable Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DATABASE_URL` | Yes | None | PostgreSQL connection string |
| `SUPABASE_URL` | Yes | None | Supabase project URL |
| `SUPABASE_KEY` | Yes | None | Service role key |
| `SUPABASE_JWT_SECRET` | Yes | None | JWT secret (32+ chars) |
| `CORS_ORIGINS` | Yes | localhost | Comma-separated allowed origins |
| `ENVIRONMENT` | Yes | development | production/staging/development |
| `LOG_LEVEL` | Yes | INFO | DEBUG/INFO/WARNING/ERROR |
| `API_HOST` | No | 0.0.0.0 | Bind address |
| `API_PORT` | No | 8000 | Bind port |
| `REDIS_URL` | No | None | Redis connection string |

---

## Next Steps After Deployment

1. Test all API endpoints from frontend
2. Monitor error rates in Railway logs
3. Set up alerting for service downtime
4. Configure custom domain (optional)
5. Enable Railway autoscaling (if needed)

---

**Generated:** November 2025
**From:** IMPLEMENTATION_PLAN_FIXES.md - P0 #2
**Related Files:** `.env.example`, `CORS_CONFIG.md`
