// lib/core/constants/cookie_constants.dart

import 'package:flutter/material.dart';

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
