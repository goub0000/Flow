import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/child_model.dart';
import '../../features/parent/dashboard/presentation/parent_dashboard_screen.dart';
import '../../features/parent/children/presentation/children_list_screen.dart';
import '../../features/parent/children/presentation/child_detail_screen.dart';

/// Parent-specific routes
List<RouteBase> parentRoutes = [
  GoRoute(
    path: '/parent/dashboard',
    name: 'parent-dashboard',
    builder: (context, state) {
      // Check for tab query parameter
      final tabIndex = int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;
      return ParentDashboardScreen(initialTab: tabIndex);
    },
  ),
  GoRoute(
    path: '/parent/children',
    name: 'parent-children',
    redirect: (context, state) => '/parent/dashboard?tab=1',
  ),
  GoRoute(
    path: '/parent/children/:id',
    name: 'parent-child-detail',
    builder: (context, state) {
      // final childId = state.pathParameters['id']!;
      // Child should be passed via state.extra
      final child = state.extra as Child?;
      if (child == null) {
        // If no child provided, redirect back to children list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/parent/children');
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return ChildDetailScreen(child: child);
    },
  ),
];