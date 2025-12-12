import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../institution/providers/course_content_provider.dart';

/// Video Lesson Player
/// Displays video content for students with YouTube integration
class VideoLessonPlayer extends ConsumerStatefulWidget {
  final String lessonId;

  const VideoLessonPlayer({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<VideoLessonPlayer> createState() => _VideoLessonPlayerState();
}

class _VideoLessonPlayerState extends ConsumerState<VideoLessonPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // Load video content on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contentProvider.notifier).fetchVideoContent(widget.lessonId);
    });
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  String? _extractYouTubeVideoId(String url) {
    // Handle various YouTube URL formats
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([^&]+)'),
      RegExp(r'youtube\.com/embed/([^?]+)'),
      RegExp(r'youtu\.be/([^?]+)'),
      RegExp(r'youtube\.com/v/([^?]+)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        return match.group(1);
      }
    }
    return null;
  }

  void _initializeController(String videoUrl) {
    final videoId = _extractYouTubeVideoId(videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          mute: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentProvider);

    if (contentState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (contentState.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error loading video:\n${contentState.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(contentProvider.notifier).fetchVideoContent(widget.lessonId);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final content = contentState.content;
    if (content == null || content is! VideoContent) {
      return const Center(
        child: Text('No video content available'),
      );
    }

    // Initialize controller if not already done
    if (_controller == null) {
      _initializeController(content.videoUrl);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: _controller != null
                  ? YoutubePlayer(
                      controller: _controller!,
                      aspectRatio: 16 / 9,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.video_library, size: 80, color: Colors.white54),
                          const SizedBox(height: 16),
                          const Text(
                            'Non-YouTube video',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            content.videoUrl,
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Video URL: ${content.videoUrl}'),
                                  action: SnackBarAction(
                                    label: 'Copy',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('View URL'),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Video info
          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 8),
              Text('Duration: ${content.durationDisplay}'),
              const Spacer(),
              if (content.allowDownload)
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Download functionality coming soon'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
            ],
          ),

          // Transcript
          if (content.transcript != null) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.subtitles),
                const SizedBox(width: 8),
                const Text(
                  'Transcript',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                content.transcript!,
                style: const TextStyle(height: 1.6),
              ),
            ),
          ],

          const SizedBox(height: 32),

          // Video player info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _controller != null
                        ? 'YouTube video player with full playback controls, fullscreen support, and quality selection.'
                        : 'This video is not from YouTube. For non-YouTube videos, consider using the video_player package or providing a direct link.',
                    style: TextStyle(color: Colors.blue[900], fontSize: 12),
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
