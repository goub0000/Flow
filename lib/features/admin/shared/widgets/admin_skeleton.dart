import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Skeleton Loading Widget
/// Displays animated loading placeholders
class AdminSkeleton extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AdminSkeleton({
    this.width,
    this.height,
    this.borderRadius,
    super.key,
  });

  const AdminSkeleton.circular({
    required double size,
    super.key,
  })  : width = size,
        height = size,
        borderRadius = null;

  const AdminSkeleton.rectangular({
    required this.width,
    required this.height,
    super.key,
  }) : borderRadius = null;

  @override
  State<AdminSkeleton> createState() => _AdminSkeletonState();
}

class _AdminSkeletonState extends State<AdminSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.border,
                AppColors.border.withValues(alpha: 0.5),
                AppColors.border,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton for Stats Card
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
              const AdminSkeleton(width: 80, height: 14),
              AdminSkeleton.circular(size: 20),
            ],
          ),
          const SizedBox(height: 12),
          const AdminSkeleton(width: 100, height: 32),
          const SizedBox(height: 4),
          const AdminSkeleton(width: 120, height: 12),
        ],
      ),
    );
  }
}

/// Skeleton for Table Row
class SkeletonTableRow extends StatelessWidget {
  final int columns;

  const SkeletonTableRow({
    this.columns = 6,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(
          columns,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AdminSkeleton(
                height: 16,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton for Data Table
class SkeletonDataTable extends StatelessWidget {
  final int rows;
  final int columns;

  const SkeletonDataTable({
    this.rows = 10,
    this.columns = 6,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: List.generate(
                columns,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: const AdminSkeleton(
                      height: 16,
                      width: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Rows
          ...List.generate(
            rows,
            (index) => Column(
              children: [
                SkeletonTableRow(columns: columns),
                if (index < rows - 1)
                  Divider(height: 1, color: AppColors.border),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for Card List
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AdminSkeleton.circular(size: 48),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AdminSkeleton(width: 150, height: 16),
                    const SizedBox(height: 8),
                    AdminSkeleton(width: 200, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const AdminSkeleton(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          const AdminSkeleton(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          AdminSkeleton(width: 250, height: 14),
        ],
      ),
    );
  }
}

/// Skeleton Grid Layout
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const SkeletonGrid({
    this.itemCount = 6,
    this.crossAxisCount = 3,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonStatCard(),
    );
  }
}

/// Skeleton List
class SkeletonList extends StatelessWidget {
  final int itemCount;

  const SkeletonList({
    this.itemCount = 5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => const SkeletonCard(),
    );
  }
}
