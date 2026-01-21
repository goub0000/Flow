import 'package:flutter/material.dart';
import '../../../../core/constants/home_constants.dart';
import '../../../../core/theme/app_colors.dart';

/// An interactive card widget with hover/press lift effects.
///
/// Features:
/// - Scale animation on hover (1.02x)
/// - Increased shadow elevation on hover
/// - Smooth 200ms transitions
/// - Optional gradient border on hover
/// - Touch feedback for mobile
class HoverLiftCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? hoverBorderColor;
  final bool showHoverBorder;
  final double hoverScale;
  final double baseElevation;
  final double hoverElevation;
  final Duration animationDuration;
  final Curve animationCurve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const HoverLiftCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 28,
    this.backgroundColor,
    this.hoverBorderColor,
    this.showHoverBorder = false,
    this.hoverScale = HomeConstants.hoverScale,
    this.baseElevation = 0,
    this.hoverElevation = HomeConstants.hoverElevation,
    this.animationDuration = HomeConstants.hoverDuration,
    this.animationCurve = HomeConstants.hoverCurve,
    this.padding,
    this.margin,
  });

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _scale {
    if (_isPressed) return widget.hoverScale * 0.98;
    if (_isHovered) return widget.hoverScale;
    return 1.0;
  }

  double get _elevation {
    if (_isPressed) return widget.baseElevation;
    if (_isHovered) return widget.hoverElevation;
    return widget.baseElevation;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final borderColor = widget.hoverBorderColor ?? theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: widget.animationDuration,
          curve: widget.animationCurve,
          margin: widget.margin,
          transform: Matrix4.identity()..scale(_scale),
          transformAlignment: Alignment.center,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            curve: widget.animationCurve,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.showHoverBorder && _isHovered
                  ? Border.all(
                      color: borderColor.withOpacity(0.5),
                      width: 2,
                    )
                  : Border.all(
                      color: theme.colorScheme.outlineVariant,
                      width: 1,
                    ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                  blurRadius: _elevation * 2,
                  offset: Offset(0, _elevation / 2),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A card with gradient border effect on hover.
class GradientBorderCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final double borderWidth;
  final List<Color>? gradientColors;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GradientBorderCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 28,
    this.borderWidth = 2,
    this.gradientColors,
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  @override
  State<GradientBorderCard> createState() => _GradientBorderCardState();
}

class _GradientBorderCardState extends State<GradientBorderCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColors = widget.gradientColors ??
        [
          AppColors.primary,
          AppColors.terracotta,
          AppColors.accent,
        ];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: HomeConstants.hoverDuration,
          curve: HomeConstants.hoverCurve,
          margin: widget.margin,
          transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: _isHovered
                ? LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: !_isHovered
                ? Border.all(
                    color: theme.colorScheme.outlineVariant,
                    width: widget.borderWidth,
                  )
                : null,
          ),
          child: Container(
            margin: _isHovered ? EdgeInsets.all(widget.borderWidth) : null,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(
                widget.borderRadius - (_isHovered ? widget.borderWidth : 0),
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A simple elevated card with smooth hover transitions.
class ElevatedHoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  const ElevatedHoverCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 16,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  State<ElevatedHoverCard> createState() => _ElevatedHoverCardState();
}

class _ElevatedHoverCardState extends State<ElevatedHoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovered ? 0.12 : 0.06),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
