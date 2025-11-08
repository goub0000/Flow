import 'user_roles.dart';

/// Admin permission types for role-based access control
enum AdminPermission {
  // User Management
  viewAllUsers,
  viewRegionalUsers,
  editUsers,
  deleteUsers,
  suspendUsers,
  bulkUserOperations,
  resetUserPasswords,
  unlockUserAccounts,

  // Institution Management
  viewInstitutions,
  editInstitutions,
  approveInstitutions,
  verifyInstitutions,
  deleteInstitutions,

  // Content Management
  viewContent,
  createContent,
  editContent,
  deleteContent,
  approveContent,
  manageVersions,
  manageTranslations,

  // Financial Management
  viewTransactions,
  processRefunds,
  manageSettlements,
  configureFees,
  manageFraudDetection,
  viewFinancialReports,
  manageCommissions,

  // Support
  viewTickets,
  manageTickets,
  accessLiveChat,
  manageKnowledgeBase,
  userImpersonation,
  manageCannedResponses,

  // Analytics
  viewAnalytics,
  createCustomReports,
  executeSQLQueries,
  exportData,
  manageKPIs,
  createDashboards,

  // Communication
  sendAnnouncements,
  sendEmailCampaigns,
  sendSMS,
  managePushNotifications,
  manageTemplates,

  // System Administration
  manageAdmins,
  manageSystemSettings,
  manageSecurityConfig,
  accessInfrastructure,
  viewAuditLogs,
  exportAuditLogs,
  manageFeatureFlags,
  manageDatabaseBackups,
  manageAPIKeys,
}

/// Admin permissions set with scope
class AdminPermissions {
  final Set<AdminPermission> permissions;
  final String? regionalScope; // For Regional Admins (e.g., "Kenya", "South Africa")

  const AdminPermissions({
    required this.permissions,
    this.regionalScope,
  });

  /// Check if has a specific permission
  bool hasPermission(AdminPermission permission) {
    return permissions.contains(permission);
  }

  /// Check if has any of the given permissions
  bool hasAnyPermission(List<AdminPermission> perms) {
    return perms.any((p) => permissions.contains(p));
  }

  /// Check if has all of the given permissions
  bool hasAllPermissions(List<AdminPermission> perms) {
    return perms.every((p) => permissions.contains(p));
  }

  /// Check if this is a regional scope
  bool get isRegionalScope => regionalScope != null;

  // Factory constructors for each admin role

  /// Super Admin - All permissions
  factory AdminPermissions.superAdmin() {
    return AdminPermissions(
      permissions: Set.from(AdminPermission.values), // All permissions
    );
  }

  /// Regional Admin - Regional management permissions
  factory AdminPermissions.regionalAdmin(String region) {
    return AdminPermissions(
      regionalScope: region,
      permissions: {
        // User Management
        AdminPermission.viewRegionalUsers,
        AdminPermission.editUsers,
        AdminPermission.bulkUserOperations,
        AdminPermission.resetUserPasswords,
        AdminPermission.unlockUserAccounts,

        // Institution Management
        AdminPermission.viewInstitutions,
        AdminPermission.editInstitutions,
        AdminPermission.approveInstitutions,

        // Content Management
        AdminPermission.viewContent,
        AdminPermission.createContent,
        AdminPermission.editContent,
        AdminPermission.approveContent,

        // Financial Management
        AdminPermission.viewTransactions,
        AdminPermission.viewFinancialReports,
        AdminPermission.configureFees,

        // Support
        AdminPermission.viewTickets,
        AdminPermission.manageTickets,
        AdminPermission.accessLiveChat,
        AdminPermission.manageKnowledgeBase,

        // Analytics
        AdminPermission.viewAnalytics,
        AdminPermission.createCustomReports,
        AdminPermission.exportData,

        // Communication
        AdminPermission.sendAnnouncements,
        AdminPermission.sendEmailCampaigns,
        AdminPermission.sendSMS,
        AdminPermission.managePushNotifications,

        // System
        AdminPermission.viewAuditLogs,
        AdminPermission.manageSystemSettings,
      },
    );
  }

  /// Content Admin - Content and curriculum management
  factory AdminPermissions.contentAdmin() {
    return AdminPermissions(
      permissions: {
        // Content Management
        AdminPermission.viewContent,
        AdminPermission.createContent,
        AdminPermission.editContent,
        AdminPermission.deleteContent,
        AdminPermission.approveContent,
        AdminPermission.manageVersions,
        AdminPermission.manageTranslations,

        // Analytics (content-related only)
        AdminPermission.viewAnalytics,
        AdminPermission.createCustomReports,
        AdminPermission.exportData,

        // Communication (content-related only)
        AdminPermission.sendAnnouncements,
        AdminPermission.managePushNotifications,
      },
    );
  }

  /// Support Admin - User support and issue resolution
  factory AdminPermissions.supportAdmin() {
    return AdminPermissions(
      permissions: {
        // User Management (limited)
        AdminPermission.viewRegionalUsers,
        AdminPermission.resetUserPasswords,
        AdminPermission.unlockUserAccounts,

        // Support
        AdminPermission.viewTickets,
        AdminPermission.manageTickets,
        AdminPermission.accessLiveChat,
        AdminPermission.manageKnowledgeBase,
        AdminPermission.userImpersonation,
        AdminPermission.manageCannedResponses,

        // Financial (read-only for support)
        AdminPermission.viewTransactions,

        // Analytics (support-related only)
        AdminPermission.viewAnalytics,
        AdminPermission.createCustomReports,
        AdminPermission.exportData,

        // Communication
        AdminPermission.sendAnnouncements,
        AdminPermission.sendSMS,
        AdminPermission.managePushNotifications,
        AdminPermission.manageTemplates,
      },
    );
  }

  /// Finance Admin - Payment processing and financial management
  factory AdminPermissions.financeAdmin() {
    return AdminPermissions(
      permissions: {
        // Financial Management
        AdminPermission.viewTransactions,
        AdminPermission.processRefunds,
        AdminPermission.manageSettlements,
        AdminPermission.configureFees,
        AdminPermission.manageFraudDetection,
        AdminPermission.viewFinancialReports,
        AdminPermission.manageCommissions,

        // User Management (payment-related only)
        AdminPermission.viewRegionalUsers,

        // Analytics (financial analytics only)
        AdminPermission.viewAnalytics,
        AdminPermission.createCustomReports,
        AdminPermission.exportData,

        // Audit
        AdminPermission.viewAuditLogs,
      },
    );
  }

  /// Analytics Admin - Data analysis and reporting
  factory AdminPermissions.analyticsAdmin() {
    return AdminPermissions(
      permissions: {
        // Analytics
        AdminPermission.viewAnalytics,
        AdminPermission.createCustomReports,
        AdminPermission.executeSQLQueries,
        AdminPermission.exportData,
        AdminPermission.manageKPIs,
        AdminPermission.createDashboards,

        // Read-only access to data
        AdminPermission.viewAllUsers,
        AdminPermission.viewInstitutions,
        AdminPermission.viewContent,
        AdminPermission.viewTransactions,
        AdminPermission.viewTickets,

        // Audit
        AdminPermission.viewAuditLogs,
      },
    );
  }

  /// Get permissions for a specific role
  static AdminPermissions forRole(UserRole role, {String? region}) {
    switch (role) {
      case UserRole.superAdmin:
        return AdminPermissions.superAdmin();
      case UserRole.regionalAdmin:
        return AdminPermissions.regionalAdmin(region ?? 'Unknown');
      case UserRole.contentAdmin:
        return AdminPermissions.contentAdmin();
      case UserRole.supportAdmin:
        return AdminPermissions.supportAdmin();
      case UserRole.financeAdmin:
        return AdminPermissions.financeAdmin();
      case UserRole.analyticsAdmin:
        return AdminPermissions.analyticsAdmin();
      default:
        return AdminPermissions(permissions: {});
    }
  }

  @override
  String toString() {
    return 'AdminPermissions(permissions: ${permissions.length}, regionalScope: $regionalScope)';
  }
}
