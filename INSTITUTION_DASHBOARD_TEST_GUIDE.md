# Institution Dashboard Testing Guide

## Overview
This guide provides comprehensive instructions for testing the institution dashboard functionality after the recent fixes and improvements.

## Fixed Issues

### 1. ✅ 404 Error on Applicant Detail Route
**Problem**: Clicking on an application in the institution dashboard resulted in a 404 error.
**Solution**:
- Re-enabled the `/institution/applicants/:id` route in `app_router.dart`
- Created `_ApplicantDetailWrapper` widget to handle applicant fetching
- Updated navigation to pass applicant data via `extra` parameter

### 2. ✅ Real Data Integration
**Problem**: Dashboard was showing mock/hardcoded data instead of real data from the backend.
**Solution**:
- Integrated `ApplicationsApiService` with the backend API at `https://web-production-51e34.up.railway.app`
- Updated `InstitutionDashboardProvider` to fetch statistics from the API
- Connected `InstitutionApplicantsProvider` to fetch real applications

### 3. ✅ Real-Time Updates
**Problem**: Data was not updating in real-time.
**Solution**:
- Created `InstitutionRealtimeService` for Supabase real-time subscriptions
- Integrated real-time updates for new applications, status changes, and deletions
- Dashboard now auto-updates when application data changes

## Testing Instructions

### Prerequisites
1. Ensure you have an institution account with valid credentials
2. Backend API must be running at `https://web-production-51e34.up.railway.app`
3. Supabase must be properly configured with valid credentials

### Test Scenarios

#### 1. Login and Initial Load
```
1. Launch the application
2. Navigate to login page
3. Login with institution credentials:
   - Email: [institution email]
   - Password: [institution password]
4. Verify: Should redirect to /institution/dashboard
5. Verify: Dashboard should load without errors
```

#### 2. Dashboard Overview Tab
```
1. On the institution dashboard, verify the Overview tab displays:
   - Total Applicants count (from real data)
   - Pending Review count
   - Active Programs count
   - Total Students count
2. Check Quick Actions section:
   - "Review Pending Applications" should be clickable if count > 0
   - "Under Review" should show correct count
   - "Accepted Applicants" should show correct count
   - "Create New Program" should be clickable
3. Verify Application Summary shows real statistics
4. Pull to refresh should update all data
```

#### 3. Applicants List Tab
```
1. Navigate to Applicants tab
2. Verify:
   - Real applications are displayed (not mock data)
   - Search functionality works
   - Tab filters work (All, Pending, Under Review, Accepted, Rejected)
   - Each applicant card shows:
     - Student name
     - Program applied for
     - Email and phone
     - GPA
     - Submission date
     - Status badge with correct color
```

#### 4. Applicant Detail View (404 Fix Test)
```
1. From the Applicants list, click on any applicant card
2. Verify:
   - NO 404 error occurs
   - Applicant detail screen loads successfully
   - All applicant information is displayed:
     - Status header with correct color
     - Student information
     - Program details
     - Statement of Purpose
     - Documents list
   - Action buttons appear for pending/under review applicants
```

#### 5. Application Review Workflow
```
1. Find a pending application and open its detail view
2. Test "Mark as Under Review":
   - Click menu button (three dots)
   - Select "Mark as Under Review"
   - Verify status changes to "Under Review"
3. Test Accept workflow:
   - Click "Accept" button
   - Add optional review notes
   - Confirm action
   - Verify status changes to "Accepted"
4. Test Reject workflow:
   - Find another pending application
   - Click "Reject" button
   - Add required review notes
   - Confirm action
   - Verify status changes to "Rejected"
```

#### 6. Real-Time Updates Test
```
1. Open institution dashboard in one browser/device
2. Open student dashboard in another browser/device
3. From student account, submit a new application
4. Verify on institution dashboard:
   - Total applicants count increases
   - Pending count increases
   - New application appears in the list without refresh
5. Change application status from institution dashboard
6. Verify changes reflect immediately in both views
```

#### 7. Error Handling
```
1. Test network disconnection:
   - Disconnect network
   - Try to load dashboard
   - Verify error message appears with retry button
2. Test invalid data:
   - Navigate to non-existent applicant ID manually
   - Verify redirect to applicants list with error message
```

#### 8. Performance Tests
```
1. Load dashboard with many applications (50+)
2. Verify:
   - Page loads within 3 seconds
   - Scrolling is smooth
   - Search is responsive
   - Tab switching is instant
```

## API Endpoints Being Used

The institution dashboard now uses these backend endpoints:

1. **GET** `/api/v1/institutions/me/applications`
   - Fetches all applications for the institution
   - Query params: `status`, `program_id`, `page`, `page_size`

2. **GET** `/api/v1/institutions/me/applications/statistics`
   - Fetches dashboard statistics

3. **PUT** `/api/v1/applications/{id}/status`
   - Updates application status (accept/reject/review)
   - Body: `{ status, reviewer_notes }`

4. **GET** `/api/v1/applications/{id}`
   - Fetches specific application details

## Debugging Tips

### Check Console Logs
Look for these log patterns to verify proper operation:
```
[ApplicationsAPI] GET https://... with token: eyJ...
[InstitutionDashboard] Fetched API statistics: {...}
[Realtime] Subscribed to institution applications for: [id]
[InstitutionApplicants] Received real-time update: [type] for [id]
```

### Common Issues and Solutions

1. **Still seeing mock data**:
   - Check if access token is being passed in API requests
   - Verify backend is running and accessible
   - Check network tab for API call responses

2. **Real-time not working**:
   - Verify Supabase credentials in environment
   - Check if WebSocket connection is established
   - Look for realtime subscription logs

3. **404 still occurring**:
   - Clear browser cache
   - Rebuild the application
   - Verify routing changes are compiled

## Code Files Modified

1. `lib/routing/app_router.dart`
   - Added institution applicant detail route
   - Created _ApplicantDetailWrapper widget

2. `lib/features/institution/applicants/presentation/applicants_list_screen.dart`
   - Updated navigation to pass applicant data

3. `lib/features/institution/providers/institution_dashboard_provider.dart`
   - Integrated real API statistics fetching
   - Added activity generation from real data

4. `lib/features/institution/providers/institution_applicants_provider.dart`
   - Added real-time subscription support
   - Integrated InstitutionRealtimeService

5. `lib/features/institution/services/realtime_service.dart` (NEW)
   - Created Supabase real-time subscription service

## Verification Checklist

- [ ] Institution can log in successfully
- [ ] Dashboard loads with real data
- [ ] Statistics show actual counts from backend
- [ ] Applicants list shows real applications
- [ ] Clicking on applicant opens detail view (no 404)
- [ ] Can mark applications as under review
- [ ] Can accept applications with notes
- [ ] Can reject applications with required notes
- [ ] Real-time updates work for new applications
- [ ] Real-time updates work for status changes
- [ ] Pull to refresh updates all data
- [ ] Search and filters work correctly
- [ ] Error states display properly
- [ ] Performance is acceptable

## Next Steps

If all tests pass:
1. Deploy to staging environment
2. Perform UAT with actual institution users
3. Monitor logs for any issues
4. Deploy to production

If issues are found:
1. Document the specific issue with steps to reproduce
2. Check console logs and network requests
3. Verify backend API is responding correctly
4. Report issues with relevant error messages and logs