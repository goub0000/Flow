import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../providers/enrollments_provider.dart';

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

      // Enroll Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            if (!isEnrolled) ...[
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
                      onPressed: isEnrolled
                          ? null
                          : (course.isFull ? null : _enrollInCourse),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: isEnrolled ? Colors.green : null,
                      ),
                      child: Text(
                        isEnrolled
                            ? 'Enrolled${enrollment?.progressPercentage != null && enrollment!.progressPercentage > 0 ? " (${enrollment.progressPercentage.toStringAsFixed(0)}%)" : ""}'
                            : (course.isFull ? 'Course Full' : 'Enroll Now'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
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
