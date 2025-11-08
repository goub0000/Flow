import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'shimmer_effect.dart';

/// Skeleton List Item - Loading placeholder for list items
class SkeletonListItem extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lineCount;

  const SkeletonListItem({
    this.hasLeading = true,
    this.hasTrailing = true,
    this.lineCount = 2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading (avatar/icon)
          if (hasLeading) ...[
            const SkeletonCircle(size: 48),
            const SizedBox(width: 16),
          ],

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 150, height: 16),
                const SizedBox(height: 8),
                if (lineCount > 1) ...[
                  SkeletonLine(
                    width: double.infinity,
                    height: 14,
                  ),
                ],
                if (lineCount > 2) ...[
                  const SizedBox(height: 6),
                  const SkeletonLine(width: 100, height: 12),
                ],
              ],
            ),
          ),

          // Trailing (icon/action)
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            const SkeletonBox(width: 24, height: 24),
          ],
        ],
      ),
    );
  }
}

/// Skeleton Card - Loading placeholder for cards
class SkeletonCard extends StatelessWidget {
  final double? width;
  final double height;
  final bool hasImage;

  const SkeletonCard({
    this.width,
    this.height = 200,
    this.hasImage = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          if (hasImage)
            SkeletonBox(
              width: double.infinity,
              height: height * 0.5,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 120, height: 18),
                const SizedBox(height: 12),
                SkeletonLine(
                  width: double.infinity,
                  height: 14,
                ),
                const SizedBox(height: 6),
                const SkeletonLine(width: 150, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton Table Row - Loading placeholder for table rows
class SkeletonTableRow extends StatelessWidget {
  final int columnCount;
  final List<double>? columnWidths;

  const SkeletonTableRow({
    this.columnCount = 5,
    this.columnWidths,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: List.generate(columnCount, (index) {
          final width = columnWidths != null && index < columnWidths!.length
              ? columnWidths![index]
              : 100.0;

          return Expanded(
            flex: width.toInt(),
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SkeletonLine(
                width: width,
                height: 14,
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Skeleton Profile Header - Loading placeholder for profile sections
class SkeletonProfileHeader extends StatelessWidget {
  const SkeletonProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar
          const SkeletonCircle(size: 80),
          const SizedBox(width: 24),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 200, height: 24),
                const SizedBox(height: 12),
                SkeletonLine(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: 8),
                const SkeletonLine(width: 150, height: 14),
              ],
            ),
          ),

          // Actions
          Column(
            children: [
              SkeletonBox(
                width: 100,
                height: 36,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 12),
              SkeletonBox(
                width: 100,
                height: 36,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Skeleton Stat Card - Loading placeholder for statistic cards
class SkeletonStatCard extends StatelessWidget {
  const SkeletonStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SkeletonLine(width: 100, height: 14),
              SkeletonBox(
                width: 32,
                height: 32,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonLine(width: 80, height: 32),
          const SizedBox(height: 8),
          const SkeletonLine(width: 120, height: 12),
        ],
      ),
    );
  }
}

/// Skeleton Form Field - Loading placeholder for form fields
class SkeletonFormField extends StatelessWidget {
  final double? width;

  const SkeletonFormField({
    this.width,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SkeletonLine(width: 100, height: 14),
        const SizedBox(height: 8),
        SkeletonBox(
          width: width ?? double.infinity,
          height: 48,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}

/// Skeleton Data Table - Loading placeholder for data tables
class SkeletonDataTable extends StatelessWidget {
  final int rowCount;
  final int columnCount;

  const SkeletonDataTable({
    this.rowCount = 5,
    this.columnCount = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SkeletonLine(
                      width: 100,
                      height: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Rows
          ...List.generate(
            rowCount,
            (index) => SkeletonTableRow(columnCount: columnCount),
          ),
        ],
      ),
    );
  }
}

/// Skeleton List - Loading placeholder for lists
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;

  const SkeletonList({
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: AppColors.border,
      ),
      itemBuilder: (context, index) => SkeletonListItem(
        hasLeading: hasLeading,
        hasTrailing: hasTrailing,
      ),
    );
  }
}
