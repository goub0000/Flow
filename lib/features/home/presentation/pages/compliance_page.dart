import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Compliance page with regulatory information
class CompliancePage extends StatelessWidget {
  const CompliancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Compliance'),
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
                  'Compliance & Certifications',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Our commitment to security, privacy, and regulatory compliance',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Certifications
                Text(
                  'Certifications',
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
                      title: 'SOC 2 Type II',
                      description: 'Certified for security, availability, and confidentiality',
                    ),
                    _buildCertCard(
                      theme,
                      icon: Icons.security,
                      title: 'ISO 27001',
                      description: 'Information security management certification',
                    ),
                    _buildCertCard(
                      theme,
                      icon: Icons.shield,
                      title: 'GDPR Compliant',
                      description: 'EU General Data Protection Regulation',
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Data Protection
                _buildComplianceSection(
                  theme,
                  icon: Icons.lock,
                  title: 'Data Protection',
                  content: '''
We implement comprehensive data protection measures to safeguard your information:

• End-to-end encryption for data in transit
• AES-256 encryption for data at rest
• Regular security audits and penetration testing
• Multi-factor authentication support
• Role-based access control
• Automated backup and disaster recovery
                  ''',
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Practices',
                  content: '''
Our privacy practices are designed to protect your rights:

• Transparent data collection and usage policies
• User consent management for data processing
• Data minimization principles
• Right to access, rectify, and delete personal data
• Data portability support
• Regular privacy impact assessments
                  ''',
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.policy,
                  title: 'Regulatory Compliance',
                  content: '''
Flow adheres to international and regional regulations:

• General Data Protection Regulation (GDPR) - EU
• Protection of Personal Information Act (POPIA) - South Africa
• Data Protection Act - Ghana, Kenya, Nigeria
• Children's Online Privacy Protection Act (COPPA)
• California Consumer Privacy Act (CCPA)
                  ''',
                ),

                _buildComplianceSection(
                  theme,
                  icon: Icons.business,
                  title: 'Third-Party Security',
                  content: '''
We carefully vet and monitor our third-party service providers:

• Vendor security assessments
• Data processing agreements
• Subprocessor transparency
• Regular compliance reviews
• Incident response coordination
                  ''',
                ),

                const SizedBox(height: 32),

                // Security Practices
                Text(
                  'Security Practices',
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
                      _buildSecurityItem(theme, Icons.update, 'Regular Updates',
                          'Security patches and updates deployed continuously'),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.bug_report, 'Bug Bounty Program',
                          'Responsible disclosure program for security researchers'),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.monitor, 'Monitoring',
                          '24/7 security monitoring and threat detection'),
                      const Divider(),
                      _buildSecurityItem(theme, Icons.history, 'Audit Logs',
                          'Comprehensive logging of all security events'),
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
                        'Compliance Questions?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Contact our compliance team for inquiries',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'compliance@flowedtech.com',
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
