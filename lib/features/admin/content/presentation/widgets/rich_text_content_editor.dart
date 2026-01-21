import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../../../../../core/theme/app_colors.dart';

/// A text editor widget for CMS content editing with markdown formatting toolbar.
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

  /// Apply formatting to selected text or insert at cursor
  void _applyFormatting(String prefix, String suffix, {String? placeholder}) {
    final text = _textController.text;
    final selection = _textController.selection;

    if (!selection.isValid) {
      // No valid selection, insert at end
      final newText = '$text$prefix${placeholder ?? ''}$suffix';
      _textController.text = newText;
      _textController.selection = TextSelection.collapsed(
        offset: newText.length - suffix.length,
      );
      return;
    }

    final selectedText = selection.textInside(text);
    final before = text.substring(0, selection.start);
    final after = text.substring(selection.end);

    String newText;
    int newCursorPos;

    if (selectedText.isEmpty) {
      // No text selected, insert placeholder
      final insert = placeholder ?? '';
      newText = '$before$prefix$insert$suffix$after';
      newCursorPos = selection.start + prefix.length + insert.length;
    } else {
      // Wrap selected text
      newText = '$before$prefix$selectedText$suffix$after';
      newCursorPos = selection.start + prefix.length + selectedText.length + suffix.length;
    }

    _textController.text = newText;
    _textController.selection = TextSelection.collapsed(offset: newCursorPos);
    _focusNode.requestFocus();
  }

  /// Insert text at cursor position
  void _insertAtCursor(String insert) {
    final text = _textController.text;
    final selection = _textController.selection;

    if (!selection.isValid) {
      _textController.text = '$text$insert';
      return;
    }

    final before = text.substring(0, selection.start);
    final after = text.substring(selection.end);

    _textController.text = '$before$insert$after';
    _textController.selection = TextSelection.collapsed(
      offset: selection.start + insert.length,
    );
    _focusNode.requestFocus();
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
              // Formatting toolbar
              if (!widget.readOnly) _buildToolbar(theme),
              if (!widget.readOnly) Divider(height: 1, color: AppColors.border),
              // Text input area
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
              // Character count footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(7)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Supports Markdown formatting',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    Text(
                      '${_textController.text.length} characters',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
      ),
      child: Wrap(
        spacing: 2,
        runSpacing: 4,
        children: [
          // Bold
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold (**text**)',
            onPressed: () => _applyFormatting('**', '**', placeholder: 'bold text'),
          ),
          // Italic
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic (*text*)',
            onPressed: () => _applyFormatting('*', '*', placeholder: 'italic text'),
          ),
          // Underline (using HTML tag for markdown compatibility)
          _ToolbarButton(
            icon: Icons.format_underlined,
            tooltip: 'Underline',
            onPressed: () => _applyFormatting('<u>', '</u>', placeholder: 'underlined text'),
          ),
          // Strikethrough
          _ToolbarButton(
            icon: Icons.format_strikethrough,
            tooltip: 'Strikethrough (~~text~~)',
            onPressed: () => _applyFormatting('~~', '~~', placeholder: 'strikethrough'),
          ),

          _ToolbarDivider(),

          // Heading 1
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading 1',
            label: 'H1',
            onPressed: () => _insertAtCursor('\n# '),
          ),
          // Heading 2
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading 2',
            label: 'H2',
            onPressed: () => _insertAtCursor('\n## '),
          ),
          // Heading 3
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading 3',
            label: 'H3',
            onPressed: () => _insertAtCursor('\n### '),
          ),

          _ToolbarDivider(),

          // Bullet list
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet list',
            onPressed: () => _insertAtCursor('\n- '),
          ),
          // Numbered list
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered list',
            onPressed: () => _insertAtCursor('\n1. '),
          ),
          // Quote
          _ToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Quote',
            onPressed: () => _insertAtCursor('\n> '),
          ),

          _ToolbarDivider(),

          // Link
          _ToolbarButton(
            icon: Icons.link,
            tooltip: 'Insert link [text](url)',
            onPressed: () => _applyFormatting('[', '](url)', placeholder: 'link text'),
          ),
          // Code
          _ToolbarButton(
            icon: Icons.code,
            tooltip: 'Inline code',
            onPressed: () => _applyFormatting('`', '`', placeholder: 'code'),
          ),
          // Horizontal rule
          _ToolbarButton(
            icon: Icons.horizontal_rule,
            tooltip: 'Horizontal line',
            onPressed: () => _insertAtCursor('\n\n---\n\n'),
          ),
        ],
      ),
    );
  }
}

/// Toolbar button widget
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final String? label;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                )
              : Icon(icon, size: 18, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Toolbar divider widget
class _ToolbarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: AppColors.border,
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
