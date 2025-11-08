import 'dart:typed_data';

/// Stub implementation for non-web platforms
/// Downloads file to the file system (simplified for now)
Future<void> downloadFile({
  required Uint8List bytes,
  required String filename,
  required String mimeType,
}) async {
  // For non-web platforms (Windows, macOS, Linux, Android, iOS)
  // In production, you would use path_provider and file system APIs
  // For now, we just throw an informative error
  throw UnimplementedError(
    'File download for desktop/mobile platforms is not yet implemented. '
    'This feature requires integration with path_provider and file system APIs. '
    'For now, please use the web version or implement native file saving.',
  );
}
