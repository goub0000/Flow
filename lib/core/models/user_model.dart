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

  /// Convert to JSON (for Firebase/backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'activeRole': activeRole.name,
      'availableRoles': availableRoles.map((r) => r.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'isPhoneVerified': isPhoneVerified,
      'metadata': metadata,
    };
  }

  /// Create from JSON (from Firebase/backend)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      activeRole: UserRoleExtension.fromString(json['active_role'] as String),
      availableRoles: (json['available_roles'] as List)
          .map((r) => UserRoleExtension.fromString(r as String))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      isEmailVerified: (json['is_email_verified'] ?? json['email_verified']) as bool? ?? false,
      isPhoneVerified: (json['is_phone_verified'] ?? json['phone_verified']) as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create a mock user for development
  factory UserModel.mock({
    String id = 'mock-user-id',
    String email = 'user@example.com',
    String? displayName = 'Test User',
    UserRole activeRole = UserRole.student,
    List<UserRole>? availableRoles,
  }) {
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
