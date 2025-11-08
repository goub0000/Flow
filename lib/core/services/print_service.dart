import 'package:flutter/material.dart';

/// Print Service
/// Provides print functionality for admin dashboard
class PrintService {
  PrintService._();

  /// Print current page
  /// TODO: Implement with package:web and dart:js_interop for web support
  static void printPage() {
    // TODO: Re-implement using package:web when migrating to Flutter 3.7+
    debugPrint('Print page requested');
  }

  /// Print specific widget
  static Future<void> printWidget({
    required BuildContext context,
    required Widget widget,
    String title = 'Print',
  }) async {
    // Show print preview dialog
    await showDialog(
      context: context,
      builder: (context) => _PrintPreviewDialog(
        title: title,
        child: widget,
      ),
    );
  }

  /// Print table data as HTML
  /// TODO: Implement with package:web and dart:js_interop for web support
  static void printTable({
    required String title,
    required List<String> headers,
    required List<List<String>> rows,
  }) {
    // TODO: Re-implement using package:web when migrating to Flutter 3.7+
    // For now, this is a placeholder for backend integration
    debugPrint('Print table: $title');
    debugPrint('Headers: ${headers.join(", ")}');
    debugPrint('Rows: ${rows.length}');
  }

  /// Print report
  /// TODO: Implement with package:web and dart:js_interop for web support
  static void printReport({
    required String title,
    required String content,
    String? subtitle,
    String? footer,
  }) {
    // TODO: Re-implement using package:web when migrating to Flutter 3.7+
    // For now, this is a placeholder for backend integration
    debugPrint('Print report: $title');
    if (subtitle != null) debugPrint('Subtitle: $subtitle');
    debugPrint('Content length: ${content.length} characters');
    if (footer != null) debugPrint('Footer: $footer');
  }

  static String _generateTableHTML(
    String title,
    List<String> headers,
    List<List<String>> rows,
  ) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>$title</title>
        <style>
          ${_getPrintStyles()}
        </style>
      </head>
      <body>
        <div class="print-container">
          <h1>$title</h1>
          <table>
            <thead>
              <tr>
                ${headers.map((h) => '<th>$h</th>').join()}
              </tr>
            </thead>
            <tbody>
              ${rows.map((row) => '<tr>${row.map((cell) => '<td>$cell</td>').join()}</tr>').join()}
            </tbody>
          </table>
          <div class="print-footer">
            <p>Printed on: ${DateTime.now().toString().split('.')[0]}</p>
          </div>
        </div>
      </body>
      </html>
    ''';
  }

  static String _generateReportHTML(
    String title,
    String content,
    String? subtitle,
    String? footer,
  ) {
    return '''
      <!DOCTYPE html>
      <html>
      <head>
        <title>$title</title>
        <style>
          ${_getPrintStyles()}
        </style>
      </head>
      <body>
        <div class="print-container">
          <h1>$title</h1>
          ${subtitle != null ? '<h2>$subtitle</h2>' : ''}
          <div class="content">
            $content
          </div>
          <div class="print-footer">
            ${footer ?? ''}
            <p>Printed on: ${DateTime.now().toString().split('.')[0]}</p>
          </div>
        </div>
      </body>
      </html>
    ''';
  }

  static String _getPrintStyles() {
    return '''
      @media print {
        @page {
          size: A4;
          margin: 2cm;
        }

        body {
          font-family: Arial, sans-serif;
          font-size: 12pt;
          line-height: 1.5;
          color: #000;
          background: #fff;
        }

        .print-container {
          max-width: 100%;
        }

        h1 {
          font-size: 24pt;
          margin-bottom: 10pt;
          border-bottom: 2pt solid #333;
          padding-bottom: 5pt;
        }

        h2 {
          font-size: 18pt;
          margin-bottom: 8pt;
          color: #666;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          margin: 20pt 0;
        }

        th, td {
          border: 1pt solid #ddd;
          padding: 8pt;
          text-align: left;
        }

        th {
          background-color: #f5f5f5;
          font-weight: bold;
        }

        tr:nth-child(even) {
          background-color: #fafafa;
        }

        .print-footer {
          margin-top: 30pt;
          padding-top: 10pt;
          border-top: 1pt solid #ddd;
          font-size: 10pt;
          color: #666;
        }

        .content {
          margin: 20pt 0;
        }

        /* Hide non-printable elements */
        .no-print,
        button,
        .sidebar,
        .toolbar,
        .fab,
        nav {
          display: none !important;
        }
      }

      /* Screen styles */
      @media screen {
        body {
          font-family: Arial, sans-serif;
          padding: 20px;
          background: #f5f5f5;
        }

        .print-container {
          max-width: 800px;
          margin: 0 auto;
          background: white;
          padding: 40px;
          box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        h1 {
          font-size: 28px;
          margin-bottom: 10px;
          border-bottom: 2px solid #333;
          padding-bottom: 10px;
        }

        h2 {
          font-size: 20px;
          margin-bottom: 10px;
          color: #666;
        }

        table {
          width: 100%;
          border-collapse: collapse;
          margin: 20px 0;
        }

        th, td {
          border: 1px solid #ddd;
          padding: 12px;
          text-align: left;
        }

        th {
          background-color: #f5f5f5;
          font-weight: bold;
        }

        tr:nth-child(even) {
          background-color: #fafafa;
        }

        .print-footer {
          margin-top: 30px;
          padding-top: 10px;
          border-top: 1px solid #ddd;
          font-size: 12px;
          color: #666;
        }

        .content {
          margin: 20px 0;
          line-height: 1.6;
        }
      }
    ''';
  }
}

/// Print Preview Dialog
class _PrintPreviewDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const _PrintPreviewDialog({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Print Preview - $title',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        PrintService.printPage();
                      },
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text('Print'),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Preview
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Print-friendly wrapper widget
class PrintWrapper extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showPrintButton;

  const PrintWrapper({
    required this.child,
    this.title = '',
    this.showPrintButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showPrintButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Print this page',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.print),
                onPressed: PrintService.printPage,
                tooltip: 'Print (Ctrl+P)',
              ),
            ],
          ),
        Expanded(child: child),
      ],
    );
  }
}

/// Extension for className on widgets (for HTML conversion)
extension WidgetClassName on Widget {
  Widget withClassName(String className) {
    return this; // In Flutter Web, this would need custom implementation
  }
}
