import 'package:flutter/material.dart';
import '../../../core/services/export_service.dart';
import '../../../core/theme/app_colors.dart';

/// Export button widget with dropdown menu for format selection
class ExportButton extends StatelessWidget {
  final List<dynamic> data;
  final ExportType exportType;
  final String? customFilename;
  final Map<String, dynamic>? metadata;
  final VoidCallback? onExportStart;
  final VoidCallback? onExportComplete;
  final Function(String error)? onExportError;

  const ExportButton({
    super.key,
    required this.data,
    required this.exportType,
    this.customFilename,
    this.metadata,
    this.onExportStart,
    this.onExportComplete,
    this.onExportError,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ExportFormat>(
      icon: const Icon(Icons.download),
      tooltip: 'Export Data',
      onSelected: (format) => _handleExport(context, format),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: ExportFormat.pdf,
          child: Row(
            children: [
              Icon(Icons.picture_as_pdf, color: Colors.red),
              SizedBox(width: 12),
              Text('Export as PDF'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ExportFormat.csv,
          child: Row(
            children: [
              Icon(Icons.table_chart, color: Colors.green),
              SizedBox(width: 12),
              Text('Export as CSV'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: ExportFormat.json,
          child: Row(
            children: [
              Icon(Icons.code, color: Colors.blue),
              SizedBox(width: 12),
              Text('Export as JSON'),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleExport(BuildContext context, ExportFormat format) async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data to export'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    onExportStart?.call();

    try {
      switch (exportType) {
        case ExportType.applications:
          await _exportApplications(format);
          break;
        case ExportType.grades:
          await _exportGrades(format);
          break;
        case ExportType.analytics:
          await _exportAnalytics(format);
          break;
        case ExportType.custom:
          await _exportCustom(format);
          break;
      }

      onExportComplete?.call();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported successfully as ${format.name.toUpperCase()}'),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      onExportError?.call(e.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _handleExport(context, format),
            ),
          ),
        );
      }
    }
  }

  Future<void> _exportApplications(ExportFormat format) async {
    switch (format) {
      case ExportFormat.pdf:
        await ExportService.exportApplicationsToPDF(
          applications: data,
          studentName: metadata?['studentName'] ?? 'Student',
        );
        break;
      case ExportFormat.csv:
        await ExportService.exportApplicationsToCSV(applications: data);
        break;
      case ExportFormat.json:
        await ExportService.exportToJSON(
          filename: customFilename ?? 'applications',
          data: {'applications': data},
        );
        break;
    }
  }

  Future<void> _exportGrades(ExportFormat format) async {
    switch (format) {
      case ExportFormat.pdf:
        await ExportService.exportGradesToPDF(
          grades: data,
          studentName: metadata?['studentName'] ?? 'Student',
          courseName: metadata?['courseName'],
        );
        break;
      case ExportFormat.csv:
        await ExportService.exportGradesToCSV(grades: data);
        break;
      case ExportFormat.json:
        await ExportService.exportToJSON(
          filename: customFilename ?? 'grades',
          data: {'grades': data},
        );
        break;
    }
  }

  Future<void> _exportAnalytics(ExportFormat format) async {
    if (format == ExportFormat.pdf) {
      await ExportService.exportAnalyticsToPDF(
        title: metadata?['title'] ?? 'Analytics Report',
        analytics: data.isNotEmpty && data.first is Map
            ? Map<String, dynamic>.from(data.first)
            : {},
        description: metadata?['description'],
      );
    } else {
      throw UnimplementedError('Analytics export to ${format.name} coming soon');
    }
  }

  Future<void> _exportCustom(ExportFormat format) async {
    // For custom data structures
    switch (format) {
      case ExportFormat.csv:
        if (data.first is List) {
          await ExportService.exportToCSV(
            filename: customFilename ?? 'export',
            data: data.cast<List<dynamic>>(),
          );
        }
        break;
      case ExportFormat.json:
        await ExportService.exportToJSON(
          filename: customFilename ?? 'export',
          data: {'data': data},
        );
        break;
      default:
        throw UnimplementedError('Custom export to ${format.name} not implemented');
    }
  }
}

/// Compact export icon button
class ExportIconButton extends StatelessWidget {
  final List<dynamic> data;
  final ExportType exportType;
  final String? customFilename;
  final Map<String, dynamic>? metadata;

  const ExportIconButton({
    super.key,
    required this.data,
    required this.exportType,
    this.customFilename,
    this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.file_download),
      tooltip: 'Export',
      onPressed: () => _showExportDialog(context),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                ExportButton(
                  data: data,
                  exportType: exportType,
                  customFilename: customFilename,
                  metadata: metadata,
                )._handleExport(context, ExportFormat.pdf);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                ExportButton(
                  data: data,
                  exportType: exportType,
                  customFilename: customFilename,
                  metadata: metadata,
                )._handleExport(context, ExportFormat.csv);
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.blue),
              title: const Text('Export as JSON'),
              onTap: () {
                Navigator.pop(context);
                ExportButton(
                  data: data,
                  exportType: exportType,
                  customFilename: customFilename,
                  metadata: metadata,
                )._handleExport(context, ExportFormat.json);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

/// Type of data being exported
enum ExportType {
  applications,
  grades,
  analytics,
  custom,
}
