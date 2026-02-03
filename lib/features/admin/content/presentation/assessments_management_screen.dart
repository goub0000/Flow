import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
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
                    context.l10n.adminContentAssessmentsManagement,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminContentManageQuizzesAndAssignments,
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
                label: Text(context.l10n.adminContentRefresh),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _showCreateAssessmentDialog,
                icon: const Icon(Icons.add, size: 20),
                label: Text(context.l10n.adminContentCreateAssessment),
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
                Text(context.l10n.adminContentCreateNewAssessment),
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
                        labelText: context.l10n.adminContentAssessmentTypeRequired,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(value: 'quiz', child: Text(context.l10n.adminContentQuiz)),
                        DropdownMenuItem(
                            value: 'assignment', child: Text(context.l10n.adminContentAssignment)),
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
                        labelText: context.l10n.adminContentCourseRequired,
                        hintText: courseListState.isLoading
                            ? context.l10n.adminContentLoadingCourses
                            : context.l10n.adminContentSelectACourse,
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
                        labelText: context.l10n.adminContentModuleRequired,
                        hintText: isLoadingModules
                            ? context.l10n.adminContentLoadingModules
                            : selectedCourseId == null
                                ? context.l10n.adminContentSelectACourseFirst
                                : modules.isEmpty
                                    ? context.l10n.adminContentNoModulesInCourse
                                    : context.l10n.adminContentSelectAModule,
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
                        labelText: context.l10n.adminContentLessonTitleRequired,
                        hintText: context.l10n.adminContentEnterLessonTitle,
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
                            '${selectedType == 'quiz' ? context.l10n.adminContentQuiz : context.l10n.adminContentAssignment} ${context.l10n.adminContentTitleRequired}',
                        hintText: context.l10n.adminContentEnterTitle,
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
                          labelText: context.l10n.adminContentPassingScorePercent,
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
                          labelText: context.l10n.adminContentInstructionsRequired,
                          hintText: context.l10n.adminContentEnterAssignmentInstructions,
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
                          labelText: context.l10n.adminContentPointsPossible,
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
                          ? context.l10n.adminContentQuizDraftNotice
                          : context.l10n.adminContentAssignmentDraftNotice,
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
                child: Text(context.l10n.adminContentCancel),
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
                                  Text(context.l10n.adminContentPleaseSelectCourseAndModule),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (lessonTitleController.text.trim().isEmpty ||
                            titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  context.l10n.adminContentPleaseFillRequiredFields),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        if (selectedType == 'assignment' &&
                            instructionsController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  context.l10n.adminContentPleaseEnterInstructions),
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
                                  ? context.l10n.adminContentAssessmentCreated(selectedType == 'quiz' ? context.l10n.adminContentQuiz : context.l10n.adminContentAssignment)
                                  : context.l10n.adminContentFailedToCreateAssessment),
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
                    : Text(context.l10n.adminContentCreate),
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
              context.l10n.adminContentTotalAssessments,
              stats.totalAssessments.toString(),
              context.l10n.adminContentAllAssessments,
              Icons.assignment,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentQuizzes,
              stats.quizCount.toString(),
              context.l10n.adminContentAutoGraded,
              Icons.quiz,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentAssignments,
              stats.assignmentCount.toString(),
              context.l10n.adminContentManualGrading,
              Icons.edit_document,
              Colors.orange,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminContentPendingGrading,
              stats.pendingGrading.toString(),
              context.l10n.adminContentAwaitingReview,
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
                hintText: context.l10n.adminContentSearchAssessments,
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
                labelText: context.l10n.adminContentAssessmentType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminContentAllTypes)),
                DropdownMenuItem(value: 'quiz', child: Text(context.l10n.adminContentQuiz)),
                DropdownMenuItem(value: 'assignment', child: Text(context.l10n.adminContentAssignment)),
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
          label: context.l10n.adminContentTitleLabel,
          cellBuilder: (item) => Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: context.l10n.adminContentTypeLabel,
          cellBuilder: (item) => _buildTypeChip(item.assessmentType),
        ),
        DataTableColumn(
          label: context.l10n.adminContentCourseLabel,
          cellBuilder: (item) => Text(
            item.courseTitle,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentQuestionsSubmissions,
          cellBuilder: (item) => Text(
            item.assessmentType == 'quiz'
                ? context.l10n.adminContentQuestionsAttempts(item.questionCount, item.attemptCount)
                : context.l10n.adminContentSubmissionsGraded(item.submissionCount, item.gradedCount),
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentScoreGrade,
          cellBuilder: (item) => Text(
            item.assessmentType == 'quiz'
                ? item.passRate != null
                    ? context.l10n.adminContentPassRate(item.passRate!.toStringAsFixed(1))
                    : '-'
                : item.averageGrade != null
                    ? context.l10n.adminContentAvgGrade(item.averageGrade!.toStringAsFixed(1))
                    : '-',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ),
        DataTableColumn(
          label: context.l10n.adminContentUpdated,
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
          tooltip: context.l10n.adminContentViewStats,
          onPressed: (item) => _showAssessmentDetails(item),
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: context.l10n.adminContentEditInCourseBuilder,
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
    final label = isQuiz ? context.l10n.adminContentQuiz : context.l10n.adminContentAssignment;

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
                context.l10n.adminContentTypeLabel,
                item.assessmentType == 'quiz' ? context.l10n.adminContentQuiz : context.l10n.adminContentAssignment,
              ),
              _buildDetailRow(context.l10n.adminContentCourseLabel, item.courseTitle),
              if (item.assessmentType == 'quiz') ...[
                _buildDetailRow(context.l10n.adminContentQuestions, item.questionCount.toString()),
                _buildDetailRow(context.l10n.adminContentAttempts, item.attemptCount.toString()),
                if (item.averageScore != null)
                  _buildDetailRow(
                    context.l10n.adminContentAverageScore,
                    '${item.averageScore!.toStringAsFixed(1)}%',
                  ),
                if (item.passRate != null)
                  _buildDetailRow(
                    context.l10n.adminContentPassRateLabel,
                    '${item.passRate!.toStringAsFixed(1)}%',
                  ),
              ] else ...[
                _buildDetailRow(context.l10n.adminContentSubmissions, item.submissionCount.toString()),
                _buildDetailRow(context.l10n.adminContentGraded, item.gradedCount.toString()),
                _buildDetailRow(
                  context.l10n.adminContentPending,
                  (item.submissionCount - item.gradedCount).toString(),
                ),
                if (item.averageGrade != null)
                  _buildDetailRow(
                    context.l10n.adminContentAverageGrade,
                    '${item.averageGrade!.toStringAsFixed(1)}%',
                  ),
                if (item.dueDate != null)
                  _buildDetailRow(context.l10n.adminContentDueDate, item.dueDate!),
              ],
              _buildDetailRow(context.l10n.adminContentLastUpdated, item.lastUpdated),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminContentClose),
          ),
          if (item.courseId.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.go('/admin/content/${item.courseId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: Text(context.l10n.adminContentEditInCourseBuilder),
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

    if (diff.inDays == 0) return context.l10n.adminContentToday;
    if (diff.inDays == 1) return context.l10n.adminContentYesterday;
    if (diff.inDays < 7) return context.l10n.adminContentDaysAgo(diff.inDays);
    if (diff.inDays < 30) return context.l10n.adminContentWeeksAgo((diff.inDays / 7).floor());
    if (diff.inDays < 365) return context.l10n.adminContentMonthsAgo((diff.inDays / 30).floor());
    return context.l10n.adminContentYearsAgo((diff.inDays / 365).floor());
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
