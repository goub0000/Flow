import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import '../../../../core/l10n_extension.dart';
import '../widgets/dynamic_page_wrapper.dart';

/// Blog page with articles and news
class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DynamicPageWrapper(
      pageSlug: 'blog',
      fallbackTitle: 'Blog',
      builder: (context, content) => _buildDynamicPage(context, content),
      fallbackBuilder: (context) => _buildStaticPage(context),
    );
  }

  Widget _buildDynamicPage(BuildContext context, PublicPageContent content) {
    final theme = Theme.of(context);
    final intro = content.getString('intro') ?? 'Insights, tips, and stories about education in Africa';
    final categories = content.getList('categories');
    final featuredPost = content.getMap('featured_post');
    final blogPosts = content.getList('blog_posts');
    final newsletterTitle = content.getString('newsletter_title') ?? 'Subscribe to Our Newsletter';
    final newsletterSubtitle = content.getString('newsletter_subtitle') ?? 'Get the latest articles and resources delivered to your inbox';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                intro,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Featured Post
              if (featuredPost.isNotEmpty)
                _buildFeaturedPost(
                  theme,
                  title: featuredPost['title'] ?? '',
                  excerpt: featuredPost['excerpt'] ?? '',
                  author: featuredPost['author'] ?? '',
                  date: featuredPost['date'] ?? '',
                  readTime: featuredPost['read_time'] ?? '',
                  category: featuredPost['category'] ?? '',
                ),

              const SizedBox(height: 32),

              // Categories
              if (categories.isNotEmpty) ...[
                Text(
                  'Categories',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildCategoryChip(theme, 'All', true),
                    ...categories.map((cat) => _buildCategoryChip(
                      theme,
                      cat is String ? cat : (cat['name'] ?? ''),
                      false,
                    )),
                  ],
                ),
              ],

              const SizedBox(height: 32),

              // Recent Posts
              if (blogPosts.isNotEmpty) ...[
                Text(
                  'Recent Posts',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...blogPosts.map((post) => _buildBlogPost(
                  theme,
                  title: post['title'] ?? '',
                  excerpt: post['excerpt'] ?? '',
                  author: post['author'] ?? '',
                  date: post['date'] ?? '',
                  readTime: post['read_time'] ?? '',
                  category: post['category'] ?? '',
                )),
              ],

              const SizedBox(height: 32),

              // Newsletter signup
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
                    Icon(Icons.mail, size: 48, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      newsletterTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      newsletterSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Subscribe'),
                          ),
                        ],
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
    );
  }

  Widget _buildStaticPage(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flow Blog',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Insights, tips, and stories about education in Africa',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Featured Post
              _buildFeaturedPost(
                theme,
                title: 'The Future of Education Technology in Africa',
                excerpt:
                    'How digital platforms are transforming access to quality education across the continent and what this means for the next generation of students.',
                author: 'Dr. Amina Mensah',
                date: 'January 15, 2026',
                readTime: '8 min read',
                category: 'EdTech',
              ),

              const SizedBox(height: 32),

              // Categories
              Text(
                'Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCategoryChip(theme, 'All', true),
                  _buildCategoryChip(theme, 'EdTech', false),
                  _buildCategoryChip(theme, 'University Guides', false),
                  _buildCategoryChip(theme, 'Career Advice', false),
                  _buildCategoryChip(theme, 'Student Stories', false),
                  _buildCategoryChip(theme, 'Tips & Tricks', false),
                ],
              ),

              const SizedBox(height: 32),

              // Recent Posts
              Text(
                'Recent Posts',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildBlogPost(
                theme,
                title: '10 Tips for Writing a Winning University Application',
                excerpt: 'Expert advice on crafting an application that stands out from the crowd.',
                author: 'Sarah Okonkwo',
                date: 'January 12, 2026',
                readTime: '6 min read',
                category: 'Tips & Tricks',
              ),
              _buildBlogPost(
                theme,
                title: 'Understanding Scholarship Requirements: A Complete Guide',
                excerpt: 'Everything you need to know about finding and applying for scholarships.',
                author: 'Kwame Asante',
                date: 'January 10, 2026',
                readTime: '10 min read',
                category: 'University Guides',
              ),
              _buildBlogPost(
                theme,
                title: 'From Ghana to MIT: My Journey',
                excerpt: 'A student shares their experience of getting into a top US university.',
                author: 'Kofi Mensah',
                date: 'January 8, 2026',
                readTime: '7 min read',
                category: 'Student Stories',
              ),
              _buildBlogPost(
                theme,
                title: 'Top 20 Universities in Africa for Engineering',
                excerpt: 'A comprehensive ranking of the best engineering programs on the continent.',
                author: 'Flow Research Team',
                date: 'January 5, 2026',
                readTime: '12 min read',
                category: 'University Guides',
              ),
              _buildBlogPost(
                theme,
                title: 'How to Choose the Right University for You',
                excerpt: 'Key factors to consider when making one of life\'s biggest decisions.',
                author: 'Dr. Fatima Diallo',
                date: 'January 3, 2026',
                readTime: '8 min read',
                category: 'Career Advice',
              ),
              _buildBlogPost(
                theme,
                title: 'The Role of Parents in University Selection',
                excerpt: 'How parents can support without overwhelming their children.',
                author: 'Maria Okafor',
                date: 'January 1, 2026',
                readTime: '5 min read',
                category: 'Tips & Tricks',
              ),

              const SizedBox(height: 32),

              // Newsletter signup
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
                    Icon(Icons.mail, size: 48, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Subscribe to Our Newsletter',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get the latest articles and resources delivered to your inbox',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 400,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter your email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Subscribe'),
                          ),
                        ],
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
    );
  }

  Widget _buildFeaturedPost(
    ThemeData theme, {
    required String title,
    required String excerpt,
    required String author,
    required String date,
    required String readTime,
    required String category,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.accent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Center(
              child: Icon(Icons.article, size: 64, color: Colors.white.withOpacity(0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Featured',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  excerpt,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        author.isNotEmpty ? author[0] : '',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(author, style: theme.textTheme.bodyMedium),
                    const Spacer(),
                    Text(
                      '$date • $readTime',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ThemeData theme, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {},
      selectedColor: AppColors.primary.withOpacity(0.2),
    );
  }

  Widget _buildBlogPost(
    ThemeData theme, {
    required String title,
    required String excerpt,
    required String author,
    required String date,
    required String readTime,
    required String category,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.article, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
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
                  excerpt,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      author,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$date • $readTime',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
