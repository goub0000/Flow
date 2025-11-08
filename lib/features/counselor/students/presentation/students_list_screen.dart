import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../providers/counselor_students_provider.dart';

class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  String _searchQuery = '';

  List<StudentRecord> get _filteredStudents {
    if (_searchQuery.isEmpty) {
      return ref.read(counselorStudentsListProvider);
    }

    return ref.read(counselorStudentsProvider.notifier).searchStudents(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(counselorStudentsLoadingProvider);
    final error = ref.watch(counselorStudentsErrorProvider);

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(counselorStudentsProvider.notifier).fetchStudents();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const LoadingIndicator(message: 'Loading students...');
    }

    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search students...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        // Students List
        Expanded(child: _buildStudentsList()),
      ],
    );
  }

  Widget _buildStudentsList() {
    final students = _filteredStudents;

    if (students.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        title: 'No Students Found',
        message: _searchQuery.isNotEmpty
            ? 'Try adjusting your search'
            : 'No students assigned yet',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(counselorStudentsProvider.notifier).fetchStudents();
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _StudentCard(
              student: student,
              onTap: () {
                context.go(
                  '/counselor/students/${student.id}',
                  extra: student,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final StudentRecord student;
  final VoidCallback onTap;

  const _StudentCard({
    required this.student,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LogoAvatar.user(
                photoUrl: student.photoUrl,
                initials: student.initials,
                size: 56,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.grade} • GPA: ${student.gpa}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.school,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            student.schoolName,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getGPAColor().withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      student.gpa.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getGPAColor(),
                          ),
                    ),
                    Text(
                      'GPA',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getGPAColor(),
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Quick Stats
          Row(
            children: [
              _StatChip(
                icon: Icons.event,
                label: '${student.totalSessions} sessions',
                color: AppColors.info,
              ),
              const SizedBox(width: 8),
              _StatChip(
                icon: Icons.access_time,
                label: _getLastSessionText(),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          if (student.interests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: student.interests.take(3).map((interest) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    interest,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getGPAColor() {
    if (student.gpa >= 3.7) return AppColors.success;
    if (student.gpa >= 3.0) return AppColors.info;
    if (student.gpa >= 2.5) return AppColors.warning;
    return AppColors.error;
  }

  String _getLastSessionText() {
    final difference = DateTime.now().difference(student.lastSessionDate);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }
}
