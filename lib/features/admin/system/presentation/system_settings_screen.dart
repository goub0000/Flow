import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/constants/country_data.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_system_provider.dart';

/// System Settings Screen - Configure system-wide settings
///
/// Features:
/// - Application configuration
/// - Feature flag management
/// - API and integration settings
/// - Email/SMS provider settings
/// - Security configuration
/// - Backup settings
/// - Payment gateway configuration
class SystemSettingsScreen extends ConsumerStatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  ConsumerState<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends ConsumerState<SystemSettingsScreen> {
  String _selectedTab = 'general';

  /// Local editable copy of all settings (key -> value).
  final Map<String, dynamic> _localSettings = {};

  /// Whether any setting has been changed since the last save / load.
  bool _isDirty = false;

  /// Whether a save operation is in progress.
  bool _isSaving = false;

  /// Whether the local settings have been seeded from the provider yet.
  bool _seeded = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────

  void _seedFromProvider(AdminSystemState systemState) {
    if (_seeded) return;
    _seeded = true;
    for (final entry in systemState.settings.entries) {
      _localSettings[entry.key] = entry.value.value;
    }
  }

  void _updateLocal(String key, dynamic value) {
    setState(() {
      _localSettings[key] = value;
      _isDirty = true;
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    final success = await ref
        .read(adminSystemProvider.notifier)
        .batchUpdateSettings(Map<String, dynamic>.from(_localSettings));

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      setState(() => _isDirty = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Settings saved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save settings'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final systemState = ref.watch(adminSystemProvider);
    _seedFromProvider(systemState);

    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        _buildHeader(),
        const SizedBox(height: 24),

        // Settings Content
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar Navigation
              _buildSidebar(),
              const SizedBox(width: 24),

              // Settings Panel
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _buildSettingsPanel(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.settings,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'System Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Configure system-wide application settings',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (_isDirty)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Text(
                    'Unsaved changes',
                    style: TextStyle(
                      color: AppColors.warning,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              // View Audit Logs button
              PermissionGuard(
                permission: AdminPermission.viewAuditLogs,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to audit logs with settings filter
                  },
                  icon: const Icon(Icons.history, size: 20),
                  label: const Text('View Audit Logs'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildNavItem(
            'general',
            'General',
            Icons.settings_outlined,
          ),
          _buildNavItem(
            'features',
            'Feature Flags',
            Icons.flag_outlined,
          ),
          _buildNavItem(
            'api',
            'API & Integrations',
            Icons.api_outlined,
          ),
          _buildNavItem(
            'email',
            'Email Settings',
            Icons.email_outlined,
          ),
          _buildNavItem(
            'sms',
            'SMS Settings',
            Icons.sms_outlined,
          ),
          _buildNavItem(
            'payment',
            'Payment Gateways',
            Icons.payment_outlined,
          ),
          _buildNavItem(
            'security',
            'Security',
            Icons.security_outlined,
          ),
          _buildNavItem(
            'backup',
            'Backup & Recovery',
            Icons.backup_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String id, String label, IconData icon) {
    final isSelected = _selectedTab == id;

    return InkWell(
      onTap: () {
        setState(() => _selectedTab = id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    switch (_selectedTab) {
      case 'general':
        return _buildGeneralSettings();
      case 'features':
        return _buildFeatureFlags();
      case 'api':
        return _buildAPISettings();
      case 'email':
        return _buildEmailSettings();
      case 'sms':
        return _buildSMSSettings();
      case 'payment':
        return _buildPaymentSettings();
      case 'security':
        return _buildSecuritySettings();
      case 'backup':
        return _buildBackupSettings();
      default:
        return _buildGeneralSettings();
    }
  }

  // ── Tab panels ─────────────────────────────────────────────────────────

  Widget _buildGeneralSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure basic application settings',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'Application',
            [
              _buildTextSetting(
                'app_name',
                'Application Name',
                'Flow Education Platform',
                'The name displayed throughout the application',
              ),
              _buildTextSetting(
                'support_email',
                'Support Email',
                'support@flow.edu',
                'Email address for user support inquiries',
              ),
              _buildTextSetting(
                'support_phone',
                'Support Phone',
                '+254 123 456 789',
                'Phone number for user support',
              ),
            ],
          ),

          _buildSettingSection(
            'Regional',
            [
              _buildDropdownSetting(
                'default_region',
                'Default Region',
                'Kenya',
                allCountries,
                'Default region for new users',
                onChanged: (value) {
                  if (value == null) return;
                  _updateLocal('default_region', value);
                  // Auto-select currency based on country
                  final currency = countryCurrencyMap[value];
                  if (currency != null) {
                    _updateLocal('currency', currency);
                  }
                },
              ),
              _buildDropdownSetting(
                'currency',
                'Default Currency',
                'KES',
                allCurrencies,
                'Default currency for transactions',
              ),
              _buildDropdownSetting(
                'default_language',
                'Default Language',
                'English',
                ['English', 'Swahili', 'French'],
                'Default application language',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildFeatureFlags() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Feature Flags',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enable or disable platform features',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'User Features',
            [
              _buildToggleSetting(
                'allow_registration',
                'User Registration',
                true,
                'Allow new users to register accounts',
              ),
              _buildToggleSetting(
                'social_login',
                'Social Login',
                false,
                'Enable login with Google, Facebook, etc.',
              ),
              _buildToggleSetting(
                'require_email_verification',
                'Email Verification',
                true,
                'Require email verification for new accounts',
              ),
            ],
          ),

          _buildSettingSection(
            'Application Features',
            [
              _buildToggleSetting(
                'application_submissions',
                'Application Submissions',
                true,
                'Allow users to submit scholarship applications',
              ),
              _buildToggleSetting(
                'enable_recommendations',
                'Recommendations',
                true,
                'Enable recommendation system',
              ),
              _buildToggleSetting(
                'document_upload',
                'Document Upload',
                true,
                'Allow users to upload documents',
              ),
              _buildToggleSetting(
                'enable_payments',
                'Payment Processing',
                true,
                'Enable payment processing for fees',
              ),
            ],
          ),

          _buildSettingSection(
            'Communication',
            [
              _buildToggleSetting(
                'email_notifications',
                'Email Notifications',
                true,
                'Send email notifications to users',
              ),
              _buildToggleSetting(
                'sms_notifications',
                'SMS Notifications',
                false,
                'Send SMS notifications to users',
              ),
              _buildToggleSetting(
                'push_notifications',
                'Push Notifications',
                true,
                'Send push notifications to mobile apps',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildAPISettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API & Integration Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure API endpoints and third-party integrations',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'API Configuration',
            [
              _buildTextSetting(
                'api_base_url',
                'API Base URL',
                'https://api.flow.edu',
                'Base URL for API endpoints',
              ),
              _buildTextSetting(
                'api_version',
                'API Version',
                'v1',
                'Current API version',
              ),
              _buildToggleSetting(
                'api_rate_limiting',
                'API Rate Limiting',
                true,
                'Enable rate limiting for API requests',
              ),
            ],
          ),

          _buildSettingSection(
            'Third-Party Services',
            [
              _buildTextSetting(
                'google_analytics_id',
                'Google Analytics ID',
                'UA-XXXXXXXXX-X',
                'Google Analytics tracking ID',
              ),
              _buildTextSetting(
                'sentry_dsn',
                'Sentry DSN',
                'https://xxx@sentry.io/xxx',
                'Sentry error tracking DSN',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildEmailSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure email service provider and templates',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'Email Provider',
            [
              _buildDropdownSetting(
                'email_service',
                'Email Service',
                'SendGrid',
                ['SendGrid', 'AWS SES', 'Mailgun', 'SMTP'],
                'Email service provider',
              ),
              _buildTextSetting(
                'email_api_key',
                'API Key',
                '',
                'Email service API key',
                obscureText: true,
              ),
              _buildTextSetting(
                'from_email',
                'From Email',
                'noreply@flow.edu',
                'Default sender email address',
              ),
              _buildTextSetting(
                'from_name',
                'From Name',
                'Flow Education',
                'Default sender name',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSMSSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SMS Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure SMS service provider',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'SMS Provider',
            [
              _buildDropdownSetting(
                'sms_service',
                'SMS Service',
                'AfricasTalking',
                ['AfricasTalking', 'Twilio', 'Nexmo'],
                'SMS service provider',
              ),
              _buildTextSetting(
                'sms_api_key',
                'API Key',
                '',
                'SMS service API key',
                obscureText: true,
              ),
              _buildTextSetting(
                'sms_sender_id',
                'Sender ID',
                'FLOW_EDU',
                'SMS sender ID/shortcode',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildPaymentSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Gateway Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure payment processing providers',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'M-Pesa (Kenya)',
            [
              _buildToggleSetting(
                'enable_mpesa',
                'Enable M-Pesa',
                true,
                'Accept M-Pesa payments',
              ),
              _buildTextSetting(
                'mpesa_consumer_key',
                'Consumer Key',
                '',
                'M-Pesa consumer key',
                obscureText: true,
              ),
              _buildTextSetting(
                'mpesa_consumer_secret',
                'Consumer Secret',
                '',
                'M-Pesa consumer secret',
                obscureText: true,
              ),
              _buildTextSetting(
                'mpesa_shortcode',
                'Shortcode',
                '174379',
                'M-Pesa paybill/till number',
              ),
            ],
          ),

          _buildSettingSection(
            'Card Payments',
            [
              _buildToggleSetting(
                'enable_card_payments',
                'Enable Card Payments',
                true,
                'Accept credit/debit card payments',
              ),
              _buildDropdownSetting(
                'payment_gateway',
                'Payment Processor',
                'Stripe',
                ['Stripe', 'Paystack', 'Flutterwave'],
                'Card payment processor',
              ),
              _buildTextSetting(
                'payment_publishable_key',
                'Publishable Key',
                '',
                'Payment processor publishable key',
              ),
              _buildTextSetting(
                'payment_secret_key',
                'Secret Key',
                '',
                'Payment processor secret key',
                obscureText: true,
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure security and authentication settings',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'Authentication',
            [
              _buildToggleSetting(
                'require_mfa_admins',
                'Require MFA for Admins',
                true,
                'Require multi-factor authentication for admin accounts',
              ),
              _buildToggleSetting(
                'require_mfa_users',
                'Require MFA for Users',
                false,
                'Require multi-factor authentication for all users',
              ),
              _buildDropdownSetting(
                'session_timeout',
                'Session Timeout',
                '30 minutes',
                ['15 minutes', '30 minutes', '1 hour', '2 hours'],
                'Automatic logout after inactivity',
              ),
              _buildDropdownSetting(
                'password_min_length',
                'Password Min Length',
                '8 characters',
                ['6 characters', '8 characters', '10 characters', '12 characters'],
                'Minimum password length',
              ),
            ],
          ),

          _buildSettingSection(
            'Data Protection',
            [
              _buildToggleSetting(
                'encrypt_sensitive_data',
                'Encrypt Sensitive Data',
                true,
                'Encrypt sensitive data at rest',
              ),
              _buildToggleSetting(
                'gdpr_compliance',
                'GDPR Compliance Mode',
                true,
                'Enable GDPR compliance features',
              ),
              _buildDropdownSetting(
                'data_retention_period',
                'Data Retention Period',
                '7 years',
                ['1 year', '3 years', '5 years', '7 years', '10 years'],
                'How long to retain user data',
              ),
            ],
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildBackupSettings() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Backup & Recovery Settings',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure automated backups and disaster recovery',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            'Backup Configuration',
            [
              _buildToggleSetting(
                'enable_auto_backups',
                'Enable Automated Backups',
                true,
                'Automatically backup database and files',
              ),
              _buildDropdownSetting(
                'backup_frequency',
                'Backup Frequency',
                'Daily',
                ['Hourly', 'Every 6 hours', 'Daily', 'Weekly'],
                'How often to create backups',
              ),
              _buildDropdownSetting(
                'backup_retention',
                'Backup Retention',
                '30 days',
                ['7 days', '14 days', '30 days', '90 days', '1 year'],
                'How long to keep backups',
              ),
              _buildTextSetting(
                'backup_storage_location',
                'Backup Storage Location',
                'AWS S3 - us-east-1',
                'Where backups are stored',
              ),
            ],
          ),

          _buildSettingSection(
            'Last Backup',
            [
              _buildInfoRow('Last Successful Backup', 'Today at 2:00 AM'),
              _buildInfoRow('Backup Size', '2.3 GB'),
              _buildInfoRow('Status', 'Healthy'),
            ],
          ),

          const SizedBox(height: 16),
          PermissionGuard(
            permission: AdminPermission.manageDatabaseBackups,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Trigger manual backup
              },
              icon: const Icon(Icons.backup, size: 20),
              label: const Text('Create Backup Now'),
            ),
          ),

          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  // ── Shared setting widgets ─────────────────────────────────────────────

  Widget _buildSettingSection(String title, List<Widget> settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: settings
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final setting = entry.value;
                  return Column(
                    children: [
                      setting,
                      if (index < settings.length - 1)
                        Divider(height: 1, color: AppColors.border),
                    ],
                  );
                })
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextSetting(
    String settingKey,
    String label,
    String defaultValue,
    String description, {
    bool obscureText = false,
  }) {
    final currentValue = _localSettings[settingKey]?.toString() ?? defaultValue;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 300,
                child: TextFormField(
                  key: ValueKey('$settingKey-$currentValue'),
                  initialValue: currentValue,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  style: const TextStyle(fontSize: 13),
                  onChanged: (v) => _updateLocal(settingKey, v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String settingKey,
    String label,
    String defaultValue,
    List<String> options,
    String description, {
    ValueChanged<String?>? onChanged,
  }) {
    final currentValue = (_localSettings[settingKey]?.toString()) ?? defaultValue;
    // Ensure the current value is in the options list; if not fall back to default.
    final effectiveValue = options.contains(currentValue) ? currentValue : defaultValue;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 300,
            child: DropdownButtonFormField<String>(
              value: effectiveValue,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              isExpanded: true,
              items: options
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option, style: const TextStyle(fontSize: 13)),
                      ))
                  .toList(),
              onChanged: onChanged ?? (value) {
                if (value != null) _updateLocal(settingKey, value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSetting(
    String settingKey,
    String label,
    bool defaultValue,
    String description,
  ) {
    final currentValue = _localSettings[settingKey] is bool
        ? _localSettings[settingKey] as bool
        : defaultValue;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: currentValue,
            onChanged: (newValue) => _updateLocal(settingKey, newValue),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return PermissionGuard(
      permission: AdminPermission.manageSystemSettings,
      child: ElevatedButton.icon(
        onPressed: (_isDirty && !_isSaving) ? _save : null,
        icon: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.save, size: 20),
        label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
      ),
    );
  }
}
