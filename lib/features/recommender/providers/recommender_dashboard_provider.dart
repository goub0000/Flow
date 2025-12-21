import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recommendation_letter_models.dart';
import 'recommender_requests_provider.dart';

/// State class for recommender dashboard data
class RecommenderDashboardState {
  final Map<String, dynamic> statistics;
  final List<Map<String, dynamic>> recentActivity;
  final bool isLoading;
  final String? error;

  const RecommenderDashboardState({
    this.statistics = const {},
    this.recentActivity = const [],
    this.isLoading = false,
    this.error,
  });

  RecommenderDashboardState copyWith({
    Map<String, dynamic>? statistics,
    List<Map<String, dynamic>>? recentActivity,
    bool? isLoading,
    String? error,
  }) {
    return RecommenderDashboardState(
      statistics: statistics ?? this.statistics,
      recentActivity: recentActivity ?? this.recentActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing recommender dashboard
class RecommenderDashboardNotifier extends StateNotifier<RecommenderDashboardState> {
  final Ref ref;

  RecommenderDashboardNotifier(this.ref) : super(const RecommenderDashboardState()) {
    loadDashboardData();
  }

  /// Load all dashboard data from backend via requests provider
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get dashboard summary from requests provider (which fetches from backend)
      final dashboardSummary = ref.read(recommenderDashboardSummaryProvider);
      final requestStats = ref.read(recommenderRequestStatisticsProvider);
      final requests = ref.read(recommenderRequestsListProvider);

      final statistics = {
        // Request statistics from backend
        'totalRequests': dashboardSummary?.totalRequests ?? requestStats['total'] ?? 0,
        'pendingRequests': dashboardSummary?.pendingRequests ?? requestStats['pending'] ?? 0,
        'inProgressRequests': dashboardSummary?.inProgress ?? requestStats['inProgress'] ?? 0,
        'completedRequests': dashboardSummary?.completed ?? requestStats['completed'] ?? 0,
        'overdueRequests': dashboardSummary?.overdueRequests ?? requestStats['overdue'] ?? 0,
        'urgentRequests': dashboardSummary?.urgentRequests ?? requestStats['urgent'] ?? 0,

        // Additional metrics
        'completionRate': _calculateCompletionRate(dashboardSummary, requestStats),
        'averageResponseTime': _calculateAverageResponseTime(requests),
        'requestsThisMonth': _countRequestsThisMonth(requests),
      };

      // Generate activity from actual requests
      final recentActivity = _generateActivityFromRequests(requests);

      state = state.copyWith(
        statistics: statistics,
        recentActivity: recentActivity,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load dashboard data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Calculate completion rate
  String _calculateCompletionRate(
    RecommenderDashboardSummary? summary,
    Map<String, int> requestStats,
  ) {
    final total = summary?.totalRequests ?? requestStats['total'] ?? 0;
    final completed = summary?.completed ?? requestStats['completed'] ?? 0;

    if (total == 0) return '0.0';

    return (completed / total * 100).toStringAsFixed(1);
  }

  /// Calculate average response time from requests
  String _calculateAverageResponseTime(List<RecommendationRequest> requests) {
    final acceptedRequests = requests.where((r) => r.acceptedAt != null).toList();

    if (acceptedRequests.isEmpty) return 'N/A';

    double totalDays = 0;
    for (final request in acceptedRequests) {
      final responseTime = request.acceptedAt!.difference(request.requestedAt);
      totalDays += responseTime.inHours / 24;
    }

    final avgDays = totalDays / acceptedRequests.length;
    return '${avgDays.toStringAsFixed(1)} days';
  }

  /// Count requests created this month
  int _countRequestsThisMonth(List<RecommendationRequest> requests) {
    final now = DateTime.now();
    return requests.where((r) {
      return r.requestedAt.year == now.year && r.requestedAt.month == now.month;
    }).length;
  }

  /// Generate recent activity from actual requests
  List<Map<String, dynamic>> _generateActivityFromRequests(List<RecommendationRequest> requests) {
    final activity = <Map<String, dynamic>>[];

    // Sort by most recent update
    final sortedRequests = List<RecommendationRequest>.from(requests)
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    for (final request in sortedRequests.take(10)) {
      final activityItem = _requestToActivity(request);
      if (activityItem != null) {
        activity.add(activityItem);
      }
    }

    return activity;
  }

  /// Convert a request to an activity item
  Map<String, dynamic>? _requestToActivity(RecommendationRequest request) {
    switch (request.status) {
      case RecommendationRequestStatus.pending:
        return {
          'type': 'new_request',
          'title': 'New Recommendation Request',
          'description': 'Request from ${request.studentName ?? 'Student'} for ${request.institutionName ?? 'Institution'}',
          'timestamp': request.requestedAt,
          'icon': 'mail',
          'color': 'blue',
          'requestId': request.id,
        };
      case RecommendationRequestStatus.accepted:
        return {
          'type': 'request_accepted',
          'title': 'Request Accepted',
          'description': 'Accepted request from ${request.studentName ?? 'Student'}',
          'timestamp': request.acceptedAt ?? request.updatedAt,
          'icon': 'check_circle',
          'color': 'green',
          'requestId': request.id,
        };
      case RecommendationRequestStatus.inProgress:
        return {
          'type': 'in_progress',
          'title': 'Letter In Progress',
          'description': 'Writing letter for ${request.studentName ?? 'Student'} - ${request.institutionName ?? 'Institution'}',
          'timestamp': request.updatedAt,
          'icon': 'edit',
          'color': 'purple',
          'requestId': request.id,
        };
      case RecommendationRequestStatus.completed:
        return {
          'type': 'recommendation_submitted',
          'title': 'Letter Submitted',
          'description': 'Letter for ${request.studentName ?? 'Student'} submitted successfully',
          'timestamp': request.completedAt ?? request.updatedAt,
          'icon': 'send',
          'color': 'green',
          'requestId': request.id,
        };
      case RecommendationRequestStatus.declined:
        return {
          'type': 'request_declined',
          'title': 'Request Declined',
          'description': 'Declined request from ${request.studentName ?? 'Student'}',
          'timestamp': request.declinedAt ?? request.updatedAt,
          'icon': 'cancel',
          'color': 'red',
          'requestId': request.id,
        };
      default:
        return null;
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    // First refresh the requests provider
    await ref.read(recommenderRequestsProvider.notifier).refresh();
    // Then reload dashboard data
    await loadDashboardData();
  }

  /// Get statistics by key
  dynamic getStatistic(String key) {
    return state.statistics[key];
  }

  /// Get activity by type
  List<Map<String, dynamic>> getActivityByType(String type) {
    return state.recentActivity.where((activity) {
      return activity['type'] == type;
    }).toList();
  }

  /// Get activity count for today
  int getTodayActivityCount() {
    final today = DateTime.now();
    return state.recentActivity.where((activity) {
      final timestamp = activity['timestamp'] as DateTime;
      return timestamp.year == today.year &&
          timestamp.month == today.month &&
          timestamp.day == today.day;
    }).length;
  }
}

/// Provider for recommender dashboard state
final recommenderDashboardProvider = StateNotifierProvider<RecommenderDashboardNotifier, RecommenderDashboardState>((ref) {
  return RecommenderDashboardNotifier(ref);
});

/// Provider for dashboard statistics
final recommenderDashboardStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final dashboardState = ref.watch(recommenderDashboardProvider);
  return dashboardState.statistics;
});

/// Provider for recent activity
final recommenderRecentActivityProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final dashboardState = ref.watch(recommenderDashboardProvider);
  return dashboardState.recentActivity;
});

/// Provider for checking if dashboard is loading
final recommenderDashboardLoadingProvider = Provider<bool>((ref) {
  final dashboardState = ref.watch(recommenderDashboardProvider);
  return dashboardState.isLoading;
});

/// Provider for dashboard error
final recommenderDashboardErrorProvider = Provider<String?>((ref) {
  final dashboardState = ref.watch(recommenderDashboardProvider);
  return dashboardState.error;
});
