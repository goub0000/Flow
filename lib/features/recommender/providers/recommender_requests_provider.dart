import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/counseling_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing recommendation requests
class RecommenderRequestsState {
  final List<Recommendation> requests;
  final bool isLoading;
  final String? error;

  const RecommenderRequestsState({
    this.requests = const [],
    this.isLoading = false,
    this.error,
  });

  RecommenderRequestsState copyWith({
    List<Recommendation>? requests,
    bool? isLoading,
    String? error,
  }) {
    return RecommenderRequestsState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing recommendation requests
class RecommenderRequestsNotifier extends StateNotifier<RecommenderRequestsState> {
  final ApiClient _apiClient;

  RecommenderRequestsNotifier(this._apiClient) : super(const RecommenderRequestsState()) {
    fetchRequests();
  }

  /// Fetch all recommendation requests from backend API
  Future<void> fetchRequests() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.recommender}/recommendations',
        fromJson: (data) {
          if (data is List) {
            return data.map((recJson) => Recommendation.fromJson(recJson)).toList();
          }
          return <Recommendation>[];
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

  /// Update recommendation via backend API
  Future<bool> updateRecommendation(String recommendationId, {
    String? content,
    String? status,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.recommender}/recommendations/$recommendationId',
        data: {
          if (content != null) 'content': content,
          if (status != null) 'status': status,
        },
        fromJson: (data) => Recommendation.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedRequests = state.requests.map((r) {
          return r.id == recommendationId ? response.data! : r;
        }).toList();

        state = state.copyWith(requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update recommendation',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update recommendation: ${e.toString()}',
      );
      return false;
    }
  }

  /// Submit recommendation via backend API
  Future<bool> submitRecommendation(String requestId, String content) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.recommender}/recommendations/$requestId/submit',
        data: {
          'content': content,
        },
        fromJson: (data) => Recommendation.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedRequests = state.requests.map((r) {
          return r.id == requestId ? response.data! : r;
        }).toList();

        state = state.copyWith(requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to submit recommendation',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to submit recommendation: ${e.toString()}',
      );
      return false;
    }
  }

  /// Save draft recommendation
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> saveDraft(String requestId, String content) async {
    try {
      // TODO: Save to Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedRequests = state.requests.map((r) {
        if (r.id == requestId) {
          return Recommendation(
            id: r.id,
            studentId: r.studentId,
            studentName: r.studentName,
            studentEmail: r.studentEmail,
            counselorId: r.counselorId,
            institutionName: r.institutionName,
            programName: r.programName,
            deadline: r.deadline,
            status: 'draft',
            content: content,
            requestedDate: r.requestedDate,
            submittedDate: r.submittedDate,
          );
        }
        return r;
      }).toList();

      state = state.copyWith(requests: updatedRequests);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to save draft: ${e.toString()}',
      );
      return false;
    }
  }

  /// Decline recommendation request
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> declineRequest(String requestId, String reason) async {
    try {
      // TODO: Update in Firebase and notify student

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedRequests = state.requests.map((r) {
        if (r.id == requestId) {
          return Recommendation(
            id: r.id,
            studentId: r.studentId,
            studentName: r.studentName,
            studentEmail: r.studentEmail,
            counselorId: r.counselorId,
            institutionName: r.institutionName,
            programName: r.programName,
            deadline: r.deadline,
            status: 'declined',
            content: 'Declined: $reason',
            requestedDate: r.requestedDate,
            submittedDate: null,
          );
        }
        return r;
      }).toList();

      state = state.copyWith(requests: updatedRequests);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to decline request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Filter requests by status
  List<Recommendation> filterByStatus(String status) {
    if (status == 'all') return state.requests;

    return state.requests.where((request) => request.status == status).toList();
  }

  /// Get pending requests
  List<Recommendation> getPendingRequests() {
    return state.requests.where((r) => r.status == 'pending').toList()
      ..sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
  }

  /// Get draft requests
  List<Recommendation> getDraftRequests() {
    return state.requests.where((r) => r.status == 'draft').toList()
      ..sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
  }

  /// Get submitted requests (sorted by submission date)
  List<Recommendation> getSubmittedRequests() {
    return state.requests.where((r) => r.status == 'submitted').toList()
      ..sort((a, b) {
        // Handle null submission dates
        if (a.submittedDate == null && b.submittedDate == null) return 0;
        if (a.submittedDate == null) return 1;
        if (b.submittedDate == null) return -1;
        return b.submittedDate!.compareTo(a.submittedDate!);
      });
  }

  /// Get urgent requests (deadline within 7 days)
  List<Recommendation> getUrgentRequests() {
    final sevenDaysFromNow = DateTime.now().add(const Duration(days: 7));
    return state.requests.where((r) {
      return r.status == 'pending' && r.deadline != null && r.deadline!.isBefore(sevenDaysFromNow);
    }).toList()
      ..sort((a, b) {
        if (a.deadline == null && b.deadline == null) return 0;
        if (a.deadline == null) return 1;
        if (b.deadline == null) return -1;
        return a.deadline!.compareTo(b.deadline!);
      });
  }

  /// Get request by ID
  Recommendation? getRequestById(String id) {
    try {
      return state.requests.firstWhere((request) => request.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search requests by student name
  List<Recommendation> searchRequests(String query) {
    if (query.isEmpty) return state.requests;

    final lowerQuery = query.toLowerCase();
    return state.requests.where((request) {
      return request.studentName.toLowerCase().contains(lowerQuery) ||
          request.institutionName.toLowerCase().contains(lowerQuery) ||
          request.programName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get request statistics
  Map<String, int> getRequestStatistics() {
    return {
      'total': state.requests.length,
      'pending': state.requests.where((r) => r.status == 'pending').length,
      'draft': state.requests.where((r) => r.status == 'draft').length,
      'submitted': state.requests.where((r) => r.status == 'submitted').length,
      'declined': state.requests.where((r) => r.status == 'declined').length,
      'urgent': getUrgentRequests().length,
    };
  }
}

/// Provider for recommender requests state
final recommenderRequestsProvider = StateNotifierProvider<RecommenderRequestsNotifier, RecommenderRequestsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RecommenderRequestsNotifier(apiClient);
});

/// Provider for requests list
final recommenderRequestsListProvider = Provider<List<Recommendation>>((ref) {
  final requestsState = ref.watch(recommenderRequestsProvider);
  return requestsState.requests;
});

/// Provider for pending requests
final pendingRecommendationRequestsProvider = Provider<List<Recommendation>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getPendingRequests();
});

/// Provider for draft requests
final draftRecommendationRequestsProvider = Provider<List<Recommendation>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getDraftRequests();
});

/// Provider for submitted requests
final submittedRecommendationRequestsProvider = Provider<List<Recommendation>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getSubmittedRequests();
});

/// Provider for urgent requests
final urgentRecommendationRequestsProvider = Provider<List<Recommendation>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getUrgentRequests();
});

/// Provider for request statistics
final recommenderRequestStatisticsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getRequestStatistics();
});

/// Provider for checking if requests are loading
final recommenderRequestsLoadingProvider = Provider<bool>((ref) {
  final requestsState = ref.watch(recommenderRequestsProvider);
  return requestsState.isLoading;
});

/// Provider for requests error
final recommenderRequestsErrorProvider = Provider<String?>((ref) {
  final requestsState = ref.watch(recommenderRequestsProvider);
  return requestsState.error;
});

// Aliases for compatibility with screens
final pendingRequestsProvider = pendingRecommendationRequestsProvider;
final submittedRequestsProvider = submittedRecommendationRequestsProvider;
