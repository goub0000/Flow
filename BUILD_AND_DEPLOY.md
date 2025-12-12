# Flow EdTech - Build and Deployment Guide

⭐ **CRITICAL REFERENCE** - Follow this guide exactly for reliable deployments

## Overview

The Flow EdTech Flutter web app uses a **pre-built deployment approach** where Flutter is built locally and the compiled files are committed to git, then deployed to Railway using a simple Node.js server.

## Why Pre-Built Approach?

**DO NOT** try to build Flutter during Docker deployment on Railway. Here's why:

❌ **Multi-stage Docker builds are UNRELIABLE:**
- Flutter SDK download times out or loops in Railway's environment
- Build takes 5+ minutes even when successful
- Inconsistent behavior across deployments
- Resource constraints in Railway's build environment

✅ **Pre-built approach is PROVEN:**
- Fast deployments (< 1 minute)
- Consistent and reliable
- Used successfully since Nov 2024
- Simple Docker image (just Node.js + static files)

## Build Process

### Prerequisites

1. Flutter SDK installed locally
2. Git configured and connected to GitHub
3. Railway project connected to the GitHub repository

### Step-by-Step Build Instructions

#### 1. Clean Previous Build (Optional but Recommended)

```bash
cd "C:\Flow_App (1)\Flow"
flutter clean
flutter pub get
```

#### 2. Build Flutter Web with Environment Variables

**CRITICAL:** Always build with `--dart-define` flags to embed credentials:

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NDU2ODEsImV4cCI6MjA3NzQyMTY4MX0.4u-7fGKjvZ1K1etseU-mb6h-Xfrx25e5kyGl8ZSXnLI \
  --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app
```

**Note:** On Windows, use a single line:
```powershell
flutter build web --release --dart-define=SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NDU2ODEsImV4cCI6MjA3NzQyMTY4MX0.4u-7fGKjvZ1K1etseU-mb6h-Xfrx25e5kyGl8ZSXnLI --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app
```

#### 3. Verify Build Success

Check that `build/web` directory exists and contains:
- `index.html`
- `main.dart.js`
- `manifest.json`
- `flutter_service_worker.js`
- `assets/` directory
- `icons/` directory

```bash
ls build/web
```

#### 4. Commit and Push Changes

```bash
# Stage the build files and any code changes
git add build/web
git add .

# Commit with descriptive message
git commit -m "Rebuild Flutter web with latest changes and embedded credentials"

# Push to trigger Railway deployment
git push origin main
```

#### 5. Verify Deployment

Railway will automatically:
1. Detect the push to main branch
2. Build Docker image (simple Node.js setup)
3. Deploy to production URL

Check deployment at: https://web-production-bcafe.up.railway.app

## Dockerfile Configuration

The Dockerfile MUST use the simple pre-built approach:

```dockerfile
# Dockerfile for Flutter Web (Pre-built)
# Uses pre-built Flutter web files from build/web directory

FROM node:18-alpine

WORKDIR /app

# Copy pre-built Flutter web files
COPY build/web /app/build/web

# Copy server and dependencies
COPY server.js package.json ./

# Install Node.js dependencies
RUN npm install --production

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Start the server
CMD ["node", "server.js"]
```

**DO NOT** use multi-stage builds with Flutter SDK installation!

## Git Configuration

The `.gitignore` is configured to allow `build/web`:

```gitignore
# Allow build/web for deployment, ignore other build folders
/build/*
!/build/web/
```

This ensures the pre-built web files are tracked in git.

## Environment Variables

### Local Build Variables (--dart-define)

These are embedded into the JavaScript bundle during build:

- `SUPABASE_URL`: Supabase project URL
- `SUPABASE_ANON_KEY`: Supabase anonymous key
- `API_BASE_URL`: Backend API base URL

### Railway Environment Variables

These are set in Railway dashboard but NOT used during deployment (only for reference):

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `API_BASE_URL`
- `ALLOWED_ORIGINS`

## Troubleshooting

### Issue: 404 Errors for All Assets

**Cause:** Attempting to build during deployment instead of using pre-built files

**Solution:**
1. Revert Dockerfile to simple pre-built approach (see above)
2. Build locally with `--dart-define` flags
3. Commit `build/web` directory
4. Push to deploy

### Issue: Build Timeouts on Railway

**Cause:** Trying to download Flutter SDK during Docker build

**Solution:** Don't build during deployment. Use pre-built approach.

### Issue: Missing Credentials at Runtime

**Cause:** Building without `--dart-define` flags

**Solution:** Always use the full build command with all three `--dart-define` flags

### Issue: Old Code Still Showing After Deployment

**Cause:** Cached build or browser cache

**Solution:**
1. Rebuild locally: `flutter clean && flutter pub get && flutter build web --release --dart-define=...`
2. Hard refresh browser: Ctrl + Shift + R
3. Check Railway logs to confirm new deployment

## Quick Reference Commands

### Full Rebuild and Deploy
```bash
cd "C:\Flow_App (1)\Flow"
flutter clean
flutter pub get
flutter build web --release --dart-define=SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NDU2ODEsImV4cCI6MjA3NzQyMTY4MX0.4u-7fGKjvZ1K1etseU-mb6h-Xfrx25e5kyGl8ZSXnLI --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app
git add build/web .
git commit -m "Rebuild with latest changes"
git push origin main
```

### Check Deployment Status
```bash
# View Railway logs
railway logs

# Check service status
railway status
```

## Key Takeaways

1. ✅ **Always build locally** with `--dart-define` flags
2. ✅ **Commit `build/web`** to git
3. ✅ **Use simple Dockerfile** (Node.js + static files)
4. ❌ **Never build Flutter during deployment**
5. ❌ **Never use multi-stage Docker builds**
6. ✅ **This approach has been proven reliable since Nov 2024**

---

**Last Updated:** December 12, 2025
**Working Since:** November 28, 2024
**Status:** ✅ Production Ready
