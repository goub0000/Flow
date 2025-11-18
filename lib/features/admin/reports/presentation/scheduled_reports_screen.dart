import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/export_service.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/status_badge.dart';

/// Scheduled Reports Management Screen
/// Allows admins to create and manage automatic report generation schedules
class ScheduledReportsScreen extends ConsumerStatefulWidget {
  const ScheduledReportsScreen({super.key});

  @override
  ConsumerState<ScheduledReportsScreen> createState() => _ScheduledReportsScreenState();
}

class _ScheduledReportsScreenState extends ConsumerState<ScheduledReportsScreen> {
  // Mock data - replace with provider
  final List<ScheduledReport> _scheduledReports = [
    ScheduledReport(
      id: '1',
      title: 'Weekly User Activity Report',
      description: 'Overview of user registrations and activity metrics',
      frequency: ReportFrequency.weekly,
      format: ExportFormat.pdf,
      recipients: ['admin@flow.com', 'manager@flow.com'],
      nextRun: DateTime.now().add(const Duration(days: 2)),
      isActive: true,
      metrics: ['total_users', 'new_registrations', 'active_sessions'],
    ),
    ScheduledReport(
      id: '2',
      title: 'Monthly Application Analytics',
      description: 'Application submission and acceptance statistics',
      frequency: ReportFrequency.monthly,
      format: ExportFormat.csv,
      recipients: ['analytics@flow.com'],
      nextRun: DateTime.now().add(const Duration(days: 15)),
      isActive: true,
      metrics: ['total_applications', 'application_acceptance_rate'],
    ),
    ScheduledReport(
      id: '3',
      title: 'Quarterly Revenue Report',
      description: 'Financial summary and revenue breakdown',
      frequency: ReportFrequency.monthly,
      format: ExportFormat.pdf,
      recipients: ['finance@flow.com', 'admin@flow.com'],
      nextRun: DateTime.now().add(const Duration(days: 30)),
      isActive: false,
      metrics: ['revenue', 'conversion_rate'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: 'Help',
          ),
        ],
      ),
      body: _scheduledReports.isEmpty
          ? EmptyState(
              icon: Icons.schedule,
              title: 'No Scheduled Reports',
              message: 'Create automated reports to receive regular updates',
              actionLabel: 'Create Schedule',
              onAction: _createScheduledReport,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _scheduledReports.length,
              itemBuilder: (context, index) {
                final report = _scheduledReports[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ScheduledReportCard(
                    report: report,
                    onTap: () => _editScheduledReport(report),
                    onToggle: (value) => _toggleReport(report, value),
                    onDelete: () => _deleteReport(report),
                    onRunNow: () => _runReportNow(report),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createScheduledReport,
        icon: const Icon(Icons.add),
        label: const Text('New Schedule'),
      ),
    );
  }

  void _createScheduledReport() {
    showDialog(
      context: context,
      builder: (context) => const _ScheduledReportDialog(),
    );
  }

  void _editScheduledReport(ScheduledReport report) {
    showDialog(
      context: context,
      builder: (context) => _ScheduledReportDialog(report: report),
    );
  }

  void _toggleReport(ScheduledReport report, bool value) {
    setState(() {
      report.isActive = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'Report activated' : 'Report paused',
        ),
        backgroundColor: value ? AppColors.success : AppColors.warning,
      ),
    );
  }

  void _deleteReport(ScheduledReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Scheduled Report'),
        content: Text('Are you sure you want to delete "${report.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _scheduledReports.remove(report);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scheduled report deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _runReportNow(ScheduledReport report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report generation started. You will receive it via email shortly.'),
        backgroundColor: AppColors.info,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scheduled Reports Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How to use Scheduled Reports:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('1. Click "New Schedule" to create an automated report'),
              SizedBox(height: 8),
              Text('2. Choose report frequency (daily, weekly, monthly)'),
              SizedBox(height: 8),
              Text('3. Select metrics to include in the report'),
              SizedBox(height: 8),
              Text('4. Add email recipients who will receive the report'),
              SizedBox(height: 8),
              Text('5. Reports will be automatically generated and emailed'),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Pause/resume schedules at any time'),
              SizedBox(height: 4),
              Text('• Run reports manually with "Run Now"'),
              SizedBox(height: 4),
              Text('• Edit existing schedules'),
              SizedBox(height: 4),
              Text('• Multiple export formats (PDF, CSV, JSON)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _ScheduledReportCard extends StatelessWidget {
  final ScheduledReport report;
  final VoidCallback onTap;
  final Function(bool) onToggle;
  final VoidCallback onDelete;
  final VoidCallback onRunNow;

  const _ScheduledReportCard({
    required this.report,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
    required this.onRunNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysUntilNext = report.nextRun.difference(DateTime.now()).inDays;

    return CustomCard(
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
                      report.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (report.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        report.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch(
                value: report.isActive,
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.schedule,
                label: _getFrequencyLabel(report.frequency),
                color: AppColors.primary,
              ),
              _InfoChip(
                icon: Icons.insert_drive_file,
                label: report.format.name.toUpperCase(),
                color: AppColors.info,
              ),
              _InfoChip(
                icon: Icons.email,
                label: '${report.recipients.length} recipients',
                color: AppColors.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: report.isActive
                  ? AppColors.info.withValues(alpha: 0.1)
                  : AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: report.isActive ? AppColors.info : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    report.isActive
                        ? 'Next run: ${_formatNextRun(daysUntilNext)}'
                        : 'Paused',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: report.isActive ? AppColors.info : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRunNow,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Run Now'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFrequencyLabel(ReportFrequency frequency) {
    switch (frequency) {
      case ReportFrequency.daily:
        return 'Daily';
      case ReportFrequency.weekly:
        return 'Weekly';
      case ReportFrequency.monthly:
        return 'Monthly';
    }
  }

  String _formatNextRun(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return 'in $days days';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for creating/editing scheduled reports
class _ScheduledReportDialog extends StatefulWidget {
  final ScheduledReport? report;

  const _ScheduledReportDialog({this.report});

  @override
  State<_ScheduledReportDialog> createState() => _ScheduledReportDialogState();
}

class _ScheduledReportDialogState extends State<_ScheduledReportDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _recipientsController;
  late ReportFrequency _frequency;
  late ExportFormat _format;
  final Map<String, bool> _selectedMetrics = {
    'total_users': false,
    'new_registrations': false,
    'total_applications': false,
    'application_acceptance_rate': false,
    'active_sessions': false,
    'revenue': false,
    'user_engagement': false,
    'conversion_rate': false,
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.report?.title ?? '');
    _descriptionController = TextEditingController(text: widget.report?.description ?? '');
    _recipientsController = TextEditingController(
      text: widget.report?.recipients.join(', ') ?? '',
    );
    _frequency = widget.report?.frequency ?? ReportFrequency.weekly;
    _format = widget.report?.format ?? ExportFormat.pdf;

    if (widget.report != null) {
      for (final metric in widget.report!.metrics) {
        _selectedMetrics[metric] = true;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _recipientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.report == null ? 'New Scheduled Report' : 'Edit Scheduled Report'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Report Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ReportFrequency>(
                  value: _frequency,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                  items: ReportFrequency.values.map((freq) {
                    return DropdownMenuItem(
                      value: freq,
                      child: Text(_getFrequencyLabel(freq)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _frequency = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ExportFormat>(
                  value: _format,
                  decoration: const InputDecoration(
                    labelText: 'Export Format',
                    border: OutlineInputBorder(),
                  ),
                  items: ExportFormat.values.map((format) {
                    return DropdownMenuItem(
                      value: format,
                      child: Text(format.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _format = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _recipientsController,
                  decoration: const InputDecoration(
                    labelText: 'Email Recipients (comma-separated)',
                    border: OutlineInputBorder(),
                    hintText: 'admin@example.com, manager@example.com',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter at least one recipient';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Metrics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._selectedMetrics.keys.map((metric) {
                  return CheckboxListTile(
                    title: Text(_formatMetricName(metric)),
                    value: _selectedMetrics[metric],
                    onChanged: (value) {
                      setState(() {
                        _selectedMetrics[metric] = value ?? false;
                      });
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.report == null ? 'Create' : 'Save'),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_selectedMetrics.values.any((v) => v)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one metric'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.report == null
              ? 'Scheduled report created successfully'
              : 'Scheduled report updated successfully',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String _getFrequencyLabel(ReportFrequency frequency) {
    switch (frequency) {
      case ReportFrequency.daily:
        return 'Daily';
      case ReportFrequency.weekly:
        return 'Weekly';
      case ReportFrequency.monthly:
        return 'Monthly';
    }
  }

  String _formatMetricName(String metric) {
    return metric.split('_').map((word) =>
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }
}

/// Scheduled Report Model
class ScheduledReport {
  final String id;
  final String title;
  final String? description;
  final ReportFrequency frequency;
  final ExportFormat format;
  final List<String> recipients;
  final DateTime nextRun;
  bool isActive;
  final List<String> metrics;

  ScheduledReport({
    required this.id,
    required this.title,
    this.description,
    required this.frequency,
    required this.format,
    required this.recipients,
    required this.nextRun,
    required this.isActive,
    required this.metrics,
  });
}

/// Report Frequency Enum
enum ReportFrequency {
  daily,
  weekly,
  monthly,
}
