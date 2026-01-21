import 'package:flutter/material.dart';

/// An animated counter that counts up from 0 to a target value.
///
/// Triggers animation when the widget becomes visible in the viewport.
class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final String suffix;
  final String? prefix;
  final Duration duration;
  final Curve curve;
  final TextStyle? textStyle;
  final bool startOnVisible;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.suffix = '',
    this.prefix,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeOutCubic,
    this.textStyle,
    this.startOnVisible = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (!widget.startOnVisible) {
      _controller.forward();
      _hasAnimated = true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
    }
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final RenderObject? renderObject = _key.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;

    // Start animation when element is 80% up the screen
    if (position.dy < screenHeight * 0.8 && position.dy > -box.size.height) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int value) {
    if (value >= 1000) {
      final double k = value / 1000;
      if (k == k.roundToDouble()) {
        return '${k.round()}K';
      }
      return '${k.toStringAsFixed(1)}K';
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Schedule visibility check on scroll
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: AnimatedBuilder(
        key: _key,
        animation: _animation,
        builder: (context, child) {
          final value = _animation.value.round();
          final displayValue = _formatNumber(value);
          return Text(
            '${widget.prefix ?? ''}$displayValue${widget.suffix}',
            style: widget.textStyle,
          );
        },
      ),
    );
  }
}

/// A row of animated stat counters
class AnimatedStatsRow extends StatelessWidget {
  final List<StatItem> stats;
  final Duration staggerDelay;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;

  const AnimatedStatsRow({
    super.key,
    required this.stats,
    this.staggerDelay = const Duration(milliseconds: 200),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spacing = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: spacing,
      runSpacing: 24,
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        return _AnimatedStatItem(
          stat: stat,
          delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
        );
      }).toList(),
    );
  }
}

class _AnimatedStatItem extends StatefulWidget {
  final StatItem stat;
  final Duration delay;

  const _AnimatedStatItem({
    required this.stat,
    required this.delay,
  });

  @override
  State<_AnimatedStatItem> createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<_AnimatedStatItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 20),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (!mounted || _hasAnimated) return;

    final RenderObject? renderObject = _key.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;

    if (position.dy < screenHeight * 0.85) {
      _hasAnimated = true;
      Future.delayed(widget.delay, () {
        if (mounted) _fadeController.forward();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: AnimatedBuilder(
        key: _key,
        animation: _fadeController,
        builder: (context, child) {
          return Transform.translate(
            offset: _slideAnimation.value,
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.stat.icon,
                    size: 28,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  AnimatedCounter(
                    targetValue: widget.stat.value,
                    suffix: widget.stat.suffix,
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    startOnVisible: _hasAnimated,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.stat.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Data class for a stat item
class StatItem {
  final IconData icon;
  final int value;
  final String suffix;
  final String label;

  const StatItem({
    required this.icon,
    required this.value,
    this.suffix = '+',
    required this.label,
  });
}
