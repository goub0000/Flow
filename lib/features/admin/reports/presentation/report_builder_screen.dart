import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/export_service.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/custom_card.dart';

/// Admin Report Builder Screen
/// Allows admins to create custom reports with selected metrics and date ranges
class ReportBuilderScreen extends ConsumerStatefulWidget {
  const ReportBuilderScreen({super.key});

  @override
  ConsumerState<ReportBuilderScreen> createState() => _ReportBuilderScreenState();
}

class _ReportBuilderScreenState extends ConsumerState<ReportBuilderScreen> {
  final _formKey = GlobalKey<FormState>();

  // Report configuration
  String _reportTitle = '';
  String _reportDescription = '';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  // Available metrics
  final Map<String, bool> _selectedMetrics = {
    'total_users': true,
    'new_registrations': true,
    'total_applications': true,
    'application_acceptance_rate': false,
    'active_sessions': false,
    'revenue': false,
    'user_engagement': false,
    'conversion_rate': false,
  };

  // Export format
  ExportFormat _exportFormat = ExportFormat.pdf;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminReportBuilderTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
            tooltip: context.l10n.adminReportHelp,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Information Section
              _buildSectionHeader(context.l10n.adminReportInformation),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: context.l10n.adminReportTitle,
                          hintText: context.l10n.adminReportTitleHint,
                          prefixIcon: const Icon(Icons.title),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return context.l10n.adminReportTitleRequired;
                          }
                          return null;
                        },
                        onChanged: (value) => _reportTitle = value,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: context.l10n.adminReportDescriptionOptional,
                          hintText: context.l10n.adminReportDescriptionHint,
                          prefixIcon: const Icon(Icons.description),
                          border: const OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) => _reportDescription = value,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Date Range Section
              _buildSectionHeader(context.l10n.adminReportDateRange),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          label: context.l10n.adminReportStartDate,
                          date: _startDate,
                          onDateSelected: (date) {
                            setState(() => _startDate = date);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateSelector(
                          label: context.l10n.adminReportEndDate,
                          date: _endDate,
                          onDateSelected: (date) {
                            setState(() => _endDate = date);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Metrics Selection Section
              _buildSectionHeader(context.l10n.adminReportSelectMetrics),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.l10n.adminReportSelectAll,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: _selectedMetrics.values.every((v) => v),
                            onChanged: (value) {
                              setState(() {
                                _selectedMetrics.updateAll((key, _) => value);
                              });
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      ..._selectedMetrics.keys.map((metric) {
                        return CheckboxListTile(
                          title: Text(_formatMetricName(metric)),
                          subtitle: Text(_getMetricDescription(metric)),
                          value: _selectedMetrics[metric],
                          onChanged: (value) {
                            setState(() {
                              _selectedMetrics[metric] = value ?? false;
                            });
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Export Format Section
              _buildSectionHeader(context.l10n.adminReportExportFormat),
              const SizedBox(height: 16),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      RadioListTile<ExportFormat>(
                        title: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, color: Colors.red),
                            const SizedBox(width: 12),
                            Text(context.l10n.adminReportPdfDocument),
                          ],
                        ),
                        subtitle: Text(context.l10n.adminReportPdfDescription),
                        value: ExportFormat.pdf,
                        groupValue: _exportFormat,
                        onChanged: (value) {
                          setState(() => _exportFormat = value!);
                        },
                      ),
                      RadioListTile<ExportFormat>(
                        title: Row(
                          children: [
                            const Icon(Icons.table_chart, color: Colors.green),
                            const SizedBox(width: 12),
                            Text(context.l10n.adminReportCsvSpreadsheet),
                          ],
                        ),
                        subtitle: Text(context.l10n.adminReportCsvDescription),
                        value: ExportFormat.csv,
                        groupValue: _exportFormat,
                        onChanged: (value) {
                          setState(() => _exportFormat = value!);
                        },
                      ),
                      RadioListTile<ExportFormat>(
                        title: Row(
                          children: [
                            const Icon(Icons.code, color: Colors.blue),
                            const SizedBox(width: 12),
                            Text(context.l10n.adminReportJsonData),
                          ],
                        ),
                        subtitle: Text(context.l10n.adminReportJsonDescription),
                        value: ExportFormat.json,
                        groupValue: _exportFormat,
                        onChanged: (value) {
                          setState(() => _exportFormat = value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateReport,
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.file_download),
                  label: Text(
                    _isGenerating ? context.l10n.adminReportGenerating : context.l10n.adminReportGenerate,
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quick Presets
              _buildQuickPresets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPresets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.adminReportQuickPresets,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip(context.l10n.adminReportLast7Days, () {
              setState(() {
                _endDate = DateTime.now();
                _startDate = _endDate.subtract(const Duration(days: 7));
              });
            }),
            _buildPresetChip(context.l10n.adminReportLast30Days, () {
              setState(() {
                _endDate = DateTime.now();
                _startDate = _endDate.subtract(const Duration(days: 30));
              });
            }),
            _buildPresetChip(context.l10n.adminReportThisMonth, () {
              setState(() {
                final now = DateTime.now();
                _startDate = DateTime(now.year, now.month, 1);
                _endDate = now;
              });
            }),
            _buildPresetChip(context.l10n.adminReportLastMonth, () {
              setState(() {
                final now = DateTime.now();
                _startDate = DateTime(now.year, now.month - 1, 1);
                _endDate = DateTime(now.year, now.month, 0);
              });
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.surface,
    );
  }

  String _formatMetricName(String metric) {
    return metric.split('_').map((word) =>
      word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _getMetricDescription(String metric) {
    final descriptions = {
      'total_users': context.l10n.adminReportMetricTotalUsers,
      'new_registrations': context.l10n.adminReportMetricNewRegistrations,
      'total_applications': context.l10n.adminReportMetricTotalApplications,
      'application_acceptance_rate': context.l10n.adminReportMetricAcceptanceRate,
      'active_sessions': context.l10n.adminReportMetricActiveSessions,
      'revenue': context.l10n.adminReportMetricRevenue,
      'user_engagement': context.l10n.adminReportMetricEngagement,
      'conversion_rate': context.l10n.adminReportMetricConversion,
    };
    return descriptions[metric] ?? '';
  }

  Future<void> _generateReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_selectedMetrics.values.any((v) => v)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminReportSelectAtLeastOneMetric),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      // Generate mock analytics data
      final selectedMetricsData = <String, dynamic>{};
      _selectedMetrics.forEach((key, selected) {
        if (selected) {
          selectedMetricsData[key] = _getMockMetricValue(key);
        }
      });

      // Export based on format
      if (_exportFormat == ExportFormat.pdf) {
        await ExportService.exportAnalyticsToPDF(
          title: _reportTitle.isNotEmpty ? _reportTitle : context.l10n.adminReportDefaultTitle,
          analytics: selectedMetricsData,
          description: _reportDescription.isNotEmpty ? _reportDescription : null,
        );
      } else if (_exportFormat == ExportFormat.csv) {
        final data = [
          [context.l10n.adminReportMetricHeader, context.l10n.adminReportValueHeader],
          ...selectedMetricsData.entries.map((e) => [
            _formatMetricName(e.key),
            e.value.toString(),
          ]),
        ];
        await ExportService.exportToCSV(
          filename: 'analytics_report_${DateTime.now().millisecondsSinceEpoch}',
          data: data,
        );
      } else {
        await ExportService.exportToJSON(
          filename: 'analytics_report_${DateTime.now().millisecondsSinceEpoch}',
          data: {
            'title': _reportTitle,
            'description': _reportDescription,
            'date_range': {
              'start': _startDate.toIso8601String(),
              'end': _endDate.toIso8601String(),
            },
            'metrics': selectedMetricsData,
          },
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminReportGeneratedSuccess),
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

  dynamic _getMockMetricValue(String metric) {
    // Mock data - replace with actual API calls
    switch (metric) {
      case 'total_users':
        return 1543;
      case 'new_registrations':
        return 127;
      case 'total_applications':
        return 892;
      case 'application_acceptance_rate':
        return '68.5%';
      case 'active_sessions':
        return 234;
      case 'revenue':
        return '\$12,450.00';
      case 'user_engagement':
        return '73.2%';
      case 'conversion_rate':
        return '42.8%';
      default:
        return 'N/A';
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.adminReportBuilderHelpTitle),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.adminReportHowToUse,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(context.l10n.adminReportHelpStep1),
              const SizedBox(height: 8),
              Text(context.l10n.adminReportHelpStep2),
              const SizedBox(height: 8),
              Text(context.l10n.adminReportHelpStep3),
              const SizedBox(height: 8),
              Text(context.l10n.adminReportHelpStep4),
              const SizedBox(height: 8),
              Text(context.l10n.adminReportHelpStep5),
              const SizedBox(height: 16),
              Text(
                context.l10n.adminReportQuickPresets,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(context.l10n.adminReportHelpPresetsInfo),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminReportGotIt),
          ),
        ],
      ),
    );
  }
}
