import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recommendation_letter_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/providers/service_providers.dart';
import '../../authentication/providers/auth_provider.dart';

/// State class for managing student's recommendation requests
class StudentRecommendationRequestsState {
  final List<RecommendationRequest> requests;
  final List<Map<String, dynamic>> availableRecommenders;
  final bool isLoading;
  final String? error;

  const StudentRecommendationRequestsState({
    this.requests = const [],
    this.availableRecommenders = const [],
    this.isLoading = false,
    this.error,
  });

  StudentRecommendationRequestsState copyWith({
    List<RecommendationRequest>? requests,
    List<Map<String, dynamic>>? availableRecommenders,
    bool? isLoading,
    String? error,
  }) {
    return StudentRecommendationRequestsState(
      requests: requests ?? this.requests,
      availableRecommenders: availableRecommenders ?? this.availableRecommenders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing student's recommendation requests
class StudentRecommendationRequestsNotifier
    extends StateNotifier<StudentRecommendationRequestsState> {
  final ApiClient _apiClient;
  final String? _studentId;

  StudentRecommendationRequestsNotifier(this._apiClient, this._studentId)
      : super(const StudentRecommendationRequestsState()) {
    if (_studentId != null) {
      fetchRequests();
    }
  }

  /// Fetch all recommendation requests for the student
  /// GET /api/v1/students/{student_id}/recommendation-requests
  Future<void> fetchRequests() async {
    if (_studentId == null) {
      state = state.copyWith(error: 'No student ID available');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '/students/$_studentId/recommendation-requests',
        fromJson: (data) {
          if (data is Map && data['requests'] != null) {
            return (data['requests'] as List)
                .map((e) => RecommendationRequest.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (data is List) {
            return data
                .map((e) => RecommendationRequest.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return <RecommendationRequest>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          requests: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch requests',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch requests: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Search for recommenders (teachers, counselors, professors)
  /// GET /api/v1/recommenders/search?q={query}
  Future<void> searchRecommenders(String query) async {
    if (query.length < 2) {
      state = state.copyWith(availableRecommenders: []);
      return;
    }

    try {
      final response = await _apiClient.get(
        '/recommenders/search?q=$query',
        fromJson: (data) {
          if (data is Map && data['recommenders'] != null) {
            return (data['recommenders'] as List).cast<Map<String, dynamic>>();
          }
          if (data is List) {
            return data.cast<Map<String, dynamic>>();
          }
          return <Map<String, dynamic>>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(availableRecommenders: response.data!);
      }
    } catch (e) {
      // Silently fail search - don't show error for search
    }
  }

  /// Create a new recommendation request
  /// POST /api/v1/recommendation-requests
  Future<bool> createRequest({
    required String recommenderId,
    required String requestType,
    required String purpose,
    required DateTime deadline,
    String? institutionName,
    String priority = 'normal',
    String? studentMessage,
    String? achievements,
    String? goals,
    String? relationshipContext,
  }) async {
    if (_studentId == null) return false;

    try {
      final response = await _apiClient.post(
        '/recommendation-requests',
        data: CreateRecommendationRequestDto(
          studentId: _studentId!,
          recommenderId: recommenderId,
          requestType: requestType,
          purpose: purpose,
          institutionName: institutionName,
          deadline: deadline.toIso8601String().split('T')[0],
          priority: priority,
          studentMessage: studentMessage,
          achievements: achievements,
          goals: goals,
          relationshipContext: relationshipContext,
        ).toJson(),
        fromJson: (data) => RecommendationRequest.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Add new request to local state
        state = state.copyWith(
          requests: [...state.requests, response.data!],
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Create recommendation requests by email (for each selected institution)
  /// POST /api/v1/recommendation-requests/by-email
  /// This sends an invitation to the recommender if they don't have an account
  Future<bool> createRequestByEmail({
    required String recommenderEmail,
    required String recommenderName,
    required String requestType,
    required String purpose,
    required DateTime deadline,
    required List<String> institutionNames,
    String priority = 'normal',
    String? studentMessage,
    String? achievements,
    String? goals,
    String? relationshipContext,
  }) async {
    if (_studentId == null) return false;

    try {
      // Create a request for each selected institution
      final response = await _apiClient.post(
        '/recommendation-requests/by-email',
        data: {
          'student_id': _studentId,
          'recommender_email': recommenderEmail,
          'recommender_name': recommenderName,
          'request_type': requestType,
          'purpose': purpose,
          'institution_names': institutionNames,
          'deadline': deadline.toIso8601String().split('T')[0],
          'priority': priority,
          'student_message': studentMessage,
          'achievements': achievements,
          'goals': goals,
          'relationship_context': relationshipContext,
        },
        fromJson: (data) {
          // Response may contain a list of created requests
          if (data is Map && data['requests'] != null) {
            return (data['requests'] as List)
                .map((e) => RecommendationRequest.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          if (data is List) {
            return data
                .map((e) => RecommendationRequest.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          // Single request
          return [RecommendationRequest.fromJson(data as Map<String, dynamic>)];
        },
      );

      if (response.success && response.data != null) {
        // Add new requests to local state
        state = state.copyWith(
          requests: [...state.requests, ...response.data!],
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Cancel a recommendation request
  /// DELETE /api/v1/recommendation-requests/{request_id}?student_id={student_id}
  Future<bool> cancelRequest(String requestId) async {
    if (_studentId == null) return false;

    try {
      final response = await _apiClient.delete(
        '/recommendation-requests/$requestId?student_id=$_studentId',
        fromJson: (data) => data,
      );

      if (response.success) {
        // Remove from local state
        state = state.copyWith(
          requests: state.requests.where((r) => r.id != requestId).toList(),
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to cancel request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to cancel request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Send reminder to recommender
  /// POST /api/v1/recommendation-requests/{request_id}/remind?student_id={student_id}
  Future<bool> sendReminder(String requestId) async {
    if (_studentId == null) return false;

    try {
      final response = await _apiClient.post(
        '/recommendation-requests/$requestId/remind?student_id=$_studentId',
        fromJson: (data) => data,
      );

      if (response.success) {
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to send reminder',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send reminder: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get pending requests
  List<RecommendationRequest> getPendingRequests() {
    return state.requests.where((r) => r.isPending).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get accepted/in-progress requests
  List<RecommendationRequest> getInProgressRequests() {
    return state.requests
        .where((r) => r.isAccepted || r.isInProgress)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get completed requests
  List<RecommendationRequest> getCompletedRequests() {
    return state.requests.where((r) => r.isCompleted).toList()
      ..sort((a, b) {
        final aDate = a.completedAt ?? a.updatedAt;
        final bDate = b.completedAt ?? b.updatedAt;
        return bDate.compareTo(aDate);
      });
  }

  /// Get declined requests
  List<RecommendationRequest> getDeclinedRequests() {
    return state.requests.where((r) => r.isDeclined).toList();
  }

  /// Get request by ID
  RecommendationRequest? getRequestById(String id) {
    try {
      return state.requests.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get statistics
  Map<String, int> getStatistics() {
    return {
      'total': state.requests.length,
      'pending': state.requests.where((r) => r.isPending).length,
      'inProgress': state.requests.where((r) => r.isAccepted || r.isInProgress).length,
      'completed': state.requests.where((r) => r.isCompleted).length,
      'declined': state.requests.where((r) => r.isDeclined).length,
    };
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh
  Future<void> refresh() async {
    await fetchRequests();
  }
}

/// Provider for student recommendation requests
final studentRecommendationRequestsProvider = StateNotifierProvider<
    StudentRecommendationRequestsNotifier, StudentRecommendationRequestsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final authState = ref.watch(authProvider);
  final studentId = authState.user?.id;
  return StudentRecommendationRequestsNotifier(apiClient, studentId);
});

/// Provider for pending requests
final studentPendingRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(studentRecommendationRequestsProvider.notifier);
  return notifier.getPendingRequests();
});

/// Provider for in-progress requests
final studentInProgressRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(studentRecommendationRequestsProvider.notifier);
  return notifier.getInProgressRequests();
});

/// Provider for completed requests
final studentCompletedRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(studentRecommendationRequestsProvider.notifier);
  return notifier.getCompletedRequests();
});

/// Provider for recommendation request statistics
final studentRecommendationStatisticsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(studentRecommendationRequestsProvider.notifier);
  return notifier.getStatistics();
});

/// Provider for loading state
final studentRecommendationLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(studentRecommendationRequestsProvider);
  return state.isLoading;
});

/// Provider for error state
final studentRecommendationErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(studentRecommendationRequestsProvider);
  return state.error;
});

/// Provider for available recommenders (search results)
final availableRecommendersProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final state = ref.watch(studentRecommendationRequestsProvider);
  return state.availableRecommenders;
});
