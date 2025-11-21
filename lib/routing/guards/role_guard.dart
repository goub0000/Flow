import '../../core/models/user_model.dart';
import '../../core/constants/user_roles.dart';

class RoleGuard {
  /// Check if user has access to a specific role's routes
  static bool hasRoleAccess(UserModel user, String routeRole) {
    switch (routeRole) {
      case 'student':
        return user.activeRole == UserRole.student ||
            user.availableRoles.contains(UserRole.student);
      case 'institution':
        return user.activeRole == UserRole.institution ||
            user.availableRoles.contains(UserRole.institution);
      case 'parent':
        return user.activeRole == UserRole.parent ||
            user.availableRoles.contains(UserRole.parent);
      case 'counselor':
        return user.activeRole == UserRole.counselor ||
            user.availableRoles.contains(UserRole.counselor);
      case 'recommender':
        return user.activeRole == UserRole.recommender ||
            user.availableRoles.contains(UserRole.recommender);
      case 'admin':
        // All admin roles have access to /admin routes
        return user.activeRole.isAdmin ||
            user.availableRoles.any((role) => role.isAdmin);
      default:
        return false;
    }
  }

  /// Check if a route is a shared route accessible to all authenticated users
  static bool isSharedRoute(String location) {
    final pathSegments = location.split('/');
    if (pathSegments.length > 1) {
      final routeRole = pathSegments[1];
      return routeRole == 'profile' ||
          routeRole == 'settings' ||
          routeRole == 'notifications' ||
          routeRole == 'messages' ||
          routeRole == 'documents' ||
          routeRole == 'payments' ||
          routeRole == 'resources' ||
          routeRole == 'schedule' ||
          routeRole == 'exams' ||
          routeRole == 'quiz' ||
          routeRole == 'tasks' ||
          routeRole == 'collaboration';
    }
    return false;
  }

  /// Get redirect path based on role access
  static String? getRoleBasedRedirect({
    required UserModel user,
    required String location,
  }) {
    // Extract the role from the route
    final pathSegments = location.split('/');
    if (pathSegments.length > 1) {
      final routeRole = pathSegments[1];

      // Shared routes accessible to all authenticated users
      if (isSharedRoute(location) || location.startsWith('/find-your-path')) {
        return null;
      }

      // Check if user has access to this role's routes
      if (!hasRoleAccess(user, routeRole)) {
        return user.activeRole.dashboardRoute;
      }
    }

    return null;
  }
}