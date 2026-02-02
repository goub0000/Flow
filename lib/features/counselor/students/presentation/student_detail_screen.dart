import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/counseling_models.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../providers/counselor_students_provider.dart';

class StudentDetailScreen extends ConsumerStatefulWidget {
  final StudentRecord student;

  const StudentDetailScreen({
    super.key,
    required this.student,
  });

  @override
  ConsumerState<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends ConsumerState<StudentDetailScreen>
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
          tooltip: context.l10n.counselorStudentBack,
        ),
        title: Text(widget.student.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: () {
              // TODO: Add notes
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.counselorStudentAddNotesComingSoon)),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.counselorStudentOverview),
            Tab(text: context.l10n.counselorStudentSessions),
            Tab(text: context.l10n.counselorStudentNotes),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildSessionsTab(),
          _buildNotesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Schedule session
          _showScheduleDialog();
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.counselorStudentScheduleSession),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          CustomCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    widget.student.initials,
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student.name,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.student.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.student.grade,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Academic Performance
          Text(
            context.l10n.counselorStudentAcademicPerformance,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.school,
                  label: context.l10n.counselorStudentGpa,
                  value: widget.student.gpa.toStringAsFixed(2),
                  color: _getGPAColor(widget.student.gpa),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  icon: Icons.event,
                  label: context.l10n.counselorStudentSessions,
                  value: '${widget.student.totalSessions}',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Interests
          Text(
            context.l10n.counselorStudentInterests,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.student.interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  labelStyle: const TextStyle(color: AppColors.primary),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Strengths
          Text(
            context.l10n.counselorStudentStrengths,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: widget.student.strengths.map((strength) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 20,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          strength,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Challenges
          Text(
            context.l10n.counselorStudentAreasForGrowth,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: widget.student.challenges.map((challenge) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 20,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          challenge,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSessionsTab() {
    // TODO: Fetch session history for this student from backend API
    final sessions = <CounselingSession>[]; // No mock data

    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.counselorStudentNoSessionsYet,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.counselorStudentScheduleSessionPrompt,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatSessionType(session.type),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(session.scheduledDate),
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
                    _StatusChip(status: session.status),
                  ],
                ),
                if (session.summary != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    session.summary!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (session.actionItems != null &&
                    session.actionItems!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...session.actionItems!.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.arrow_right,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.note_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.counselorStudentNoNotesYet,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.counselorStudentAddPrivateNotes,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add note
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.counselorStudentAddNotesComingSoon)),
                );
              },
              icon: const Icon(Icons.add),
              label: Text(context.l10n.counselorStudentAddNote),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGPAColor(double gpa) {
    if (gpa >= 3.7) return AppColors.success;
    if (gpa >= 3.0) return AppColors.info;
    if (gpa >= 2.5) return AppColors.warning;
    return AppColors.error;
  }

  String _formatSessionType(String type) {
    switch (type) {
      case 'individual':
        return context.l10n.counselorStudentIndividualCounseling;
      case 'group':
        return context.l10n.counselorStudentGroupSession;
      case 'career':
        return context.l10n.counselorStudentCareerCounseling;
      case 'academic':
        return context.l10n.counselorStudentAcademicAdvising;
      case 'personal':
        return context.l10n.counselorStudentPersonalCounseling;
      default:
        return type;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.counselorStudentScheduleSession),
        content: Text(
          context.l10n.counselorStudentScheduleFeatureComingSoon,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.counselorStudentClose),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: color.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
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

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'scheduled':
        color = AppColors.info;
        label = context.l10n.counselorStudentScheduled;
        break;
      case 'completed':
        color = AppColors.success;
        label = context.l10n.counselorStudentCompleted;
        break;
      case 'cancelled':
        color = AppColors.error;
        label = context.l10n.counselorStudentCancelled;
        break;
      case 'no_show':
        color = AppColors.warning;
        label = context.l10n.counselorStudentNoShow;
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
