import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';
import 'widgets/rich_text_content_editor.dart';

/// Enum for editor modes
enum EditorMode { visual, rawJson }

/// Admin screen for editing a single page's content
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

  // Section-based content
  List<Map<String, dynamic>> _sections = [];

  // Dynamically detect if page has sections based on content structure
  bool _hasSectionsInContent = false;

  bool get _hasSections => _hasSectionsInContent;

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

        // Dynamically detect if content has sections
        _hasSectionsInContent = page.content.containsKey('sections') &&
            page.content['sections'] is List;

        // Initialize sections if this page has sections
        if (_hasSections) {
          _initializeSections(page.content);
        }

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

  void _initializeSections(Map<String, dynamic> content) {
    final sections = content['sections'];
    if (sections is List) {
      _sections = sections.map((s) {
        if (s is Map<String, dynamic>) {
          return ContentConverter.convertSectionToQuillFormat(s);
        }
        return <String, dynamic>{};
      }).toList();
    } else {
      _sections = [];
    }
  }

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _syncContentFromSections() {
    // Build content JSON from sections
    final content = Map<String, dynamic>.from(
      json.decode(_contentController.text) as Map<String, dynamic>,
    );
    content['sections'] = _sections;
    _contentController.text = const JsonEncoder.withIndent('  ').convert(content);
  }

  void _syncSectionsFromContent() {
    try {
      final content = json.decode(_contentController.text) as Map<String, dynamic>;
      _initializeSections(content);
    } catch (e) {
      // Invalid JSON, keep current sections
    }
  }

  void _switchToMode(EditorMode mode) {
    if (_editorMode == mode) return;

    if (_editorMode == EditorMode.visual && mode == EditorMode.rawJson) {
      // Switching from visual to raw - sync sections to JSON
      if (_hasSections) {
        _syncContentFromSections();
      }
    } else if (_editorMode == EditorMode.rawJson && mode == EditorMode.visual) {
      // Switching from raw to visual - sync JSON to sections
      if (_hasSections) {
        _syncSectionsFromContent();
      }
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
          content: const Text('At least one section is required'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Section'),
        content: const Text('Are you sure you want to remove this section?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Remove'),
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

  Future<void> _savePage() async {
    if (!_formKey.currentState!.validate()) return;

    // Sync content based on current mode
    if (_editorMode == EditorMode.visual && _hasSections) {
      _syncContentFromSections();
    }

    // Parse content JSON
    Map<String, dynamic>? contentJson;
    try {
      contentJson = json.decode(_contentController.text) as Map<String, dynamic>;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Invalid JSON in content field'),
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
        // Refresh the admin pages list
        ref.invalidate(adminPagesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Page saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to save page'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _publishPage() async {
    setState(() {
      _isSaving = true;
    });

    final service = ref.read(pageContentServiceProvider);
    final response = await service.publishPage(widget.pageSlug);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (response.success) {
        _originalPage = response.data;
        ref.invalidate(adminPagesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Page published successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        setState(() {}); // Refresh UI
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to publish page'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _unpublishPage() async {
    setState(() {
      _isSaving = true;
    });

    final service = ref.read(pageContentServiceProvider);
    final response = await service.unpublishPage(widget.pageSlug);

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (response.success) {
        _originalPage = response.data;
        ref.invalidate(adminPagesProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Page unpublished (set to draft)'),
            backgroundColor: AppColors.warning,
          ),
        );
        setState(() {}); // Refresh UI
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to unpublish page'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
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
          if (shouldPop && mounted) {
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
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading page',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.go('/admin/pages'),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to List'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _loadPage,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
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
        // Preview header
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.info.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.visibility, color: AppColors.info),
              const SizedBox(width: 12),
              Text(
                'Preview Mode',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => setState(() => _isPreviewMode = false),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Back to Editor'),
              ),
            ],
          ),
        ),
        // Preview content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titleController.text,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_subtitleController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _subtitleController.text,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                if (_hasSections)
                  ..._sections.asMap().entries.map((entry) {
                    final section = entry.value;
                    final title = section['title']?.toString() ?? '';
                    final content = section['content'];
                    final plainText = ContentConverter.deltaToPlainText(
                      content is Map<String, dynamic> ? content : null,
                    );

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (title.isNotEmpty) const SizedBox(height: 12),
                          Text(
                            plainText,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                          ),
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
            // Header
            _buildHeader(theme),
            const SizedBox(height: 32),

            // Form fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Basic info
                Expanded(
                  flex: 1,
                  child: _buildBasicInfoCard(theme),
                ),
                const SizedBox(width: 24),
                // Right column - Content editor
                Expanded(
                  flex: 2,
                  child: _buildContentEditorCard(theme),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Help section
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
              if (shouldPop && mounted) {
                context.go('/admin/pages');
              }
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
              Text(
                'Edit Page: ${_formatSlug(widget.pageSlug)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Slug: ${widget.pageSlug}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildStatusBadge(_originalPage?.status ?? 'draft'),
                  if (_hasChanges) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'UNSAVED',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        // Action buttons
        Row(
          children: [
            // Preview button
            OutlinedButton.icon(
              onPressed: () => setState(() => _isPreviewMode = true),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text('Preview'),
            ),
            const SizedBox(width: 12),
            if (_originalPage?.isPublished == true)
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _unpublishPage,
                icon: const Icon(Icons.visibility_off, size: 18),
                label: const Text('Unpublish'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.warning,
                ),
              )
            else
              OutlinedButton.icon(
                onPressed: _isSaving ? null : _publishPage,
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text('Publish'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                ),
              ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _isSaving ? null : _savePage,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save, size: 18),
              label: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBasicInfoCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // Title
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Page Title',
              hintText: 'Enter the page title',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
            onChanged: (_) => _markChanged(),
          ),
          const SizedBox(height: 20),
          // Subtitle
          TextFormField(
            controller: _subtitleController,
            decoration: const InputDecoration(
              labelText: 'Subtitle (optional)',
              hintText: 'Enter a subtitle or tagline',
            ),
            maxLines: 2,
            onChanged: (_) => _markChanged(),
          ),
          const SizedBox(height: 20),
          // Meta description
          TextFormField(
            controller: _metaDescriptionController,
            decoration: const InputDecoration(
              labelText: 'Meta Description (SEO)',
              hintText: 'Brief description for search engines',
            ),
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Content',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Editor mode toggle
              if (_hasSections) _buildEditorModeToggle(theme),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _editorMode == EditorMode.visual
                ? 'Use the rich text editor to format your content.'
                : 'Edit the page content in JSON format. Structure varies by page type.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          if (_editorMode == EditorMode.visual && _hasSections)
            _buildVisualEditor(theme)
          else
            _buildRawJsonEditor(theme),
        ],
      ),
    );
  }

  Widget _buildEditorModeToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildModeButton(
            icon: Icons.edit_note,
            label: 'Visual',
            isSelected: _editorMode == EditorMode.visual,
            onTap: () => _switchToMode(EditorMode.visual),
          ),
          _buildModeButton(
            icon: Icons.code,
            label: 'Raw JSON',
            isSelected: _editorMode == EditorMode.rawJson,
            onTap: () => _switchToMode(EditorMode.rawJson),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sections
        ..._sections.asMap().entries.map((entry) {
          final index = entry.key;
          final section = entry.value;
          return SectionEditor(
            key: ValueKey('section_$index'),
            index: index,
            initialTitle: section['title']?.toString() ?? '',
            initialContent: section['content'] is Map<String, dynamic>
                ? section['content'] as Map<String, dynamic>
                : null,
            onChanged: (data) => _updateSection(index, data),
            onRemove: () => _removeSection(index),
            canRemove: _sections.length > 1,
          );
        }),

        // Add section button
        Center(
          child: OutlinedButton.icon(
            onPressed: _addSection,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Section'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRawJsonEditor(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: _formatJson,
              icon: const Icon(Icons.format_align_left, size: 16),
              label: const Text('Format'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _contentController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          maxLines: 25,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Content is required';
            }
            try {
              json.decode(value);
            } catch (e) {
              return 'Invalid JSON format';
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
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Structure Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _hasSections
                      ? 'This page uses a section-based structure. '
                          'Use the Visual Editor to easily format text with bold, italic, headings, and lists. '
                          'Switch to Raw JSON mode for advanced editing.'
                      : 'Each page type has a specific content structure. '
                          'Policy pages use "sections" array with title/content. '
                          'Careers page uses "benefits" and "positions" arrays. '
                          'Check the API documentation for detailed schema.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'draft':
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'archived':
        backgroundColor = AppColors.textSecondary.withValues(alpha: 0.1);
        textColor = AppColors.textSecondary;
        break;
      default:
        backgroundColor = AppColors.border;
        textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatSlug(String slug) {
    return slug
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _formatJson() {
    try {
      final parsed = json.decode(_contentController.text);
      final formatted = const JsonEncoder.withIndent('  ').convert(parsed);
      _contentController.text = formatted;
      _markChanged();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cannot format: Invalid JSON'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
