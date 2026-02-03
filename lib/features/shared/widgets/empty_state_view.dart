import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

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
  static Widget noApplications(BuildContext context, {
    VoidCallback? onCreateFirst,
  }) {
    return EmptyStateView(
      icon: Icons.description_outlined,
      title: context.l10n.swEmptyStateNoApplicationsTitle,
      message: context.l10n.swEmptyStateNoApplicationsMessage,
      actionLabel: onCreateFirst != null ? context.l10n.swEmptyStateBrowsePrograms : null,
      onAction: onCreateFirst,
      iconColor: AppColors.primary,
    );
  }

  static Widget noActivities(BuildContext context) {
    return EmptyStateView(
      icon: Icons.inbox_outlined,
      title: context.l10n.swEmptyStateNoActivitiesTitle,
      message: context.l10n.swEmptyStateNoActivitiesMessage,
      iconColor: AppColors.info,
    );
  }

  static Widget noRecommendations(BuildContext context, {
    VoidCallback? onCompleteProfile,
  }) {
    return EmptyStateView(
      icon: Icons.lightbulb_outline,
      title: context.l10n.swEmptyStateNoRecommendationsTitle,
      message: context.l10n.swEmptyStateNoRecommendationsMessage,
      actionLabel: onCompleteProfile != null ? context.l10n.swEmptyStateCompleteProfile : null,
      onAction: onCompleteProfile,
      iconColor: AppColors.warning,
    );
  }

  static Widget noMessages(BuildContext context) {
    return EmptyStateView(
      icon: Icons.message_outlined,
      title: context.l10n.swEmptyStateNoMessagesTitle,
      message: context.l10n.swEmptyStateNoMessagesMessage,
      iconColor: AppColors.info,
    );
  }

  static Widget noSearchResults(BuildContext context, {
    VoidCallback? onClearFilters,
  }) {
    return EmptyStateView(
      icon: Icons.search_off,
      title: context.l10n.swEmptyStateNoResultsTitle,
      message: context.l10n.swEmptyStateNoResultsMessage,
      actionLabel: onClearFilters != null ? context.l10n.swEmptyStateClearFilters : null,
      onAction: onClearFilters,
      iconColor: AppColors.warning,
    );
  }

  static Widget noCourses(BuildContext context, {
    VoidCallback? onBrowse,
  }) {
    return EmptyStateView(
      icon: Icons.school_outlined,
      title: context.l10n.swEmptyStateNoCoursesTitle,
      message: context.l10n.swEmptyStateNoCoursesMessage,
      actionLabel: onBrowse != null ? context.l10n.swEmptyStateExplorePrograms : null,
      onAction: onBrowse,
      iconColor: AppColors.primary,
    );
  }

  static Widget noStudents(BuildContext context) {
    return EmptyStateView(
      icon: Icons.people_outline,
      title: context.l10n.swEmptyStateNoStudentsTitle,
      message: context.l10n.swEmptyStateNoStudentsMessage,
      iconColor: AppColors.info,
    );
  }

  static Widget noSessions(BuildContext context, {
    VoidCallback? onSchedule,
  }) {
    return EmptyStateView(
      icon: Icons.calendar_today_outlined,
      title: context.l10n.swEmptyStateNoSessionsTitle,
      message: context.l10n.swEmptyStateNoSessionsMessage,
      actionLabel: onSchedule != null ? context.l10n.swEmptyStateScheduleSession : null,
      onAction: onSchedule,
      iconColor: AppColors.success,
    );
  }

  static Widget noData(BuildContext context) {
    return EmptyStateView(
      icon: Icons.analytics_outlined,
      title: context.l10n.swEmptyStateNoDataTitle,
      message: context.l10n.swEmptyStateNoDataMessage,
      iconColor: AppColors.info,
    );
  }

  static Widget noNotifications(BuildContext context) {
    return EmptyStateView(
      icon: Icons.notifications_none,
      title: context.l10n.swEmptyStateNoNotificationsTitle,
      message: context.l10n.swEmptyStateNoNotificationsMessage,
      iconColor: AppColors.success,
    );
  }

  static Widget comingSoon(BuildContext context, {
    required String feature,
  }) {
    return EmptyStateView(
      icon: Icons.construction,
      title: context.l10n.swEmptyStateComingSoonTitle,
      message: context.l10n.swEmptyStateComingSoonMessage(feature),
      iconColor: AppColors.warning,
    );
  }

  static Widget noPermission(BuildContext context) {
    return EmptyStateView(
      icon: Icons.lock_outline,
      title: context.l10n.swEmptyStateAccessRestrictedTitle,
      message: context.l10n.swEmptyStateAccessRestrictedMessage,
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