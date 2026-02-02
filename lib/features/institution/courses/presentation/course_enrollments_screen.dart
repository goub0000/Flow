import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/services/enrollment_permissions_api_service.dart';
import '../../../../core/l10n_extension.dart';
import '../../../authentication/providers/auth_provider.dart';

/// Course Enrollments/Roster Screen
/// Shows list of students enrolled in a course
class CourseEnrollmentsScreen extends ConsumerStatefulWidget {
  final Course course;

  const CourseEnrollmentsScreen({super.key, required this.course});

  @override
  ConsumerState<CourseEnrollmentsScreen> createState() =>
      _CourseEnrollmentsScreenState();
}

class _CourseEnrollmentsScreenState
    extends ConsumerState<CourseEnrollmentsScreen> {
  List<dynamic> _enrolledStudents = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchEnrolledStudents();
  }

  Future<void> _fetchEnrolledStudents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final accessToken = ref.read(authProvider).accessToken;
      final apiService =
          EnrollmentPermissionsApiService(accessToken: accessToken);

      // Get students with approved permissions (can enroll)
      final result =
          await apiService.getAdmittedStudents(courseId: widget.course.id);

      if (mounted) {
        // Filter to only show students with approved permissions
        final allStudents = result['students'] as List? ?? [];
        final enrolledStudents = allStudents.where((s) {
          final permission = s['permission'] as Map<String, dynamic>?;
          return permission != null && permission['status'] == 'approved';
        }).toList();

        setState(() {
          _enrolledStudents = enrolledStudents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load roster: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.instCourseCourseRoster),
            Text(
              widget.course.title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchEnrolledStudents,
            tooltip: context.l10n.instCourseRefresh,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchEnrolledStudents,
              child: Text(context.l10n.instCourseRetry),
            ),
          ],
        ),
      );
    }

    if (_enrolledStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoEnrolledStudents,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseApprovedStudentsAppearHere,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Colors.blue, size: 32),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_enrolledStudents.length}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        context.l10n.instCourseEnrolledStudents,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.course.maxStudents != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.course.maxStudents}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          context.l10n.instCourseMaxCapacity,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),

        // Student list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _fetchEnrolledStudents,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _enrolledStudents.length,
              itemBuilder: (context, index) {
                final student = _enrolledStudents[index];
                return _buildStudentCard(student);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCard(dynamic student) {
    final permission = student['permission'] as Map<String, dynamic>?;
    final grantedAt = permission?['reviewed_at'] != null
        ? DateTime.tryParse(permission!['reviewed_at'])
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Text(
            (student['display_name'] ?? 'S')[0].toUpperCase(),
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          student['display_name'] ?? 'Student',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student['email'] ?? ''),
            if (grantedAt != null)
              Text(
                context.l10n.instCourseEnrolledDate(_formatDate(grantedAt)),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: const Icon(Icons.check_circle, color: Colors.green),
        isThreeLine: grantedAt != null,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
