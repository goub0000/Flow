import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/providers/admin_assessments_provider.dart';
import '../../shared/providers/admin_course_list_provider.dart';
import '../../shared/utils/debouncer.dart';

/// Assessments Management Screen - Manage quizzes and assignments across all courses
class AssessmentsManagementScreen extends ConsumerStatefulWidget {
  const AssessmentsManagementScreen({super.key});

  @override
  ConsumerState<AssessmentsManagementScreen> createState() =>
      _AssessmentsManagementScreenState();
}

class _AssessmentsManagementScreenState
    extends ConsumerState<AssessmentsManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedType = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(),
        const SizedBox(height: 24),
        _buildFiltersSection(),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: _buildDataTable(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.quiz, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Assessments Management',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage quizzes and assignments across all courses',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(adminAssessmentsProvider.notifier).fetchAssessments();
                },
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('Refresh'),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showCreateAssessmentDialog,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Create Assessment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateAssessmentDialog() {
    final lessonTitleController = TextEditingController();
    final titleController = TextEditingController();
    final instructionsController = TextEditingController();
    final pointsController = TextEditingController(text: '100');
    final passingScoreController = TextEditingController(text: '70');
    String selectedType = 'quiz';
    String? selectedCourseId;
    String? selectedModuleId;
    List<ModuleListItem> modules = [];
    bool isCreating = false;
    bool isLoadingModules = false;

    ref.read(adminCourseListProvider.notifier).fetchCourses();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final courseListState = ref.watch(adminCourseListProvider);

          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.add_circle, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text('Create New Assessment'),
              ],
            ),
            content: SizedBox(
              width: 550,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Assessment type
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Assessment Type *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'quiz', child: Text('Quiz')),
                        DropdownMenuItem(
                            value: 'assignment', child: Text('Assignment')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Course selector
                    DropdownButtonFormField<String>(
                      value: selectedCourseId,
                      decoration: InputDecoration(
                        labelText: 'Course *',
                        hintText: courseListState.isLoading
                            ? 'Loading courses...'
                            : 'Select a course',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: courseListState.courses
                          .map((c) => DropdownMenuItem(
                                value: c.id,
                                child: Text(c.title,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) async {
                        setDialogState(() {
                          selectedCourseId = value;
                          selectedModuleId = null;
                          modules = [];
                          isLoadingModules = true;
                        });
                        if (value != null) {
                          final fetched = await ref
                              .read(adminCourseListProvider.notifier)
                              .fetchModules(value);
                          setDialogState(() {
                            modules = fetched;
                            isLoadingModules = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    // Module selector
                    DropdownButtonFormField<String>(
                      value: selectedModuleId,
                      decoration: InputDecoration(
                        labelText: 'Module *',
                        hintText: isLoadingModules
                            ? 'Loading modules...'
                            : selectedCourseId == null
                                ? 'Select a course first'
                                : modules.isEmpty
                                    ? 'No modules in this course'
                                    : 'Select a module',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: modules
                          .map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.title,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedModuleId = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: lessonTitleController,
                      decoration: InputDecoration(
                        labelText: 'Lesson Title *',
                        hintText: 'Enter lesson title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText:
                            '${selectedType == 'quiz' ? 'Quiz' : 'Assignment'} Title *',
                        hintText: 'Enter title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Type-specific fields
                    if (selectedType == 'quiz') ...[
                      TextField(
                        controller: passingScoreController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Passing Score (%)',
                          hintText: '70',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ] else ...[
                      TextField(
                        controller: instructionsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Instructions *',
                          hintText: 'Enter assignment instructions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: pointsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Points Possible',
                          hintText: '100',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      selectedType == 'quiz'
                          ? 'Quiz will be created as a draft. Add questions in the Course Builder.'
                          : 'Assignment will be created as a draft. Configure details in the Course Builder.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isCreating ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isCreating
                    ? null
                    : () async {
                        if (selectedCourseId == null ||
                            selectedModuleId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Please select course and module'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (lessonTitleController.text.trim().isEmpty ||
                            titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Please fill in all required fields'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (selectedType == 'assignment' &&
                            instructionsController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Please enter assignment instructions'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isCreating = true);

                        final success = await ref
                            .read(adminAssessmentsProvider.notifier)
                            .createAssessment(
                              assessmentType: selectedType,
                              courseId: selectedCourseId!,
                              moduleId: selectedModuleId!,
                              lessonTitle:
                                  lessonTitleController.text.trim(),
                              title: titleController.text.trim(),
                              passingScore: selectedType == 'quiz'
                                  ? double.tryParse(
                                      passingScoreController.text.trim())
                                  : null,
                              instructions: selectedType == 'assignment'
                                  ? instructionsController.text.trim()
                                  : null,
                              pointsPossible: selectedType == 'assignment'
                                  ? int.tryParse(
                                      pointsController.text.trim())
                                  : null,
                            );

                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success
                                  ? '${selectedType == 'quiz' ? 'Quiz' : 'Assignment'} created'
                                  : 'Failed to create assessment'),
                              backgroundColor:
                                  success ? AppColors.success : AppColors.error,
                            ),
                          );
                        }
                      },
                child: isCreating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    final stats = ref.watch(adminAssessmentsStatsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Assessments',
              stats.totalAssessments.toString(),
              'All assessments',
              Icons.assignment,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Quizzes',
              stats.quizCount.toString(),
              'Auto-graded',
              Icons.quiz,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Assignments',
              stats.assignmentCount.toString(),
              'Manual grading',
              Icons.edit_document,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pending Grading',
              stats.pendingGrading.toString(),
              'Awaiting review',
              Icons.pending_actions,
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search assessments by title...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                _searchDebouncer.call(() {
                  setState(() => _searchQuery = value.toLowerCase());
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: 'Assessment Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'quiz', child: Text('Quiz')),
                DropdownMenuItem(value: 'assignment', child: Text('Assignment')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final assessmentsState = ref.watch(adminAssessmentsProvider);
    final isLoading = assessmentsState.isLoading;

    var items = assessmentsState.assessments.map((a) {
      return AssessmentRowData(
        id: a.id,
        assessmentType: a.assessmentType,
        title: a.title,
        courseTitle: a.courseTitle ?? '-',
        courseId: a.courseId ?? '',
        questionCount: a.questionCount,
        attemptCount: a.attemptCount,
        averageScore: a.averageScore,
        passRate: a.passRate,
        submissionCount: a.submissionCount,
        gradedCount: a.gradedCount,
        averageGrade: a.averageGrade,
        dueDate: a.dueDate,
        lastUpdated: _formatDate(a.updatedAt ?? a.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) {
        return item.title.toLowerCase().contains(_searchQuery) ||
            item.courseTitle.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply type filter
    if (_selectedType != 'all') {
      items = items.where((item) => item.assessmentType == _selectedType).toList();
    }

    return AdminDataTable<AssessmentRowData>(
      columns: [
        DataTableColumn(
          label: 'Title',
          cellBuilder: (item) => Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (item) => _buildTypeChip(item.assessmentType),
        ),
        DataTableColumn(
          label: 'Course',
          cellBuilder: (item) => Text(
            item.courseTitle,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: 'Questions / Submissions',
          cellBuilder: (item) => Text(
            item.assessmentType == 'quiz'
                ? '${item.questionCount} questions (${item.attemptCount} attempts)'
                : '${item.submissionCount} submissions (${item.gradedCount} graded)',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        DataTableColumn(
          label: 'Score / Grade',
          cellBuilder: (item) => Text(
            item.assessmentType == 'quiz'
                ? item.passRate != null
                    ? '${item.passRate!.toStringAsFixed(1)}% pass'
                    : '-'
                : item.averageGrade != null
                    ? '${item.averageGrade!.toStringAsFixed(1)}% avg'
                    : '-',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        DataTableColumn(
          label: 'Updated',
          cellBuilder: (item) => Text(
            item.lastUpdated,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          sortable: true,
        ),
      ],
      data: items,
      isLoading: isLoading,
      onRowTap: (item) => _showAssessmentDetails(item),
      rowActions: [
        DataTableAction(
          icon: Icons.bar_chart,
          tooltip: 'View Stats',
          onPressed: (item) => _showAssessmentDetails(item),
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit in Course Builder',
          color: AppColors.primary,
          onPressed: (item) {
            if (item.courseId.isNotEmpty) {
              context.go('/admin/content/${item.courseId}/edit');
            }
          },
        ),
      ],
    );
  }

  Widget _buildTypeChip(String type) {
    final isQuiz = type == 'quiz';
    final color = isQuiz ? Colors.blue : Colors.orange;
    final icon = isQuiz ? Icons.quiz : Icons.edit_document;
    final label = isQuiz ? 'Quiz' : 'Assignment';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showAssessmentDetails(AssessmentRowData item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              item.assessmentType == 'quiz' ? Icons.quiz : Icons.edit_document,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(item.title, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Type',
                item.assessmentType == 'quiz' ? 'Quiz' : 'Assignment',
              ),
              _buildDetailRow('Course', item.courseTitle),
              if (item.assessmentType == 'quiz') ...[
                _buildDetailRow('Questions', item.questionCount.toString()),
                _buildDetailRow('Attempts', item.attemptCount.toString()),
                if (item.averageScore != null)
                  _buildDetailRow(
                    'Average Score',
                    '${item.averageScore!.toStringAsFixed(1)}%',
                  ),
                if (item.passRate != null)
                  _buildDetailRow(
                    'Pass Rate',
                    '${item.passRate!.toStringAsFixed(1)}%',
                  ),
              ] else ...[
                _buildDetailRow('Submissions', item.submissionCount.toString()),
                _buildDetailRow('Graded', item.gradedCount.toString()),
                _buildDetailRow(
                  'Pending',
                  (item.submissionCount - item.gradedCount).toString(),
                ),
                if (item.averageGrade != null)
                  _buildDetailRow(
                    'Average Grade',
                    '${item.averageGrade!.toStringAsFixed(1)}%',
                  ),
                if (item.dueDate != null)
                  _buildDetailRow('Due Date', item.dueDate!),
              ],
              _buildDetailRow('Last Updated', item.lastUpdated),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (item.courseId.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.go('/admin/content/${item.courseId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit in Course Builder'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} months ago';
    return '${(diff.inDays / 365).floor()} years ago';
  }
}

/// Row data model for the assessments table
class AssessmentRowData {
  final String id;
  final String assessmentType;
  final String title;
  final String courseTitle;
  final String courseId;
  final int questionCount;
  final int attemptCount;
  final double? averageScore;
  final double? passRate;
  final int submissionCount;
  final int gradedCount;
  final double? averageGrade;
  final String? dueDate;
  final String lastUpdated;

  AssessmentRowData({
    required this.id,
    required this.assessmentType,
    required this.title,
    required this.courseTitle,
    required this.courseId,
    required this.questionCount,
    required this.attemptCount,
    this.averageScore,
    this.passRate,
    required this.submissionCount,
    required this.gradedCount,
    this.averageGrade,
    this.dueDate,
    required this.lastUpdated,
  });
}
