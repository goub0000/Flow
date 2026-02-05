import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Compliance page with regulatory information - fetches content from CMS
class CompliancePage extends ConsumerWidget {
  const CompliancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.compliancePageTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.compliancePageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.compliancePageSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Certifications
                Text(
                  l10n.compliancePageCertificationsTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildCertCard(
                      theme,
                      icon: Icons.verified_user,
                      title: l10n.compliancePageCertSoc2Title,
                      description: l10n.compliancePageCertSoc2Description,
                    ),
                    _buildCertCard(
                      theme,
                      icon: Icons.security,
                      title: l10n.compliancePageCertIsoTitle,
                      description: l10n.compliancePageCertIsoDescription,
                    ),
                    _buildCertCard(
                      theme,
                      icon: Icons.shield,
                      title: l10n.compliancePageCertGdprTitle,
                      description: l10n.compliancePageCertGdprDescription,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Data Protection
                _buildComplianceSection(
                  theme,
                  icon: Icons.lock,
                  title: l10n.compliancePageDataProtectionTitle,
                  content: l10n.compliancePageDataProtectionContent,
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.privacy_tip,
                  title: l10n.compliancePagePrivacyTitle,
                  content: l10n.compliancePagePrivacyContent,
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.policy,
                  title: l10n.compliancePageRegulatoryTitle,
                  content: l10n.compliancePageRegulatoryContent,
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.business,
                  title: l10n.compliancePageThirdPartyTitle,
                  content: l10n.compliancePageThirdPartyContent,
                ),

                const SizedBox(height: 32),

                // Security Practices
                Text(
                  l10n.compliancePageSecurityTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildSecurityItem(theme, Icons.update, l10n.compliancePageSecurityUpdatesTitle,
                          l10n.compliancePageSecurityUpdatesDescription),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.bug_report, l10n.compliancePageSecurityBugBountyTitle,
                          l10n.compliancePageSecurityBugBountyDescription),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.monitor, l10n.compliancePageSecurityMonitoringTitle,
                          l10n.compliancePageSecurityMonitoringDescription),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.history, l10n.compliancePageSecurityAuditTitle,
                          l10n.compliancePageSecurityAuditDescription),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Contact
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.contact_support, size: 40, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        l10n.compliancePageContactTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.compliancePageContactDescription,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.compliancePageContactEmail,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCertCard(ThemeData theme,
      {required IconData icon, required String title, required String description}) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 40),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceSection(ThemeData theme,
      {required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityItem(ThemeData theme, IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
