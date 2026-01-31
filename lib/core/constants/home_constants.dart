import 'package:flutter/animation.dart';

/// Constants for the home screen UI
class HomeConstants {
  HomeConstants._();

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double wideDesktopBreakpoint = 1600;

  // Layout constraints
  static const double maxContentWidth = 1200;
  static const double maxHeroWidth = 1000;
  static const double maxFooterWidth = 1000;

  // Section spacing - increased for visual rhythm
  static const double sectionSpacingLarge = 96;
  static const double sectionSpacingMedium = 72;
  static const double sectionSpacingSmall = 48;

  // Card sizing
  static const double cardMinWidth = 280;
  static const double cardMaxWidth = 400;
  static const double cardPadding = 40;

  // Touch targets (WCAG accessibility)
  static const double minTouchTarget = 48;
  static const double buttonMinHeight = 56;

  // Animation durations
  static const Duration scrollAnimationDuration = Duration(milliseconds: 500);
  static const Duration gradientAnimationDuration = Duration(seconds: 20);
  static const Duration statsAnimationDuration = Duration(milliseconds: 1500);
  static const Duration fadeInDuration = Duration(milliseconds: 600);
  static const Duration loadingDelay = Duration(milliseconds: 500);
  static const Duration hoverDuration = Duration(milliseconds: 200);
  static const Duration staggerDelay = Duration(milliseconds: 100);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve statsCurve = Curves.easeOutCubic;
  static const Curve hoverCurve = Curves.easeOut;
  static const Curve fadeInCurve = Curves.easeOutCubic;

  // Scroll thresholds
  static const double scrollToTopThreshold = 200;
  static const double blurEffectThreshold = 10;

  // Spacing (legacy - maintained for compatibility)
  static const double sectionSpacing = 96;
  static const double cardSpacing = 32;
  static const double itemSpacing = 24;

  // Hover effects
  static const double hoverScale = 1.02;
  static const double hoverElevation = 12;

}
