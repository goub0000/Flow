import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Print Service
/// Provides print functionality for admin dashboard
class PrintService {
  PrintService._();

  static final _logger = Logger('PrintService');

  /// Print current page
  /// TODO: Implement with package:web and dart:js_interop for web support
  static void printPage() {
    // TODO: Re-implement using package:web when migrating to Flutter 3.7+
    _logger.fine('Print page requested');
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
    _logger.fine('Print table: $title (${headers.length} columns, ${rows.length} rows)');
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
    _logger.fine('Print report: $title (${content.length} characters)');
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
