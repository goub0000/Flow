import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../widgets/resource_widgets.dart';

/// Resources Library Screen
///
/// Main screen for browsing and managing course resources.
/// Features:
/// - Search and filter resources
/// - Category-based organization
/// - Download management
/// - Bookmarking
/// - Sorting options
///
/// Backend Integration TODO:
/// - Fetch resources from backend
/// - Implement search with debouncing
/// - Handle download queue
/// - Sync bookmarks across devices

class ResourcesLibraryScreen extends StatefulWidget {
  final String? courseId;
  final String? lessonId;

  const ResourcesLibraryScreen({
    super.key,
    this.courseId,
    this.lessonId,
  });

  @override
  State<ResourcesLibraryScreen> createState() => _ResourcesLibraryScreenState();
}

class _ResourcesLibraryScreenState extends State<ResourcesLibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  ResourceType? _selectedType;
  final Map<String, double> _downloadProgress = {};
  late List<ResourceModel> _resources;
  final List<String> _categories = [
    'Lecture Notes',
    'Assignments',
    'Reading Materials',
    'Code Examples',
    'Practice Problems',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateMockResources();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockResources() {
    _resources = [
      ResourceModel(
        id: '1',
        title: 'Introduction to Flutter - Lecture Slides',
        description: 'Comprehensive slides covering Flutter basics and widgets',
        type: ResourceType.presentation,
        url: 'https://example.com/flutter-intro.pptx',
        fileSize: 2 * 1024 * 1024, // 2 MB
        category: 'Lecture Notes',
        tags: ['flutter', 'basics', 'widgets'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 2)),
        courseId: widget.courseId,
        downloadCount: 145,
        viewCount: 320,
      ),
      ResourceModel(
        id: '2',
        title: 'Flutter State Management Tutorial',
        description: 'Video tutorial on Riverpod and Provider',
        type: ResourceType.video,
        url: 'https://example.com/state-management.mp4',
        fileSize: 45 * 1024 * 1024, // 45 MB
        category: 'Lecture Notes',
        tags: ['flutter', 'state-management', 'riverpod'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 5)),
        courseId: widget.courseId,
        downloadCount: 89,
        viewCount: 210,
        isBookmarked: true,
      ),
      ResourceModel(
        id: '3',
        title: 'Assignment 1 - Build a Todo App',
        description: 'Instructions and requirements for the first assignment',
        type: ResourceType.pdf,
        url: 'https://example.com/assignment1.pdf',
        fileSize: 512 * 1024, // 512 KB
        category: 'Assignments',
        tags: ['assignment', 'todo-app'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 7)),
        courseId: widget.courseId,
        downloadCount: 234,
        viewCount: 289,
        isDownloaded: true,
      ),
      ResourceModel(
        id: '4',
        title: 'Flutter Documentation (Official)',
        description: 'Link to official Flutter documentation',
        type: ResourceType.link,
        url: 'https://flutter.dev/docs',
        fileSize: 0,
        category: 'Reading Materials',
        tags: ['documentation', 'reference'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 10)),
        courseId: widget.courseId,
        downloadCount: 0,
        viewCount: 156,
      ),
      ResourceModel(
        id: '5',
        title: 'Sample Flutter Project - Counter App',
        description: 'Complete code example with comments',
        type: ResourceType.zip,
        url: 'https://example.com/counter-app.zip',
        fileSize: 15 * 1024, // 15 KB
        category: 'Code Examples',
        tags: ['code', 'example', 'counter'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 12)),
        courseId: widget.courseId,
        downloadCount: 178,
        viewCount: 234,
      ),
      ResourceModel(
        id: '6',
        title: 'Widget Cheat Sheet',
        description: 'Quick reference for common Flutter widgets',
        type: ResourceType.image,
        url: 'https://example.com/widget-cheatsheet.png',
        fileSize: 890 * 1024, // 890 KB
        category: 'Reading Materials',
        tags: ['widgets', 'reference', 'cheatsheet'],
        uploadedAt: DateTime.now().subtract(const Duration(days: 15)),
        courseId: widget.courseId,
        downloadCount: 267,
        viewCount: 445,
        isBookmarked: true,
        isDownloaded: true,
      ),
    ];
  }

  List<ResourceModel> get _allResources {
    return _resources.where((resource) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesTitle = resource.title.toLowerCase().contains(query);
        final matchesDescription = resource.description?.toLowerCase().contains(query) ?? false;
        final matchesTags = resource.tags.any((tag) => tag.toLowerCase().contains(query));

        if (!matchesTitle && !matchesDescription && !matchesTags) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null && resource.category != _selectedCategory) {
        return false;
      }

      // Type filter
      if (_selectedType != null && resource.type != _selectedType) {
        return false;
      }

      return true;
    }).toList();
  }

  List<ResourceModel> get _bookmarkedResources {
    return _allResources.where((r) => r.isBookmarked).toList();
  }

  List<ResourceModel> get _downloadedResources {
    return _allResources.where((r) => r.isDownloaded).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All (${_allResources.length})'),
            Tab(text: 'Bookmarked (${_bookmarkedResources.length})'),
            Tab(text: 'Downloaded (${_downloadedResources.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search resources...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Category Filter
                PopupMenuButton<String?>(
                  child: Chip(
                    avatar: const Icon(Icons.category, size: 18),
                    label: Text(_selectedCategory ?? 'All Categories'),
                    deleteIcon: _selectedCategory != null
                        ? const Icon(Icons.close, size: 18)
                        : null,
                    onDeleted: _selectedCategory != null
                        ? () {
                            setState(() {
                              _selectedCategory = null;
                            });
                          }
                        : null,
                  ),
                  onSelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ..._categories.map((category) {
                      return PopupMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }),
                  ],
                ),
                const SizedBox(width: 8),

                // Type Filter
                PopupMenuButton<ResourceType?>(
                  child: Chip(
                    avatar: Icon(
                      _selectedType?.icon ?? Icons.filter_list,
                      size: 18,
                    ),
                    label: Text(_selectedType?.displayName ?? 'All Types'),
                    deleteIcon: _selectedType != null
                        ? const Icon(Icons.close, size: 18)
                        : null,
                    onDeleted: _selectedType != null
                        ? () {
                            setState(() {
                              _selectedType = null;
                            });
                          }
                        : null,
                  ),
                  onSelected: (type) {
                    setState(() {
                      _selectedType = type;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: null,
                      child: Text('All Types'),
                    ),
                    ...ResourceType.values.map((type) {
                      return PopupMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(type.icon, size: 18, color: type.color),
                            const SizedBox(width: 12),
                            Text(type.displayName),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Resource List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResourceList(_allResources),
                _buildResourceList(_bookmarkedResources),
                _buildResourceList(_downloadedResources),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceList(List<ResourceModel> resources) {
    if (resources.isEmpty) {
      return EmptyResourcesState(
        message: _searchQuery.isNotEmpty
            ? 'No resources found'
            : 'No resources available',
        subtitle: _searchQuery.isNotEmpty
            ? 'Try a different search term'
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh resources from backend
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final resource = resources[index];
          return ResourceCard(
            resource: resource,
            downloadProgress: _downloadProgress[resource.id],
            onTap: () => _viewResource(resource),
            onDownload: () => _downloadResource(resource),
            onBookmark: () => _toggleBookmark(resource),
          );
        },
      ),
    );
  }

  void _viewResource(ResourceModel resource) {
    // TODO: Navigate to resource viewer
    Navigator.pushNamed(
      context,
      '/resources/view',
      arguments: resource,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${resource.title}...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _downloadResource(ResourceModel resource) {
    if (resource.isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Already downloaded'),
          backgroundColor: AppColors.info,
        ),
      );
      return;
    }

    // Simulate download
    setState(() {
      _downloadProgress[resource.id] = 0.0;
    });

    // Simulate progress
    Future.delayed(const Duration(milliseconds: 100), () {
      _simulateDownload(resource.id, 0.0);
    });
  }

  void _simulateDownload(String resourceId, double progress) {
    if (progress >= 1.0) {
      setState(() {
        _downloadProgress.remove(resourceId);
        // Mark as downloaded
        final index = _resources.indexWhere((r) => r.id == resourceId);
        if (index != -1) {
          // Update isDownloaded flag
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download completed!'),
          backgroundColor: AppColors.success,
        ),
      );
      return;
    }

    setState(() {
      _downloadProgress[resourceId] = progress + 0.1;
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_downloadProgress.containsKey(resourceId)) {
        _simulateDownload(resourceId, progress + 0.1);
      }
    });
  }

  void _toggleBookmark(ResourceModel resource) {
    setState(() {
      // Toggle bookmark
      final index = _resources.indexWhere((r) => r.id == resource.id);
      if (index != -1) {
        // Update isBookmarked flag
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resource.isBookmarked
              ? 'Removed from bookmarks'
              : 'Added to bookmarks',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Name (A-Z)'),
              onTap: () {
                setState(() {
                  _resources.sort((a, b) => a.title.compareTo(b.title));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Date Added (Newest)'),
              onTap: () {
                setState(() {
                  _resources.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Most Downloaded'),
              onTap: () {
                setState(() {
                  _resources.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('File Size'),
              onTap: () {
                setState(() {
                  _resources.sort((a, b) => a.fileSize.compareTo(b.fileSize));
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
