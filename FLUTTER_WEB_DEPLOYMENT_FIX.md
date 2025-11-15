# Flutter Web Deployment Fix - Railway

## Problem Identified

The Flutter web app at https://web-production-bcafe.up.railway.app/ was crashing with the error:
```
Exception while loading service worker: Error: prepareServiceWorker took more than 4000ms to resolve
Uncaught Error at Object.ag (main.dart.js:3833:30)
```

### Root Cause

The app was being built with `flutter build web --release` **without** the required `--dart-define` environment variables. When the app initialized, `ApiConfig.validateConfig()` in `lib/core/api/api_config.dart` threw an exception because:

1. `SUPABASE_URL` was empty (default: "")
2. `SUPABASE_ANON_KEY` was empty (default: "")
3. The validation method threw an exception, crashing the app before it could render

This happened because the `package.json` build script didn't pass environment variables to the Flutter build command.

## Changes Made

### 1. Updated `lib/core/api/api_config.dart`
- Added `import 'package:flutter/foundation.dart';` for debugPrint
- Enhanced error messages in `validateConfig()` to show actual values
- Added debug logging to help diagnose configuration issues

### 2. Created `build.sh`
- New bash script that validates environment variables before building
- Passes all required `--dart-define` flags to `flutter build web`
- Provides clear error messages if environment variables are missing

### 3. Updated `package.json`
- Changed build script from `flutter build web --release` to `bash build.sh`
- This ensures environment variables are properly passed during build

### 4. Created `nixpacks.toml`
- Configured Nixpacks to install Flutter SDK during Railway build
- Ensures Flutter is available in the build environment
- Sets up proper PATH and runs the build script

### 5. Updated `railway.toml`
- Added comments documenting required environment variables

## Deployment Instructions for Railway

### Step 1: Set Environment Variables in Railway Dashboard

Go to your Flutter web project in Railway (https://web-production-bcafe.up.railway.app) and add these environment variables:

1. **SUPABASE_URL**
   - Value: Your Supabase project URL (e.g., `https://xxxxx.supabase.co`)
   - Find it: Supabase Dashboard → Settings → API → Project URL

2. **SUPABASE_ANON_KEY**
   - Value: Your Supabase anonymous/public key
   - Find it: Supabase Dashboard → Settings → API → Project API keys → anon public

3. **API_BASE_URL**
   - Value: `https://web-production-51e34.up.railway.app`
   - This is your backend API Railway URL

4. **SENTRY_DSN** (Optional, for error tracking)
   - Value: Your Sentry DSN if you want crash reporting
   - Leave empty if not using Sentry

### Step 2: Deploy to Railway

#### Option A: Automatic Deployment (if GitHub connected)
1. Commit and push the changes to your GitHub repository:
   ```bash
   cd "C:\Flow_App (1)\Flow"
   git add .
   git commit -m "Fix Flutter web deployment - add environment variables to build"
   git push
   ```
2. Railway will automatically detect the changes and redeploy

#### Option B: Manual Deployment
1. In Railway Dashboard, go to your Flutter web service
2. Click "Deployments" tab
3. Click "Deploy" button to trigger a new deployment

### Step 3: Verify Environment Variables Are Set

Before deploying, verify in Railway Dashboard:
1. Go to your service → "Variables" tab
2. Confirm all three required variables are present:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `API_BASE_URL`

### Step 4: Monitor Build Logs

1. Go to "Deployments" tab in Railway
2. Click on the latest deployment
3. Watch the build logs for:
   ```
   Environment variables detected:
     - SUPABASE_URL: https://...
     - SUPABASE_ANON_KEY: eyJ...
     - API_BASE_URL: https://web-production-51e34.up.railway.app
   ```
4. Look for "Build completed successfully!"

### Step 5: Test the Deployed App

1. Visit: https://web-production-bcafe.up.railway.app/
2. The app should now load properly
3. Check browser console (F12) for any errors
4. You should see in console:
   ```
   API Configuration validated successfully:
     - Supabase URL: https://xxxxx...
     - API Base URL: https://web-production-51e34.up.railway.app/api/v1
     - Environment: Production
   ```

## Troubleshooting

### Build Fails: "SUPABASE_URL environment variable is not set"

**Cause:** Environment variables not configured in Railway

**Fix:**
1. Go to Railway Dashboard → Your Service → Variables
2. Add the missing environment variable
3. Trigger a new deployment

### Build Fails: "Flutter SDK not found"

**Cause:** nixpacks.toml not being used or Flutter installation failed

**Fix:**
1. Check if `nixpacks.toml` exists in repository root
2. Check Railway build logs for Flutter installation errors
3. May need to update Flutter version in `nixpacks.toml`

### App Loads but Shows "API Error"

**Cause:** Environment variables set incorrectly or API_BASE_URL is wrong

**Fix:**
1. Verify `API_BASE_URL` points to: `https://web-production-51e34.up.railway.app`
2. Test backend API directly: `https://web-production-51e34.up.railway.app/api/v1/health`
3. Check browser console for specific error messages

### App Shows Blank Screen

**Cause:** JavaScript error during initialization

**Fix:**
1. Open browser console (F12)
2. Look for error messages
3. Check Network tab for failed requests
4. Verify all files are loading (main.dart.js, flutter.js, etc.)

## Local Testing

To test the build locally with environment variables:

```bash
cd "C:\Flow_App (1)\Flow"

# Set environment variables (Windows PowerShell)
$env:SUPABASE_URL="https://your-project.supabase.co"
$env:SUPABASE_ANON_KEY="your_anon_key_here"
$env:API_BASE_URL="https://web-production-51e34.up.railway.app"

# Run the build script
bash build.sh

# Test the built app
npm install
npm start

# Visit http://localhost:3000
```

## Quick Checklist

Before deploying, ensure:
- [ ] `SUPABASE_URL` environment variable is set in Railway
- [ ] `SUPABASE_ANON_KEY` environment variable is set in Railway
- [ ] `API_BASE_URL` environment variable is set in Railway
- [ ] `build.sh` has execute permissions (chmod +x build.sh)
- [ ] `nixpacks.toml` exists in repository root
- [ ] All files are committed to Git
- [ ] Backend API is running and accessible

## Files Changed

1. `lib/core/api/api_config.dart` - Enhanced error messages
2. `build.sh` - New build script with environment validation
3. `package.json` - Updated build command
4. `nixpacks.toml` - New Nixpacks configuration
5. `railway.toml` - Added environment variable documentation

## Expected Build Time

- First deployment: ~5-10 minutes (Flutter SDK download + build)
- Subsequent deployments: ~3-5 minutes (cached SDK)

## Success Indicators

✅ Build completes without errors
✅ App loads at https://web-production-bcafe.up.railway.app/
✅ No errors in browser console
✅ Login page renders correctly
✅ Can navigate to registration page
✅ API calls work (check Network tab)

## Contact

If issues persist after following these steps, check:
1. Railway build logs for specific errors
2. Browser console for JavaScript errors
3. Network tab for failed API requests
4. Supabase Dashboard to verify credentials are correct
