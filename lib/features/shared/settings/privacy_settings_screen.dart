import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/settings_widgets.dart';

/// Privacy & Security Settings Screen
///
/// Allows users to manage privacy and security settings:
/// - Data sharing preferences
/// - Profile visibility
/// - Two-factor authentication
/// - Biometric authentication
/// - Password management
/// - Session management
///
/// Backend Integration TODO:
/// - Update privacy preferences on backend
/// - Enable/disable 2FA
/// - Manage active sessions
/// - Data export/deletion requests

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profilePublic = true;
  bool _showEmail = false;
  bool _showPhone = false;
  bool _shareProgress = true;
  bool _allowMessagesFromAnyone = false;
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Privacy & Security'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Privacy Section
          SettingsSectionHeader(
            title: 'PROFILE PRIVACY',
            subtitle: 'Control who can see your profile information',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.public,
                title: 'Public Profile',
                subtitle: 'Allow anyone to view your profile',
                value: _profilePublic,
                onChanged: (value) {
                  setState(() {
                    _profilePublic = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.email,
                title: 'Show Email',
                subtitle: 'Display email on your profile',
                value: _showEmail,
                onChanged: (value) {
                  setState(() {
                    _showEmail = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.phone,
                title: 'Show Phone Number',
                subtitle: 'Display phone number on your profile',
                value: _showPhone,
                onChanged: (value) {
                  setState(() {
                    _showPhone = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.analytics,
                title: 'Share Progress',
                subtitle: 'Share your learning progress with counselors',
                value: _shareProgress,
                onChanged: (value) {
                  setState(() {
                    _shareProgress = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Communication Privacy Section
          SettingsSectionHeader(
            title: 'COMMUNICATION',
            subtitle: 'Manage who can contact you',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.message,
                title: 'Allow Messages from Anyone',
                subtitle: 'Anyone can send you messages',
                value: _allowMessagesFromAnyone,
                onChanged: (value) {
                  setState(() {
                    _allowMessagesFromAnyone = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Security Section
          SettingsSectionHeader(
            title: 'SECURITY',
            subtitle: 'Protect your account',
          ),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.lock,
                title: 'Change Password',
                subtitle: 'Update your account password',
                onTap: () {
                  context.push('/settings/change-password');
                },
              ),
              SettingsSwitchTile(
                icon: Icons.security,
                title: 'Two-Factor Authentication',
                subtitle: _twoFactorEnabled ? 'Enabled' : 'Recommended',
                value: _twoFactorEnabled,
                iconColor: _twoFactorEnabled ? AppColors.success : AppColors.warning,
                onChanged: (value) {
                  if (value) {
                    _showEnableTwoFactorDialog();
                  } else {
                    _showDisableTwoFactorDialog();
                  }
                },
              ),
              SettingsSwitchTile(
                icon: Icons.fingerprint,
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID',
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                  // TODO: Enable biometric authentication
                },
              ),
              SettingsTile(
                icon: Icons.devices,
                title: 'Active Sessions',
                subtitle: 'Manage devices signed in to your account',
                onTap: () {
                  _showActiveSessionsDialog();
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Data & Privacy Section
          SettingsSectionHeader(
            title: 'DATA & PRIVACY',
            subtitle: 'Control your data',
          ),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.download,
                title: 'Download My Data',
                subtitle: 'Request a copy of your data',
                onTap: () {
                  _showDownloadDataDialog();
                },
              ),
              SettingsTile(
                icon: Icons.policy,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {
                  // TODO: Open privacy policy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Privacy policy coming soon'),
                    ),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.gavel,
                title: 'Terms of Service',
                subtitle: 'Read our terms of service',
                onTap: () {
                  // TODO: Open terms of service
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of service coming soon'),
                    ),
                  );
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Danger Zone
          SettingsSectionHeader(
            title: 'ACCOUNT ACTIONS',
            subtitle: 'Irreversible actions',
          ),
          DangerZone(
            actions: [
              DangerAction(
                title: 'Delete Account',
                subtitle: 'Permanently delete your account and data',
                icon: Icons.delete_forever,
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEnableTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enable Two-Factor Authentication'),
        content: const Text(
          'Two-factor authentication adds an extra layer of security to your account. You\'ll need to enter a code from your phone in addition to your password when signing in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = true;
              });
              // TODO: Show 2FA setup screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('2FA setup screen - Backend integration required'),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showDisableTwoFactorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disable Two-Factor Authentication'),
        content: const Text(
          'Are you sure you want to disable two-factor authentication? This will make your account less secure.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Active Sessions'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              _SessionTile(
                device: 'iPhone 13 Pro',
                location: 'Nairobi, Kenya',
                lastActive: 'Active now',
                isCurrent: true,
              ),
              _SessionTile(
                device: 'MacBook Pro',
                location: 'Nairobi, Kenya',
                lastActive: '2 hours ago',
                isCurrent: false,
                onRevoke: () {
                  // TODO: Revoke session
                },
              ),
              _SessionTile(
                device: 'Chrome on Windows',
                location: 'Mombasa, Kenya',
                lastActive: '3 days ago',
                isCurrent: false,
                onRevoke: () {
                  // TODO: Revoke session
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Revoke all sessions
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All other sessions revoked'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Revoke All'),
          ),
        ],
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Your Data'),
        content: const Text(
          'We\'ll prepare a copy of your data and send it to your email address. This may take up to 24 hours.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Request data download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Request'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you absolutely sure? This action cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showDeleteConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type "DELETE" to confirm account deletion:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'DELETE',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text == 'DELETE') {
                Navigator.pop(context);
                // TODO: Delete account
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion - Backend integration required'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please type DELETE to confirm'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final String device;
  final String location;
  final String lastActive;
  final bool isCurrent;
  final VoidCallback? onRevoke;

  const _SessionTile({
    required this.device,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
    this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isCurrent ? AppColors.primary : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getDeviceIcon(),
            color: isCurrent ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  lastActive,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (!isCurrent && onRevoke != null)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              color: AppColors.error,
              onPressed: onRevoke,
            ),
        ],
      ),
    );
  }

  IconData _getDeviceIcon() {
    if (device.contains('iPhone') || device.contains('Android')) {
      return Icons.phone_android;
    } else if (device.contains('MacBook') || device.contains('Laptop')) {
      return Icons.laptop;
    } else if (device.contains('iPad') || device.contains('Tablet')) {
      return Icons.tablet;
    } else {
      return Icons.computer;
    }
  }
}
