import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';

/// Admin screen for managing page content (CMS)
class PageContentListScreen extends ConsumerStatefulWidget {
  const PageContentListScreen({super.key});

  @override
  ConsumerState<PageContentListScreen> createState() => _PageContentListScreenState();
}

class _PageContentListScreenState extends ConsumerState<PageContentListScreen> {
  @override
  void initState() {
    super.initState();
    // Load pages on init
    Future.microtask(() {
      ref.read(adminPagesProvider.notifier).loadPages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminPagesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Page Content Management',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage footer pages content (About, Privacy, Terms, etc.)',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Refresh button
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(adminPagesProvider.notifier).loadPages();
                  },
                  tooltip: 'Refresh',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(48),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.error != null)
              _buildErrorState(state.error!)
            else if (state.pages.isEmpty)
              _buildEmptyState()
            else
              _buildPagesList(state.pages),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading pages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(adminPagesProvider.notifier).loadPages();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No pages found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Run the database migration to seed initial page content.',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagesList(List<PageContentModel> pages) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Page',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Expanded(
                  flex: 3,
                  child: Text(
                    'Title',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Last Updated',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Table rows
          ...pages.map((page) => _buildPageRow(page)),
        ],
      ),
    );
  }

  Widget _buildPageRow(PageContentModel page) {
    return InkWell(
      onTap: () => _editPage(page.pageSlug),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border.withOpacity(0.5)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Icon(
                    _getPageIcon(page.pageSlug),
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _formatSlug(page.pageSlug),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                page.title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 100,
              child: _buildStatusBadge(page.status),
            ),
            SizedBox(
              width: 150,
              child: Text(
                _formatDate(page.updatedAt),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () => _editPage(page.pageSlug),
                    tooltip: 'Edit',
                    color: AppColors.primary,
                  ),
                  IconButton(
                    icon: Icon(
                      page.isPublished ? Icons.visibility_off : Icons.visibility,
                      size: 18,
                    ),
                    onPressed: () => _togglePublish(page),
                    tooltip: page.isPublished ? 'Unpublish' : 'Publish',
                    color: page.isPublished ? AppColors.warning : AppColors.success,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'draft':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'archived':
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
        textColor = AppColors.textSecondary;
        break;
      default:
        backgroundColor = AppColors.border;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getPageIcon(String slug) {
    switch (slug) {
      case 'about':
        return Icons.info_outline;
      case 'contact':
        return Icons.contact_mail_outlined;
      case 'privacy':
        return Icons.privacy_tip_outlined;
      case 'terms':
        return Icons.gavel_outlined;
      case 'cookies':
        return Icons.cookie_outlined;
      case 'data-protection':
        return Icons.security_outlined;
      case 'compliance':
        return Icons.verified_outlined;
      case 'careers':
        return Icons.work_outline;
      case 'press':
        return Icons.newspaper_outlined;
      case 'partners':
        return Icons.handshake_outlined;
      case 'help':
        return Icons.help_outline;
      case 'docs':
        return Icons.menu_book_outlined;
      case 'api-docs':
        return Icons.code_outlined;
      case 'community':
        return Icons.people_outline;
      case 'blog':
        return Icons.article_outlined;
      case 'mobile-apps':
        return Icons.smartphone_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  String _formatSlug(String slug) {
    return slug
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _editPage(String slug) {
    context.go('/admin/pages/$slug/edit');
  }

  Future<void> _togglePublish(PageContentModel page) async {
    final notifier = ref.read(adminPagesProvider.notifier);
    bool success;

    if (page.isPublished) {
      success = await notifier.unpublishPage(page.pageSlug);
    } else {
      success = await notifier.publishPage(page.pageSlug);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Page ${page.isPublished ? 'unpublished' : 'published'} successfully'
                : 'Failed to ${page.isPublished ? 'unpublish' : 'publish'} page',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }
}
