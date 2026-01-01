import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Core imports
import '../core/error/error_handling.dart';
import '../core/constants/user_roles.dart';
import '../features/authentication/providers/auth_provider.dart';

// Guards
import 'guards/auth_guard.dart';
import 'guards/role_guard.dart';

// Routes
import 'routes/auth_routes.dart';
import 'routes/student_routes.dart';
import 'routes/institution_routes.dart';
import 'routes/parent_routes.dart';
import 'routes/counselor_routes.dart';
import 'routes/recommender_routes.dart';
import 'routes/admin_routes.dart';
import 'routes/shared_routes.dart';
import 'routes/find_your_path_routes.dart';

/// Main router provider that combines all route modules
final routerProvider = Provider<GoRouter>((ref) {
  // final logger = Logger('AppRouter');
  // Watch authProvider to trigger rebuilds, but read fresh state in redirect
  ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _RouterNotifier(ref),
    redirect: (context, state) {
      // Read fresh auth state inside redirect callback to avoid stale data
      final authState = ref.read(authProvider);
      final isLoading = authState.isLoading;
      final isAuthenticated = authState.isAuthenticated;
      final location = state.matchedLocation;

      // Don't redirect while auth state is still loading (session being restored)
      // This prevents the flash of wrong content during page refresh
      if (isLoading) {
        return null;
      }

      // First check auth-based redirects
      final authRedirect = AuthGuard.getRedirect(
        location: location,
        isAuthenticated: isAuthenticated,
        userDashboardRoute: authState.user?.activeRole.dashboardRoute,
      );

      if (authRedirect != null) {
        return authRedirect;
      }

      // Then check role-based access
      if (isAuthenticated && !AuthGuard.isAuthRoute(location)) {
        final user = authState.user!;
        final roleRedirect = RoleGuard.getRoleBasedRedirect(
          user: user,
          location: location,
        );

        if (roleRedirect != null) {
          return roleRedirect;
        }
      }

      return null;
    },
    routes: [
      // Combine all route modules
      ...authRoutes,
      ...studentRoutes,
      ...institutionRoutes,
      ...parentRoutes,
      ...counselorRoutes,
      ...recommenderRoutes,
      ...adminRoutes,
      ...sharedRoutes,
      ...findYourPathRoutes,
    ],
    errorBuilder: (context, state) => NotFoundScreen(
      path: state.matchedLocation,
    ),
  );
});

/// Router notifier for refreshing routes on auth state change
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen(
      authProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }
}