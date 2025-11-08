import 'package:flutter/material.dart';
import '../constants/user_roles.dart';
import '../constants/admin_permissions.dart';
import '../theme/app_colors.dart';

/// Admin user model with role-based permissions
class AdminUser {
  final String id;
  final String email;
  final String displayName;
  final UserRole adminRole;
  final AdminPermissions permissions;
  final bool mfaEnabled;
  final String? profilePhotoUrl;
  final DateTime createdAt;
  final DateTime lastLogin;
  final bool isActive;
  final String? regionalScope; // For regional admins

  AdminUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.adminRole,
    required this.permissions,
    required this.mfaEnabled,
    this.profilePhotoUrl,
    required this.createdAt,
    required this.lastLogin,
    this.isActive = true,
    this.regionalScope,
  });

  /// Check if user has a specific permission
  bool hasPermission(AdminPermission permission) {
    return permissions.hasPermission(permission);
  }

  /// Check if user has any of the given permissions
  bool hasAnyPermission(List<AdminPermission> perms) {
    return permissions.hasAnyPermission(perms);
  }

  /// Check if user has all of the given permissions
  bool hasAllPermissions(List<AdminPermission> perms) {
    return permissions.hasAllPermissions(perms);
  }

  /// Check if user is super admin
  bool get isSuperAdmin => adminRole == UserRole.superAdmin;

  /// Check if user is regional admin
  bool get isRegionalAdmin => adminRole == UserRole.regionalAdmin;

  /// Check if user is admin (any admin role)
  bool get isAdmin => adminRole.isAdmin;

  /// Get admin level
  AdminLevel? get adminLevel => adminRole.adminLevel;

  /// Get role badge text
  String get roleBadgeText {
    return adminRole.displayName.toUpperCase();
  }

  /// Get role badge color
  Color get roleBadgeColor {
    return AppColors.getAdminRoleColor(adminRole);
  }

  /// Get role icon
  IconData get roleIcon {
    return AppColors.getAdminRoleIcon(adminRole);
  }

  /// Get accent color for super admin badge
  Color? get badgeAccentColor {
    if (isSuperAdmin) {
      return AppColors.superAdminAccent;
    }
    return null;
  }

  /// Get regional scope display text
  String get regionalScopeDisplay {
    if (regionalScope != null) {
      return regionalScope!;
    }
    return 'Global';
  }

  /// Create a copy of this admin user with updated fields
  AdminUser copyWith({
    String? id,
    String? email,
    String? displayName,
    UserRole? adminRole,
    AdminPermissions? permissions,
    bool? mfaEnabled,
    String? profilePhotoUrl,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    String? regionalScope,
  }) {
    return AdminUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      adminRole: adminRole ?? this.adminRole,
      permissions: permissions ?? this.permissions,
      mfaEnabled: mfaEnabled ?? this.mfaEnabled,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      regionalScope: regionalScope ?? this.regionalScope,
    );
  }

  /// Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'adminRole': adminRole.name,
      'mfaEnabled': mfaEnabled,
      'profilePhotoUrl': profilePhotoUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin.toIso8601String(),
      'isActive': isActive,
      'regionalScope': regionalScope,
    };
  }

  /// Create from JSON (Firebase)
  factory AdminUser.fromJson(Map<String, dynamic> json) {
    final role = UserRole.values.firstWhere(
      (r) => r.name == json['adminRole'],
      orElse: () => UserRole.superAdmin,
    );

    return AdminUser(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      adminRole: role,
      permissions: AdminPermissions.forRole(
        role,
        region: json['regionalScope'] as String?,
      ),
      mfaEnabled: json['mfaEnabled'] as bool? ?? false,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'] as String)
          : DateTime.now(),
      isActive: json['isActive'] as bool? ?? true,
      regionalScope: json['regionalScope'] as String?,
    );
  }

  @override
  String toString() {
    return 'AdminUser(id: $id, email: $email, role: ${adminRole.displayName}, active: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AdminUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
