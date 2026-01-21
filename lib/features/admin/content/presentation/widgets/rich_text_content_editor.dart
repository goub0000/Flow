import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../core/theme/app_colors.dart';

/// A rich text editor widget for CMS content editing using flutter_quill.
/// Provides WYSIWYG editing with toolbar for formatting text.
class RichTextContentEditor extends StatefulWidget {
  /// The initial content in Quill Delta JSON format.
  /// If null or invalid, starts with empty document.
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
  late QuillController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    _controller.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  QuillController _createController() {
    Document document;

    if (widget.initialContent != null) {
      try {
        // Check if it's already a Quill Delta format
        if (widget.initialContent!.containsKey('ops')) {
          document = Document.fromJson(widget.initialContent!['ops'] as List);
        } else {
          // Convert plain text content to Quill format
          document = Document()..insert(0, _extractPlainText(widget.initialContent!));
        }
      } catch (e) {
        // If parsing fails, start with empty document
        document = Document();
      }
    } else {
      document = Document();
    }

    return QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: widget.readOnly,
    );
  }

  /// Extract plain text from various content formats
  String _extractPlainText(Map<String, dynamic> content) {
    // Handle case where content is a simple text field
    if (content.containsKey('text')) {
      return content['text'].toString();
    }
    // Handle case where content has a content field (for sections)
    if (content.containsKey('content')) {
      final c = content['content'];
      if (c is String) return c;
      if (c is Map && c.containsKey('ops')) {
        // It's already Quill format, parse it
        return '';
      }
    }
    return '';
  }

  void _onContentChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(getDeltaJson());
    }
  }

  /// Get the current content as Quill Delta JSON
  Map<String, dynamic> getDeltaJson() {
    return {'ops': _controller.document.toDelta().toJson()};
  }

  /// Get the current content as plain text
  String getPlainText() {
    return _controller.document.toPlainText();
  }

  /// Set content from Quill Delta JSON
  void setContent(Map<String, dynamic>? content) {
    _controller.removeListener(_onContentChanged);

    Document document;
    if (content != null && content.containsKey('ops')) {
      try {
        document = Document.fromJson(content['ops'] as List);
      } catch (e) {
        document = Document();
      }
    } else {
      document = Document();
    }

    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: widget.readOnly,
    );

    _controller.addListener(_onContentChanged);
    setState(() {});
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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Toolbar
              if (!widget.readOnly) _buildToolbar(theme),
              // Editor
              Container(
                height: widget.height,
                decoration: BoxDecoration(
                  border: widget.readOnly
                      ? null
                      : Border(
                          top: BorderSide(color: AppColors.border),
                        ),
                ),
                child: QuillEditor.basic(
                  controller: _controller,
                  focusNode: _focusNode,
                  scrollController: _scrollController,
                  config: QuillEditorConfig(
                    padding: const EdgeInsets.all(16),
                    placeholder: widget.hintText ?? 'Start typing...',
                    expands: true,
                    autoFocus: false,
                    customStyles: _buildCustomStyles(theme),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: QuillSimpleToolbar(
        controller: _controller,
        config: QuillSimpleToolbarConfig(
          showDividers: true,
          showFontFamily: false,
          showFontSize: false,
          showBoldButton: true,
          showItalicButton: true,
          showUnderLineButton: true,
          showStrikeThrough: true,
          showInlineCode: false,
          showColorButton: true,
          showBackgroundColorButton: false,
          showClearFormat: true,
          showAlignmentButtons: true,
          showLeftAlignment: true,
          showCenterAlignment: true,
          showRightAlignment: true,
          showJustifyAlignment: false,
          showHeaderStyle: true,
          showListNumbers: true,
          showListBullets: true,
          showListCheck: false,
          showCodeBlock: false,
          showQuote: true,
          showIndent: true,
          showLink: true,
          showUndo: true,
          showRedo: true,
          showSearchButton: false,
          showSubscript: false,
          showSuperscript: false,
        ),
      ),
    );
  }

  DefaultStyles _buildCustomStyles(ThemeData theme) {
    return DefaultStyles(
      h1: DefaultTextBlockStyle(
        TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(16, 8),
        const VerticalSpacing(0, 0),
        null,
      ),
      h2: DefaultTextBlockStyle(
        TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(14, 6),
        const VerticalSpacing(0, 0),
        null,
      ),
      h3: DefaultTextBlockStyle(
        TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.3,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(12, 4),
        const VerticalSpacing(0, 0),
        null,
      ),
      paragraph: DefaultTextBlockStyle(
        TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          height: 1.5,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(8, 8),
        const VerticalSpacing(0, 0),
        null,
      ),
      bold: const TextStyle(fontWeight: FontWeight.bold),
      italic: const TextStyle(fontStyle: FontStyle.italic),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikeThrough: const TextStyle(decoration: TextDecoration.lineThrough),
      link: TextStyle(
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      ),
      placeHolder: DefaultTextBlockStyle(
        TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary.withValues(alpha: 0.6),
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
    );
  }
}

/// A section editor widget that combines a title field with a rich text editor.
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
