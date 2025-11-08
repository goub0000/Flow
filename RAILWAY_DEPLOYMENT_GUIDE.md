# Railway Deployment Guide - Flow EdTech Platform

## Problem

Currently, only the frontend is deployed. We need TWO separate Railway services:
1. **Backend Service** - FastAPI recommendation service
2. **Frontend Service** - Flutter web app

## Solution: Deploy Both Services from Same Repository

### Step 1: Deploy Backend Service

1. Go to your Railway dashboard: https://railway.app/dashboard
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Select repository: **goub0000/Flow**
4. After Railway creates the service, click on the service
5. Go to **Settings** tab
6. Under **"Root Directory"**, enter: `recommendation_service`
7. Under **"Environment Variables"**, add:
   - `SUPABASE_URL` = `https://wmuarotbdjhqbyjyslqg.supabase.co`
   - `SUPABASE_KEY` = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MTg0NTY4MSwiZXhwIjoyMDc3NDIxNjgxfQ.CjfL8kn745KaxUUflPY30WnbLfMKwwVmA2RI3vFwAlM`
   - `ALLOWED_ORIGINS` = (leave empty for now, we'll add frontend URL after next step)
8. Click **"Redeploy"**
9. Once deployed, copy the backend URL (e.g., `https://backend-production-xxxx.up.railway.app`)

### Step 2: Deploy Frontend Service

1. In the same Railway project, click **"New Service"** → **"GitHub Repo"**
2. Select the same repository: **goub0000/Flow**
3. After Railway creates the service, click on the service
4. Go to **Settings** tab
5. Under **"Root Directory"**, enter: `build/web`
6. Click **"Redeploy"**
7. Once deployed, copy the frontend URL (e.g., `https://frontend-production-xxxx.up.railway.app`)

### Step 3: Update Backend CORS

1. Go back to the **Backend Service** in Railway
2. Go to **Settings** → **"Environment Variables"**
3. Update `ALLOWED_ORIGINS` with your frontend URL:
   ```
   https://frontend-production-xxxx.up.railway.app
   ```
4. Click **"Redeploy"**

### Step 4: Update Frontend API Configuration

The frontend needs to know the backend URL. Update the API configuration:

1. In your Flutter project, find the file that configures the API base URL
2. Update it to point to your new backend URL
3. Rebuild the Flutter app:
   ```bash
   cd "C:\Flow_App (1)\Flow"
   flutter build web --release
   ```
4. Commit and push:
   ```bash
   git add build/web
   git commit -m "Update API URL for production backend"
   git push
   ```
5. Railway will automatically redeploy the frontend

### Step 5: Test

1. Open your frontend URL in a browser
2. Try logging in
3. Navigate to "Find Your Path" and generate recommendations
4. Verify that data loads correctly

## Alternative: Use Existing Service for Backend

If you want to keep the existing service URL (https://web-production-bcafe.up.railway.app/):

1. **Delete the current deployment** (which is serving the frontend)
2. Create a **new service** for the backend with Root Directory = `recommendation_service`
3. Create a **new service** for the frontend with Root Directory = `build/web`
4. Follow steps 3-5 above

## Expected Result

You should have **TWO services** in your Railway project:
- Service 1: Backend (FastAPI) - `https://backend-production-xxxx.up.railway.app`
- Service 2: Frontend (Flutter) - `https://frontend-production-xxxx.up.railway.app`

Both services pull from the same GitHub repository but deploy different directories.
