import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Data Protection page with GDPR and data rights information - fetches content from CMS
class DataProtectionPage extends ConsumerWidget {
  const DataProtectionPage({super.key});

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
        title: Text(l10n.dataProtectionPageTitle),
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
                  l10n.dataProtectionPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dataProtectionPageSubtitle,
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
                            l10n.dataProtectionPageRightsTitle,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.dataProtectionPageRightsDescription,
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
                  title: l10n.dataProtectionPageRightAccessTitle,
                  description: l10n.dataProtectionPageRightAccessDescription,
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.edit,
                  title: l10n.dataProtectionPageRightRectificationTitle,
                  description: l10n.dataProtectionPageRightRectificationDescription,
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.delete,
                  title: l10n.dataProtectionPageRightErasureTitle,
                  description: l10n.dataProtectionPageRightErasureDescription,
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.download,
                  title: l10n.dataProtectionPageRightPortabilityTitle,
                  description: l10n.dataProtectionPageRightPortabilityDescription,
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.block,
                  title: l10n.dataProtectionPageRightObjectTitle,
                  description: l10n.dataProtectionPageRightObjectDescription,
                ),
                _buildRightCard(
                  theme,
                  icon: Icons.pause,
                  title: l10n.dataProtectionPageRightRestrictTitle,
                  description: l10n.dataProtectionPageRightRestrictDescription,
                ),

                const SizedBox(height: 32),

                // How We Protect Your Data
                _buildSection(
                  theme,
                  icon: Icons.security,
                  title: l10n.dataProtectionPageProtectionTitle,
                  content: l10n.dataProtectionPageProtectionContent,
                ),

                _buildSection(
                  theme,
                  icon: Icons.storage,
                  title: l10n.dataProtectionPageStorageTitle,
                  content: l10n.dataProtectionPageStorageContent,
                ),

                _buildSection(
                  theme,
                  icon: Icons.share,
                  title: l10n.dataProtectionPageSharingTitle,
                  content: l10n.dataProtectionPageSharingContent,
                ),

                const SizedBox(height: 32),

                // Exercise Your Rights
                _buildContactSection(theme, context),

                const SizedBox(height: 32),

                // Related Pages
                Text(
                  l10n.dataProtectionPageRelatedTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildRelatedLink(context, theme, l10n.dataProtectionPageRelatedPrivacy, '/privacy'),
                    _buildRelatedLink(context, theme, l10n.dataProtectionPageRelatedCookies, '/cookies'),
                    _buildRelatedLink(context, theme, l10n.dataProtectionPageRelatedTerms, '/terms'),
                    _buildRelatedLink(context, theme, l10n.dataProtectionPageRelatedCompliance, '/compliance'),
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

  Widget _buildContactSection(ThemeData theme, BuildContext context) {
    final l10n = context.l10n;
    return Container(
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
            l10n.dataProtectionPageExerciseTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.dataProtectionPageExerciseDescription,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.dataProtectionPageExerciseEmail,
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
                label: Text(l10n.dataProtectionPageExerciseContactButton),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () => context.go('/settings'),
                icon: const Icon(Icons.settings),
                label: Text(l10n.dataProtectionPageExerciseManageButton),
              ),
            ],
          ),
        ],
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
