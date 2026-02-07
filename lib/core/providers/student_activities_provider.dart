import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/activity_models.dart';
import '../services/student_activities_api_service.dart';
import './service_providers.dart';

/// State for student activities
class StudentActivitiesState {
  final List<StudentActivity> activities;
  final int totalCount;
  final int currentPage;
  final int limit;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final bool isLoadingMore;

  const StudentActivitiesState({
    this.activities = const [],
    this.totalCount = 0,
    this.currentPage = 1,
    this.limit = 10,
    this.hasMore = false,
    this.isLoading = false,
    this.error,
    this.isLoadingMore = false,
  });

  StudentActivitiesState copyWith({
    List<StudentActivity>? activities,
    int? totalCount,
    int? currentPage,
    int? limit,
    bool? hasMore,
    bool? isLoading,
    String? error,
    bool? isLoadingMore,
  }) {
    return StudentActivitiesState(
      activities: activities ?? this.activities,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Notifier for managing student activities
class StudentActivitiesNotifier extends StateNotifier<StudentActivitiesState> {
  final StudentActivitiesApiService _apiService;

  StudentActivitiesNotifier(this._apiService)
      : super(const StudentActivitiesState());

  /// Fetch activities with optional filters
  Future<void> fetchActivities({
    int page = 1,
    int limit = 10,
    List<StudentActivityType>? activityTypes,
    DateTime? startDate,
    DateTime? endDate,
    bool append = false,
  }) async {
    if (append) {
      state = state.copyWith(isLoadingMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final filters = StudentActivityFilterRequest(
        page: page,
        limit: limit,
        activityTypes: activityTypes,
        startDate: startDate,
        endDate: endDate,
      );

      final response = await _apiService.getMyActivities(filters: filters);

      if (append) {
        // Append to existing activities
        final updatedActivities = [
          ...state.activities,
          ...response.activities,
        ];
        state = state.copyWith(
          activities: updatedActivities,
          totalCount: response.totalCount,
          currentPage: response.page,
          limit: response.limit,
          hasMore: response.hasMore,
          isLoading: false,
          isLoadingMore: false,
        );
      } else {
        // Replace activities
        state = state.copyWith(
          activities: response.activities,
          totalCount: response.totalCount,
          currentPage: response.page,
          limit: response.limit,
          hasMore: response.hasMore,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  /// Load next page of activities
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) return;

    await fetchActivities(
      page: state.currentPage + 1,
      limit: state.limit,
      append: true,
    );
  }

  /// Refresh activities (pull to refresh)
  Future<void> refresh() async {
    await fetchActivities(page: 1, limit: state.limit);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Get activities by type
  List<StudentActivity> getActivitiesByType(StudentActivityType type) {
    return state.activities.where((a) => a.type == type).toList();
  }

  /// Get recent activities (last N days)
  List<StudentActivity> getRecentActivities({int days = 7}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return state.activities
        .where((a) => a.timestamp.isAfter(cutoffDate))
        .toList();
  }

  /// Get unread message activities
  List<StudentActivity> getUnreadMessages() {
    return state.activities
        .where((a) =>
            a.type == StudentActivityType.messageReceived &&
            a.metadata['is_read'] == false)
        .toList();
  }
}

/// Provider for student activities API service
final studentActivitiesApiServiceProvider = Provider<StudentActivitiesApiService>((ref) {
  // Get the access token from the auth service
  final authService = ref.watch(authServiceProvider);
  final accessToken = authService.accessToken;

  return StudentActivitiesApiService(accessToken: accessToken);
});

/// Provider for student activities state
final studentActivitiesProvider =
    StateNotifierProvider.autoDispose<StudentActivitiesNotifier,
        StudentActivitiesState>((ref) {
  final apiService = ref.watch(studentActivitiesApiServiceProvider);
  final notifier = StudentActivitiesNotifier(apiService);

  // Auto-fetch on creation
  Future.microtask(() => notifier.fetchActivities());

  return notifier;
});

// ==================== Derived Providers ====================

/// Provider for recent activities (last 7 days)
final recentActivitiesProvider = Provider.autoDispose<List<StudentActivity>>((ref) {
  final state = ref.watch(studentActivitiesProvider);
  final cutoffDate = DateTime.now().subtract(const Duration(days: 7));
  return state.activities
      .where((a) => a.timestamp.isAfter(cutoffDate))
      .toList();
});

/// Provider for application-related activities
final applicationActivitiesProvider =
    Provider.autoDispose<List<StudentActivity>>((ref) {
  final state = ref.watch(studentActivitiesProvider);
  return state.activities
      .where((a) =>
          a.type == StudentActivityType.applicationSubmitted ||
          a.type == StudentActivityType.applicationStatusChanged)
      .toList();
});

/// Provider for achievement activities
final achievementActivitiesProvider =
    Provider.autoDispose<List<StudentActivity>>((ref) {
  final state = ref.watch(studentActivitiesProvider);
  return state.activities
      .where((a) => a.type == StudentActivityType.achievementEarned)
      .toList();
});

/// Provider for meeting activities
final meetingActivitiesProvider =
    Provider.autoDispose<List<StudentActivity>>((ref) {
  final state = ref.watch(studentActivitiesProvider);
  return state.activities
      .where((a) =>
          a.type == StudentActivityType.meetingScheduled ||
          a.type == StudentActivityType.meetingCompleted)
      .toList();
});

/// Provider for unread message activities
final unreadMessageActivitiesProvider =
    Provider.autoDispose<List<StudentActivity>>((ref) {
  final state = ref.watch(studentActivitiesProvider);
  return state.activities
      .where((a) =>
          a.type == StudentActivityType.messageReceived &&
          a.metadata['is_read'] == false)
      .toList();
});

/// Provider for activity loading state
final activitiesLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(studentActivitiesProvider).isLoading;
});

/// Provider for activity error state
final activitiesErrorProvider = Provider.autoDispose<String?>((ref) {
  return ref.watch(studentActivitiesProvider).error;
});

/// Provider for has more activities flag
final hasMoreActivitiesProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(studentActivitiesProvider).hasMore;
});
