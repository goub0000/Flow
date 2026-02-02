import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../widgets/job_career_widgets.dart';

/// Career Resources Screen
///
/// Provides access to career development resources including:
/// - Articles and guides
/// - Video tutorials
/// - Online courses
/// - Career development tools
/// - Interview preparation
/// - Resume templates
///
/// Backend Integration TODO:
/// - Fetch resources from API
/// - Track user's viewed resources
/// - Implement bookmarking
/// - Add resource recommendations
/// - Track learning progress

class CareerResourcesScreen extends StatefulWidget {
  const CareerResourcesScreen({super.key});

  @override
  State<CareerResourcesScreen> createState() => _CareerResourcesScreenState();
}

class _CareerResourcesScreenState extends State<CareerResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<CareerResource> _mockResources = [];
  List<CareerResource> _filteredResources = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _generateMockResources();
    _filteredResources = _mockResources;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _generateMockResources() {
    _mockResources = [
      const CareerResource(
        id: '1',
        title: 'How to Build an Impressive Resume',
        description:
            'Learn the key elements of a standout resume that gets you noticed by employers.',
        type: 'article',
        duration: Duration(minutes: 10),
        views: 12500,
      ),
      const CareerResource(
        id: '2',
        title: 'Mastering the Job Interview',
        description:
            'Essential tips and strategies for acing your next job interview.',
        type: 'video',
        duration: Duration(minutes: 25),
        views: 8900,
        isBookmarked: true,
      ),
      const CareerResource(
        id: '3',
        title: 'Complete Career Development Course',
        description:
            'A comprehensive course covering career planning, skill development, and job search strategies.',
        type: 'course',
        duration: Duration(hours: 8),
        views: 4200,
      ),
      const CareerResource(
        id: '4',
        title: 'Salary Negotiation Guide',
        description:
            'Learn how to confidently negotiate your salary and benefits package.',
        type: 'guide',
        duration: Duration(minutes: 15),
        views: 15600,
      ),
      const CareerResource(
        id: '5',
        title: 'LinkedIn Profile Optimization',
        description:
            'Transform your LinkedIn profile into a powerful job-hunting tool.',
        type: 'article',
        duration: Duration(minutes: 12),
        views: 9800,
        isBookmarked: true,
      ),
      const CareerResource(
        id: '6',
        title: 'Effective Networking Strategies',
        description:
            'Build meaningful professional connections that advance your career.',
        type: 'video',
        duration: Duration(minutes: 30),
        views: 7300,
      ),
      const CareerResource(
        id: '7',
        title: 'Career Change Roadmap',
        description:
            'A step-by-step guide to successfully transitioning to a new career.',
        type: 'guide',
        duration: Duration(minutes: 20),
        views: 11200,
      ),
      const CareerResource(
        id: '8',
        title: 'Personal Branding Workshop',
        description:
            'Develop a strong personal brand that sets you apart in your industry.',
        type: 'course',
        duration: Duration(hours: 6),
        views: 3500,
      ),
      const CareerResource(
        id: '9',
        title: 'Remote Work Best Practices',
        description:
            'Essential skills and strategies for succeeding in a remote work environment.',
        type: 'article',
        duration: Duration(minutes: 8),
        views: 13400,
      ),
      const CareerResource(
        id: '10',
        title: 'Technical Interview Preparation',
        description:
            'Prepare for technical interviews with coding challenges and problem-solving strategies.',
        type: 'video',
        duration: Duration(minutes: 45),
        views: 6700,
      ),
    ];
  }

  void _filterResources() {
    setState(() {
      _filteredResources = _mockResources.where((resource) {
        if (_searchController.text.isEmpty) return true;

        final searchLower = _searchController.text.toLowerCase();
        return resource.title.toLowerCase().contains(searchLower) ||
            resource.description.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  void _toggleBookmark(CareerResource resource) {
    setState(() {
      final index = _mockResources.indexWhere((r) => r.id == resource.id);
      if (index != -1) {
        _mockResources[index] =
            resource.copyWith(isBookmarked: !resource.isBookmarked);
        _filterResources();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resource.isBookmarked
              ? context.l10n.careerRemovedFromBookmarks
              : context.l10n.careerAddedToBookmarks,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.helpBack,
        ),
        title: Text(context.l10n.careerResourcesTitle),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: context.l10n.careerAll),
            Tab(text: context.l10n.careerArticles),
            Tab(text: context.l10n.careerVideos),
            Tab(text: context.l10n.careerCourses),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.careerSearchResources,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterResources();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (_) => _filterResources(),
            ),
          ),

          // Quick Access Tiles
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _QuickAccessTile(
                    icon: Icons.bookmark,
                    label: 'Bookmarked',
                    count: _mockResources
                        .where((r) => r.isBookmarked)
                        .length,
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Show bookmarked resources
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickAccessTile(
                    icon: Icons.history,
                    label: 'Recent',
                    count: 5,
                    color: AppColors.info,
                    onTap: () {
                      // TODO: Show recent resources
                    },
                  ),
                ),
              ],
            ),
          ),

          // Resources List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildResourcesList(_filteredResources),
                _buildResourcesList(
                  _filteredResources.where((r) => r.type == 'article').toList(),
                ),
                _buildResourcesList(
                  _filteredResources.where((r) => r.type == 'video').toList(),
                ),
                _buildResourcesList(
                  _filteredResources.where((r) => r.type == 'course').toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCategoriesSheet();
        },
        icon: const Icon(Icons.category),
        label: Text(context.l10n.careerCategories),
      ),
    );
  }

  Widget _buildResourcesList(List<CareerResource> resources) {
    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.careerNoResourcesFound,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.careerTryAdjustingSearch,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
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
        final resource = resources[index];
        return CareerResourceCard(
          resource: resource,
          onTap: () {
            _showResourceDetail(resource);
          },
          onBookmark: () => _toggleBookmark(resource),
        );
      },
    );
  }

  void _showResourceDetail(CareerResource resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      resource.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Type and Duration
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          resource.type.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (resource.duration != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDuration(resource.duration!),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    resource.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // What You'll Learn (mock)
                  Text(
                    context.l10n.careerWhatYoullLearn,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...['Key concept 1', 'Key concept 2', 'Key concept 3'].map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 20,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    children: [
                      _StatChip(
                        icon: Icons.visibility,
                        label: '${resource.views} views',
                      ),
                      const SizedBox(width: 12),
                      const _StatChip(
                        icon: Icons.star,
                        label: '4.8 rating',
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _toggleBookmark(resource),
                      icon: Icon(
                        resource.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      label: Text(
                        resource.isBookmarked ? context.l10n.careerSaved : context.l10n.careerSave,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.l10n.careerOpeningResource),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.l10n.careerStartLearning),
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

  void _showCategoriesSheet() {
    final categories = [
      {'icon': Icons.article, 'label': 'Resume Writing', 'color': AppColors.primary},
      {'icon': Icons.psychology, 'label': 'Interview Prep', 'color': AppColors.info},
      {'icon': Icons.trending_up, 'label': 'Career Growth', 'color': AppColors.success},
      {'icon': Icons.people, 'label': 'Networking', 'color': AppColors.warning},
      {'icon': Icons.business_center, 'label': 'Job Search', 'color': Colors.purple},
      {'icon': Icons.school, 'label': 'Skill Development', 'color': Colors.orange},
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  context.l10n.careerBrowseCategories,
                  style: const TextStyle(
                    fontSize: 18,
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

          // Categories Grid
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Filter by category
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: (category['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (category['color'] as Color).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          category['icon'] as IconData,
                          color: category['color'] as Color,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: category['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes} min';
  }
}

/// Quick Access Tile Widget
class _QuickAccessTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;
  final VoidCallback onTap;

  const _QuickAccessTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Stat Chip Widget
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
