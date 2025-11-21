import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/enrollment_model.dart';
import '../../../../core/models/course_model.dart';
import '../../providers/enrollments_provider.dart';
import '../../providers/courses_provider.dart';

/// My Courses Screen
/// Displays student's enrolled courses with progress tracking
class MyCoursesScreen extends ConsumerStatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  ConsumerState<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends ConsumerState<MyCoursesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      // Load more when scrolled to 90%
      ref.read(enrollmentsProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enrollmentsState = ref.watch(enrollmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersBottomSheet(context),
            tooltip: 'Filter by status',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(enrollmentsProvider.notifier).refresh(),
        child: Column(
          children: [
            // Active Status Filter Chip
            if (enrollmentsState.filterStatus != null)
              _buildActiveFilter(enrollmentsState),

            // Enrollments List
            Expanded(
              child: _buildEnrollmentsList(enrollmentsState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilter(EnrollmentsState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          Chip(
            label: Text(state.filterStatus!.displayName),
            deleteIcon: const Icon(Icons.close, size: 18),
            onDeleted: () {
              ref.read(enrollmentsProvider.notifier).filterByStatus(null);
            },
          ),
          TextButton.icon(
            onPressed: () {
              ref.read(enrollmentsProvider.notifier).filterByStatus(null);
            },
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear Filter'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentsList(EnrollmentsState state) {
    if (state.isLoading && state.enrollments.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.enrollments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(enrollmentsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.enrollments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No enrolled courses',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse courses to get started',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/student/courses');
              },
              icon: const Icon(Icons.explore),
              label: const Text('Browse Courses'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: state.enrollments.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.enrollments.length) {
          // Loading indicator for pagination
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final enrollment = state.enrollments[index];
        return _buildEnrollmentCard(enrollment);
      },
    );
  }

  Widget _buildEnrollmentCard(Enrollment enrollment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to course detail - will need to fetch course first
          _navigateToCourseDetail(enrollment.courseId);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (enrollment.courseThumbnailUrl != null)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  enrollment.courseThumbnailUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                ),
              )
            else
              _buildPlaceholderImage(),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge and Title Row
                  Row(
                    children: [
                      _buildStatusBadge(enrollment.status),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          enrollment.courseTitle ?? 'Course',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Institution Name
                  if (enrollment.institutionName != null)
                    Row(
                      children: [
                        Icon(Icons.business, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            enrollment.institutionName!,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),

                  // Progress Bar (only for active enrollments)
                  if (enrollment.isActive) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${enrollment.progressPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: enrollment.progressPercentage / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(enrollment.progressPercentage),
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Enrollment Info
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Enrolled: ${_formatDate(enrollment.enrolledAt)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      if (enrollment.completedAt != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.check_circle,
                            size: 14, color: Colors.green[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Completed: ${_formatDate(enrollment.completedAt!)}',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.7),
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.school,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  Widget _buildStatusBadge(EnrollmentStatus status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case EnrollmentStatus.active:
        backgroundColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.play_circle_outline;
        break;
      case EnrollmentStatus.completed:
        backgroundColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle_outline;
        break;
      case EnrollmentStatus.dropped:
        backgroundColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.cancel_outlined;
        break;
      case EnrollmentStatus.suspended:
        backgroundColor = Colors.red[50]!;
        textColor = Colors.red[700]!;
        icon = Icons.pause_circle_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<void> _navigateToCourseDetail(String courseId) async {
    // Fetch the full course details first
    try {
      final course = await ref.read(coursesProvider.notifier).getCourseById(courseId);
      if (course != null && mounted) {
        context.push('/student/courses/$courseId', extra: course);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load course details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _StatusFilterBottomSheet(),
    );
  }
}

/// Status Filter Bottom Sheet
class _StatusFilterBottomSheet extends ConsumerWidget {
  const _StatusFilterBottomSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(enrollmentsProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter by Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Status Filter Options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(
                context,
                ref,
                'All',
                icon: Icons.all_inclusive,
                isSelected: state.filterStatus == null,
                onTap: () {
                  ref.read(enrollmentsProvider.notifier).filterByStatus(null);
                  Navigator.pop(context);
                },
              ),
              ...EnrollmentStatus.values.map((status) => _buildFilterChip(
                    context,
                    ref,
                    status.displayName,
                    icon: _getStatusIcon(status),
                    isSelected: state.filterStatus == status,
                    onTap: () {
                      ref
                          .read(enrollmentsProvider.notifier)
                          .filterByStatus(status);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    String label, {
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withOpacity(0.2),
    );
  }

  IconData _getStatusIcon(EnrollmentStatus status) {
    switch (status) {
      case EnrollmentStatus.active:
        return Icons.play_circle_outline;
      case EnrollmentStatus.completed:
        return Icons.check_circle_outline;
      case EnrollmentStatus.dropped:
        return Icons.cancel_outlined;
      case EnrollmentStatus.suspended:
        return Icons.pause_circle_outline;
    }
  }
}
