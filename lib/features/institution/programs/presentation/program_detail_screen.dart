import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/program_model.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../../core/l10n_extension.dart';
import '../../providers/institution_programs_provider.dart';

class ProgramDetailScreen extends ConsumerStatefulWidget {
  final Program program;

  const ProgramDetailScreen({
    super.key,
    required this.program,
  });

  @override
  ConsumerState<ProgramDetailScreen> createState() => _ProgramDetailScreenState();
}

class _ProgramDetailScreenState extends ConsumerState<ProgramDetailScreen> {
  late Program _program;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _program = widget.program;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: context.l10n.instProgramBack,
        ),
        title: Text(context.l10n.instProgramDetails),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                // TODO: Navigate to edit program
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.instProgramEditComingSoon)),
                );
              } else if (value == 'toggle_status') {
                _toggleProgramStatus();
              } else if (value == 'delete') {
                _confirmDelete();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit, size: 20),
                    const SizedBox(width: 8),
                    Text(context.l10n.instProgramEditProgram),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_status',
                child: Row(
                  children: [
                    Icon(
                      _program.isActive ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(_program.isActive ? context.l10n.instProgramDeactivate : context.l10n.instProgramActivate),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, size: 20, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text(context.l10n.instProgramDeleteProgram),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            if (!_program.isActive)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.instProgramInactiveMessage,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),

            // Program Header
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _program.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _program.level.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Stats
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.people,
                    label: context.l10n.instProgramEnrolled,
                    value: '${_program.enrolledStudents}',
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.event_seat,
                    label: context.l10n.instProgramAvailable,
                    value: '${_program.availableSlots}',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.attach_money,
                    label: context.l10n.instProgramFee,
                    value: '\$${_program.fee.toStringAsFixed(0)}',
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer,
                    label: context.l10n.instProgramDuration,
                    value: _formatDuration(_program.duration),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              context.l10n.instProgramDescription,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Text(
                _program.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Program Details
            Text(
              context.l10n.instProgramProgramDetails,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.category,
                    label: context.l10n.instProgramCategory,
                    value: _program.category,
                  ),
                  const Divider(),
                  _DetailRow(
                    icon: Icons.school,
                    label: context.l10n.instProgramInstitution,
                    value: _program.institutionName,
                  ),
                  const Divider(),
                  _DetailRow(
                    icon: Icons.calendar_today,
                    label: context.l10n.instProgramStartDate,
                    value: _formatDate(_program.startDate),
                  ),
                  const Divider(),
                  _DetailRow(
                    icon: Icons.event,
                    label: context.l10n.instProgramApplicationDeadline,
                    value: _formatDate(_program.applicationDeadline),
                  ),
                  const Divider(),
                  _DetailRow(
                    icon: Icons.group,
                    label: context.l10n.instProgramMaxStudents,
                    value: '${_program.maxStudents}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Requirements
            Text(
              context.l10n.instProgramRequirements,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _program.requirements.map((req) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            req,
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

            // Enrollment Progress
            Text(
              context.l10n.instProgramEnrollmentStatus,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            CustomCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.instProgramFillRate,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${_program.fillPercentage.toStringAsFixed(1)}%',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _getEnrollmentColor(),
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: _program.fillPercentage / 100,
                      minHeight: 16,
                      backgroundColor: AppColors.surface,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_getEnrollmentColor()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _program.isFull
                        ? context.l10n.instProgramIsFull
                        : context.l10n.instProgramSlotsRemaining(_program.availableSlots),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEnrollmentColor() {
    if (_program.fillPercentage >= 90) return AppColors.error;
    if (_program.fillPercentage >= 70) return AppColors.warning;
    return AppColors.success;
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    if (days < 30) {
      return '$days days';
    } else if (days < 365) {
      final months = (days / 30).round();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (days / 365).round();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _toggleProgramStatus() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_program.isActive ? context.l10n.instProgramDeactivateQuestion : context.l10n.instProgramActivateQuestion),
        content: Text(
          _program.isActive
              ? context.l10n.instProgramStopAccepting
              : context.l10n.instProgramStartAccepting,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.instProgramCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              setState(() => _isProcessing = true);

              try {
                await ref.read(institutionProgramsProvider.notifier).toggleProgramStatus(_program.id);

                // Update local program state
                final updatedProgram = ref.read(institutionProgramsProvider.notifier).getProgramById(_program.id);
                if (updatedProgram != null && mounted) {
                  setState(() {
                    _program = updatedProgram;
                    _isProcessing = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _program.isActive
                            ? context.l10n.instProgramActivated
                            : context.l10n.instProgramDeactivated,
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isProcessing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.instProgramErrorUpdatingStatus(e.toString())),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: Text(context.l10n.instProgramConfirm),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instProgramDeleteProgramQuestion),
        content: Text(
          context.l10n.instProgramDeleteConfirm,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.instProgramCancel),
          ),
          ElevatedButton(
            onPressed: () async {
              context.pop();
              setState(() => _isProcessing = true);

              try {
                final success = await ref.read(institutionProgramsProvider.notifier).deleteProgram(_program.id);

                if (success && mounted) {
                  context.pop(); // Go back to list
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.instProgramDeletedSuccess),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else if (mounted) {
                  setState(() => _isProcessing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.instProgramFailedToDelete),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  setState(() => _isProcessing = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.l10n.instProgramErrorDeleting(e.toString())),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.instProgramDelete),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
