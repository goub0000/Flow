import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final Widget? customIcon;
  final List<Widget>? additionalActions;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.customIcon,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary.withOpacity(0.6);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or Custom Widget
            if (customIcon != null)
              customIcon!
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: effectiveIconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: effectiveIconColor,
                ),
              ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],

            // Additional Actions
            if (additionalActions != null && additionalActions!.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...additionalActions!,
            ],
          ],
        ),
      ),
    );
  }
}

// Predefined empty states for common scenarios
class CommonEmptyStates {
  static Widget noApplications({
    VoidCallback? onCreateFirst,
  }) {
    return EmptyStateView(
      icon: Icons.description_outlined,
      title: 'No Applications Yet',
      message: 'Start your journey by exploring programs and submitting your first application.',
      actionLabel: onCreateFirst != null ? 'Browse Programs' : null,
      onAction: onCreateFirst,
      iconColor: AppColors.primary,
    );
  }

  static Widget noActivities() {
    return EmptyStateView(
      icon: Icons.inbox_outlined,
      title: 'No Recent Activities',
      message: 'Your recent activities and updates will appear here as you use the platform.',
      iconColor: AppColors.info,
    );
  }

  static Widget noRecommendations({
    VoidCallback? onCompleteProfile,
  }) {
    return EmptyStateView(
      icon: Icons.lightbulb_outline,
      title: 'No Recommendations',
      message: 'Complete your profile to receive personalized recommendations based on your interests and goals.',
      actionLabel: onCompleteProfile != null ? 'Complete Profile' : null,
      onAction: onCompleteProfile,
      iconColor: AppColors.warning,
    );
  }

  static Widget noMessages() {
    return EmptyStateView(
      icon: Icons.message_outlined,
      title: 'No Messages',
      message: 'Your conversations and notifications will appear here.',
      iconColor: AppColors.info,
    );
  }

  static Widget noSearchResults({
    VoidCallback? onClearFilters,
  }) {
    return EmptyStateView(
      icon: Icons.search_off,
      title: 'No Results Found',
      message: 'Try adjusting your search criteria or filters to find what you\'re looking for.',
      actionLabel: onClearFilters != null ? 'Clear Filters' : null,
      onAction: onClearFilters,
      iconColor: AppColors.warning,
    );
  }

  static Widget noCourses({
    VoidCallback? onBrowse,
  }) {
    return EmptyStateView(
      icon: Icons.school_outlined,
      title: 'No Courses Available',
      message: 'Check back later for new courses or explore other learning opportunities.',
      actionLabel: onBrowse != null ? 'Explore Programs' : null,
      onAction: onBrowse,
      iconColor: AppColors.primary,
    );
  }

  static Widget noStudents() {
    return const EmptyStateView(
      icon: Icons.people_outline,
      title: 'No Students',
      message: 'Students you\'re counseling will appear here once they\'re assigned or request your guidance.',
      iconColor: AppColors.info,
    );
  }

  static Widget noSessions({
    VoidCallback? onSchedule,
  }) {
    return EmptyStateView(
      icon: Icons.calendar_today_outlined,
      title: 'No Upcoming Sessions',
      message: 'You don\'t have any counseling sessions scheduled.',
      actionLabel: onSchedule != null ? 'Schedule Session' : null,
      onAction: onSchedule,
      iconColor: AppColors.success,
    );
  }

  static Widget noData() {
    return EmptyStateView(
      icon: Icons.analytics_outlined,
      title: 'No Data Available',
      message: 'Data will appear here once there\'s activity to display.',
      iconColor: AppColors.info,
    );
  }

  static Widget noNotifications() {
    return EmptyStateView(
      icon: Icons.notifications_none,
      title: 'No Notifications',
      message: 'You\'re all caught up! New notifications will appear here.',
      iconColor: AppColors.success,
    );
  }

  static Widget comingSoon({
    required String feature,
  }) {
    return EmptyStateView(
      icon: Icons.construction,
      title: 'Coming Soon',
      message: '$feature is currently under development and will be available soon.',
      iconColor: AppColors.warning,
    );
  }

  static Widget noPermission() {
    return EmptyStateView(
      icon: Icons.lock_outline,
      title: 'Access Restricted',
      message: 'You don\'t have permission to view this content. Contact your administrator if you need access.',
      iconColor: AppColors.error,
    );
  }
}

// Compact empty state for smaller containers
class CompactEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

// List empty state widget
class ListEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const ListEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Row(
        children: [
          Icon(
            icon,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: onAction,
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}