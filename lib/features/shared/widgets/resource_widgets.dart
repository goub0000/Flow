import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Resources & Materials Widgets
///
/// Comprehensive resource management UI components including:
/// - Resource cards (documents, videos, links, etc.)
/// - Download indicators
/// - Category chips
/// - File type badges
/// - Bookmark buttons
/// - Preview thumbnails
///
/// Backend Integration TODO:
/// ```dart
/// // File Storage with Firebase Storage
/// import 'package:firebase_storage/firebase_storage.dart';
/// import 'package:path_provider/path_provider.dart';
/// import 'dart:io';
///
/// class ResourceStorageService {
///   final FirebaseStorage _storage = FirebaseStorage.instance;
///
///   Future<String> uploadResource({
///     required File file,
///     required String courseId,
///     required String fileName,
///   }) async {
///     final ref = _storage.ref().child('resources/$courseId/$fileName');
///     final uploadTask = ref.putFile(file);
///
///     final snapshot = await uploadTask;
///     return await snapshot.ref.getDownloadURL();
///   }
///
///   Future<void> downloadResource({
///     required String url,
///     required String fileName,
///     required Function(double) onProgress,
///   }) async {
///     final ref = _storage.refFromURL(url);
///     final dir = await getApplicationDocumentsDirectory();
///     final file = File('${dir.path}/$fileName');
///
///     final downloadTask = ref.writeToFile(file);
///     downloadTask.snapshotEvents.listen((snapshot) {
///       final progress = snapshot.bytesTransferred / snapshot.totalBytes;
///       onProgress(progress);
///     });
///
///     await downloadTask;
///   }
///
///   Future<void> deleteResource(String url) async {
///     final ref = _storage.refFromURL(url);
///     await ref.delete();
///   }
/// }
///
/// // Resources API
/// import 'package:dio/dio.dart';
///
/// class ResourceRepository {
///   final Dio _dio;
///
///   Future<List<ResourceModel>> getResources({
///     String? courseId,
///     String? lessonId,
///     ResourceType? type,
///     String? category,
///   }) async {
///     final response = await _dio.get('/api/resources', queryParameters: {
///       'courseId': courseId,
///       'lessonId': lessonId,
///       'type': type?.name,
///       'category': category,
///     });
///
///     return (response.data['resources'] as List)
///         .map((json) => ResourceModel.fromJson(json))
///         .toList();
///   }
///
///   Future<ResourceModel> getResourceDetail(String resourceId) async {
///     final response = await _dio.get('/api/resources/$resourceId');
///     return ResourceModel.fromJson(response.data);
///   }
///
///   Future<void> trackResourceView(String resourceId) async {
///     await _dio.post('/api/resources/$resourceId/view');
///   }
///
///   Future<void> trackResourceDownload(String resourceId) async {
///     await _dio.post('/api/resources/$resourceId/download');
///   }
///
///   Future<void> bookmarkResource(String resourceId) async {
///     await _dio.post('/api/resources/$resourceId/bookmark');
///   }
///
///   Future<void> removeBookmark(String resourceId) async {
///     await _dio.delete('/api/resources/$resourceId/bookmark');
///   }
/// }
///
/// // Local storage for offline access
/// import 'package:sqflite/sqflite.dart';
///
/// class LocalResourcesDatabase {
///   late Database _database;
///
///   Future<void> initialize() async {
///     _database = await openDatabase(
///       'resources.db',
///       version: 1,
///       onCreate: (db, version) {
///         return db.execute(
///           'CREATE TABLE resources(id TEXT PRIMARY KEY, title TEXT, '
///           'filePath TEXT, type TEXT, size INTEGER, downloadedAt TEXT)',
///         );
///       },
///     );
///   }
///
///   Future<void> saveDownloadedResource(ResourceModel resource, String filePath) async {
///     await _database.insert(
///       'resources',
///       {
///         'id': resource.id,
///         'title': resource.title,
///         'filePath': filePath,
///         'type': resource.type.name,
///         'size': resource.fileSize,
///         'downloadedAt': DateTime.now().toIso8601String(),
///       },
///       conflictAlgorithm: ConflictAlgorithm.replace,
///     );
///   }
///
///   Future<List<Map<String, dynamic>>> getDownloadedResources() async {
///     return await _database.query('resources', orderBy: 'downloadedAt DESC');
///   }
/// }
/// ```

/// Resource Type Enum
enum ResourceType {
  pdf,
  video,
  audio,
  document,
  presentation,
  spreadsheet,
  image,
  link,
  zip,
}

extension ResourceTypeExtension on ResourceType {
  String get displayName {
    switch (this) {
      case ResourceType.pdf:
        return 'PDF';
      case ResourceType.video:
        return 'Video';
      case ResourceType.audio:
        return 'Audio';
      case ResourceType.document:
        return 'Document';
      case ResourceType.presentation:
        return 'Presentation';
      case ResourceType.spreadsheet:
        return 'Spreadsheet';
      case ResourceType.image:
        return 'Image';
      case ResourceType.link:
        return 'Link';
      case ResourceType.zip:
        return 'Archive';
    }
  }

  IconData get icon {
    switch (this) {
      case ResourceType.pdf:
        return Icons.picture_as_pdf;
      case ResourceType.video:
        return Icons.play_circle;
      case ResourceType.audio:
        return Icons.audiotrack;
      case ResourceType.document:
        return Icons.description;
      case ResourceType.presentation:
        return Icons.slideshow;
      case ResourceType.spreadsheet:
        return Icons.table_chart;
      case ResourceType.image:
        return Icons.image;
      case ResourceType.link:
        return Icons.link;
      case ResourceType.zip:
        return Icons.folder_zip;
    }
  }

  Color get color {
    switch (this) {
      case ResourceType.pdf:
        return const Color(0xFFE53935);
      case ResourceType.video:
        return const Color(0xFF1E88E5);
      case ResourceType.audio:
        return const Color(0xFFFF6F00);
      case ResourceType.document:
        return const Color(0xFF1976D2);
      case ResourceType.presentation:
        return const Color(0xFFFB8C00);
      case ResourceType.spreadsheet:
        return const Color(0xFF43A047);
      case ResourceType.image:
        return const Color(0xFF8E24AA);
      case ResourceType.link:
        return AppColors.info;
      case ResourceType.zip:
        return AppColors.textSecondary;
    }
  }
}

/// Resource Model
class ResourceModel {
  final String id;
  final String title;
  final String? description;
  final ResourceType type;
  final String url;
  final int fileSize; // bytes
  final String? thumbnailUrl;
  final String? category;
  final List<String> tags;
  final DateTime uploadedAt;
  final String? courseId;
  final String? lessonId;
  final int downloadCount;
  final int viewCount;
  final bool isBookmarked;
  final bool isDownloaded;

  const ResourceModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.url,
    required this.fileSize,
    this.thumbnailUrl,
    this.category,
    this.tags = const [],
    required this.uploadedAt,
    this.courseId,
    this.lessonId,
    this.downloadCount = 0,
    this.viewCount = 0,
    this.isBookmarked = false,
    this.isDownloaded = false,
  });

  String get formattedSize {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ResourceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ResourceType.document,
      ),
      url: json['url'],
      fileSize: json['fileSize'],
      thumbnailUrl: json['thumbnailUrl'],
      category: json['category'],
      tags: List<String>.from(json['tags'] ?? []),
      uploadedAt: DateTime.parse(json['uploadedAt']),
      courseId: json['courseId'],
      lessonId: json['lessonId'],
      downloadCount: json['downloadCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      isBookmarked: json['isBookmarked'] ?? false,
      isDownloaded: json['isDownloaded'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'url': url,
      'fileSize': fileSize,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'tags': tags,
      'uploadedAt': uploadedAt.toIso8601String(),
      'courseId': courseId,
      'lessonId': lessonId,
      'downloadCount': downloadCount,
      'viewCount': viewCount,
      'isBookmarked': isBookmarked,
      'isDownloaded': isDownloaded,
    };
  }
}

/// Resource Card Widget
class ResourceCard extends StatelessWidget {
  final ResourceModel resource;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final double? downloadProgress;

  const ResourceCard({
    super.key,
    required this.resource,
    this.onTap,
    this.onDownload,
    this.onBookmark,
    this.onShare,
    this.downloadProgress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail or Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: resource.type.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: resource.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          resource.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              resource.type.icon,
                              color: resource.type.color,
                              size: 28,
                            );
                          },
                        ),
                      )
                    : Icon(
                        resource.type.icon,
                        color: resource.type.color,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            resource.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (resource.isDownloaded)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.download_done,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (resource.description != null)
                      Text(
                        resource.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        _buildInfoChip(
                          icon: resource.type.icon,
                          label: resource.type.displayName,
                          color: resource.type.color,
                        ),
                        _buildInfoChip(
                          icon: Icons.storage,
                          label: resource.formattedSize,
                          color: AppColors.textSecondary,
                        ),
                        if (resource.downloadCount > 0)
                          _buildInfoChip(
                            icon: Icons.download,
                            label: '${resource.downloadCount}',
                            color: AppColors.textSecondary,
                          ),
                      ],
                    ),
                    if (downloadProgress != null) ...[
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: downloadProgress,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 4,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(downloadProgress! * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  if (onBookmark != null)
                    IconButton(
                      icon: Icon(
                        resource.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        color: resource.isBookmarked
                            ? AppColors.warning
                            : AppColors.textSecondary,
                      ),
                      onPressed: onBookmark,
                      tooltip: resource.isBookmarked
                          ? 'Remove bookmark'
                          : 'Bookmark',
                    ),
                  if (onDownload != null && downloadProgress == null)
                    IconButton(
                      icon: Icon(
                        resource.isDownloaded
                            ? Icons.download_done
                            : Icons.download,
                        color: resource.isDownloaded
                            ? AppColors.success
                            : AppColors.textSecondary,
                      ),
                      onPressed: onDownload,
                      tooltip: resource.isDownloaded ? 'Downloaded' : 'Download',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Resource Category Chip
class ResourceCategoryChip extends StatelessWidget {
  final String category;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const ResourceCategoryChip({
    super.key,
    required this.category,
    this.count = 0,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              category,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty Resources State
class EmptyResourcesState extends StatelessWidget {
  final String message;
  final String? subtitle;

  const EmptyResourcesState({
    super.key,
    this.message = 'No Resources Available',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.folder_open,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle ?? 'Resources will appear here when available',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Download Progress Dialog
class DownloadProgressDialog extends StatelessWidget {
  final String fileName;
  final double progress;

  const DownloadProgressDialog({
    super.key,
    required this.fileName,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Downloading'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fileName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Resource Filter Chip
class ResourceFilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const ResourceFilterChip({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: onTap != null ? (_) => onTap!() : null,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
    );
  }
}
