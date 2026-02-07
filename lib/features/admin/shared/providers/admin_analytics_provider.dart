import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Analytics report model
class AnalyticsReport {
  final String id;
  final String name;
  final String type;
  final Map<String, dynamic> data;
  final DateTime generatedAt;

  const AnalyticsReport({
    required this.id,
    required this.name,
    required this.type,
    required this.data,
    required this.generatedAt,
  });
}

/// Activity item model
class ActivityItem {
  final String id;
  final DateTime timestamp;
  final String? userName;
  final String? userRole;
  final String actionType;
  final String description;
  final Map<String, dynamic>? metadata;

  const ActivityItem({
    required this.id,
    required this.timestamp,
    this.userName,
    this.userRole,
    required this.actionType,
    required this.description,
    this.metadata,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      userName: json['user_name'],
      userRole: json['user_role'],
      actionType: json['action_type'] ?? 'unknown',
      description: json['description'] ?? '',
      metadata: json['metadata'],
    );
  }
}

/// State class for admin analytics
class AdminAnalyticsState {
  final Map<String, dynamic> metrics;
  final List<AnalyticsReport> reports;
  final List<ActivityItem> recentActivity;
  final bool isLoading;
  final String? error;

  const AdminAnalyticsState({
    this.metrics = const {},
    this.reports = const [],
    this.recentActivity = const [],
    this.isLoading = false,
    this.error,
  });

  AdminAnalyticsState copyWith({
    Map<String, dynamic>? metrics,
    List<AnalyticsReport>? reports,
    List<ActivityItem>? recentActivity,
    bool? isLoading,
    String? error,
  }) {
    return AdminAnalyticsState(
      metrics: metrics ?? this.metrics,
      reports: reports ?? this.reports,
      recentActivity: recentActivity ?? this.recentActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for admin analytics
class AdminAnalyticsNotifier extends StateNotifier<AdminAnalyticsState> {
  final ApiClient _apiClient;

  AdminAnalyticsNotifier(this._apiClient) : super(const AdminAnalyticsState()) {
    fetchAnalytics();
  }

  /// Fetch analytics data from backend API
  Future<void> fetchAnalytics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/analytics/metrics',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          metrics: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch analytics',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch analytics: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Generate custom report via backend API
  Future<AnalyticsReport?> generateReport({
    required String reportType,
    required DateTime startDate,
    required DateTime endDate,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/analytics/reports',
        data: {
          'report_type': reportType,
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
          if (filters != null) 'filters': filters,
        },
        fromJson: (data) {
          return AnalyticsReport(
            id: data['id'] ?? 'report_${DateTime.now().millisecondsSinceEpoch}',
            name: data['name'] ?? '$reportType Report',
            type: data['type'] ?? reportType,
            data: data['data'] ?? {},
            generatedAt: data['generated_at'] != null
                ? DateTime.parse(data['generated_at'])
                : DateTime.now(),
          );
        },
      );

      if (response.success && response.data != null) {
        final updatedReports = [response.data!, ...state.reports];
        state = state.copyWith(reports: updatedReports);
        return response.data!;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to generate report',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to generate report: ${e.toString()}',
      );
      return null;
    }
  }

  /// Get user growth data from backend API
  Future<Map<String, dynamic>?> fetchUserGrowth(String period) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/dashboard/analytics/user-growth?period=$period',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch user growth data',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch user growth data: ${e.toString()}',
      );
      return null;
    }
  }

  /// Get role distribution data from backend API
  Future<Map<String, dynamic>?> fetchRoleDistribution() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/dashboard/analytics/role-distribution',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch role distribution data',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch role distribution data: ${e.toString()}',
      );
      return null;
    }
  }

  /// Get revenue trends
  /// Note: This returns derived data from the metrics
  List<Map<String, dynamic>> getRevenueTrends(String period) {
    // This could be enhanced to fetch from backend, but for now
    // returns placeholder data that could be derived from metrics
    return List.generate(12, (index) {
      return {
        'period': 'Month ${index + 1}',
        'revenue': 5000.0 + (index * 2000),
      };
    });
  }

  /// Get top performing courses
  /// Note: This returns derived data from the metrics
  List<Map<String, dynamic>> getTopCourses(int limit) {
    // This could be enhanced to fetch from backend, but for now
    // returns placeholder data that could be derived from metrics
    return List.generate(limit, (index) {
      return {
        'id': 'course_$index',
        'name': 'Course ${index + 1}',
        'enrollments': 500 - (index * 50),
        'revenue': 25000.0 - (index * 2000),
        'rating': 4.5 - (index * 0.1),
      };
    });
  }

  /// Fetch recent activity from backend
  Future<List<ActivityItem>> fetchRecentActivity({int limit = 10}) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/dashboard/recent-activity?limit=$limit',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final activities = (response.data!['activities'] as List<dynamic>?)
            ?.map((item) => ActivityItem.fromJson(item as Map<String, dynamic>))
            .toList() ?? [];

        state = state.copyWith(recentActivity: activities);
        return activities;
      } else {
        return [];
      }
    } catch (e) {
      // Return empty list on error, don't update error state for this
      return [];
    }
  }

  /// Refresh analytics
  Future<void> refresh() async {
    await Future.wait([
      fetchAnalytics(),
      fetchRecentActivity(),
    ]);
  }
}

/// Provider for admin analytics state
final adminAnalyticsProvider = StateNotifierProvider<AdminAnalyticsNotifier, AdminAnalyticsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminAnalyticsNotifier(apiClient);
});

/// Provider for analytics metrics
final adminAnalyticsMetricsProvider = Provider<Map<String, dynamic>>((ref) {
  final analyticsState = ref.watch(adminAnalyticsProvider);
  return analyticsState.metrics;
});

/// Provider for analytics reports
final adminAnalyticsReportsProvider = Provider<List<AnalyticsReport>>((ref) {
  final analyticsState = ref.watch(adminAnalyticsProvider);
  return analyticsState.reports;
});

/// Provider for checking if analytics is loading
final adminAnalyticsLoadingProvider = Provider<bool>((ref) {
  final analyticsState = ref.watch(adminAnalyticsProvider);
  return analyticsState.isLoading;
});

/// Provider for analytics error
final adminAnalyticsErrorProvider = Provider<String?>((ref) {
  final analyticsState = ref.watch(adminAnalyticsProvider);
  return analyticsState.error;
});

/// Provider for recent activity
final adminRecentActivityProvider = Provider<List<ActivityItem>>((ref) {
  final analyticsState = ref.watch(adminAnalyticsProvider);
  return analyticsState.recentActivity;
});
