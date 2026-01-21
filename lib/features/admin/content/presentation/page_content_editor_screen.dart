import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/page_content_provider.dart';
import '../../../../core/models/page_content_model.dart';

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
  PageContentModel? _originalPage;
  String? _error;

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

  void _markChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _savePage() async {
    if (!_formKey.currentState!.validate()) return;

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

  Widget _buildForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
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
                                color: AppColors.warning.withOpacity(0.1),
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
            ),
            const SizedBox(height: 32),

            // Form fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column - Basic info
                Expanded(
                  flex: 1,
                  child: Container(
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
                  ),
                ),
                const SizedBox(width: 24),
                // Right column - Content JSON editor
                Expanded(
                  flex: 2,
                  child: Container(
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
                              'Content (JSON)',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _formatJson,
                              icon: const Icon(Icons.format_align_left, size: 16),
                              label: const Text('Format'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Edit the page content in JSON format. Structure varies by page type.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
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
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Help section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.2)),
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
                          'Each page type has a specific content structure. '
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'published':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'draft':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'archived':
        backgroundColor = AppColors.textSecondary.withOpacity(0.1);
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
