import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../shared/utils/export_utils_web.dart' as export_utils;

/// Export data source definition
class _ExportSource {
  final String id;
  final String label;
  final String description;
  final IconData icon;
  final String endpoint;
  final String dataKey;
  final Color color;

  const _ExportSource({
    required this.id,
    required this.label,
    required this.description,
    required this.icon,
    required this.endpoint,
    required this.dataKey,
    required this.color,
  });
}

const _exportSources = <_ExportSource>[
  _ExportSource(
    id: 'users',
    label: 'Users',
    description: 'All registered users with profiles',
    icon: Icons.people,
    endpoint: '/admin/users',
    dataKey: 'users',
    color: AppColors.primary,
  ),
  _ExportSource(
    id: 'transactions',
    label: 'Transactions',
    description: 'Financial transaction records',
    icon: Icons.receipt_long,
    endpoint: '/admin/finance/transactions',
    dataKey: 'transactions',
    color: Color(0xFFFAA61A),
  ),
  _ExportSource(
    id: 'content',
    label: 'Content',
    description: 'Courses and educational content',
    icon: Icons.library_books,
    endpoint: '/admin/content',
    dataKey: 'content',
    color: AppColors.success,
  ),
  _ExportSource(
    id: 'tickets',
    label: 'Support Tickets',
    description: 'Support ticket history',
    icon: Icons.support_agent,
    endpoint: '/admin/support/tickets',
    dataKey: 'tickets',
    color: AppColors.secondary,
  ),
  _ExportSource(
    id: 'campaigns',
    label: 'Campaigns',
    description: 'Communication campaigns',
    icon: Icons.campaign,
    endpoint: '/admin/communications/campaigns',
    dataKey: 'campaigns',
    color: AppColors.primaryLight,
  ),
  _ExportSource(
    id: 'activity',
    label: 'Activity Log',
    description: 'Platform activity and audit trail',
    icon: Icons.history,
    endpoint: '/admin/dashboard/recent-activity',
    dataKey: 'activities',
    color: Color(0xFF4CAF50),
  ),
];

enum _ExportFormat { csv, json }

class ExportsScreen extends ConsumerStatefulWidget {
  const ExportsScreen({super.key});

  @override
  ConsumerState<ExportsScreen> createState() => _ExportsScreenState();
}

class _ExportsScreenState extends ConsumerState<ExportsScreen> {
  _ExportSource? _selectedSource;
  _ExportFormat _format = _ExportFormat.csv;
  bool _exporting = false;
  String? _error;
  final List<Map<String, String>> _history = [];

  Future<void> _export() async {
    if (_selectedSource == null) return;

    setState(() {
      _exporting = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final src = _selectedSource!;
      final response = await apiClient.get(
        '${ApiConfig.admin}${src.endpoint.replaceFirst('/admin', '')}',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (!response.success || response.data == null) {
        setState(() {
          _error = response.message ?? 'Failed to fetch data';
          _exporting = false;
        });
        return;
      }

      final data = response.data!;
      final rawList = data[src.dataKey];
      List<Map<String, dynamic>> rows = [];

      if (rawList is List) {
        rows = rawList.whereType<Map<String, dynamic>>().toList();
      }

      if (rows.isEmpty) {
        setState(() {
          _error = 'No data to export';
          _exporting = false;
        });
        return;
      }

      // Extract flat columns
      final cols = <String>{};
      for (final row in rows.take(10)) {
        for (final key in row.keys) {
          if (row[key] is! Map && row[key] is! List) cols.add(key);
        }
      }
      final columns = cols.toList();

      String content;
      String mimeType;
      String extension;

      if (_format == _ExportFormat.csv) {
        final buffer = StringBuffer();
        buffer.writeln(columns.join(','));
        for (final row in rows) {
          final values = columns.map((col) {
            final val = row[col]?.toString() ?? '';
            // Escape CSV values containing commas or quotes
            if (val.contains(',') || val.contains('"') || val.contains('\n')) {
              return '"${val.replaceAll('"', '""')}"';
            }
            return val;
          });
          buffer.writeln(values.join(','));
        }
        content = buffer.toString();
        mimeType = 'text/csv';
        extension = 'csv';
      } else {
        content = const JsonEncoder.withIndent('  ').convert(rows);
        mimeType = 'application/json';
        extension = 'json';
      }

      // Trigger browser download
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final fileName = '${src.id}_export_$timestamp.$extension';

      await export_utils.downloadFile(
        bytes: Uint8List.fromList(utf8.encode(content)),
        filename: fileName,
        mimeType: mimeType,
      );

      setState(() {
        _history.insert(0, {
          'source': src.label,
          'format': extension.toUpperCase(),
          'rows': '${rows.length}',
          'time': DateTime.now().toIso8601String(),
          'file': fileName,
        });
        _exporting = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${rows.length} rows to $fileName'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = 'Export failed: $e';
        _exporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExportForm(),
                const SizedBox(height: 32),
                _buildExportHistory(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.download, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Exports',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Export platform data in CSV or JSON format',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('New Export', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Step 1: Select data source
          const Text('1. Select data source', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _exportSources.map((src) {
              final isSelected = _selectedSource?.id == src.id;
              return InkWell(
                onTap: () => setState(() => _selectedSource = src),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 180,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? src.color.withValues(alpha: 0.08) : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? src.color : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(src.icon, color: isSelected ? src.color : AppColors.textSecondary, size: 24),
                      const SizedBox(height: 8),
                      Text(src.label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: isSelected ? src.color : AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(src.description, style: TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 2),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Step 2: Select format
          const Text('2. Select format', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildFormatOption(
                _ExportFormat.csv,
                'CSV',
                'Comma-separated values — opens in Excel, Google Sheets',
                Icons.table_chart,
              ),
              const SizedBox(width: 12),
              _buildFormatOption(
                _ExportFormat.json,
                'JSON',
                'Structured data format — for developers and APIs',
                Icons.data_object,
              ),
            ],
          ),

          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13))),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Export button
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _selectedSource != null && !_exporting ? _export : null,
              icon: _exporting
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.download),
              label: Text(_exporting ? 'Exporting...' : 'Export Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatOption(_ExportFormat format, String label, String desc, IconData icon) {
    final isSelected = _format == format;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _format = format),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.06) : null,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                    Text(desc, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, size: 20),
              const SizedBox(width: 8),
              const Text('Export History (this session)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          if (_history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No exports yet this session', style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            ..._history.map((entry) {
              DateTime ts;
              try {
                ts = DateTime.parse(entry['time']!);
              } catch (_) {
                ts = DateTime.now();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: AppColors.success),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry['file'] ?? '', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                          Text(
                            '${entry['source']}  |  ${entry['rows']} rows  |  ${entry['format']}',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${ts.hour}:${ts.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
