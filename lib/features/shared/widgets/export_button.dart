import 'package:flutter/material.dart';
import '../../../core/services/export_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

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
      tooltip: context.l10n.swExportData,
      onSelected: (format) => _handleExport(context, format),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ExportFormat.pdf,
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf, color: Colors.red),
              const SizedBox(width: 12),
              Text(context.l10n.swExportAsPdf),
            ],
          ),
        ),
        PopupMenuItem(
          value: ExportFormat.csv,
          child: Row(
            children: [
              const Icon(Icons.table_chart, color: Colors.green),
              const SizedBox(width: 12),
              Text(context.l10n.swExportAsCsv),
            ],
          ),
        ),
        PopupMenuItem(
          value: ExportFormat.json,
          child: Row(
            children: [
              const Icon(Icons.code, color: Colors.blue),
              const SizedBox(width: 12),
              Text(context.l10n.swExportAsJson),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleExport(BuildContext context, ExportFormat format) async {
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.swExportNoData),
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
            content: Text(context.l10n.swExportSuccess(format.name.toUpperCase())),
            backgroundColor: AppColors.success,
            action: SnackBarAction(
              label: context.l10n.swExportOk,
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
            content: Text(context.l10n.swExportFailed(e.toString())),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: context.l10n.swExportRetry,
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
      tooltip: context.l10n.swExportTooltip,
      onPressed: () => _showExportDialog(context),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.swExportData),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(context.l10n.swExportAsPdf),
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
              title: Text(context.l10n.swExportAsCsv),
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
              title: Text(context.l10n.swExportAsJson),
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
            child: Text(context.l10n.swExportCancel),
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
