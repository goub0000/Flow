import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../core/theme/app_colors.dart';

/// A text editor widget for CMS content editing.
/// Uses a simple TextField for reliable cross-platform compatibility.
class RichTextContentEditor extends StatefulWidget {
  /// The initial content in Quill Delta JSON format or plain text.
  final Map<String, dynamic>? initialContent;

  /// Callback when content changes. Returns Quill Delta JSON.
  final ValueChanged<Map<String, dynamic>>? onChanged;

  /// Whether the editor is in read-only mode.
  final bool readOnly;

  /// Optional label to display above the editor.
  final String? label;

  /// Optional hint text when editor is empty.
  final String? hintText;

  /// Height of the editor. Defaults to 300.
  final double height;

  const RichTextContentEditor({
    super.key,
    this.initialContent,
    this.onChanged,
    this.readOnly = false,
    this.label,
    this.hintText,
    this.height = 300,
  });

  @override
  State<RichTextContentEditor> createState() => _RichTextContentEditorState();
}

class _RichTextContentEditorState extends State<RichTextContentEditor> {
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: _extractInitialText());
    _textController.addListener(_onTextChanged);
  }

  String _extractInitialText() {
    if (widget.initialContent == null) return '';

    // If it's already Quill Delta format, extract text
    if (widget.initialContent!.containsKey('ops')) {
      try {
        final doc = Document.fromJson(widget.initialContent!['ops'] as List);
        return doc.toPlainText().trim();
      } catch (e) {
        return '';
      }
    }

    // Handle other content formats
    if (widget.initialContent!.containsKey('text')) {
      return widget.initialContent!['text'].toString();
    }
    if (widget.initialContent!.containsKey('content')) {
      final c = widget.initialContent!['content'];
      if (c is String) return c;
    }
    return '';
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      // Convert plain text to Quill Delta format for consistency
      final text = _textController.text;
      final doc = Document()..insert(0, text);
      widget.onChanged!({'ops': doc.toDelta().toJson()});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Simple info bar
              if (!widget.readOnly)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit_note, size: 20, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Content Editor',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${_textController.text.length} characters',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!widget.readOnly) Divider(height: 1, color: AppColors.border),
              // Text input area - using TextFormField for better web compatibility
              Container(
                height: widget.height,
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: _textController,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  maxLines: null,
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'Start typing your content here...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A section editor widget that combines a title field with a text editor.
/// Used for editing content sections (like privacy policy sections).
class SectionEditor extends StatefulWidget {
  final int index;
  final String initialTitle;
  final Map<String, dynamic>? initialContent;
  final ValueChanged<Map<String, dynamic>>? onChanged;
  final VoidCallback? onRemove;
  final bool canRemove;

  const SectionEditor({
    super.key,
    required this.index,
    required this.initialTitle,
    this.initialContent,
    this.onChanged,
    this.onRemove,
    this.canRemove = true,
  });

  @override
  State<SectionEditor> createState() => _SectionEditorState();
}

class _SectionEditorState extends State<SectionEditor> {
  late TextEditingController _titleController;
  Map<String, dynamic> _contentDelta = {};
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentDelta = widget.initialContent ?? {};
    _titleController.addListener(_notifyChange);
  }

  @override
  void dispose() {
    _titleController.removeListener(_notifyChange);
    _titleController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onChanged?.call({
      'title': _titleController.text,
      'content': _contentDelta,
    });
  }

  void _onContentChanged(Map<String, dynamic> delta) {
    _contentDelta = delta;
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(11),
                  bottom: _isExpanded ? Radius.zero : const Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Section ${widget.index + 1}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_titleController.text.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '- ${_titleController.text}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  if (widget.canRemove)
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppColors.error),
                      onPressed: widget.onRemove,
                      tooltip: 'Remove section',
                      iconSize: 20,
                    ),
                ],
              ),
            ),
          ),
          // Content
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Section Title',
                      hintText: 'Enter section title',
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichTextContentEditor(
                    label: 'Section Content',
                    initialContent: widget.initialContent,
                    onChanged: _onContentChanged,
                    hintText: 'Enter section content...',
                    height: 250,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper class for converting between different content formats
class ContentConverter {
  /// Convert Quill Delta JSON to plain text
  static String deltaToPlainText(Map<String, dynamic>? delta) {
    if (delta == null || !delta.containsKey('ops')) {
      return '';
    }

    try {
      final doc = Document.fromJson(delta['ops'] as List);
      return doc.toPlainText().trim();
    } catch (e) {
      return '';
    }
  }

  /// Convert plain text to Quill Delta JSON
  static Map<String, dynamic> plainTextToDelta(String text) {
    final doc = Document()..insert(0, text);
    return {'ops': doc.toDelta().toJson()};
  }

  /// Check if content is in Quill Delta format
  static bool isQuillDelta(dynamic content) {
    if (content is Map<String, dynamic>) {
      return content.containsKey('ops') && content['ops'] is List;
    }
    return false;
  }

  /// Convert legacy section content to new format with Quill Delta
  static Map<String, dynamic> convertSectionToQuillFormat(
      Map<String, dynamic> section) {
    final title = section['title']?.toString() ?? '';
    final content = section['content'];

    Map<String, dynamic> contentDelta;
    if (content is String) {
      contentDelta = plainTextToDelta(content);
    } else if (content is Map<String, dynamic> && isQuillDelta(content)) {
      contentDelta = content;
    } else {
      contentDelta = plainTextToDelta('');
    }

    return {
      'title': title,
      'content': contentDelta,
    };
  }

  /// Convert section with Quill Delta to legacy format (for display)
  static Map<String, dynamic> convertSectionToLegacyFormat(
      Map<String, dynamic> section) {
    final title = section['title']?.toString() ?? '';
    final content = section['content'];

    String contentText;
    if (content is Map<String, dynamic> && isQuillDelta(content)) {
      contentText = deltaToPlainText(content);
    } else if (content is String) {
      contentText = content;
    } else {
      contentText = '';
    }

    return {
      'title': title,
      'content': contentText,
    };
  }

  /// Convert full page content to use Quill Delta format
  static Map<String, dynamic> convertPageContentToQuillFormat(
      Map<String, dynamic> content) {
    final result = Map<String, dynamic>.from(content);

    // Convert sections if present
    if (content.containsKey('sections') && content['sections'] is List) {
      result['sections'] = (content['sections'] as List)
          .map((s) => s is Map<String, dynamic>
              ? convertSectionToQuillFormat(s)
              : s)
          .toList();
    }

    return result;
  }

  /// Convert page content from Quill format back to legacy format
  static Map<String, dynamic> convertPageContentToLegacyFormat(
      Map<String, dynamic> content) {
    final result = Map<String, dynamic>.from(content);

    // Convert sections if present
    if (content.containsKey('sections') && content['sections'] is List) {
      result['sections'] = (content['sections'] as List)
          .map((s) => s is Map<String, dynamic>
              ? convertSectionToLegacyFormat(s)
              : s)
          .toList();
    }

    return result;
  }
}
