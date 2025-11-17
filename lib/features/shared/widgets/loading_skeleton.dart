import 'package:flutter/material.dart';

enum SkeletonType {
  list,        // For list items
  grid,        // For grid items
  card,        // For single cards
  stats,       // For statistics cards
  text,        // For text lines
  activity,    // For activity feed items
  recommendation, // For recommendation cards
}

class LoadingSkeleton extends StatefulWidget {
  final SkeletonType type;
  final int itemCount;
  final double? height;
  final double? width;

  const LoadingSkeleton({
    super.key,
    required this.type,
    this.itemCount = 3,
    this.height,
    this.width,
  });

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.3,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case SkeletonType.list:
        return _buildListSkeleton();
      case SkeletonType.grid:
        return _buildGridSkeleton();
      case SkeletonType.card:
        return _buildCardSkeleton();
      case SkeletonType.stats:
        return _buildStatsSkeleton();
      case SkeletonType.text:
        return _buildTextSkeleton();
      case SkeletonType.activity:
        return _buildActivitySkeleton();
      case SkeletonType.recommendation:
        return _buildRecommendationSkeleton();
    }
  }

  Widget _buildListSkeleton() {
    return Column(
      children: List.generate(
        widget.itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: _buildSkeletonItem(
            child: Row(
              children: [
                _buildSkeletonBox(width: 48, height: 48, radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSkeletonBox(height: 14, width: double.infinity),
                      const SizedBox(height: 6),
                      _buildSkeletonBox(height: 12, width: 150),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _buildSkeletonItem(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(width: 40, height: 40, radius: 8),
                const Spacer(),
                _buildSkeletonBox(height: 14, width: double.infinity),
                const SizedBox(height: 6),
                _buildSkeletonBox(height: 12, width: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSkeleton() {
    return _buildSkeletonItem(
      child: Container(
        height: widget.height ?? 150,
        width: widget.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonBox(height: 20, width: 200),
            const SizedBox(height: 12),
            _buildSkeletonBox(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            _buildSkeletonBox(height: 14, width: double.infinity),
            const SizedBox(height: 8),
            _buildSkeletonBox(height: 14, width: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSkeleton() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _buildSkeletonItem(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSkeletonBox(width: 32, height: 32, radius: 16),
                const SizedBox(height: 8),
                _buildSkeletonBox(height: 20, width: 40),
                const SizedBox(height: 4),
                _buildSkeletonBox(height: 12, width: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        widget.itemCount,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: _buildSkeletonItem(
            child: _buildSkeletonBox(
              height: 14,
              width: index == widget.itemCount - 1
                  ? MediaQuery.of(context).size.width * 0.5
                  : double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivitySkeleton() {
    return Column(
      children: List.generate(
        widget.itemCount,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildSkeletonItem(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  _buildSkeletonBox(width: 40, height: 40, radius: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonBox(height: 14, width: 200),
                        const SizedBox(height: 6),
                        _buildSkeletonBox(height: 12, width: double.infinity),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildSkeletonBox(width: 50, height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSkeleton() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 8,
              right: index == widget.itemCount - 1 ? 0 : 8,
            ),
            child: _buildSkeletonItem(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSkeletonBox(width: 40, height: 40, radius: 8),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSkeletonBox(height: 16, width: 150),
                              const SizedBox(height: 4),
                              _buildSkeletonBox(height: 12, width: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSkeletonBox(height: 14, width: double.infinity),
                    const SizedBox(height: 6),
                    _buildSkeletonBox(height: 14, width: double.infinity),
                    const Spacer(),
                    _buildSkeletonBox(height: 32, width: 100, radius: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonItem({required Widget child}) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget _buildSkeletonBox({
    required double height,
    required double width,
    double radius = 4,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// Extension to create shimmer effect if needed
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
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
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _animation.value * 2, 0.0),
              end: Alignment(-1.0 + _animation.value * 2 + 1.0, 0.0),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}