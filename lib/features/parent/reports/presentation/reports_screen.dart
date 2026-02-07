// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/parent_children_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.parentReportBack,
        ),
        title: Text(context.l10n.parentReportAcademicReports),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.parentReportProgress),
            Tab(text: context.l10n.parentReportGrades),
            Tab(text: context.l10n.parentReportAttendance),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProgressReportsTab(),
          _buildGradeReportsTab(),
          _buildAttendanceReportsTab(),
        ],
      ),
    );
  }

  Widget _buildProgressReportsTab() {
    final children = ref.watch(parentChildrenListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.l10n.parentReportStudentProgressReports,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.parentReportTrackProgress,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),
        if (children.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.assessment_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.parentReportNoProgressData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.parentReportAddChildrenProgress,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...children.map((child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            child.initials,
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                child.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                child.grade,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getGradeColor(child.averageGrade)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${child.averageGrade.toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: _getGradeColor(child.averageGrade),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    _ProgressMetric(
                      label: context.l10n.parentReportCoursesEnrolled,
                      value: child.enrolledCourses.length.toString(),
                      icon: Icons.book_outlined,
                    ),
                    const SizedBox(height: 12),
                    _ProgressMetric(
                      label: context.l10n.parentReportApplications,
                      value: child.applications.length.toString(),
                      icon: Icons.description_outlined,
                    ),
                    const SizedBox(height: 12),
                    _ProgressMetric(
                      label: context.l10n.parentReportOverallProgress,
                      value: '${(child.averageGrade * 0.85).toStringAsFixed(0)}%',
                      icon: Icons.trending_up,
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildGradeReportsTab() {
    final children = ref.watch(parentChildrenListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.l10n.parentReportGradeReports,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.parentReportGradeBreakdown,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),
        if (children.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.grade_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.parentReportNoGradeData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.parentReportAddChildrenGrades,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...children.map((child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            child.initials,
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            child.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Mock grade data
                    ..._buildMockGrades(child),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  List<Widget> _buildMockGrades(child) {
    final mockSubjects = [
      {'subject': context.l10n.parentReportMathematics, 'grade': 92.0},
      {'subject': context.l10n.parentReportEnglish, 'grade': 88.0},
      {'subject': context.l10n.parentReportScience, 'grade': 90.0},
      {'subject': context.l10n.parentReportHistory, 'grade': 85.0},
    ];

    return mockSubjects.map((data) {
      final grade = data['grade'] as double;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                data['subject'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getGradeColor(grade).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${grade.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: _getGradeColor(grade),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAttendanceReportsTab() {
    final children = ref.watch(parentChildrenListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          context.l10n.parentReportAttendanceReports,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.parentReportTrackAttendance,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),
        if (children.isEmpty)
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(
                    Icons.event_available_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.parentReportNoAttendanceData,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.parentReportAddChildrenAttendance,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ...children.map((child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            child.initials,
                            style: const TextStyle(
                              color: AppColors.textOnPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            child.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Mock attendance data
                    Row(
                      children: [
                        Expanded(
                          child: _AttendanceMetric(
                            label: context.l10n.parentReportPresent,
                            value: '95%',
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AttendanceMetric(
                            label: context.l10n.parentReportLate,
                            value: '3%',
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _AttendanceMetric(
                            label: context.l10n.parentReportAbsent,
                            value: '2%',
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.parentReportThisMonth('20', '21'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 90) return AppColors.success;
    if (grade >= 75) return AppColors.info;
    if (grade >= 60) return AppColors.warning;
    return AppColors.error;
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}

class _AttendanceMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _AttendanceMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
