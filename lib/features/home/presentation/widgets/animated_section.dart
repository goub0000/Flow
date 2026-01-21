import 'package:flutter/material.dart';
import '../../../../core/constants/home_constants.dart';

/// A widget that animates its child when it becomes visible in the viewport.
///
/// Uses scroll position calculations to determine visibility and triggers
/// a fade-in animation with optional slide effect. Respects reduced motion settings.
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double slideOffset;
  final Axis slideDirection;
  final double triggerOffset;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const AnimatedSection({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.slideOffset = 40.0,
    this.slideDirection = Axis.vertical,
    this.triggerOffset = 0.2,
    this.backgroundColor,
    this.padding,
  });

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    final slideBegin = widget.slideDirection == Axis.vertical
        ? Offset(0, widget.slideOffset)
        : Offset(widget.slideOffset, 0);

    _slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(bool isVisible) {
    if (isVisible && !_hasAnimated) {
      _hasAnimated = true;
      // Check for reduced motion preference
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) {
        _controller.value = 1.0;
      } else {
        _controller.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: _onVisibilityChanged,
      triggerOffset: widget.triggerOffset,
      child: Container(
        color: widget.backgroundColor,
        padding: widget.padding,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: _slideAnimation.value,
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A simple visibility detector that notifies when a widget enters the viewport.
///
/// This is a lightweight alternative to full visibility tracking packages.
class VisibilityDetector extends StatefulWidget {
  final Widget child;
  final void Function(bool isVisible) onVisibilityChanged;
  final double triggerOffset;

  const VisibilityDetector({
    super.key,
    required this.child,
    required this.onVisibilityChanged,
    this.triggerOffset = 0.2,
  });

  @override
  State<VisibilityDetector> createState() => _VisibilityDetectorState();
}

class _VisibilityDetectorState extends State<VisibilityDetector> {
  final GlobalKey _key = GlobalKey();
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderObject? renderObject = _key.currentContext?.findRenderObject();
    if (renderObject == null || !renderObject.attached) return;

    final RenderBox box = renderObject as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double screenHeight = MediaQuery.of(context).size.height;

    // Calculate how much of the widget is visible
    final double visibleTop = position.dy;
    final double triggerPoint = screenHeight * (1 - widget.triggerOffset);

    final bool isNowVisible = visibleTop < triggerPoint;

    if (isNowVisible != _isVisible) {
      _isVisible = isNowVisible;
      widget.onVisibilityChanged(_isVisible);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Schedule visibility check on each build
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVisibility());

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: Container(
        key: _key,
        child: widget.child,
      ),
    );
  }
}

/// A section container with automatic scroll-triggered animation and styling.
class AnimatedSectionContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final double maxWidth;
  final Duration animationDuration;

  const AnimatedSectionContainer({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(
      vertical: HomeConstants.sectionSpacingLarge,
      horizontal: 24,
    ),
    this.maxWidth = HomeConstants.maxContentWidth,
    this.animationDuration = HomeConstants.fadeInDuration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSection(
      duration: animationDuration,
      backgroundColor: backgroundColor,
      padding: padding,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
