import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/document_model.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/skeleton_loader.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/cached_image.dart';
import '../providers/documents_provider.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(documentsProvider.notifier).fetchDocuments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(documentsLoadingProvider);
    final error = ref.watch(documentsErrorProvider);
    final documents = ref.watch(documentsListProvider);
    final folders = ref.watch(documentFoldersListProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('My Documents'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.insert_drive_file), text: 'All Documents'),
            Tab(icon: Icon(Icons.folder), text: 'Folders'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter',
          ),
        ],
      ),
      body: error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(documentsProvider.notifier).fetchDocuments();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : isLoading
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    SkeletonList(
                      itemCount: 6,
                      itemBuilder: (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: SkeletonListTile(hasLeading: true, hasTrailing: true),
                      ),
                    ),
                    SkeletonGrid(
                      crossAxisCount: 2,
                      itemCount: 6,
                      itemBuilder: (index) => const SkeletonCard(),
                    ),
                  ],
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDocumentsTab(documents),
                    _buildFoldersTab(folders),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadOptions,
        icon: const Icon(Icons.add),
        label: const Text('Upload'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDocumentsTab(List<Document> documents) {
    final filteredDocuments = documents.where((doc) {
      final matchesSearch =
          doc.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              doc.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
      final matchesCategory =
          _selectedCategory == null || doc.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search documents...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Filter Chips
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Chip(
                  label: Text(_getCategoryDisplayName(_selectedCategory!)),
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                ),
              ],
            ),
          ),

        // Documents List
        Expanded(
          child: filteredDocuments.isEmpty
              ? EmptyState(
                  icon: _searchQuery.isEmpty ? Icons.folder_open : Icons.search_off,
                  title: _searchQuery.isEmpty ? 'No Documents' : 'Not Found',
                  message: _searchQuery.isEmpty
                      ? 'No documents yet'
                      : 'No documents found',
                  actionLabel: _searchQuery.isEmpty ? 'Upload Document' : null,
                  onAction: _searchQuery.isEmpty ? _showUploadOptions : null,
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(documentsProvider.notifier).fetchDocuments();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document = filteredDocuments[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _DocumentCard(
                          document: document,
                          onTap: () {
                            context.go('/documents/${document.id}');
                          },
                          onMenuAction: (action) {
                            _handleDocumentAction(action, document);
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildFoldersTab(List<DocumentFolder> folders) {
    return folders.isEmpty
        ? const EmptyState(
            icon: Icons.folder_open,
            title: 'No Folders',
            message: 'No folders yet',
          )
        : RefreshIndicator(
            onRefresh: () async {
              await ref.read(documentsProvider.notifier).fetchDocuments();
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: folders.length,
              itemBuilder: (context, index) {
                final folder = folders[index];
                return _FolderCard(
                  folder: folder,
                  onTap: () {
                    _showFolderContents(folder);
                  },
                );
              },
            ),
          );
  }

  void _showFolderContents(DocumentFolder folder) {
    final allDocuments = ref.read(documentsListProvider);
    // Filter documents in this folder by category
    final folderDocuments = allDocuments.where((doc) => doc.category == folder.category).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.folder, color: AppColors.warning, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              folder.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${folder.documentCount} document${folder.documentCount != 1 ? 's' : ''}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Documents List
                Expanded(
                  child: folderDocuments.isEmpty
                      ? const EmptyState(
                          icon: Icons.folder_open,
                          title: 'Empty Folder',
                          message: 'This folder has no documents yet',
                        )
                      : ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: folderDocuments.length,
                          itemBuilder: (context, index) {
                            final document = folderDocuments[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _DocumentCard(
                                document: document,
                                onTap: () {
                                  Navigator.pop(context);
                                  context.go('/documents/${document.id}');
                                },
                                onMenuAction: (action) {
                                  _handleDocumentAction(action, document);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    final documents = ref.read(documentsListProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Category'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FilterOption(
                label: 'All Documents',
                isSelected: _selectedCategory == null,
                onTap: () {
                  setState(() {
                    _selectedCategory = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ..._getCategories(documents).map((category) {
                return _FilterOption(
                  label: _getCategoryDisplayName(category),
                  isSelected: _selectedCategory == category,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Title
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.upload, color: AppColors.primary),
                      const SizedBox(width: 12),
                      const Text(
                        'Upload Document',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Upload Widget
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: FileUploadWidget(
                      onFilesSelected: (files) {
                        // TODO: Implement actual upload to backend
                        // Example with Firebase Storage:
                        // for (final file in files) {
                        //   await uploadToFirebaseStorage(file);
                        // }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${files.length} file(s)'),
                            action: SnackBarAction(
                              label: 'Upload',
                              onPressed: () {
                                // Start upload process
                              },
                            ),
                          ),
                        );
                      },
                      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
                      maxSizeInMB: 10,
                      allowMultiple: true,
                      helpText: 'Supported: PDF, DOC, DOCX, JPG, PNG\nMax 10MB per file',
                    ),
                  ),
                ),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            // TODO: Implement camera capture with image_picker package
                            // Example: final image = await ImagePicker().pickImage(source: ImageSource.camera);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening camera...'),
                                backgroundColor: AppColors.info,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Camera'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            // TODO: Implement gallery picker with image_picker package
                            // Example: final images = await ImagePicker().pickMultiImage();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening gallery...'),
                                backgroundColor: AppColors.info,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.photo_library),
                          label: const Text('Gallery'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleDocumentAction(String action, Document document) {
    switch (action) {
      case 'download':
        // TODO: Implement download
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading ${document.name}...')),
        );
        break;
      case 'share':
        _showShareDialog(document);
        break;
      case 'delete':
        _showDeleteConfirmation(document);
        break;
    }
  }

  void _showShareDialog(Document document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share "${document.name}"',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.link, color: AppColors.info),
              ),
              title: const Text('Copy Link'),
              subtitle: const Text('Share via link'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement actual link generation with backend
                final link = 'https://flowedtech.com/documents/${document.id}';
                // Copy to clipboard would require clipboard package
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Link copied: $link'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.email, color: AppColors.primary),
              ),
              title: const Text('Share via Email'),
              subtitle: const Text('Send document link by email'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement email sharing with url_launcher
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sharing ${document.name} via email...'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.people, color: AppColors.success),
              ),
              title: const Text('Share with Users'),
              subtitle: const Text('Share with specific users in the app'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement user selection dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening user selection...'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document?'),
        content: Text('Are you sure you want to delete "${document.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref.read(documentsProvider.notifier).deleteDocument(document.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Document deleted'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to delete document: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  List<String> _getCategories(List<Document> documents) {
    return documents.map((d) => d.category).toSet().toList();
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'transcript':
        return 'Transcripts';
      case 'certificate':
        return 'Certificates';
      case 'id':
        return 'ID Documents';
      case 'essay':
        return 'Essays';
      case 'recommendation':
        return 'Recommendations';
      case 'resume':
        return 'Resumes';
      case 'portfolio':
        return 'Portfolios';
      default:
        return category;
    }
  }
}

class _DocumentCard extends StatelessWidget {
  final Document document;
  final VoidCallback onTap;
  final Function(String) onMenuAction;

  const _DocumentCard({
    required this.document,
    required this.onTap,
    required this.onMenuAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          // File Icon
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _getFileColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getFileIcon(),
                  color: _getFileColor(),
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  document.fileExtension,
                  style: TextStyle(
                    color: _getFileColor(),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        document.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (document.isVerified)
                      const Icon(
                        Icons.verified,
                        color: AppColors.success,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  document.categoryDisplayName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      document.formattedSize,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _formatDate(document.uploadedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Button
          PopupMenuButton<String>(
            onSelected: onMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download, size: 20),
                    SizedBox(width: 12),
                    Text('Download'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 12),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: AppColors.error),
                    SizedBox(width: 12),
                    Text('Delete', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon() {
    if (document.isPDF) return Icons.picture_as_pdf;
    if (document.isImage) return Icons.image;
    if (document.isDocument) return Icons.description;
    return Icons.insert_drive_file;
  }

  Color _getFileColor() {
    if (document.isPDF) return AppColors.error;
    if (document.isImage) return AppColors.success;
    if (document.isDocument) return AppColors.info;
    return AppColors.textSecondary;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _FolderCard extends StatelessWidget {
  final DocumentFolder folder;
  final VoidCallback onTap;

  const _FolderCard({
    required this.folder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.folder,
            color: AppColors.warning,
            size: 48,
          ),
          const Spacer(),
          Text(
            folder.name,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${folder.documentCount} document${folder.documentCount != 1 ? 's' : ''}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
