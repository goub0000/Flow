import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';
import 'logo_avatar.dart';

class DashboardScaffold extends ConsumerWidget {
  final String title;
  final Widget body;
  final List<DashboardAction>? actions;
  final int currentIndex;
  final Function(int) onNavigationTap;
  final List<DashboardNavigationItem> navigationItems;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    required this.currentIndex,
    required this.onNavigationTap,
    required this.navigationItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final canPop = GoRouter.of(context).canPop();

    // Intelligently show either back button or logo
    Widget leadingWidget;
    if (canPop) {
      // Show back button when navigation is possible
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
        tooltip: 'Back',
      );
    } else {
      // Show clickable logo when at root level
      leadingWidget = IconButton(
        icon: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/logo.png',
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback icon if logo doesn't load
              return const Icon(Icons.home);
            },
          ),
        ),
        onPressed: () => context.go('/'),
        tooltip: 'Home',
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: leadingWidget,
        title: Text(title),
        actions: [
          if (actions != null)
            ...actions!.map((action) => IconButton(
                  icon: Icon(action.icon),
                  onPressed: action.onPressed,
                  tooltip: action.tooltip,
                )),
          // Role switcher (if user has multiple roles)
          if (user != null && user.hasMultipleRoles)
            PopupMenuButton<UserRole>(
              icon: const Icon(Icons.swap_horiz),
              tooltip: 'Switch Role',
              onSelected: (role) {
                ref.read(authProvider.notifier).switchRole(role);
              },
              itemBuilder: (context) {
                return user.availableRoles.map((role) {
                  final isActive = role == user.activeRole;
                  return PopupMenuItem<UserRole>(
                    value: role,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.getRoleColor(UserRoleHelper.getRoleName(role)),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          role.displayName,
                          style: TextStyle(
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.check,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList();
              },
            ),
          // Profile menu
          PopupMenuButton<String>(
            icon: LogoAvatar.user(
              photoUrl: user?.photoUrl,
              initials: user?.initials ?? 'U',
              size: 40,
            ),
            onSelected: (value) {
              switch (value) {
                case 'profile':
                  // Don't navigate if we're already in a dashboard with tabs
                  // Let the tab navigation handle profile display
                  if (navigationItems.any((item) => item.label == 'Profile')) {
                    // Find and switch to profile tab instead of navigating
                    final profileIndex = navigationItems.indexWhere((item) => item.label == 'Profile');
                    if (profileIndex != -1) {
                      onNavigationTap(profileIndex);
                    }
                  } else {
                    // Only navigate to standalone profile if not in tabbed dashboard
                    context.go('/profile');
                  }
                  break;
                case 'settings':
                  // Similar handling for settings
                  if (navigationItems.any((item) => item.label == 'Settings')) {
                    final settingsIndex = navigationItems.indexWhere((item) => item.label == 'Settings');
                    if (settingsIndex != -1) {
                      onNavigationTap(settingsIndex);
                    }
                  } else {
                    context.go('/settings');
                  }
                  break;
                case 'logout':
                  ref.read(authProvider.notifier).signOut();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outlined),
                    const SizedBox(width: 12),
                    const Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined),
                    const SizedBox(width: 12),
                    const Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: AppColors.error),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          print('[DEBUG] DashboardScaffold: BottomNav tapped - index: $index');
          onNavigationTap(index);
        },
        items: navigationItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  activeIcon: Icon(item.activeIcon ?? item.icon),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class DashboardAction {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;

  const DashboardAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });
}

class DashboardNavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const DashboardNavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}
