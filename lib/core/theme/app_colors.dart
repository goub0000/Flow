import 'package:flutter/material.dart';
import '../constants/user_roles.dart';

/// App color palette based on Flow EdTech specifications
/// Primary color: #373896 (Blue - Primary actions: buttons, headers, nav links)
/// Maroon: #B01116 (Secondary actions, highlights, error banners)
/// Yellow: #FAA61A (Accent highlights: alerts, badges, CTAs)
class AppColors {
  AppColors._();

  // Primary Colors (Blue #373896)
  static const Color primary = Color(0xFF373896);
  static const Color primaryDark = Color(0xFF2A2B72);
  static const Color primaryLight = Color(0xFF5456AE);

  // Secondary Colors (Maroon #B01116)
  static const Color secondary = Color(0xFFB01116);
  static const Color secondaryDark = Color(0xFF8B0D11);
  static const Color secondaryLight = Color(0xFFC53A3E);

  // Accent Colors (Yellow #FAA61A)
  static const Color accent = Color(0xFFFAA61A);
  static const Color accentDark = Color(0xFF8B5E10); // Darkened for text on white - 4.5:1 contrast (was #C88515 - 2.9:1)
  static const Color accentLight = Color(0xFFFBB845);
  // Use accentDark for text on light backgrounds to meet WCAG AA
  static const Color accentOnLight = Color(0xFF8B5E10); // 4.5:1 contrast on white

  // African Warmth Palette
  static const Color terracotta = Color(0xFFC4704F);
  static const Color coral = Color(0xFFE07A5F);
  static const Color warmSand = Color(0xFFF4E8DC);
  static const Color deepOchre = Color(0xFFB8860B);

  // Section Backgrounds for Visual Rhythm
  static const Color sectionLight = Color(0xFFF8FAFB);
  static const Color sectionWarm = Color(0xFFFFF9F5);
  static const Color sectionDark = Color(0xFF1A1A1A);

  // Hero Gradient Colors
  static const List<Color> heroGradient = [primary, Color(0xFF4A4BC8), terracotta];

  // Background Colors (Pure white for premium minimalistic design)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFB);

  // Text Colors
  // WCAG AA compliant: minimum 4.5:1 contrast ratio for normal text
  static const Color textPrimary = Color(0xFF000000); // 21:1 on white
  static const Color textSecondary = Color(0xFF595959); // 7:1 on white (was #666666 - 5.74:1)
  static const Color textDisabled = Color(0xFF757575); // 4.6:1 on white (was #999999 - 2.85:1, FAILED AA)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFB01116); // Using Maroon for errors
  static const Color warning = Color(0xFFFAA61A); // Using Yellow for warnings
  static const Color info = Color(0xFF373896); // Using Primary Blue for info

  // Role-specific Colors
  static const Color studentRole = Color(0xFF373896); // Primary Blue
  static const Color institutionRole = Color(0xFFB01116); // Maroon
  static const Color parentRole = Color(0xFF4CAF50); // Green (for differentiation)
  static const Color counselorRole = Color(0xFFFAA61A); // Yellow/Accent
  static const Color recommenderRole = Color(0xFF5456AE); // Light Blue variant

  // Admin role colors
  static const Color superAdminRole = Color(0xFFB01116); // Maroon - highest authority
  static const Color regionalAdminRole = Color(0xFF373896); // Primary Blue
  static const Color contentAdminRole = Color(0xFF373896); // Primary Blue
  static const Color supportAdminRole = Color(0xFF373896); // Primary Blue
  static const Color financeAdminRole = Color(0xFF373896); // Primary Blue
  static const Color analyticsAdminRole = Color(0xFF373896); // Primary Blue

  // Admin badge accent colors
  static const Color superAdminAccent = Color(0xFFFFD700); // Gold for Super Admin badge

  // Border & Divider Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color scrim = Color(0xB3000000); // 70% black

  /// Get role color by role type
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return studentRole;
      case 'institution':
        return institutionRole;
      case 'parent':
        return parentRole;
      case 'counselor':
        return counselorRole;
      case 'recommender':
        return recommenderRole;
      default:
        return primary;
    }
  }

  /// Get admin role color by UserRole enum
  static Color getAdminRoleColor(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return superAdminRole;
      case UserRole.regionalAdmin:
        return regionalAdminRole;
      case UserRole.contentAdmin:
        return contentAdminRole;
      case UserRole.supportAdmin:
        return supportAdminRole;
      case UserRole.financeAdmin:
        return financeAdminRole;
      case UserRole.analyticsAdmin:
        return analyticsAdminRole;
      // Non-admin roles
      case UserRole.student:
        return studentRole;
      case UserRole.institution:
        return institutionRole;
      case UserRole.parent:
        return parentRole;
      case UserRole.counselor:
        return counselorRole;
      case UserRole.recommender:
        return recommenderRole;
    }
  }

  /// Get admin role icon by UserRole enum
  static IconData getAdminRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return Icons.shield; // Crown alternative (shield for authority)
      case UserRole.regionalAdmin:
        return Icons.public; // Globe for regional
      case UserRole.contentAdmin:
        return Icons.library_books; // Books for content
      case UserRole.supportAdmin:
        return Icons.support_agent; // Headset for support
      case UserRole.financeAdmin:
        return Icons.account_balance_wallet; // Wallet for finance
      case UserRole.analyticsAdmin:
        return Icons.analytics; // Chart for analytics
      default:
        return Icons.admin_panel_settings; // Default admin icon
    }
  }

  /// Get admin role badge text
  static String getAdminRoleBadgeText(UserRole role) {
    if (!role.isAdmin) return '';
    return role.displayName.toUpperCase();
  }

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
