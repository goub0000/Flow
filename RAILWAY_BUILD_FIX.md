# Railway Build Configuration Fix

## The Problem

The production app shows: `ERROR: SUPABASE_URL not configured`

**Root Cause**:
- Railway environment variables ARE set correctly ✅
- `nixpacks.toml` IS configured to build Flutter with those variables ✅
- BUT `railway.json` was overriding the build with: `"buildCommand": "echo 'Using pre-built Flutter web files'"` ❌
- This caused Railway to skip the Flutter build and deploy OLD pre-built files without credentials

## The Fix Applied

### 1. Updated `railway.json`
**Before:**
```json
{
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "echo 'Using pre-built Flutter web files'"  // ❌ Skips build
  }
}
```

**After:**
```json
{
  "build": {
    "builder": "NIXPACKS"  // ✅ Uses nixpacks.toml build configuration
  }
}
```

### 2. Build Flow (Now Correct)

When you deploy to Railway, it will now:

1. **Setup Phase** (`nixpacks.toml`):
   - Install Node.js, Flutter SDK, dependencies

2. **Install Phase**:
   - Download Flutter 3.27.0
   - Extract and configure Flutter
   - Run `npm install`

3. **Build Phase**:
   - Run `bash build.sh` with Railway environment variables:
     - `SUPABASE_URL` (already set in Railway)
     - `SUPABASE_ANON_KEY` (already set in Railway)
     - `API_BASE_URL` (already set in Railway)

4. **Deploy Phase**:
   - Start Node.js server: `node server.js`
   - Serve the NEWLY built `build/web` with embedded credentials

## Deployment Steps

### Option 1: Trigger Railway Rebuild (RECOMMENDED)

Simply commit and push the fixed configuration:

```bash
cd "C:\Flow_App (1)\Flow"

# Stage the fixes
git add railway.json build.sh RAILWAY_BUILD_FIX.md

# Commit
git commit -m "Fix: Enable Railway to build Flutter with env vars"

# Push to trigger Railway deployment
git push
```

Railway will automatically:
- Detect the changes
- Run the full build process
- Build Flutter web with your credentials
- Deploy the new build

### Option 2: Manual Redeploy in Railway Dashboard

1. Go to Railway dashboard
2. Select your Flutter web service
3. Click **"Deploy"** → **"Redeploy"**
4. Railway will rebuild from scratch

## Verification

### Check Railway Build Logs

After deployment, check the logs for:

```
✅ Building Flutter Web with Environment Variables
✅ Environment variables detected:
   - SUPABASE_URL: https://wmuarotbdjhqbyjyslqg...
   - SUPABASE_ANON_KEY: eyJhbGciOiJI...
   - API_BASE_URL: https://web-production-51e34...
✅ Running Flutter build web...
✅ Build completed successfully!
```

### Test the Production App

Visit your Railway app URL. You should:
- ✅ NO error about SUPABASE_URL
- ✅ See login/registration screens
- ✅ Be able to interact with Supabase

### If Still Failing

Check Railway environment variables are set:

1. Go to Railway dashboard → Your service → **Variables**
2. Verify these are set:
   ```
   SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
   SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   API_BASE_URL=https://web-production-51e34.up.railway.app
   ```

3. If missing, add them and redeploy

## What Changed

| File | Change | Why |
|------|--------|-----|
| `railway.json` | Removed `buildCommand` override | Let nixpacks.toml handle the build |
| `railway.json` | Added health check endpoint | Better deployment monitoring |
| `build.sh` | Made API_BASE_URL optional | Allow local development |

## Expected Build Time

The first build after this fix will take **~8-12 minutes** because Railway needs to:
- Download Flutter SDK (~400MB)
- Install dependencies
- Build Flutter web

Subsequent builds will be faster (~3-5 minutes) due to caching.

## Next Steps After Successful Build

Once the app builds successfully:

1. ✅ **Test the production app** - Verify no SUPABASE_URL error
2. ⚠️ **Fix CORS** - You'll likely see CORS errors when calling the recommendation API
3. ⚠️ **Configure recommendation service database** - Switch from SQLite to PostgreSQL
4. ⚠️ **Set up health checks** - Add proper monitoring

See `IMPLEMENTATION_PLAN_FIXES.md` for the complete fix list.

## Troubleshooting

### Build fails with "Flutter command not found"
**Cause**: nixpacks.toml not being used
**Fix**: Ensure railway.json doesn't override the builder

### Build fails with "SUPABASE_URL not set"
**Cause**: Railway environment variables not configured
**Fix**: Set variables in Railway dashboard

### Build succeeds but app still shows error
**Cause**: Old deployment cached
**Fix**: Hard refresh browser (Ctrl+Shift+R) or clear cache

### Build takes too long (>15 minutes)
**Cause**: Flutter SDK download is slow
**Fix**: Normal on first build; subsequent builds are faster

---

**Status**: Ready to deploy ✅
**Action Required**: Commit and push to trigger Railway rebuild
