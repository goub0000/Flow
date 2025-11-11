import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Content item model for admin management
class ContentItem {
  final String id;
  final String title;
  final String type; // 'course', 'lesson', 'module', 'assignment'
  final String status; // 'draft', 'review', 'published', 'archived'
  final String? authorId;
  final String? authorName;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final int views;
  final double rating;

  const ContentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    this.authorId,
    this.authorName,
    required this.createdAt,
    this.publishedAt,
    this.views = 0,
    this.rating = 0.0,
  });

  static ContentItem fromCourse(Course course) {
    return ContentItem(
      id: course.id,
      title: course.title,
      type: 'course',
      status: 'published',
      authorId: null,
      authorName: course.institutionName,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      publishedAt: DateTime.now().subtract(const Duration(days: 25)),
      views: course.enrolledStudents,
      rating: 4.5,
    );
  }

  static ContentItem mockContent(int index) {
    final types = ['course', 'lesson', 'module', 'assignment'];
    final statuses = ['draft', 'review', 'published', 'archived'];

    return ContentItem(
      id: 'content_$index',
      title: 'Content ${index + 1}',
      type: types[index % types.length],
      status: statuses[index % statuses.length],
      authorId: 'author_$index',
      authorName: 'Author ${index + 1}',
      createdAt: DateTime.now().subtract(Duration(days: index)),
      publishedAt: index % 2 == 0
          ? DateTime.now().subtract(Duration(days: index ~/ 2))
          : null,
      views: 100 + (index * 50),
      rating: 4.0 + (index % 10) * 0.1,
    );
  }
}

/// State class for content management
class AdminContentState {
  final List<ContentItem> content;
  final bool isLoading;
  final String? error;

  const AdminContentState({
    this.content = const [],
    this.isLoading = false,
    this.error,
  });

  AdminContentState copyWith({
    List<ContentItem>? content,
    bool? isLoading,
    String? error,
  }) {
    return AdminContentState(
      content: content ?? this.content,
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
  Future<void> fetchContent() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/content',
        fromJson: (data) {
          if (data is List) {
            // Backend may not have full content management yet
            return <ContentItem>[];
          }
          return <ContentItem>[];
        },
      );

      if (response.success) {
        state = state.copyWith(
          content: response.data ?? [],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch content',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch content: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update content status
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateContentStatus(String contentId, String newStatus) async {
    try {
      // TODO: Update in Firebase
      await Future.delayed(const Duration(milliseconds: 300));

      final updatedContent = state.content.map((item) {
        if (item.id == contentId) {
          return ContentItem(
            id: item.id,
            title: item.title,
            type: item.type,
            status: newStatus,
            authorId: item.authorId,
            authorName: item.authorName,
            createdAt: item.createdAt,
            publishedAt: newStatus == 'published' ? DateTime.now() : item.publishedAt,
            views: item.views,
            rating: item.rating,
          );
        }
        return item;
      }).toList();

      state = state.copyWith(content: updatedContent);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update content status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete content
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> deleteContent(String contentId) async {
    try {
      // TODO: Delete from Firebase
      await Future.delayed(const Duration(milliseconds: 500));

      final updatedContent = state.content.where((item) => item.id != contentId).toList();
      state = state.copyWith(content: updatedContent);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete content: ${e.toString()}',
      );
      return false;
    }
  }

  /// Approve content for publication
  /// TODO: Connect to backend API
  Future<bool> approveContent(String contentId) async {
    return await updateContentStatus(contentId, 'published');
  }

  /// Reject content
  /// TODO: Connect to backend API
  Future<bool> rejectContent(String contentId) async {
    return await updateContentStatus(contentId, 'draft');
  }

  /// Filter content
  List<ContentItem> filterContent({
    String? type,
    String? status,
  }) {
    var filtered = state.content;

    if (type != null && type != 'all') {
      filtered = filtered.where((item) => item.type == type).toList();
    }

    if (status != null && status != 'all') {
      filtered = filtered.where((item) => item.status == status).toList();
    }

    return filtered;
  }

  /// Get content statistics
  Map<String, dynamic> getContentStatistics() {
    final Map<String, int> typeCounts = {};
    final Map<String, int> statusCounts = {};
    int totalViews = 0;
    double totalRating = 0;

    for (final item in state.content) {
      typeCounts[item.type] = (typeCounts[item.type] ?? 0) + 1;
      statusCounts[item.status] = (statusCounts[item.status] ?? 0) + 1;
      totalViews += item.views;
      totalRating += item.rating;
    }

    final avgRating = state.content.isEmpty
        ? 0.0
        : totalRating / state.content.length;

    return {
      'total': state.content.length,
      'typeCounts': typeCounts,
      'statusCounts': statusCounts,
      'totalViews': totalViews,
      'averageRating': avgRating,
      'pendingReview': statusCounts['review'] ?? 0,
    };
  }

  /// Get content pending review
  List<ContentItem> getContentPendingReview() {
    return state.content.where((item) => item.status == 'review').toList();
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
final adminContentStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(adminContentProvider.notifier);
  return notifier.getContentStatistics();
});

/// Provider for content pending review
final adminContentPendingReviewProvider = Provider<List<ContentItem>>((ref) {
  final notifier = ref.watch(adminContentProvider.notifier);
  return notifier.getContentPendingReview();
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
