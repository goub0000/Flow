// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../providers/institution_courses_provider.dart';

/// Institution Courses Management Screen
/// Manage courses for an educational institution
class InstitutionCoursesScreen extends ConsumerWidget {
  const InstitutionCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(institutionCoursesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/institution/courses/create');
            },
            tooltip: 'Create Course',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(institutionCoursesProvider.notifier).refresh(),
        child: Column(
          children: [
            // Statistics Cards
            if (state.statistics != null) _buildStatisticsCards(state.statistics!),

            // Filter Tabs
            _buildFilterTabs(context, ref, state),

            // Courses List
            Expanded(
              child: _buildCoursesList(context, ref, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(CourseStatistics stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard('Total Courses', stats.totalCourses.toString(), Icons.school, AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Published', stats.publishedCourses.toString(), Icons.check_circle, Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('Enrollments', stats.totalEnrollments.toString(), Icons.people, Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, WidgetRef ref, InstitutionCoursesState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', state.filterStatus == null, () {
              ref.read(institutionCoursesProvider.notifier).filterByStatus(null);
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Published', state.filterStatus == CourseStatus.published, () {
              ref.read(institutionCoursesProvider.notifier).filterByStatus(CourseStatus.published);
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Draft', state.filterStatus == CourseStatus.draft, () {
              ref.read(institutionCoursesProvider.notifier).filterByStatus(CourseStatus.draft);
            }),
            const SizedBox(width: 8),
            _buildFilterChip('Archived', state.filterStatus == CourseStatus.archived, () {
              ref.read(institutionCoursesProvider.notifier).filterByStatus(CourseStatus.archived);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha:0.2),
    );
  }

  Widget _buildCoursesList(BuildContext context, WidgetRef ref, InstitutionCoursesState state) {
    if (state.isLoading && state.courses.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(state.error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(institutionCoursesProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text('No courses yet', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/institution/courses/create');
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Your First Course'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.courses.length,
      itemBuilder: (context, index) {
        final course = state.courses[index];
        return _buildCourseCard(context, ref, course);
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, WidgetRef ref, Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(course.status),
          child: Icon(
            course.isPublished ? Icons.check : Icons.edit,
            color: Colors.white,
          ),
        ),
        title: Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${course.enrolledCount} enrolled • ${course.level.displayName}'),
            Text(course.status.displayName, style: TextStyle(color: _getStatusColor(course.status))),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'permissions', child: Text('Manage Permissions')),
            const PopupMenuItem(value: 'roster', child: Text('View Roster')),
            if (!course.isPublished)
              const PopupMenuItem(value: 'publish', child: Text('Publish'))
            else
              const PopupMenuItem(value: 'unpublish', child: Text('Unpublish')),
            const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
          onSelected: (value) => _handleMenuAction(context, ref, course, value.toString()),
        ),
        isThreeLine: true,
        onTap: () {
          context.push('/institution/courses/${course.id}', extra: course);
        },
      ),
    );
  }

  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.published:
        return Colors.green;
      case CourseStatus.draft:
        return Colors.orange;
      case CourseStatus.archived:
        return Colors.grey;
    }
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, Course course, String action) async {
    final notifier = ref.read(institutionCoursesProvider.notifier);

    switch (action) {
      case 'edit':
        context.push('/institution/courses/${course.id}/edit', extra: course);
        break;
      case 'permissions':
        context.push('/institution/courses/${course.id}/permissions', extra: course);
        break;
      case 'roster':
        // Navigate to roster view (enrollments list)
        context.push('/institution/courses/${course.id}/enrollments', extra: course);
        break;
      case 'publish':
        final result = await notifier.publishCourse(course.id);
        if (result != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course published successfully!')),
          );
        }
        break;
      case 'unpublish':
        final result = await notifier.unpublishCourse(course.id);
        if (result != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course unpublished')),
          );
        }
        break;
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Course'),
            content: const Text('Are you sure you want to delete this course?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          final success = await notifier.deleteCourse(course.id);
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Course deleted')),
            );
          }
        }
        break;
    }
  }
}
