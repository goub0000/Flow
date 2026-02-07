// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/export_utils.dart';

/// Dialog for selecting export format
class ExportDialog extends StatefulWidget {
  final String title;
  final Future<void> Function(ExportFormat format) onExport;

  const ExportDialog({
    super.key,
    required this.title,
    required this.onExport,
  });

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.csv;
  bool _isExporting = false;

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);

    try {
      await widget.onExport(_selectedFormat);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select export format:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ...ExportFormat.values.map((format) {
            return RadioListTile<ExportFormat>(
              title: Row(
                children: [
                  Icon(
                    _getFormatIcon(format),
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Text(format.displayName),
                ],
              ),
              subtitle: Text(
                _getFormatDescription(format),
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              value: format,
              groupValue: _selectedFormat,
              onChanged: _isExporting
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedFormat = value);
                      }
                    },
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isExporting ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isExporting ? null : _handleExport,
          child: _isExporting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Export'),
        ),
      ],
    );
  }

  IconData _getFormatIcon(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return Icons.table_chart;
      case ExportFormat.excel:
        return Icons.grid_on;
      case ExportFormat.pdf:
        return Icons.picture_as_pdf;
    }
  }

  String _getFormatDescription(ExportFormat format) {
    switch (format) {
      case ExportFormat.csv:
        return 'Comma-separated values (compatible with Excel, Google Sheets)';
      case ExportFormat.excel:
        return 'Microsoft Excel format (.xlsx)';
      case ExportFormat.pdf:
        return 'Portable Document Format (for printing/viewing)';
    }
  }
}

/// Helper function to show export dialog
Future<bool?> showExportDialog({
  required BuildContext context,
  required String title,
  required Future<void> Function(ExportFormat format) onExport,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ExportDialog(
      title: title,
      onExport: onExport,
    ),
  );
}
