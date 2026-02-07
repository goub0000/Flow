// ignore_for_file: deprecated_member_use

/// Export Service
/// Provides functionality to export data to various formats (PDF, CSV, Excel)
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Export format enum
enum ExportFormat {
  pdf,
  csv,
  json,
}

/// Export service class
class ExportService {
  /// Export data to CSV format
  static Future<void> exportToCSV({
    required String filename,
    required List<List<dynamic>> data,
    String delimiter = ',',
  }) async {
    try {
      // Generate CSV string
      final csvData = const ListToCsvConverter().convert(data, fieldDelimiter: delimiter);

      // Convert to bytes
      final bytes = utf8.encode(csvData);

      // Download file
      await _downloadFile(
        bytes: Uint8List.fromList(bytes),
        filename: '$filename.csv',
        mimeType: 'text/csv',
      );
    } catch (e) {
      throw Exception('Failed to export CSV: $e');
    }
  }

  /// Export data to JSON format
  static Future<void> exportToJSON({
    required String filename,
    required Map<String, dynamic> data,
  }) async {
    try {
      // Generate JSON string
      final jsonData = const JsonEncoder.withIndent('  ').convert(data);

      // Convert to bytes
      final bytes = utf8.encode(jsonData);

      // Download file
      await _downloadFile(
        bytes: Uint8List.fromList(bytes),
        filename: '$filename.json',
        mimeType: 'application/json',
      );
    } catch (e) {
      throw Exception('Failed to export JSON: $e');
    }
  }

  /// Export data to PDF format
  static Future<void> exportToPDF({
    required String filename,
    required String title,
    required List<String> headers,
    required List<List<dynamic>> data,
    String? subtitle,
    Map<String, String>? metadata,
  }) async {
    try {
      final pdf = pw.Document();

      // Add page with table
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return [
              // Title
              pw.Header(
                level: 0,
                child: pw.Text(
                  title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // Subtitle
              if (subtitle != null) ...[
                pw.SizedBox(height: 8),
                pw.Text(
                  subtitle,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
              ],

              // Metadata
              if (metadata != null && metadata.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: metadata.entries.map((entry) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 4),
                        child: pw.Row(
                          children: [
                            pw.Text(
                              '${entry.key}: ',
                              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            ),
                            pw.Text(entry.value),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],

              pw.SizedBox(height: 20),

              // Table
              pw.Table.fromTextArray(
                headers: headers,
                data: data,
                border: pw.TableBorder.all(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue700,
                ),
                cellHeight: 30,
                cellAlignments: {
                  for (int i = 0; i < headers.length; i++)
                    i: pw.Alignment.centerLeft,
                },
              ),

              pw.SizedBox(height: 20),

              // Footer
              pw.Text(
                'Generated on ${DateFormat('MMMM dd, yyyy \'at\' hh:mm a').format(DateTime.now())}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey600,
                ),
              ),
            ];
          },
        ),
      );

      // Save PDF
      final bytes = await pdf.save();
      await _downloadFile(
        bytes: bytes,
        filename: '$filename.pdf',
        mimeType: 'application/pdf',
      );
    } catch (e) {
      throw Exception('Failed to export PDF: $e');
    }
  }

  /// Export applications to PDF
  static Future<void> exportApplicationsToPDF({
    required List<dynamic> applications,
    required String studentName,
  }) async {
    final headers = ['Institution', 'Program', 'Status', 'Date Applied', 'Decision Date'];
    final data = applications.map((app) {
      return [
        app['institution_name'] ?? 'N/A',
        app['program_name'] ?? 'N/A',
        app['status'] ?? 'N/A',
        app['application_date'] != null
            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(app['application_date']))
            : 'N/A',
        app['decision_date'] != null
            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(app['decision_date']))
            : 'Pending',
      ];
    }).toList();

    await exportToPDF(
      filename: 'applications_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Application History',
      subtitle: 'Student: $studentName',
      headers: headers,
      data: data,
      metadata: {
        'Total Applications': applications.length.toString(),
        'Exported By': studentName,
        'Export Date': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      },
    );
  }

  /// Export applications to CSV
  static Future<void> exportApplicationsToCSV({
    required List<dynamic> applications,
  }) async {
    final data = [
      ['Institution', 'Program', 'Status', 'Date Applied', 'Decision Date', 'Notes'],
      ...applications.map((app) {
        return [
          app['institution_name'] ?? 'N/A',
          app['program_name'] ?? 'N/A',
          app['status'] ?? 'N/A',
          app['application_date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(app['application_date']))
              : '',
          app['decision_date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(app['decision_date']))
              : '',
          app['notes'] ?? '',
        ];
      }),
    ];

    await exportToCSV(
      filename: 'applications_${DateTime.now().millisecondsSinceEpoch}',
      data: data,
    );
  }

  /// Export analytics data to PDF
  static Future<void> exportAnalyticsToPDF({
    required String title,
    required Map<String, dynamic> analytics,
    String? description,
  }) async {
    final headers = ['Metric', 'Value'];
    final data = analytics.entries.map((entry) {
      return [
        _formatMetricName(entry.key),
        _formatMetricValue(entry.value),
      ];
    }).toList();

    await exportToPDF(
      filename: 'analytics_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: description,
      headers: headers,
      data: data,
      metadata: {
        'Report Type': 'Analytics',
        'Generated': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      },
    );
  }

  /// Export grades to PDF
  static Future<void> exportGradesToPDF({
    required List<dynamic> grades,
    required String studentName,
    String? courseName,
  }) async {
    final headers = [
      'Assignment',
      'Category',
      'Grade',
      'Max Points',
      'Percentage',
      'Date'
    ];
    final data = grades.map((grade) {
      return [
        grade['assignment_name'] ?? grade['name'] ?? 'N/A',
        grade['category'] ?? 'Assignment',
        grade['grade']?.toString() ?? grade['points_earned']?.toString() ?? 'N/A',
        grade['max_grade']?.toString() ?? grade['points_possible']?.toString() ?? 'N/A',
        grade['percentage'] != null
            ? '${(grade['percentage'] as num).toStringAsFixed(1)}%'
            : 'N/A',
        grade['graded_date'] != null || grade['submitted_date'] != null
            ? DateFormat('MMM dd, yyyy').format(DateTime.parse(
                grade['graded_date'] ?? grade['submitted_date']))
            : grade['date'] != null
                ? DateFormat('MMM dd, yyyy').format(DateTime.parse(grade['date']))
                : 'N/A',
      ];
    }).toList();

    // Calculate average if possible
    final percentages = grades
        .where((g) => g['percentage'] != null)
        .map((g) => (g['percentage'] as num).toDouble())
        .toList();
    final averageGrade = percentages.isNotEmpty
        ? percentages.reduce((a, b) => a + b) / percentages.length
        : null;

    await exportToPDF(
      filename: 'grades_${DateTime.now().millisecondsSinceEpoch}',
      title: courseName != null ? '$courseName - Grade Report' : 'Grade Report',
      subtitle: 'Student: $studentName',
      headers: headers,
      data: data,
      metadata: {
        'Total Assignments': grades.length.toString(),
        if (averageGrade != null)
          'Average Grade': '${averageGrade.toStringAsFixed(1)}%',
        'Student': studentName,
        if (courseName != null) 'Course': courseName,
        'Export Date': DateFormat('MMMM dd, yyyy').format(DateTime.now()),
      },
    );
  }

  /// Export grades to CSV
  static Future<void> exportGradesToCSV({
    required List<dynamic> grades,
  }) async {
    final data = [
      [
        'Assignment',
        'Category',
        'Grade',
        'Max Points',
        'Percentage',
        'Status',
        'Submitted Date',
        'Graded Date',
        'Feedback'
      ],
      ...grades.map((grade) {
        return [
          grade['assignment_name'] ?? grade['name'] ?? 'N/A',
          grade['category'] ?? 'Assignment',
          grade['grade']?.toString() ?? grade['points_earned']?.toString() ?? '',
          grade['max_grade']?.toString() ?? grade['points_possible']?.toString() ?? '',
          grade['percentage']?.toString() ?? '',
          grade['status'] ?? '',
          grade['submitted_date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(grade['submitted_date']))
              : grade['date'] ?? '',
          grade['graded_date'] != null
              ? DateFormat('yyyy-MM-dd').format(DateTime.parse(grade['graded_date']))
              : '',
          grade['feedback'] ?? grade['teacher_comments'] ?? '',
        ];
      }),
    ];

    await exportToCSV(
      filename: 'grades_${DateTime.now().millisecondsSinceEpoch}',
      data: data,
    );
  }

  /// Download file (cross-platform)
  static Future<void> _downloadFile({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    if (kIsWeb) {
      // Web platform
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
      );
    } else {
      // Mobile/Desktop platform
      // Note: This requires additional platform-specific implementation
      // For now, we'll use the printing package's share functionality
      await Printing.sharePdf(
        bytes: bytes,
        filename: filename,
      );
    }
  }

  /// Format metric name for display
  static String _formatMetricName(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Format metric value for display
  static String _formatMetricValue(dynamic value) {
    if (value == null) return 'N/A';
    if (value is num) {
      if (value is double) {
        return value.toStringAsFixed(2);
      }
      return value.toString();
    }
    if (value is bool) {
      return value ? 'Yes' : 'No';
    }
    return value.toString();
  }

  /// Show export options dialog
  static Future<ExportFormat?> showExportDialog() async {
    // This will be implemented in the UI layer
    return null;
  }
}
