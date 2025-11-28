import 'package:flutter/material.dart';

/// Responsive breakpoints following Material Design guidelines
///
/// Breakpoints:
/// - Compact (phone): 0 - 599dp
/// - Medium (tablet portrait): 600 - 839dp
/// - Expanded (tablet landscape / small desktop): 840 - 1199dp
/// - Large (desktop): 1200dp+
///
/// Usage:
/// ```dart
/// // Using breakpoints directly
/// if (Responsive.isCompact(context)) {
///   return MobileLayout();
/// }
///
/// // Using responsive builder
/// Responsive.builder(
///   context: context,
///   compact: (context) => MobileLayout(),
///   medium: (context) => TabletLayout(),
///   expanded: (context) => DesktopLayout(),
/// )
///
/// // Using responsive value
/// final padding = Responsive.value<double>(
///   context: context,
///   compact: 16,
///   medium: 24,
///   expanded: 32,
/// );
/// ```
class Responsive {
  Responsive._();

  // ============================================================
  // BREAKPOINTS (Material Design 3)
  // ============================================================

  /// Compact breakpoint max width (phones)
  static const double compactMax = 599;

  /// Medium breakpoint range (tablets portrait)
  static const double mediumMin = 600;
  static const double mediumMax = 839;

  /// Expanded breakpoint range (tablets landscape, small desktop)
  static const double expandedMin = 840;
  static const double expandedMax = 1199;

  /// Large breakpoint min (desktop)
  static const double largeMin = 1200;

  // ============================================================
  // SCREEN SIZE GETTERS
  // ============================================================

  /// Get the current screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Get the current screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  /// Get the device pixel ratio
  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.devicePixelRatioOf(context);
  }

  // ============================================================
  // BREAKPOINT CHECKS
  // ============================================================

  /// Is screen width in compact range (phone)?
  static bool isCompact(BuildContext context) {
    return screenWidth(context) <= compactMax;
  }

  /// Is screen width in medium range (tablet portrait)?
  static bool isMedium(BuildContext context) {
    final width = screenWidth(context);
    return width >= mediumMin && width <= mediumMax;
  }

  /// Is screen width in expanded range (tablet landscape)?
  static bool isExpanded(BuildContext context) {
    final width = screenWidth(context);
    return width >= expandedMin && width <= expandedMax;
  }

  /// Is screen width in large range (desktop)?
  static bool isLarge(BuildContext context) {
    return screenWidth(context) >= largeMin;
  }

  /// Is screen at least medium (tablet or larger)?
  static bool isMediumOrLarger(BuildContext context) {
    return screenWidth(context) >= mediumMin;
  }

  /// Is screen at least expanded (large tablet or desktop)?
  static bool isExpandedOrLarger(BuildContext context) {
    return screenWidth(context) >= expandedMin;
  }

  /// Is mobile (compact only)?
  static bool isMobile(BuildContext context) => isCompact(context);

  /// Is tablet (medium or expanded)?
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mediumMin && width < largeMin;
  }

  /// Is desktop (large)?
  static bool isDesktop(BuildContext context) => isLarge(context);

  // ============================================================
  // CURRENT BREAKPOINT
  // ============================================================

  /// Get the current breakpoint type
  static ScreenBreakpoint currentBreakpoint(BuildContext context) {
    final width = screenWidth(context);
    if (width < mediumMin) return ScreenBreakpoint.compact;
    if (width < expandedMin) return ScreenBreakpoint.medium;
    if (width < largeMin) return ScreenBreakpoint.expanded;
    return ScreenBreakpoint.large;
  }

  // ============================================================
  // RESPONSIVE VALUE HELPER
  // ============================================================

  /// Get a value based on current screen size
  ///
  /// [compact] is required (mobile baseline)
  /// [medium], [expanded], [large] fallback to previous breakpoint if not provided
  static T value<T>({
    required BuildContext context,
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    final breakpoint = currentBreakpoint(context);

    switch (breakpoint) {
      case ScreenBreakpoint.compact:
        return compact;
      case ScreenBreakpoint.medium:
        return medium ?? compact;
      case ScreenBreakpoint.expanded:
        return expanded ?? medium ?? compact;
      case ScreenBreakpoint.large:
        return large ?? expanded ?? medium ?? compact;
    }
  }

  // ============================================================
  // RESPONSIVE BUILDER
  // ============================================================

  /// Build different widgets based on screen size
  ///
  /// [compact] is required (mobile baseline)
  /// [medium], [expanded], [large] fallback to previous breakpoint if not provided
  static Widget builder({
    required BuildContext context,
    required Widget Function(BuildContext context) compact,
    Widget Function(BuildContext context)? medium,
    Widget Function(BuildContext context)? expanded,
    Widget Function(BuildContext context)? large,
  }) {
    final breakpoint = currentBreakpoint(context);

    switch (breakpoint) {
      case ScreenBreakpoint.compact:
        return compact(context);
      case ScreenBreakpoint.medium:
        return (medium ?? compact)(context);
      case ScreenBreakpoint.expanded:
        return (expanded ?? medium ?? compact)(context);
      case ScreenBreakpoint.large:
        return (large ?? expanded ?? medium ?? compact)(context);
    }
  }

  // ============================================================
  // GRID HELPERS
  // ============================================================

  /// Get recommended number of columns for a grid based on screen size
  static int gridColumns(BuildContext context) {
    return value<int>(
      context: context,
      compact: 4,
      medium: 8,
      expanded: 12,
      large: 12,
    );
  }

  /// Get recommended max content width for centered content
  static double? maxContentWidth(BuildContext context) {
    return value<double?>(
      context: context,
      compact: null, // Full width on mobile
      medium: null,
      expanded: 960,
      large: 1200,
    );
  }

  /// Get recommended horizontal padding based on screen size
  static double horizontalPadding(BuildContext context) {
    return value<double>(
      context: context,
      compact: 16,
      medium: 24,
      expanded: 32,
      large: 48,
    );
  }

  // ============================================================
  // SAFE AREA HELPERS
  // ============================================================

  /// Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return MediaQuery.paddingOf(context);
  }

  /// Get view insets (keyboard, etc.)
  static EdgeInsets viewInsets(BuildContext context) {
    return MediaQuery.viewInsetsOf(context);
  }

  /// Is keyboard visible?
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.viewInsetsOf(context).bottom > 0;
  }
}

/// Screen breakpoint types
enum ScreenBreakpoint {
  /// Phone (0-599dp)
  compact,

  /// Tablet portrait (600-839dp)
  medium,

  /// Tablet landscape / small desktop (840-1199dp)
  expanded,

  /// Desktop (1200dp+)
  large,
}

/// Extension on BuildContext for easier access
extension ResponsiveContext on BuildContext {
  /// Is compact (phone)?
  bool get isCompact => Responsive.isCompact(this);

  /// Is medium (tablet portrait)?
  bool get isMedium => Responsive.isMedium(this);

  /// Is expanded (tablet landscape)?
  bool get isExpanded => Responsive.isExpanded(this);

  /// Is large (desktop)?
  bool get isLarge => Responsive.isLarge(this);

  /// Is mobile?
  bool get isMobile => Responsive.isMobile(this);

  /// Is tablet?
  bool get isTablet => Responsive.isTablet(this);

  /// Is desktop?
  bool get isDesktop => Responsive.isDesktop(this);

  /// Current breakpoint
  ScreenBreakpoint get breakpoint => Responsive.currentBreakpoint(this);

  /// Screen width
  double get screenWidth => Responsive.screenWidth(this);

  /// Screen height
  double get screenHeight => Responsive.screenHeight(this);
}

/// Responsive layout widget that rebuilds on breakpoint changes
class ResponsiveLayout extends StatelessWidget {
  /// Widget for compact screens (phone)
  final Widget compact;

  /// Widget for medium screens (tablet portrait)
  final Widget? medium;

  /// Widget for expanded screens (tablet landscape)
  final Widget? expanded;

  /// Widget for large screens (desktop)
  final Widget? large;

  const ResponsiveLayout({
    super.key,
    required this.compact,
    this.medium,
    this.expanded,
    this.large,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive.builder(
      context: context,
      compact: (_) => compact,
      medium: medium != null ? (_) => medium! : null,
      expanded: expanded != null ? (_) => expanded! : null,
      large: large != null ? (_) => large! : null,
    );
  }
}

/// Responsive centered content widget with max width constraints
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMaxWidth = maxWidth ?? Responsive.maxContentWidth(context);
    final effectivePadding = padding ??
        EdgeInsets.symmetric(horizontal: Responsive.horizontalPadding(context));

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth ?? double.infinity,
        ),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}
