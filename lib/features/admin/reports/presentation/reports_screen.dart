import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../models/report_model.dart';
import '../services/report_service.dart';

/// Reports Screen - Generate and manage reports
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  ReportCategory? _selectedCategory;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.adminReportReportsTitle,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.adminReportReportsSubtitle,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to scheduled reports
                      },
                      icon: const Icon(Icons.schedule, size: 20),
                      label: Text(context.l10n.adminReportScheduledReports),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildCategoryFilter(),
              ],
            ),
          ),

          // Reports Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildReportsGrid(),
            ),
          ),
          const SizedBox(height: 24),
        ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryChip(null, context.l10n.adminReportAllReports),
          ...ReportCategory.values.map((category) {
            return _buildCategoryChip(category, category.label);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(ReportCategory? category, String label) {
    final isSelected = _selectedCategory == category;

    return InkWell(
      onTap: () {
        setState(() => _selectedCategory = category);
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildReportsGrid() {
    final reports = _getFilteredReports();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.2,
      ),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(ReportModel report) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showReportDialog(report),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        report.icon,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        report.category.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  report.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  report.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),

                // Last Generated
                if (report.lastGenerated != null) ...[
                  Divider(color: AppColors.border),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Last: ${DateFormat('MMM d, HH:mm').format(report.lastGenerated!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (report.isScheduled)
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportDialog(ReportModel report) {
    showDialog(
      context: context,
      builder: (context) => _ReportGenerationDialog(
        report: report,
        onGenerate: _handleGenerateReport,
      ),
    );
  }

  Future<void> _handleGenerateReport(
    ReportModel report,
    ReportParameters params,
  ) async {
    setState(() => _isGenerating = true);

    try {
      switch (report.type) {
        case ReportType.users:
          await ReportService.generateUserActivityReport(params: params);
          break;
        case ReportType.financial:
          await ReportService.generateFinancialReport(params: params);
          break;
        case ReportType.engagement:
          await ReportService.generateEngagementReport(params: params);
          break;
        case ReportType.performance:
          await ReportService.generatePerformanceReport(params: params);
          break;
        case ReportType.system:
          await ReportService.generateSystemHealthReport(params: params);
          break;
        case ReportType.custom:
          await ReportService.generateCustomReport(
            reportId: report.id,
            params: params,
          );
          break;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminReportNameGeneratedSuccess(report.name)),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminReportGenerateFailed(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  List<ReportModel> _getFilteredReports() {
    var reports = _getAvailableReports();

    if (_selectedCategory != null) {
      reports = reports
          .where((r) => r.category == _selectedCategory)
          .toList();
    }

    return reports;
  }

  List<ReportModel> _getAvailableReports() {
    return [
      // Analytics Reports
      ReportModel(
        id: 'user_activity',
        name: 'User Activity Report',
        description:
            'Comprehensive overview of user registrations, logins, and activity patterns',
        type: ReportType.users,
        category: ReportCategory.analytics,
        icon: Icons.people,
        lastGenerated: DateTime.now().subtract(const Duration(hours: 2)),
        isScheduled: true,
      ),
      ReportModel(
        id: 'engagement',
        name: 'Engagement Metrics',
        description:
            'Track user engagement, course enrollments, and platform interactions',
        type: ReportType.engagement,
        category: ReportCategory.analytics,
        icon: Icons.trending_up,
        lastGenerated: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ReportModel(
        id: 'performance',
        name: 'System Performance',
        description:
            'API response times, throughput, and system performance metrics',
        type: ReportType.performance,
        category: ReportCategory.analytics,
        icon: Icons.speed,
      ),

      // Financial Reports
      ReportModel(
        id: 'revenue',
        name: 'Revenue Report',
        description:
            'Detailed breakdown of revenue, subscriptions, and transactions',
        type: ReportType.financial,
        category: ReportCategory.finance,
        icon: Icons.attach_money,
        lastGenerated: DateTime.now().subtract(const Duration(hours: 12)),
        isScheduled: true,
      ),
      ReportModel(
        id: 'payment_analytics',
        name: 'Payment Analytics',
        description:
            'Payment success rates, processing times, and transaction analysis',
        type: ReportType.financial,
        category: ReportCategory.finance,
        icon: Icons.payment,
      ),

      // Operations Reports
      ReportModel(
        id: 'user_growth',
        name: 'User Growth Report',
        description:
            'Track user acquisition, retention, and growth trends over time',
        type: ReportType.users,
        category: ReportCategory.operations,
        icon: Icons.show_chart,
        lastGenerated: DateTime.now().subtract(const Duration(days: 7)),
      ),
      ReportModel(
        id: 'system_health',
        name: 'System Health Report',
        description:
            'Infrastructure status, uptime, resource utilization, and health metrics',
        type: ReportType.system,
        category: ReportCategory.operations,
        icon: Icons.monitor_heart,
        isScheduled: true,
      ),
      ReportModel(
        id: 'application_funnel',
        name: 'Application Funnel',
        description:
            'Track application submissions, conversions, and completion rates',
        type: ReportType.engagement,
        category: ReportCategory.operations,
        icon: Icons.filter_alt,
      ),

      // Compliance Reports
      ReportModel(
        id: 'audit_trail',
        name: 'Audit Trail Report',
        description:
            'Complete audit trail of admin actions and system changes',
        type: ReportType.system,
        category: ReportCategory.compliance,
        icon: Icons.gavel,
      ),
      ReportModel(
        id: 'data_access',
        name: 'Data Access Report',
        description:
            'Track data access patterns and sensitive information requests',
        type: ReportType.system,
        category: ReportCategory.compliance,
        icon: Icons.security,
      ),
    ];
  }
}

/// Report Generation Dialog
class _ReportGenerationDialog extends StatefulWidget {
  final ReportModel report;
  final Future<void> Function(ReportModel report, ReportParameters params)
      onGenerate;

  const _ReportGenerationDialog({
    required this.report,
    required this.onGenerate,
  });

  @override
  State<_ReportGenerationDialog> createState() =>
      _ReportGenerationDialogState();
}

class _ReportGenerationDialogState extends State<_ReportGenerationDialog> {
  late DateTime _startDate;
  late DateTime _endDate;
  ReportFormat _selectedFormat = ReportFormat.pdf;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = _endDate.subtract(const Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(widget.report.icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.report.name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.report.description,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Date Range
            Text(
              context.l10n.adminReportDateRange,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(isStartDate: true),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      DateFormat('MMM d, yyyy').format(_startDate),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(context.l10n.adminReportTo),
                ),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectDate(isStartDate: false),
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      DateFormat('MMM d, yyyy').format(_endDate),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Format Selection
            Text(
              context.l10n.adminReportExportFormat,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: ReportFormat.values.map((format) {
                final isSelected = _selectedFormat == format;
                return ChoiceChip(
                  label: Text(format.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedFormat = format);
                    }
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.adminReportCancel),
        ),
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : _handleGenerate,
          icon: _isGenerating
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.download, size: 18),
          label: Text(_isGenerating ? context.l10n.adminReportGenerating : context.l10n.adminReportGenerate),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  Future<void> _handleGenerate() async {
    setState(() => _isGenerating = true);

    final params = ReportParameters(
      startDate: _startDate,
      endDate: _endDate,
      format: _selectedFormat,
    );

    try {
      await widget.onGenerate(widget.report, params);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}
