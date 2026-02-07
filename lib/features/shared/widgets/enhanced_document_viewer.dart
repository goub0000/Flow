import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/document_model.dart';
import '../../../core/l10n_extension.dart';

/// Enhanced Document Viewer Widget
///
/// Provides advanced document viewing capabilities:
/// - PDF viewing with page navigation
/// - Image viewing with zoom, pan, and pinch gestures
/// - Loading states and error handling
/// - Page indicators and controls
///
/// Backend Integration TODO:
/// Add these dependencies to pubspec.yaml:
/// ```yaml
/// dependencies:
///   # For PDF viewing
///   syncfusion_flutter_pdfviewer: ^24.1.41  # OR
///   flutter_pdfview: ^1.3.2  # OR
///   pdfx: ^2.6.0
///
///   # For enhanced image viewing with zoom/pan
///   photo_view: ^0.14.0
///
///   # For image caching
///   cached_network_image: ^3.3.1
/// ```

class EnhancedDocumentViewer extends StatefulWidget {
  final Document document;
  final bool showControls;

  const EnhancedDocumentViewer({
    super.key,
    required this.document,
    this.showControls = true,
  });

  @override
  State<EnhancedDocumentViewer> createState() => _EnhancedDocumentViewerState();
}

class _EnhancedDocumentViewerState extends State<EnhancedDocumentViewer> {
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // TODO: Implement actual document loading based on type
      // For PDFs: Load PDF and get page count
      // For images: Preload image
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      setState(() {
        _isLoading = false;
        // For demo: Set total pages based on document type
        if (widget.document.isPDF) {
          _totalPages = 5; // Would come from PDF library
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingView();
    }

    if (_error != null) {
      return _buildErrorView();
    }

    if (widget.document.isImage) {
      return _buildImageViewer();
    } else if (widget.document.isPDF) {
      return _buildPDFViewer();
    } else {
      return _buildUnsupportedView();
    }
  }

  Widget _buildLoadingView() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              context.l10n.swDocViewerLoading(widget.document.name),
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                _error != null ? context.l10n.swDocViewerLoadError(_error!) : context.l10n.swDocViewerFailedToLoad,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadDocument,
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.swDocViewerRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageViewer() {
    return Stack(
      children: [
        // Image with zoom/pan capabilities
        ZoomableImageViewer(
          imageUrl: widget.document.url!,
          onLoadComplete: () {
            setState(() => _isLoading = false);
          },
          onLoadError: (error) {
            setState(() {
              _isLoading = false;
              _error = error;
            });
          },
        ),

        // Controls overlay
        if (widget.showControls)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: _buildImageControls(),
          ),
      ],
    );
  }

  Widget _buildPDFViewer() {
    return Stack(
      children: [
        // PDF Viewer
        PDFDocumentViewer(
          pdfUrl: widget.document.url!,
          initialPage: _currentPage,
          onPageChanged: (page) {
            setState(() => _currentPage = page);
          },
          onDocumentLoaded: (totalPages) {
            setState(() {
              _totalPages = totalPages;
              _isLoading = false;
            });
          },
          onLoadError: (error) {
            setState(() {
              _isLoading = false;
              _error = error;
            });
          },
        ),

        // Page controls
        if (widget.showControls && _totalPages > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: _buildPDFControls(),
          ),
      ],
    );
  }

  Widget _buildImageControls() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () {
                // TODO: Implement zoom in
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.swDocViewerPinchToZoom)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () {
                // TODO: Implement zoom out
              },
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen, color: Colors.white),
              onPressed: () {
                // TODO: Implement fullscreen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFControls() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: _currentPage > 1
                  ? () => setState(() => _currentPage--)
                  : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_currentPage / $_totalPages',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: _currentPage < _totalPages
                  ? () => setState(() => _currentPage++)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnsupportedView() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getFileIcon(),
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.swDocViewerPreviewNotAvailable,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.swDocViewerCannotPreview(widget.document.fileExtension),
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement download
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.swDocViewerDownloading(widget.document.name)),
                  ),
                );
              },
              icon: const Icon(Icons.download),
              label: Text(context.l10n.swDocViewerDownloadToView),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFileIcon() {
    if (widget.document.isDocument) return Icons.description;
    return Icons.insert_drive_file;
  }
}

/// Zoomable Image Viewer with pinch-to-zoom and pan gestures
///
/// TODO: Replace with photo_view package for production:
/// ```dart
/// import 'package:photo_view/photo_view.dart';
///
/// PhotoView(
///   imageProvider: CachedNetworkImageProvider(imageUrl),
///   minScale: PhotoViewComputedScale.contained,
///   maxScale: PhotoViewComputedScale.covered * 2,
///   backgroundDecoration: BoxDecoration(color: Colors.black),
/// )
/// ```
class ZoomableImageViewer extends StatefulWidget {
  final String imageUrl;
  final VoidCallback? onLoadComplete;
  final Function(String)? onLoadError;

  const ZoomableImageViewer({
    super.key,
    required this.imageUrl,
    this.onLoadComplete,
    this.onLoadError,
  });

  @override
  State<ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<ZoomableImageViewer> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: _buildImage(),
        ),
      ),
    );
  }

  Widget _buildImage() {
    // TODO: Replace with CachedNetworkImage for production:
    // ```dart
    // return CachedNetworkImage(
    //   imageUrl: widget.imageUrl,
    //   placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) {
    //     widget.onLoadError?.call(error.toString());
    //     return Icon(Icons.error, color: Colors.red, size: 48);
    //   },
    //   imageBuilder: (context, imageProvider) {
    //     widget.onLoadComplete?.call();
    //     return Image(image: imageProvider, fit: BoxFit.contain);
    //   },
    // );
    // ```

    return Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          widget.onLoadComplete?.call();
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        widget.onLoadError?.call(error.toString());
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, size: 48, color: AppColors.error),
              const SizedBox(height: 8),
              Text(
                context.l10n.swDocViewerFailedToLoadImage,
                style: const TextStyle(color: AppColors.error),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// PDF Document Viewer
///
/// TODO: Replace with actual PDF library for production.
/// Recommended options:
///
/// Option 1: Syncfusion (commercial, full-featured):
/// ```dart
/// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
///
/// SfPdfViewer.network(
///   pdfUrl,
///   onDocumentLoaded: (PdfDocumentLoadedDetails details) {
///     onDocumentLoaded(details.document.pages.count);
///   },
///   onPageChanged: (PdfPageChangedDetails details) {
///     onPageChanged(details.newPageNumber);
///   },
/// )
/// ```
///
/// Option 2: flutter_pdfview (open source):
/// ```dart
/// import 'package:flutter_pdfview/flutter_pdfview.dart';
///
/// PDFView(
///   filePath: localPath, // Must download first
///   onRender: (_pages) => onDocumentLoaded(_pages!),
///   onPageChanged: (page, total) => onPageChanged(page! + 1),
///   onError: (error) => onLoadError(error.toString()),
/// )
/// ```
///
/// Option 3: pdfx (modern, good performance):
/// ```dart
/// import 'package:pdfx/pdfx.dart';
///
/// PdfView(
///   controller: PdfController(
///     document: PdfDocument.openData(pdfBytes),
///   ),
///   onPageChanged: onPageChanged,
///   onDocumentLoaded: (document) => onDocumentLoaded(document.pagesCount),
/// )
/// ```
class PDFDocumentViewer extends StatelessWidget {
  final String pdfUrl;
  final int initialPage;
  final Function(int) onPageChanged;
  final Function(int) onDocumentLoaded;
  final Function(String) onLoadError;

  const PDFDocumentViewer({
    super.key,
    required this.pdfUrl,
    this.initialPage = 1,
    required this.onPageChanged,
    required this.onDocumentLoaded,
    required this.onLoadError,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual PDF viewer
    // For now, show placeholder with instructions

    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.picture_as_pdf,
                size: 80,
                color: AppColors.error,
              ),
              const SizedBox(height: 24),
              Text(
                context.l10n.swDocViewerPdfViewer,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.swDocViewerPdfEnableMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              _buildPackageOption(
                'syncfusion_flutter_pdfviewer',
                context.l10n.swDocViewerPdfOptionCommercial,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                'flutter_pdfview',
                context.l10n.swDocViewerPdfOptionOpenSource,
              ),
              const SizedBox(height: 8),
              _buildPackageOption(
                'pdfx',
                context.l10n.swDocViewerPdfOptionModern,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info, color: AppColors.info, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        context.l10n.swDocViewerPageOf(initialPage, initialPage + 4),
                        style: const TextStyle(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageOption(String packageName, String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  packageName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
