# Railway Environment Variables Setup - Quick Guide

## Required Environment Variables

### For Flutter Web Service (web-production-bcafe.up.railway.app)

Set these in Railway Dashboard → Your Service → Variables:

| Variable Name | Value | Where to Find |
|--------------|-------|---------------|
| `SUPABASE_URL` | `https://xxxxx.supabase.co` | Supabase Dashboard → Settings → API → Project URL |
| `SUPABASE_ANON_KEY` | `eyJhbG...` (long string) | Supabase Dashboard → Settings → API → anon public key |
| `API_BASE_URL` | `https://web-production-51e34.up.railway.app` | Your backend Railway service URL |
| `SENTRY_DSN` (optional) | `https://...@sentry.io/...` | Sentry Dashboard (if using error tracking) |

## Step-by-Step Instructions

### 1. Get Supabase Credentials

1. Go to https://supabase.com/dashboard
2. Select your project
3. Click Settings (gear icon) → API
4. Copy:
   - **Project URL** (starts with https://)
   - **anon public** key (under Project API keys)

### 2. Set Variables in Railway

1. Go to https://railway.app/dashboard
2. Select your Flutter web project (web-production-bcafe)
3. Click on the service
4. Click "Variables" tab
5. Click "New Variable"
6. Add each variable:

   **Variable 1:**
   - Name: `SUPABASE_URL`
   - Value: (paste your Supabase Project URL)

   **Variable 2:**
   - Name: `SUPABASE_ANON_KEY`
   - Value: (paste your Supabase anon key)

   **Variable 3:**
   - Name: `API_BASE_URL`
   - Value: `https://web-production-51e34.up.railway.app`

7. Click "Add" for each variable

### 3. Verify Variables Are Set

In the Variables tab, you should see:
```
SUPABASE_URL = https://xxxxx.supabase.co
SUPABASE_ANON_KEY = eyJhbG... (truncated for security)
API_BASE_URL = https://web-production-51e34.up.railway.app
```

### 4. Deploy

After setting variables:
1. Go to "Deployments" tab
2. Click "Deploy" to trigger a new build
3. Wait for build to complete (~5-10 minutes first time)

## Common Mistakes

### ❌ Using SERVICE_ROLE key instead of ANON key
- **Wrong:** Use the `service_role` key (secret key)
- **Correct:** Use the `anon` public key
- The anon key is safe to expose in client-side code

### ❌ Missing trailing slash in URLs
- **Wrong:** `https://xxxxx.supabase.co/`
- **Correct:** `https://xxxxx.supabase.co`

### ❌ Wrong backend URL
- **Wrong:** `http://localhost:8000` or `web-production-51e34.up.railway.app`
- **Correct:** `https://web-production-51e34.up.railway.app` (with https://)

### ❌ Forgetting to redeploy
- After setting variables, you MUST trigger a new deployment
- Variables don't affect running deployments, only new ones

## Verification

After deployment completes, verify:

1. **Check Build Logs:**
   - Go to Deployments → Latest deployment → Logs
   - Look for: "Environment variables detected:"
   - Should show your SUPABASE_URL and API_BASE_URL

2. **Check Live App:**
   - Visit: https://web-production-bcafe.up.railway.app/
   - Open browser console (F12)
   - Should see: "API Configuration validated successfully"
   - No errors about missing configuration

3. **Test Login:**
   - Go to the login page
   - Try logging in
   - Should connect to backend API successfully

## If Build Fails

Check build logs for error message:

**"SUPABASE_URL environment variable is not set"**
→ Variable not set in Railway, go back to Step 2

**"Flutter SDK not found"**
→ Check nixpacks.toml is in repository

**"Build failed"**
→ Check build logs for specific error

## Getting Your Supabase Keys (Detailed)

1. Login to Supabase: https://supabase.com/dashboard
2. If you have multiple projects, select the one for Flow app
3. Left sidebar → Click "Settings" (gear icon at bottom)
4. Click "API" in the settings menu
5. You'll see:

   ```
   Project URL
   https://xxxxxxxxxxxxx.supabase.co
   [Copy button]

   Project API keys

   anon public
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...
   [Copy button]

   service_role secret
   eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBh...
   [Copy button]
   ```

6. Copy:
   - Project URL → Use for `SUPABASE_URL`
   - anon public key → Use for `SUPABASE_ANON_KEY`
   - **DO NOT** use service_role secret in Flutter app!

## Security Notes

✅ The `anon` key is SAFE to expose in client-side code (Flutter web)
✅ Supabase uses Row Level Security (RLS) to protect data
✅ Never use `service_role` key in Flutter app (backend only)
✅ Environment variables are encrypted in Railway

## Need Help?

If you're stuck:
1. Double-check each variable name is exactly as shown (case-sensitive)
2. Verify you copied the full key (Supabase keys are very long)
3. Make sure API_BASE_URL uses `https://` not `http://`
4. Check Railway deployment logs for specific errors
5. Test backend API separately: https://web-production-51e34.up.railway.app/api/v1/health
