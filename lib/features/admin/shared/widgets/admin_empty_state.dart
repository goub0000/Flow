import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Enhanced Empty State Widget
/// Displays engaging empty states with icons and actions
class AdminEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const AdminEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: iconColor ?? AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add, size: 20),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Predefined Empty States for common scenarios

class NoDataEmptyState extends StatelessWidget {
  final String? title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const NoDataEmptyState({
    this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdminEmptyState(
      icon: Icons.inbox_outlined,
      title: title ?? 'No Data Available',
      description:
          description ?? 'There is no data to display at the moment.',
      actionLabel: actionLabel,
      onAction: onAction,
      iconColor: AppColors.textSecondary,
    );
  }
}

class NoResultsEmptyState extends StatelessWidget {
  final String? searchQuery;
  final VoidCallback? onClearSearch;

  const NoResultsEmptyState({
    this.searchQuery,
    this.onClearSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdminEmptyState(
      icon: Icons.search_off,
      title: 'No Results Found',
      description: searchQuery != null
          ? 'No results found for "$searchQuery". Try adjusting your search.'
          : 'No results match your current filters. Try adjusting them.',
      actionLabel: onClearSearch != null ? 'Clear Search' : null,
      onAction: onClearSearch,
      iconColor: AppColors.warning,
    );
  }
}

class ErrorEmptyState extends StatelessWidget {
  final String? title;
  final String? description;
  final VoidCallback? onRetry;

  const ErrorEmptyState({
    this.title,
    this.description,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdminEmptyState(
      icon: Icons.error_outline,
      title: title ?? 'Something Went Wrong',
      description:
          description ?? 'An error occurred while loading the data.',
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
      iconColor: AppColors.error,
    );
  }
}

class NoPermissionEmptyState extends StatelessWidget {
  final String? title;
  final String? description;

  const NoPermissionEmptyState({
    this.title,
    this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdminEmptyState(
      icon: Icons.lock_outline,
      title: title ?? 'Access Restricted',
      description: description ??
          'You do not have permission to access this feature.',
      iconColor: AppColors.error,
    );
  }
}

class ComingSoonEmptyState extends StatelessWidget {
  final String featureName;
  final String? description;

  const ComingSoonEmptyState({
    required this.featureName,
    this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdminEmptyState(
      icon: Icons.construction_outlined,
      title: '$featureName Coming Soon',
      description: description ??
          'This feature is under development and will be available soon.',
      iconColor: AppColors.primary,
    );
  }
}
