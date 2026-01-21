import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// App theme configuration with light and dark themes
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryLight,
      surface: AppColors.surface,
      surfaceContainerHighest: AppColors.surfaceVariant,
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimary,
      onError: AppColors.textOnPrimary,
      outline: AppColors.border,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      ),
    ),
    textTheme: TextTheme(
      // Hero title: 56px / weight 800 / height 1.1
      displayLarge: GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        height: 1.1,
        color: AppColors.textPrimary,
      ),
      // Section title: 36px / weight 700 / height 1.2
      displayMedium: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      // Body text: 16px / height 1.6
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.6,
        color: AppColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        height: 1.6,
        color: AppColors.textPrimary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColors.textDisabled,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(8),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,
      deleteIconColor: AppColors.textSecondary,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  /// Dark theme (for future implementation)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryDark,
      surface: const Color(0xFF1E1E1E),
      error: AppColors.error,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: Colors.white,
      onError: AppColors.textOnPrimary,
      outline: const Color(0xFF404040),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    ),
  );

  /// Get light theme with custom settings
  static ThemeData getLightTheme({
    double fontSize = 16.0,
    String? fontFamily,
    Color? accentColor,
    bool compactMode = false,
  }) {
    final primaryColor = accentColor ?? AppColors.primary;
    final fontSizeMultiplier = fontSize / 16.0; // Base size is 16
    final verticalPadding = compactMode ? 8.0 : 12.0;

    return lightTheme.copyWith(
      colorScheme: lightTheme.colorScheme.copyWith(
        primary: primaryColor,
      ),
      appBarTheme: lightTheme.appBarTheme.copyWith(
        backgroundColor: primaryColor,
        titleTextStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
          fontSize: 20 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
      textTheme: _buildTextTheme(fontSizeMultiplier, fontFamily),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.textOnPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: lightTheme.inputDecorationTheme.copyWith(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      bottomNavigationBarTheme: lightTheme.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primaryColor,
      ),
    );
  }

  /// Get dark theme with custom settings
  static ThemeData getDarkTheme({
    double fontSize = 16.0,
    String? fontFamily,
    Color? accentColor,
    bool compactMode = false,
  }) {
    final primaryColor = accentColor ?? AppColors.primary;
    final fontSizeMultiplier = fontSize / 16.0;
    final verticalPadding = compactMode ? 8.0 : 12.0;

    return darkTheme.copyWith(
      colorScheme: darkTheme.colorScheme.copyWith(
        primary: primaryColor,
      ),
      appBarTheme: darkTheme.appBarTheme.copyWith(
        backgroundColor: primaryColor,
        titleTextStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
          fontSize: 20 * fontSizeMultiplier,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
      textTheme: _buildTextTheme(fontSizeMultiplier, fontFamily, dark: true),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.textOnPrimary,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(color: primaryColor, width: 1.5),
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: (fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter()).copyWith(
            fontSize: 14 * fontSizeMultiplier,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: darkTheme.inputDecorationTheme.copyWith(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      bottomNavigationBarTheme: darkTheme.bottomNavigationBarTheme.copyWith(
        selectedItemColor: primaryColor,
      ),
    );
  }

  /// Build text theme with custom font size and family
  static TextTheme _buildTextTheme(double multiplier, String? fontFamily, {bool dark = false}) {
    final textColor = dark ? Colors.white : AppColors.textPrimary;
    final secondaryColor = dark ? Colors.white70 : AppColors.textSecondary;
    final getFont = fontFamily != null ? GoogleFonts.getFont(fontFamily) : GoogleFonts.inter();

    return TextTheme(
      displayLarge: getFont.copyWith(
        fontSize: 32 * multiplier,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displayMedium: getFont.copyWith(
        fontSize: 28 * multiplier,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      displaySmall: getFont.copyWith(
        fontSize: 24 * multiplier,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineLarge: getFont.copyWith(
        fontSize: 22 * multiplier,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineMedium: getFont.copyWith(
        fontSize: 20 * multiplier,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: getFont.copyWith(
        fontSize: 18 * multiplier,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: getFont.copyWith(
        fontSize: 16 * multiplier,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: getFont.copyWith(
        fontSize: 14 * multiplier,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      titleSmall: getFont.copyWith(
        fontSize: 12 * multiplier,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: getFont.copyWith(
        fontSize: 16 * multiplier,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodyMedium: getFont.copyWith(
        fontSize: 14 * multiplier,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
      bodySmall: getFont.copyWith(
        fontSize: 12 * multiplier,
        fontWeight: FontWeight.normal,
        color: secondaryColor,
      ),
      labelLarge: getFont.copyWith(
        fontSize: 14 * multiplier,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelMedium: getFont.copyWith(
        fontSize: 12 * multiplier,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
      labelSmall: getFont.copyWith(
        fontSize: 10 * multiplier,
        fontWeight: FontWeight.w500,
        color: secondaryColor,
      ),
    );
  }
}
