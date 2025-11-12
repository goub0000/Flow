/// Storage Service
/// Handles file uploads to Supabase Storage

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase;

  StorageService(this._supabase);

  /// Upload a document to the documents bucket
  ///
  /// [userId] - User ID for folder organization
  /// [fileName] - Name of the file
  /// [fileBytes] - File content as bytes
  /// [fileType] - Type of document (transcript, id, photo, etc.)
  ///
  /// Returns the signed URL of the uploaded file (valid for 1 year)
  Future<String> uploadDocument({
    required String userId,
    required String fileName,
    required Uint8List fileBytes,
    required String fileType,
  }) async {
    try {
      // Create a unique file path: userId/fileType/timestamp_filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/$fileType/${timestamp}_$fileName';

      // Determine content type from file extension
      String contentType = 'application/octet-stream';
      final extension = fileName.toLowerCase().split('.').last;
      switch (extension) {
        case 'pdf':
          contentType = 'application/pdf';
          break;
        case 'doc':
          contentType = 'application/msword';
          break;
        case 'docx':
          contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
          break;
        case 'jpg':
        case 'jpeg':
          contentType = 'image/jpeg';
          break;
        case 'png':
          contentType = 'image/png';
          break;
      }

      // Upload to Supabase Storage
      await _supabase.storage
          .from('documents')
          .upload(
            filePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: contentType,
              cacheControl: '3600',
              upsert: true, // Allow overwriting if file exists
            ),
          );

      // Return storage path in Supabase format: bucket/path
      // Backend and institutions can generate URLs as needed
      return 'documents/$filePath';
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  /// Delete a document from storage
  Future<void> deleteDocument(String filePath) async {
    try {
      await _supabase.storage.from('documents').remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Get signed URL for private document access
  Future<String> getSignedUrl(String filePath, {int expiresIn = 3600}) async {
    try {
      final signedUrl = await _supabase.storage
          .from('documents')
          .createSignedUrl(filePath, expiresIn);
      return signedUrl;
    } catch (e) {
      throw Exception('Failed to get signed URL: $e');
    }
  }
}
