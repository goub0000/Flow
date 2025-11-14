# Railway Deployment Guide

## Overview

This guide walks you through deploying the Find Your Path College Recommendation Service to Railway, a modern cloud platform with automatic deployments and zero-config infrastructure.

## Architecture

```
┌─────────────────────────────────────────────────┐
│                                                 │
│  Railway (Cloud Platform)                       │
│  ┌──────────────────────────────────────────┐  │
│  │                                          │  │
│  │  FastAPI Application                     │  │
│  │  - University Recommendation API         │  │
│  │  - Student Profile Management            │  │
│  │  - Universities Search                   │  │
│  │  - Monitoring & Health Checks            │  │
│  │                                          │  │
│  └──────────────────────────────────────────┘  │
│                    ↓                            │
└────────────────────┼────────────────────────────┘
                     ↓
      ┌──────────────────────────────┐
      │                              │
      │  Supabase (Cloud Database)   │
      │  - universities table        │
      │  - programs table            │
      │  - student_profiles table    │
      │  - recommendations table     │
      │  - app_config table          │
      │                              │
      └──────────────────────────────┘
```

## ✅ Pre-Deployment Checklist

### System Status
- ✅ **Fully Cloud-Based**: No local database dependencies
- ✅ **Supabase Integration**: All data stored in cloud PostgreSQL
- ✅ **Railway Configuration**: `railway.json` and `railway.toml` configured
- ✅ **Environment Variables**: Dynamic CORS and configuration support
- ✅ **Health Checks**: `/health` endpoint for monitoring
- ✅ **Stateless Design**: Can scale horizontally

### No Local Dependencies
- ❌ No SQLite database files
- ❌ No local file storage requirements
- ❌ No hardcoded localhost URLs
- ✅ All configuration via environment variables
- ✅ All data in Supabase cloud database

## 📋 Prerequisites

1. **Railway Account**
   - Sign up at https://railway.app
   - Free tier available ($5 credit/month)
   - GitHub authentication recommended

2. **Supabase Account**
   - Already configured: `https://wmuarotbdjhqbyjyslqg.supabase.co`
   - Service role key available in your `.env` file

3. **GitHub Repository** (Recommended)
   - Push your code to GitHub for automatic deployments
   - Or use Railway CLI for direct deployments

## 🚀 Deployment Methods

### Method 1: GitHub Integration (Recommended)

#### Step 1: Push to GitHub
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
git init
git add .
git commit -m "Initial commit - Railway deployment ready"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/college-recommendation-api.git
git push -u origin main
```

#### Step 2: Deploy to Railway
1. Go to https://railway.app/dashboard
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose your repository
5. Railway will auto-detect the Python project

#### Step 3: Configure Environment Variables
In Railway dashboard, go to **Variables** tab and add:

**CRITICAL - Required Variables (Backend will NOT start without these):**
```bash
SUPABASE_URL=<YOUR_SUPABASE_PROJECT_URL>
SUPABASE_KEY=<YOUR_SUPABASE_SERVICE_ROLE_KEY>
SUPABASE_JWT_SECRET=<YOUR_SUPABASE_JWT_SECRET>
ALLOWED_ORIGINS=https://your-frontend-url.railway.app
```

**How to get these values:**
- `SUPABASE_URL`: Supabase Dashboard → Settings → API → Project URL
- `SUPABASE_KEY`: Supabase Dashboard → Settings → API → service_role key (keep secret!)
- `SUPABASE_JWT_SECRET`: Supabase Dashboard → Settings → API → JWT Settings → JWT Secret
- `ALLOWED_ORIGINS`: Your Flutter web deployment URL (or multiple URLs separated by commas)

**Optional Variables:**
```bash
COLLEGE_SCORECARD_API_KEY=<YOUR_COLLEGE_SCORECARD_API_KEY>
KAGGLE_USERNAME=<YOUR_KAGGLE_USERNAME>
KAGGLE_KEY=<YOUR_KAGGLE_API_KEY>
COLLEGE_SCORECARD_RATE_LIMIT_DELAY=0.1
```

**SECURITY WARNING:**
- ⚠️ **JWT_SECRET is CRITICAL** - Without it, ALL authentication will fail
- Get Supabase credentials from: Supabase Dashboard → Project Settings → API
- Get College Scorecard API key from: https://collegescorecard.ed.gov/data/documentation/
- Get Kaggle credentials from: https://www.kaggle.com/settings/account → API
- NEVER commit these credentials to git or share them publicly
- Use different credentials for dev/staging/production environments

#### Step 4: Deploy
Railway will automatically:
- ✅ Detect Python project
- ✅ Install dependencies from `requirements.txt`
- ✅ Run health checks on `/health`
- ✅ Assign a public URL (e.g., `https://college-recommendation-api-production.up.railway.app`)

### Method 2: Railway CLI

#### Step 1: Install Railway CLI
```bash
# Windows (PowerShell)
iwr https://railway.app/install.ps1 | iex

# macOS/Linux
curl -fsSL https://railway.app/install.sh | sh
```

#### Step 2: Login
```bash
railway login
```

#### Step 3: Initialize Project
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
railway init
```

#### Step 4: Add Environment Variables
```bash
railway variables set SUPABASE_URL=https://your-project.supabase.co
railway variables set SUPABASE_KEY=your_service_role_key
railway variables set SUPABASE_JWT_SECRET=your_jwt_secret_32_chars_minimum
railway variables set ALLOWED_ORIGINS=https://your-app.railway.app
```

#### Step 5: Deploy
```bash
railway up
```

## 🔧 Post-Deployment Configuration

### 1. Update ALLOWED_ORIGINS

After deployment, Railway will assign a URL like:
```
https://college-recommendation-api-production.up.railway.app
```

Update the `ALLOWED_ORIGINS` environment variable to include:
```bash
ALLOWED_ORIGINS=http://localhost:8080,https://college-recommendation-api-production.up.railway.app,https://your-frontend-domain.com
```

### 2. Verify Deployment

**Health Check:**
```bash
curl https://your-railway-app.railway.app/health
```

Expected response:
```json
{"status": "healthy"}
```

**API Info:**
```bash
curl https://your-railway-app.railway.app/
```

Expected response:
```json
{
  "service": "Find Your Path API",
  "status": "running",
  "version": "1.0.0"
}
```

**Test Database Connection:**
```bash
curl https://your-railway-app.railway.app/api/v1/universities?limit=5
```

Should return universities from Supabase.

### 3. Configure Custom Domain (Optional)

1. Go to Railway dashboard → Settings
2. Click **"Add Custom Domain"**
3. Add your domain (e.g., `api.findyourpath.com`)
4. Update DNS records as instructed
5. Railway provides automatic SSL certificates

## 📊 Monitoring & Logs

### View Logs
**Railway Dashboard:**
- Go to your project
- Click **"Logs"** tab
- Real-time log streaming

**Railway CLI:**
```bash
railway logs
```

### Monitor Performance
Railway provides built-in metrics:
- CPU usage
- Memory usage
- Request count
- Response times
- Error rates

Access at: Railway Dashboard → Metrics

## 🔄 Continuous Deployment

Once GitHub is connected, Railway automatically deploys when you push:

```bash
# Make changes to code
git add .
git commit -m "Update recommendation algorithm"
git push origin main
# Railway automatically deploys the new version
```

## 🛠️ Troubleshooting

### Deployment Fails

**Check Logs:**
```bash
railway logs
```

**Common Issues:**

1. **Missing Dependencies**
   - Ensure `requirements.txt` is complete
   - Check Python version (3.9+ required)

2. **Port Binding Error**
   - Ensure using `$PORT` environment variable
   - Check `railway.json` startCommand

3. **Database Connection Failed**
   - Verify `SUPABASE_URL` and `SUPABASE_KEY`
   - Test Supabase credentials locally first

### CORS Errors

If frontend can't connect:
1. Check `ALLOWED_ORIGINS` includes frontend domain
2. Verify format: comma-separated, no spaces
3. Include protocol: `https://` not just `domain.com`

### Health Check Timeout

Railway health checks expect `/health` to respond within 300 seconds:
- Check database connectivity
- Verify Supabase is accessible
- Check application startup logs

## 📈 Scaling

### Horizontal Scaling
Railway supports horizontal scaling:
1. Go to Settings → Scale
2. Adjust number of instances
3. Railway handles load balancing automatically

### Vertical Scaling
Increase resources:
1. Go to Settings → Resources
2. Upgrade plan for more CPU/RAM
3. Railway automatically restarts with new resources

## 💰 Cost Estimation

**Railway Pricing:**
- Free tier: $5 credit/month (~500 hours)
- Hobby plan: $5/month (includes $5 credit)
- Pro plan: Starting at $20/month

**Estimated Costs:**
- Small API (1 instance, 512MB RAM): ~$5-10/month
- Medium load (2-3 instances): ~$15-25/month
- High load (5+ instances): ~$50+/month

**Supabase Pricing:**
- Free tier: Up to 500MB database, 2GB bandwidth
- Pro plan: $25/month (8GB database, 50GB bandwidth)

## 🔐 Security Best Practices

1. **Never commit `.env` file**
   - Already in `.gitignore`
   - Use Railway environment variables

2. **Use Service Role Key**
   - `SUPABASE_KEY` should be service_role key (not anon key)
   - Provides full database access

3. **Configure CORS Properly**
   - Only allow trusted domains
   - Don't use `*` in production

4. **Enable Row-Level Security (RLS) in Supabase**
   - Recommended for production
   - Control data access at database level

5. **Monitor API Usage**
   - Set up alerts for unusual traffic
   - Use Railway metrics dashboard

## 📚 Additional Resources

- **Railway Docs**: https://docs.railway.app
- **Supabase Docs**: https://supabase.com/docs
- **FastAPI Docs**: https://fastapi.tiangolo.com
- **API Documentation**: https://your-railway-app.railway.app/docs (auto-generated)

## 🎯 Quick Reference

### Railway Commands
```bash
railway login              # Authenticate
railway init              # Initialize project
railway up                # Deploy
railway logs              # View logs
railway status            # Check deployment status
railway variables         # List environment variables
railway variables set KEY=VALUE  # Set variable
railway open              # Open app in browser
railway link              # Link to existing project
```

### Environment Variables Reference
| Variable | Required | Description |
|----------|----------|-------------|
| `SUPABASE_URL` | ✅ Yes | Supabase project URL |
| `SUPABASE_KEY` | ✅ Yes | Service role key |
| `ALLOWED_ORIGINS` | ✅ Yes | CORS allowed origins |
| `COLLEGE_SCORECARD_API_KEY` | ❌ No | US college data API |
| `KAGGLE_USERNAME` | ❌ No | Kaggle data imports |
| `KAGGLE_KEY` | ❌ No | Kaggle API key |
| `PORT` | 🔵 Auto | Set by Railway |

## ✅ Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] Railway project created
- [ ] Environment variables configured
- [ ] First deployment successful
- [ ] `/health` endpoint responds
- [ ] Database connection verified
- [ ] CORS configured with actual domain
- [ ] Custom domain added (optional)
- [ ] Monitoring configured
- [ ] Team notified of production URL

## 🎉 You're All Set!

Your college recommendation API is now running on Railway with Supabase as the database. The system is:

- ✅ Fully cloud-based
- ✅ Automatically deploying from GitHub
- ✅ Scalable horizontally and vertically
- ✅ Monitored with health checks
- ✅ Secured with environment variables
- ✅ Ready for production traffic

For questions or issues, refer to the troubleshooting section or Railway documentation.
