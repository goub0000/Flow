// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:typed_data';
import 'dart:html' as html;

/// Web-specific implementation using dart:html
/// Downloads file using Blob and anchor element
Future<void> downloadFile({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  final blob = html.Blob([bytes], mimeType);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
