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
  static const double maxHeroWidth = 900;
  static const double maxFooterWidth = 1000;

  // Animation durations
  static const Duration scrollAnimationDuration = Duration(milliseconds: 500);
  static const Duration gradientAnimationDuration = Duration(seconds: 20);
  static const Duration statsAnimationDuration = Duration(milliseconds: 1500);
  static const Duration fadeInDuration = Duration(milliseconds: 300);
  static const Duration loadingDelay = Duration(milliseconds: 500);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve statsCurve = Curves.easeOutCubic;

  // Scroll thresholds
  static const double scrollToTopThreshold = 200;
  static const double blurEffectThreshold = 10;

  // Spacing
  static const double sectionSpacing = 80;
  static const double cardSpacing = 24;
  static const double itemSpacing = 16;

  // Video
  static const String demoVideoId = 'dQw4w9WgXcQ'; // Replace with actual demo video ID
}
