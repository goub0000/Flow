import 'package:flutter/foundation.dart' show kDebugMode;
import '../constants/user_roles.dart';

/// User model representing a user in the Flow EdTech platform
class UserModel {
  final String id;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole activeRole;
  final List<UserRole> availableRoles;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    required this.activeRole,
    required this.availableRoles,
    required this.createdAt,
    this.lastLoginAt,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.metadata,
  });

  /// Check if user can switch to a specific role
  bool canSwitchTo(UserRole role) => availableRoles.contains(role);

  /// Check if user has multiple roles
  bool get hasMultipleRoles => availableRoles.length > 1;

  /// Alias for photoUrl for compatibility
  String? get photoURL => photoUrl;

  /// Alias for displayName for compatibility
  String? get fullName => displayName;

  /// Get user's initials for avatar
  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email.substring(0, 2).toUpperCase();
    }
    final parts = displayName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName!.substring(0, 2).toUpperCase();
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    UserRole? activeRole,
    List<UserRole>? availableRoles,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      activeRole: activeRole ?? this.activeRole,
      availableRoles: availableRoles ?? this.availableRoles,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to JSON for backend API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'activeRole': UserRoleHelper.getRoleName(activeRole),
      'availableRoles': availableRoles.map((r) => UserRoleHelper.getRoleName(r)).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'metadata': metadata,
    };
  }

  /// Create from JSON from backend API
  /// Handles null values gracefully with sensible defaults
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safe extraction with null checks
    final id = json['id']?.toString() ?? '';
    final email = json['email']?.toString() ?? '';

    // Handle active_role with fallback - check multiple possible keys
    String activeRoleStr = json['active_role']?.toString() ??
        json['activeRole']?.toString() ??
        json['role']?.toString() ??
        'student';

    // Handle available_roles with fallback
    List<String> availableRolesStrs;
    final rolesData = json['available_roles'];
    if (rolesData is List && rolesData.isNotEmpty) {
      availableRolesStrs = rolesData.map((r) => r.toString()).toList();
    } else {
      availableRolesStrs = [activeRoleStr];
    }

    // Handle created_at with fallback
    DateTime createdAt;
    final createdAtStr = json['created_at']?.toString();
    if (createdAtStr != null && createdAtStr.isNotEmpty) {
      try {
        createdAt = DateTime.parse(createdAtStr);
      } catch (_) {
        createdAt = DateTime.now();
      }
    } else {
      createdAt = DateTime.now();
    }

    // Handle last_login_at
    DateTime? lastLoginAt;
    final lastLoginStr = json['last_login_at']?.toString();
    if (lastLoginStr != null && lastLoginStr.isNotEmpty) {
      try {
        lastLoginAt = DateTime.parse(lastLoginStr);
      } catch (_) {
        lastLoginAt = null;
      }
    }

    return UserModel(
      id: id,
      email: email,
      displayName: json['display_name']?.toString(),
      phoneNumber: json['phone_number']?.toString(),
      photoUrl: json['photo_url']?.toString(),
      activeRole: UserRoleExtension.fromString(activeRoleStr),
      availableRoles: availableRolesStrs
          .map((r) => UserRoleExtension.fromString(r))
          .toList(),
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      isEmailVerified: (json['is_email_verified'] ?? json['email_verified']) == true,
      isPhoneVerified: (json['is_phone_verified'] ?? json['phone_verified']) == true,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create a mock user for development - DEBUG ONLY
  /// This factory is only available in debug mode to prevent mock data in production
  /// Returns null in release mode
  static UserModel? mock({
    String id = 'mock-user-id',
    String email = 'user@example.com',
    String? displayName = 'Test User',
    UserRole activeRole = UserRole.student,
    List<UserRole>? availableRoles,
  }) {
    if (!kDebugMode) {
      assert(false, 'UserModel.mock should not be called in release mode');
      return null;
    }

    return UserModel(
      id: id,
      email: email,
      displayName: displayName,
      activeRole: activeRole,
      availableRoles: availableRoles ?? [activeRole],
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, displayName: $displayName, activeRole: ${activeRole.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel && other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
