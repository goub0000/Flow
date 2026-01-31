import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../core/models/admin_user_model.dart';
import '../providers/admin_auth_provider.dart';
import 'admin_role_badge.dart';
import 'admin_global_search.dart';

/// Admin Top Bar - Header with user info, notifications, and actions
class AdminTopBar extends ConsumerWidget {
  final AdminUser adminUser;

  const AdminTopBar({
    required this.adminUser,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Page title will be added by child pages
          const Expanded(child: SizedBox()),

          // Global Search Bar
          const AdminGlobalSearch(),
          const SizedBox(width: 16),

          // Theme Toggle
          Semantics(
            button: true,
            label: 'Toggle dark mode',
            child: IconButton(
              icon: Icon(
                ref.watch(themeModeProvider) == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              tooltip: ref.watch(themeModeProvider) == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ),
          const SizedBox(width: 8),

          // Notifications icon (placeholder for Phase 3)
          Semantics(
            button: true,
            label: 'Notifications',
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    context.go('/admin/notifications');
                  },
                  tooltip: 'Notifications',
                ),
                // Notification badge (decorative)
                Positioned(
                  right: 8,
                  top: 8,
                  child: ExcludeSemantics(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Divider
          Container(
            width: 1,
            height: 40,
            color: AppColors.divider,
          ),
          const SizedBox(width: 16),

          // Admin role badge
          AdminRoleBadge(adminUser: adminUser),
          const SizedBox(width: 16),

          // Quick Logout Button
          Semantics(
            button: true,
            label: 'Sign out',
            child: IconButton(
              icon: Icon(Icons.logout, color: AppColors.error),
              onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true && context.mounted) {
                await ref.read(adminAuthProvider.notifier).signOut();
                if (context.mounted) {
                  context.go('/admin/login');
                }
              }
            },
            tooltip: 'Sign Out',
            ),
          ),
          const SizedBox(width: 8),

          // User profile menu
          Semantics(
            button: true,
            label: 'User menu for ${adminUser.displayName}',
            child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: adminUser.roleBadgeColor.withValues(alpha: 0.1),
                  child: adminUser.profilePhotoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            adminUser.profilePhotoUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildInitialsAvatar();
                            },
                          ),
                        )
                      : _buildInitialsAvatar(),
                ),
                const SizedBox(width: 12),
                // User name and role
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      adminUser.displayName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      adminUser.regionalScopeDisplay,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(Icons.person_outline, size: 20),
                    const SizedBox(width: 12),
                    const Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(Icons.settings_outlined, size: 20),
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
                    Icon(Icons.logout, size: 20, color: AppColors.error),
                    const SizedBox(width: 12),
                    Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'profile':
                  context.go('/admin/system/settings');
                  break;
                case 'settings':
                  context.go('/admin/system/settings');
                  break;
                case 'logout':
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true && context.mounted) {
                    await ref.read(adminAuthProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/admin/login');
                    }
                  }
                  break;
              }
            },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialsAvatar() {
    final initials = adminUser.displayName
        .split(' ')
        .map((name) => name.isNotEmpty ? name[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Text(
      initials,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: adminUser.roleBadgeColor,
      ),
    );
  }

}
