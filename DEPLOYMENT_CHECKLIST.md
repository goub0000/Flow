# Deployment Checklist: Institutions Fix

## Quick Deployment Steps

### Step 1: Deploy Backend to Railway ⏱️ 5 minutes

```bash
# Navigate to backend
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Check what will be committed
git status

# Stage new API file
git add app/api/institutions_api.py

# Stage modified main.py
git add app/main.py

# Commit with descriptive message
git commit -m "feat: Add institutions API endpoint

- Add GET /api/v1/institutions for registered institutions
- Add GET /api/v1/institutions/{id} for single institution
- Include pagination, search, and filtering
- Return institutions with valid UUIDs for applications
- Fixes issue where students saw recommendation universities instead of registered institutions"

# Push to trigger Railway deployment
git push origin main

# Monitor deployment
# Visit: https://railway.app/dashboard
# Or check: https://web-production-51e34.up.railway.app/docs
```

**Verification (after 2-3 min):**
- [ ] Visit https://web-production-51e34.up.railway.app/docs
- [ ] Check for "Institutions" section
- [ ] Test `GET /api/v1/institutions` endpoint

---

### Step 2: Test Backend API ⏱️ 5 minutes

**Quick API Test:**

```bash
# 1. Login to get token
curl -X POST https://web-production-51e34.up.railway.app/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"YOUR_EMAIL","password":"YOUR_PASSWORD"}'

# 2. Copy access_token from response

# 3. Test institutions endpoint
curl https://web-production-51e34.up.railway.app/api/v1/institutions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Expected:**
```json
{
  "institutions": [...],
  "total": X,
  "page": 1,
  "page_size": 20
}
```

- [ ] API returns 200 OK
- [ ] Response has correct structure
- [ ] Institutions have UUID ids

---

### Step 3: Run Flutter App ⏱️ 2 minutes

```bash
# Navigate to Flutter directory
cd "C:\Flow_App (1)\Flow"

# Clean build (if needed)
# flutter clean
# flutter pub get

# Run on web
flutter run -d chrome

# OR run on connected device
flutter run
```

- [ ] App builds successfully
- [ ] No compilation errors

---

### Step 4: Test Application Flow ⏱️ 5 minutes

**Quick UI Test:**

1. Login as student
2. Go to Applications → Create New Application
3. Click "Browse Institutions"
4. **Verify:**
   - [ ] Button says "Browse **Institutions**" (not Universities)
   - [ ] Opens Browse Institutions screen
   - [ ] Shows registered institutions (not 1000+ universities)
   - [ ] Can search/filter
   - [ ] Can select institution
   - [ ] Selected institution shows with email and offerings
5. Complete application and submit
6. **Verify:**
   - [ ] Submission succeeds
   - [ ] No FK constraint error
   - [ ] Application appears in list

---

### Step 5: Verify Database ⏱️ 2 minutes

**In Supabase:**

```sql
-- Check recent application
SELECT
  id,
  institution_id,
  institution_name,
  status,
  created_at
FROM applications
ORDER BY created_at DESC
LIMIT 1;

-- Verify institution_id is valid
SELECT
  id,
  display_name,
  email,
  active_role
FROM users
WHERE id = 'INSTITUTION_ID_FROM_ABOVE';
```

- [ ] Application exists
- [ ] institution_id is a UUID
- [ ] institution_id references valid user
- [ ] User has active_role = 'institution'

---

## Critical Verification Points

### ✅ Backend
- [ ] Institutions API endpoint is live
- [ ] Returns only users with 'institution' role
- [ ] Returns valid UUIDs
- [ ] Pagination works
- [ ] Authentication required

### ✅ Frontend
- [ ] Browse Institutions screen works
- [ ] Shows registered institutions only
- [ ] Selection works correctly
- [ ] Application submission works

### ✅ Database
- [ ] FK constraints satisfied
- [ ] No orphaned applications
- [ ] institution_id values are valid

### ✅ Separation
- [ ] Applications use `/institutions` endpoint ✅
- [ ] Find Your Path uses `/universities` endpoint ✅
- [ ] No confusion between the two ✅

---

## If Something Goes Wrong

### Backend Issues

**Error: "Institutions endpoint not found"**
```bash
# Check Railway deployment status
# Visit Railway dashboard
# Check build logs
# Restart service if needed
```

**Error: "Module not found: institutions_api"**
```bash
# Verify file is committed
git log --name-only -1

# Force redeploy
git commit --allow-empty -m "chore: trigger redeploy"
git push origin main
```

### Frontend Issues

**Error: "Institution model not found"**
```bash
# Verify files exist
ls lib/core/models/institution_model.dart
ls lib/features/student/institutions/browse_institutions_screen.dart

# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Error: "No institutions found"**
- Check if any institution accounts exist in database
- Register a test institution user
- Clear filters in UI

### Database Issues

**Error: FK constraint violation**
- This means the fix isn't working
- Verify institution_id is a UUID (not integer)
- Check selected from Browse Institutions (not Universities)
- Review application submission logs

---

## Rollback (If Needed)

### Backend Rollback
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
git revert HEAD
git push origin main
```

### Frontend Rollback
```bash
cd "C:\Flow_App (1)\Flow"
git checkout HEAD~1 -- lib/features/student/applications/presentation/create_application_screen.dart
git checkout HEAD~1 -- lib/core/api/api_config.dart
```

---

## Post-Deployment

### Monitor (first 24 hours)
- [ ] Check Railway logs for errors
- [ ] Monitor application submission rate
- [ ] Watch for FK constraint errors
- [ ] Collect user feedback

### Document
- [ ] Update API documentation
- [ ] Update integration guide
- [ ] Add to changelog
- [ ] Inform team

### Optimize (if needed)
- [ ] Add database indexes
- [ ] Cache institutions list
- [ ] Optimize queries

---

## Summary

**Files Changed:**

Backend (2 files):
- ✅ `app/api/institutions_api.py` (NEW)
- ✅ `app/main.py` (modified)

Frontend (6 files):
- ✅ `lib/core/api/api_config.dart` (modified)
- ✅ `lib/core/models/institution_model.dart` (NEW)
- ✅ `lib/features/student/services/institutions_api_service.dart` (NEW)
- ✅ `lib/features/student/providers/institutions_provider.dart` (NEW)
- ✅ `lib/features/student/institutions/browse_institutions_screen.dart` (NEW)
- ✅ `lib/features/student/applications/presentation/create_application_screen.dart` (modified)

**Total Time:** ~20 minutes for deployment and basic testing

**Risk Level:** Low (new functionality, existing features unchanged)

**Impact:** High (fixes critical bug preventing applications)
