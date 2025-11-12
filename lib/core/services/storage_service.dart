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
  /// Returns the public URL of the uploaded file
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

      // Upload to Supabase Storage
      final response = await _supabase.storage
          .from('documents')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: false,
            ),
          );

      // Get public URL
      final publicUrl = _supabase.storage
          .from('documents')
          .getPublicUrl(filePath);

      return publicUrl;
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
