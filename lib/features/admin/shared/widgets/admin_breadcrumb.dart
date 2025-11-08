import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Breadcrumb Navigation Widget
/// Provides hierarchical navigation path for admin pages
class AdminBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const AdminBreadcrumb({
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.home_outlined,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == items.length - 1;

            return Row(
              children: [
                if (index > 0) _buildSeparator(),
                _buildBreadcrumbItem(context, item, isLast),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.chevron_right,
        size: 16,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildBreadcrumbItem(
    BuildContext context,
    BreadcrumbItem item,
    bool isLast,
  ) {
    if (isLast) {
      return Text(
        item.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      );
    }

    return InkWell(
      onTap: item.route != null ? () => context.go(item.route!) : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          item.label,
          style: TextStyle(
            fontSize: 13,
            color: item.route != null
                ? AppColors.primary
                : AppColors.textSecondary,
            decoration:
                item.route != null ? TextDecoration.underline : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}

/// Breadcrumb Item
class BreadcrumbItem {
  final String label;
  final String? route;

  const BreadcrumbItem({
    required this.label,
    this.route,
  });
}
