import 'package:logging/logging.dart';

class AuthGuard {
  static final logger = Logger('AuthGuard');

  /// Check if the current route requires authentication
  static bool isAuthRoute(String location) {
    return location.startsWith('/login') ||
        location.startsWith('/register') ||
        location.startsWith('/forgot-password') ||
        location.startsWith('/email-verification') ||
        location.startsWith('/onboarding') ||
        location.startsWith('/biometric-setup');
  }

  /// Check if the route is a home route
  static bool isHomeRoute(String location) {
    return location == '/' || location.startsWith('/home');
  }

  /// Check if the route is a Find Your Path route (public access)
  static bool isFindYourPathRoute(String location) {
    return location.startsWith('/find-your-path');
  }

  /// Check if the route is a University Search route (public access)
  static bool isUniversityRoute(String location) {
    return location.startsWith('/universities');
  }

  /// Check if the route is a public info page (footer pages)
  static bool isPublicInfoRoute(String location) {
    const publicRoutes = [
      '/about',
      '/contact',
      '/privacy',
      '/terms',
      '/careers',
      '/press',
      '/partners',
      '/help',
      '/docs',
      '/api-docs',
      '/community',
      '/blog',
      '/compliance',
      '/cookies',
      '/data-protection',
      '/mobile-apps',
    ];
    return publicRoutes.contains(location);
  }

  /// Determine if a redirect is needed based on authentication state
  static String? getRedirect({
    required String location,
    required bool isAuthenticated,
    required String? userDashboardRoute,
  }) {
    logger.fine('AuthGuard redirect: location=\$location, isAuthenticated=\$isAuthenticated');

    // PRIORITY 1: Redirect authenticated users away from auth routes and home page
    if (isAuthenticated) {
      if (isAuthRoute(location) || isHomeRoute(location)) {
        logger.info('Redirecting authenticated user to dashboard: \$userDashboardRoute');
        return userDashboardRoute;
      }
    }

    // PRIORITY 2: Allow unauthenticated access to public routes
    if (isHomeRoute(location) || isFindYourPathRoute(location) || isUniversityRoute(location) || isPublicInfoRoute(location)) {
      return null;
    }

    // PRIORITY 3: Redirect unauthenticated users to login
    if (!isAuthenticated && !isAuthRoute(location)) {
      return '/login';
    }

    return null;
  }
}
