/// User roles in the Flow EdTech platform
enum UserRole {
  student,
  institution,
  parent,
  counselor,
  recommender,

  // Admin roles
  superAdmin,
  regionalAdmin,
  contentAdmin,
  supportAdmin,
  financeAdmin,
  analyticsAdmin,
}

/// Admin hierarchy levels
enum AdminLevel {
  platform,    // Super Admin - Full platform access
  regional,    // Regional Admin - Regional scope
  specialized, // Content, Support, Finance, Analytics - Specialized access
}

extension UserRoleExtension on UserRole {
  /// Get role name as string (lowercase)
  String get roleName {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.institution:
        return 'institution';
      case UserRole.parent:
        return 'parent';
      case UserRole.counselor:
        return 'counselor';
      case UserRole.recommender:
        return 'recommender';
      case UserRole.superAdmin:
        return 'superadmin';
      case UserRole.regionalAdmin:
        return 'regionaladmin';
      case UserRole.contentAdmin:
        return 'contentadmin';
      case UserRole.supportAdmin:
        return 'supportadmin';
      case UserRole.financeAdmin:
        return 'financeadmin';
      case UserRole.analyticsAdmin:
        return 'analyticsadmin';
    }
  }

  /// Get display name for the role
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.institution:
        return 'Institution';
      case UserRole.parent:
        return 'Parent';
      case UserRole.counselor:
        return 'Counselor';
      case UserRole.recommender:
        return 'Recommender';
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.regionalAdmin:
        return 'Regional Admin';
      case UserRole.contentAdmin:
        return 'Content Admin';
      case UserRole.supportAdmin:
        return 'Support Admin';
      case UserRole.financeAdmin:
        return 'Finance Admin';
      case UserRole.analyticsAdmin:
        return 'Analytics Admin';
    }
  }

  /// Get route path for the role
  String get routePath {
    switch (this) {
      case UserRole.student:
        return '/student';
      case UserRole.institution:
        return '/institution';
      case UserRole.parent:
        return '/parent';
      case UserRole.counselor:
        return '/counselor';
      case UserRole.recommender:
        return '/recommender';
      // All admin roles share the same base path
      case UserRole.superAdmin:
      case UserRole.regionalAdmin:
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return '/admin';
    }
  }

  /// Get dashboard route for the role
  String get dashboardRoute {
    return '$routePath/dashboard';
  }

  /// Parse UserRole from string
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.roleName == value.toLowerCase(),
      orElse: () => UserRole.student,
    );
  }

  /// Check if this role is an admin role
  bool get isAdmin {
    return [
      UserRole.superAdmin,
      UserRole.regionalAdmin,
      UserRole.contentAdmin,
      UserRole.supportAdmin,
      UserRole.financeAdmin,
      UserRole.analyticsAdmin,
    ].contains(this);
  }

  /// Get admin level for admin roles
  AdminLevel? get adminLevel {
    switch (this) {
      case UserRole.superAdmin:
        return AdminLevel.platform;
      case UserRole.regionalAdmin:
        return AdminLevel.regional;
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return AdminLevel.specialized;
      default:
        return null;
    }
  }

  /// Check if this is a super admin role
  bool get isSuperAdmin => this == UserRole.superAdmin;

  /// Check if this is a regional admin role
  bool get isRegionalAdmin => this == UserRole.regionalAdmin;

  /// Get numeric hierarchy level for admin roles (higher number = higher authority)
  /// Returns 0 for non-admin roles
  int get hierarchyLevel {
    switch (this) {
      case UserRole.superAdmin:
        return 3; // Highest level
      case UserRole.regionalAdmin:
        return 2; // Mid level
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return 1; // Specialized admins - lowest admin level
      default:
        return 0; // Non-admin roles
    }
  }

  /// Check if this role can manage another role
  /// Hierarchy rules:
  /// - Super Admin can manage all users including all admin types
  /// - Regional Admin can manage specialized admins and regular users (not Super Admin or other Regional Admins)
  /// - Specialized Admins cannot manage any admin roles
  /// - Non-admins cannot manage anyone
  bool canManage(UserRole targetRole) {
    // Super Admin can manage everyone
    if (this == UserRole.superAdmin) return true;

    // Regular users (non-admins) cannot manage anyone
    if (!isAdmin) return false;

    // Admins cannot manage other admins of equal or higher hierarchy
    if (targetRole.isAdmin) {
      return hierarchyLevel > targetRole.hierarchyLevel;
    }

    // Regional and specialized admins can manage regular users based on their permissions
    return true;
  }

  /// Check if this role is higher in hierarchy than another role
  bool isHigherThan(UserRole other) {
    return hierarchyLevel > other.hierarchyLevel;
  }

  /// Check if this role is lower in hierarchy than another role
  bool isLowerThan(UserRole other) {
    return hierarchyLevel < other.hierarchyLevel;
  }

  /// Check if this role is equal in hierarchy to another role
  bool isEqualTo(UserRole other) {
    return hierarchyLevel == other.hierarchyLevel;
  }
}
