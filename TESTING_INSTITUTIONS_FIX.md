# Testing Guide: Institutions Fix

## Overview
This document provides step-by-step instructions to test the fix that separates registered institutions from the recommendation universities database.

## Problem Fixed
Students were seeing 1000+ scraped universities (from recommendation DB) when trying to apply, instead of seeing only registered institution accounts.

## Solution Implemented
Created a separate institutions API and UI that fetches only registered institution user accounts from the main platform database.

---

## PRE-DEPLOYMENT STEPS

### 1. Deploy Backend Changes

#### Files Changed:
- `app/api/institutions_api.py` (NEW)
- `app/main.py` (modified - added institutions router)

#### Deploy to Railway:

```bash
# Navigate to backend directory
cd "C:\Flow_App (1)\Flow\recommendation_service"

# Stage changes
git add app/api/institutions_api.py
git add app/main.py

# Commit
git commit -m "Add institutions API endpoint for registered institutions

- Create GET /api/v1/institutions endpoint
- Returns only users with 'institution' role
- Includes pagination, search, and filtering
- Provides programs_count and courses_count
- Enables proper application flow with valid institution IDs"

# Push to Railway (triggers auto-deploy)
git push origin main
```

#### Verify Deployment:
Wait 2-3 minutes, then check:
```
https://web-production-51e34.up.railway.app/docs
```
Look for **"Institutions"** section in Swagger docs.

---

### 2. Build Flutter App

#### Files Changed:
- `lib/core/api/api_config.dart`
- `lib/core/models/institution_model.dart` (NEW)
- `lib/features/student/services/institutions_api_service.dart` (NEW)
- `lib/features/student/providers/institutions_provider.dart` (NEW)
- `lib/features/student/institutions/browse_institutions_screen.dart` (NEW)
- `lib/features/student/applications/presentation/create_application_screen.dart`

#### Build Commands:

```bash
# Navigate to Flutter directory
cd "C:\Flow_App (1)\Flow"

# Get dependencies (if needed)
flutter pub get

# Run build runner (if using code generation)
# flutter pub run build_runner build --delete-conflicting-outputs

# For web testing
flutter run -d chrome

# For production web build
flutter build web

# For mobile
flutter run -d <device>
```

---

## TESTING PLAN

### Phase 1: Backend API Testing

#### Test 1.1: API Endpoint Availability
**Endpoint:** `GET /api/v1/institutions`

**Method 1: Using Swagger UI**
1. Navigate to: https://web-production-51e34.up.railway.app/docs
2. Scroll to **"Institutions"** section
3. Click on `GET /api/v1/institutions`
4. Click **"Try it out"**
5. Click **"Execute"**

**Expected Result:**
- Status: 200 OK
- Response contains `institutions` array
- Response contains `total`, `page`, `page_size`
- Each institution has: `id` (UUID), `name`, `email`, `programs_count`, `courses_count`

**Method 2: Using curl**
```bash
# First, login to get token
curl -X POST https://web-production-51e34.up.railway.app/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"your-email@example.com","password":"your-password"}'

# Copy the access_token from response

# Then test institutions endpoint
curl -X GET "https://web-production-51e34.up.railway.app/api/v1/institutions?page=1&page_size=20" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN_HERE"
```

**Expected Response Structure:**
```json
{
  "institutions": [
    {
      "id": "uuid-string",
      "name": "Institution Name",
      "email": "contact@institution.edu",
      "phone_number": "+1234567890",
      "photo_url": null,
      "created_at": "2025-01-01T00:00:00Z",
      "is_verified": true,
      "programs_count": 5,
      "courses_count": 12
    }
  ],
  "total": 1,
  "page": 1,
  "page_size": 20
}
```

#### Test 1.2: Search Functionality
```bash
curl -X GET "https://web-production-51e34.up.railway.app/api/v1/institutions?search=university" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Expected:** Only institutions matching search term

#### Test 1.3: Pagination
```bash
# Page 1
curl -X GET "https://web-production-51e34.up.railway.app/api/v1/institutions?page=1&page_size=5" \
  -H "Authorization: Bearer YOUR_TOKEN"

# Page 2
curl -X GET "https://web-production-51e34.up.railway.app/api/v1/institutions?page=2&page_size=5" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Expected:** Different results per page

#### Test 1.4: Get Single Institution
```bash
curl -X GET "https://web-production-51e34.up.railway.app/api/v1/institutions/INSTITUTION_UUID" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Expected:** Single institution object

---

### Phase 2: Flutter UI Testing

#### Test 2.1: Browse Institutions Screen

**Steps:**
1. Run the Flutter app
2. Login as a student
3. Navigate to **"Applications"** tab
4. Click **"Create New Application"** button
5. In Step 1 (Program Selection), click **"Browse Institutions"**

**Expected Results:**
✅ Screen title shows "Select Institution" (not "Select University")
✅ Search bar placeholder: "Search by institution name or email..."
✅ Sort options include: Name, Total Offerings, Programs, Courses, Newest
✅ "Show verified only" checkbox is visible
✅ Results count shows: "X registered institutions" (not universities)
✅ If no institutions registered yet, shows empty state with business icon

#### Test 2.2: Institution Cards Display

**Expected Card Elements:**
✅ Business icon (not school icon)
✅ Institution name in bold
✅ Green "Verified" badge if `is_verified = true`
✅ Email address with email icon
✅ Programs count chip (blue) - e.g., "5 programs"
✅ Courses count chip (secondary color) - e.g., "12 courses"
✅ "No offerings yet" chip if both counts are 0
✅ Chevron right icon

#### Test 2.3: Search Functionality

**Steps:**
1. In Browse Institutions screen, type in search bar
2. Try searching for: institution name, partial name, email

**Expected:**
✅ Results filter in real-time
✅ Shows only matching institutions
✅ Clear button appears in search field
✅ Click clear button resets search

#### Test 2.4: Sort & Filter

**Steps:**
1. Change sort dropdown to "Total Offerings"
2. Click sort order button (up/down arrow)
3. Check "Show verified only" checkbox

**Expected:**
✅ List re-orders by selected criteria
✅ Arrow toggles between ascending/descending
✅ Checkbox filters to show only verified institutions

#### Test 2.5: Pagination (Infinite Scroll)

**Steps:**
1. Scroll to bottom of institutions list
2. Continue scrolling

**Expected:**
✅ Loading indicator appears at bottom
✅ More institutions load automatically
✅ Smooth scrolling experience

#### Test 2.6: Pull to Refresh

**Steps:**
1. Pull down from top of list
2. Release

**Expected:**
✅ Loading indicator appears
✅ List refreshes with latest data

#### Test 2.7: Institution Selection

**Steps:**
1. Tap on an institution card

**Expected:**
✅ Screen closes (pops)
✅ Returns to Create Application screen
✅ Selected institution appears in a card
✅ Card shows: business icon, institution name, verified badge (if applicable), email, offerings count
✅ Institution name fills the institution field
✅ "Remove" button (X icon) appears

#### Test 2.8: Remove Selected Institution

**Steps:**
1. After selecting an institution, click the X icon

**Expected:**
✅ Selected institution card disappears
✅ "Browse Institutions" button reappears
✅ Institution field clears

---

### Phase 3: Application Submission Flow

#### Test 3.1: Validation

**Steps:**
1. Try to proceed without selecting institution
2. Try to proceed without entering program name

**Expected:**
✅ Error message: "Please select an institution to continue"
✅ Cannot advance to next step without institution
✅ Program name validation works

#### Test 3.2: Complete Application Flow

**Steps:**
1. Select a registered institution
2. Enter program name (e.g., "Computer Science")
3. Click "Continue" to Step 2
4. Fill personal information
5. Click "Continue" to Step 3
6. Fill academic information
7. Click "Continue" to Step 4
8. Upload documents (optional)
9. Click "Submit"

**Expected:**
✅ All steps work smoothly
✅ Selected institution data persists through steps
✅ Submission succeeds (no FK constraint error)
✅ Success message appears
✅ Application appears in applications list

#### Test 3.3: Verify Database

**After submission, check Supabase:**

```sql
-- Check the application was created
SELECT id, student_id, institution_id, institution_name, program_name, status
FROM applications
WHERE institution_name = 'YOUR_SELECTED_INSTITUTION_NAME'
ORDER BY created_at DESC
LIMIT 1;

-- Verify institution_id is a valid UUID referencing users table
SELECT u.id, u.display_name, u.email, u.active_role
FROM users u
WHERE u.id = 'INSTITUTION_ID_FROM_ABOVE_QUERY';
```

**Expected:**
✅ Application record exists
✅ `institution_id` is a valid UUID
✅ `institution_id` matches a user with `active_role = 'institution'`
✅ Foreign key constraint satisfied

---

### Phase 4: Verify Separation from Universities

#### Test 4.1: Universities Still Work for Recommendations

**Steps:**
1. Navigate to "Find Your Path" feature
2. Complete the questionnaire
3. View recommendations

**Expected:**
✅ Recommendations still show universities from recommendation DB
✅ Match scores, categories (Safety/Match/Reach) work
✅ University details show comprehensive data
✅ This feature is UNCHANGED

#### Test 4.2: No Overlap

**Verify:**
✅ Application form shows ONLY registered institutions (from users table)
✅ Find Your Path shows ONLY universities (from recommendation DB)
✅ Two separate data sources
✅ No confusion between the two

---

## COMMON ISSUES & TROUBLESHOOTING

### Issue 1: "Institutions endpoint not found" (404)

**Cause:** Backend not deployed yet

**Solution:**
1. Verify Railway deployment completed
2. Check Railway logs for errors
3. Confirm `institutions_api.py` is included in deployment
4. Restart the Railway service if needed

### Issue 2: "Unauthorized" (401)

**Cause:** No authentication token or expired token

**Solution:**
1. Ensure user is logged in
2. Check token is stored in SharedPreferences
3. Try logging out and back in
4. Verify `InstitutionsApiService.setAuthToken()` is called

### Issue 3: Empty institutions list

**Possible Causes:**
- No users with `active_role = 'institution'` exist in database
- Filters are too restrictive

**Solution:**
1. Check Supabase `users` table:
   ```sql
   SELECT COUNT(*) FROM users WHERE active_role = 'institution';
   ```
2. Register a test institution account
3. Clear filters in the UI

### Issue 4: FK constraint error on application submission

**Cause:** Selected institution ID doesn't exist in users table (should be impossible with fix)

**Solution:**
1. Verify you selected from Browse Institutions (not Browse Universities)
2. Check institution still exists in database
3. Check `institution_id` in application data is a valid UUID

### Issue 5: Build errors in Flutter

**Cause:** Missing imports or dependencies

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## SUCCESS CRITERIA

✅ **Backend API:**
- [ ] `/api/v1/institutions` endpoint accessible
- [ ] Returns correct data structure
- [ ] Pagination works
- [ ] Search/filter works
- [ ] Authentication required

✅ **Flutter UI:**
- [ ] Browse Institutions screen opens
- [ ] Shows only registered institutions
- [ ] Search, sort, filter all work
- [ ] Institution selection works
- [ ] Selected institution displays correctly

✅ **Application Flow:**
- [ ] Can select institution
- [ ] Can complete all steps
- [ ] Submission succeeds
- [ ] Application saved to database
- [ ] FK constraint satisfied

✅ **Separation of Concerns:**
- [ ] Applications use institutions endpoint
- [ ] Find Your Path uses universities endpoint
- [ ] No overlap or confusion

✅ **Database Integrity:**
- [ ] All `institution_id` values are valid UUIDs
- [ ] All `institution_id` values reference existing users
- [ ] No orphaned applications

---

## ROLLBACK PLAN

If issues occur, rollback steps:

### Backend Rollback:
```bash
cd "C:\Flow_App (1)\Flow\recommendation_service"
git revert HEAD
git push origin main
```

### Frontend Rollback:
```bash
cd "C:\Flow_App (1)\Flow"
git checkout HEAD~1 -- lib/core/api/api_config.dart
git checkout HEAD~1 -- lib/features/student/applications/presentation/create_application_screen.dart
# Remove new files
git clean -fd lib/core/models/institution_model.dart
git clean -fd lib/features/student/institutions/
git clean -fd lib/features/student/providers/institutions_provider.dart
git clean -fd lib/features/student/services/institutions_api_service.dart
```

---

## POST-TESTING TASKS

After successful testing:

1. **Update Documentation**
   - Update API documentation
   - Add institutions endpoint to integration guide
   - Document the difference between institutions and universities

2. **Monitor Production**
   - Watch for errors in Railway logs
   - Monitor application submission success rate
   - Track user feedback

3. **Performance Optimization** (if needed)
   - Add database indexes on `users.active_role`
   - Cache institution list
   - Optimize queries

4. **Future Enhancements**
   - Add institution details screen
   - Add institution ratings/reviews
   - Add filters for institution type, location, etc.
   - Add programs/courses browsing per institution

---

## TEST RESULTS LOG

Date: _____________

Tester: _____________

| Test ID | Test Name | Status | Notes |
|---------|-----------|--------|-------|
| 1.1 | API Endpoint Availability | ⬜ Pass ⬜ Fail | |
| 1.2 | Search Functionality | ⬜ Pass ⬜ Fail | |
| 1.3 | Pagination | ⬜ Pass ⬜ Fail | |
| 1.4 | Get Single Institution | ⬜ Pass ⬜ Fail | |
| 2.1 | Browse Institutions Screen | ⬜ Pass ⬜ Fail | |
| 2.2 | Institution Cards Display | ⬜ Pass ⬜ Fail | |
| 2.3 | Search Functionality (UI) | ⬜ Pass ⬜ Fail | |
| 2.4 | Sort & Filter | ⬜ Pass ⬜ Fail | |
| 2.5 | Pagination (Infinite Scroll) | ⬜ Pass ⬜ Fail | |
| 2.6 | Pull to Refresh | ⬜ Pass ⬜ Fail | |
| 2.7 | Institution Selection | ⬜ Pass ⬜ Fail | |
| 2.8 | Remove Selected Institution | ⬜ Pass ⬜ Fail | |
| 3.1 | Validation | ⬜ Pass ⬜ Fail | |
| 3.2 | Complete Application Flow | ⬜ Pass ⬜ Fail | |
| 3.3 | Verify Database | ⬜ Pass ⬜ Fail | |
| 4.1 | Universities Still Work | ⬜ Pass ⬜ Fail | |
| 4.2 | No Overlap | ⬜ Pass ⬜ Fail | |

**Overall Result:** ⬜ PASS ⬜ FAIL

**Comments:**
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
