import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Data Protection page with GDPR and data rights information
class DataProtectionPage extends StatelessWidget {
  const DataProtectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: const Text('Data Protection'),
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
                  'Data Protection',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'How we protect and manage your personal data',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Your Rights
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.shield, color: AppColors.primary, size: 32),
                          const SizedBox(width: 12),
                          Text(
                            'Your Data Rights',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Under data protection laws, you have the following rights:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _buildRightCard(
                  theme,
                  icon: Icons.visibility,
                  title: 'Right to Access',
                  description:
                      'You can request a copy of all personal data we hold about you. We will provide this within 30 days.',
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.edit,
                  title: 'Right to Rectification',
                  description:
                      'You can request correction of inaccurate or incomplete personal data.',
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.delete,
                  title: 'Right to Erasure',
                  description:
                      'You can request deletion of your personal data in certain circumstances.',
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.download,
                  title: 'Right to Data Portability',
                  description:
                      'You can request your data in a structured, machine-readable format.',
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.block,
                  title: 'Right to Object',
                  description:
                      'You can object to processing of your personal data for certain purposes.',
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.pause,
                  title: 'Right to Restrict Processing',
                  description:
                      'You can request that we limit how we use your data.',
                ),

                const SizedBox(height: 32),

                // How We Protect Your Data
                _buildSection(
                  theme,
                  icon: Icons.security,
                  title: 'How We Protect Your Data',
                  content: '''
We implement robust security measures to protect your personal data:

**Technical Measures**
• End-to-end encryption for data transmission
• AES-256 encryption for stored data
• Regular security audits and penetration testing
• Intrusion detection systems
• Secure data centers with physical security

**Organizational Measures**
• Staff training on data protection
• Access controls and authentication
• Data protection impact assessments
• Incident response procedures
• Regular compliance reviews
                  ''',
                ),

                _buildSection(
                  theme,
                  icon: Icons.storage,
                  title: 'Data Storage & Retention',
                  content: '''
**Where We Store Your Data**
Your data is stored on secure servers located in regions with strong data protection laws. We use industry-leading cloud providers with SOC 2 and ISO 27001 certifications.

**How Long We Keep Your Data**
• Account data: Until you delete your account
• Application data: 7 years for compliance
• Analytics data: 2 years
• Communication logs: 3 years

After these periods, data is securely deleted or anonymized.
                  ''',
                ),

                _buildSection(
                  theme,
                  icon: Icons.share,
                  title: 'Data Sharing',
                  content: '''
We only share your data when necessary:

• **With your consent**: When you explicitly agree
• **Service providers**: Partners who help us deliver services
• **Legal requirements**: When required by law
• **Business transfers**: In case of merger or acquisition

We never sell your personal data to third parties.
                  ''',
                ),

                const SizedBox(height: 32),

                // Exercise Your Rights
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.mail, size: 40, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Exercise Your Rights',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'To make a data request or exercise any of your rights, contact our Data Protection Officer:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'dpo@flowedtech.com',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => context.go('/contact'),
                            icon: const Icon(Icons.contact_support),
                            label: const Text('Contact Us'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            onPressed: () => context.go('/settings'),
                            icon: const Icon(Icons.settings),
                            label: const Text('Manage Data'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Related Pages
                Text(
                  'Related Information',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildRelatedLink(context, theme, 'Privacy Policy', '/privacy'),
                    _buildRelatedLink(context, theme, 'Cookie Policy', '/cookies'),
                    _buildRelatedLink(context, theme, 'Terms of Service', '/terms'),
                    _buildRelatedLink(context, theme, 'Compliance', '/compliance'),
                  ],
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRightCard(ThemeData theme,
      {required IconData icon, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
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

  Widget _buildSection(ThemeData theme,
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

  Widget _buildRelatedLink(BuildContext context, ThemeData theme, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
