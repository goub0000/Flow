import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import '../widgets/dynamic_page_wrapper.dart';

/// About page with company information - fetches content from CMS
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicPageWrapper(
      pageSlug: 'about',
      fallbackTitle: 'About Flow',
      builder: (context, content) => _buildDynamicPage(context, content),
      fallbackBuilder: (context) => _buildStaticPage(context),
    );
  }

  Widget _buildDynamicPage(BuildContext context, PublicPageContent content) {
    final theme = Theme.of(context);
    final mission = content.getString('mission');
    final vision = content.getString('vision');
    final story = content.getString('story');
    final values = content.getValues();

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
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
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
                        content.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (content.subtitle != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          content.subtitle!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Mission
                if (mission.isNotEmpty)
                  _buildSection(
                    theme,
                    icon: Icons.flag,
                    title: 'Our Mission',
                    content: mission,
                  ),

                const SizedBox(height: 24),

                // Vision
                if (vision.isNotEmpty)
                  _buildSection(
                    theme,
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    content: vision,
                  ),

                const SizedBox(height: 24),

                // Story
                if (story.isNotEmpty)
                  _buildSection(
                    theme,
                    icon: Icons.auto_stories,
                    title: 'Our Story',
                    content: story,
                  ),

                const SizedBox(height: 24),

                // Values
                if (values.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Text(
                        'Our Values',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ValuesListWidget(values: values),
                ],

                const SizedBox(height: 32),

                // Contact CTA
                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail),
                    label: const Text('Get in Touch'),
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      );
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
                        AppColors.primary.withOpacity(0.1),
                        AppColors.accent.withOpacity(0.1),
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
                        'Flow EdTech',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Africa's Premier Education Platform",
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
                  title: 'Our Mission',
                  content:
                      'Flow is dedicated to transforming education across Africa by connecting students with universities, counselors, and resources they need to succeed.',
                ),

                const SizedBox(height: 24),

                _buildSection(
                  theme,
                  icon: Icons.visibility,
                  title: 'Our Vision',
                  content:
                      'We envision a future where every African student has the tools, information, and support needed to achieve their educational dreams.',
                ),

                const SizedBox(height: 32),

                Center(
                  child: FilledButton.icon(
                    onPressed: () => context.go('/contact'),
                    icon: const Icon(Icons.mail),
                    label: const Text('Get in Touch'),
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
