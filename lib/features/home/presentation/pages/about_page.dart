import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// About page with company information - fetches content from CMS
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildStaticPage(context);
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Hero section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.accent.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 3),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.school,
                              size: 40,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.aboutPageFlowEdTech,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.aboutPagePremierPlatform,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildSection(
                  theme,
                  icon: Icons.flag,
                  title: context.l10n.aboutPageOurMission,
                  content: context.l10n.aboutPageMissionContent,
                ),

                const SizedBox(height: 24),

                _buildSection(
                  theme,
                  icon: Icons.visibility,
                  title: context.l10n.aboutPageOurVision,
                  content: context.l10n.aboutPageVisionContent,
                ),

                const SizedBox(height: 32),

                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail),
                    label: Text(context.l10n.aboutPageGetInTouch),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildSection(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String content,
  }) {
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
}
