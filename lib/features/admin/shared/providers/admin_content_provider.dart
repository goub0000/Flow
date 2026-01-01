import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Content item model for admin management
class ContentItem {
  final String id;
  final String title;
  final String? description;
  final String type; // 'course', 'lesson', 'module', 'assignment'
  final String status; // 'draft', 'pending', 'published', 'archived'
  final String? authorId;
  final String? authorName;
  final String? institutionId;
  final String? institutionName;
  final String? category;
  final String? level;
  final double? durationHours;
  final int enrollmentCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;

  const ContentItem({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.status,
    this.authorId,
    this.authorName,
    this.institutionId,
    this.institutionName,
    this.category,
    this.level,
    this.durationHours,
    this.enrollmentCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.publishedAt,
  });

  /// Parse ContentItem from API response
  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'course',
      status: json['status'] as String? ?? 'draft',
      authorId: json['author_id'] as String?,
      authorName: json['author_name'] as String?,
      institutionId: json['institution_id'] as String?,
      institutionName: json['institution_name'] as String?,
      category: json['category'] as String?,
      level: json['level'] as String?,
      durationHours: (json['duration_hours'] as num?)?.toDouble(),
      enrollmentCount: json['enrollment_count'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
    );
  }
}

/// Content statistics model
class ContentStats {
  final int total;
  final int published;
  final int draft;
  final int pending;
  final int archived;

  const ContentStats({
    this.total = 0,
    this.published = 0,
    this.draft = 0,
    this.pending = 0,
    this.archived = 0,
  });

  factory ContentStats.fromJson(Map<String, dynamic> json) {
    return ContentStats(
      total: json['total'] as int? ?? 0,
      published: json['published'] as int? ?? 0,
      draft: json['draft'] as int? ?? 0,
      pending: json['pending'] as int? ?? 0,
      archived: json['archived'] as int? ?? 0,
    );
  }
}

/// State class for content management
class AdminContentState {
  final List<ContentItem> content;
  final ContentStats stats;
  final bool isLoading;
  final String? error;

  const AdminContentState({
    this.content = const [],
    this.stats = const ContentStats(),
    this.isLoading = false,
    this.error,
  });

  AdminContentState copyWith({
    List<ContentItem>? content,
    ContentStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return AdminContentState(
      content: content ?? this.content,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for content management
class AdminContentNotifier extends StateNotifier<AdminContentState> {
  final ApiClient _apiClient;

  AdminContentNotifier(this._apiClient) : super(const AdminContentState()) {
    fetchContent();
  }

  /// Fetch all content from backend API
  Future<void> fetchContent({
    String? status,
    String? type,
    String? category,
    String? search,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (status != null && status != 'all') queryParams['status'] = status;
      if (type != null && type != 'all') queryParams['type'] = type;
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      final response = await _apiClient.get(
        '${ApiConfig.admin}/content$queryString',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final contentData = response.data!['content'] as List<dynamic>? ?? [];
        final statsData = response.data!['stats'] as Map<String, dynamic>? ?? {};

        final contentList = contentData
            .map((item) => ContentItem.fromJson(item as Map<String, dynamic>))
            .toList();

        final stats = ContentStats(
          total: response.data!['total'] as int? ?? contentList.length,
          published: statsData['published'] as int? ?? 0,
          draft: statsData['draft'] as int? ?? 0,
          pending: statsData['pending'] as int? ?? 0,
          archived: statsData['archived'] as int? ?? 0,
        );

        state = state.copyWith(
          content: contentList,
          stats: stats,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch content',
          isLoading: false,
        );
      }
    } catch (e) {
      print('[AdminContent] Error fetching content: $e');
      state = state.copyWith(
        error: 'Failed to fetch content: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update content status via backend API
  Future<bool> updateContentStatus(String contentId, String newStatus) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.admin}/content/$contentId/status',
        data: {'status': newStatus},
        fromJson: (data) => data,
      );

      if (response.success) {
        // Update locally
        final updatedContent = state.content.map((item) {
          if (item.id == contentId) {
            return ContentItem(
              id: item.id,
              title: item.title,
              description: item.description,
              type: item.type,
              status: newStatus,
              authorId: item.authorId,
              authorName: item.authorName,
              institutionId: item.institutionId,
              institutionName: item.institutionName,
              category: item.category,
              level: item.level,
              durationHours: item.durationHours,
              enrollmentCount: item.enrollmentCount,
              createdAt: item.createdAt,
              updatedAt: DateTime.now(),
              publishedAt: newStatus == 'published' ? DateTime.now() : item.publishedAt,
            );
          }
          return item;
        }).toList();

        // Update stats
        final newStats = _recalculateStats(updatedContent);
        state = state.copyWith(content: updatedContent, stats: newStats);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update content status',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update content status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete content via backend API (soft delete)
  Future<bool> deleteContent(String contentId) async {
    try {
      await _apiClient.delete('${ApiConfig.admin}/content/$contentId');

      final updatedContent = state.content.where((item) => item.id != contentId).toList();
      final newStats = _recalculateStats(updatedContent);
      state = state.copyWith(content: updatedContent, stats: newStats);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete content: ${e.toString()}',
      );
      return false;
    }
  }

  /// Approve content for publication
  Future<bool> approveContent(String contentId) async {
    return await updateContentStatus(contentId, 'published');
  }

  /// Reject content (set to draft)
  Future<bool> rejectContent(String contentId) async {
    return await updateContentStatus(contentId, 'draft');
  }

  /// Archive content
  Future<bool> archiveContent(String contentId) async {
    return await updateContentStatus(contentId, 'archived');
  }

  /// Recalculate stats from content list
  ContentStats _recalculateStats(List<ContentItem> contentList) {
    int published = 0, draft = 0, pending = 0, archived = 0;
    for (final item in contentList) {
      switch (item.status) {
        case 'published':
          published++;
          break;
        case 'draft':
          draft++;
          break;
        case 'pending':
          pending++;
          break;
        case 'archived':
          archived++;
          break;
      }
    }
    return ContentStats(
      total: contentList.length,
      published: published,
      draft: draft,
      pending: pending,
      archived: archived,
    );
  }

  /// Filter content locally
  List<ContentItem> filterContent({
    String? type,
    String? status,
    String? search,
  }) {
    var filtered = state.content;

    if (type != null && type != 'all') {
      filtered = filtered.where((item) => item.type == type).toList();
    }

    if (status != null && status != 'all') {
      filtered = filtered.where((item) => item.status == status).toList();
    }

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      filtered = filtered.where((item) =>
          item.title.toLowerCase().contains(query) ||
          (item.description?.toLowerCase().contains(query) ?? false) ||
          (item.authorName?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    return filtered;
  }

  /// Get content statistics
  ContentStats getContentStatistics() {
    return state.stats;
  }

  /// Get content pending review
  List<ContentItem> getContentPendingReview() {
    return state.content.where((item) => item.status == 'pending').toList();
  }

  /// Get published content
  List<ContentItem> getPublishedContent() {
    return state.content.where((item) => item.status == 'published').toList();
  }

  /// Create new content via backend API
  Future<bool> createContent({
    required String title,
    String? description,
    required String type,
    String? category,
    String? level,
    double? durationHours,
    String? institutionId,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/content',
        data: {
          'title': title,
          'description': description,
          'type': type,
          'category': category,
          'level': level,
          'duration_hours': durationHours,
          'institution_id': institutionId,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        // Refresh content list to show new item
        await fetchContent();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create content',
        );
        return false;
      }
    } catch (e) {
      print('[AdminContent] Error creating content: $e');
      state = state.copyWith(
        error: 'Failed to create content: ${e.toString()}',
      );
      return false;
    }
  }

  /// Assign content to users via backend API
  Future<bool> assignContent({
    required String contentId,
    required String targetType, // 'student', 'institution', 'all_students'
    List<String>? targetIds,
    bool isRequired = false,
    String? dueDate,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/content/assign',
        data: {
          'content_id': contentId,
          'target_type': targetType,
          'target_ids': targetIds,
          'is_required': isRequired,
          'due_date': dueDate,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to assign content',
        );
        return false;
      }
    } catch (e) {
      print('[AdminContent] Error assigning content: $e');
      state = state.copyWith(
        error: 'Failed to assign content: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get content assignments
  Future<List<Map<String, dynamic>>> getContentAssignments(String contentId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/content/$contentId/assignments',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final assignments = response.data!['assignments'] as List<dynamic>? ?? [];
        return assignments.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      print('[AdminContent] Error fetching assignments: $e');
      return [];
    }
  }

  /// Remove content assignment
  Future<bool> removeContentAssignment(String assignmentId) async {
    try {
      await _apiClient.delete('${ApiConfig.admin}/content/assignment/$assignmentId');
      return true;
    } catch (e) {
      print('[AdminContent] Error removing assignment: $e');
      return false;
    }
  }
}

/// Provider for admin content state
final adminContentProvider = StateNotifierProvider<AdminContentNotifier, AdminContentState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminContentNotifier(apiClient);
});

/// Provider for content list
final adminContentListProvider = Provider<List<ContentItem>>((ref) {
  final contentState = ref.watch(adminContentProvider);
  return contentState.content;
});

/// Provider for content statistics
final adminContentStatisticsProvider = Provider<ContentStats>((ref) {
  // Watch state to trigger rebuilds when content changes
  final contentState = ref.watch(adminContentProvider);
  return contentState.stats;
});

/// Provider for content pending review
final adminContentPendingReviewProvider = Provider<List<ContentItem>>((ref) {
  // Watch state to trigger rebuilds when content changes
  ref.watch(adminContentProvider);
  final notifier = ref.read(adminContentProvider.notifier);
  return notifier.getContentPendingReview();
});

/// Provider for published content
final adminContentPublishedProvider = Provider<List<ContentItem>>((ref) {
  // Watch state to trigger rebuilds when content changes
  ref.watch(adminContentProvider);
  final notifier = ref.read(adminContentProvider.notifier);
  return notifier.getPublishedContent();
});

/// Provider for checking if content is loading
final adminContentLoadingProvider = Provider<bool>((ref) {
  final contentState = ref.watch(adminContentProvider);
  return contentState.isLoading;
});

/// Provider for content error
final adminContentErrorProvider = Provider<String?>((ref) {
  final contentState = ref.watch(adminContentProvider);
  return contentState.error;
});
