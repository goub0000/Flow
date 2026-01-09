import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/providers/admin_auth_provider.dart';

/// Settings Screen - Admin configuration and preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // Notification settings
  bool _emailNotifications = true;
  bool _pushNotifications = false;
  bool _userActivityAlerts = true;
  bool _systemAlerts = true;

  // Display settings
  bool _darkMode = false;
  String _language = 'en';
  String _timezone = 'Africa/Nairobi';

  // Privacy settings
  bool _activityLogging = true;
  bool _analyticsTracking = true;

  @override
  Widget build(BuildContext context) {
    final adminUser = ref.watch(currentAdminUserProvider);

    // Content is wrapped by AdminShell via ShellRoute
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 32),

            // Settings Sections
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                Expanded(
                  child: Column(
                    children: [
                      _buildProfileSection(adminUser),
                      const SizedBox(height: 24),
                      _buildNotificationSettings(),
                      const SizedBox(height: 24),
                      _buildDisplaySettings(),
                    ],
                  ),
                ),
                const SizedBox(width: 24),

                // Right Column
                Expanded(
                  child: Column(
                    children: [
                      _buildSecuritySettings(),
                      const SizedBox(height: 24),
                      _buildPrivacySettings(),
                      const SizedBox(height: 24),
                      _buildDangerZone(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account settings and preferences',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(dynamic adminUser) {
    return _buildSettingsCard(
      title: 'Profile',
      icon: Icons.person,
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              adminUser?.displayName?.substring(0, 1).toUpperCase() ?? 'A',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(adminUser?.displayName ?? 'Admin User'),
          subtitle: Text(adminUser?.email ?? 'admin@flow.com'),
          trailing: TextButton(
            onPressed: () {
              // TODO: Navigate to profile edit
            },
            child: const Text('Edit'),
          ),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.badge, color: AppColors.textSecondary),
          title: const Text('Role'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Super Admin',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsCard(
      title: 'Notifications',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text('Email Notifications'),
          subtitle: const Text('Receive notifications via email'),
          value: _emailNotifications,
          onChanged: (value) {
            setState(() => _emailNotifications = value);
          },
        ),
        SwitchListTile(
          title: const Text('Push Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
          },
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('User Activity Alerts'),
          subtitle: const Text('Get notified about user registrations and activities'),
          value: _userActivityAlerts,
          onChanged: (value) {
            setState(() => _userActivityAlerts = value);
          },
        ),
        SwitchListTile(
          title: const Text('System Alerts'),
          subtitle: const Text('Get notified about system issues and updates'),
          value: _systemAlerts,
          onChanged: (value) {
            setState(() => _systemAlerts = value);
          },
        ),
      ],
    );
  }

  Widget _buildDisplaySettings() {
    return _buildSettingsCard(
      title: 'Display',
      icon: Icons.palette,
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Use dark theme'),
          value: _darkMode,
          onChanged: (value) {
            setState(() => _darkMode = value);
            // TODO: Apply theme change
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.language, color: AppColors.textSecondary),
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: _language,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'sw', child: Text('Swahili')),
              DropdownMenuItem(value: 'fr', child: Text('French')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _language = value);
              }
            },
          ),
        ),
        ListTile(
          leading: Icon(Icons.access_time, color: AppColors.textSecondary),
          title: const Text('Timezone'),
          trailing: DropdownButton<String>(
            value: _timezone,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'Africa/Nairobi', child: Text('Nairobi (EAT)')),
              DropdownMenuItem(value: 'Africa/Lagos', child: Text('Lagos (WAT)')),
              DropdownMenuItem(value: 'Africa/Cairo', child: Text('Cairo (EET)')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() => _timezone = value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return _buildSettingsCard(
      title: 'Security',
      icon: Icons.security,
      children: [
        ListTile(
          leading: Icon(Icons.lock, color: AppColors.textSecondary),
          title: const Text('Change Password'),
          subtitle: const Text('Last changed 30 days ago'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to change password
          },
        ),
        ListTile(
          leading: Icon(Icons.phone_android, color: AppColors.textSecondary),
          title: const Text('Two-Factor Authentication'),
          subtitle: const Text('Not enabled'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to 2FA setup
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.devices, color: AppColors.textSecondary),
          title: const Text('Active Sessions'),
          subtitle: const Text('Manage your active login sessions'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to sessions management
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySettings() {
    return _buildSettingsCard(
      title: 'Privacy',
      icon: Icons.privacy_tip,
      children: [
        SwitchListTile(
          title: const Text('Activity Logging'),
          subtitle: const Text('Log your admin actions for audit purposes'),
          value: _activityLogging,
          onChanged: (value) {
            setState(() => _activityLogging = value);
          },
        ),
        SwitchListTile(
          title: const Text('Analytics Tracking'),
          subtitle: const Text('Help improve the platform with usage data'),
          value: _analyticsTracking,
          onChanged: (value) {
            setState(() => _analyticsTracking = value);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.download, color: AppColors.textSecondary),
          title: const Text('Download My Data'),
          subtitle: const Text('Export all your personal data'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Trigger data export
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return _buildSettingsCard(
      title: 'Danger Zone',
      icon: Icons.warning,
      iconColor: AppColors.error,
      children: [
        ListTile(
          leading: Icon(Icons.logout, color: AppColors.error),
          title: Text(
            'Sign Out',
            style: TextStyle(color: AppColors.error),
          ),
          subtitle: const Text('Sign out from this device'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final confirmed = await showDialog<bool>(
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
                    ),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              // TODO: Implement logout
              ref.read(adminAuthProvider.notifier).logout();
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_forever, color: AppColors.error),
          title: Text(
            'Delete Account',
            style: TextStyle(color: AppColors.error),
          ),
          subtitle: const Text('Permanently delete your admin account'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Show delete account confirmation
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    Color? iconColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
