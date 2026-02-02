import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/counseling/models/counseling_models.dart';
import '../../../shared/counseling/widgets/counseling_widgets.dart';
import '../../../../core/l10n_extension.dart';
import '../../providers/institution_counselors_provider.dart';

/// Screen for managing counselors in institution dashboard
class CounselorsManagementScreen extends ConsumerStatefulWidget {
  const CounselorsManagementScreen({super.key});

  @override
  ConsumerState<CounselorsManagementScreen> createState() =>
      _CounselorsManagementScreenState();
}

class _CounselorsManagementScreenState
    extends ConsumerState<CounselorsManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(institutionCounselorsProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(institutionCounselorsProvider);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(institutionCounselorsProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: [
          // Stats section
          if (state.stats != null)
            SliverToBoxAdapter(
              child: _buildStatsSection(state.stats!, theme),
            ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: context.l10n.instCounselorSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(institutionCounselorsProvider.notifier)
                                .search('');
                          },
                        )
                      : null,
                ),
                onSubmitted: (value) {
                  ref
                      .read(institutionCounselorsProvider.notifier)
                      .search(value);
                },
              ),
            ),
          ),

          // Counselors list
          if (state.isLoading && state.counselors.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (state.error != null && state.counselors.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref
                          .read(institutionCounselorsProvider.notifier)
                          .refresh(),
                      child: Text(context.l10n.instCounselorRetry),
                    ),
                  ],
                ),
              ),
            )
          else if (state.counselors.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      context.l10n.instCounselorNoCounselorsFound,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.searchQuery.isNotEmpty
                          ? context.l10n.instCounselorNoMatchSearch
                          : context.l10n.instCounselorAddToInstitution,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final counselor = state.counselors[index];
                  return _CounselorCard(
                    counselor: counselor,
                    onTap: () => _showCounselorDetails(counselor),
                    onAssignStudents: () => _showAssignStudentsDialog(counselor),
                  );
                },
                childCount: state.counselors.length,
              ),
            ),

          // Pagination
          if (state.totalPages > 1)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: state.currentPage > 1
                          ? () => ref
                              .read(institutionCounselorsProvider.notifier)
                              .previousPage()
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      context.l10n.instCounselorPageOf(state.currentPage, state.totalPages),
                      style: theme.textTheme.bodyMedium,
                    ),
                    IconButton(
                      onPressed: state.currentPage < state.totalPages
                          ? () => ref
                              .read(institutionCounselorsProvider.notifier)
                              .nextPage()
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Map<String, dynamic> stats, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.instCounselorCounselingOverview,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                context.l10n.instCounselorCounselors,
                '${stats['total_counselors'] ?? 0}',
                Icons.people,
                AppColors.primary,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context.l10n.instCounselorStudents,
                '${stats['total_students_assigned'] ?? 0}',
                Icons.school,
                Colors.blue,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context.l10n.instCounselorSessions,
                '${stats['total_sessions'] ?? 0}',
                Icons.calendar_month,
                Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                context.l10n.instCounselorCompleted,
                '${stats['completed_sessions'] ?? 0}',
                Icons.check_circle,
                Colors.green,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context.l10n.instCounselorUpcoming,
                '${stats['upcoming_sessions'] ?? 0}',
                Icons.schedule,
                Colors.purple,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                context.l10n.instCounselorAvgRating,
                stats['average_rating'] != null
                    ? (stats['average_rating'] as num).toStringAsFixed(1)
                    : '-',
                Icons.star,
                Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCounselorDetails(InstitutionCounselor counselor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _CounselorDetailsSheet(
          counselor: counselor,
          scrollController: scrollController,
          onAssignStudents: () {
            Navigator.pop(context);
            _showAssignStudentsDialog(counselor);
          },
        ),
      ),
    );
  }

  void _showAssignStudentsDialog(InstitutionCounselor counselor) {
    showDialog(
      context: context,
      builder: (context) => _AssignStudentDialog(
        counselor: counselor,
        onAssign: (studentId) async {
          final success = await ref
              .read(institutionCounselorsProvider.notifier)
              .assignCounselor(
                counselorId: counselor.id,
                studentId: studentId,
              );
          if (success && mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.instCounselorStudentAssigned)),
            );
          }
        },
      ),
    );
  }
}

/// Counselor card widget
class _CounselorCard extends StatelessWidget {
  final InstitutionCounselor counselor;
  final VoidCallback onTap;
  final VoidCallback onAssignStudents;

  const _CounselorCard({
    required this.counselor,
    required this.onTap,
    required this.onAssignStudents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      counselor.name.isNotEmpty
                          ? counselor.name[0].toUpperCase()
                          : 'C',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          counselor.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          counselor.email,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (counselor.averageRating != null)
                    RatingStars(rating: counselor.averageRating, size: 14),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  _buildMetric(Icons.people, '${counselor.assignedStudents}', context.l10n.instCounselorStudents),
                  const SizedBox(width: 24),
                  _buildMetric(Icons.calendar_month, '${counselor.totalSessions}', context.l10n.instCounselorSessions),
                  const SizedBox(width: 24),
                  _buildMetric(Icons.check_circle, '${counselor.completedSessions}', context.l10n.instCounselorCompleted),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onAssignStudents,
                    icon: const Icon(Icons.person_add, size: 18),
                    label: Text(context.l10n.instCounselorAssign),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }
}

/// Counselor details bottom sheet
class _CounselorDetailsSheet extends StatelessWidget {
  final InstitutionCounselor counselor;
  final ScrollController scrollController;
  final VoidCallback onAssignStudents;

  const _CounselorDetailsSheet({
    required this.counselor,
    required this.scrollController,
    required this.onAssignStudents,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        // Handle
        Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Avatar and name
        Center(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              counselor.name.isNotEmpty ? counselor.name[0].toUpperCase() : 'C',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          counselor.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          counselor.email,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        if (counselor.averageRating != null)
          Center(child: RatingStars(rating: counselor.averageRating)),
        const SizedBox(height: 24),

        // Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStat(context.l10n.instCounselorStudents, '${counselor.assignedStudents}'),
            _buildStat(context.l10n.instCounselorTotalSessions, '${counselor.totalSessions}'),
            _buildStat(context.l10n.instCounselorCompleted, '${counselor.completedSessions}'),
          ],
        ),
        const SizedBox(height: 24),

        // Assign button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onAssignStudents,
            icon: const Icon(Icons.person_add),
            label: Text(context.l10n.instCounselorAssignStudents),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

/// Dialog for assigning students to a counselor
class _AssignStudentDialog extends ConsumerStatefulWidget {
  final InstitutionCounselor counselor;
  final Function(String studentId) onAssign;

  const _AssignStudentDialog({
    required this.counselor,
    required this.onAssign,
  });

  @override
  ConsumerState<_AssignStudentDialog> createState() =>
      _AssignStudentDialogState();
}

class _AssignStudentDialogState extends ConsumerState<_AssignStudentDialog> {
  final _searchController = TextEditingController();
  String? _selectedStudentId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(
      institutionStudentsProvider(_searchController.text.isEmpty
          ? null
          : _searchController.text),
    );

    return AlertDialog(
      title: Text(context.l10n.instCounselorAssignStudentTo(widget.counselor.name)),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.instCounselorSearchStudents,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: studentsAsync.when(
                data: (students) {
                  if (students.isEmpty) {
                    return Center(
                      child: Text(context.l10n.instCounselorNoStudentsFound),
                    );
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final isSelected = _selectedStudentId == student['id'];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            (student['name'] as String? ?? 'S')[0].toUpperCase(),
                          ),
                        ),
                        title: Text(student['name'] ?? 'Unknown'),
                        subtitle: Text(student['email'] ?? ''),
                        selected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedStudentId = student['id'];
                          });
                        },
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.instCounselorCancel),
        ),
        ElevatedButton(
          onPressed: _selectedStudentId != null
              ? () => widget.onAssign(_selectedStudentId!)
              : null,
          child: Text(context.l10n.instCounselorAssign),
        ),
      ],
    );
  }
}
