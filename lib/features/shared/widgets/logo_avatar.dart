import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A reusable widget for displaying logos and avatars with fallback support
/// Handles both institution logos and user profile photos
class LogoAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackText;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isRectangular;
  final BoxFit fit;

  const LogoAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackText,
    this.size = 48,
    this.backgroundColor,
    this.textColor,
    this.isRectangular = false,
    this.fit = BoxFit.cover,
  });

  /// Create a circular avatar for user profiles
  factory LogoAvatar.user({
    String? photoUrl,
    required String initials,
    double size = 40,
    Color? backgroundColor,
  }) {
    return LogoAvatar(
      imageUrl: photoUrl,
      fallbackText: initials,
      size: size,
      backgroundColor: backgroundColor ?? AppColors.primary,
      textColor: AppColors.textOnPrimary,
      isRectangular: false,
    );
  }

  /// Create a rectangular logo for institutions/organizations
  factory LogoAvatar.institution({
    String? logoUrl,
    required String name,
    double size = 48,
    Color? backgroundColor,
    BoxFit fit = BoxFit.cover,
  }) {
    // Get first 2 letters of institution name for fallback
    final initials = _getInitials(name);

    return LogoAvatar(
      imageUrl: logoUrl,
      fallbackText: initials,
      size: size,
      backgroundColor: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
      textColor: AppColors.primary,
      isRectangular: true,
      fit: fit,
    );
  }

  /// Create a course thumbnail
  factory LogoAvatar.course({
    String? imageUrl,
    required String courseName,
    double height = 120,
  }) {
    final initials = _getInitials(courseName);

    return LogoAvatar(
      imageUrl: imageUrl,
      fallbackText: initials,
      size: height,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      textColor: AppColors.primary.withValues(alpha: 0.5),
      isRectangular: true,
      fit: BoxFit.cover,
    );
  }

  static String _getInitials(String text) {
    if (text.isEmpty) return 'XX';

    final words = text.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return text.substring(0, text.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // If we have a valid image URL, try to display it
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return _buildImageContainer(
        child: Image.network(
          imageUrl!,
          width: isRectangular ? double.infinity : size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            // On error, fall back to text
            return _buildFallback();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildLoading();
          },
        ),
      );
    }

    // No image URL, show fallback
    return _buildFallback();
  }

  Widget _buildImageContainer({required Widget child}) {
    if (isRectangular) {
      return Container(
        width: double.infinity,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      child: ClipOval(child: child),
    );
  }

  Widget _buildFallback() {
    final fontSize = isRectangular ? size / 3 : size / 2.5;

    if (isRectangular) {
      return Container(
        width: double.infinity,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            fallbackText,
            style: TextStyle(
              color: textColor ?? AppColors.primary,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? AppColors.primary,
      child: Text(
        fallbackText,
        style: TextStyle(
          color: textColor ?? AppColors.textOnPrimary,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    if (isRectangular) {
      return Container(
        width: double.infinity,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[200],
      child: SizedBox(
        width: size / 3,
        height: size / 3,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
