import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Press Kit page with media resources - fetches content from CMS
class PressPage extends ConsumerWidget {
  const PressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(l10n.pressPageTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.pressPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pressPageSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Company Overview
                _buildSection(
                  theme,
                  icon: Icons.business,
                  title: l10n.pressPageCompanyOverview,
                  content: l10n.pressPageCompanyOverviewContent,
                ),

                const SizedBox(height: 24),

                // Key Facts
                Text(
                  l10n.pressPageKeyFacts,
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
                      _buildFactRow(theme, l10n.pressPageFounded, '2024'),
                      _buildFactRow(theme, l10n.pressPageHeadquarters, 'Accra, Ghana'),
                      _buildFactRow(theme, l10n.pressPageActiveUsers, '50,000+'),
                      _buildFactRow(theme, l10n.pressPagePartnerInstitutions, '200+'),
                      _buildFactRow(theme, l10n.pressPageCountries, '20+'),
                      _buildFactRow(theme, l10n.pressPageUniversitiesInDb, '18,000+'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Brand Assets
                Text(
                  l10n.pressPageBrandAssets,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildAssetCard(context, theme, Icons.image, l10n.pressPageLogoPack, l10n.pressPageLogoPackDesc),
                    _buildAssetCard(context, theme, Icons.color_lens, l10n.pressPageBrandGuidelines, l10n.pressPageBrandGuidelinesDesc),
                    _buildAssetCard(context, theme, Icons.photo_library, l10n.pressPageScreenshots, l10n.pressPageScreenshotsDesc),
                    _buildAssetCard(context, theme, Icons.videocam, l10n.pressPageVideoAssets, l10n.pressPageVideoAssetsDesc),
                  ],
                ),

                const SizedBox(height: 32),

                // Recent News
                Text(
                  l10n.pressPageRecentNews,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildNewsCard(
                  theme,
                  date: 'January 2026',
                  title: 'Flow Expands to East Africa',
                  description: 'Flow EdTech announces expansion to Kenya, Tanzania, and Uganda with new regional partnerships.',
                ),
                _buildNewsCard(
                  theme,
                  date: 'December 2025',
                  title: 'AI-Powered University Matching Launched',
                  description: 'New machine learning algorithm helps students find their perfect university match.',
                ),
                _buildNewsCard(
                  theme,
                  date: 'November 2025',
                  title: 'Partnership with African Union Education Initiative',
                  description: 'Flow joins continental effort to improve education access across Africa.',
                ),

                const SizedBox(height: 32),

                // Media Contact
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.accent.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.contact_mail, size: 40, color: AppColors.primary),
                      const SizedBox(height: 16),
                      Text(
                        l10n.pressPageMediaContact,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.pressPageMediaContactDesc,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'press@flowedtech.com',
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

  Widget _buildSection(ThemeData theme,
      {required IconData icon, required String title, required String content}) {
    return Column(
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
          content,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildFactRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, ThemeData theme, IconData icon, String title, String description) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
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
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 16),
            label: Text(context.l10n.pressPageDownload),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    ThemeData theme, {
    required String date,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
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
    );
  }
}
