/// Storage Service
/// Handles file uploads to Supabase Storage

import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _supabase;
  final _logger = Logger('StorageService');

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
      _logger.fine('Starting upload for $fileName (type: $fileType)');
      _logger.finer('User ID: $userId, File size: ${fileBytes.length} bytes');

      // Create a unique file path: userId/fileType/timestamp_filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/$fileType/${timestamp}_$fileName';
      _logger.finer('Upload path: $filePath');

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
      _logger.finer('Content type: $contentType');

      // Upload to Supabase Storage using uploadBinary for byte arrays
      _logger.fine('Starting Supabase upload...');
      await _supabase.storage
          .from('documents')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: contentType,
              cacheControl: '3600',
              upsert: true, // Allow overwriting if file exists
            ),
          );

      _logger.info('Upload successful for $fileName');
      // Return storage path in Supabase format: bucket/path
      // Backend and institutions can generate URLs as needed
      final storagePath = 'documents/$filePath';
      _logger.finer('Returning path: $storagePath');
      return storagePath;
    } catch (e) {
      _logger.severe('Upload failed: $e', e);
      throw Exception('Failed to upload document: $e');
    }
  }

  /// Upload a profile photo to the avatars bucket
  ///
  /// [userId] - User ID for unique file naming
  /// [fileBytes] - Image content as bytes
  /// [fileName] - Original file name (used to determine extension)
  ///
  /// Returns the public URL of the uploaded avatar
  Future<String> uploadProfilePhoto({
    required String userId,
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    try {
      _logger.fine('Starting profile photo upload for user: $userId');
      _logger.finer('File size: ${fileBytes.length} bytes');

      // Get file extension
      final extension = fileName.toLowerCase().split('.').last;

      // Determine content type
      String contentType = 'image/jpeg';
      if (extension == 'png') {
        contentType = 'image/png';
      } else if (extension == 'gif') {
        contentType = 'image/gif';
      } else if (extension == 'webp') {
        contentType = 'image/webp';
      }

      // Create unique file path: userId/avatar_timestamp.extension
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/avatar_$timestamp.$extension';
      _logger.finer('Upload path: $filePath');

      // Upload to Supabase Storage user-profiles bucket
      await _supabase.storage
          .from('user-profiles')
          .uploadBinary(
            filePath,
            fileBytes,
            fileOptions: FileOptions(
              contentType: contentType,
              cacheControl: '3600',
              upsert: true,
            ),
          );

      _logger.info('Profile photo uploaded successfully');

      // Get the public URL for the uploaded avatar
      final publicUrl = _supabase.storage
          .from('user-profiles')
          .getPublicUrl(filePath);

      _logger.finer('Public URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      _logger.severe('Profile photo upload failed: $e', e);
      throw Exception('Failed to upload profile photo: $e');
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
