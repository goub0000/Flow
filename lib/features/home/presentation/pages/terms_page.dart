import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Terms of Service page - fetches content from CMS
class TermsPage extends ConsumerWidget {
  const TermsPage({super.key});

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
        title: Text(context.l10n.termsPageTitle),
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
                  context.l10n.termsPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.termsPageLastUpdated,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSection(theme, title: context.l10n.termsPageSection1Title, content: context.l10n.termsPageSection1Content),
                _buildSection(theme, title: context.l10n.termsPageSection2Title, content: context.l10n.termsPageSection2Content),
                _buildSection(theme, title: context.l10n.termsPageSection3Title, content: context.l10n.termsPageSection3Content),
                _buildSection(theme, title: context.l10n.termsPageSection4Title, content: context.l10n.termsPageSection4Content),
                _buildSection(theme, title: context.l10n.termsPageSection5Title, content: context.l10n.termsPageSection5Content),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.gavel, color: AppColors.primary, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.termsPageAgreement,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
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
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(content.trim(), style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
