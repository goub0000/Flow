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

  const UserConsent._();

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
