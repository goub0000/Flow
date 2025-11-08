import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
// Conditional import for web-only functionality
import 'export_utils_stub.dart'
    if (dart.library.html) 'export_utils_web.dart' as platform;

/// Export utility for generating and downloading CSV, Excel, and PDF files
class ExportUtils {
  /// Export data to CSV format and trigger download
  static Future<void> exportToCSV({
    required List<Map<String, dynamic>> data,
    required String filename,
  }) async {
    if (data.isEmpty) {
      throw Exception('No data to export');
    }

    // Get headers from first row
    final headers = data.first.keys.toList();

    // Build CSV content
    final csvBuffer = StringBuffer();

    // Add headers
    csvBuffer.writeln(_escapeCSVRow(headers));

    // Add data rows
    for (final row in data) {
      final values = headers.map((header) => row[header]?.toString() ?? '').toList();
      csvBuffer.writeln(_escapeCSVRow(values));
    }

    // Download file
    await _downloadFile(
      content: csvBuffer.toString(),
      filename: '$filename.csv',
      mimeType: 'text/csv',
    );
  }

  /// Export data to Excel format (simple CSV-based implementation)
  /// Note: For full Excel support, integrate the 'excel' package
  static Future<void> exportToExcel({
    required List<Map<String, dynamic>> data,
    required String filename,
  }) async {
    if (data.isEmpty) {
      throw Exception('No data to export');
    }

    // For now, use CSV format with .xlsx extension
    // In production, integrate the 'excel' package for proper XLSX support
    final headers = data.first.keys.toList();
    final csvBuffer = StringBuffer();

    csvBuffer.writeln(_escapeCSVRow(headers));

    for (final row in data) {
      final values = headers.map((header) => row[header]?.toString() ?? '').toList();
      csvBuffer.writeln(_escapeCSVRow(values));
    }

    await _downloadFile(
      content: csvBuffer.toString(),
      filename: '$filename.xlsx',
      mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
  }

  /// Export data to PDF format (simple text-based implementation)
  /// Note: For full PDF support, integrate the 'pdf' package
  static Future<void> exportToPDF({
    required List<Map<String, dynamic>> data,
    required String filename,
    String? title,
  }) async {
    if (data.isEmpty) {
      throw Exception('No data to export');
    }

    // Simple PDF generation (for production, use 'pdf' package)
    final pdfContent = StringBuffer();
    pdfContent.writeln(title ?? 'Export Data');
    pdfContent.writeln('=' * 80);
    pdfContent.writeln('');

    for (final row in data) {
      for (final entry in row.entries) {
        pdfContent.writeln('${entry.key}: ${entry.value}');
      }
      pdfContent.writeln('-' * 80);
    }

    await _downloadFile(
      content: pdfContent.toString(),
      filename: '$filename.pdf',
      mimeType: 'application/pdf',
    );
  }

  /// Escape CSV row values
  static String _escapeCSVRow(List<String> values) {
    return values.map((value) {
      // Escape quotes and wrap in quotes if contains comma, quote, or newline
      if (value.contains(',') || value.contains('"') || value.contains('\n')) {
        return '"${value.replaceAll('"', '""')}"';
      }
      return value;
    }).join(',');
  }

  /// Download file (platform-aware)
  static Future<void> _downloadFile({
    required String content,
    required String filename,
    required String mimeType,
  }) async {
    final bytes = utf8.encode(content);
    await platform.downloadFile(
      bytes: bytes,
      filename: filename,
      mimeType: mimeType,
    );
  }

  /// Show export options dialog
  static Future<String?> showExportDialog(dynamic context) async {
    return await _showExportOptionsDialog(context);
  }

  static Future<String?> _showExportOptionsDialog(dynamic context) async {
    // This would be implemented with a proper dialog
    // For now, return a default format
    return 'csv';
  }
}

/// Export format enumeration
enum ExportFormat {
  csv,
  excel,
  pdf,
}

/// Extension for ExportFormat
extension ExportFormatExtension on ExportFormat {
  String get displayName {
    switch (this) {
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.excel:
        return 'Excel';
      case ExportFormat.pdf:
        return 'PDF';
    }
  }

  String get extension {
    switch (this) {
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.excel:
        return 'xlsx';
      case ExportFormat.pdf:
        return 'pdf';
    }
  }
}
