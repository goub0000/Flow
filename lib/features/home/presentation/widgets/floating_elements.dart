import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A widget that floats up and down with a gentle animation.
class FloatingElement extends StatefulWidget {
  final Widget child;
  final double floatHeight;
  final Duration duration;
  final Curve curve;
  final double delay;

  const FloatingElement({
    super.key,
    required this.child,
    this.floatHeight = 10,
    this.duration = const Duration(seconds: 3),
    this.curve = Curves.easeInOut,
    this.delay = 0,
  });

  @override
  State<FloatingElement> createState() => _FloatingElementState();
}

class _FloatingElementState extends State<FloatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: -widget.floatHeight / 2,
      end: widget.floatHeight / 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    // Start with delay
    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
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
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: widget.child,
        );
      },
    );
  }
}

/// A widget that rotates slowly and continuously.
class RotatingElement extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool clockwise;

  const RotatingElement({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 20),
    this.clockwise = true,
  });

  @override
  State<RotatingElement> createState() => _RotatingElementState();
}

class _RotatingElementState extends State<RotatingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = widget.clockwise
            ? _controller.value * 2 * math.pi
            : -_controller.value * 2 * math.pi;
        return Transform.rotate(
          angle: angle,
          child: widget.child,
        );
      },
    );
  }
}

/// A widget that scales with a pulsing effect.
class PulsingElement extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const PulsingElement({
    super.key,
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<PulsingElement> createState() => _PulsingElementState();
}

class _PulsingElementState extends State<PulsingElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
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
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// A parallax container that moves based on scroll position.
class ParallaxContainer extends StatelessWidget {
  final Widget child;
  final double parallaxFactor;
  final ScrollController scrollController;
  final double baseOffset;

  const ParallaxContainer({
    super.key,
    required this.child,
    required this.scrollController,
    this.parallaxFactor = 0.5,
    this.baseOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final scrollOffset = scrollController.hasClients
            ? scrollController.offset
            : 0.0;
        final parallaxOffset = scrollOffset * parallaxFactor;

        return Transform.translate(
          offset: Offset(0, baseOffset - parallaxOffset),
          child: child,
        );
      },
    );
  }
}

/// Decorative floating shapes for backgrounds.
class FloatingShapes extends StatelessWidget {
  final Color? primaryColor;
  final Color? secondaryColor;
  final double opacity;

  const FloatingShapes({
    super.key,
    this.primaryColor,
    this.secondaryColor,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = primaryColor ?? theme.colorScheme.primary;
    final secondary = secondaryColor ?? theme.colorScheme.secondary;

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,  // Fix: ensure Stack fills available space
        clipBehavior: Clip.none,  // Allow overflow for positioned elements
        children: [
          // Invisible spacer to give Stack size
          const SizedBox.expand(),
          // Top right circle
          Positioned(
            top: -50,
            right: -50,
            child: FloatingElement(
              floatHeight: 15,
              duration: const Duration(seconds: 4),
              delay: 0,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: opacity),
                ),
              ),
            ),
          ),
          // Bottom left circle
          Positioned(
            bottom: -30,
            left: -30,
            child: FloatingElement(
              floatHeight: 12,
              duration: const Duration(seconds: 5),
              delay: 0.5,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondary.withValues(alpha: opacity),
                ),
              ),
            ),
          ),
          // Middle right small circle
          Positioned(
            top: 200,
            right: 100,
            child: FloatingElement(
              floatHeight: 8,
              duration: const Duration(seconds: 3),
              delay: 1,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: opacity * 0.7),
                ),
              ),
            ),
          ),
          // Left side medium circle
          Positioned(
            top: 300,
            left: 50,
            child: FloatingElement(
              floatHeight: 10,
              duration: const Duration(seconds: 4),
              delay: 1.5,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondary.withValues(alpha: opacity * 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A mouse-following gradient effect for hero sections.
class MouseFollowingGradient extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double intensity;

  const MouseFollowingGradient({
    super.key,
    required this.child,
    required this.colors,
    this.intensity = 0.3,
  });

  @override
  State<MouseFollowingGradient> createState() => _MouseFollowingGradientState();
}

class _MouseFollowingGradientState extends State<MouseFollowingGradient> {
  Offset _mousePosition = const Offset(0.5, 0.5);

  void _updateMousePosition(PointerEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final size = box.size;
      final localPosition = box.globalToLocal(event.position);
      setState(() {
        _mousePosition = Offset(
          (localPosition.dx / size.width).clamp(0, 1),
          (localPosition.dy / size.height).clamp(0, 1),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _updateMousePosition,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(
              (_mousePosition.dx * 2) - 1,
              (_mousePosition.dy * 2) - 1,
            ),
            radius: 1.5,
            colors: [
              widget.colors.first.withValues(alpha: widget.intensity),
              widget.colors.last.withValues(alpha: 0),
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

/// Animated gradient background that shifts colors.
class AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Widget? child;

  const AnimatedGradientBackground({
    super.key,
    required this.colors,
    this.duration = const Duration(seconds: 10),
    this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final angle = t * 2 * math.pi;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(math.cos(angle), math.sin(angle)),
              end: Alignment(-math.cos(angle), -math.sin(angle)),
              colors: widget.colors,
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}
