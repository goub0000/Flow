import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Cookie Policy page - fetches content from CMS
class CookiesPage extends ConsumerWidget {
  const CookiesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always use translated static content for proper l10n support
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(context.l10n.cookiesPageTitle),
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
                  context.l10n.cookiesPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.cookiesPageLastUpdated,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  title: context.l10n.cookiesPageWhatAreCookies,
                  content: context.l10n.cookiesPageWhatAreCookiesContent,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.cookiesPageHowWeUse,
                  content: context.l10n.cookiesPageHowWeUseContent,
                ),

                const SizedBox(height: 24),

                // Cookie Types Table
                Text(
                  context.l10n.cookiesPageTypesTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildCookieTable(context, theme),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  title: context.l10n.cookiesPageManaging,
                  content: context.l10n.cookiesPageManagingContent,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.cookiesPageThirdParty,
                  content: context.l10n.cookiesPageThirdPartyContent,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.cookiesPageUpdates,
                  content: context.l10n.cookiesPageUpdatesContent,
                ),

                const SizedBox(height: 24),

                // Manage preferences CTA
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cookie, size: 40, color: AppColors.primary),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.cookiesPageManagePreferences,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.cookiesPageCustomize,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.go('/settings/cookies'),
                        child: Text(context.l10n.cookiesPageManageButton),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Contact
                Center(
                  child: Column(
                    children: [
                      Text(
                        context.l10n.cookiesPageQuestionsTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.cookiesPageQuestionsContact,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
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

  Widget _buildSection(ThemeData theme, {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content.trim(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCookieTable(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildTableRow(theme, context.l10n.cookiesPageCookieType, context.l10n.cookiesPagePurpose, context.l10n.cookiesPageDuration, isHeader: true),
          _buildTableRow(theme, context.l10n.cookiesPageSession, context.l10n.cookiesPageAuthentication, context.l10n.cookiesPageSession),
          _buildTableRow(theme, context.l10n.cookiesPagePreferences, context.l10n.cookiesPageUserSettings, '1 year'),
          _buildTableRow(theme, context.l10n.cookiesPageAnalytics, context.l10n.cookiesPageUsageStatistics, '2 years'),
          _buildTableRow(theme, context.l10n.cookiesPageSecurity, context.l10n.cookiesPageFraudPrevention, '1 year'),
        ],
      ),
    );
  }

  Widget _buildTableRow(ThemeData theme, String col1, String col2, String col3,
      {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isHeader ? AppColors.primary.withValues(alpha: 0.1) : null,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              col1,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              col2,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
                color: isHeader ? null : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              col3,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isHeader ? FontWeight.bold : null,
                color: isHeader ? null : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
