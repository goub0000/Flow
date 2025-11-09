# Flow EdTech - Cookies & Consent Management Implementation Plan

**Version:** 1.0
**Date:** October 31, 2025
**Status:** 📋 Planning Phase
**GDPR Compliance:** ✅ Yes

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Cookie Categories](#cookie-categories)
3. [System Architecture](#system-architecture)
4. [Data Models](#data-models)
5. [User-Facing Features](#user-facing-features)
6. [Admin Dashboard Features](#admin-dashboard-features)
7. [Technical Implementation](#technical-implementation)
8. [Privacy & Compliance](#privacy--compliance)
9. [Implementation Timeline](#implementation-timeline)
10. [Testing Strategy](#testing-strategy)

---

## Executive Summary

### Goals
- ✅ **GDPR/CCPA Compliant** cookie consent system
- ✅ **User Control** over data collection
- ✅ **Admin Visibility** into user consent and collected data
- ✅ **Default Accept** with ability to customize
- ✅ **Essential-Only Option** for privacy-conscious users

### Key Features
- Cookie consent banner on first visit
- Granular consent management (4 cookie categories)
- Admin dashboard for consent analytics
- Automated cookie data collection and storage
- User consent history and audit trail
- Privacy-by-design architecture

### Consent Model
```
Default Mode: Accept All (with banner)
  ↓
User Can: Accept All | Customize | Essential Only
  ↓
Data Collection: Based on user consent
  ↓
Admin Access: View aggregated and individual consent data
```

---

## Cookie Categories

### 1. Essential Cookies (Always Active)
**Purpose:** Required for basic app functionality
**User Control:** ❌ Cannot be disabled
**Duration:** Session / 1 year

**Data Collected:**
- User authentication tokens
- Session management
- Security tokens (CSRF)
- Language preferences
- Theme settings
- Last visited page

**Storage:**
```dart
{
  'auth_token': 'jwt_token_here',
  'session_id': 'uuid',
  'user_role': 'student|institution|parent|counselor|recommender|admin',
  'csrf_token': 'random_string',
  'language': 'en',
  'theme': 'light|dark|system',
  'last_active': 'timestamp',
}
```

---

### 2. Functional Cookies
**Purpose:** Enhanced user experience
**User Control:** ✅ Can be disabled
**Duration:** 30 days - 1 year

**Data Collected:**
- Form auto-fill data
- User preferences (dashboard layout, filters)
- Course bookmarks and favorites
- Recent searches
- Notification settings
- Custom dashboard configurations

**Storage:**
```dart
{
  'saved_filters': {'courses': ['engineering', 'science']},
  'bookmarks': ['course_123', 'course_456'],
  'recent_searches': ['machine learning', 'data science'],
  'dashboard_layout': 'grid|list',
  'sidebar_collapsed': true,
  'notification_preferences': {...},
}
```

---

### 3. Analytics Cookies
**Purpose:** Understanding app usage and improving performance
**User Control:** ✅ Can be disabled
**Duration:** 90 days - 2 years

**Data Collected:**
- Page views and navigation paths
- Time spent on pages
- Feature usage statistics
- Device and browser information
- Screen resolution
- Click patterns (heatmaps)
- Error logs
- Performance metrics
- A/B test assignments

**Storage:**
```dart
{
  'user_id_hash': 'anonymized_user_id',
  'session_start': 'timestamp',
  'pages_visited': ['dashboard', 'courses', 'applications'],
  'time_per_page': {'dashboard': 120, 'courses': 300},
  'device_info': {
    'platform': 'web|android|ios',
    'browser': 'chrome|safari|firefox',
    'screen_size': '1920x1080',
    'os': 'windows|mac|linux|android|ios',
  },
  'interactions': {
    'clicks': 45,
    'scrolls': 12,
    'form_submissions': 3,
  },
  'errors_encountered': ['404_on_/admin/old-route'],
  'ab_tests': {'test_123': 'variant_b'},
}
```

---

### 4. Marketing Cookies
**Purpose:** Personalized content and advertising
**User Control:** ✅ Can be disabled
**Duration:** 180 days - 2 years

**Data Collected:**
- Course recommendations
- Personalized content suggestions
- Email campaign tracking
- Referral source tracking
- Social media integration
- Third-party analytics (if applicable)

**Storage:**
```dart
{
  'recommended_courses': ['course_789', 'course_012'],
  'interests': ['programming', 'data science', 'design'],
  'email_campaign_id': 'campaign_fall_2024',
  'referral_source': 'google|facebook|direct|organic',
  'utm_parameters': {
    'source': 'google',
    'medium': 'cpc',
    'campaign': 'fall_enrollment',
  },
  'last_recommendation_date': 'timestamp',
}
```

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter Web/Mobile App                   │
└───────────┬───────────────────────────────────┬─────────────┘
            │                                   │
            ▼                                   ▼
┌───────────────────────┐       ┌───────────────────────────┐
│  Cookie Consent UI    │       │  Cookie Manager Service   │
│  ────────────────     │       │  ────────────────────     │
│  • Banner             │       │  • Set cookies            │
│  • Preference Modal   │◄──────┤  • Get cookies            │
│  • Settings Page      │       │  • Delete cookies         │
└───────────────────────┘       │  • Check consent          │
                                │  • Sync with backend      │
                                └─────────────┬─────────────┘
                                              │
                                              ▼
                        ┌─────────────────────────────────────┐
                        │         Backend / Firebase          │
                        │  ────────────────────────────────   │
                        │  • Firestore: Consent records       │
                        │  • Analytics: Usage data            │
                        │  • Cloud Functions: Data processing │
                        └─────────────┬───────────────────────┘
                                      │
                                      ▼
                        ┌─────────────────────────────────────┐
                        │       Admin Dashboard               │
                        │  ────────────────────────────────   │
                        │  • Consent analytics                │
                        │  • User data viewer                 │
                        │  • Cookie audit logs                │
                        │  • Export reports                   │
                        └─────────────────────────────────────┘
```

---

## Data Models

### 1. User Consent Model

**File:** `lib/core/models/user_consent_model.dart`

```dart
/// User Consent Record
/// Stores user's cookie consent preferences and history
class UserConsent {
  final String id;                    // Unique consent record ID
  final String userId;                // User ID (or anonymous ID)
  final ConsentStatus status;         // acceptAll | custom | essentialOnly

  // Granular consent for each category
  final bool essentialConsent;        // Always true
  final bool functionalConsent;
  final bool analyticsConsent;
  final bool marketingConsent;

  // Metadata
  final DateTime consentDate;         // When consent was given
  final DateTime expiryDate;          // When consent expires (1 year)
  final DateTime? lastModified;       // Last update
  final String consentVersion;        // Privacy policy version
  final String ipAddress;             // IP at time of consent
  final String userAgent;             // Browser/device info
  final String platform;              // web|android|ios

  // Audit trail
  final List<ConsentChange> history;  // All consent changes
  final bool isExplicit;              // true if user clicked, false if default

  const UserConsent({
    required this.id,
    required this.userId,
    required this.status,
    this.essentialConsent = true,
    required this.functionalConsent,
    required this.analyticsConsent,
    required this.marketingConsent,
    required this.consentDate,
    required this.expiryDate,
    this.lastModified,
    required this.consentVersion,
    required this.ipAddress,
    required this.userAgent,
    required this.platform,
    this.history = const [],
    this.isExplicit = false,
  });

  // Firestore serialization
  Map<String, dynamic> toFirestore() => {...};
  factory UserConsent.fromFirestore(Map<String, dynamic> data) => {...};
}

/// Consent status enum
enum ConsentStatus {
  acceptAll,        // All cookies enabled
  custom,           // User customized preferences
  essentialOnly,    // Only essential cookies
  notSet,           // No consent given yet
}

/// Consent change history
class ConsentChange {
  final DateTime timestamp;
  final ConsentStatus previousStatus;
  final ConsentStatus newStatus;
  final Map<String, bool> changes;  // Which categories changed
  final String changeReason;        // 'user_action' | 'expiry' | 'policy_update'

  const ConsentChange({
    required this.timestamp,
    required this.previousStatus,
    required this.newStatus,
    required this.changes,
    required this.changeReason,
  });
}
```

---

### 2. Cookie Data Model

**File:** `lib/core/models/cookie_data_model.dart`

```dart
/// Cookie Data Collected
/// Represents data collected based on user consent
class CookieData {
  final String id;
  final String userId;
  final String sessionId;
  final CookieCategory category;
  final Map<String, dynamic> data;
  final DateTime collectedAt;
  final DateTime? expiresAt;
  final String deviceId;
  final String platform;

  const CookieData({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.category,
    required this.data,
    required this.collectedAt,
    this.expiresAt,
    required this.deviceId,
    required this.platform,
  });

  // Anonymize user data for analytics
  CookieData anonymize() {
    return CookieData(
      id: id,
      userId: _hashUserId(userId),
      sessionId: sessionId,
      category: category,
      data: _sanitizeData(data),
      collectedAt: collectedAt,
      expiresAt: expiresAt,
      deviceId: deviceId,
      platform: platform,
    );
  }
}

enum CookieCategory {
  essential,
  functional,
  analytics,
  marketing,
}
```

---

### 3. Session Analytics Model

**File:** `lib/core/models/session_analytics_model.dart`

```dart
/// Session Analytics
/// Aggregated session data for admin dashboard
class SessionAnalytics {
  final String sessionId;
  final String userId;
  final DateTime sessionStart;
  final DateTime? sessionEnd;
  final Duration duration;

  // Navigation data
  final List<PageView> pagesVisited;
  final String entryPage;
  final String? exitPage;

  // Interaction data
  final int totalClicks;
  final int totalScrolls;
  final int formsSubmitted;
  final List<String> buttonsClicked;

  // Performance data
  final double avgPageLoadTime;
  final List<ErrorLog> errors;

  // Device data
  final DeviceInfo device;
  final String ipAddress;
  final String? location;  // City, Country (if consented)

  const SessionAnalytics({
    required this.sessionId,
    required this.userId,
    required this.sessionStart,
    this.sessionEnd,
    required this.duration,
    required this.pagesVisited,
    required this.entryPage,
    this.exitPage,
    required this.totalClicks,
    required this.totalScrolls,
    required this.formsSubmitted,
    required this.buttonsClicked,
    required this.avgPageLoadTime,
    required this.errors,
    required this.device,
    required this.ipAddress,
    this.location,
  });
}

class PageView {
  final String route;
  final DateTime timestamp;
  final Duration timeSpent;
  final int scrollDepth;  // Percentage scrolled

  const PageView({
    required this.route,
    required this.timestamp,
    required this.timeSpent,
    required this.scrollDepth,
  });
}

class DeviceInfo {
  final String platform;
  final String browser;
  final String browserVersion;
  final String os;
  final String osVersion;
  final String screenResolution;
  final String language;
  final String timezone;

  const DeviceInfo({
    required this.platform,
    required this.browser,
    required this.browserVersion,
    required this.os,
    required this.osVersion,
    required this.screenResolution,
    required this.language,
    required this.timezone,
  });
}
```

---

## User-Facing Features

### 1. Cookie Consent Banner

**Location:** Bottom of screen on first visit
**Behavior:**
- Shows on first app launch
- Re-shows when policy updates
- Can be dismissed to accept all (default)
- Persists choice for 1 year

**UI Design:**

```
┌──────────────────────────────────────────────────────────┐
│  🍪  We use cookies to improve your experience           │
│                                                           │
│  We use cookies and similar technologies to provide      │
│  essential services, enhance functionality, analyze      │
│  usage, and personalize content.                         │
│                                                           │
│  [ Privacy Policy ]  [ Customize ]  [ Accept All ✓ ]    │
└──────────────────────────────────────────────────────────┘
```

**File:** `lib/features/shared/cookies/cookie_consent_banner.dart`

**Key Features:**
- ✅ Non-intrusive bottom banner
- ✅ Dismissible (defaults to accept all)
- ✅ Links to privacy policy
- ✅ Customize button opens preferences
- ✅ "Essential Only" quick option
- ✅ Remembers user choice

---

### 2. Cookie Preferences Modal

**Triggered by:** "Customize" button or Settings menu
**Layout:** Bottom sheet / full-screen modal

**UI Design:**

```
┌────────────────────────────────────────────────────┐
│  Cookie Preferences                        [Close] │
├────────────────────────────────────────────────────┤
│                                                    │
│  Manage your cookie preferences below. You can     │
│  enable or disable each category.                  │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │ 🔒 Essential Cookies           [Always On] │ │
│  │ Required for the app to function            │ │
│  │ [More Info ▼]                                 │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │ ⚙️ Functional Cookies            [Toggle ✓] │ │
│  │ Enhanced features and preferences            │ │
│  │ [More Info ▼]                                 │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │ 📊 Analytics Cookies             [Toggle ✓] │ │
│  │ Help us improve the app                      │ │
│  │ [More Info ▼]                                 │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │ 🎯 Marketing Cookies             [Toggle  ] │ │
│  │ Personalized recommendations                 │ │
│  │ [More Info ▼]                                 │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  [Accept Selection]  [Accept All]  [Reject All]   │
└────────────────────────────────────────────────────┘
```

**File:** `lib/features/shared/cookies/cookie_preferences_modal.dart`

**Features:**
- ✅ Expandable info for each category
- ✅ Toggle switches for each type
- ✅ Essential cookies locked to "on"
- ✅ "Accept All" / "Reject All" shortcuts
- ✅ Real-time preview of enabled features

---

### 3. Cookie Settings Page

**Location:** Settings → Privacy & Data → Cookie Settings
**Access:** All authenticated users

**UI Design:**

```
┌────────────────────────────────────────────────────┐
│  ← Cookie Settings                                 │
├────────────────────────────────────────────────────┤
│                                                    │
│  Current Status: ✅ All Cookies Accepted          │
│  Last Updated: Oct 31, 2025                        │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │  YOUR COOKIE PREFERENCES                     │ │
│  ├──────────────────────────────────────────────┤ │
│  │  Essential: ✅ (Required)                    │ │
│  │  Functional: ✅                              │ │
│  │  Analytics: ✅                               │ │
│  │  Marketing: ❌                               │ │
│  │                                              │ │
│  │  [Change Preferences]                        │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │  DATA COLLECTED                              │ │
│  ├──────────────────────────────────────────────┤ │
│  │  • Session data                              │ │
│  │  • Usage analytics                           │ │
│  │  • Device information                        │ │
│  │  • Performance metrics                       │ │
│  │                                              │ │
│  │  [View My Data]  [Download Data]            │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  ┌──────────────────────────────────────────────┐ │
│  │  DATA RIGHTS (GDPR)                          │ │
│  ├──────────────────────────────────────────────┤ │
│  │  • Right to access your data                 │ │
│  │  • Right to delete your data                 │ │
│  │  • Right to data portability                 │ │
│  │  • Right to withdraw consent                 │ │
│  │                                              │ │
│  │  [Delete All Cookie Data]                    │ │
│  └──────────────────────────────────────────────┘ │
│                                                    │
│  [View Privacy Policy]  [Contact Support]         │
└────────────────────────────────────────────────────┘
```

**File:** `lib/features/shared/settings/cookie_settings_screen.dart`

---

## Admin Dashboard Features

### 1. Cookie Consent Analytics Dashboard

**Location:** Admin → Analytics → Cookie Consent
**Access:** Super Admin, Analytics Admin

**UI Design:**

```
┌─────────────────────────────────────────────────────────────┐
│  Cookie Consent Analytics                    [Export] [⟲]   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📊 CONSENT OVERVIEW                                         │
│  ┌──────────┬──────────┬──────────┬──────────┬───────────┐ │
│  │ Total    │ Accept   │ Custom   │Essential │ Not Set   │ │
│  │ Users    │ All      │          │ Only     │           │ │
│  ├──────────┼──────────┼──────────┼──────────┼───────────┤ │
│  │ 12,458   │ 8,921    │ 2,134    │ 1,203    │ 200       │ │
│  │ 100%     │ 71.6%    │ 17.1%    │ 9.7%     │ 1.6%      │ │
│  └──────────┴──────────┴──────────┴──────────┴───────────┘ │
│                                                              │
│  📈 CONSENT TRENDS (Last 30 Days)                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │     [Line chart showing consent over time]             │ │
│  │     - Accept All (increasing)                          │ │
│  │     - Custom (stable)                                  │ │
│  │     - Essential Only (slight decrease)                 │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  🍪 COOKIE CATEGORY ADOPTION                                │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Essential:   100% ████████████████████████████████  │  │
│  │  Functional:   88% █████████████████████████░░░░░░  │  │
│  │  Analytics:    76% ████████████████████░░░░░░░░░░░  │  │
│  │  Marketing:    45% ████████████░░░░░░░░░░░░░░░░░░░  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                              │
│  🌍 CONSENT BY REGION                                        │
│  ┌──────────────────┬──────────┬──────────┬─────────────┐  │
│  │ Region           │ Users    │Accept All│Essential     │  │
│  ├──────────────────┼──────────┼──────────┼─────────────┤  │
│  │ Europe (GDPR)    │ 3,456    │ 52%      │ 25%          │  │
│  │ North America    │ 5,234    │ 78%      │ 8%           │  │
│  │ Africa           │ 2,890    │ 82%      │ 5%           │  │
│  │ Asia             │ 878      │ 76%      │ 12%          │  │
│  └──────────────────┴──────────┴──────────┴─────────────┘  │
│                                                              │
│  ⚖️ COMPLIANCE STATUS                                        │
│  ✅ GDPR Compliant                                           │
│  ✅ CCPA Compliant                                           │
│  ✅ Cookie Policy Updated: Oct 15, 2025                     │
│  ⚠️  203 users need consent renewal (expires in 30 days)    │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

**File:** `lib/features/admin/analytics/presentation/cookie_consent_analytics_screen.dart`

---

### 2. User Cookie Data Viewer

**Location:** Admin → Users → [Select User] → Cookie Data
**Access:** Super Admin, Support Admin

**UI Design:**

```
┌─────────────────────────────────────────────────────────────┐
│  ← User Cookie Data - John Doe (student@example.com)        │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📋 CONSENT STATUS                                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Status: ✅ Custom Preferences                         │ │
│  │  Last Updated: Oct 28, 2025 10:32 AM                   │ │
│  │  Consent Version: v2.1                                 │ │
│  │  Expires: Oct 28, 2026                                 │ │
│  │                                                         │ │
│  │  Essential:   ✅ (Required)                            │ │
│  │  Functional:  ✅                                       │ │
│  │  Analytics:   ✅                                       │ │
│  │  Marketing:   ❌                                       │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  📊 SESSION HISTORY (Last 7 Days)                           │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Oct 31  │ 3 sessions │ 45 min avg │ 23 pages          │ │
│  │  Oct 30  │ 2 sessions │ 38 min avg │ 15 pages          │ │
│  │  Oct 29  │ 4 sessions │ 52 min avg │ 31 pages          │ │
│  │  Oct 28  │ 1 session  │ 20 min avg │ 8 pages           │ │
│  │  ...                                                    │ │
│  │                                                         │ │
│  │  [View Detailed Sessions]                              │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  🍪 COLLECTED DATA SUMMARY                                  │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Essential Data:                                       │ │
│  │  • Auth tokens, session IDs                           │ │
│  │  • Last visited: /student/dashboard                   │ │
│  │                                                         │ │
│  │  Functional Data:                                      │ │
│  │  • 5 bookmarked courses                               │ │
│  │  • 12 saved filters                                   │ │
│  │  • Dashboard layout: Grid view                        │ │
│  │                                                         │ │
│  │  Analytics Data:                                       │ │
│  │  • 156 total page views                               │ │
│  │  • Avg session: 42 minutes                            │ │
│  │  • Device: Chrome on Windows                          │ │
│  │  • Screen: 1920x1080                                  │ │
│  │                                                         │ │
│  │  [View Full Data] [Export JSON] [Download CSV]       │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  📜 CONSENT HISTORY                                          │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  Oct 28, 2025  │ Changed to Custom    │ User Action   │ │
│  │  Oct 15, 2025  │ Policy Updated       │ Auto-prompt   │ │
│  │  Sep 01, 2025  │ Initial: Accept All  │ Default       │ │
│  │                                                         │ │
│  │  [View Full History]                                   │ │
│  └────────────────────────────────────────────────────────┘ │
│                                                              │
│  ⚙️ ADMIN ACTIONS                                            │
│  [Revoke Consent] [Delete User Data] [Export Report]       │
│                                                              │
│  ⚠️  Actions are logged and cannot be undone               │
└─────────────────────────────────────────────────────────────┘
```

**File:** `lib/features/admin/users/presentation/user_cookie_data_screen.dart`

---

### 3. Cookie Audit Log

**Location:** Admin → System → Cookie Audit
**Access:** Super Admin only

**Features:**
- View all consent changes
- Track data access by admins
- Monitor consent expiries
- Compliance reporting
- Export audit trails

**File:** `lib/features/admin/system/presentation/cookie_audit_log_screen.dart`

---

## Technical Implementation

### Phase 1: Core Infrastructure (Week 1)

#### 1.1 Data Models
**Files to Create:**
- `lib/core/models/user_consent_model.dart`
- `lib/core/models/cookie_data_model.dart`
- `lib/core/models/session_analytics_model.dart`

#### 1.2 Cookie Service
**File:** `lib/core/services/cookie_service.dart`

```dart
/// Cookie Management Service
class CookieService {
  static final CookieService _instance = CookieService._internal();
  factory CookieService() => _instance;
  CookieService._internal();

  final _prefs = SharedPreferences.getInstance();
  UserConsent? _currentConsent;

  /// Initialize and check consent status
  Future<void> initialize() async {
    _currentConsent = await _loadConsent();

    // Show banner if no consent
    if (_currentConsent == null || _isConsentExpired()) {
      _showConsentBanner();
    }
  }

  /// Check if user has consented to a cookie category
  bool hasConsent(CookieCategory category) {
    if (_currentConsent == null) return false;

    switch (category) {
      case CookieCategory.essential:
        return true;  // Always allowed
      case CookieCategory.functional:
        return _currentConsent!.functionalConsent;
      case CookieCategory.analytics:
        return _currentConsent!.analyticsConsent;
      case CookieCategory.marketing:
        return _currentConsent!.marketingConsent;
    }
  }

  /// Save consent
  Future<void> saveConsent(UserConsent consent) async {
    _currentConsent = consent;
    await _persistConsent(consent);
    await _syncWithBackend(consent);
    _triggerDataCollection();
  }

  /// Track page view (if analytics enabled)
  Future<void> trackPageView(String route) async {
    if (!hasConsent(CookieCategory.analytics)) return;

    final pageView = PageView(
      route: route,
      timestamp: DateTime.now(),
      // ... more data
    );

    await _sendToAnalytics(pageView);
  }

  /// Set cookie
  Future<void> setCookie(String key, dynamic value, CookieCategory category) async {
    if (!hasConsent(category)) return;

    final prefs = await _prefs;
    // Store based on type
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  /// Get cookie
  Future<T?> getCookie<T>(String key) async {
    final prefs = await _prefs;
    return prefs.get(key) as T?;
  }

  /// Delete all non-essential cookies
  Future<void> deleteAllCookies() async {
    final prefs = await _prefs;
    final essentialKeys = ['auth_token', 'session_id', 'user_role'];

    final allKeys = prefs.getKeys();
    for (final key in allKeys) {
      if (!essentialKeys.contains(key)) {
        await prefs.remove(key);
      }
    }
  }
}
```

#### 1.3 Analytics Service
**File:** `lib/core/services/analytics_service.dart`

```dart
/// Analytics Service
/// Collects usage data based on user consent
class AnalyticsService {
  final CookieService _cookieService = CookieService();

  /// Track screen view
  Future<void> trackScreen(String screenName) async {
    if (!_cookieService.hasConsent(CookieCategory.analytics)) return;

    await _cookieService.trackPageView(screenName);
  }

  /// Track event
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties) async {
    if (!_cookieService.hasConsent(CookieCategory.analytics)) return;

    // Send to backend
    await _sendEvent(eventName, properties);
  }

  /// Track user action
  Future<void> trackAction(String action, String target) async {
    if (!_cookieService.hasConsent(CookieCategory.analytics)) return;

    // Log the action
  }
}
```

---

### Phase 2: User Interface (Week 2)

#### 2.1 Cookie Consent Banner
**File:** `lib/features/shared/cookies/cookie_consent_banner.dart`

```dart
class CookieConsentBanner extends StatelessWidget {
  const CookieConsentBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.cookie, size: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We use cookies to improve your experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'We use cookies and similar technologies to provide essential services, enhance functionality, analyze usage, and personalize content.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: () => _showPrivacyPolicy(context),
                    child: const Text('Privacy Policy'),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => _showCustomizeModal(context),
                    child: const Text('Customize'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _acceptAll(context),
                    child: const Text('Accept All'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _acceptAll(BuildContext context) async {
    final consent = UserConsent(
      id: const Uuid().v4(),
      userId: 'current_user_id',
      status: ConsentStatus.acceptAll,
      essentialConsent: true,
      functionalConsent: true,
      analyticsConsent: true,
      marketingConsent: true,
      consentDate: DateTime.now(),
      expiryDate: DateTime.now().add(const Duration(days: 365)),
      consentVersion: '2.1',
      ipAddress: await _getIpAddress(),
      userAgent: await _getUserAgent(),
      platform: Platform.operatingSystem,
      isExplicit: true,
    );

    await CookieService().saveConsent(consent);
    Navigator.pop(context);
  }
}
```

#### 2.2 Cookie Preferences Modal
**File:** `lib/features/shared/cookies/cookie_preferences_modal.dart`

```dart
class CookiePreferencesModal extends StatefulWidget {
  const CookiePreferencesModal({super.key});

  @override
  State<CookiePreferencesModal> createState() => _CookiePreferencesModalState();
}

class _CookiePreferencesModalState extends State<CookiePreferencesModal> {
  bool _functional = true;
  bool _analytics = true;
  bool _marketing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Text(
                'Cookie Preferences',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'Manage your cookie preferences below. You can enable or disable each category.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Cookie categories
          Expanded(
            child: ListView(
              children: [
                _buildCategoryCard(
                  icon: Icons.lock,
                  title: 'Essential Cookies',
                  description: 'Required for the app to function properly',
                  isEnabled: true,
                  isLocked: true,
                  onChanged: null,
                ),
                _buildCategoryCard(
                  icon: Icons.settings,
                  title: 'Functional Cookies',
                  description: 'Enhanced features and saved preferences',
                  isEnabled: _functional,
                  onChanged: (value) => setState(() => _functional = value!),
                ),
                _buildCategoryCard(
                  icon: Icons.analytics,
                  title: 'Analytics Cookies',
                  description: 'Help us understand how you use our app',
                  isEnabled: _analytics,
                  onChanged: (value) => setState(() => _analytics = value!),
                ),
                _buildCategoryCard(
                  icon: Icons.campaign,
                  title: 'Marketing Cookies',
                  description: 'Personalized content and recommendations',
                  isEnabled: _marketing,
                  onChanged: (value) => setState(() => _marketing = value!),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _rejectAll,
                  child: const Text('Essential Only'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _savePreferences,
                  child: const Text('Save Preferences'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _savePreferences() async {
    final consent = UserConsent(
      // ... build consent object
      functionalConsent: _functional,
      analyticsConsent: _analytics,
      marketingConsent: _marketing,
      status: ConsentStatus.custom,
    );

    await CookieService().saveConsent(consent);
    Navigator.pop(context);
  }
}
```

---

### Phase 3: Admin Dashboard (Week 3)

#### 3.1 Cookie Consent Analytics
**File:** `lib/features/admin/analytics/presentation/cookie_consent_analytics_screen.dart`

```dart
class CookieConsentAnalyticsScreen extends ConsumerWidget {
  const CookieConsentAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(cookieAnalyticsProvider);

    return AdminShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 24),

            // Overview cards
            _buildOverviewCards(analytics),
            const SizedBox(height: 24),

            // Trends chart
            _buildTrendsChart(analytics),
            const SizedBox(height: 24),

            // Category adoption
            _buildCategoryAdoption(analytics),
            const SizedBox(height: 24),

            // Regional breakdown
            _buildRegionalBreakdown(analytics),
          ],
        ),
      ),
    );
  }
}
```

#### 3.2 User Cookie Data Viewer
**File:** `lib/features/admin/users/presentation/user_cookie_data_screen.dart`

```dart
class UserCookieDataScreen extends ConsumerWidget {
  final String userId;

  const UserCookieDataScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userCookieDataProvider(userId));

    return AdminShell(
      child: userData.when(
        data: (data) => _buildContent(context, data),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }
}
```

---

### Phase 4: Backend Integration (Week 4)

#### 4.1 Firebase Structure

```
/consent_records
  /{userId}
    /current
      - status: "acceptAll" | "custom" | "essentialOnly"
      - essential: true
      - functional: true
      - analytics: true
      - marketing: false
      - consentDate: Timestamp
      - expiryDate: Timestamp
      - consentVersion: "2.1"
      - platform: "web"

    /history
      /{consentId}
        - timestamp: Timestamp
        - previousStatus: "custom"
        - newStatus: "acceptAll"
        - changes: {...}

/cookie_data
  /{userId}
    /sessions
      /{sessionId}
        - sessionStart: Timestamp
        - sessionEnd: Timestamp
        - pagesVisited: [...]
        - interactions: {...}

    /analytics
      /{date}
        - pageViews: 45
        - avgDuration: 720
        - uniquePages: 12

/analytics
  /consent_stats
    /daily
      /{date}
        - totalUsers: 1000
        - acceptAll: 750
        - custom: 150
        - essentialOnly: 100
```

#### 4.2 Cloud Functions

**File:** `functions/src/cookieManagement.ts`

```typescript
// Expire old consents
export const expireOldConsents = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    const expiredConsents = await db
      .collection('consent_records')
      .where('expiryDate', '<', now)
      .get();

    // Update expired consents
    const batch = db.batch();
    expiredConsents.forEach(doc => {
      batch.update(doc.ref, {
        status: 'expired',
        needsRenewal: true
      });
    });

    await batch.commit();
    return null;
  });

// Aggregate consent statistics
export const aggregateConsentStats = functions.firestore
  .document('consent_records/{userId}/current')
  .onWrite(async (change, context) => {
    // Update daily stats
    const date = new Date().toISOString().split('T')[0];

    await db.doc(`analytics/consent_stats/daily/${date}`).set({
      // ... aggregated data
    }, { merge: true });
  });

// GDPR data export
export const exportUserData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be logged in');
  }

  const userId = context.auth.uid;

  // Collect all user data
  const consentData = await db.collection(`consent_records/${userId}`).get();
  const cookieData = await db.collection(`cookie_data/${userId}`).get();

  return {
    consent: consentData.docs.map(d => d.data()),
    cookies: cookieData.docs.map(d => d.data()),
  };
});
```

---

## Privacy & Compliance

### GDPR Compliance Checklist

✅ **Consent Requirements**
- [ ] Clear and specific consent requests
- [ ] Separate consent for each cookie category
- [ ] Pre-checked boxes not allowed (except essential)
- [ ] Easy to withdraw consent
- [ ] Consent records kept for 3 years

✅ **User Rights**
- [ ] Right to access data (data export)
- [ ] Right to erasure (delete all data)
- [ ] Right to data portability (JSON/CSV export)
- [ ] Right to object (opt-out)
- [ ] Right to restriction of processing

✅ **Transparency**
- [ ] Clear cookie policy
- [ ] Updated privacy policy
- [ ] List of all cookies and purposes
- [ ] Data retention periods disclosed
- [ ] Third-party data sharing disclosed

✅ **Technical Measures**
- [ ] Cookies only set after consent
- [ ] Consent recorded with timestamp
- [ ] IP address logged (for audit)
- [ ] Automatic consent expiry (1 year)
- [ ] Secure data transmission (HTTPS)

---

## Implementation Timeline

### Week 1: Foundation (Nov 4-10, 2025)
- ✅ Create data models
- ✅ Implement CookieService
- ✅ Implement AnalyticsService
- ✅ Setup SharedPreferences storage
- ✅ Write unit tests

### Week 2: User Interface (Nov 11-17, 2025)
- ✅ Build Cookie Consent Banner
- ✅ Build Cookie Preferences Modal
- ✅ Add to Settings screen
- ✅ Create Cookie Settings page
- ✅ Implement data export UI

### Week 3: Admin Dashboard (Nov 18-24, 2025)
- ✅ Cookie Consent Analytics screen
- ✅ User Cookie Data viewer
- ✅ Cookie Audit Log
- ✅ Admin reports and exports
- ✅ Add to admin navigation

### Week 4: Backend & Testing (Nov 25-Dec 1, 2025)
- ✅ Firebase integration
- ✅ Cloud Functions
- ✅ Data sync logic
- ✅ End-to-end testing
- ✅ Performance optimization

### Week 5: Documentation & Launch (Dec 2-8, 2025)
- ✅ Update Privacy Policy
- ✅ Update Terms of Service
- ✅ User documentation
- ✅ Admin training materials
- ✅ Soft launch to test users

### Week 6: Full Launch (Dec 9-15, 2025)
- ✅ Production deployment
- ✅ Monitor consent rates
- ✅ Fix any issues
- ✅ Gather feedback

---

## Testing Strategy

### Unit Tests
```dart
// Test: Cookie service initialization
test('CookieService initializes correctly', () async {
  final service = CookieService();
  await service.initialize();

  expect(service.isInitialized, true);
});

// Test: Consent validation
test('Essential cookies always enabled', () {
  final service = CookieService();

  expect(service.hasConsent(CookieCategory.essential), true);
});

// Test: Analytics tracking with consent
test('Analytics only tracks with consent', () async {
  final service = CookieService();

  // No consent
  await service.trackPageView('/test');
  expect(analyticsCallCount, 0);

  // With consent
  await service.saveConsent(consentWithAnalytics);
  await service.trackPageView('/test');
  expect(analyticsCallCount, 1);
});
```

### Integration Tests
```dart
// Test: Full consent flow
testWidgets('User can customize cookie preferences', (tester) async {
  await tester.pumpWidget(MyApp());

  // Banner appears
  expect(find.byType(CookieConsentBanner), findsOneWidget);

  // Click customize
  await tester.tap(find.text('Customize'));
  await tester.pumpAndSettle();

  // Modal appears
  expect(find.byType(CookiePreferencesModal), findsOneWidget);

  // Toggle analytics off
  await tester.tap(find.text('Analytics Cookies'));
  await tester.pumpAndSettle();

  // Save
  await tester.tap(find.text('Save Preferences'));
  await tester.pumpAndSettle();

  // Verify saved
  final service = CookieService();
  expect(service.hasConsent(CookieCategory.analytics), false);
});
```

### Manual Testing Checklist
- [ ] Banner shows on first visit
- [ ] Banner doesn't show after consent given
- [ ] All cookie types can be toggled
- [ ] Essential cookies cannot be disabled
- [ ] Preferences save correctly
- [ ] Analytics only collects with consent
- [ ] Admin can view user consent status
- [ ] Admin can export consent data
- [ ] Data export includes all user data
- [ ] Delete data works correctly

---

## Success Metrics

### User Metrics
- **Consent Rate:** Target 80%+ accept some cookies
- **Accept All Rate:** Expected 60-70%
- **Custom Preferences:** Expected 15-20%
- **Essential Only:** Expected 10-15%

### Technical Metrics
- **Page Load Impact:** < 50ms overhead
- **Storage Size:** < 5KB per user
- **Sync Success Rate:** > 99%
- **API Response Time:** < 200ms

### Compliance Metrics
- **Consent Capture Rate:** 100%
- **Audit Log Coverage:** 100%
- **Data Export Success:** > 99%
- **GDPR Violations:** 0

---

## Appendix

### A. Privacy Policy Updates

Add the following section to the Privacy Policy:

**Cookie Policy**

We use cookies and similar tracking technologies to provide and improve our services. This section explains what cookies are, how we use them, and how you can control them.

**What Are Cookies?**
Cookies are small text files stored on your device when you visit our website or use our app. They help us recognize you, remember your preferences, and provide personalized experiences.

**Cookie Categories:**

1. **Essential Cookies (Required)**
   - These cookies are necessary for the app to function and cannot be disabled.
   - Examples: Authentication, security, session management

2. **Functional Cookies (Optional)**
   - These cookies enhance your experience but are not essential.
   - Examples: Saved preferences, bookmarks, custom layouts

3. **Analytics Cookies (Optional)**
   - These cookies help us understand how users interact with our app.
   - Examples: Page views, session duration, feature usage

4. **Marketing Cookies (Optional)**
   - These cookies enable personalized recommendations and content.
   - Examples: Course recommendations, targeted emails

**Managing Cookies:**
You can manage your cookie preferences at any time through Settings → Privacy & Data → Cookie Settings. Changes take effect immediately.

**Cookie Lifespan:**
- Essential cookies: Session or 1 year
- Functional cookies: 30 days - 1 year
- Analytics cookies: 90 days - 2 years
- Marketing cookies: 180 days - 2 years

Your consent is valid for 1 year and will be requested again upon expiry.

### B. Terms of Service Updates

Add clause:

**Data Collection and Cookies**

By using our services, you acknowledge that we use cookies and tracking technologies as described in our Cookie Policy. You have the right to control which cookies we use through your cookie preferences. Essential cookies cannot be disabled as they are required for basic functionality.

---

## Contact & Support

**Implementation Team:**
- Lead Developer: [Assign]
- Backend Developer: [Assign]
- UI/UX Designer: [Assign]
- Legal/Compliance: [Assign]

**Questions?**
- Email: privacy@flowedtech.com
- Slack: #cookies-implementation
- Documentation: /docs/cookies

---

**Document Status:** ✅ Complete and Ready for Review
**Next Steps:** Begin Week 1 implementation
**Review By:** Legal team, Product Manager, Engineering Lead

---

*This implementation plan follows GDPR, CCPA, and industry best practices for cookie consent management. All features are designed with privacy-by-design principles.*
