import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import '../../../../core/l10n_extension.dart';
import '../widgets/dynamic_page_wrapper.dart';

/// Privacy Policy page - fetches content from CMS
class PrivacyPage extends ConsumerWidget {
  const PrivacyPage({super.key});

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
        title: Text(context.l10n.privacyPageTitle),
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
                  context.l10n.privacyPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.privacyPageLastUpdated,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection1Title,
                  content: context.l10n.privacyPageSection1Content,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection2Title,
                  content: context.l10n.privacyPageSection2Content,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection3Title,
                  content: context.l10n.privacyPageSection3Content,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection4Title,
                  content: context.l10n.privacyPageSection4Content,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection5Title,
                  content: context.l10n.privacyPageSection5Content,
                ),

                _buildSection(
                  theme,
                  title: context.l10n.privacyPageSection6Title,
                  content: context.l10n.privacyPageSection6Content,
                ),

                const SizedBox(height: 32),

                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail_outline),
                    label: Text(context.l10n.privacyPageContactTeam),
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
}
