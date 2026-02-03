import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/constants/country_data.dart';
import '../../../../core/l10n_extension.dart';
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
          content: Text(context.l10n.adminSystemSettingsSavedSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminSystemSettingsSavedError),
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
                    context.l10n.adminSystemSettingsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminSystemSettingsSubtitle,
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
                    context.l10n.adminSystemUnsavedChanges,
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
                  label: Text(context.l10n.adminSystemViewAuditLogs),
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
            context.l10n.adminSystemNavGeneral,
            Icons.settings_outlined,
          ),
          _buildNavItem(
            'features',
            context.l10n.adminSystemNavFeatureFlags,
            Icons.flag_outlined,
          ),
          _buildNavItem(
            'api',
            context.l10n.adminSystemNavApiIntegrations,
            Icons.api_outlined,
          ),
          _buildNavItem(
            'email',
            context.l10n.adminSystemNavEmailSettings,
            Icons.email_outlined,
          ),
          _buildNavItem(
            'sms',
            context.l10n.adminSystemNavSmsSettings,
            Icons.sms_outlined,
          ),
          _buildNavItem(
            'payment',
            context.l10n.adminSystemNavPaymentGateways,
            Icons.payment_outlined,
          ),
          _buildNavItem(
            'security',
            context.l10n.adminSystemNavSecurity,
            Icons.security_outlined,
          ),
          _buildNavItem(
            'backup',
            context.l10n.adminSystemNavBackupRecovery,
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
            context.l10n.adminSystemGeneralSettingsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemGeneralSettingsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionApplication,
            [
              _buildTextSetting(
                'app_name',
                context.l10n.adminSystemApplicationName,
                'Flow Education Platform',
                context.l10n.adminSystemApplicationNameDesc,
              ),
              _buildTextSetting(
                'support_email',
                context.l10n.adminSystemSupportEmail,
                'support@flow.edu',
                context.l10n.adminSystemSupportEmailDesc,
              ),
              _buildTextSetting(
                'support_phone',
                context.l10n.adminSystemSupportPhone,
                '+254 123 456 789',
                context.l10n.adminSystemSupportPhoneDesc,
              ),
            ],
          ),

          _buildSettingSection(
            context.l10n.adminSystemSectionRegional,
            [
              _buildDropdownSetting(
                'default_region',
                context.l10n.adminSystemDefaultRegion,
                'Kenya',
                allCountries,
                context.l10n.adminSystemDefaultRegionDesc,
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
                context.l10n.adminSystemDefaultCurrency,
                'KES',
                allCurrencies,
                context.l10n.adminSystemDefaultCurrencyDesc,
              ),
              _buildDropdownSetting(
                'default_language',
                context.l10n.adminSystemDefaultLanguage,
                'English',
                ['English', 'Swahili', 'French'],
                context.l10n.adminSystemDefaultLanguageDesc,
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
            context.l10n.adminSystemFeatureFlagsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemFeatureFlagsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionUserFeatures,
            [
              _buildToggleSetting(
                'allow_registration',
                context.l10n.adminSystemUserRegistration,
                true,
                context.l10n.adminSystemUserRegistrationDesc,
              ),
              _buildToggleSetting(
                'social_login',
                context.l10n.adminSystemSocialLogin,
                false,
                context.l10n.adminSystemSocialLoginDesc,
              ),
              _buildToggleSetting(
                'require_email_verification',
                context.l10n.adminSystemEmailVerification,
                true,
                context.l10n.adminSystemEmailVerificationDesc,
              ),
            ],
          ),

          _buildSettingSection(
            context.l10n.adminSystemSectionApplicationFeatures,
            [
              _buildToggleSetting(
                'application_submissions',
                context.l10n.adminSystemApplicationSubmissions,
                true,
                context.l10n.adminSystemApplicationSubmissionsDesc,
              ),
              _buildToggleSetting(
                'enable_recommendations',
                context.l10n.adminSystemRecommendations,
                true,
                context.l10n.adminSystemRecommendationsDesc,
              ),
              _buildToggleSetting(
                'document_upload',
                context.l10n.adminSystemDocumentUpload,
                true,
                context.l10n.adminSystemDocumentUploadDesc,
              ),
              _buildToggleSetting(
                'enable_payments',
                context.l10n.adminSystemPaymentProcessing,
                true,
                context.l10n.adminSystemPaymentProcessingDesc,
              ),
            ],
          ),

          _buildSettingSection(
            context.l10n.adminSystemSectionCommunication,
            [
              _buildToggleSetting(
                'email_notifications',
                context.l10n.adminSystemEmailNotifications,
                true,
                context.l10n.adminSystemEmailNotificationsDesc,
              ),
              _buildToggleSetting(
                'sms_notifications',
                context.l10n.adminSystemSmsNotifications,
                false,
                context.l10n.adminSystemSmsNotificationsDesc,
              ),
              _buildToggleSetting(
                'push_notifications',
                context.l10n.adminSystemPushNotifications,
                true,
                context.l10n.adminSystemPushNotificationsDesc,
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
            context.l10n.adminSystemApiSettingsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemApiSettingsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionApiConfiguration,
            [
              _buildTextSetting(
                'api_base_url',
                context.l10n.adminSystemApiBaseUrl,
                'https://api.flow.edu',
                context.l10n.adminSystemApiBaseUrlDesc,
              ),
              _buildTextSetting(
                'api_version',
                context.l10n.adminSystemApiVersion,
                'v1',
                context.l10n.adminSystemApiVersionDesc,
              ),
              _buildToggleSetting(
                'api_rate_limiting',
                context.l10n.adminSystemApiRateLimiting,
                true,
                context.l10n.adminSystemApiRateLimitingDesc,
              ),
            ],
          ),

          _buildSettingSection(
            context.l10n.adminSystemSectionThirdPartyServices,
            [
              _buildTextSetting(
                'google_analytics_id',
                context.l10n.adminSystemGoogleAnalyticsId,
                'UA-XXXXXXXXX-X',
                context.l10n.adminSystemGoogleAnalyticsIdDesc,
              ),
              _buildTextSetting(
                'sentry_dsn',
                context.l10n.adminSystemSentryDsn,
                'https://xxx@sentry.io/xxx',
                context.l10n.adminSystemSentryDsnDesc,
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
            context.l10n.adminSystemEmailSettingsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemEmailSettingsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionEmailProvider,
            [
              _buildDropdownSetting(
                'email_service',
                context.l10n.adminSystemEmailService,
                'SendGrid',
                ['SendGrid', 'AWS SES', 'Mailgun', 'SMTP'],
                context.l10n.adminSystemEmailServiceDesc,
              ),
              _buildTextSetting(
                'email_api_key',
                context.l10n.adminSystemApiKey,
                '',
                context.l10n.adminSystemEmailApiKeyDesc,
                obscureText: true,
              ),
              _buildTextSetting(
                'from_email',
                context.l10n.adminSystemFromEmail,
                'noreply@flow.edu',
                context.l10n.adminSystemFromEmailDesc,
              ),
              _buildTextSetting(
                'from_name',
                context.l10n.adminSystemFromName,
                'Flow Education',
                context.l10n.adminSystemFromNameDesc,
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
            context.l10n.adminSystemSmsSettingsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemSmsSettingsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionSmsProvider,
            [
              _buildDropdownSetting(
                'sms_service',
                context.l10n.adminSystemSmsService,
                'AfricasTalking',
                ['AfricasTalking', 'Twilio', 'Nexmo'],
                context.l10n.adminSystemSmsServiceDesc,
              ),
              _buildTextSetting(
                'sms_api_key',
                context.l10n.adminSystemApiKey,
                '',
                context.l10n.adminSystemSmsApiKeyDesc,
                obscureText: true,
              ),
              _buildTextSetting(
                'sms_sender_id',
                context.l10n.adminSystemSmsSenderId,
                'FLOW_EDU',
                context.l10n.adminSystemSmsSenderIdDesc,
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
            context.l10n.adminSystemPaymentSettingsTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.adminSystemPaymentSettingsSubtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),

          _buildSettingSection(
            context.l10n.adminSystemSectionMpesa,
            [
              _buildToggleSetting(
                'enable_mpesa',
                context.l10n.adminSystemEnableMpesa,
                true,
                context.l10n.adminSystemEnableMpesaDesc,
              ),
              _buildTextSetting(
                'mpesa_consumer_key',
                context.l10n.adminSystemConsumerKey,
                '',
                context.l10n.adminSystemMpesaConsumerKeyDesc,
                obscureText: true,
              ),
              _buildTextSetting(
                'mpesa_consumer_secret',
                context.l10n.adminSystemConsumerSecret,
                '',
                context.l10n.adminSystemMpesaConsumerSecretDesc,
                obscureText: true,
              ),
              _buildTextSetting(
                'mpesa_shortcode',
                context.l10n.adminSystemShortcode,
                '174379',
                context.l10n.adminSystemMpesaShortcodeDesc,
              ),
            ],
          ),

          _buildSettingSection(
            context.l10n.adminSystemSectionCardPayments,
            [
              _buildToggleSetting(
                'enable_card_payments',
                context.l10n.adminSystemEnableCardPayments,
                true,
                context.l10n.adminSystemEnableCardPaymentsDesc,
              ),
              _buildDropdownSetting(
                'payment_gateway',
                context.l10n.adminSystemPaymentProcessor,
                'Stripe',
                ['Stripe', 'Paystack', 'Flutterwave'],
                context.l10n.adminSystemPaymentProcessorDesc,
              ),
              _buildTextSetting(
                'payment_publishable_key',
                context.l10n.adminSystemPublishableKey,
                '',
                context.l10n.adminSystemPublishableKeyDesc,
              ),
              _buildTextSetting(
                'payment_secret_key',
                context.l10n.adminSystemSecretKey,
                '',
                context.l10n.adminSystemSecretKeyDesc,
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
