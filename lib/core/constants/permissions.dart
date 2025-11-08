import 'user_roles.dart';

/// Permissions for different features in the app
enum Permission {
  // Student permissions
  viewApplications,
  submitApplication,
  editProfile,
  viewCourses,
  enrollInCourse,
  submitAssignment,
  viewProgress,

  // Institution permissions
  viewAllApplications,
  manageInstitutionProfile,
  reviewApplications,
  acceptApplication,
  rejectApplication,
  viewApplicantDetails,
  manageCourses,
  manageEnrollments,

  // Parent permissions
  viewChildProgress,
  receiveNotifications,
  viewChildApplications,
  communicateWithInstitution,

  // Counselor permissions
  viewStudentRecords,
  provideCounseling,
  writeRecommendations,
  scheduleAppointments,
  trackStudentProgress,

  // Recommender permissions
  viewRecommendationRequests,
  submitRecommendations,
  viewRequestDetails,
  editRecommendation,

  // Shared permissions
  changePassword,
  viewNotifications,
  updateProfilePicture,
  enableBiometric,
  manageSettings,
}

/// Role-based access control manager
class RoleManager {
  RoleManager._();

  /// Map of roles to their permissions
  static final Map<UserRole, Set<Permission>> rolePermissions = {
    UserRole.student: {
      Permission.viewApplications,
      Permission.submitApplication,
      Permission.editProfile,
      Permission.viewCourses,
      Permission.enrollInCourse,
      Permission.submitAssignment,
      Permission.viewProgress,
      Permission.changePassword,
      Permission.viewNotifications,
      Permission.updateProfilePicture,
      Permission.enableBiometric,
      Permission.manageSettings,
    },
    UserRole.institution: {
      Permission.viewAllApplications,
      Permission.manageInstitutionProfile,
      Permission.reviewApplications,
      Permission.acceptApplication,
      Permission.rejectApplication,
      Permission.viewApplicantDetails,
      Permission.manageCourses,
      Permission.manageEnrollments,
      Permission.changePassword,
      Permission.viewNotifications,
      Permission.updateProfilePicture,
      Permission.manageSettings,
    },
    UserRole.parent: {
      Permission.viewChildProgress,
      Permission.receiveNotifications,
      Permission.viewChildApplications,
      Permission.communicateWithInstitution,
      Permission.changePassword,
      Permission.viewNotifications,
      Permission.updateProfilePicture,
      Permission.manageSettings,
    },
    UserRole.counselor: {
      Permission.viewStudentRecords,
      Permission.provideCounseling,
      Permission.writeRecommendations,
      Permission.scheduleAppointments,
      Permission.trackStudentProgress,
      Permission.changePassword,
      Permission.viewNotifications,
      Permission.updateProfilePicture,
      Permission.manageSettings,
    },
    UserRole.recommender: {
      Permission.viewRecommendationRequests,
      Permission.submitRecommendations,
      Permission.viewRequestDetails,
      Permission.editRecommendation,
      Permission.changePassword,
      Permission.viewNotifications,
      Permission.updateProfilePicture,
      Permission.manageSettings,
    },
  };

  /// Check if a role has a specific permission
  static bool hasPermission(UserRole role, Permission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }

  /// Check if a role has any of the specified permissions
  static bool hasAnyPermission(UserRole role, List<Permission> permissions) {
    final rolePerms = rolePermissions[role] ?? {};
    return permissions.any((perm) => rolePerms.contains(perm));
  }

  /// Check if a role has all of the specified permissions
  static bool hasAllPermissions(UserRole role, List<Permission> permissions) {
    final rolePerms = rolePermissions[role] ?? {};
    return permissions.every((perm) => rolePerms.contains(perm));
  }

  /// Get all permissions for a role
  static Set<Permission> getPermissions(UserRole role) {
    return rolePermissions[role] ?? {};
  }
}
