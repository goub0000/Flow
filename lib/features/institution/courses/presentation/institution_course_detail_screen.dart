import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';

/// Institution Course Detail Screen
/// Shows course details with management options for institutions
class InstitutionCourseDetailScreen extends ConsumerWidget {
  final Course course;

  const InstitutionCourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit Course',
                onPressed: () {
                  context.push('/institution/courses/${course.id}/edit', extra: course);
                },
              ),
            ],
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
                  // Status Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: course.isPublished ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          course.isPublished ? 'Published' : course.status.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (course.enrolledCount != null && course.enrolledCount! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${course.enrolledCount} Enrolled',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Meta Info
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(course.level.displayName)),
                      Chip(label: Text(course.courseType.displayName)),
                      if (course.durationHours != null)
                        Chip(label: Text('${course.durationHours}h')),
                      Chip(label: Text(course.formattedPrice)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.menu_book,
                          title: 'Content',
                          subtitle: 'Manage course content',
                          onTap: () {
                            context.push('/institution/courses/${course.id}/content', extra: course);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.security,
                          title: 'Permissions',
                          subtitle: 'Manage student access',
                          onTap: () {
                            context.push('/institution/courses/${course.id}/permissions', extra: course);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.edit,
                          title: 'Edit',
                          subtitle: 'Update course details',
                          onTap: () {
                            context.push('/institution/courses/${course.id}/edit', extra: course);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ActionCard(
                          icon: Icons.people,
                          title: 'Enrollments',
                          subtitle: 'View enrolled students',
                          onTap: () {
                            context.push('/institution/courses/${course.id}/enrollments', extra: course);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(course.description, style: const TextStyle(height: 1.6)),
                  const SizedBox(height: 24),

                  // Learning Outcomes
                  if (course.learningOutcomes.isNotEmpty) ...[
                    const Text('Learning Outcomes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    const SizedBox(height: 24),
                  ],

                  // Course Stats
                  const Text('Statistics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _StatRow(
                            label: 'Enrolled Students',
                            value: '${course.enrolledCount ?? 0}${course.maxStudents != null ? " / ${course.maxStudents}" : ""}',
                          ),
                          const Divider(),
                          _StatRow(
                            label: 'Price',
                            value: course.formattedPrice,
                          ),
                          const Divider(),
                          _StatRow(
                            label: 'Duration',
                            value: course.durationHours != null ? '${course.durationHours} hours' : 'Not specified',
                          ),
                          const Divider(),
                          _StatRow(
                            label: 'Category',
                            value: course.category ?? 'Uncategorized',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: AppColors.primary),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
