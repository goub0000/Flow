import 'package:flutter/material.dart';
import '../../../../core/models/course_content_models.dart';

class VideoContentEditor extends StatefulWidget {
  final VideoContent? initialContent;
  final Function(VideoContentRequest) onSave;

  const VideoContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<VideoContentEditor> createState() => _VideoContentEditorState();
}

class _VideoContentEditorState extends State<VideoContentEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _urlController;
  late TextEditingController _durationController;
  late TextEditingController _transcriptController;
  bool _allowDownload = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(
      text: widget.initialContent?.videoUrl ?? '',
    );
    _durationController = TextEditingController(
      text: widget.initialContent?.duration.toString() ?? '',
    );
    _transcriptController = TextEditingController(
      text: widget.initialContent?.transcript ?? '',
    );
    _allowDownload = widget.initialContent?.allowDownload ?? false;
  }

  @override
  void dispose() {
    _urlController.dispose();
    _durationController.dispose();
    _transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Content',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Video URL',
              hintText: 'https://www.youtube.com/watch?v=...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.video_library),
              helperText: 'YouTube, Vimeo, or direct video link',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a video URL';
              }
              if (!Uri.tryParse(value)!.isAbsolute) {
                return 'Please enter a valid URL';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _durationController,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.access_time),
              helperText: 'Enter duration in minutes',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter duration';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _transcriptController,
            decoration: const InputDecoration(
              labelText: 'Transcript (Optional)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.subtitles),
              helperText: 'Video transcript for accessibility',
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Allow Download'),
            subtitle: const Text('Let students download this video'),
            value: _allowDownload,
            onChanged: (value) {
              setState(() {
                _allowDownload = value;
              });
            },
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _saveContent,
                icon: const Icon(Icons.save),
                label: const Text('Save Video Content'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      final request = VideoContentRequest(
        videoUrl: _urlController.text,
        duration: int.parse(_durationController.text),
        transcript: _transcriptController.text.isEmpty
            ? null
            : _transcriptController.text,
        allowDownload: _allowDownload,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
