import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';

/// Resources Screen for students
/// Shows learning materials, documents, links, and educational resources
class ResourcesScreen extends ConsumerStatefulWidget {
  const ResourcesScreen({super.key});

  @override
  ConsumerState<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends ConsumerState<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  ResourceCategory? _selectedCategory;

  // Mock resources data - TODO: Replace with backend data
  final List<Resource> _resources = [
    // Study Guides
    Resource(
      id: '1',
      title: 'SAT Preparation Guide 2024',
      description: 'Comprehensive guide for SAT exam preparation with practice questions and strategies.',
      category: ResourceCategory.studyGuide,
      type: ResourceType.pdf,
      url: 'https://example.com/sat-guide.pdf',
      size: '15.2 MB',
      dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      isFavorite: true,
    ),
    Resource(
      id: '2',
      title: 'College Application Essay Tips',
      description: 'Learn how to write compelling personal statements and application essays.',
      category: ResourceCategory.studyGuide,
      type: ResourceType.article,
      url: 'https://example.com/essay-tips',
      dateAdded: DateTime.now().subtract(const Duration(days: 10)),
    ),
    // Video Tutorials
    Resource(
      id: '3',
      title: 'Introduction to Calculus',
      description: 'Video series covering fundamental calculus concepts.',
      category: ResourceCategory.video,
      type: ResourceType.video,
      url: 'https://example.com/calculus-intro',
      duration: '2h 30m',
      dateAdded: DateTime.now().subtract(const Duration(days: 3)),
      isFavorite: true,
    ),
    Resource(
      id: '4',
      title: 'Interview Preparation Workshop',
      description: 'Recorded webinar on how to ace your college interviews.',
      category: ResourceCategory.video,
      type: ResourceType.video,
      url: 'https://example.com/interview-workshop',
      duration: '1h 15m',
      dateAdded: DateTime.now().subtract(const Duration(days: 7)),
    ),
    // Templates
    Resource(
      id: '5',
      title: 'Resume Template for Students',
      description: 'Professional resume template designed for high school and college students.',
      category: ResourceCategory.template,
      type: ResourceType.document,
      url: 'https://example.com/resume-template.docx',
      size: '245 KB',
      dateAdded: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Resource(
      id: '6',
      title: 'Cover Letter Template',
      description: 'Customizable cover letter template for internship applications.',
      category: ResourceCategory.template,
      type: ResourceType.document,
      url: 'https://example.com/cover-letter.docx',
      size: '180 KB',
      dateAdded: DateTime.now().subtract(const Duration(days: 20)),
    ),
    // External Links
    Resource(
      id: '7',
      title: 'Khan Academy',
      description: 'Free online courses, lessons, and practice in various subjects.',
      category: ResourceCategory.externalLink,
      type: ResourceType.link,
      url: 'https://www.khanacademy.org',
      dateAdded: DateTime.now().subtract(const Duration(days: 30)),
      isFavorite: true,
    ),
    Resource(
      id: '8',
      title: 'Common App',
      description: 'Official Common Application portal for college applications.',
      category: ResourceCategory.externalLink,
      type: ResourceType.link,
      url: 'https://www.commonapp.org',
      dateAdded: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Resource(
      id: '9',
      title: 'College Board',
      description: 'SAT registration, AP courses, and college planning resources.',
      category: ResourceCategory.externalLink,
      type: ResourceType.link,
      url: 'https://www.collegeboard.org',
      dateAdded: DateTime.now().subtract(const Duration(days: 28)),
    ),
    // Career Resources
    Resource(
      id: '10',
      title: 'Career Exploration Guide',
      description: 'Discover different career paths and understand job requirements.',
      category: ResourceCategory.career,
      type: ResourceType.pdf,
      url: 'https://example.com/career-guide.pdf',
      size: '8.5 MB',
      dateAdded: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Resource> get _filteredResources {
    var filtered = _resources;

    if (_selectedCategory != null) {
      filtered = filtered.where((r) => r.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((r) {
        return r.title.toLowerCase().contains(query) ||
            r.description.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  List<Resource> get _favoriteResources {
    return _resources.where((r) => r.isFavorite).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.studentResourcesTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: context.l10n.studentResourcesAllResources),
            Tab(text: context.l10n.studentResourcesFavorites),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and Filter
          _buildSearchAndFilter(theme),
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResourcesList(_filteredResources),
                _buildResourcesList(_favoriteResources),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: context.l10n.studentResourcesSearchHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          const SizedBox(height: 12),
          // Category filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(null, context.l10n.studentResourcesAll),
                ...ResourceCategory.values.map((cat) {
                  return _buildCategoryChip(cat, cat.labelFor(context));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ResourceCategory? category, String label) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _selectedCategory = category);
        },
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildResourcesList(List<Resource> resources) {
    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.studentResourcesNoResults,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.studentResourcesTryAdjusting,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        return _buildResourceCard(resources[index]);
      },
    );
  }

  Widget _buildResourceCard(Resource resource) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _openResource(resource),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: resource.type.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  resource.type.icon,
                  color: resource.type.color,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: resource.category.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            resource.category.labelFor(context),
                            style: TextStyle(
                              fontSize: 10,
                              color: resource.category.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: Icon(
                            resource.isFavorite
                                ? Icons.star
                                : Icons.star_border,
                            color: resource.isFavorite
                                ? Colors.amber
                                : Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _toggleFavorite(resource),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resource.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (resource.size != null) ...[
                          Icon(Icons.storage, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            resource.size!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if (resource.duration != null) ...[
                          Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            resource.duration!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(resource.dateAdded),
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return context.l10n.studentResourcesDateToday;
    } else if (diff.inDays == 1) {
      return context.l10n.studentResourcesDateYesterday;
    } else if (diff.inDays < 7) {
      return context.l10n.studentResourcesDateDaysAgo(diff.inDays);
    } else if (diff.inDays < 30) {
      return context.l10n.studentResourcesDateWeeksAgo((diff.inDays / 7).floor());
    } else {
      return context.l10n.studentResourcesDateMonthsAgo((diff.inDays / 30).floor());
    }
  }

  void _toggleFavorite(Resource resource) {
    setState(() {
      final index = _resources.indexWhere((r) => r.id == resource.id);
      if (index != -1) {
        _resources[index] = Resource(
          id: resource.id,
          title: resource.title,
          description: resource.description,
          category: resource.category,
          type: resource.type,
          url: resource.url,
          size: resource.size,
          duration: resource.duration,
          dateAdded: resource.dateAdded,
          isFavorite: !resource.isFavorite,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resource.isFavorite
              ? context.l10n.studentResourcesRemovedFavorite
              : context.l10n.studentResourcesAddedFavorite,
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openResource(Resource resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: resource.type.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    resource.type.icon,
                    color: resource.type.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: resource.category.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          resource.category.labelFor(context),
                          style: TextStyle(
                            fontSize: 11,
                            color: resource.category.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resource.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              resource.description,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            if (resource.size != null || resource.duration != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    if (resource.size != null) ...[
                      Icon(Icons.storage, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        resource.size!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      if (resource.duration != null) const SizedBox(width: 24),
                    ],
                    if (resource.duration != null) ...[
                      Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        resource.duration!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.studentResourcesOpening(resource.title)),
                      action: SnackBarAction(
                        label: 'View',
                        onPressed: () {
                          // TODO: Open URL
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  resource.type == ResourceType.link
                      ? Icons.open_in_new
                      : Icons.download,
                ),
                label: Text(
                  resource.type == ResourceType.link ? context.l10n.studentResourcesOpenLink : context.l10n.studentResourcesDownload,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Resource categories
enum ResourceCategory {
  studyGuide,
  video,
  template,
  externalLink,
  career;

  String labelFor(BuildContext context) {
    switch (this) {
      case ResourceCategory.studyGuide:
        return context.l10n.studentResourcesCategoryStudyGuide;
      case ResourceCategory.video:
        return context.l10n.studentResourcesCategoryVideo;
      case ResourceCategory.template:
        return context.l10n.studentResourcesCategoryTemplate;
      case ResourceCategory.externalLink:
        return context.l10n.studentResourcesCategoryExternalLink;
      case ResourceCategory.career:
        return context.l10n.studentResourcesCategoryCareer;
    }
  }

  Color get color {
    switch (this) {
      case ResourceCategory.studyGuide:
        return Colors.blue;
      case ResourceCategory.video:
        return Colors.red;
      case ResourceCategory.template:
        return Colors.green;
      case ResourceCategory.externalLink:
        return Colors.purple;
      case ResourceCategory.career:
        return Colors.orange;
    }
  }
}

/// Resource types
enum ResourceType {
  pdf,
  video,
  document,
  article,
  link;

  IconData get icon {
    switch (this) {
      case ResourceType.pdf:
        return Icons.picture_as_pdf;
      case ResourceType.video:
        return Icons.play_circle;
      case ResourceType.document:
        return Icons.description;
      case ResourceType.article:
        return Icons.article;
      case ResourceType.link:
        return Icons.link;
    }
  }

  Color get color {
    switch (this) {
      case ResourceType.pdf:
        return Colors.red;
      case ResourceType.video:
        return Colors.blue;
      case ResourceType.document:
        return Colors.green;
      case ResourceType.article:
        return Colors.orange;
      case ResourceType.link:
        return Colors.purple;
    }
  }
}

/// Resource model
class Resource {
  final String id;
  final String title;
  final String description;
  final ResourceCategory category;
  final ResourceType type;
  final String url;
  final String? size;
  final String? duration;
  final DateTime dateAdded;
  final bool isFavorite;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.url,
    this.size,
    this.duration,
    required this.dateAdded,
    this.isFavorite = false,
  });
}
