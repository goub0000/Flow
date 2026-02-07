import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import 'widgets/rich_text_content_editor.dart';

/// Enum for editor modes
enum EditorMode { visual, rawJson }

/// Admin screen for editing a single page's content with rich text support
class PageContentEditorScreen extends ConsumerStatefulWidget {
  final String pageSlug;

  const PageContentEditorScreen({
    required this.pageSlug,
    super.key,
  });

  @override
  ConsumerState<PageContentEditorScreen> createState() => _PageContentEditorScreenState();
}

class _PageContentEditorScreenState extends ConsumerState<PageContentEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _metaDescriptionController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isLoading = false;
  bool _isSaving = false;
  bool _hasChanges = false;
  bool _isPreviewMode = false;
  PageContentModel? _originalPage;
  String? _error;
  EditorMode _editorMode = EditorMode.visual;

  // Content data for visual editing
  Map<String, dynamic> _contentData = {};
  List<Map<String, dynamic>> _sections = [];

  // Rich text fields mapped by field name
  Map<String, Map<String, dynamic>> _richTextFields = {};

  // Fields that should use rich text editor
  static const _richTextFieldNames = ['intro', 'story', 'content', 'description'];

  // Detect content structure type
  bool get _hasSections => _contentData.containsKey('sections') && _contentData['sections'] is List;
  bool get _hasRichTextFields => _richTextFieldNames.any((f) => _contentData.containsKey(f) && _contentData[f] is String);

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _metaDescriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadPage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final service = ref.read(pageContentServiceProvider);
    final response = await service.getPageForAdmin(widget.pageSlug);

    if (mounted) {
      if (response.success && response.data != null) {
        final page = response.data!;
        _originalPage = page;
        _titleController.text = page.title;
        _subtitleController.text = page.subtitle ?? '';
        _metaDescriptionController.text = page.metaDescription ?? '';
        _contentController.text = const JsonEncoder.withIndent('  ').convert(page.content);
        _contentData = Map<String, dynamic>.from(page.content);

        // Initialize based on content structure
        _initializeContent();

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _error = response.message ?? 'Failed to load page';
        });
      }
    }
  }

  void _initializeContent() {
    // Initialize sections if present
    if (_hasSections) {
      final sections = _contentData['sections'];
      if (sections is List) {
        _sections = sections.map((s) {
          if (s is Map<String, dynamic>) {
            return ContentConverter.convertSectionToQuillFormat(s);
          }
          return <String, dynamic>{};
        }).toList();
      }
    }

    // Initialize rich text fields
    _richTextFields = {};
    for (final fieldName in _richTextFieldNames) {
      if (_contentData.containsKey(fieldName)) {
        final value = _contentData[fieldName];
        if (value is String) {
          _richTextFields[fieldName] = ContentConverter.plainTextToDelta(value);
        } else if (value is Map<String, dynamic> && ContentConverter.isQuillDelta(value)) {
          _richTextFields[fieldName] = value;
        }
      }
    }
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _syncContentFromVisual() {
    // Build content JSON from visual editor data
    final content = Map<String, dynamic>.from(_contentData);

    // Sync sections
    if (_hasSections) {
      content['sections'] = _sections;
    }

    // Sync rich text fields
    for (final entry in _richTextFields.entries) {
      content[entry.key] = entry.value;
    }

    _contentController.text = const JsonEncoder.withIndent('  ').convert(content);
  }

  void _syncVisualFromContent() {
    try {
      _contentData = Map<String, dynamic>.from(
        json.decode(_contentController.text) as Map<String, dynamic>,
      );
      _initializeContent();
    } catch (e) {
      // Invalid JSON, keep current data
    }
  }

  void _switchToMode(EditorMode mode) {
    if (_editorMode == mode) return;

    if (_editorMode == EditorMode.visual && mode == EditorMode.rawJson) {
      _syncContentFromVisual();
    } else if (_editorMode == EditorMode.rawJson && mode == EditorMode.visual) {
      _syncVisualFromContent();
    }

    setState(() {
      _editorMode = mode;
    });
  }

  void _addSection() {
    setState(() {
      _sections.add({
        'title': '',
        'content': ContentConverter.plainTextToDelta(''),
      });
      _hasChanges = true;
    });
  }

  void _removeSection(int index) {
    if (_sections.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminContentAtLeastOneSection),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminContentRemoveSection),
        content: Text(context.l10n.adminContentConfirmRemoveSection),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminContentCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _sections.removeAt(index);
                _hasChanges = true;
              });
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.adminContentRemove),
          ),
        ],
      ),
    );
  }

  void _updateSection(int index, Map<String, dynamic> sectionData) {
    setState(() {
      _sections[index] = sectionData;
      _hasChanges = true;
    });
  }

  void _updateRichTextField(String fieldName, Map<String, dynamic> delta) {
    setState(() {
      _richTextFields[fieldName] = delta;
      _hasChanges = true;
    });
  }

  Future<void> _savePage() async {
    if (!_formKey.currentState!.validate()) return;

    // Sync content based on current mode
    if (_editorMode == EditorMode.visual) {
      _syncContentFromVisual();
    }

    // Parse content JSON
    Map<String, dynamic>? contentJson;
    try {
      contentJson = json.decode(_contentController.text) as Map<String, dynamic>;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminContentInvalidJson),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final service = ref.read(pageContentServiceProvider);
    final response = await service.updatePage(
      widget.pageSlug,
      title: _titleController.text,
      subtitle: _subtitleController.text.isEmpty ? null : _subtitleController.text,
      content: contentJson,
      metaDescription: _metaDescriptionController.text.isEmpty ? null : _metaDescriptionController.text,
    );

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (response.success) {
        _hasChanges = false;
        ref.invalidate(adminPagesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminContentPageSavedSuccessfully),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? context.l10n.adminContentFailedToSavePage),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _publishPage() async {
    setState(() => _isSaving = true);

    final service = ref.read(pageContentServiceProvider);
    final response = await service.publishPage(widget.pageSlug);

    if (mounted) {
      setState(() => _isSaving = false);

      if (response.success) {
        _originalPage = response.data;
        ref.invalidate(adminPagesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adminContentPagePublishedSuccessfully), backgroundColor: AppColors.success),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? context.l10n.adminContentFailedToPublishPage), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _unpublishPage() async {
    setState(() => _isSaving = true);

    final service = ref.read(pageContentServiceProvider);
    final response = await service.unpublishPage(widget.pageSlug);

    if (mounted) {
      setState(() => _isSaving = false);

      if (response.success) {
        _originalPage = response.data;
        ref.invalidate(adminPagesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adminContentPageUnpublished), backgroundColor: AppColors.warning),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? context.l10n.adminContentFailedToUnpublishPage), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminContentUnsavedChanges),
        content: Text(context.l10n.adminContentDiscardChanges),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.adminContentCancel)),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.adminContentDiscard),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _hasChanges) {
          final shouldPop = await _onWillPop();
          if (!context.mounted) return;
          if (shouldPop) {
            context.go('/admin/pages');
          }
        }
      },
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _buildErrorState()
                : _isPreviewMode
                    ? _buildPreviewMode(theme)
                    : _buildForm(theme),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(context.l10n.adminContentErrorLoadingPage, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.error)),
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(onPressed: () => context.go('/admin/pages'), icon: const Icon(Icons.arrow_back), label: Text(context.l10n.adminContentBack)),
                const SizedBox(width: 16),
                ElevatedButton.icon(onPressed: _loadPage, icon: const Icon(Icons.refresh), label: Text(context.l10n.adminContentRetry)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewMode(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.info.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.visibility, color: AppColors.info),
              const SizedBox(width: 12),
              Text(context.l10n.adminContentPreviewMode, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: AppColors.info)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isPreviewMode = false),
                icon: const Icon(Icons.edit, size: 18),
                label: Text(context.l10n.adminContentBackToEditor),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_titleController.text, style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
                if (_subtitleController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_subtitleController.text, style: theme.textTheme.titleLarge?.copyWith(color: AppColors.textSecondary)),
                ],
                const SizedBox(height: 32),
                // Preview rich text fields
                for (final entry in _richTextFields.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      ContentConverter.deltaToPlainText(entry.value),
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                    ),
                  ),
                // Preview sections
                if (_hasSections)
                  ..._sections.map((section) {
                    final title = section['title']?.toString() ?? '';
                    final content = section['content'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty) Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                          if (title.isNotEmpty) const SizedBox(height: 12),
                          Text(ContentConverter.deltaToPlainText(content is Map<String, dynamic> ? content : null), style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: _buildBasicInfoCard(theme)),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: _buildContentEditorCard(theme)),
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (_hasChanges) {
              final shouldPop = await _onWillPop();
              if (shouldPop && mounted) context.go('/admin/pages');
            } else {
              context.go('/admin/pages');
            }
          },
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.adminContentEditPageTitle(_formatSlug(widget.pageSlug)), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(context.l10n.adminContentSlug(widget.pageSlug), style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(width: 16),
                  _buildStatusBadge(_originalPage?.status ?? 'draft'),
                  if (_hasChanges) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(context.l10n.adminContentUnsaved, style: TextStyle(color: AppColors.warning, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            OutlinedButton.icon(onPressed: () => setState(() => _isPreviewMode = true), icon: const Icon(Icons.visibility, size: 18), label: Text(context.l10n.adminContentPreview)),
            const SizedBox(width: 12),
            if (_originalPage?.isPublished == true)
              OutlinedButton.icon(onPressed: _isSaving ? null : _unpublishPage, icon: const Icon(Icons.visibility_off, size: 18), label: Text(context.l10n.adminContentUnpublish), style: OutlinedButton.styleFrom(foregroundColor: AppColors.warning))
            else
              OutlinedButton.icon(onPressed: _isSaving ? null : _publishPage, icon: const Icon(Icons.visibility, size: 18), label: Text(context.l10n.adminContentPublish), style: OutlinedButton.styleFrom(foregroundColor: AppColors.success)),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _savePage,
              icon: _isSaving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save, size: 18),
              label: Text(_isSaving ? context.l10n.adminContentSaving : context.l10n.adminContentSave),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.adminContentBasicInformation, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: context.l10n.adminContentPageTitle, hintText: context.l10n.adminContentEnterPageTitle),
            validator: (value) => (value == null || value.isEmpty) ? context.l10n.adminContentTitleRequired : null,
            onChanged: (_) => _markChanged(),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _subtitleController,
            decoration: InputDecoration(labelText: context.l10n.adminContentSubtitleOptional, hintText: context.l10n.adminContentEnterSubtitle),
            maxLines: 2,
            onChanged: (_) => _markChanged(),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _metaDescriptionController,
            decoration: InputDecoration(labelText: context.l10n.adminContentMetaDescription, hintText: context.l10n.adminContentBriefDescription),
            maxLines: 3,
            maxLength: 300,
            onChanged: (_) => _markChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildContentEditorCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.adminContentContent, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              _buildEditorModeToggle(theme),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _editorMode == EditorMode.visual
                ? context.l10n.adminContentUseRichTextEditor
                : context.l10n.adminContentEditJsonFormat,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          if (_editorMode == EditorMode.visual)
            _buildVisualEditor(theme)
          else
            _buildRawJsonEditor(theme),
        ],
      ),
    );
  }

  Widget _buildEditorModeToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(icon: Icons.edit_note, label: context.l10n.adminContentVisual, isSelected: _editorMode == EditorMode.visual, onTap: () => _switchToMode(EditorMode.visual)),
          _buildModeButton(icon: Icons.code, label: context.l10n.adminContentRawJson, isSelected: _editorMode == EditorMode.rawJson, onTap: () => _switchToMode(EditorMode.rawJson)),
        ],
      ),
    );
  }

  Widget _buildModeButton({required IconData icon, required String label, required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null, borderRadius: BorderRadius.circular(7)),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? AppColors.primary : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rich text fields (intro, story, etc.)
        if (_hasRichTextFields || _richTextFields.isNotEmpty)
          ..._buildRichTextFieldEditors(theme),

        // Sections
        if (_hasSections) ...[
          if (_richTextFields.isNotEmpty) const Divider(height: 32),
          Text(context.l10n.adminContentSections, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ..._sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return SectionEditor(
              key: ValueKey('section_$index'),
              index: index,
              initialTitle: section['title']?.toString() ?? '',
              initialContent: section['content'] is Map<String, dynamic> ? section['content'] as Map<String, dynamic> : null,
              onChanged: (data) => _updateSection(index, data),
              onRemove: () => _removeSection(index),
              canRemove: _sections.length > 1,
            );
          }),
          Center(
            child: OutlinedButton.icon(
              onPressed: _addSection,
              icon: const Icon(Icons.add, size: 18),
              label: Text(context.l10n.adminContentAddSection),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
        ],

        // Other content fields (non-rich text)
        if (!_hasSections && _richTextFields.isEmpty)
          _buildGenericFieldsEditor(theme),
      ],
    );
  }

  List<Widget> _buildRichTextFieldEditors(ThemeData theme) {
    final widgets = <Widget>[];

    // Find and display rich text fields from content
    for (final fieldName in _richTextFieldNames) {
      if (_contentData.containsKey(fieldName)) {
        final value = _contentData[fieldName];
        Map<String, dynamic>? initialContent;

        if (value is String) {
          initialContent = _richTextFields[fieldName] ?? ContentConverter.plainTextToDelta(value);
        } else if (value is Map<String, dynamic>) {
          initialContent = _richTextFields[fieldName] ?? value;
        }

        if (initialContent != null || value is String) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: RichTextContentEditor(
                key: ValueKey('rich_$fieldName'),
                label: _formatFieldName(fieldName),
                initialContent: initialContent,
                onChanged: (delta) => _updateRichTextField(fieldName, delta),
                hintText: 'Enter ${_formatFieldName(fieldName).toLowerCase()}...',
                height: 200,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  Widget _buildGenericFieldsEditor(ThemeData theme) {
    // For pages without sections or standard rich text fields,
    // show editable text fields for string values
    final stringFields = _contentData.entries.where((e) => e.value is String).toList();

    if (stringFields.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(Icons.data_object, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              context.l10n.adminContentComplexStructure,
              style: theme.textTheme.titleSmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.adminContentUseRawJsonMode,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stringFields.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RichTextContentEditor(
            key: ValueKey('field_${entry.key}'),
            label: _formatFieldName(entry.key),
            initialContent: _richTextFields[entry.key] ?? ContentConverter.plainTextToDelta(entry.value as String),
            onChanged: (delta) => _updateRichTextField(entry.key, delta),
            hintText: 'Enter ${_formatFieldName(entry.key).toLowerCase()}...',
            height: 150,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRawJsonEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(onPressed: _formatJson, icon: const Icon(Icons.format_align_left, size: 16), label: Text(context.l10n.adminContentFormat)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentController,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.all(16)),
          maxLines: 25,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
          validator: (value) {
            if (value == null || value.isEmpty) return context.l10n.adminContentContentRequired;
            try {
              json.decode(value);
            } catch (e) {
              return context.l10n.adminContentInvalidJsonFormat;
            }
            return null;
          },
          onChanged: (_) => _markChanged(),
        ),
      ],
    );
  }

  Widget _buildHelpSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.info, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.adminContentRichTextEditor, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.info)),
                const SizedBox(height: 4),
                Text(
                  context.l10n.adminContentVisualEditorHelp,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final colors = {
      'published': (AppColors.success.withValues(alpha: 0.1), AppColors.success),
      'draft': (AppColors.warning.withValues(alpha: 0.1), AppColors.warning),
      'archived': (AppColors.textSecondary.withValues(alpha: 0.1), AppColors.textSecondary),
    };
    final (bg, fg) = colors[status.toLowerCase()] ?? (AppColors.border, AppColors.textSecondary);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(status.toUpperCase(), style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }

  String _formatSlug(String slug) => slug.split('-').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');

  String _formatFieldName(String name) => name.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');

  void _formatJson() {
    try {
      final parsed = json.decode(_contentController.text);
      _contentController.text = const JsonEncoder.withIndent('  ').convert(parsed);
      _markChanged();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.adminContentCannotFormatInvalidJson), backgroundColor: AppColors.error),
      );
    }
  }
}
