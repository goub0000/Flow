import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/resource_widgets.dart';
import '../widgets/coming_soon_dialog.dart';

/// Resource Viewer Screen
///
/// Displays and plays different types of resources.
/// Features:
/// - PDF viewer
/// - Video player
/// - Audio player
/// - Image viewer
/// - Link handler
/// - Download option
///
/// Backend Integration TODO:
/// ```dart
/// // Use video_player for videos
/// import 'package:video_player/video_player.dart';
///
/// // Use pdf_view for PDFs
/// import 'package:flutter_pdfview/flutter_pdfview.dart';
///
/// // Use audioplayers for audio
/// import 'package:audioplayers/audioplayers.dart';
///
/// // Use url_launcher for links
/// import 'package:url_launcher/url_launcher.dart';
/// ```

class ResourceViewerScreen extends StatefulWidget {
  final ResourceModel resource;

  const ResourceViewerScreen({
    super.key,
    required this.resource,
  });

  @override
  State<ResourceViewerScreen> createState() => _ResourceViewerScreenState();
}

class _ResourceViewerScreenState extends State<ResourceViewerScreen> {
  bool _isLoading = true;
  bool _hasError = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadResource();
  }

  Future<void> _loadResource() async {
    // TODO: Load resource content based on type
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.resource.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _toggleBookmark,
            tooltip: 'Bookmark',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _shareResource,
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _downloadResource,
            tooltip: 'Download',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorView()
              : _buildResourceContent(),
      bottomNavigationBar: _buildBottomInfo(),
    );
  }

  Widget _buildResourceContent() {
    switch (widget.resource.type) {
      case ResourceType.pdf:
        return _buildPDFViewer();
      case ResourceType.video:
        return _buildVideoPlayer();
      case ResourceType.audio:
        return _buildAudioPlayer();
      case ResourceType.image:
        return _buildImageViewer();
      case ResourceType.link:
        return _buildLinkView();
      case ResourceType.document:
      case ResourceType.presentation:
      case ResourceType.spreadsheet:
        return _buildDocumentViewer();
      case ResourceType.zip:
        return _buildArchiveView();
    }
  }

  Widget _buildPDFViewer() {
    // TODO: Integrate PDF viewer
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.resource.type.icon,
            size: 80,
            color: widget.resource.type.color,
          ),
          const SizedBox(height: 24),
          Text(
            'PDF Viewer',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'PDF viewing requires video_player package',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _downloadResource,
            icon: const Icon(Icons.download),
            label: const Text('Download to View'),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    // TODO: Integrate video player
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              widget.resource.type.icon,
              size: 80,
              color: widget.resource.type.color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Video Player',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Video playback requires video_player package',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filled(
                onPressed: () {
                  ComingSoonDialog.show(
                    context,
                    featureName: 'Video Player',
                    customMessage: 'Video playback functionality will be available soon.',
                  );
                },
                icon: const Icon(Icons.play_arrow, size: 32),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    // TODO: Integrate audio player
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: widget.resource.type.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.resource.type.icon,
              size: 80,
              color: widget.resource.type.color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.resource.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Playback controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  ComingSoonDialog.show(
                    context,
                    featureName: 'Audio Controls',
                    customMessage: 'Audio playback controls will be available soon.',
                  );
                },
                icon: const Icon(Icons.skip_previous, size: 32),
              ),
              const SizedBox(width: 16),
              IconButton.filled(
                onPressed: () {
                  ComingSoonDialog.show(
                    context,
                    featureName: 'Audio Player',
                    customMessage: 'Audio playback functionality will be available soon.',
                  );
                },
                icon: const Icon(Icons.play_arrow, size: 40),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  ComingSoonDialog.show(
                    context,
                    featureName: 'Audio Controls',
                    customMessage: 'Audio playback controls will be available soon.',
                  );
                },
                icon: const Icon(Icons.skip_next, size: 32),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Slider(
                  value: 0.3,
                  onChanged: (value) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0:45',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '2:30',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageViewer() {
    return Center(
      child: InteractiveViewer(
        child: Image.network(
          widget.resource.url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const CircularProgressIndicator();
          },
          errorBuilder: (context, error, stackTrace) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.broken_image,
                  size: 80,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load image',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLinkView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.resource.type.icon,
              size: 80,
              color: widget.resource.type.color,
            ),
            const SizedBox(height: 24),
            Text(
              widget.resource.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            if (widget.resource.description != null) ...[
              const SizedBox(height: 16),
              Text(
                widget.resource.description!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SelectableText(
                widget.resource.url,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _openLink,
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open Link'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentViewer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.resource.type.icon,
            size: 80,
            color: widget.resource.type.color,
          ),
          const SizedBox(height: 24),
          Text(
            widget.resource.type.displayName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'This file type requires a specific viewer',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _downloadResource,
            icon: const Icon(Icons.download),
            label: const Text('Download to View'),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.resource.type.icon,
              size: 80,
              color: widget.resource.type.color,
            ),
            const SizedBox(height: 24),
            Text(
              'Archive File',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Download to extract and view contents',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _downloadResource,
                icon: const Icon(Icons.download),
                label: const Text('Download Archive'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: AppColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            'Failed to Load Resource',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
              _loadResource();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.resource.description != null) ...[
              Text(
                widget.resource.description!,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                _buildInfoChip(
                  icon: widget.resource.type.icon,
                  label: widget.resource.type.displayName,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.storage,
                  label: widget.resource.formattedSize,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.download,
                  label: '${widget.resource.downloadCount}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleBookmark() {
    // TODO: Toggle bookmark
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.resource.isBookmarked
              ? 'Removed from bookmarks'
              : 'Added to bookmarks',
        ),
      ),
    );
  }

  void _shareResource() {
    // TODO: Share resource
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _downloadResource() {
    // TODO: Download resource
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DownloadProgressDialog(
        fileName: widget.resource.title,
        progress: _downloadProgress,
      ),
    );

    // Simulate download
    _simulateDownload();
  }

  void _simulateDownload() async {
    for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() {
          _downloadProgress = progress;
        });
      }
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download completed!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _openLink() {
    // TODO: Open link in browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${widget.resource.url}...')),
    );
  }
}
