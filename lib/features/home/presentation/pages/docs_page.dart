import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Documentation page with guides and tutorials - fetches content from CMS
class DocsPage extends ConsumerWidget {
  const DocsPage({super.key});

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
        title: Text(l10n.docsPageTitle),
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
                  l10n.docsPageTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.docsPageSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // Getting Started
                _buildDocSection(
                  theme,
                  icon: Icons.rocket_launch,
                  title: 'Getting Started',
                  description: 'Learn the basics of Flow',
                  articles: [
                    _DocArticle('Creating Your Account', '5 min read', Icons.person_add),
                    _DocArticle('Setting Up Your Profile', '3 min read', Icons.edit),
                    _DocArticle('Understanding Your Dashboard', '7 min read', Icons.dashboard),
                    _DocArticle('Quick Start Guide', '10 min read', Icons.play_circle),
                  ],
                ),

                _buildDocSection(
                  theme,
                  icon: Icons.school,
                  title: 'For Students',
                  description: 'Guides for student users',
                  articles: [
                    _DocArticle('Finding Your Perfect University', '8 min read', Icons.search),
                    _DocArticle('Using University Recommendations', '5 min read', Icons.recommend),
                    _DocArticle('Tracking Applications', '6 min read', Icons.track_changes),
                    _DocArticle('Connecting with Counselors', '4 min read', Icons.support_agent),
                    _DocArticle('Managing Documents', '5 min read', Icons.folder),
                  ],
                ),

                _buildDocSection(
                  theme,
                  icon: Icons.family_restroom,
                  title: 'For Parents',
                  description: 'Guides for parent users',
                  articles: [
                    _DocArticle('Linking to Your Child\'s Account', '4 min read', Icons.link),
                    _DocArticle('Monitoring Progress', '5 min read', Icons.insights),
                    _DocArticle('Understanding Reports', '6 min read', Icons.assessment),
                    _DocArticle('Communication Features', '4 min read', Icons.chat),
                  ],
                ),

                _buildDocSection(
                  theme,
                  icon: Icons.support_agent,
                  title: 'For Counselors',
                  description: 'Guides for education counselors',
                  articles: [
                    _DocArticle('Setting Up Your Practice', '8 min read', Icons.business),
                    _DocArticle('Managing Students', '6 min read', Icons.people),
                    _DocArticle('Scheduling Sessions', '5 min read', Icons.calendar_today),
                    _DocArticle('Billing and Payments', '7 min read', Icons.payment),
                  ],
                ),

                _buildDocSection(
                  theme,
                  icon: Icons.business,
                  title: 'For Institutions',
                  description: 'Guides for universities and colleges',
                  articles: [
                    _DocArticle('Institution Dashboard Overview', '10 min read', Icons.dashboard),
                    _DocArticle('Managing Programs', '7 min read', Icons.school),
                    _DocArticle('Viewing Applicants', '5 min read', Icons.people),
                    _DocArticle('Analytics and Insights', '8 min read', Icons.analytics),
                  ],
                ),

                const SizedBox(height: 32),

                // Need more help?
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
                      Icon(Icons.help_center, size: 48, color: AppColors.primary),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Can't find what you're looking for?",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Check out our Help Center or contact support',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () => context.go('/help'),
                        child: const Text('Help Center'),
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

  Widget _buildDocSection(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required List<_DocArticle> articles,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
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
            ],
          ),
          const SizedBox(height: 16),
          ...articles.map((article) => _buildArticleItem(theme, article)),
        ],
      ),
    );
  }

  Widget _buildArticleItem(ThemeData theme, _DocArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(article.icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  article.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                article.readTime,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocArticle {
  final String title;
  final String readTime;
  final IconData icon;

  _DocArticle(this.title, this.readTime, this.icon);
}
