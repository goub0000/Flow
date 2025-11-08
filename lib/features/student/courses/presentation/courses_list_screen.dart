import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/skeleton_loader.dart';
import '../../../shared/widgets/search_widget.dart';
import '../../../shared/widgets/filter_widget.dart';
import '../../../shared/widgets/sort_widget.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../providers/student_courses_provider.dart';

class CoursesListScreen extends ConsumerStatefulWidget {
  const CoursesListScreen({super.key});

  @override
  ConsumerState<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends ConsumerState<CoursesListScreen> {
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();
  int _displayedItemCount = 10; // Pagination: initially show 10 items

  // Filter and sort state
  FilterOptions _filterOptions = FilterOptions();
  SortOption _sortOption = SortOptions.relevance;

  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more items when reaching 80% of scroll extent
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMore();
    }
  }

  void _loadMore() {
    setState(() {
      // Load 10 more items at a time
      _displayedItemCount += 10;
    });
  }

  List<Course> get _filteredCourses {
    final courses = ref.watch(availableCoursesProvider);

    // Apply filters
    var filtered = courses.where((course) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch = course.title.toLowerCase().contains(searchLower) ||
            course.institutionName.toLowerCase().contains(searchLower) ||
            course.description.toLowerCase().contains(searchLower);
        if (!matchesSearch) return false;
      }

      // Category filter
      if (_filterOptions.categories.isNotEmpty) {
        if (!_filterOptions.categories.contains(course.category)) {
          return false;
        }
      }

      // Price filter
      if (course.fee != null) {
        if (course.fee! < _filterOptions.priceRange.start ||
            course.fee! > _filterOptions.priceRange.end) {
          return false;
        }
      }

      // Level filter
      if (_filterOptions.levels.isNotEmpty) {
        if (!_filterOptions.levels.contains(course.level)) {
          return false;
        }
      }

      // Duration filter
      if (_filterOptions.durationRange != null) {
        final durationWeeks = course.duration * 4; // Convert months to weeks
        if (durationWeeks < _filterOptions.durationRange!.start ||
            durationWeeks > _filterOptions.durationRange!.end) {
          return false;
        }
      }

      // Online only filter
      if (_filterOptions.onlineOnly && !course.isOnline) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    filtered = SortHelper.sortList(
      items: filtered,
      sortBy: _sortOption,
      getValue: (course) {
        switch (_sortOption.field) {
          case 'rating':
            return course.rating;
          case 'price':
            return course.fee ?? 0;
          case 'duration':
            return course.duration;
          case 'enrollmentCount':
            return course.enrolledStudents;
          case 'name':
            return course.title;
          case 'createdAt':
            return course.createdAt;
          default:
            return 0;
        }
      },
    );

    // Return paginated results
    return filtered.take(_displayedItemCount).toList();
  }

  int get _totalFilteredCount {
    final courses = ref.watch(availableCoursesProvider);
    return courses.where((course) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final matchesSearch = course.title.toLowerCase().contains(searchLower) ||
            course.institutionName.toLowerCase().contains(searchLower) ||
            course.description.toLowerCase().contains(searchLower);
        if (!matchesSearch) return false;
      }

      // Category filter
      if (_filterOptions.categories.isNotEmpty) {
        if (!_filterOptions.categories.contains(course.category)) {
          return false;
        }
      }

      // Price filter
      if (course.fee != null) {
        if (course.fee! < _filterOptions.priceRange.start ||
            course.fee! > _filterOptions.priceRange.end) {
          return false;
        }
      }

      // Level filter
      if (_filterOptions.levels.isNotEmpty) {
        if (!_filterOptions.levels.contains(course.level)) {
          return false;
        }
      }

      // Duration filter
      if (_filterOptions.durationRange != null) {
        final durationWeeks = course.duration * 4; // Convert months to weeks
        if (durationWeeks < _filterOptions.durationRange!.start ||
            durationWeeks > _filterOptions.durationRange!.end) {
          return false;
        }
      }

      // Online only filter
      if (_filterOptions.onlineOnly && !course.isOnline) {
        return false;
      }

      return true;
    }).length;
  }

  Future<void> _refreshCourses() async {
    setState(() {
      _displayedItemCount = 10; // Reset pagination on refresh
    });
    await ref.read(coursesProvider.notifier).fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(coursesLoadingProvider);
    final error = ref.watch(coursesErrorProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/student/dashboard');
            }
          },
          tooltip: 'Back',
        ),
        title: const Text('Available Courses'),
      ),
      body: Column(
        children: [
          // Search Widget
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchWidget(
              hint: 'Search courses, institutions...',
              onSearch: (query) {
                setState(() {
                  _searchQuery = query;
                  _displayedItemCount = 10; // Reset pagination
                });
              },
            ),
          ),

          // Active Filters Display
          if (_filterOptions.activeFilterCount > 0)
            ActiveFiltersChips(
              filters: _filterOptions,
              onFilterRemoved: (newFilters) {
                setState(() {
                  _filterOptions = newFilters;
                  _displayedItemCount = 10;
                });
              },
            ),

          // Sort and Filter Bar
          SortFilterBar(
            currentSort: _sortOption,
            activeFilters: _filterOptions.activeFilterCount,
            resultsCount: '${_totalFilteredCount} courses',
            onSortPressed: () {
              showSortBottomSheet(
                context: context,
                options: SortOptions.courseOptions,
                currentSort: _sortOption,
                onSelected: (option) {
                  setState(() {
                    _sortOption = option;
                    _displayedItemCount = 10;
                  });
                },
              );
            },
            onFilterPressed: () {
              showFilterBottomSheet(
                context: context,
                currentFilters: _filterOptions,
                filterType: FilterType.courses,
                onApply: (filters) {
                  setState(() {
                    _filterOptions = filters;
                    _displayedItemCount = 10;
                  });
                },
              );
            },
          ),

          // Error message
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: AppColors.error.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: AppColors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                      TextButton(
                        onPressed: _refreshCourses,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Courses List
          Expanded(
            child: isLoading
                ? SkeletonList(
                    itemCount: 5,
                    itemBuilder: (index) => const SkeletonCourseCard(),
                  )
                : _filteredCourses.isEmpty
                    ? EmptyState(
                        icon: Icons.school_outlined,
                        title: 'No Courses Found',
                        message: _searchQuery.isNotEmpty
                            ? 'Try adjusting your search or filters'
                            : 'No courses available at the moment',
                        actionLabel: error != null ? 'Refresh' : null,
                        onAction: error != null ? _refreshCourses : null,
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshCourses,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredCourses.length +
                              (_displayedItemCount < _totalFilteredCount ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the bottom when more items exist
                            if (index == _filteredCourses.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final course = _filteredCourses[index];
                            return _CourseCard(
                              course: course,
                              onTap: () {
                                context.go('/student/courses/${course.id}',
                                    extra: course);
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

}

class _CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;

  const _CourseCard({
    required this.course,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysUntilStart = course.startDate.difference(DateTime.now()).inDays;

    return CustomCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course/Institution Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: LogoAvatar.course(
              imageUrl: course.imageUrl,
              courseName: course.institutionName,
              height: 120,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Institution Name
                Text(
                  course.institutionName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),

                // Course Title
                Text(
                  course.title,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Course Info
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      icon: Icons.schedule,
                      label: '${course.duration} months',
                    ),
                    _InfoChip(
                      icon: Icons.people,
                      label:
                          '${course.enrolledStudents}/${course.maxStudents}',
                    ),
                    if (course.fee != null)
                      _InfoChip(
                        icon: Icons.attach_money,
                        label: '${course.currency} ${course.fee}',
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Start Date
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: daysUntilStart <= 30
                        ? AppColors.warning.withValues(alpha: 0.1)
                        : AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    daysUntilStart > 0
                        ? 'Starts in $daysUntilStart days'
                        : 'Starting soon',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: daysUntilStart <= 30
                          ? AppColors.warning
                          : AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
