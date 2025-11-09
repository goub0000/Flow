# Cookies Implementation Guide - Prioritized Task List

**Project:** Flow EdTech App - GDPR-Compliant Cookie Consent System
**Timeline:** 6 weeks (30 working days)
**Status:** Ready for Implementation

---

## Table of Contents
1. [Priority Overview](#priority-overview)
2. [Phase 1: Foundation & Core Models](#phase-1-foundation--core-models)
3. [Phase 2: Services & Business Logic](#phase-2-services--business-logic)
4. [Phase 3: User-Facing UI](#phase-3-user-facing-ui)
5. [Phase 4: Admin Dashboard](#phase-4-admin-dashboard)
6. [Phase 5: Backend Integration](#phase-5-backend-integration)
7. [Phase 6: Testing & Compliance](#phase-6-testing--compliance)

---

## Priority Overview

### Priority Levels:
- **P0 (Critical)**: Must be completed first, blocking all other work
- **P1 (High)**: Core functionality, needed before UI implementation
- **P2 (Medium)**: User-facing features, needed before admin features
- **P3 (Low)**: Admin features and enhancements
- **P4 (Polish)**: Nice-to-have improvements and optimizations

### Implementation Order:
```
P0: Foundation (Days 1-3)
├── Core models
├── Constants and enums
└── Basic storage setup

P1: Services (Days 4-7)
├── Cookie service
├── Consent service
└── Analytics service

P2: User UI (Days 8-15)
├── Cookie banner
├── Preferences modal
└── Settings page

P3: Admin Dashboard (Days 16-23)
├── Consent analytics
├── User data viewer
└── Audit log

P4: Backend & Polish (Days 24-30)
├── Firebase integration
├── Cloud Functions
└── Testing & optimization
```

---

## Phase 1: Foundation & Core Models
**Duration:** Days 1-3 (3 days)
**Priority:** P0 (Critical)

### Task 1.1: Create Constants & Enums
**Priority:** P0
**Estimated Time:** 2 hours
**File:** `lib/core/constants/cookie_constants.dart`

**Create new file with:**

```dart
// lib/core/constants/cookie_constants.dart

/// Cookie category types
enum CookieCategory {
  essential,
  functional,
  analytics,
  marketing;

  String get displayName {
    switch (this) {
      case CookieCategory.essential:
        return 'Essential';
      case CookieCategory.functional:
        return 'Functional';
      case CookieCategory.analytics:
        return 'Analytics';
      case CookieCategory.marketing:
        return 'Marketing';
    }
  }

  String get description {
    switch (this) {
      case CookieCategory.essential:
        return 'Required for the website to function. Cannot be disabled.';
      case CookieCategory.functional:
        return 'Enable personalized features and preferences.';
      case CookieCategory.analytics:
        return 'Help us understand how you use our platform.';
      case CookieCategory.marketing:
        return 'Used to show relevant content and recommendations.';
    }
  }

  IconData get icon {
    switch (this) {
      case CookieCategory.essential:
        return Icons.security;
      case CookieCategory.functional:
        return Icons.tune;
      case CookieCategory.analytics:
        return Icons.analytics;
      case CookieCategory.marketing:
        return Icons.campaign;
    }
  }
}

/// Consent status
enum ConsentStatus {
  notAsked,
  accepted,
  customized,
  declined;
}

/// Cookie data types
enum CookieDataType {
  authToken,
  sessionId,
  userPreference,
  pageView,
  clickEvent,
  searchQuery,
  deviceInfo,
  performanceMetric,
  recommendation,
  campaignTracking;

  CookieCategory get category {
    switch (this) {
      case CookieDataType.authToken:
      case CookieDataType.sessionId:
        return CookieCategory.essential;
      case CookieDataType.userPreference:
      case CookieDataType.searchQuery:
        return CookieCategory.functional;
      case CookieDataType.pageView:
      case CookieDataType.clickEvent:
      case CookieDataType.deviceInfo:
      case CookieDataType.performanceMetric:
        return CookieCategory.analytics;
      case CookieDataType.recommendation:
      case CookieDataType.campaignTracking:
        return CookieCategory.marketing;
    }
  }
}

/// Cookie constants
class CookieConstants {
  // Storage keys
  static const String consentStatusKey = 'cookie_consent_status';
  static const String consentTimestampKey = 'cookie_consent_timestamp';
  static const String consentVersionKey = 'cookie_consent_version';
  static const String consentCategoriesKey = 'cookie_consent_categories';

  // Cookie settings
  static const int consentValidityDays = 365; // 1 year
  static const String currentConsentVersion = '1.0.0';

  // Analytics settings
  static const int maxCookieDataAge = 90; // days
  static const int sessionTimeout = 30; // minutes

  // Local storage keys for cookie data
  static const String localCookieDataKey = 'local_cookie_data';
  static const String sessionDataKey = 'session_analytics_data';
}
```

**Acceptance Criteria:**
- [ ] File compiles without errors
- [ ] All enums have display names and descriptions
- [ ] Constants are properly organized
- [ ] No hardcoded strings elsewhere in the app

---

### Task 1.2: Create UserConsent Model
**Priority:** P0
**Estimated Time:** 3 hours
**File:** `lib/core/models/user_consent.dart`

**Create new file with:**

```dart
// lib/core/models/user_consent.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/cookie_constants.dart';

part 'user_consent.freezed.dart';
part 'user_consent.g.dart';

@freezed
class UserConsent with _$UserConsent {
  const factory UserConsent({
    required String userId,
    required ConsentStatus status,
    required DateTime timestamp,
    required String version,
    required Map<CookieCategory, bool> categoryConsents,
    DateTime? expiresAt,
    String? ipAddress,
    String? userAgent,
    @Default([]) List<ConsentHistoryEntry> history,
  }) = _UserConsent;

  factory UserConsent.fromJson(Map<String, dynamic> json) =>
      _$UserConsentFromJson(json);

  // Factory for initial state (not asked)
  factory UserConsent.initial(String userId) => UserConsent(
        userId: userId,
        status: ConsentStatus.notAsked,
        timestamp: DateTime.now(),
        version: CookieConstants.currentConsentVersion,
        categoryConsents: {
          CookieCategory.essential: true, // Always true
          CookieCategory.functional: false,
          CookieCategory.analytics: false,
          CookieCategory.marketing: false,
        },
      );

  // Factory for accepting all
  factory UserConsent.acceptAll(String userId) => UserConsent(
        userId: userId,
        status: ConsentStatus.accepted,
        timestamp: DateTime.now(),
        version: CookieConstants.currentConsentVersion,
        expiresAt: DateTime.now().add(
          Duration(days: CookieConstants.consentValidityDays),
        ),
        categoryConsents: {
          CookieCategory.essential: true,
          CookieCategory.functional: true,
          CookieCategory.analytics: true,
          CookieCategory.marketing: true,
        },
      );

  // Factory for essential only
  factory UserConsent.essentialOnly(String userId) => UserConsent(
        userId: userId,
        status: ConsentStatus.customized,
        timestamp: DateTime.now(),
        version: CookieConstants.currentConsentVersion,
        expiresAt: DateTime.now().add(
          Duration(days: CookieConstants.consentValidityDays),
        ),
        categoryConsents: {
          CookieCategory.essential: true,
          CookieCategory.functional: false,
          CookieCategory.analytics: false,
          CookieCategory.marketing: false,
        },
      );
}

const UserConsent._();

extension UserConsentX on UserConsent {
  /// Check if consent has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if user has given consent (any level)
  bool get hasConsented {
    return status == ConsentStatus.accepted ||
        status == ConsentStatus.customized;
  }

  /// Check if specific category is consented
  bool isCategoryConsented(CookieCategory category) {
    return categoryConsents[category] ?? false;
  }

  /// Check if specific data type can be collected
  bool canCollectDataType(CookieDataType dataType) {
    return isCategoryConsented(dataType.category);
  }

  /// Create updated consent with new categories
  UserConsent updateCategories(Map<CookieCategory, bool> newCategories) {
    return copyWith(
      categoryConsents: {
        CookieCategory.essential: true, // Always true
        ...newCategories,
      },
      timestamp: DateTime.now(),
      expiresAt: DateTime.now().add(
        Duration(days: CookieConstants.consentValidityDays),
      ),
      status: _determineStatus(newCategories),
    );
  }

  ConsentStatus _determineStatus(Map<CookieCategory, bool> categories) {
    final allAccepted = categories.entries
        .where((e) => e.key != CookieCategory.essential)
        .every((e) => e.value);

    if (allAccepted) return ConsentStatus.accepted;
    return ConsentStatus.customized;
  }

  /// Add history entry
  UserConsent addHistoryEntry(ConsentHistoryEntry entry) {
    return copyWith(
      history: [...history, entry],
    );
  }
}

@freezed
class ConsentHistoryEntry with _$ConsentHistoryEntry {
  const factory ConsentHistoryEntry({
    required DateTime timestamp,
    required ConsentStatus status,
    required Map<CookieCategory, bool> categoryConsents,
    String? action, // e.g., "user_updated", "auto_renewed", "admin_reset"
    String? ipAddress,
  }) = _ConsentHistoryEntry;

  factory ConsentHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ConsentHistoryEntryFromJson(json);
}
```

**Dependencies to add to `pubspec.yaml`:**
```yaml
dependencies:
  freezed_annotation: ^2.4.1

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

**Run code generation:**
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

**Acceptance Criteria:**
- [ ] Model compiles without errors
- [ ] Code generation runs successfully
- [ ] Factory constructors work correctly
- [ ] Extension methods function as expected
- [ ] All edge cases handled (null expiration, etc.)

---

### Task 1.3: Create CookieData Model
**Priority:** P0
**Estimated Time:** 2 hours
**File:** `lib/core/models/cookie_data.dart`

**Create new file with:**

```dart
// lib/core/models/cookie_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/cookie_constants.dart';

part 'cookie_data.freezed.dart';
part 'cookie_data.g.dart';

@freezed
class CookieData with _$CookieData {
  const factory CookieData({
    required String id,
    required String userId,
    required CookieDataType type,
    required DateTime timestamp,
    required Map<String, dynamic> data,
    @Default(false) bool isAnonymized,
    DateTime? expiresAt,
    String? sessionId,
  }) = _CookieData;

  factory CookieData.fromJson(Map<String, dynamic> json) =>
      _$CookieDataFromJson(json);

  const CookieData._();
}

extension CookieDataX on CookieData {
  /// Check if data has expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get category for this data type
  CookieCategory get category => type.category;

  /// Anonymize sensitive data
  CookieData anonymize() {
    if (isAnonymized) return this;

    final anonymizedData = Map<String, dynamic>.from(data);

    // Remove or hash sensitive fields
    anonymizedData.remove('email');
    anonymizedData.remove('name');
    anonymizedData.remove('ipAddress');
    anonymizedData.remove('exactLocation');

    // Hash user ID if present
    if (anonymizedData.containsKey('userId')) {
      anonymizedData['userId'] = _hashString(anonymizedData['userId']);
    }

    return copyWith(
      data: anonymizedData,
      isAnonymized: true,
    );
  }

  String _hashString(String input) {
    // Simple hash for demo - use crypto package in production
    return input.hashCode.toRadixString(16);
  }
}

@freezed
class SessionAnalytics with _$SessionAnalytics {
  const factory SessionAnalytics({
    required String sessionId,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    @Default([]) List<String> pagesVisited,
    @Default({}) Map<String, int> interactions,
    String? deviceType,
    String? browser,
    String? referrer,
    @Default(0) int totalDuration, // in seconds
  }) = _SessionAnalytics;

  factory SessionAnalytics.fromJson(Map<String, dynamic> json) =>
      _$SessionAnalyticsFromJson(json);

  const SessionAnalytics._();
}

extension SessionAnalyticsX on SessionAnalytics {
  /// Calculate session duration
  int get durationSeconds {
    if (endTime == null) {
      return DateTime.now().difference(startTime).inSeconds;
    }
    return endTime!.difference(startTime).inSeconds;
  }

  /// Check if session is active
  bool get isActive {
    if (endTime != null) return false;

    final lastActivity = DateTime.now().difference(startTime);
    return lastActivity.inMinutes <= CookieConstants.sessionTimeout;
  }

  /// Add page visit
  SessionAnalytics addPageVisit(String page) {
    return copyWith(
      pagesVisited: [...pagesVisited, page],
    );
  }

  /// Record interaction
  SessionAnalytics recordInteraction(String interactionType) {
    final newInteractions = Map<String, int>.from(interactions);
    newInteractions[interactionType] = (newInteractions[interactionType] ?? 0) + 1;

    return copyWith(interactions: newInteractions);
  }

  /// End session
  SessionAnalytics endSession() {
    return copyWith(
      endTime: DateTime.now(),
      totalDuration: durationSeconds,
    );
  }
}
```

**Run code generation again:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**Acceptance Criteria:**
- [ ] Model compiles without errors
- [ ] Anonymization logic works correctly
- [ ] Session tracking methods function properly
- [ ] All edge cases handled

---

## Phase 2: Services & Business Logic
**Duration:** Days 4-7 (4 days)
**Priority:** P1 (High)

### Task 2.1: Create ConsentService
**Priority:** P1
**Estimated Time:** 4 hours
**File:** `lib/core/services/consent_service.dart`

**Create new file with:**

```dart
// lib/core/services/consent_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_consent.dart';
import '../constants/cookie_constants.dart';

class ConsentService {
  final SharedPreferences _prefs;

  ConsentService(this._prefs);

  /// Get current user consent
  Future<UserConsent?> getUserConsent(String userId) async {
    final json = _prefs.getString('${CookieConstants.consentStatusKey}_$userId');
    if (json == null) return null;

    try {
      return UserConsent.fromJson(jsonDecode(json));
    } catch (e) {
      print('Error parsing consent: $e');
      return null;
    }
  }

  /// Save user consent
  Future<bool> saveUserConsent(UserConsent consent) async {
    try {
      final json = jsonEncode(consent.toJson());
      return await _prefs.setString(
        '${CookieConstants.consentStatusKey}_${consent.userId}',
        json,
      );
    } catch (e) {
      print('Error saving consent: $e');
      return false;
    }
  }

  /// Accept all cookies
  Future<bool> acceptAll(String userId) async {
    final consent = UserConsent.acceptAll(userId);
    return await saveUserConsent(consent);
  }

  /// Accept essential only
  Future<bool> acceptEssentialOnly(String userId) async {
    final consent = UserConsent.essentialOnly(userId);
    return await saveUserConsent(consent);
  }

  /// Update category consents
  Future<bool> updateConsent(
    String userId,
    Map<CookieCategory, bool> categories,
  ) async {
    final current = await getUserConsent(userId);
    if (current == null) {
      // Create new consent with custom categories
      final consent = UserConsent(
        userId: userId,
        status: ConsentStatus.customized,
        timestamp: DateTime.now(),
        version: CookieConstants.currentConsentVersion,
        categoryConsents: {
          CookieCategory.essential: true,
          ...categories,
        },
        expiresAt: DateTime.now().add(
          Duration(days: CookieConstants.consentValidityDays),
        ),
      );
      return await saveUserConsent(consent);
    }

    final updated = current.updateCategories(categories);
    return await saveUserConsent(updated);
  }

  /// Check if consent is needed
  Future<bool> needsConsent(String userId) async {
    final consent = await getUserConsent(userId);

    if (consent == null) return true;
    if (consent.status == ConsentStatus.notAsked) return true;
    if (consent.isExpired) return true;
    if (consent.version != CookieConstants.currentConsentVersion) return true;

    return false;
  }

  /// Check if specific category is consented
  Future<bool> isCategoryConsented(
    String userId,
    CookieCategory category,
  ) async {
    final consent = await getUserConsent(userId);
    if (consent == null) return false;

    return consent.isCategoryConsented(category);
  }

  /// Check if specific data type can be collected
  Future<bool> canCollectData(
    String userId,
    CookieDataType dataType,
  ) async {
    final consent = await getUserConsent(userId);
    if (consent == null) return false;

    return consent.canCollectDataType(dataType);
  }

  /// Revoke all consents (for user deletion)
  Future<bool> revokeConsent(String userId) async {
    try {
      return await _prefs.remove(
        '${CookieConstants.consentStatusKey}_$userId',
      );
    } catch (e) {
      print('Error revoking consent: $e');
      return false;
    }
  }

  /// Get consent statistics (for admin dashboard)
  Future<Map<String, dynamic>> getConsentStatistics() async {
    final keys = _prefs.getKeys();
    final consentKeys = keys.where(
      (k) => k.startsWith(CookieConstants.consentStatusKey),
    );

    int total = consentKeys.length;
    int accepted = 0;
    int customized = 0;
    int declined = 0;
    int expired = 0;

    Map<CookieCategory, int> categoryStats = {
      CookieCategory.essential: 0,
      CookieCategory.functional: 0,
      CookieCategory.analytics: 0,
      CookieCategory.marketing: 0,
    };

    for (final key in consentKeys) {
      final json = _prefs.getString(key);
      if (json == null) continue;

      try {
        final consent = UserConsent.fromJson(jsonDecode(json));

        if (consent.isExpired) {
          expired++;
        } else {
          switch (consent.status) {
            case ConsentStatus.accepted:
              accepted++;
              break;
            case ConsentStatus.customized:
              customized++;
              break;
            case ConsentStatus.declined:
              declined++;
              break;
            case ConsentStatus.notAsked:
              break;
          }
        }

        // Count category consents
        consent.categoryConsents.forEach((category, consented) {
          if (consented) {
            categoryStats[category] = (categoryStats[category] ?? 0) + 1;
          }
        });
      } catch (e) {
        print('Error parsing consent for stats: $e');
      }
    }

    return {
      'total': total,
      'accepted': accepted,
      'customized': customized,
      'declined': declined,
      'expired': expired,
      'categoryStats': categoryStats,
    };
  }
}
```

**Acceptance Criteria:**
- [ ] All CRUD operations work correctly
- [ ] Consent validation logic is accurate
- [ ] Statistics calculation is correct
- [ ] Error handling is robust
- [ ] No data loss on errors

---

### Task 2.2: Create CookieService
**Priority:** P1
**Estimated Time:** 5 hours
**File:** `lib/core/services/cookie_service.dart`

**Create new file with:**

```dart
// lib/core/services/cookie_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/cookie_data.dart';
import '../constants/cookie_constants.dart';
import 'consent_service.dart';

class CookieService {
  final SharedPreferences _prefs;
  final ConsentService _consentService;
  final _uuid = const Uuid();

  CookieService(this._prefs, this._consentService);

  /// Store cookie data if consent allows
  Future<bool> storeCookieData(CookieData data) async {
    // Check consent
    final canCollect = await _consentService.canCollectData(
      data.userId,
      data.type,
    );

    if (!canCollect && data.type.category != CookieCategory.essential) {
      print('Cannot store ${data.type} - no consent');
      return false;
    }

    try {
      // Get existing data
      final existing = await _getAllCookieData(data.userId);

      // Add new data
      existing.add(data);

      // Prune old data
      final pruned = _pruneOldData(existing);

      // Save
      final json = jsonEncode(pruned.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_${data.userId}',
        json,
      );
    } catch (e) {
      print('Error storing cookie data: $e');
      return false;
    }
  }

  /// Get all cookie data for a user
  Future<List<CookieData>> getCookieData(
    String userId, {
    CookieCategory? category,
    CookieDataType? type,
    DateTime? since,
  }) async {
    final all = await _getAllCookieData(userId);

    return all.where((data) {
      if (category != null && data.category != category) return false;
      if (type != null && data.type != type) return false;
      if (since != null && data.timestamp.isBefore(since)) return false;
      return true;
    }).toList();
  }

  Future<List<CookieData>> _getAllCookieData(String userId) async {
    final json = _prefs.getString(
      '${CookieConstants.localCookieDataKey}_$userId',
    );

    if (json == null) return [];

    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((e) => CookieData.fromJson(e)).toList();
    } catch (e) {
      print('Error loading cookie data: $e');
      return [];
    }
  }

  /// Delete all cookie data for a user
  Future<bool> deleteUserCookieData(String userId) async {
    try {
      return await _prefs.remove(
        '${CookieConstants.localCookieDataKey}_$userId',
      );
    } catch (e) {
      print('Error deleting cookie data: $e');
      return false;
    }
  }

  /// Delete cookie data by category
  Future<bool> deleteCategoryData(
    String userId,
    CookieCategory category,
  ) async {
    try {
      final all = await _getAllCookieData(userId);
      final filtered = all.where((data) => data.category != category).toList();

      final json = jsonEncode(filtered.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_$userId',
        json,
      );
    } catch (e) {
      print('Error deleting category data: $e');
      return false;
    }
  }

  /// Anonymize all cookie data for a user
  Future<bool> anonymizeUserData(String userId) async {
    try {
      final all = await _getAllCookieData(userId);
      final anonymized = all.map((data) => data.anonymize()).toList();

      final json = jsonEncode(anonymized.map((e) => e.toJson()).toList());
      return await _prefs.setString(
        '${CookieConstants.localCookieDataKey}_$userId',
        json,
      );
    } catch (e) {
      print('Error anonymizing data: $e');
      return false;
    }
  }

  /// Prune data older than max age
  List<CookieData> _pruneOldData(List<CookieData> data) {
    final cutoff = DateTime.now().subtract(
      Duration(days: CookieConstants.maxCookieDataAge),
    );

    return data.where((d) => d.timestamp.isAfter(cutoff)).toList();
  }

  /// Export user data (GDPR requirement)
  Future<Map<String, dynamic>> exportUserData(String userId) async {
    final consent = await _consentService.getUserConsent(userId);
    final cookieData = await getCookieData(userId);

    return {
      'userId': userId,
      'exportDate': DateTime.now().toIso8601String(),
      'consent': consent?.toJson(),
      'cookieData': cookieData.map((e) => e.toJson()).toList(),
      'dataCount': cookieData.length,
    };
  }

  /// Get storage size for user
  Future<int> getUserDataSize(String userId) async {
    final data = await _getAllCookieData(userId);
    final json = jsonEncode(data.map((e) => e.toJson()).toList());
    return json.length; // Size in bytes
  }
}
```

**Add to `pubspec.yaml`:**
```yaml
dependencies:
  uuid: ^4.2.1
```

**Acceptance Criteria:**
- [ ] Data storage respects consent
- [ ] Data pruning works correctly
- [ ] Anonymization removes sensitive fields
- [ ] Export function includes all data
- [ ] Category-based deletion works

---

### Task 2.3: Create AnalyticsService
**Priority:** P1
**Estimated Time:** 4 hours
**File:** `lib/core/services/analytics_service.dart`

**Create new file with:**

```dart
// lib/core/services/analytics_service.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/cookie_data.dart';
import '../constants/cookie_constants.dart';
import 'cookie_service.dart';
import 'consent_service.dart';

class AnalyticsService {
  final SharedPreferences _prefs;
  final CookieService _cookieService;
  final ConsentService _consentService;
  final _uuid = const Uuid();

  String? _currentSessionId;
  SessionAnalytics? _currentSession;

  AnalyticsService(this._prefs, this._cookieService, this._consentService);

  /// Start tracking session
  Future<void> startSession(String userId, {
    String? deviceType,
    String? browser,
    String? referrer,
  }) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.pageView,
    );

    if (!canTrack) {
      print('Cannot track session - no analytics consent');
      return;
    }

    _currentSessionId = _uuid.v4();
    _currentSession = SessionAnalytics(
      sessionId: _currentSessionId!,
      userId: userId,
      startTime: DateTime.now(),
      deviceType: deviceType,
      browser: browser,
      referrer: referrer,
    );

    await _saveSession();
  }

  /// Track page view
  Future<void> trackPageView(String userId, String pageName) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.pageView,
    );

    if (!canTrack) return;

    // Store as cookie data
    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.pageView,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'page': pageName,
        'sessionId': _currentSessionId,
      },
    );

    await _cookieService.storeCookieData(data);

    // Update session
    if (_currentSession != null) {
      _currentSession = _currentSession!.addPageVisit(pageName);
      await _saveSession();
    }
  }

  /// Track click event
  Future<void> trackClick(
    String userId,
    String elementType,
    String elementId,
  ) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.clickEvent,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.clickEvent,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'elementType': elementType,
        'elementId': elementId,
        'page': 'current_page', // Should be passed from context
      },
    );

    await _cookieService.storeCookieData(data);

    // Update session
    if (_currentSession != null) {
      _currentSession = _currentSession!.recordInteraction(elementType);
      await _saveSession();
    }
  }

  /// Track search
  Future<void> trackSearch(String userId, String query) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.searchQuery,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.searchQuery,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'query': query,
        'resultsCount': 0, // Should be passed
      },
    );

    await _cookieService.storeCookieData(data);
  }

  /// Track performance metric
  Future<void> trackPerformance(
    String userId,
    String metricName,
    double value,
  ) async {
    final canTrack = await _consentService.canCollectData(
      userId,
      CookieDataType.performanceMetric,
    );

    if (!canTrack) return;

    final data = CookieData(
      id: _uuid.v4(),
      userId: userId,
      type: CookieDataType.performanceMetric,
      timestamp: DateTime.now(),
      sessionId: _currentSessionId,
      data: {
        'metric': metricName,
        'value': value,
        'unit': 'ms',
      },
    );

    await _cookieService.storeCookieData(data);
  }

  /// End session
  Future<void> endSession() async {
    if (_currentSession == null) return;

    _currentSession = _currentSession!.endSession();
    await _saveSession();

    _currentSessionId = null;
    _currentSession = null;
  }

  /// Get current session
  SessionAnalytics? getCurrentSession() => _currentSession;

  /// Get user sessions
  Future<List<SessionAnalytics>> getUserSessions(String userId) async {
    final json = _prefs.getString('${CookieConstants.sessionDataKey}_$userId');
    if (json == null) return [];

    try {
      final List<dynamic> list = jsonDecode(json);
      return list.map((e) => SessionAnalytics.fromJson(e)).toList();
    } catch (e) {
      print('Error loading sessions: $e');
      return [];
    }
  }

  Future<void> _saveSession() async {
    if (_currentSession == null) return;

    try {
      final existing = await getUserSessions(_currentSession!.userId);

      // Update or add current session
      final index = existing.indexWhere(
        (s) => s.sessionId == _currentSession!.sessionId,
      );

      if (index >= 0) {
        existing[index] = _currentSession!;
      } else {
        existing.add(_currentSession!);
      }

      final json = jsonEncode(existing.map((e) => e.toJson()).toList());
      await _prefs.setString(
        '${CookieConstants.sessionDataKey}_${_currentSession!.userId}',
        json,
      );
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  /// Get analytics summary for user
  Future<Map<String, dynamic>> getUserAnalyticsSummary(String userId) async {
    final sessions = await getUserSessions(userId);
    final cookieData = await _cookieService.getCookieData(
      userId,
      category: CookieCategory.analytics,
    );

    final pageViews = cookieData
        .where((d) => d.type == CookieDataType.pageView)
        .length;

    final clicks = cookieData
        .where((d) => d.type == CookieDataType.clickEvent)
        .length;

    final totalDuration = sessions.fold<int>(
      0,
      (sum, s) => sum + s.durationSeconds,
    );

    return {
      'totalSessions': sessions.length,
      'totalPageViews': pageViews,
      'totalClicks': clicks,
      'totalDurationSeconds': totalDuration,
      'averageSessionDuration': sessions.isEmpty
          ? 0
          : totalDuration / sessions.length,
    };
  }
}
```

**Acceptance Criteria:**
- [ ] Session tracking works correctly
- [ ] All events respect consent
- [ ] Session data persists correctly
- [ ] Analytics summary calculates accurately
- [ ] No tracking when consent is missing

---

### Task 2.4: Create Riverpod Providers
**Priority:** P1
**Estimated Time:** 2 hours
**File:** `lib/core/providers/cookie_providers.dart`

**Create new file with:**

```dart
// lib/core/providers/cookie_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/consent_service.dart';
import '../services/cookie_service.dart';
import '../services/analytics_service.dart';
import '../models/user_consent.dart';

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

/// ConsentService provider
final consentServiceProvider = Provider<ConsentService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ConsentService(prefs);
});

/// CookieService provider
final cookieServiceProvider = Provider<CookieService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final consentService = ref.watch(consentServiceProvider);
  return CookieService(prefs, consentService);
});

/// AnalyticsService provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final cookieService = ref.watch(cookieServiceProvider);
  final consentService = ref.watch(consentServiceProvider);
  return AnalyticsService(prefs, cookieService, consentService);
});

/// Current user consent provider
final userConsentProvider = FutureProvider.family<UserConsent?, String>((ref, userId) async {
  final service = ref.watch(consentServiceProvider);
  return await service.getUserConsent(userId);
});

/// Consent needed check provider
final consentNeededProvider = FutureProvider.family<bool, String>((ref, userId) async {
  final service = ref.watch(consentServiceProvider);
  return await service.needsConsent(userId);
});

/// Consent statistics provider (for admin dashboard)
final consentStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(consentServiceProvider);
  return await service.getConsentStatistics();
});

/// User analytics summary provider
final userAnalyticsSummaryProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, userId) async {
    final service = ref.watch(analyticsServiceProvider);
    return await service.getUserAnalyticsSummary(userId);
  },
);
```

**Acceptance Criteria:**
- [ ] All providers compile correctly
- [ ] Dependencies are properly injected
- [ ] No circular dependencies
- [ ] Providers can be used in widgets

---

## Phase 3: User-Facing UI
**Duration:** Days 8-15 (8 days)
**Priority:** P2 (Medium)

### Task 3.1: Create Cookie Banner
**Priority:** P2
**Estimated Time:** 6 hours
**File:** `lib/features/shared/cookies/presentation/cookie_banner.dart`

**Create new file with:**

```dart
// lib/features/shared/cookies/presentation/cookie_banner.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/theme/app_colors.dart';
import 'cookie_preferences_modal.dart';

class CookieBanner extends ConsumerStatefulWidget {
  final String userId;

  const CookieBanner({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<CookieBanner> createState() => _CookieBannerState();
}

class _CookieBannerState extends ConsumerState<CookieBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _checkIfNeedsConsent();
  }

  Future<void> _checkIfNeedsConsent() async {
    final needsConsent = await ref.read(
      consentNeededProvider(widget.userId).future,
    );

    if (needsConsent && mounted) {
      setState(() => _isVisible = true);
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _acceptAll() async {
    final service = ref.read(consentServiceProvider);
    final success = await service.acceptAll(widget.userId);

    if (success && mounted) {
      await _animationController.reverse();
      setState(() => _isVisible = false);

      // Start analytics session
      final analytics = ref.read(analyticsServiceProvider);
      await analytics.startSession(widget.userId);
    }
  }

  Future<void> _acceptEssential() async {
    final service = ref.read(consentServiceProvider);
    final success = await service.acceptEssentialOnly(widget.userId);

    if (success && mounted) {
      await _animationController.reverse();
      setState(() => _isVisible = false);
    }
  }

  void _showPreferences() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CookiePreferencesModal(userId: widget.userId),
    ).then((saved) {
      if (saved == true && mounted) {
        _animationController.reverse();
        setState(() => _isVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.cookie,
                    color: AppColors.primary,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'We use cookies',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'We use cookies to enhance your experience, analyze site usage, '
                'and provide personalized content. By clicking "Accept All", '
                'you consent to our use of cookies.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: _acceptAll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Accept All'),
                  ),
                  OutlinedButton(
                    onPressed: _acceptEssential,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Essential Only'),
                  ),
                  TextButton(
                    onPressed: _showPreferences,
                    child: const Text('Customize'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to privacy policy
                    },
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Acceptance Criteria:**
- [ ] Banner appears when consent is needed
- [ ] Banner slides in smoothly
- [ ] All buttons work correctly
- [ ] Banner dismisses after consent
- [ ] Responsive on mobile and desktop

---

### Task 3.2: Create Cookie Preferences Modal
**Priority:** P2
**Estimated Time:** 8 hours
**File:** `lib/features/shared/cookies/presentation/cookie_preferences_modal.dart`

**Create new file with:**

```dart
// lib/features/shared/cookies/presentation/cookie_preferences_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/theme/app_colors.dart';

class CookiePreferencesModal extends ConsumerStatefulWidget {
  final String userId;

  const CookiePreferencesModal({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<CookiePreferencesModal> createState() =>
      _CookiePreferencesModalState();
}

class _CookiePreferencesModalState
    extends ConsumerState<CookiePreferencesModal> {
  final Map<CookieCategory, bool> _selections = {
    CookieCategory.essential: true,
    CookieCategory.functional: true,
    CookieCategory.analytics: true,
    CookieCategory.marketing: true,
  };

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentConsent();
  }

  Future<void> _loadCurrentConsent() async {
    final consent = await ref.read(
      userConsentProvider(widget.userId).future,
    );

    if (consent != null && mounted) {
      setState(() {
        _selections.addAll(consent.categoryConsents);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    final service = ref.read(consentServiceProvider);
    final success = await service.updateConsent(widget.userId, _selections);

    if (mounted) {
      if (success) {
        // Start/stop analytics based on selection
        if (_selections[CookieCategory.analytics] == true) {
          final analytics = ref.read(analyticsServiceProvider);
          await analytics.startSession(widget.userId);
        }

        Navigator.of(context).pop(true);
      } else {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preferences. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.tune, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Cookie Preferences',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Content
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customize your cookie preferences. Essential cookies are always enabled.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    ...CookieCategory.values.map((category) {
                      final isEssential = category == CookieCategory.essential;
                      return _CategoryCard(
                        category: category,
                        isEnabled: _selections[category] ?? false,
                        isLocked: isEssential,
                        onChanged: isEssential
                            ? null
                            : (value) {
                                setState(() {
                                  _selections[category] = value;
                                });
                              },
                      );
                    }),

                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSaving ? null : () {
                              setState(() {
                                _selections[CookieCategory.functional] = false;
                                _selections[CookieCategory.analytics] = false;
                                _selections[CookieCategory.marketing] = false;
                              });
                            },
                            child: const Text('Reject All'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _savePreferences,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Save Preferences'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CookieCategory category;
  final bool isEnabled;
  final bool isLocked;
  final ValueChanged<bool>? onChanged;

  const _CategoryCard({
    required this.category,
    required this.isEnabled,
    required this.isLocked,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  category.icon,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Always Active',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                else
                  Switch(
                    value: isEnabled,
                    onChanged: onChanged,
                    activeColor: AppColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Acceptance Criteria:**
- [ ] Modal loads current consent
- [ ] All categories can be toggled (except essential)
- [ ] Save button works correctly
- [ ] Reject all button works
- [ ] UI is responsive and accessible

---

### Task 3.3: Create Cookie Settings Page
**Priority:** P2
**Estimated Time:** 4 hours
**File:** `lib/features/shared/cookies/presentation/cookie_settings_screen.dart`

**Create new file with:**

```dart
// lib/features/shared/cookies/presentation/cookie_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/theme/app_colors.dart';
import 'cookie_preferences_modal.dart';

class CookieSettingsScreen extends ConsumerWidget {
  final String userId;

  const CookieSettingsScreen({
    required this.userId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(userConsentProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: consentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading consent: $error'),
        ),
        data: (consent) {
          if (consent == null) {
            return const Center(child: Text('No consent data'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status card
                Card(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          consent.hasConsented
                              ? Icons.check_circle
                              : Icons.info,
                          color: AppColors.primary,
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                consent.hasConsented
                                    ? 'Consent Active'
                                    : 'No Consent Given',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Updated: ${_formatDate(consent.timestamp)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (consent.expiresAt != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Expires: ${_formatDate(consent.expiresAt!)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Current preferences
                Text(
                  'Current Preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                ...consent.categoryConsents.entries.map((entry) {
                  final category = entry.key;
                  final enabled = entry.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        category.icon,
                        color: enabled ? AppColors.primary : Colors.grey,
                      ),
                      title: Text(category.displayName),
                      subtitle: Text(category.description),
                      trailing: Icon(
                        enabled ? Icons.check_circle : Icons.cancel,
                        color: enabled ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 24),

                // Actions
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CookiePreferencesModal(
                          userId: userId,
                        ),
                      ).then((_) {
                        // Refresh consent data
                        ref.invalidate(userConsentProvider(userId));
                      });
                    },
                    icon: const Icon(Icons.tune),
                    label: const Text('Change Preferences'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _exportData(context, ref),
                    icon: const Icon(Icons.download),
                    label: const Text('Export My Data'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteData(context, ref),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete My Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Info section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              'About Cookies',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cookies help us provide you with a better experience. '
                          'You can change your preferences at any time. '
                          'Essential cookies are always active for security and functionality.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            // Navigate to privacy policy
                            context.push('/privacy-policy');
                          },
                          child: const Text('Read Privacy Policy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This will create a file with all your cookie and consent data. '
          'The file will be saved to your downloads folder.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final service = ref.read(cookieServiceProvider);
      final data = await service.exportUserData(userId);

      // In production, trigger file download
      // For now, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data exported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _deleteData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Data'),
        content: const Text(
          'This will permanently delete all your cookie data. '
          'Essential cookies required for the app to function will remain. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final cookieService = ref.read(cookieServiceProvider);

      // Delete functional, analytics, and marketing data
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.functional,
      );
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.analytics,
      );
      await cookieService.deleteCategoryData(
        userId,
        CookieCategory.marketing,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh consent
      ref.invalidate(userConsentProvider(userId));
    }
  }
}
```

**Acceptance Criteria:**
- [ ] Screen displays current consent status
- [ ] All buttons work correctly
- [ ] Export data functionality works
- [ ] Delete data shows confirmation
- [ ] Screen updates after preference changes

---

### Task 3.4: Integrate Cookie Banner into App
**Priority:** P2
**Estimated Time:** 2 hours
**Files:**
- `lib/main.dart`
- `lib/routing/app_router.dart`

**Update `main.dart`:**

```dart
// Add to main.dart

import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/cookie_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}
```

**Add route to `app_router.dart`:**

```dart
// Add to app_router.dart in the routes list

GoRoute(
  path: '/cookie-settings',
  name: 'cookie-settings',
  builder: (context, state) {
    final userId = state.uri.queryParameters['userId'] ?? '';
    return CookieSettingsScreen(userId: userId);
  },
),
```

**Add banner to main scaffold (example for student dashboard):**

```dart
// In student_dashboard_screen.dart or main app scaffold

@override
Widget build(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authStateProvider);

  return Scaffold(
    body: Stack(
      children: [
        // Your normal content
        _buildDashboardContent(),

        // Cookie banner overlay
        if (authState.user != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CookieBanner(userId: authState.user!.id),
          ),
      ],
    ),
  );
}
```

**Acceptance Criteria:**
- [ ] Banner appears on app launch
- [ ] Banner only shows when consent needed
- [ ] Route to settings works
- [ ] No performance impact
- [ ] Works across all user roles

---

## Phase 4: Admin Dashboard
**Duration:** Days 16-23 (8 days)
**Priority:** P3 (Low)

### Task 4.1: Create Consent Analytics Dashboard
**Priority:** P3
**Estimated Time:** 8 hours
**File:** `lib/features/admin/cookies/presentation/consent_analytics_screen.dart`

**Create new file with:**

```dart
// lib/features/admin/cookies/presentation/consent_analytics_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../admin/shared/widgets/admin_shell.dart';

class ConsentAnalyticsScreen extends ConsumerWidget {
  const ConsentAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(consentStatisticsProvider);

    return AdminShell(
      child: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Cookie Consent Analytics',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Overview of user cookie consent preferences',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),

              // Summary cards
              _buildSummaryCards(stats),

              const SizedBox(height: 32),

              // Charts
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Consent status pie chart
                  Expanded(
                    child: _buildConsentStatusChart(stats),
                  ),
                  const SizedBox(width: 24),
                  // Category consent bar chart
                  Expanded(
                    child: _buildCategoryChart(stats),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Detailed breakdown
              _buildDetailedBreakdown(stats),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> stats) {
    final total = stats['total'] as int;
    final accepted = stats['accepted'] as int;
    final customized = stats['customized'] as int;
    final declined = stats['declined'] as int;
    final expired = stats['expired'] as int;

    return Row(
      children: [
        _SummaryCard(
          title: 'Total Users',
          value: total.toString(),
          icon: Icons.people,
          color: AppColors.primary,
        ),
        const SizedBox(width: 16),
        _SummaryCard(
          title: 'Accepted All',
          value: accepted.toString(),
          subtitle: '${_percentage(accepted, total)}%',
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 16),
        _SummaryCard(
          title: 'Customized',
          value: customized.toString(),
          subtitle: '${_percentage(customized, total)}%',
          icon: Icons.tune,
          color: Colors.orange,
        ),
        const SizedBox(width: 16),
        _SummaryCard(
          title: 'Expired',
          value: expired.toString(),
          subtitle: '${_percentage(expired, total)}%',
          icon: Icons.warning,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildConsentStatusChart(Map<String, dynamic> stats) {
    final total = stats['total'] as int;
    final accepted = stats['accepted'] as int;
    final customized = stats['customized'] as int;
    final declined = stats['declined'] as int;

    if (total == 0) {
      return Card(
        child: Container(
          height: 300,
          alignment: Alignment.center,
          child: const Text('No data available'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consent Status Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: accepted.toDouble(),
                      title: 'Accepted\n$accepted',
                      color: Colors.green,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: customized.toDouble(),
                      title: 'Custom\n$customized',
                      color: Colors.orange,
                      radius: 100,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (declined > 0)
                      PieChartSectionData(
                        value: declined.toDouble(),
                        title: 'Declined\n$declined',
                        color: Colors.red,
                        radius: 100,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(Map<String, dynamic> stats) {
    final categoryStats = stats['categoryStats'] as Map<CookieCategory, int>;
    final total = stats['total'] as int;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Category Consent Rates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...CookieCategory.values.map((category) {
              final count = categoryStats[category] ?? 0;
              final percentage = _percentage(count, total);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(category.icon, size: 20),
                            const SizedBox(width: 8),
                            Text(category.displayName),
                          ],
                        ),
                        Text(
                          '$percentage% ($count)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(
                        _getCategoryColor(category),
                      ),
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedBreakdown(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Count')),
                DataColumn(label: Text('Percentage')),
              ],
              rows: [
                _buildDataRow('Accepted All', stats['accepted'], stats['total']),
                _buildDataRow('Customized', stats['customized'], stats['total']),
                _buildDataRow('Declined', stats['declined'], stats['total']),
                _buildDataRow('Expired', stats['expired'], stats['total']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String label, int count, int total) {
    return DataRow(
      cells: [
        DataCell(Text(label)),
        DataCell(Text(count.toString())),
        DataCell(Text('${_percentage(count, total)}%')),
      ],
    );
  }

  int _percentage(int value, int total) {
    if (total == 0) return 0;
    return ((value / total) * 100).round();
  }

  Color _getCategoryColor(CookieCategory category) {
    switch (category) {
      case CookieCategory.essential:
        return Colors.blue;
      case CookieCategory.functional:
        return Colors.purple;
      case CookieCategory.analytics:
        return Colors.orange;
      case CookieCategory.marketing:
        return Colors.green;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: color, size: 32),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

**Add dependency to `pubspec.yaml`:**
```yaml
dependencies:
  fl_chart: ^0.66.0
```

**Acceptance Criteria:**
- [ ] Dashboard shows accurate statistics
- [ ] Charts render correctly
- [ ] Data updates in real-time
- [ ] Responsive layout
- [ ] No performance issues

---

### Task 4.2: Create User Cookie Data Viewer
**Priority:** P3
**Estimated Time:** 6 hours
**File:** `lib/features/admin/cookies/presentation/user_cookie_viewer_screen.dart`

**Create new file with:**

```dart
// lib/features/admin/cookies/presentation/user_cookie_viewer_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cookie_providers.dart';
import '../../../../core/constants/cookie_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../admin/shared/widgets/admin_shell.dart';
import 'dart:convert';

class UserCookieViewerScreen extends ConsumerStatefulWidget {
  final String userId;

  const UserCookieViewerScreen({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<UserCookieViewerScreen> createState() =>
      _UserCookieViewerScreenState();
}

class _UserCookieViewerScreenState
    extends ConsumerState<UserCookieViewerScreen> {
  CookieCategory? _selectedCategory;
  bool _showAnonymized = false;

  @override
  Widget build(BuildContext context) {
    final consentAsync = ref.watch(userConsentProvider(widget.userId));
    final analyticsAsync = ref.watch(
      userAnalyticsSummaryProvider(widget.userId),
    );

    return AdminShell(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with back button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Cookie Data',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'User ID: ${widget.userId}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Export button
                ElevatedButton.icon(
                  onPressed: () => _exportUserData(),
                  icon: const Icon(Icons.download),
                  label: const Text('Export Data'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Consent status
            consentAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (consent) => _buildConsentSection(consent),
            ),

            const SizedBox(height: 32),

            // Analytics summary
            analyticsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
              data: (summary) => _buildAnalyticsSummary(summary),
            ),

            const SizedBox(height: 32),

            // Category filter
            _buildCategoryFilter(),

            const SizedBox(height: 16),

            // Cookie data table
            _buildCookieDataTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentSection(consent) {
    if (consent == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 48),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No Consent Data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This user has not provided cookie consent yet.',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  consent.hasConsented ? Icons.check_circle : Icons.cancel,
                  color: consent.hasConsented ? Colors.green : Colors.red,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consent Status: ${consent.status.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${_formatDate(consent.timestamp)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (consent.expiresAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Expires: ${_formatDate(consent.expiresAt!)} ${consent.isExpired ? "(EXPIRED)" : ""}',
                          style: TextStyle(
                            color: consent.isExpired ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              'Category Permissions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: consent.categoryConsents.entries.map((entry) {
                final category = entry.key;
                final enabled = entry.value;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: enabled
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: enabled ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        category.icon,
                        color: enabled ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        category.displayName,
                        style: TextStyle(
                          color: enabled ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        enabled ? Icons.check : Icons.close,
                        color: enabled ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSummary(Map<String, dynamic> summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Analytics Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildSummaryItem(
                  'Total Sessions',
                  summary['totalSessions'].toString(),
                  Icons.access_time,
                ),
                const SizedBox(width: 24),
                _buildSummaryItem(
                  'Page Views',
                  summary['totalPageViews'].toString(),
                  Icons.pageview,
                ),
                const SizedBox(width: 24),
                _buildSummaryItem(
                  'Total Clicks',
                  summary['totalClicks'].toString(),
                  Icons.touch_app,
                ),
                const SizedBox(width: 24),
                _buildSummaryItem(
                  'Avg Session (s)',
                  summary['averageSessionDuration'].toStringAsFixed(0),
                  Icons.timer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Text(
              'Filter by Category:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Wrap(
                spacing: 12,
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = null);
                    },
                  ),
                  ...CookieCategory.values.map((category) {
                    return FilterChip(
                      label: Text(category.displayName),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Row(
              children: [
                const Text('Show Anonymized:'),
                const SizedBox(width: 8),
                Switch(
                  value: _showAnonymized,
                  onChanged: (value) {
                    setState(() => _showAnonymized = value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookieDataTable() {
    // This is a placeholder - in real implementation,
    // you'd fetch actual cookie data from the service
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cookie Data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Cookie data table would be displayed here with filtering by category.',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportUserData() async {
    final service = ref.read(cookieServiceProvider);
    final data = await service.exportUserData(widget.userId);

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported ${data['dataCount']} records'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}
```

**Acceptance Criteria:**
- [ ] Shows user consent status
- [ ] Displays analytics summary
- [ ] Category filtering works
- [ ] Export functionality works
- [ ] Responsive layout

---

### Task 4.3: Add Cookie Routes to Admin Navigation
**Priority:** P3
**Estimated Time:** 2 hours
**Files:**
- `lib/features/admin/shared/widgets/admin_sidebar.dart`
- `lib/routing/app_router.dart`

**Add to admin_sidebar.dart (in appropriate admin role navigation):**

```dart
// Add to Super Admin navigation items
AdminNavigationItem(
  icon: Icons.cookie,
  label: 'Cookie Management',
  route: '/admin/cookies/analytics',
),
```

**Add routes to app_router.dart:**

```dart
// Add to admin routes
GoRoute(
  path: '/admin/cookies/analytics',
  name: 'admin-cookie-analytics',
  builder: (context, state) => const ConsentAnalyticsScreen(),
),
GoRoute(
  path: '/admin/cookies/user/:userId',
  name: 'admin-cookie-user-viewer',
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return UserCookieViewerScreen(userId: userId);
  },
),
```

**Acceptance Criteria:**
- [ ] Routes appear in admin sidebar
- [ ] Navigation works correctly
- [ ] Proper role-based access control
- [ ] Deep linking works

---

## Phase 5: Backend Integration
**Duration:** Days 24-28 (5 days)
**Priority:** P4 (Polish)

### Task 5.1: Design Firestore Structure
**Priority:** P4
**Estimated Time:** 2 hours
**File:** `FIREBASE_STRUCTURE.md` (documentation)

**Create Firebase collections:**

```
users/{userId}/
├── consent/
│   └── current (document)
│       ├── status: string
│       ├── timestamp: timestamp
│       ├── version: string
│       ├── expiresAt: timestamp
│       ├── categoryConsents: map
│       └── ipAddress: string
│
├── consentHistory/ (subcollection)
│   └── {historyId} (document)
│       ├── timestamp: timestamp
│       ├── status: string
│       ├── categoryConsents: map
│       └── action: string
│
└── cookieData/ (subcollection)
    └── {dataId} (document)
        ├── type: string
        ├── category: string
        ├── timestamp: timestamp
        ├── data: map
        ├── isAnonymized: boolean
        └── sessionId: string

sessions/{sessionId}/ (root collection)
└── (document)
    ├── userId: string
    ├── startTime: timestamp
    ├── endTime: timestamp
    ├── pagesVisited: array
    ├── interactions: map
    ├── deviceType: string
    └── totalDuration: number
```

**Acceptance Criteria:**
- [ ] Structure documented
- [ ] Indexes planned
- [ ] Security rules drafted
- [ ] Query patterns identified

---

### Task 5.2: Implement Firebase Services
**Priority:** P4
**Estimated Time:** 6 hours
**File:** `lib/core/services/firebase_cookie_service.dart`

**This is a placeholder for Firebase integration - implement when backend is ready**

**Acceptance Criteria:**
- [ ] Firebase SDK integrated
- [ ] CRUD operations work
- [ ] Real-time updates function
- [ ] Error handling robust

---

## Phase 6: Testing & Polish
**Duration:** Days 29-30 (2 days)
**Priority:** P4 (Polish)

### Task 6.1: Write Unit Tests
**Priority:** P4
**Estimated Time:** 6 hours

**Test files to create:**
- `test/core/models/user_consent_test.dart`
- `test/core/services/consent_service_test.dart`
- `test/core/services/cookie_service_test.dart`
- `test/core/services/analytics_service_test.dart`

**Acceptance Criteria:**
- [ ] 80%+ code coverage
- [ ] All models tested
- [ ] All services tested
- [ ] Edge cases covered

---

### Task 6.2: Integration Testing
**Priority:** P4
**Estimated Time:** 4 hours

**Test scenarios:**
1. User sees banner on first visit
2. User accepts all cookies
3. User customizes preferences
4. User exports data
5. User deletes data
6. Admin views analytics
7. Admin views user data

**Acceptance Criteria:**
- [ ] All user flows work
- [ ] All admin flows work
- [ ] No console errors
- [ ] Performance acceptable

---

### Task 6.3: GDPR Compliance Check
**Priority:** P4
**Estimated Time:** 2 hours

**Checklist:**
- [ ] Consent is asked before non-essential cookies
- [ ] Essential-only option available
- [ ] Clear cookie descriptions
- [ ] Data export works
- [ ] Data deletion works
- [ ] Consent can be withdrawn
- [ ] Privacy policy linked
- [ ] Consent expires after 1 year

---

## Summary

### Total Implementation Time: 30 days

### Priority Breakdown:
- **P0 (Critical)**: 3 days - Foundation & models
- **P1 (High)**: 4 days - Services & business logic
- **P2 (Medium)**: 8 days - User-facing UI
- **P3 (Low)**: 8 days - Admin dashboard
- **P4 (Polish)**: 7 days - Backend & testing

### Dependencies Required:
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  uuid: ^4.2.1
  fl_chart: ^0.66.0

dev_dependencies:
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

### Files to Create: 30+
### Files to Modify: 5+

---

**Next Step:** Start with Phase 1, Task 1.1 - Create Constants & Enums

This guide provides a complete, step-by-step implementation plan that any software engineer can follow to implement the cookie consent system from scratch.
