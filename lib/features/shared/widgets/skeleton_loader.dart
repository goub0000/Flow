import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Skeleton loading widgets for displaying loading states
///
/// Provides shimmer-like animated placeholders while content is loading.
/// Use these instead of simple CircularProgressIndicator for better UX.
///
/// Usage:
/// ```dart
/// isLoading
///   ? SkeletonListTile()
///   : ListTile(...)
/// ```

class SkeletonLoader extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SkeletonLoader({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
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
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEBEBF4),
                Color(0xFFF4F4F4),
                Color(0xFFEBEBF4),
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Basic skeleton box (rectangle)
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

/// Skeleton circle (avatar placeholder)
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.border,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Skeleton for text lines
class SkeletonLine extends StatelessWidget {
  final double? width;
  final double height;

  const SkeletonLine({
    super.key,
    this.width,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(height / 2),
    );
  }
}

/// Skeleton for a list tile (common pattern)
class SkeletonListTile extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lineCount;

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lineCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasLeading) ...[
            const SkeletonCircle(size: 48),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 150),
                const SizedBox(height: 8),
                for (int i = 0; i < lineCount - 1; i++) ...[
                  SkeletonLine(
                    width: i == lineCount - 2 ? 100 : null,
                    height: 14,
                  ),
                  if (i < lineCount - 2) const SizedBox(height: 6),
                ],
              ],
            ),
          ),
          if (hasTrailing) ...[
            const SizedBox(width: 16),
            const SkeletonBox(width: 24, height: 24),
          ],
        ],
      ),
    );
  }
}

/// Skeleton for a card (common pattern)
class SkeletonCard extends StatelessWidget {
  final double? height;

  const SkeletonCard({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: SkeletonLine(height: 20),
                ),
                const SizedBox(width: 16),
                SkeletonBox(
                  width: 60,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLine(height: 14),
            const SizedBox(height: 6),
            const SkeletonLine(width: 200, height: 14),
            const Spacer(),
            Row(
              children: [
                const SkeletonBox(width: 80, height: 32),
                const Spacer(),
                const SkeletonBox(width: 24, height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for dashboard stats card
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLine(width: 80, height: 14),
                SkeletonBox(
                  width: 32,
                  height: 32,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLine(width: 100, height: 32),
            const SizedBox(height: 8),
            const SkeletonLine(width: 120, height: 12),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for course/program card
class SkeletonCourseCard extends StatelessWidget {
  const SkeletonCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          SkeletonBox(
            width: double.infinity,
            height: 160,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonLine(width: 200, height: 20),
                const SizedBox(height: 8),
                const SkeletonLine(height: 14),
                const SizedBox(height: 6),
                const SkeletonLine(width: 180, height: 14),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const SkeletonBox(width: 60, height: 20),
                    const SizedBox(width: 16),
                    const SkeletonBox(width: 80, height: 20),
                    const Spacer(),
                    SkeletonBox(
                      width: 80,
                      height: 36,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton for application card
class SkeletonApplicationCard extends StatelessWidget {
  const SkeletonApplicationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: SkeletonLine(width: 180, height: 18),
                ),
                const SizedBox(width: 16),
                SkeletonBox(
                  width: 80,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const SkeletonLine(width: 150, height: 14),
            const SizedBox(height: 8),
            Row(
              children: [
                const SkeletonBox(width: 16, height: 16),
                const SizedBox(width: 8),
                const SkeletonLine(width: 120, height: 12),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLine(width: 100, height: 14),
                SkeletonBox(
                  width: 100,
                  height: 32,
                  borderRadius: BorderRadius.circular(16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid of skeleton cards
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final Widget Function(int) itemBuilder;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}

/// List of skeleton items
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int) itemBuilder;
  final EdgeInsets? padding;

  const SkeletonList({
    super.key,
    this.itemCount = 10,
    required this.itemBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding ?? const EdgeInsets.all(8),
      itemCount: itemCount,
      itemBuilder: (context, index) => itemBuilder(index),
    );
  }
}
