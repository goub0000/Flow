import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../../authentication/providers/auth_provider.dart';
import '../widgets/settings_widgets.dart';
import 'appearance_settings_screen.dart';
import 'privacy_settings_screen.dart';
import 'language_settings_screen.dart';
import 'data_storage_settings_screen.dart';
import '../help/presentation/help_center_screen.dart';
import 'subscriptions_screen.dart';
import 'study_schedule_screen.dart';
import 'progress_reports_screen.dart';
import 'contact_support_screen.dart';
import 'bug_report_screen.dart';
import 'send_feedback_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Quick Settings Section
        SettingsSectionHeader(
          title: 'QUICK SETTINGS',
          subtitle: 'Frequently used settings',
        ),
        SettingsCard(
          children: [
            SettingsSwitchTile(
              icon: Icons.notifications,
              title: 'Push Notifications',
              subtitle: 'Receive app notifications',
              value: _pushNotifications,
              onChanged: (value) {
                setState(() => _pushNotifications = value);
                // TODO: Update notification preferences
              },
            ),
            SettingsSwitchTile(
              icon: Icons.email,
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() => _emailNotifications = value);
                // TODO: Update notification preferences
              },
            ),
            SettingsSwitchTile(
              icon: Icons.sms,
              title: 'SMS Notifications',
              subtitle: 'Receive SMS alerts',
              value: _smsNotifications,
              onChanged: (value) {
                setState(() => _smsNotifications = value);
                // TODO: Update notification preferences
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Preferences Section
        SettingsSectionHeader(
          title: 'PREFERENCES',
          subtitle: 'Customize your experience',
        ),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.palette,
              title: 'Appearance',
              subtitle: 'Theme, colors, and display',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppearanceSettingsScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.language,
              title: 'Language & Region',
              subtitle: 'English, Kenya',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LanguageSettingsScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.storage,
              title: 'Data & Storage',
              subtitle: 'Manage downloads and cache',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DataStorageSettingsScreen(),
                  ),
                );
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Account Section
        SettingsSectionHeader(
          title: 'ACCOUNT',
          subtitle: 'Manage your account settings',
        ),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.person,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                Navigator.pushNamed(context, '/profile/edit');
              },
            ),
            SettingsTile(
              icon: Icons.lock,
              title: 'Privacy & Security',
              subtitle: 'Control your privacy settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacySettingsScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.payment,
              title: 'Payment Methods',
              subtitle: 'Manage payment options',
              onTap: () {
                Navigator.pushNamed(context, '/payments/history');
              },
            ),
            SettingsTile(
              icon: Icons.subscriptions,
              title: 'Subscriptions',
              subtitle: 'View and manage subscriptions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionsScreen(),
                  ),
                );
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Learning Preferences Section
        SettingsSectionHeader(
          title: 'LEARNING',
          subtitle: 'Customize your learning experience',
        ),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.calendar_today,
              title: 'Study Schedule',
              subtitle: 'Set reminders and goals',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudyScheduleScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.analytics,
              title: 'Progress Reports',
              subtitle: 'View your learning analytics',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgressReportsScreen(),
                  ),
                );
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Support Section
        SettingsSectionHeader(
          title: 'SUPPORT',
          subtitle: 'Get help and provide feedback',
        ),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.help,
              title: 'Help Center',
              subtitle: 'Browse help articles',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpCenterScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.contact_support,
              title: 'Contact Support',
              subtitle: 'Get in touch with our team',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactSupportScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.bug_report,
              title: 'Report a Bug',
              subtitle: 'Help us improve',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BugReportScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.feedback,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SendFeedbackScreen(),
                  ),
                );
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Legal Section
        SettingsSectionHeader(
          title: 'LEGAL',
        ),
        SettingsCard(
          children: [
            SettingsTile(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.cookie,
              title: 'Cookie Settings',
              subtitle: 'Manage cookie preferences',
              onTap: () {
                final userId = ref.read(authProvider).user?.id ?? 'anonymous';
                context.push('/settings/cookies?userId=$userId');
              },
            ),
            SettingsTile(
              icon: Icons.description,
              title: 'Terms of Service',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServiceScreen(),
                  ),
                );
              },
            ),
            SettingsTile(
              icon: Icons.gavel,
              title: 'Licenses',
              subtitle: 'Open source licenses',
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Flow',
                  applicationVersion: '1.0.0',
                );
              },
              showDivider: false,
            ),
          ],
        ),
        const SizedBox(height: 24),

        // About Section
        SettingsSectionHeader(
          title: 'ABOUT',
        ),
        const AboutAppInfo(
          appName: 'Flow',
          version: '1.0.0',
          buildNumber: '1',
        ),
        const SizedBox(height: 24),

        // Logout Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              _showLogoutDialog();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authProvider.notifier).signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
