import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Resource item model for admin management
class ResourceItem {
  final String id;
  final String resourceType; // 'video' or 'text'
  final String? lessonId;
  final String? lessonTitle;
  final String? moduleTitle;
  final String? courseId;
  final String? courseTitle;
  final String title;
  final String? videoUrl;
  final String? videoPlatform;
  final int? durationSeconds;
  final String? contentFormat;
  final int? estimatedReadingTime;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ResourceItem({
    required this.id,
    required this.resourceType,
    this.lessonId,
    this.lessonTitle,
    this.moduleTitle,
    this.courseId,
    this.courseTitle,
    required this.title,
    this.videoUrl,
    this.videoPlatform,
    this.durationSeconds,
    this.contentFormat,
    this.estimatedReadingTime,
    required this.createdAt,
    this.updatedAt,
  });

  factory ResourceItem.fromJson(Map<String, dynamic> json) {
    return ResourceItem(
      id: json['id'] as String? ?? '',
      resourceType: json['resource_type'] as String? ?? 'text',
      lessonId: json['lesson_id'] as String?,
      lessonTitle: json['lesson_title'] as String?,
      moduleTitle: json['module_title'] as String?,
      courseId: json['course_id'] as String?,
      courseTitle: json['course_title'] as String?,
      title: json['title'] as String? ?? '',
      videoUrl: json['video_url'] as String?,
      videoPlatform: json['video_platform'] as String?,
      durationSeconds: json['duration_seconds'] as int?,
      contentFormat: json['content_format'] as String?,
      estimatedReadingTime: json['estimated_reading_time'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

/// Resource statistics model
class ResourceStats {
  final int totalResources;
  final int videoCount;
  final int textCount;
  final int totalDurationMinutes;
  final int totalCoursesWithResources;

  const ResourceStats({
    this.totalResources = 0,
    this.videoCount = 0,
    this.textCount = 0,
    this.totalDurationMinutes = 0,
    this.totalCoursesWithResources = 0,
  });

  factory ResourceStats.fromJson(Map<String, dynamic> json) {
    return ResourceStats(
      totalResources: json['total_resources'] as int? ?? 0,
      videoCount: json['video_count'] as int? ?? 0,
      textCount: json['text_count'] as int? ?? 0,
      totalDurationMinutes: json['total_duration_minutes'] as int? ?? 0,
      totalCoursesWithResources: json['total_courses_with_resources'] as int? ?? 0,
    );
  }
}

/// State class for resources management
class AdminResourcesState {
  final List<ResourceItem> resources;
  final ResourceStats stats;
  final bool isLoading;
  final String? error;

  const AdminResourcesState({
    this.resources = const [],
    this.stats = const ResourceStats(),
    this.isLoading = false,
    this.error,
  });

  AdminResourcesState copyWith({
    List<ResourceItem>? resources,
    ResourceStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return AdminResourcesState(
      resources: resources ?? this.resources,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for resources management
class AdminResourcesNotifier extends StateNotifier<AdminResourcesState> {
  final ApiClient _apiClient;

  AdminResourcesNotifier(this._apiClient) : super(const AdminResourcesState()) {
    fetchResources();
  }

  /// Fetch all resources from backend API
  Future<void> fetchResources({
    String? type,
    String? search,
    String? courseId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queryParams = <String, String>{};
      if (type != null && type != 'all') queryParams['resource_type'] = type;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (courseId != null && courseId.isNotEmpty) queryParams['course_id'] = courseId;

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      final response = await _apiClient.get(
        '${ApiConfig.admin}/resources$queryString',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final resourcesData = response.data!['resources'] as List<dynamic>? ?? [];
        final statsData = response.data!['stats'] as Map<String, dynamic>? ?? {};

        final resourcesList = resourcesData
            .map((item) => ResourceItem.fromJson(item as Map<String, dynamic>))
            .toList();

        final stats = ResourceStats.fromJson(statsData);

        state = state.copyWith(
          resources: resourcesList,
          stats: stats,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch resources',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch resources: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new resource (video or text) — creates lesson + content
  Future<bool> createResource({
    required String resourceType,
    required String courseId,
    required String moduleId,
    required String lessonTitle,
    // Video fields
    String? videoUrl,
    String? videoPlatform,
    int? durationSeconds,
    // Text fields
    String? content,
    String? contentFormat,
    int? estimatedReadingTime,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/resources',
        data: {
          'resource_type': resourceType,
          'course_id': courseId,
          'module_id': moduleId,
          'lesson_title': lessonTitle,
          'video_url': videoUrl,
          'video_platform': videoPlatform,
          'duration_seconds': durationSeconds,
          'content': content,
          'content_format': contentFormat,
          'estimated_reading_time': estimatedReadingTime,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        await fetchResources();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create resource',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create resource: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider for admin resources state
final adminResourcesProvider =
    StateNotifierProvider<AdminResourcesNotifier, AdminResourcesState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminResourcesNotifier(apiClient);
});

/// Provider for resource statistics
final adminResourcesStatsProvider = Provider<ResourceStats>((ref) {
  final resourcesState = ref.watch(adminResourcesProvider);
  return resourcesState.stats;
});
