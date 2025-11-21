import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';

/// Course Permissions Management Screen
/// Institution manages enrollment permissions for a specific course
class CoursePermissionsScreen extends ConsumerStatefulWidget {
  final Course course;

  const CoursePermissionsScreen({super.key, required this.course});

  @override
  ConsumerState<CoursePermissionsScreen> createState() =>
      _CoursePermissionsScreenState();
}

class _CoursePermissionsScreenState
    extends ConsumerState<CoursePermissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Enrollment Permissions'),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending Requests'),
            Tab(text: 'Approved'),
            Tab(text: 'All Students'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PendingRequestsTab(course: widget.course),
          _ApprovedPermissionsTab(course: widget.course),
          _AllStudentsTab(course: widget.course),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGrantPermissionDialog(),
        icon: const Icon(Icons.person_add),
        label: const Text('Grant Permission'),
      ),
    );
  }

  void _showGrantPermissionDialog() {
    // TODO: Implement grant permission dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grant Enrollment Permission'),
        content: const Text('Grant permission feature coming soon. Select admitted students to grant access to this course.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Pending Requests Tab
class _PendingRequestsTab extends ConsumerWidget {
  final Course course;

  const _PendingRequestsTab({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch pending requests from API
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pending_actions, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No pending requests',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Students can request enrollment permission',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// Approved Permissions Tab
class _ApprovedPermissionsTab extends ConsumerWidget {
  final Course course;

  const _ApprovedPermissionsTab({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch approved permissions from API
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No approved permissions yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Grant permissions to allow students to enroll',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

/// All Admitted Students Tab
class _AllStudentsTab extends ConsumerWidget {
  final Course course;

  const _AllStudentsTab({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch admitted students from API
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No admitted students',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Students with accepted applications will appear here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
