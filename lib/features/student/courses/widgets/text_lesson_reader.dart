import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/models/course_content_models.dart';
import '../../../institution/providers/course_content_provider.dart';

/// Text Lesson Reader
/// Displays text/reading content for students
class TextLessonReader extends ConsumerStatefulWidget {
  final String lessonId;

  const TextLessonReader({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<TextLessonReader> createState() => _TextLessonReaderState();
}

class _TextLessonReaderState extends ConsumerState<TextLessonReader> {
  @override
  void initState() {
    super.initState();
    // Load text content on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contentProvider.notifier).fetchTextContent(widget.lessonId);
    });
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
                'Error loading content:\n${contentState.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(contentProvider.notifier).fetchTextContent(widget.lessonId);
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
    if (content == null || content is! TextContent) {
      return const Center(
        child: Text('No text content available'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reading time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  '${content.estimatedReadingTime ?? 5} min read',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Main content
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: MarkdownWidget(
              data: content.content,
              selectable: true,
              shrinkWrap: true,
              config: MarkdownConfig(
                configs: [
                  LinkConfig(
                    onTap: _launchUrl,
                  ),
                  PConfig(textStyle: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    letterSpacing: 0.3,
                  )),
                  H1Config(style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  )),
                  H2Config(style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  )),
                  H3Config(style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  )),
                  CodeConfig(style: TextStyle(
                    backgroundColor: Colors.grey[100],
                    fontFamily: 'monospace',
                    fontSize: 14,
                  )),
                  PreConfig(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  BlockquoteConfig(
                    textColor: Colors.grey[700]!,
                  ),
                ],
              ),
            ),
          ),

          // Attachments
          if (content.attachments.isNotEmpty) ...[
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.attach_file),
                SizedBox(width: 8),
                Text(
                  'Attachments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...content.attachments.map((attachment) {
              final url = attachment['url'] as String? ?? '';
              final name = attachment['name'] as String? ?? _getFileNameFromUrl(url);
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    url,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading: $name'),
                        ),
                      );
                      // Implement actual download logic
                    },
                    tooltip: 'Download',
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Opening: $name'),
                      ),
                    );
                    // Open file in browser or viewer
                  },
                ),
              );
            }),
          ],

          const SizedBox(height: 32),

          // Markdown formatting tip
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
                    'This content supports Markdown formatting including headings, bold, italic, code blocks, links, and more.',
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

  String _getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      if (pathSegments.isNotEmpty) {
        return pathSegments.last;
      }
    } catch (e) {
      // Return the full URL if parsing fails
    }
    return url;
  }

  void _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // URL launch failed - could show a snackbar here
    }
  }
}
