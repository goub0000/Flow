import 'package:flutter/material.dart';

/// App spacing system based on 8dp baseline grid
///
/// Material Design recommends an 8dp grid for consistent spacing.
/// All spacing values are multiples of 4dp for flexibility,
/// with primary values being multiples of 8dp.
///
/// Usage:
/// - Use [AppSpacing.xs] through [AppSpacing.xxxl] for padding/margins
/// - Use [AppSpacing.gap4] through [AppSpacing.gap64] for SizedBox gaps
/// - Use [AppSpacing.insets*] for common EdgeInsets patterns
class AppSpacing {
  AppSpacing._();

  // ============================================================
  // BASE UNIT
  // ============================================================

  /// Base unit: 4dp (half of the 8dp grid for fine-tuning)
  static const double unit = 4.0;

  // ============================================================
  // SPACING SCALE (following 8dp baseline grid)
  // ============================================================

  /// 4dp - Extra extra small (half step)
  static const double xxs = 4.0;

  /// 8dp - Extra small (1x base grid)
  static const double xs = 8.0;

  /// 12dp - Small (1.5x base grid)
  static const double sm = 12.0;

  /// 16dp - Medium (2x base grid) - Default spacing
  static const double md = 16.0;

  /// 24dp - Large (3x base grid)
  static const double lg = 24.0;

  /// 32dp - Extra large (4x base grid)
  static const double xl = 32.0;

  /// 48dp - Extra extra large (6x base grid)
  static const double xxl = 48.0;

  /// 64dp - Extra extra extra large (8x base grid)
  static const double xxxl = 64.0;

  // ============================================================
  // GAP WIDGETS (for use in Column/Row)
  // ============================================================

  /// 4dp vertical gap
  static const Widget gapV4 = SizedBox(height: xxs);

  /// 8dp vertical gap
  static const Widget gapV8 = SizedBox(height: xs);

  /// 12dp vertical gap
  static const Widget gapV12 = SizedBox(height: sm);

  /// 16dp vertical gap (default)
  static const Widget gapV16 = SizedBox(height: md);

  /// 24dp vertical gap
  static const Widget gapV24 = SizedBox(height: lg);

  /// 32dp vertical gap
  static const Widget gapV32 = SizedBox(height: xl);

  /// 48dp vertical gap
  static const Widget gapV48 = SizedBox(height: xxl);

  /// 64dp vertical gap
  static const Widget gapV64 = SizedBox(height: xxxl);

  /// 4dp horizontal gap
  static const Widget gapH4 = SizedBox(width: xxs);

  /// 8dp horizontal gap
  static const Widget gapH8 = SizedBox(width: xs);

  /// 12dp horizontal gap
  static const Widget gapH12 = SizedBox(width: sm);

  /// 16dp horizontal gap (default)
  static const Widget gapH16 = SizedBox(width: md);

  /// 24dp horizontal gap
  static const Widget gapH24 = SizedBox(width: lg);

  /// 32dp horizontal gap
  static const Widget gapH32 = SizedBox(width: xl);

  /// 48dp horizontal gap
  static const Widget gapH48 = SizedBox(width: xxl);

  /// 64dp horizontal gap
  static const Widget gapH64 = SizedBox(width: xxxl);

  // ============================================================
  // EDGE INSETS - SYMMETRIC
  // ============================================================

  /// All sides 4dp
  static const EdgeInsets insetsAll4 = EdgeInsets.all(xxs);

  /// All sides 8dp
  static const EdgeInsets insetsAll8 = EdgeInsets.all(xs);

  /// All sides 12dp
  static const EdgeInsets insetsAll12 = EdgeInsets.all(sm);

  /// All sides 16dp (default)
  static const EdgeInsets insetsAll16 = EdgeInsets.all(md);

  /// All sides 24dp
  static const EdgeInsets insetsAll24 = EdgeInsets.all(lg);

  /// All sides 32dp
  static const EdgeInsets insetsAll32 = EdgeInsets.all(xl);

  // ============================================================
  // EDGE INSETS - HORIZONTAL ONLY
  // ============================================================

  /// Horizontal 8dp
  static const EdgeInsets insetsH8 = EdgeInsets.symmetric(horizontal: xs);

  /// Horizontal 12dp
  static const EdgeInsets insetsH12 = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal 16dp (default)
  static const EdgeInsets insetsH16 = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal 24dp
  static const EdgeInsets insetsH24 = EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal 32dp
  static const EdgeInsets insetsH32 = EdgeInsets.symmetric(horizontal: xl);

  // ============================================================
  // EDGE INSETS - VERTICAL ONLY
  // ============================================================

  /// Vertical 8dp
  static const EdgeInsets insetsV8 = EdgeInsets.symmetric(vertical: xs);

  /// Vertical 12dp
  static const EdgeInsets insetsV12 = EdgeInsets.symmetric(vertical: sm);

  /// Vertical 16dp (default)
  static const EdgeInsets insetsV16 = EdgeInsets.symmetric(vertical: md);

  /// Vertical 24dp
  static const EdgeInsets insetsV24 = EdgeInsets.symmetric(vertical: lg);

  /// Vertical 32dp
  static const EdgeInsets insetsV32 = EdgeInsets.symmetric(vertical: xl);

  // ============================================================
  // COMMON COMPONENT PATTERNS
  // ============================================================

  /// Card padding: 16dp all sides
  static const EdgeInsets cardPadding = insetsAll16;

  /// Card padding compact: 12dp all sides
  static const EdgeInsets cardPaddingCompact = insetsAll12;

  /// List item padding: 16dp horizontal, 12dp vertical
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Button padding: 24dp horizontal, 12dp vertical
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );

  /// Button padding compact: 16dp horizontal, 8dp vertical
  static const EdgeInsets buttonPaddingCompact = EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  /// Input field content padding: 16dp horizontal, 12dp vertical
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Screen padding: 16dp horizontal (standard mobile edge margin)
  static const EdgeInsets screenPadding = insetsH16;

  /// Screen padding with top: 16dp all sides
  static const EdgeInsets screenPaddingAll = insetsAll16;

  /// Section spacing: 24dp vertical margin between sections
  static const EdgeInsets sectionMargin = insetsV24;

  /// Dialog padding: 24dp all sides
  static const EdgeInsets dialogPadding = insetsAll24;

  // ============================================================
  // BORDER RADIUS
  // ============================================================

  /// Small radius: 4dp
  static const double radiusSm = 4.0;

  /// Medium radius: 8dp (default for buttons, inputs)
  static const double radiusMd = 8.0;

  /// Large radius: 12dp (default for cards)
  static const double radiusLg = 12.0;

  /// Extra large radius: 16dp
  static const double radiusXl = 16.0;

  /// Full/pill radius: 999dp
  static const double radiusFull = 999.0;

  /// Small BorderRadius
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));

  /// Medium BorderRadius
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));

  /// Large BorderRadius
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));

  /// Extra large BorderRadius
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // ============================================================
  // ICON SIZES (following Material Design)
  // ============================================================

  /// Small icon: 16dp
  static const double iconSm = 16.0;

  /// Medium icon: 24dp (default)
  static const double iconMd = 24.0;

  /// Large icon: 32dp
  static const double iconLg = 32.0;

  /// Extra large icon: 48dp
  static const double iconXl = 48.0;

  // ============================================================
  // TOUCH TARGET (Accessibility)
  // ============================================================

  /// Minimum touch target size: 48dp (WCAG 2.1 AA)
  /// Interactive elements should be at least this size
  static const double minTouchTarget = 48.0;

  /// Recommended touch target size: 44dp (iOS HIG)
  static const double touchTarget = 44.0;
}
