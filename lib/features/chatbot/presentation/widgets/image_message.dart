import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Image message widget for displaying images in chat
class ImageMessage extends StatelessWidget {
  final String imageUrl;
  final String? caption;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ImageMessage({
    super.key,
    required this.imageUrl,
    this.caption,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: BoxConstraints(
        maxWidth: width ?? 280,
        maxHeight: height ?? 200,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image
          ClipRRect(
            borderRadius: caption != null
                ? const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )
                : BorderRadius.circular(12),
            child: GestureDetector(
              onTap: onTap ?? () => _showFullImage(context),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: width ?? 280,
                height: height ?? 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: width ?? 280,
                  height: height ?? 180,
                  color: AppColors.border,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: width ?? 280,
                  height: height ?? 180,
                  color: AppColors.border,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.broken_image,
                        color: AppColors.textSecondary,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.chatFailedToLoadImage,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Caption
          if (caption != null)
            Container(
              width: width ?? 280,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                caption!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 64,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.of(ctx).pop(),
                icon: const Icon(Icons.close, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Image gallery message for multiple images
class ImageGalleryMessage extends StatelessWidget {
  final List<String> imageUrls;
  final String? caption;

  const ImageGalleryMessage({
    super.key,
    required this.imageUrls,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) return const SizedBox();
    if (imageUrls.length == 1) {
      return ImageMessage(imageUrl: imageUrls.first, caption: caption);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid of images
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImageGrid(context),
          ),

          // Caption
          if (caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                caption!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    final displayCount = imageUrls.length > 4 ? 4 : imageUrls.length;
    final extraCount = imageUrls.length - 4;

    return SizedBox(
      height: displayCount <= 2 ? 140 : 200,
      child: Row(
        children: [
          // First image (larger)
          Expanded(
            child: GestureDetector(
              onTap: () => _showGallery(context, 0),
              child: CachedNetworkImage(
                imageUrl: imageUrls[0],
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),

          // Additional images
          if (displayCount > 1)
            const SizedBox(width: 2),
          if (displayCount > 1)
            Expanded(
              child: Column(
                children: List.generate(
                  displayCount - 1,
                  (index) {
                    final imageIndex = index + 1;
                    final isLast = imageIndex == displayCount - 1 && extraCount > 0;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _showGallery(context, imageIndex),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: imageUrls[imageIndex],
                              fit: BoxFit.cover,
                            ),
                            if (isLast)
                              Container(
                                color: Colors.black54,
                                child: Center(
                                  child: Text(
                                    '+$extraCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ).expand((w) => [w, const SizedBox(height: 2)]).toList()
                  ..removeLast(),
              ),
            ),
        ],
      ),
    );
  }

  void _showGallery(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      builder: (ctx) => _ImageGalleryViewer(
        imageUrls: imageUrls,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _ImageGalleryViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _ImageGalleryViewer({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_ImageGalleryViewer> createState() => _ImageGalleryViewerState();
}

class _ImageGalleryViewerState extends State<_ImageGalleryViewer> {
  late PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrls[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: 40,
            right: 16,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),

          // Page indicator
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  context.l10n.chatImageCounter(_currentIndex + 1, widget.imageUrls.length),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
