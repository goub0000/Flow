import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Status badge widget for showing status indicators
class StatusBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  factory StatusBadge.pending() {
    return const StatusBadge(
      label: 'Pending',
      color: AppColors.warning,
      icon: Icons.pending,
    );
  }

  factory StatusBadge.approved() {
    return const StatusBadge(
      label: 'Approved',
      color: AppColors.success,
      icon: Icons.check_circle,
    );
  }

  factory StatusBadge.rejected() {
    return const StatusBadge(
      label: 'Rejected',
      color: AppColors.error,
      icon: Icons.cancel,
    );
  }

  factory StatusBadge.inProgress() {
    return const StatusBadge(
      label: 'In Progress',
      color: AppColors.info,
      icon: Icons.hourglass_empty,
    );
  }

  factory StatusBadge.completed() {
    return const StatusBadge(
      label: 'Completed',
      color: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = color ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: badgeColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
