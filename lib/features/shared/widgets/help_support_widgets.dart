import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Help & Support Widgets Library
///
/// Reusable components for knowledge base, FAQ, and support features.
/// All components work without backend integration using mock data patterns.
///
/// Backend Integration TODO:
/// - Fetch help articles from CMS
/// - Submit support tickets
/// - Implement live chat
/// - Track ticket status
/// - Search help content
/// - Track article views and helpfulness

// ============================================================================
// MODELS
// ============================================================================

/// Help Category Model
class HelpCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int articleCount;

  const HelpCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.articleCount,
  });
}

/// Help Article Model
class HelpArticle {
  final String id;
  final String title;
  final String content;
  final String categoryId;
  final List<String> tags;
  final DateTime publishedDate;
  final int views;
  final double helpfulnessRating;
  final int helpfulCount;
  final bool isBookmarked;

  const HelpArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    this.tags = const [],
    required this.publishedDate,
    this.views = 0,
    this.helpfulnessRating = 0.0,
    this.helpfulCount = 0,
    this.isBookmarked = false,
  });

  HelpArticle copyWith({
    String? id,
    String? title,
    String? content,
    String? categoryId,
    List<String>? tags,
    DateTime? publishedDate,
    int? views,
    double? helpfulnessRating,
    int? helpfulCount,
    bool? isBookmarked,
  }) {
    return HelpArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      publishedDate: publishedDate ?? this.publishedDate,
      views: views ?? this.views,
      helpfulnessRating: helpfulnessRating ?? this.helpfulnessRating,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

/// FAQ Item Model
class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String categoryId;
  final int helpfulCount;
  final bool isExpanded;

  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    this.helpfulCount = 0,
    this.isExpanded = false,
  });

  FAQItem copyWith({
    String? id,
    String? question,
    String? answer,
    String? categoryId,
    int? helpfulCount,
    bool? isExpanded,
  }) {
    return FAQItem(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      categoryId: categoryId ?? this.categoryId,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

/// Support Ticket Model
class SupportTicket {
  final String id;
  final String subject;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final TicketCategory category;
  final DateTime createdAt;
  final DateTime? lastUpdated;
  final List<TicketMessage> messages;
  final String? assignedTo;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.priority,
    required this.category,
    required this.createdAt,
    this.lastUpdated,
    this.messages = const [],
    this.assignedTo,
  });
}

/// Ticket Status Enum
enum TicketStatus {
  open,
  inProgress,
  waitingForResponse,
  resolved,
  closed,
}

extension TicketStatusExtension on TicketStatus {
  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.waitingForResponse:
        return 'Waiting for Response';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case TicketStatus.open:
        return AppColors.info;
      case TicketStatus.inProgress:
        return AppColors.warning;
      case TicketStatus.waitingForResponse:
        return Colors.orange;
      case TicketStatus.resolved:
        return AppColors.success;
      case TicketStatus.closed:
        return AppColors.textSecondary;
    }
  }

  IconData get icon {
    switch (this) {
      case TicketStatus.open:
        return Icons.mail;
      case TicketStatus.inProgress:
        return Icons.hourglass_empty;
      case TicketStatus.waitingForResponse:
        return Icons.reply;
      case TicketStatus.resolved:
        return Icons.check_circle;
      case TicketStatus.closed:
        return Icons.cancel;
    }
  }
}

/// Ticket Priority Enum
enum TicketPriority {
  low,
  medium,
  high,
  urgent,
}

extension TicketPriorityExtension on TicketPriority {
  String get displayName {
    switch (this) {
      case TicketPriority.low:
        return 'Low';
      case TicketPriority.medium:
        return 'Medium';
      case TicketPriority.high:
        return 'High';
      case TicketPriority.urgent:
        return 'Urgent';
    }
  }

  Color get color {
    switch (this) {
      case TicketPriority.low:
        return AppColors.success;
      case TicketPriority.medium:
        return AppColors.info;
      case TicketPriority.high:
        return AppColors.warning;
      case TicketPriority.urgent:
        return AppColors.error;
    }
  }
}

/// Ticket Category Enum
enum TicketCategory {
  technical,
  billing,
  account,
  courses,
  other,
}

extension TicketCategoryExtension on TicketCategory {
  String get displayName {
    switch (this) {
      case TicketCategory.technical:
        return 'Technical Issue';
      case TicketCategory.billing:
        return 'Billing & Payments';
      case TicketCategory.account:
        return 'Account & Profile';
      case TicketCategory.courses:
        return 'Courses & Content';
      case TicketCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case TicketCategory.technical:
        return Icons.bug_report;
      case TicketCategory.billing:
        return Icons.payment;
      case TicketCategory.account:
        return Icons.person;
      case TicketCategory.courses:
        return Icons.school;
      case TicketCategory.other:
        return Icons.help;
    }
  }
}

/// Ticket Message Model
class TicketMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final bool isFromSupport;
  final String? authorName;
  final List<String>? attachments;

  const TicketMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.isFromSupport,
    this.authorName,
    this.attachments,
  });
}

// ============================================================================
// WIDGETS
// ============================================================================

/// Help Category Card
class HelpCategoryCard extends StatelessWidget {
  final HelpCategory category;
  final VoidCallback? onTap;

  const HelpCategoryCard({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: category.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${category.articleCount} articles',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                category.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Help Article Card
class HelpArticleCard extends StatelessWidget {
  final HelpArticle article;
  final VoidCallback? onTap;
  final VoidCallback? onBookmark;

  const HelpArticleCard({
    super.key,
    required this.article,
    this.onTap,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (onBookmark != null)
                    IconButton(
                      icon: Icon(
                        article.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: article.isBookmarked
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      onPressed: onBookmark,
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                article.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.visibility,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${article.views} views',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.thumb_up,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${article.helpfulCount} helpful',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// FAQ Item Widget
class FAQItemWidget extends StatelessWidget {
  final FAQItem faq;
  final VoidCallback? onTap;
  final VoidCallback? onHelpful;

  const FAQItemWidget({
    super.key,
    required this.faq,
    this.onTap,
    this.onHelpful,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    faq.isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (faq.isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq.answer,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Was this helpful?',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: onHelpful,
                        icon: const Icon(Icons.thumb_up, size: 16),
                        label: Text(
                          faq.helpfulCount > 0
                              ? '${faq.helpfulCount}'
                              : 'Yes',
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Support Ticket Card
class SupportTicketCard extends StatelessWidget {
  final SupportTicket ticket;
  final VoidCallback? onTap;

  const SupportTicketCard({
    super.key,
    required this.ticket,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.subject,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TicketStatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                ticket.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TicketPriorityBadge(priority: ticket.priority),
                  const SizedBox(width: 12),
                  Icon(
                    ticket.category.icon,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ticket.category.displayName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(ticket.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';

    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Ticket Status Badge
class TicketStatusBadge extends StatelessWidget {
  final TicketStatus status;
  final bool showIcon;

  const TicketStatusBadge({
    super.key,
    required this.status,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: status.color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              status.icon,
              size: 14,
              color: status.color,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Ticket Priority Badge
class TicketPriorityBadge extends StatelessWidget {
  final TicketPriority priority;

  const TicketPriorityBadge({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: priority.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: priority.color,
        ),
      ),
    );
  }
}

/// Ticket Message Bubble
class TicketMessageBubble extends StatelessWidget {
  final TicketMessage message;

  const TicketMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFromSupport = message.isFromSupport;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isFromSupport ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isFromSupport) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.support_agent,
                size: 16,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFromSupport
                    ? AppColors.surface
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isFromSupport
                      ? AppColors.border
                      : AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.authorName != null) ...[
                    Text(
                      message.authorName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.content,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isFromSupport) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${time.day}/${time.month}/${time.year}';
  }
}

/// Quick Help Option Card
class QuickHelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const QuickHelpCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
