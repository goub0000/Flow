# CORS Configuration - Recommendation Service

**Date:** November 2025
**Status:** ✅ UPDATED (Simplified from complex to environment-based)

---

## Changes Made

### Before (Complex Implementation)
- Generated 20+ localhost origins dynamically
- Hardcoded production URLs in code
- Used `ALLOWED_ORIGINS` environment variable
- Complex logic with multiple lists and merging

### After (Simplified Implementation)
- Single `CORS_ORIGINS` environment variable
- Clean split(",") approach
- Better logging of configured origins
- Easier to maintain and debug

---

## Railway Environment Variable Configuration

### Required Variable

**Variable Name:** `CORS_ORIGINS`

**Production Value:**
```
https://web-production-bcafe.up.railway.app,https://web-production-51e34.up.railway.app
```

### How to Set in Railway

1. Go to Railway dashboard
2. Select the **recommendation service** project
3. Navigate to **Variables** tab
4. Add new variable:
   - **Key:** `CORS_ORIGINS`
   - **Value:** `https://web-production-bcafe.up.railway.app,https://web-production-51e34.up.railway.app`
5. Save and redeploy

---

## Development Configuration

The service will automatically use development defaults if `CORS_ORIGINS` is not set:

```python
"http://localhost:8080,http://localhost:3000,http://localhost:3001"
```

These defaults allow:
- Flutter web dev server (port 8080)
- React/Next.js dev servers (ports 3000-3001)

---

## Verification

After deployment, check the logs for:

```
CORS configured with N allowed origins: ['url1', 'url2', ...]
```

This confirms the CORS configuration is active.

---

## Troubleshooting

### Issue: CORS errors in production
**Solution:** Verify `CORS_ORIGINS` includes both frontend and backend URLs

### Issue: No origins configured
**Solution:** Check Railway environment variables are set correctly

### Issue: Multiple origins not working
**Solution:** Ensure comma-separated list has no extra spaces (handled by .strip())

---

**Generated:** November 2025
**From:** IMPLEMENTATION_PLAN_FIXES.md - P0 #1
**Next Step:** Configure this variable in Railway dashboard
