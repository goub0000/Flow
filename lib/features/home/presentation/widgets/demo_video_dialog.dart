import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// A dialog that displays a YouTube demo video for the Flow platform.
///
/// Usage:
/// ```dart
/// showDemoVideoDialog(context);
/// ```
class DemoVideoDialog extends StatefulWidget {
  const DemoVideoDialog({super.key});

  @override
  State<DemoVideoDialog> createState() => _DemoVideoDialogState();
}

class _DemoVideoDialogState extends State<DemoVideoDialog> {
  late final YoutubePlayerController _controller;
  bool _isLoading = true;

  // Replace with your actual demo video ID
  static const String _demoVideoId = 'dQw4w9WgXcQ'; // Placeholder - replace with real demo

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _demoVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );

    _controller.setFullScreenListener((isFullScreen) {
      // Handle fullscreen changes if needed
    });

    // Mark as loaded after a brief delay to ensure player is ready
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Responsive sizing
    final isDesktop = screenSize.width > 800;
    final dialogWidth = isDesktop ? 800.0 : screenSize.width * 0.95;
    final aspectRatio = 16 / 9;
    final videoHeight = dialogWidth / aspectRatio;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 12,
        vertical: 24,
      ),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: screenSize.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 8, 8),
              child: Row(
                children: [
                  Icon(
                    Icons.play_circle_filled,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'See Flow in Action',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Watch how Flow transforms education',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Video Player
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: SizedBox(
                width: dialogWidth,
                height: videoHeight.clamp(200.0, 500.0),
                child: Stack(
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      aspectRatio: aspectRatio,
                    ),

                    // Loading overlay
                    if (_isLoading)
                      Container(
                        color: Colors.black87,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading demo...',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the demo video dialog.
///
/// Call this from any button's onPressed handler:
/// ```dart
/// OutlinedButton(
///   onPressed: () => showDemoVideoDialog(context),
///   child: Text('Watch Demo'),
/// )
/// ```
void showDemoVideoDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => const DemoVideoDialog(),
  );
}
