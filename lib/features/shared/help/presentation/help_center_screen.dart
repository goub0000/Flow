import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../widgets/help_support_widgets.dart';
import 'faq_screen.dart';
import 'contact_support_screen.dart';
import 'support_tickets_screen.dart';

/// Help Center Screen
///
/// Main hub for help resources and support.
/// Features:
/// - Search help articles
/// - Browse by category
/// - Popular articles
/// - Quick access to support
/// - FAQ section
/// - Contact options
///
/// Backend Integration TODO:
/// - Fetch help categories and articles
/// - Implement search functionality
/// - Track article views
/// - Collect helpfulness feedback
/// - Personalized recommendations

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<HelpCategory> _categories = [];
  List<HelpArticle> _popularArticles = [];

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockData() {
    _categories = const [
      HelpCategory(
        id: '1',
        title: 'Getting Started',
        description: 'Learn the basics of using Flow',
        icon: Icons.rocket_launch,
        color: AppColors.primary,
        articleCount: 12,
      ),
      HelpCategory(
        id: '2',
        title: 'Account & Profile',
        description: 'Manage your account settings',
        icon: Icons.person,
        color: AppColors.info,
        articleCount: 8,
      ),
      HelpCategory(
        id: '3',
        title: 'Courses & Learning',
        description: 'Everything about courses',
        icon: Icons.school,
        color: AppColors.success,
        articleCount: 15,
      ),
      HelpCategory(
        id: '4',
        title: 'Payments & Billing',
        description: 'Payment and subscription help',
        icon: Icons.payment,
        color: AppColors.warning,
        articleCount: 10,
      ),
      HelpCategory(
        id: '5',
        title: 'Technical Issues',
        description: 'Troubleshooting common problems',
        icon: Icons.bug_report,
        color: AppColors.error,
        articleCount: 18,
      ),
      HelpCategory(
        id: '6',
        title: 'Mobile App',
        description: 'Using Flow on mobile devices',
        icon: Icons.phone_android,
        color: Colors.purple,
        articleCount: 9,
      ),
    ];

    _popularArticles = [
      HelpArticle(
        id: '1',
        title: 'How to enroll in a course',
        content:
            'Learn how to browse and enroll in courses on Flow. Step-by-step guide with screenshots.',
        categoryId: '3',
        publishedDate: DateTime.now().subtract(const Duration(days: 5)),
        views: 2453,
        helpfulCount: 187,
        tags: ['courses', 'enrollment', 'getting started'],
      ),
      HelpArticle(
        id: '2',
        title: 'Resetting your password',
        content:
            'Follow these simple steps to reset your password if you\'ve forgotten it.',
        categoryId: '2',
        publishedDate: DateTime.now().subtract(const Duration(days: 10)),
        views: 1892,
        helpfulCount: 143,
        tags: ['account', 'password', 'security'],
      ),
      HelpArticle(
        id: '3',
        title: 'Understanding course certificates',
        content:
            'Learn about how certificates work, when you receive them, and how to download them.',
        categoryId: '3',
        publishedDate: DateTime.now().subtract(const Duration(days: 3)),
        views: 1567,
        helpfulCount: 98,
        tags: ['certificates', 'courses'],
      ),
      HelpArticle(
        id: '4',
        title: 'Payment methods and billing',
        content:
            'Information about accepted payment methods, billing cycles, and refund policies.',
        categoryId: '4',
        publishedDate: DateTime.now().subtract(const Duration(days: 7)),
        views: 1234,
        helpfulCount: 76,
        tags: ['payment', 'billing', 'subscription'],
      ),
      HelpArticle(
        id: '5',
        title: 'App not loading or crashing',
        content:
            'Troubleshooting steps for when the app won\'t load or keeps crashing.',
        categoryId: '5',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        views: 987,
        helpfulCount: 54,
        tags: ['technical', 'troubleshooting', 'app'],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.helpBack,
        ),
        title: Text(context.l10n.helpCenterTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Header
          Text(
            context.l10n.helpHowCanWeHelp,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.helpSearchOrBrowse,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.helpSearchForHelp,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
            onSubmitted: (value) {
              // TODO: Perform search
              if (value.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Searching for: $value')),
                );
              }
            },
          ),
          const SizedBox(height: 32),

          // Quick Help Options
          Row(
            children: [
              Text(
                context.l10n.helpQuickHelp,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          QuickHelpCard(
            icon: Icons.question_answer,
            title: context.l10n.helpBrowseFaqs,
            description: context.l10n.helpBrowseFaqsDesc,
            color: AppColors.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FAQScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          QuickHelpCard(
            icon: Icons.support_agent,
            title: context.l10n.helpContactSupport,
            description: context.l10n.helpContactSupportDesc,
            color: AppColors.success,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContactSupportScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          QuickHelpCard(
            icon: Icons.confirmation_number,
            title: context.l10n.helpMySupportTickets,
            description: context.l10n.helpMySupportTicketsDesc,
            color: AppColors.info,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SupportTicketsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.helpBrowseByTopic,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all categories
                },
                child: Text(context.l10n.helpViewAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return HelpCategoryCard(
                category: category,
                onTap: () {
                  _showCategoryArticles(category);
                },
              );
            },
          ),
          const SizedBox(height: 32),

          // Popular Articles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.helpPopularArticles,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: View all articles
                },
                child: Text(context.l10n.helpViewAll),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._popularArticles.map((article) {
            return HelpArticleCard(
              article: article,
              onTap: () {
                _showArticleDetail(article);
              },
              onBookmark: () {
                setState(() {
                  final index = _popularArticles
                      .indexWhere((a) => a.id == article.id);
                  if (index != -1) {
                    _popularArticles[index] = article.copyWith(
                      isBookmarked: !article.isBookmarked,
                    );
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      article.isBookmarked
                          ? context.l10n.helpRemovedFromBookmarks
                          : context.l10n.helpAddedToBookmarks,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 32),

          // Still Need Help Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.help_outline,
                  size: 48,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  context.l10n.helpStillNeedHelp,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.helpSupportTeamHere,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactSupportScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: Text(context.l10n.helpContactSupport),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCategoryArticles(HelpCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(category.icon, color: category.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${category.articleCount} articles',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Articles List
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: _popularArticles
                    .where((a) => a.categoryId == category.id)
                    .map((article) {
                  return HelpArticleCard(
                    article: article,
                    onTap: () {
                      Navigator.pop(context);
                      _showArticleDetail(article);
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showArticleDetail(HelpArticle article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      article.isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: article.isBookmarked
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        final index = _popularArticles
                            .indexWhere((a) => a.id == article.id);
                        if (index != -1) {
                          _popularArticles[index] = article.copyWith(
                            isBookmarked: !article.isBookmarked,
                          );
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Meta info
                  Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${article.views} views',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(article.publishedDate),
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    article.content,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tags
                  if (article.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: article.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            '#$tag',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Helpful Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.helpWasArticleHelpful,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text(context.l10n.helpThanksForFeedback)),
                                );
                              },
                              icon: const Icon(Icons.thumb_up),
                              label: Text(context.l10n.helpYes),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          context.l10n.helpThanksWeWillImprove)),
                                );
                              },
                              icon: const Icon(Icons.thumb_down),
                              label: Text(context.l10n.helpNo),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '$difference days ago';

    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
