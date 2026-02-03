import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
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
          context.l10n.adminSettingsTitle,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.adminSettingsSubtitle,
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
      title: context.l10n.adminSettingsProfile,
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
          title: Text(adminUser?.displayName ?? context.l10n.adminSettingsDefaultUser),
          subtitle: Text(adminUser?.email ?? 'admin@flow.com'),
          trailing: TextButton(
            onPressed: () {
              // TODO: Navigate to profile edit
            },
            child: Text(context.l10n.adminSettingsEdit),
          ),
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.badge, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsRole),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              context.l10n.adminSettingsSuperAdmin,
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
      title: context.l10n.adminSettingsNotifications,
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: Text(context.l10n.adminSettingsEmailNotifications),
          subtitle: Text(context.l10n.adminSettingsEmailNotificationsDesc),
          value: _emailNotifications,
          onChanged: (value) {
            setState(() => _emailNotifications = value);
          },
        ),
        SwitchListTile(
          title: Text(context.l10n.adminSettingsPushNotifications),
          subtitle: Text(context.l10n.adminSettingsPushNotificationsDesc),
          value: _pushNotifications,
          onChanged: (value) {
            setState(() => _pushNotifications = value);
          },
        ),
        const Divider(),
        SwitchListTile(
          title: Text(context.l10n.adminSettingsUserActivityAlerts),
          subtitle: Text(context.l10n.adminSettingsUserActivityAlertsDesc),
          value: _userActivityAlerts,
          onChanged: (value) {
            setState(() => _userActivityAlerts = value);
          },
        ),
        SwitchListTile(
          title: Text(context.l10n.adminSettingsSystemAlerts),
          subtitle: Text(context.l10n.adminSettingsSystemAlertsDesc),
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
      title: context.l10n.adminSettingsDisplay,
      icon: Icons.palette,
      children: [
        SwitchListTile(
          title: Text(context.l10n.adminSettingsDarkMode),
          subtitle: Text(context.l10n.adminSettingsDarkModeDesc),
          value: _darkMode,
          onChanged: (value) {
            setState(() => _darkMode = value);
            // TODO: Apply theme change
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.language, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsLanguage),
          trailing: DropdownButton<String>(
            value: _language,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: 'en', child: Text(context.l10n.adminSettingsLangEnglish)),
              DropdownMenuItem(value: 'sw', child: Text(context.l10n.adminSettingsLangSwahili)),
              DropdownMenuItem(value: 'fr', child: Text(context.l10n.adminSettingsLangFrench)),
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
          title: Text(context.l10n.adminSettingsTimezone),
          trailing: DropdownButton<String>(
            value: _timezone,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: 'Africa/Nairobi', child: Text(context.l10n.adminSettingsTimezoneNairobi)),
              DropdownMenuItem(value: 'Africa/Lagos', child: Text(context.l10n.adminSettingsTimezoneLagos)),
              DropdownMenuItem(value: 'Africa/Cairo', child: Text(context.l10n.adminSettingsTimezoneCairo)),
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
      title: context.l10n.adminSettingsSecurity,
      icon: Icons.security,
      children: [
        ListTile(
          leading: Icon(Icons.lock, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsChangePassword),
          subtitle: Text(context.l10n.adminSettingsChangePasswordDesc),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to change password
          },
        ),
        ListTile(
          leading: Icon(Icons.phone_android, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsTwoFactor),
          subtitle: Text(context.l10n.adminSettingsTwoFactorDesc),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to 2FA setup
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.devices, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsActiveSessions),
          subtitle: Text(context.l10n.adminSettingsActiveSessionsDesc),
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
      title: context.l10n.adminSettingsPrivacy,
      icon: Icons.privacy_tip,
      children: [
        SwitchListTile(
          title: Text(context.l10n.adminSettingsActivityLogging),
          subtitle: Text(context.l10n.adminSettingsActivityLoggingDesc),
          value: _activityLogging,
          onChanged: (value) {
            setState(() => _activityLogging = value);
          },
        ),
        SwitchListTile(
          title: Text(context.l10n.adminSettingsAnalyticsTracking),
          subtitle: Text(context.l10n.adminSettingsAnalyticsTrackingDesc),
          value: _analyticsTracking,
          onChanged: (value) {
            setState(() => _analyticsTracking = value);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.download, color: AppColors.textSecondary),
          title: Text(context.l10n.adminSettingsDownloadData),
          subtitle: Text(context.l10n.adminSettingsDownloadDataDesc),
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
      title: context.l10n.adminSettingsDangerZone,
      icon: Icons.warning,
      iconColor: AppColors.error,
      children: [
        ListTile(
          leading: Icon(Icons.logout, color: AppColors.error),
          title: Text(
            context.l10n.adminSettingsSignOut,
            style: TextStyle(color: AppColors.error),
          ),
          subtitle: Text(context.l10n.adminSettingsSignOutDesc),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(context.l10n.adminSettingsSignOut),
                content: Text(context.l10n.adminSettingsSignOutConfirm),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(context.l10n.adminSettingsCancel),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: Text(context.l10n.adminSettingsSignOut),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              // TODO: Implement logout
              ref.read(adminAuthProvider.notifier).signOut();
            }
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_forever, color: AppColors.error),
          title: Text(
            context.l10n.adminSettingsDeleteAccount,
            style: TextStyle(color: AppColors.error),
          ),
          subtitle: Text(context.l10n.adminSettingsDeleteAccountDesc),
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
