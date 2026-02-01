import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/user_roles.dart';
import '../../authentication/providers/auth_provider.dart';

/// Persistent navigation shell for public pages (about, universities, etc.).
/// Provides a consistent top navbar with logo, navigation links, and auth buttons.
class PublicShell extends ConsumerWidget {
  final Widget child;

  const PublicShell({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _PublicNavBar(
          theme: theme,
          currentPath: location,
          isAuthenticated: authState.isAuthenticated,
          dashboardRoute: authState.user?.activeRole.dashboardRoute,
        ),
      ),
      body: child,
    );
  }
}

class _PublicNavBar extends StatelessWidget {
  final ThemeData theme;
  final String currentPath;
  final bool isAuthenticated;
  final String? dashboardRoute;

  const _PublicNavBar({
    required this.theme,
    required this.currentPath,
    required this.isAuthenticated,
    this.dashboardRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Material(
      elevation: 1,
      color: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surfaceTint,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Logo + brand
                _LogoBrand(theme: theme),

                const SizedBox(width: 24),

                // Nav links (hidden on narrow screens)
                if (isWide) ...[
                  _NavLink(
                    label: 'Home',
                    path: '/',
                    currentPath: currentPath,
                    theme: theme,
                  ),
                  _NavLink(
                    label: 'Universities',
                    path: '/universities',
                    currentPath: currentPath,
                    theme: theme,
                  ),
                  _NavLink(
                    label: 'About',
                    path: '/about',
                    currentPath: currentPath,
                    theme: theme,
                  ),
                  _NavLink(
                    label: 'Contact',
                    path: '/contact',
                    currentPath: currentPath,
                    theme: theme,
                  ),
                ],

                const Spacer(),

                // Auth actions
                if (isAuthenticated && dashboardRoute != null) ...[
                  FilledButton.icon(
                    onPressed: () => context.go(dashboardRoute!),
                    icon: const Icon(Icons.dashboard, size: 18),
                    label: const Text('Dashboard'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ] else ...[
                  TextButton(
                    onPressed: () => context.go('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurface,
                    ),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => context.go('/register'),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Get Started'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],

                // Hamburger menu on narrow screens
                if (!isWide) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.menu),
                    onSelected: (path) => context.go(path),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: '/', child: Text('Home')),
                      const PopupMenuItem(
                        value: '/universities',
                        child: Text('Universities'),
                      ),
                      const PopupMenuItem(value: '/about', child: Text('About')),
                      const PopupMenuItem(
                        value: '/contact',
                        child: Text('Contact'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoBrand extends StatelessWidget {
  final ThemeData theme;

  const _LogoBrand({required this.theme});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                height: 36,
                width: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.school, size: 36),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Flow',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String path;
  final String currentPath;
  final ThemeData theme;

  const _NavLink({
    required this.label,
    required this.path,
    required this.currentPath,
    required this.theme,
  });

  bool get _isActive =>
      path == '/'
          ? currentPath == '/'
          : currentPath.startsWith(path);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => context.go(path),
        style: TextButton.styleFrom(
          foregroundColor: _isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: _isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
