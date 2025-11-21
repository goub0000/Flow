import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/enrollment_permission_model.dart';
import '../../../../core/services/enrollment_permissions_api_service.dart';
import '../../providers/enrollments_provider.dart';
import '../../../authentication/providers/auth_provider.dart';

/// Course Detail Screen
/// Shows detailed information about a course
class CourseDetailScreen extends ConsumerStatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  bool _isEnrolling = false;
  bool _isCheckingPermission = false;
  EnrollmentPermission? _permission;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    setState(() => _isCheckingPermission = true);

    try {
      final accessToken = ref.read(authProvider).accessToken;
      final apiService = EnrollmentPermissionsApiService(accessToken: accessToken);

      final permissionData = await apiService.getPermissionForCourse(widget.course.id);

      if (permissionData != null && mounted) {
        setState(() {
          _permission = EnrollmentPermission.fromJson(permissionData);
          _isCheckingPermission = false;
        });
      } else if (mounted) {
        setState(() {
          _permission = null;
          _isCheckingPermission = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _permission = null;
          _isCheckingPermission = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final enrollmentsState = ref.watch(enrollmentsProvider);
    final isEnrolled = enrollmentsState.enrollments
        .any((e) => e.courseId == course.id && e.isActive);
    final enrollment = enrollmentsState.enrollments
        .where((e) => e.courseId == course.id && e.isActive)
        .firstOrNull;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(course.title, style: const TextStyle(shadows: [
                Shadow(blurRadius: 2, color: Colors.black54)
              ])),
              background: course.thumbnailUrl != null
                  ? Image.network(course.thumbnailUrl!, fit: BoxFit.cover)
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.school, size: 80, color: Colors.white),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Info
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(course.level.displayName)),
                      Chip(label: Text(course.courseType.displayName)),
                      if (course.durationHours != null)
                        Chip(label: Text('${course.durationHours}h')),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(course.description, style: const TextStyle(height: 1.6)),
                  const SizedBox(height: 24),

                  // Learning Outcomes
                  if (course.learningOutcomes.isNotEmpty) ...[
                    const Text('What You\'ll Learn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...course.learningOutcomes.map((outcome) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(outcome)),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],

                  // Prerequisites
                  if (course.prerequisites.isNotEmpty) ...[
                    const Text('Prerequisites', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    ...course.prerequisites.map((prereq) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(prereq)),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // Enroll Button with Permission Check
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: _isCheckingPermission
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show permission status info if applicable
                  if (_permission != null && !_permission!.isApproved && !isEnrolled) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: _permission!.isPending
                            ? Colors.orange[50]
                            : (_permission!.isDenied ? Colors.red[50] : Colors.grey[100]),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _permission!.isPending
                              ? Colors.orange
                              : (_permission!.isDenied ? Colors.red : Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _permission!.isPending
                                ? Icons.pending
                                : (_permission!.isDenied ? Icons.cancel : Icons.info),
                            color: _permission!.isPending
                                ? Colors.orange
                                : (_permission!.isDenied ? Colors.red : Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _permission!.isPending
                                      ? 'Permission Requested'
                                      : (_permission!.isDenied
                                          ? 'Permission Denied'
                                          : 'Permission ${_permission!.status.displayName}'),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (_permission!.isDenied && _permission!.denialReason != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _permission!.denialReason!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  Row(
                    children: [
                      if (!isEnrolled && (_permission == null || !_permission!.isPending)) ...[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            Text(
                              course.formattedPrice,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: course.isFree ? Colors.green : AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        child: _isEnrolling
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _getButtonAction(isEnrolled),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: isEnrolled
                                      ? Colors.green
                                      : (_permission?.isPending == true ? Colors.orange : null),
                                ),
                                child: Text(_getButtonText(isEnrolled, enrollment)),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  VoidCallback? _getButtonAction(bool isEnrolled) {
    if (isEnrolled) return null;
    if (widget.course.isFull) return null;
    if (_permission?.isPending == true) return null;

    // Check if permission is approved or doesn't exist (need to request)
    if (_permission == null || _permission!.isDenied || _permission!.isRevoked) {
      return _requestPermission;
    }

    if (_permission!.isApproved) {
      return _enrollInCourse;
    }

    return null;
  }

  String _getButtonText(bool isEnrolled, dynamic enrollment) {
    if (isEnrolled) {
      return 'Enrolled${enrollment?.progressPercentage != null && enrollment!.progressPercentage > 0 ? " (${enrollment.progressPercentage.toStringAsFixed(0)}%)" : ""}';
    }

    if (widget.course.isFull) return 'Course Full';

    if (_permission == null) {
      return 'Request Permission';
    }

    if (_permission!.isPending) {
      return 'Permission Pending';
    }

    if (_permission!.isDenied || _permission!.isRevoked) {
      return 'Request Permission Again';
    }

    if (_permission!.isApproved) {
      return 'Enroll Now';
    }

    return 'Request Permission';
  }

  Future<void> _requestPermission() async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Enrollment Permission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Request permission to enroll in "${widget.course.title}"?'),
            const SizedBox(height: 8),
            const Text(
              'The institution will review your request.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Message to institution (optional)',
                hintText: 'Why do you want to take this course?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Request'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      setState(() => _isEnrolling = true);

      try {
        final accessToken = ref.read(authProvider).accessToken;
        final apiService = EnrollmentPermissionsApiService(accessToken: accessToken);

        await apiService.requestPermission(
          widget.course.id,
          notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Permission request sent!'),
              backgroundColor: Colors.green,
            ),
          );

          // Refresh permission status
          await _checkPermission();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to request permission: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isEnrolling = false);
        }
      }
    }

    notesController.dispose();
  }

  Future<void> _enrollInCourse() async {
    setState(() => _isEnrolling = true);

    try {
      final enrollment = await ref
          .read(enrollmentsProvider.notifier)
          .enrollInCourse(widget.course.id);

      if (enrollment != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully enrolled in course!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(enrollmentsProvider).error ?? 'Failed to enroll'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isEnrolling = false);
      }
    }
  }
}
