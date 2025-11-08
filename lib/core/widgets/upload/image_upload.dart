import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../theme/app_colors.dart';

/// Image Upload Widget - Upload images with preview
class ImageUpload extends StatefulWidget {
  final void Function(List<UploadedImage> images) onImagesSelected;
  final int maxImages;
  final int? maxSizeInMB;
  final double? aspectRatio;
  final String? hint;
  final bool showPreview;

  const ImageUpload({
    required this.onImagesSelected,
    this.maxImages = 1,
    this.maxSizeInMB,
    this.aspectRatio,
    this.hint,
    this.showPreview = true,
    super.key,
  });

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final List<UploadedImage> _images = [];

  @override
  Widget build(BuildContext context) {
    if (widget.showPreview && _images.isNotEmpty) {
      return _buildPreviewGrid();
    }

    return _buildUploadArea();
  }

  Widget _buildUploadArea() {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              widget.hint ?? 'Upload Images',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Click to browse',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (widget.maxSizeInMB != null) ...[
              const SizedBox(height: 8),
              Text(
                'Max ${widget.maxSizeInMB}MB per image',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Selected Images (${_images.length}/${widget.maxImages})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                if (_images.length < widget.maxImages)
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add More'),
                  ),
                TextButton.icon(
                  onPressed: _clearAll,
                  icon: const Icon(Icons.clear, size: 18),
                  label: const Text('Clear'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.maxImages == 1 ? 1 : 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: widget.aspectRatio ?? 1.0,
          ),
          itemCount: _images.length,
          itemBuilder: (context, index) {
            return _buildImagePreview(_images[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildImagePreview(UploadedImage image, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image.bytes != null
                ? Image.memory(
                    Uint8List.fromList(image.bytes!),
                    fit: BoxFit.cover,
                  )
                : const Center(
                    child: Icon(Icons.image, size: 48),
                  ),
          ),
        ),
        // Overlay with actions
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.white),
                  onPressed: () => _removeImage(index),
                  tooltip: 'Remove',
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ),
        // File name overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  image.name,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatFileSize(image.size),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImages() async {
    if (_images.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum ${widget.maxImages} images allowed'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.maxImages > 1,
        type: FileType.image,
      );

      if (result != null) {
        final remainingSlots = widget.maxImages - _images.length;
        final filesToAdd = result.files.take(remainingSlots);

        final newImages = <UploadedImage>[];

        for (final file in filesToAdd) {
          // Validate size
          if (widget.maxSizeInMB != null) {
            final maxSizeBytes = widget.maxSizeInMB! * 1024 * 1024;
            if (file.size > maxSizeBytes) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${file.name} exceeds ${widget.maxSizeInMB}MB',
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
              continue;
            }
          }

          newImages.add(UploadedImage(
            name: file.name,
            size: file.size,
            bytes: file.bytes,
            path: file.path,
          ));
        }

        if (newImages.isNotEmpty) {
          setState(() {
            _images.addAll(newImages);
          });
          widget.onImagesSelected(_images);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking images: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesSelected(_images);
  }

  void _clearAll() {
    setState(() {
      _images.clear();
    });
    widget.onImagesSelected(_images);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }
}

/// Uploaded Image Model
class UploadedImage {
  final String name;
  final int size;
  final List<int>? bytes;
  final String? path;

  UploadedImage({
    required this.name,
    required this.size,
    this.bytes,
    this.path,
  });
}
