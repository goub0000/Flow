// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/notes_widgets.dart';

/// Note Editor Screen
///
/// Full-featured note editor with:
/// - Rich text editing
/// - Category selection
/// - Tag management
/// - Priority setting
/// - Auto-save functionality
/// - Formatting toolbar
///
/// Backend Integration TODO:
/// ```dart
/// // Auto-save implementation
/// import 'dart:async';
///
/// class NoteEditorService {
///   Timer? _autoSaveTimer;
///   final NotesRepository _repository;
///
///   void startAutoSave(NoteModel note, Function(NoteModel) onSave) {
///     _autoSaveTimer?.cancel();
///     _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
///       onSave(note);
///       _repository.updateNote(note);
///     });
///   }
///
///   void stopAutoSave() {
///     _autoSaveTimer?.cancel();
///   }
/// }
///
/// // Rich text editor integration
/// import 'package:flutter_quill/flutter_quill.dart';
///
/// class RichTextEditor extends StatefulWidget {
///   final String? initialContent;
///   final ValueChanged<String> onChanged;
///
///   @override
///   State<RichTextEditor> createState() => _RichTextEditorState();
/// }
///
/// class _RichTextEditorState extends State<RichTextEditor> {
///   late QuillController _controller;
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = QuillController.basic();
///     if (widget.initialContent != null) {
///       // Load existing content
///     }
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         QuillToolbar.simple(controller: _controller),
///         Expanded(
///           child: QuillEditor.basic(
///             controller: _controller,
///             onTextChanged: () {
///               widget.onChanged(_controller.document.toPlainText());
///             },
///           ),
///         ),
///       ],
///     );
///   }
/// }
///
/// // File attachments
/// import 'package:file_picker/file_picker.dart';
/// import 'package:supabase_flutter/supabase_flutter.dart';
///
/// class AttachmentService {
///   Future<String> uploadAttachment(String filePath, String noteId) async {
///     final file = File(filePath);
///     final fileName = path.basename(filePath);
///     final storagePath = 'notes/$noteId/$fileName';
///
///     await Supabase.instance.client.storage
///         .from('attachments')
///         .upload(storagePath, file);
///     return Supabase.instance.client.storage
///         .from('attachments')
///         .getPublicUrl(storagePath);
///   }
///
///   Future<List<String>> pickFiles() async {
///     final result = await FilePicker.platform.pickFiles(
///       allowMultiple: true,
///       type: FileType.custom,
///       allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'jpg', 'png'],
///     );
///
///     return result?.paths.whereType<String>().toList() ?? [];
///   }
/// }
/// ```

class NoteEditorScreen extends StatefulWidget {
  final NoteModel? note;

  const NoteEditorScreen({
    super.key,
    this.note,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _tagController;

  List<NoteCategory> _categories = [];
  String? _selectedCategoryId;
  List<String> _tags = [];
  NotePriority _priority = NotePriority.low;
  bool _isFavorite = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _tagController = TextEditingController();

    if (widget.note != null) {
      _selectedCategoryId = widget.note!.categoryId;
      _tags = List.from(widget.note!.tags);
      _priority = widget.note!.priority;
      _isFavorite = widget.note!.isFavorite;
    }

    _generateMockCategories();

    // Listen for changes
    _titleController.addListener(_markAsUnsaved);
    _contentController.addListener(_markAsUnsaved);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _generateMockCategories() {
    _categories = [
      const NoteCategory(
        id: '1',
        name: 'Personal',
        icon: Icons.person,
        color: Colors.blue,
      ),
      const NoteCategory(
        id: '2',
        name: 'Study',
        icon: Icons.school,
        color: Colors.green,
      ),
      const NoteCategory(
        id: '3',
        name: 'Work',
        icon: Icons.work,
        color: Colors.orange,
      ),
      const NoteCategory(
        id: '4',
        name: 'Ideas',
        icon: Icons.lightbulb,
        color: Colors.amber,
      ),
    ];
  }

  void _markAsUnsaved() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.sharedNotesUnsavedChangesTitle),
        content: Text(context.l10n.sharedNotesUnsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(context.l10n.sharedNotesCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              context.l10n.sharedNotesDiscard,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.sharedNotesPleaseEnterTitle),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // TODO: Save to backend
    final now = DateTime.now();
    final savedNote = NoteModel(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      categoryId: _selectedCategoryId,
      tags: _tags,
      priority: _priority,
      isFavorite: _isFavorite,
      isPinned: widget.note?.isPinned ?? false,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );

    setState(() {
      _hasUnsavedChanges = false;
    });

    Navigator.pop(context, savedNote);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved successfully'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
        _markAsUnsaved();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _markAsUnsaved();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.note != null;

    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            tooltip: 'Back',
          ),
          title: Text(isEditing ? 'Edit Note' : 'New Note'),
          actions: [
            IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? AppColors.error : null,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                  _markAsUnsaved();
                });
              },
              tooltip: _isFavorite ? 'Remove from favorites' : 'Add to favorites',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveNote,
              tooltip: 'Save',
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Note Title',
                border: InputBorder.none,
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 8),

            // Metadata row
            Wrap(
              spacing: 12,
              children: [
                // Priority
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_priority.icon, size: 16),
                      const SizedBox(width: 4),
                      Text(_priority.displayName),
                    ],
                  ),
                  selected: false,
                  onSelected: (_) => _showPriorityDialog(),
                  backgroundColor: _priority.color.withValues(alpha: 0.1),
                  labelStyle: TextStyle(color: _priority.color),
                  side: BorderSide(color: _priority.color),
                ),

                // Category
                if (_selectedCategoryId != null) ...[
                  ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _categories
                              .firstWhere((c) => c.id == _selectedCategoryId)
                              .icon,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _categories
                              .firstWhere((c) => c.id == _selectedCategoryId)
                              .name,
                        ),
                      ],
                    ),
                    selected: false,
                    onSelected: (_) => _showCategoryDialog(),
                  ),
                ] else ...[
                  ActionChip(
                    label: const Text('Add Category'),
                    avatar: const Icon(Icons.add, size: 16),
                    onPressed: _showCategoryDialog,
                  ),
                ],
              ],
            ),
            const Divider(height: 32),

            // Content
            TextField(
              controller: _contentController,
              style: theme.textTheme.bodyLarge,
              decoration: const InputDecoration(
                hintText: 'Start typing your note...',
                border: InputBorder.none,
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),

            // Tags Section
            Text(
              'Tags',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Existing tags
            if (_tags.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return TagChip(
                    tag: tag,
                    onDelete: () => _removeTag(tag),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
            ],

            // Add tag input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Add tag...',
                      prefixIcon: const Icon(Icons.tag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTag(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _addTag,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Formatting toolbar
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.format_bold),
                      onPressed: () {
                        // TODO: Apply bold formatting
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rich text formatting coming soon'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      tooltip: 'Bold',
                    ),
                    IconButton(
                      icon: const Icon(Icons.format_italic),
                      onPressed: () {
                        // TODO: Apply italic formatting
                      },
                      tooltip: 'Italic',
                    ),
                    IconButton(
                      icon: const Icon(Icons.format_underlined),
                      onPressed: () {
                        // TODO: Apply underline formatting
                      },
                      tooltip: 'Underline',
                    ),
                    const VerticalDivider(),
                    IconButton(
                      icon: const Icon(Icons.format_list_bulleted),
                      onPressed: () {
                        // TODO: Insert bullet list
                      },
                      tooltip: 'Bullet List',
                    ),
                    IconButton(
                      icon: const Icon(Icons.format_list_numbered),
                      onPressed: () {
                        // TODO: Insert numbered list
                      },
                      tooltip: 'Numbered List',
                    ),
                    const VerticalDivider(),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        // TODO: Add attachment
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('File attachments coming soon'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      tooltip: 'Attach File',
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: () {
                        // TODO: Insert image
                      },
                      tooltip: 'Insert Image',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showPriorityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotePriority.values.map((priority) {
            return RadioListTile<NotePriority>(
              title: Row(
                children: [
                  Icon(priority.icon, color: priority.color, size: 20),
                  const SizedBox(width: 12),
                  Text(priority.displayName),
                ],
              ),
              value: priority,
              groupValue: _priority,
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                  _markAsUnsaved();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // No category option
            RadioListTile<String?>(
              title: const Text('No Category'),
              value: null,
              groupValue: _selectedCategoryId,
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                  _markAsUnsaved();
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Categories
            ..._categories.map((category) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Icon(category.icon, color: category.color, size: 20),
                    const SizedBox(width: 12),
                    Text(category.name),
                  ],
                ),
                value: category.id,
                groupValue: _selectedCategoryId,
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                    _markAsUnsaved();
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Create new category
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create category coming soon')),
              );
            },
            child: const Text('Create New'),
          ),
        ],
      ),
    );
  }
}
