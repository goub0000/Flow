// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/models/course_content_models.dart';
import 'content_editor_wrapper.dart';

/// Attachment model for file attachments
class Attachment {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int? fileSizeBytes;
  final String? description;

  Attachment({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    this.fileSizeBytes,
    this.description,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'file_name': fileName,
        'file_url': fileUrl,
        'file_type': fileType,
        'file_size_bytes': fileSizeBytes,
        'description': description,
      };

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: json['file_name'] as String,
        fileUrl: json['file_url'] as String,
        fileType: json['file_type'] as String? ?? 'application/octet-stream',
        fileSizeBytes: json['file_size_bytes'] as int?,
        description: json['description'] as String?,
      );

  String get fileSizeDisplay {
    if (fileSizeBytes == null) return '';
    if (fileSizeBytes! < 1024) return '${fileSizeBytes}B';
    if (fileSizeBytes! < 1024 * 1024) return '${(fileSizeBytes! / 1024).toStringAsFixed(1)}KB';
    return '${(fileSizeBytes! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  IconData get fileIcon {
    switch (fileType.toLowerCase()) {
      case 'pdf':
      case 'application/pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
      case 'application/msword':
        return Icons.description;
      case 'xls':
      case 'xlsx':
      case 'application/vnd.ms-excel':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'image':
        return Icons.image;
      case 'zip':
      case 'rar':
      case '7z':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }
}

/// External link model
class ExternalLink {
  final String title;
  final String url;
  final String? description;
  final bool openInNewTab;

  ExternalLink({
    required this.title,
    required this.url,
    this.description,
    this.openInNewTab = true,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
        'description': description,
        'open_in_new_tab': openInNewTab,
      };

  factory ExternalLink.fromJson(Map<String, dynamic> json) => ExternalLink(
        title: json['title'] as String,
        url: json['url'] as String,
        description: json['description'] as String?,
        openInNewTab: json['open_in_new_tab'] as bool? ?? true,
      );
}

/// Learning objective model
class LearningObjective {
  final String text;
  final bool isCompleted;

  LearningObjective({
    required this.text,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'is_completed': isCompleted,
      };
}

/// A professional text/reading content editor for creating college-grade reading materials.
/// Supports rich text formatting, attachments, external links, and comprehensive features.
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

class _TextContentEditorState extends State<TextContentEditor>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Content editor
  late TextEditingController _contentController;
  bool _isMarkdownMode = true;
  String _contentFormat = 'markdown';

  // Reading time
  int _estimatedReadingTime = 0;
  bool _autoCalculateReadingTime = true;

  // Attachments
  final List<Attachment> _attachments = [];

  // External links
  final List<ExternalLink> _externalLinks = [];

  // Learning objectives
  final List<LearningObjective> _learningObjectives = [];

  // Prerequisites
  final List<String> _prerequisites = [];

  // State tracking
  bool _hasChanges = false;
  bool _isSaving = false;

  late TabController _tabController;

  // Stats
  int get _wordCount {
    final text = _contentController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }

  int get _characterCount => _contentController.text.length;

  int get _calculatedReadingTime {
    // Average reading speed: 200 words per minute
    return (_wordCount / 200).ceil();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _contentController = TextEditingController(
      text: widget.initialContent?.content ?? '',
    );

    // Load initial content
    if (widget.initialContent != null) {
      final content = widget.initialContent!;
      _contentFormat = content.contentFormat;
      _isMarkdownMode = _contentFormat == 'markdown';
      _estimatedReadingTime = content.estimatedReadingTime ?? 0;

      // Load attachments
      for (final attachment in content.attachments) {
        _attachments.add(Attachment.fromJson(attachment));
      }

      // Load external links
      for (final link in content.externalLinks) {
        _externalLinks.add(ExternalLink.fromJson(link));
      }
    }

    // Add listeners
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }

    // Update auto-calculated reading time
    if (_autoCalculateReadingTime) {
      setState(() {
        _estimatedReadingTime = _calculatedReadingTime;
      });
    }
  }

  bool get _isValid {
    return _contentController.text.isNotEmpty;
  }

  List<String> _validate() {
    final errors = <String>[];

    if (_contentController.text.isEmpty) {
      errors.add('Content is required');
    }

    if (_contentController.text.length < 50) {
      errors.add('Content should be at least 50 characters for meaningful reading');
    }

    if (_estimatedReadingTime == 0 && _wordCount > 0) {
      errors.add('Reading time should be set');
    }

    // Validate external links
    for (int i = 0; i < _externalLinks.length; i++) {
      final link = _externalLinks[i];
      final uri = Uri.tryParse(link.url);
      if (uri == null || !uri.hasScheme) {
        errors.add('External link ${i + 1} has invalid URL');
      }
    }

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return ContentEditorWrapper(
      title: 'Text Content Editor',
      subtitle: 'Create engaging reading materials for students',
      icon: Icons.article,
      themeColor: Colors.blue,
      editorContent: _buildEditorContent(),
      previewContent: _buildPreviewContent(),
      onSave: _saveContent,
      onCancel: () => Navigator.pop(context),
      hasUnsavedChanges: () => _hasChanges,
      validate: _validate,
      isValid: _isValid,
      isSaving: _isSaving,
      saveButtonLabel: 'Save Text Content',
      summaryWidget: _buildSummaryWidget(),
    );
  }

  Widget _buildSummaryWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isValid ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isValid ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isValid ? Icons.check_circle : Icons.warning,
            size: 20,
            color: _isValid ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildSummaryChip(
                  Icons.text_fields,
                  '$_wordCount words',
                  Colors.blue,
                ),
                _buildSummaryChip(
                  Icons.timer,
                  '$_estimatedReadingTime min read',
                  Colors.green,
                ),
                if (_attachments.isNotEmpty)
                  _buildSummaryChip(
                    Icons.attach_file,
                    '${_attachments.length} files',
                    Colors.orange,
                  ),
                if (_externalLinks.isNotEmpty)
                  _buildSummaryChip(
                    Icons.link,
                    '${_externalLinks.length} links',
                    Colors.purple,
                  ),
                if (_learningObjectives.isNotEmpty)
                  _buildSummaryChip(
                    Icons.check_circle_outline,
                    '${_learningObjectives.length} objectives',
                    Colors.teal,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.edit_document), text: 'Content'),
              Tab(icon: Icon(Icons.attach_file), text: 'Attachments'),
              Tab(icon: Icon(Icons.link), text: 'Resources'),
              Tab(icon: Icon(Icons.school), text: 'Learning'),
            ],
            labelColor: Colors.blue.shade700,
            indicatorColor: Colors.blue.shade700,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContentTab(),
                _buildAttachmentsTab(),
                _buildResourcesTab(),
                _buildLearningTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Editor Mode Toggle
          EditorSection(
            title: 'Content Editor',
            icon: Icons.edit,
            iconColor: Colors.blue,
            subtitle: 'Write your lesson content',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_wordCount words | $_characterCount chars',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mode toggle and toolbar
                Row(
                  children: [
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          label: Text('Markdown'),
                          icon: Icon(Icons.code, size: 16),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text('Rich Text'),
                          icon: Icon(Icons.format_bold, size: 16),
                        ),
                      ],
                      selected: {_isMarkdownMode},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _isMarkdownMode = newSelection.first;
                          _contentFormat = _isMarkdownMode ? 'markdown' : 'html';
                          _hasChanges = true;
                        });
                      },
                    ),
                    const Spacer(),
                    // Formatting toolbar
                    _buildFormattingToolbar(),
                  ],
                ),
                const SizedBox(height: 12),

                // Content editor
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      // Quick format buttons for markdown
                      if (_isMarkdownMode)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildMarkdownButton('H1', '# ', 'Heading 1'),
                                _buildMarkdownButton('H2', '## ', 'Heading 2'),
                                _buildMarkdownButton('H3', '### ', 'Heading 3'),
                                const VerticalDivider(width: 16),
                                _buildMarkdownIconButton(Icons.format_bold, '**', '**', 'Bold'),
                                _buildMarkdownIconButton(Icons.format_italic, '_', '_', 'Italic'),
                                _buildMarkdownIconButton(Icons.strikethrough_s, '~~', '~~', 'Strikethrough'),
                                const VerticalDivider(width: 16),
                                _buildMarkdownIconButton(Icons.format_list_bulleted, '\n- ', '', 'Bullet List'),
                                _buildMarkdownIconButton(Icons.format_list_numbered, '\n1. ', '', 'Numbered List'),
                                _buildMarkdownIconButton(Icons.format_quote, '\n> ', '', 'Quote'),
                                const VerticalDivider(width: 16),
                                _buildMarkdownIconButton(Icons.link, '[', '](url)', 'Link'),
                                _buildMarkdownIconButton(Icons.image, '![alt](', ')', 'Image'),
                                _buildMarkdownIconButton(Icons.code, '`', '`', 'Inline Code'),
                                _buildMarkdownButton('```', '\n```\n', 'Code Block'),
                                const VerticalDivider(width: 16),
                                _buildMarkdownIconButton(Icons.table_chart, '\n| Header | Header |\n|--------|--------|\n| Cell   | Cell   |', '', 'Table'),
                              ],
                            ),
                          ),
                        ),
                      TextFormField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: _isMarkdownMode
                              ? '# Start writing your lesson content...\n\nUse **bold** and _italic_ for emphasis.\n\n## Add sections with headings\n\n- Create bullet points\n- To organize information'
                              : 'Start writing your lesson content here...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        maxLines: 20,
                        style: TextStyle(
                          fontFamily: _isMarkdownMode ? 'monospace' : null,
                          fontSize: 14,
                          height: 1.6,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Content is required';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Markdown help
                if (_isMarkdownMode)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tip: Use # for headings, ** for bold, _ for italic, - for lists, and > for quotes',
                            style: TextStyle(color: Colors.blue.shade700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Reading Time
          EditorSection(
            title: 'Reading Time',
            icon: Icons.timer,
            iconColor: Colors.green,
            subtitle: 'Estimated time to read this content',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _estimatedReadingTime.toString(),
                        enabled: !_autoCalculateReadingTime,
                        decoration: InputDecoration(
                          labelText: 'Minutes',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.timer),
                          suffixText: 'min',
                          filled: _autoCalculateReadingTime,
                          fillColor: Colors.grey.shade100,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          if (!_autoCalculateReadingTime) {
                            setState(() {
                              _estimatedReadingTime = int.tryParse(value) ?? 0;
                              _hasChanges = true;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _autoCalculateReadingTime,
                              onChanged: (value) {
                                setState(() {
                                  _autoCalculateReadingTime = value ?? true;
                                  if (_autoCalculateReadingTime) {
                                    _estimatedReadingTime = _calculatedReadingTime;
                                  }
                                  _hasChanges = true;
                                });
                              },
                            ),
                            const Text('Auto-calculate'),
                          ],
                        ),
                        Text(
                          'Based on $_wordCount words @ 200 wpm',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
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

  Widget _buildFormattingToolbar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.undo, size: 20),
          onPressed: () {
            // TODO: Implement undo
          },
          tooltip: 'Undo',
        ),
        IconButton(
          icon: const Icon(Icons.redo, size: 20),
          onPressed: () {
            // TODO: Implement redo
          },
          tooltip: 'Redo',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.spellcheck, size: 20),
          onPressed: () {
            // TODO: Implement spell check
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Spell check coming soon')),
            );
          },
          tooltip: 'Spell Check',
        ),
      ],
    );
  }

  Widget _buildMarkdownButton(String label, String prefix, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _insertMarkdown(prefix, ''),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownIconButton(IconData icon, String prefix, String suffix, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () => _insertMarkdown(prefix, suffix),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  void _insertMarkdown(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final selectedText = selection.textInside(text);

    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$prefix$selectedText$suffix',
    );

    _contentController.text = newText;
    _contentController.selection = TextSelection.collapsed(
      offset: selection.start + prefix.length + selectedText.length + suffix.length,
    );
  }

  Widget _buildAttachmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          EditorSection(
            title: 'File Attachments',
            icon: Icons.attach_file,
            iconColor: Colors.orange,
            subtitle: 'Upload supplementary materials',
            trailing: Text(
              '${_attachments.length} files',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_attachments.isEmpty)
                  _buildEmptyState(
                    icon: Icons.cloud_upload,
                    title: 'No attachments yet',
                    subtitle: 'Add PDFs, documents, images, and more',
                  )
                else
                  ...List.generate(_attachments.length, (index) {
                    final attachment = _attachments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            attachment.fileIcon,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        title: Text(attachment.fileName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (attachment.description != null)
                              Text(
                                attachment.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            Row(
                              children: [
                                Text(
                                  attachment.fileType.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                if (attachment.fileSizeBytes != null) ...[
                                  const Text(' | '),
                                  Text(
                                    attachment.fileSizeDisplay,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showEditAttachmentDialog(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                              onPressed: () {
                                setState(() {
                                  _attachments.removeAt(index);
                                  _hasChanges = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAddAttachmentDialog,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Attachment'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement file picker
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File picker coming soon')),
                        );
                      },
                      icon: const Icon(Icons.upload_file, size: 18),
                      label: const Text('Upload File'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Supported formats: PDF, DOC, DOCX, XLS, XLSX, PPT, PPTX, JPG, PNG, GIF, ZIP (Max 50MB per file)',
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // External Links
          EditorSection(
            title: 'External Links',
            icon: Icons.link,
            iconColor: Colors.purple,
            subtitle: 'Add reference links and resources',
            trailing: Text(
              '${_externalLinks.length} links',
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_externalLinks.isEmpty)
                  _buildEmptyState(
                    icon: Icons.add_link,
                    title: 'No external links yet',
                    subtitle: 'Add links to helpful resources',
                  )
                else
                  ...List.generate(_externalLinks.length, (index) {
                    final link = _externalLinks[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.purple.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.link,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        title: Text(link.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade600,
                              ),
                            ),
                            if (link.description != null)
                              Text(
                                link.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            Row(
                              children: [
                                Icon(
                                  link.openInNewTab
                                      ? Icons.open_in_new
                                      : Icons.open_in_browser,
                                  size: 12,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  link.openInNewTab ? 'Opens in new tab' : 'Opens in same tab',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showEditLinkDialog(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                              onPressed: () {
                                setState(() {
                                  _externalLinks.removeAt(index);
                                  _hasChanges = true;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddLinkDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add External Link'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Related Content (placeholder for future)
          EditorSection(
            title: 'Related Content',
            icon: Icons.auto_stories,
            iconColor: Colors.teal,
            subtitle: 'Link to related lessons in this course',
            initiallyExpanded: false,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Icon(Icons.auto_stories, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'Coming Soon',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Link related lessons from this course',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Learning Objectives
          EditorSection(
            title: 'Learning Objectives',
            icon: Icons.check_circle_outline,
            iconColor: Colors.teal,
            subtitle: 'What will students learn from this content?',
            trailing: Text(
              '${_learningObjectives.length} objectives',
              style: TextStyle(
                color: Colors.teal.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_learningObjectives.isEmpty)
                  _buildEmptyState(
                    icon: Icons.emoji_objects,
                    title: 'No learning objectives yet',
                    subtitle: 'Define what students will learn',
                  )
                else
                  ...List.generate(_learningObjectives.length, (index) {
                    final objective = _learningObjectives[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.teal.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade700,
                              ),
                            ),
                          ),
                        ),
                        title: Text(objective.text),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, size: 20, color: Colors.red.shade400),
                          onPressed: () {
                            setState(() {
                              _learningObjectives.removeAt(index);
                              _hasChanges = true;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddObjectiveDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Objective'),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Colors.teal.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tip: Start with action verbs like "Understand", "Explain", "Apply", "Analyze", "Create"',
                          style: TextStyle(color: Colors.teal.shade700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Prerequisites
          EditorSection(
            title: 'Prerequisites',
            icon: Icons.playlist_add_check,
            iconColor: Colors.amber,
            subtitle: 'What should students know before this lesson?',
            trailing: Text(
              '${_prerequisites.length} prerequisites',
              style: TextStyle(
                color: Colors.amber.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_prerequisites.isEmpty)
                  _buildEmptyState(
                    icon: Icons.playlist_add_check,
                    title: 'No prerequisites set',
                    subtitle: 'Define what students should know first',
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_prerequisites.length, (index) {
                      return Chip(
                        label: Text(_prerequisites[index]),
                        onDeleted: () {
                          setState(() {
                            _prerequisites.removeAt(index);
                            _hasChanges = true;
                          });
                        },
                        deleteIconColor: Colors.red.shade400,
                        backgroundColor: Colors.amber.shade50,
                      );
                    }),
                  ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _showAddPrerequisiteDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Prerequisite'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with reading time
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.timer, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_estimatedReadingTime min read',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.text_fields, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                '$_wordCount words',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Learning Objectives
        if (_learningObjectives.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Learning Objectives',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(_learningObjectives.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.teal.shade700,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _learningObjectives[index].text,
                          style: TextStyle(color: Colors.teal.shade900),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],

        // Prerequisites
        if (_prerequisites.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Prerequisites',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _prerequisites.map((prereq) {
              return Chip(
                label: Text(prereq),
                avatar: Icon(Icons.school, size: 16, color: Colors.amber.shade700),
                backgroundColor: Colors.amber.shade50,
              );
            }).toList(),
          ),
        ],

        // Main Content
        const SizedBox(height: 24),
        Text(
          'Content',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: _isMarkdownMode
              ? _buildMarkdownPreview(_contentController.text)
              : Text(
                  _contentController.text.isEmpty
                      ? 'No content to preview'
                      : _contentController.text,
                  style: const TextStyle(height: 1.6),
                ),
        ),

        // Attachments
        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Attachments',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_attachments.length, (index) {
            final attachment = _attachments[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(attachment.fileIcon, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          attachment.fileName,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (attachment.description != null)
                          Text(
                            attachment.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download'),
                  ),
                ],
              ),
            );
          }),
        ],

        // External Links
        if (_externalLinks.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Additional Resources',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_externalLinks.length, (index) {
            final link = _externalLinks[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.link, color: Colors.purple.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          link.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        if (link.description != null)
                          Text(
                            link.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    link.openInNewTab ? Icons.open_in_new : Icons.arrow_forward,
                    size: 16,
                    color: Colors.purple.shade700,
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildMarkdownPreview(String content) {
    if (content.isEmpty) {
      return Text(
        'No content to preview',
        style: TextStyle(color: Colors.grey.shade500),
      );
    }

    // Simple markdown-like rendering (in a real app, use flutter_markdown package)
    final lines = content.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(2),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            line.substring(3),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            line.substring(4),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ));
      } else if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('  '),
              const Text('\u2022 ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(line.substring(2))),
            ],
          ),
        ));
      } else if (line.startsWith('> ')) {
        widgets.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.grey.shade400, width: 4)),
            color: Colors.grey.shade100,
          ),
          child: Text(
            line.substring(2),
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade700),
          ),
        ));
      } else if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else {
        widgets.add(Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(line, style: const TextStyle(height: 1.6)),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  // Dialog methods
  void _showAddAttachmentDialog() {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final descController = TextEditingController();
    String fileType = 'pdf';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.attach_file, color: Colors.orange),
            SizedBox(width: 12),
            Text('Add Attachment'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'File Name *',
                  hintText: 'e.g., Lecture Notes.pdf',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'File URL *',
                  hintText: 'https://example.com/file.pdf',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: fileType,
                decoration: const InputDecoration(
                  labelText: 'File Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'pdf', child: Text('PDF')),
                  DropdownMenuItem(value: 'doc', child: Text('Word Document')),
                  DropdownMenuItem(value: 'xls', child: Text('Excel Spreadsheet')),
                  DropdownMenuItem(value: 'ppt', child: Text('PowerPoint')),
                  DropdownMenuItem(value: 'image', child: Text('Image')),
                  DropdownMenuItem(value: 'zip', child: Text('Archive')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) => fileType = value ?? 'pdf',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Brief description of this file',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && urlController.text.isNotEmpty) {
                setState(() {
                  _attachments.add(Attachment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    fileName: nameController.text,
                    fileUrl: urlController.text,
                    fileType: fileType,
                    description: descController.text.isEmpty ? null : descController.text,
                  ));
                  _hasChanges = true;
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

  void _showEditAttachmentDialog(int index) {
    final attachment = _attachments[index];
    final nameController = TextEditingController(text: attachment.fileName);
    final urlController = TextEditingController(text: attachment.fileUrl);
    final descController = TextEditingController(text: attachment.description ?? '');
    String fileType = attachment.fileType;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.orange),
            SizedBox(width: 12),
            Text('Edit Attachment'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'File Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'File URL *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && urlController.text.isNotEmpty) {
                setState(() {
                  _attachments[index] = Attachment(
                    id: attachment.id,
                    fileName: nameController.text,
                    fileUrl: urlController.text,
                    fileType: fileType,
                    fileSizeBytes: attachment.fileSizeBytes,
                    description: descController.text.isEmpty ? null : descController.text,
                  );
                  _hasChanges = true;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAddLinkDialog() {
    final titleController = TextEditingController();
    final urlController = TextEditingController();
    final descController = TextEditingController();
    bool openInNewTab = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.link, color: Colors.purple),
              SizedBox(width: 12),
              Text('Add External Link'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    hintText: 'e.g., Official Documentation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL *',
                    hintText: 'https://example.com',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Brief description of this resource',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Open in new tab'),
                  subtitle: const Text('Recommended for external links'),
                  value: openInNewTab,
                  onChanged: (value) {
                    setDialogState(() => openInNewTab = value ?? true);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                  setState(() {
                    _externalLinks.add(ExternalLink(
                      title: titleController.text,
                      url: urlController.text,
                      description: descController.text.isEmpty ? null : descController.text,
                      openInNewTab: openInNewTab,
                    ));
                    _hasChanges = true;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditLinkDialog(int index) {
    final link = _externalLinks[index];
    final titleController = TextEditingController(text: link.title);
    final urlController = TextEditingController(text: link.url);
    final descController = TextEditingController(text: link.description ?? '');
    bool openInNewTab = link.openInNewTab;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit, color: Colors.purple),
              SizedBox(width: 12),
              Text('Edit External Link'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Open in new tab'),
                  value: openInNewTab,
                  onChanged: (value) {
                    setDialogState(() => openInNewTab = value ?? true);
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && urlController.text.isNotEmpty) {
                  setState(() {
                    _externalLinks[index] = ExternalLink(
                      title: titleController.text,
                      url: urlController.text,
                      description: descController.text.isEmpty ? null : descController.text,
                      openInNewTab: openInNewTab,
                    );
                    _hasChanges = true;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddObjectiveDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.emoji_objects, color: Colors.teal),
            SizedBox(width: 12),
            Text('Add Learning Objective'),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Objective *',
            hintText: 'e.g., Understand the fundamentals of...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          autofocus: true,
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
                  _learningObjectives.add(LearningObjective(text: controller.text));
                  _hasChanges = true;
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

  void _showAddPrerequisiteDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.playlist_add_check, color: Colors.amber),
            SizedBox(width: 12),
            Text('Add Prerequisite'),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Prerequisite *',
            hintText: 'e.g., Basic Python knowledge',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
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
                  _prerequisites.add(controller.text);
                  _hasChanges = true;
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
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);

      final request = TextContentRequest(
        content: _contentController.text,
        contentFormat: _contentFormat,
        estimatedReadingTime: _estimatedReadingTime > 0 ? _estimatedReadingTime : null,
        attachments: _attachments.isEmpty
            ? null
            : _attachments.map((a) => a.toJson()).toList(),
        externalLinks: _externalLinks.isEmpty
            ? null
            : _externalLinks.map((l) => l.toJson()).toList(),
      );

      widget.onSave(request);
      Navigator.pop(context);
    }
  }
}
