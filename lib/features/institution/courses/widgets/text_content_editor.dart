import 'package:flutter/material.dart';
import '../../../../core/models/course_content_models.dart';

class TextContentEditor extends StatefulWidget {
  final TextContent? initialContent;
  final Function(TextContentRequest) onSave;

  const TextContentEditor({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<TextContentEditor> createState() => _TextContentEditorState();
}

class _TextContentEditorState extends State<TextContentEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  late TextEditingController _readingTimeController;
  final List<String> _attachments = [];
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.initialContent?.content ?? '',
    );
    _readingTimeController = TextEditingController(
      text: widget.initialContent?.estimatedReadingTime.toString() ?? '',
    );
    if (widget.initialContent?.attachments != null) {
      _attachments.addAll(widget.initialContent!.attachments);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _readingTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Text/Reading Content',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Edit'),
                    icon: Icon(Icons.edit, size: 16),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Preview'),
                    icon: Icon(Icons.visibility, size: 16),
                  ),
                ],
                selected: {_isPreviewMode},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isPreviewMode = newSelection.first;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!_isPreviewMode) ...[
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Enter your lesson content here...',
                border: OutlineInputBorder(),
                helperText: 'Supports Markdown formatting',
              ),
              maxLines: 15,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter content';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _readingTimeController,
              decoration: const InputDecoration(
                labelText: 'Estimated Reading Time (minutes)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter reading time';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildAttachmentsSection(),
          ] else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(minHeight: 400),
              child: SingleChildScrollView(
                child: Text(
                  _contentController.text.isEmpty
                      ? 'No content to preview'
                      : _contentController.text,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
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
                label: const Text('Save Text Content'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Attachments',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addAttachment,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Add Attachment'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_attachments.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                'No attachments',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ...List.generate(_attachments.length, (index) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: Text(_attachments[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _attachments.removeAt(index);
                    });
                  },
                ),
              ),
            );
          }),
      ],
    );
  }

  void _addAttachment() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Attachment'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'File URL',
            hintText: 'https://example.com/file.pdf',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _attachments.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveContent() {
    if (_formKey.currentState!.validate()) {
      final request = TextContentRequest(
        content: _contentController.text,
        estimatedReadingTime: int.parse(_readingTimeController.text),
        attachments: _attachments.isEmpty ? null : _attachments,
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
