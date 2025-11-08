import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  /// Load all dashboard data
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase aggregation queries

      await Future.delayed(const Duration(seconds: 1));

      // Get statistics from requests provider
      final requestStats = ref.read(recommenderRequestStatisticsProvider);

      final statistics = {
        // Request statistics
        'totalRequests': requestStats['total'],
        'pendingRequests': requestStats['pending'],
        'draftRequests': requestStats['draft'],
        'submittedRequests': requestStats['submitted'],
        'declinedRequests': requestStats['declined'],
        'urgentRequests': requestStats['urgent'],

        // Additional metrics
        'completionRate': _calculateCompletionRate(requestStats),
        'averageResponseTime': '2.3 days', // TODO: Calculate from actual data
        'requestsThisMonth': requestStats['submitted'] ?? 0,
      };

      // Mock recent activity
      final recentActivity = _generateMockActivity();

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
  String _calculateCompletionRate(Map<String, int> requestStats) {
    final total = requestStats['total'] ?? 0;
    final submitted = requestStats['submitted'] ?? 0;

    if (total == 0) return '0.0';

    return (submitted / total * 100).toStringAsFixed(1);
  }

  /// Generate mock recent activity
  /// TODO: Replace with actual data from Firebase
  List<Map<String, dynamic>> _generateMockActivity() {
    return [
      {
        'type': 'new_request',
        'title': 'New Recommendation Request',
        'description': 'Request from John Smith for MIT - Computer Science',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'icon': 'mail',
        'color': 'blue',
      },
      {
        'type': 'recommendation_submitted',
        'title': 'Recommendation Submitted',
        'description': 'Recommendation for Sarah Johnson submitted successfully',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'icon': 'send',
        'color': 'green',
      },
      {
        'type': 'draft_saved',
        'title': 'Draft Saved',
        'description': 'Draft saved for Michael Brown - Stanford',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'save',
        'color': 'purple',
      },
      {
        'type': 'deadline_reminder',
        'title': 'Deadline Approaching',
        'description': 'Emma Davis recommendation due in 3 days',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'alarm',
        'color': 'orange',
      },
      {
        'type': 'recommendation_accepted',
        'title': 'Recommendation Accepted',
        'description': 'Your recommendation for Alex Wilson was accepted by Harvard',
        'timestamp': DateTime.now().subtract(const Duration(days: 2)),
        'icon': 'verified',
        'color': 'teal',
      },
    ];
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
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
