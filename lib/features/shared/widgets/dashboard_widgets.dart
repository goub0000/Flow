import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Dashboard Widgets
///
/// Provides comprehensive dashboard components:
/// - Activity feed
/// - Quick actions grid
/// - Recommendation cards
/// - Progress summary
///
/// Backend Integration TODO:
/// ```dart
/// // Fetch activity feed from API
/// import 'package:dio/dio.dart';
///
/// class ActivityService {
///   final Dio _dio;
///
///   Future<List<ActivityItem>> getRecentActivity({int limit = 10}) async {
///     final response = await _dio.get('/api/activity', queryParameters: {
///       'limit': limit,
///     });
///     return (response.data['activities'] as List)
///         .map((json) => ActivityItem.fromJson(json))
///         .toList();
///   }
///
///   Future<List<QuickAction>> getQuickActions() async {
///     final response = await _dio.get('/api/dashboard/quick-actions');
///     return (response.data['actions'] as List)
///         .map((json) => QuickAction.fromJson(json))
///         .toList();
///   }
/// }
/// ```

/// Activity Item Model
class ActivityItem {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  ActivityItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.imageUrl,
    this.metadata,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      type: ActivityType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ActivityType.general,
      ),
      imageUrl: json['imageUrl'],
      metadata: json['metadata'],
    );
  }
}

enum ActivityType {
  general,
  course,
  application,
  payment,
  achievement,
  message,
}

/// Quick Action Model
class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final int? badgeCount;

  QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badgeCount,
  });
}

/// Activity Feed Widget
class ActivityFeed extends StatelessWidget {
  final List<ActivityItem> activities;
  final VoidCallback? onViewAll;
  final Function(ActivityItem)? onActivityTap;

  const ActivityFeed({
    super.key,
    required this.activities,
    this.onViewAll,
    this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.dashCommonRecentActivity,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(context.l10n.dashCommonViewAll),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Activities
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.history,
                      size: 48,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.dashCommonNoRecentActivity,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return ActivityTile(
                  activity: activity,
                  onTap: () => onActivityTap?.call(activity),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Activity Tile
class ActivityTile extends StatelessWidget {
  final ActivityItem activity;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = timeago.format(activity.timestamp);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getActivityColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getActivityIcon(),
                color: _getActivityColor(),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon() {
    switch (activity.type) {
      case ActivityType.course:
        return Icons.school;
      case ActivityType.application:
        return Icons.description;
      case ActivityType.payment:
        return Icons.payment;
      case ActivityType.achievement:
        return Icons.emoji_events;
      case ActivityType.message:
        return Icons.message;
      default:
        return Icons.notifications;
    }
  }

  Color _getActivityColor() {
    switch (activity.type) {
      case ActivityType.course:
        return AppColors.primary;
      case ActivityType.application:
        return AppColors.info;
      case ActivityType.payment:
        return AppColors.success;
      case ActivityType.achievement:
        return AppColors.warning;
      case ActivityType.message:
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}

/// Quick Actions Grid
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final int crossAxisCount;

  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return QuickActionButton(action: action);
      },
    );
  }
}

/// Quick Action Button
class QuickActionButton extends StatelessWidget {
  final QuickAction action;

  const QuickActionButton({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: action.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (action.badgeCount != null && action.badgeCount! > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      action.badgeCount! > 99 ? '99+' : '${action.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Recommendation Card
class RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String? badge;
  final VoidCallback onTap;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.badge,
    required this.onTap,
  });

  /// Get icon based on recommendation title/type
  IconData _getRecommendationIcon() {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('university') || lowerTitle.contains('universities')) {
      return Icons.school;
    } else if (lowerTitle.contains('path') || lowerTitle.contains('assessment')) {
      return Icons.explore;
    } else if (lowerTitle.contains('scholarship') || lowerTitle.contains('financial')) {
      return Icons.attach_money;
    } else if (lowerTitle.contains('computer') || lowerTitle.contains('technology') || lowerTitle.contains('data')) {
      return Icons.computer;
    } else if (lowerTitle.contains('business') || lowerTitle.contains('management')) {
      return Icons.business;
    } else if (lowerTitle.contains('health') || lowerTitle.contains('medical')) {
      return Icons.local_hospital;
    } else if (lowerTitle.contains('environment') || lowerTitle.contains('sustainability')) {
      return Icons.eco;
    } else if (lowerTitle.contains('course')) {
      return Icons.menu_book;
    } else if (lowerTitle.contains('program')) {
      return Icons.school_outlined;
    }
    return Icons.lightbulb_outline;
  }

  /// Get color based on recommendation type
  Color _getRecommendationColor() {
    final lowerTitle = title.toLowerCase();
    if (lowerTitle.contains('university') || lowerTitle.contains('universities')) {
      return AppColors.primary;
    } else if (lowerTitle.contains('path') || lowerTitle.contains('assessment')) {
      return AppColors.info;
    } else if (lowerTitle.contains('scholarship') || lowerTitle.contains('financial')) {
      return AppColors.success;
    } else if (lowerTitle.contains('computer') || lowerTitle.contains('technology') || lowerTitle.contains('data')) {
      return const Color(0xFF5C6BC0); // Indigo
    } else if (lowerTitle.contains('business') || lowerTitle.contains('management')) {
      return const Color(0xFF26A69A); // Teal
    } else if (lowerTitle.contains('health') || lowerTitle.contains('medical')) {
      return const Color(0xFFEF5350); // Red
    } else if (lowerTitle.contains('environment') || lowerTitle.contains('sustainability')) {
      return const Color(0xFF66BB6A); // Green
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValidImage = imageUrl.isNotEmpty &&
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'));
    final iconColor = _getRecommendationColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 280,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image or Fallback
              Stack(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          iconColor.withValues(alpha: 0.15),
                          iconColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: hasValidImage
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback to icon on image load error
                                return Center(
                                  child: Icon(
                                    _getRecommendationIcon(),
                                    size: 48,
                                    color: iconColor,
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    strokeWidth: 2,
                                    color: iconColor,
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getRecommendationIcon(),
                              size: 48,
                              color: iconColor,
                            ),
                          ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Recommendations Carousel
class RecommendationsCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;
  final Function(Map<String, dynamic>) onTap;

  const RecommendationsCarousel({
    super.key,
    required this.recommendations,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.l10n.dashCommonRecommendedForYou,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final rec = recommendations[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < recommendations.length - 1 ? 12 : 0,
                ),
                child: RecommendationCard(
                  title: rec['title'],
                  description: rec['description'],
                  imageUrl: rec['imageUrl'] ?? '',
                  badge: rec['badge'],
                  onTap: () => onTap(rec),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(context.l10n.dashCommonViewAll),
            ),
        ],
      ),
    );
  }
}
