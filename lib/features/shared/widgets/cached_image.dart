import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Cached Network Image Widget
///
/// Provides efficient image loading with caching, placeholders, and error handling.
/// This is a wrapper that works without external dependencies but can easily be
/// replaced with cached_network_image package for production.
///
/// Backend Integration TODO:
/// For production, add to pubspec.yaml:
/// ```yaml
/// dependencies:
///   cached_network_image: ^3.3.1
/// ```
///
/// Then replace implementation with:
/// ```dart
/// import 'package:cached_network_image/cached_network_image.dart';
///
/// CachedNetworkImage(
///   imageUrl: imageUrl,
///   placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
///   errorWidget: (context, url, error) => errorWidget ?? _buildError(),
///   fit: fit,
///   width: width,
///   height: height,
///   fadeInDuration: const Duration(milliseconds: 300),
///   fadeOutDuration: const Duration(milliseconds: 100),
///   cacheManager: CacheManager(
///     Config(
///       'customCacheKey',
///       stalePeriod: const Duration(days: 7),
///       maxNrOfCacheObjects: 200,
///     ),
///   ),
/// )
/// ```
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final bool showLoadingIndicator;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.showLoadingIndicator = true,
  });

  /// Avatar image with circular shape
  factory CachedImage.avatar({
    required String imageUrl,
    double size = 48,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(size / 2),
      placeholder: placeholder ??
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: size * 0.6,
              color: AppColors.textSecondary,
            ),
          ),
      errorWidget: errorWidget,
    );
  }

  /// Thumbnail image with rounded corners
  factory CachedImage.thumbnail({
    required String imageUrl,
    double width = 80,
    double height = 80,
    double borderRadius = 8,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(borderRadius),
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  /// Full-width banner image
  factory CachedImage.banner({
    required String imageUrl,
    double height = 200,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return _buildLoadingState(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorState();
      },
    );

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingState(ImageChunkEvent loadingProgress) {
    if (!showLoadingIndicator && placeholder != null) {
      return placeholder!;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: borderRadius,
      ),
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: AppColors.error,
          size: 32,
        ),
      ),
    );
  }
}

/// Preload images for better UX
///
/// Usage:
/// ```dart
/// ImageCacheManager.precacheImages(
///   context,
///   ['url1', 'url2', 'url3'],
/// );
/// ```
class ImageCacheManager {
  /// Precache multiple images
  static Future<void> precacheImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (final url in imageUrls) {
      try {
        await precacheImage(NetworkImage(url), context);
      } catch (e) {
        // Silently fail - image will load when displayed
        debugPrint('Failed to precache image: $url');
      }
    }
  }

  /// Clear image cache
  /// Note: Flutter's Image.network uses default cache
  /// For production with cached_network_image, use:
  /// ```dart
  /// await DefaultCacheManager().emptyCache();
  /// ```
  static Future<void> clearCache() async {
    // TODO: Implement cache clearing
    // With cached_network_image:
    // await DefaultCacheManager().emptyCache();
    debugPrint('Image cache would be cleared here');
  }

  /// Get cache size
  /// For production monitoring
  static Future<int> getCacheSize() async {
    // TODO: Implement cache size calculation
    // With cached_network_image:
    // final cacheManager = DefaultCacheManager();
    // final files = await cacheManager.getFilesFromCache();
    // return files.fold<int>(0, (sum, file) => sum + file.file.lengthSync());
    return 0;
  }
}

/// Shimmer placeholder for loading images
class ShimmerPlaceholder extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerPlaceholder({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  Color(0xFFEBEBF4),
                  Color(0xFFF4F4F4),
                  Color(0xFFEBEBF4),
                ],
                stops: [
                  _animation.value - 0.3,
                  _animation.value,
                  _animation.value + 0.3,
                ],
                tileMode: TileMode.clamp,
              ).createShader(bounds);
            },
            child: Container(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

/// Image Grid with lazy loading
class CachedImageGrid extends StatelessWidget {
  final List<String> imageUrls;
  final int crossAxisCount;
  final double spacing;
  final double aspectRatio;
  final Function(int)? onImageTap;

  const CachedImageGrid({
    super.key,
    required this.imageUrls,
    this.crossAxisCount = 3,
    this.spacing = 8,
    this.aspectRatio = 1.0,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onImageTap?.call(index),
          child: CachedImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
            placeholder: const ShimmerPlaceholder(),
          ),
        );
      },
    );
  }
}

/// Fade-in image with animation
class FadeInCachedImage extends StatelessWidget {
  final String imageUrl;
  final Duration duration;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const FadeInCachedImage({
    super.key,
    required this.imageUrl,
    this.duration = const Duration(milliseconds: 300),
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: CachedImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }
}
