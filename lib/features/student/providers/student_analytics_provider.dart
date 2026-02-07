import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for student analytics
class StudentAnalyticsState {
  final Map<String, dynamic>? applicationSuccessData;
  final Map<String, dynamic>? gpaTrendData;
  final bool isLoading;
  final String? error;

  const StudentAnalyticsState({
    this.applicationSuccessData,
    this.gpaTrendData,
    this.isLoading = false,
    this.error,
  });

  StudentAnalyticsState copyWith({
    Map<String, dynamic>? applicationSuccessData,
    Map<String, dynamic>? gpaTrendData,
    bool? isLoading,
    String? error,
  }) {
    return StudentAnalyticsState(
      applicationSuccessData: applicationSuccessData ?? this.applicationSuccessData,
      gpaTrendData: gpaTrendData ?? this.gpaTrendData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for student analytics
class StudentAnalyticsNotifier extends StateNotifier<StudentAnalyticsState> {
  final ApiClient _apiClient;
  final String _userId;

  StudentAnalyticsNotifier(this._apiClient, this._userId)
      : super(const StudentAnalyticsState());

  /// Fetch application success rate analytics
  Future<void> fetchApplicationSuccess() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.students}/$_userId/analytics/application-success',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          applicationSuccessData: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch application success data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch application success data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch GPA trend analytics
  Future<void> fetchGpaTrend() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.students}/$_userId/analytics/gpa-trend',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          gpaTrendData: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch GPA trend data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch GPA trend data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch all analytics
  Future<void> fetchAll() async {
    await Future.wait([
      fetchApplicationSuccess(),
      fetchGpaTrend(),
    ]);
  }

  /// Refresh all analytics
  Future<void> refresh() async {
    await fetchAll();
  }
}

/// Provider for student analytics state
final studentAnalyticsProvider =
    StateNotifierProvider.family<StudentAnalyticsNotifier, StudentAnalyticsState, String>(
  (ref, userId) {
    final apiClient = ref.watch(apiClientProvider);
    return StudentAnalyticsNotifier(apiClient, userId);
  },
);

/// Provider for application success data
final studentApplicationSuccessProvider = Provider.family<Map<String, dynamic>?, String>((ref, userId) {
  final analyticsState = ref.watch(studentAnalyticsProvider(userId));
  return analyticsState.applicationSuccessData;
});

/// Provider for GPA trend data
final studentGpaTrendProvider = Provider.family<Map<String, dynamic>?, String>((ref, userId) {
  final analyticsState = ref.watch(studentAnalyticsProvider(userId));
  return analyticsState.gpaTrendData;
});

/// Provider for analytics loading state
final studentAnalyticsLoadingProvider = Provider.family<bool, String>((ref, userId) {
  final analyticsState = ref.watch(studentAnalyticsProvider(userId));
  return analyticsState.isLoading;
});

/// Provider for analytics error
final studentAnalyticsErrorProvider = Provider.family<String?, String>((ref, userId) {
  final analyticsState = ref.watch(studentAnalyticsProvider(userId));
  return analyticsState.error;
});
