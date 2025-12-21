import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recommendation_letter_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
import '../../authentication/providers/auth_provider.dart';

/// State class for managing recommendation requests
class RecommenderRequestsState {
  final List<RecommendationRequest> requests;
  final Map<String, LetterOfRecommendation> letters; // requestId -> letter
  final RecommenderDashboardSummary? dashboard;
  final bool isLoading;
  final String? error;

  const RecommenderRequestsState({
    this.requests = const [],
    this.letters = const {},
    this.dashboard,
    this.isLoading = false,
    this.error,
  });

  RecommenderRequestsState copyWith({
    List<RecommendationRequest>? requests,
    Map<String, LetterOfRecommendation>? letters,
    RecommenderDashboardSummary? dashboard,
    bool? isLoading,
    String? error,
  }) {
    return RecommenderRequestsState(
      requests: requests ?? this.requests,
      letters: letters ?? this.letters,
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing recommendation requests
class RecommenderRequestsNotifier extends StateNotifier<RecommenderRequestsState> {
  final ApiClient _apiClient;
  final String? _recommenderId;

  RecommenderRequestsNotifier(this._apiClient, this._recommenderId)
      : super(const RecommenderRequestsState()) {
    if (_recommenderId != null) {
      fetchDashboard();
    }
  }

  /// Fetch recommender dashboard from backend API
  /// GET /api/v1/recommenders/{recommender_id}/dashboard
  Future<void> fetchDashboard() async {
    if (_recommenderId == null) {
      state = state.copyWith(error: 'No recommender ID available');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '/recommenders/$_recommenderId/dashboard',
        fromJson: (data) => RecommenderDashboardSummary.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Extract requests from dashboard's upcoming deadlines
        final dashboard = response.data!;
        state = state.copyWith(
          dashboard: dashboard,
          requests: dashboard.upcomingDeadlines,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch dashboard',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch dashboard: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch a specific recommendation request
  /// GET /api/v1/recommendation-requests/{request_id}?user_id={recommender_id}
  Future<RecommendationRequest?> fetchRequest(String requestId) async {
    if (_recommenderId == null) return null;

    try {
      final response = await _apiClient.get(
        '/recommendation-requests/$requestId?user_id=$_recommenderId',
        fromJson: (data) => RecommendationRequest.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Update in local state
        final updatedRequests = state.requests.map((r) {
          return r.id == requestId ? response.data! : r;
        }).toList();

        // If not in list, add it
        if (!updatedRequests.any((r) => r.id == requestId)) {
          updatedRequests.add(response.data!);
        }

        state = state.copyWith(requests: updatedRequests);
        return response.data;
      }
      return null;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch request: ${e.toString()}',
      );
      return null;
    }
  }

  /// Accept a recommendation request
  /// POST /api/v1/recommendation-requests/{request_id}/accept?recommender_id={recommender_id}
  Future<bool> acceptRequest(String requestId) async {
    if (_recommenderId == null) return false;

    try {
      final response = await _apiClient.post(
        '/recommendation-requests/$requestId/accept?recommender_id=$_recommenderId',
        data: {'accepted': true},
        fromJson: (data) => RecommendationRequest.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        final updatedRequests = state.requests.map((r) {
          return r.id == requestId ? response.data! : r;
        }).toList();

        state = state.copyWith(requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to accept request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to accept request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Decline a recommendation request
  /// POST /api/v1/recommendation-requests/{request_id}/decline?recommender_id={recommender_id}
  Future<bool> declineRequest(String requestId, String reason) async {
    if (_recommenderId == null) return false;

    try {
      final response = await _apiClient.post(
        '/recommendation-requests/$requestId/decline?recommender_id=$_recommenderId',
        data: {'decline_reason': reason},
        fromJson: (data) => RecommendationRequest.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        final updatedRequests = state.requests.map((r) {
          return r.id == requestId ? response.data! : r;
        }).toList();

        state = state.copyWith(requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to decline request',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to decline request: ${e.toString()}',
      );
      return false;
    }
  }

  /// Create a new recommendation letter (draft)
  /// POST /api/v1/recommendation-letters?recommender_id={recommender_id}
  Future<LetterOfRecommendation?> createLetter({
    required String requestId,
    required String content,
    String letterType = 'formal',
    bool isVisibleToStudent = false,
    String? templateId,
  }) async {
    if (_recommenderId == null) return null;

    try {
      final response = await _apiClient.post(
        '/recommendation-letters?recommender_id=$_recommenderId',
        data: CreateLetterDto(
          requestId: requestId,
          content: content,
          letterType: letterType,
          isVisibleToStudent: isVisibleToStudent,
          templateId: templateId,
        ).toJson(),
        fromJson: (data) => LetterOfRecommendation.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Store letter in local state
        final newLetters = Map<String, LetterOfRecommendation>.from(state.letters);
        newLetters[requestId] = response.data!;

        // Update request status
        final updatedRequests = state.requests.map((r) {
          if (r.id == requestId) {
            return RecommendationRequest(
              id: r.id,
              studentId: r.studentId,
              recommenderId: r.recommenderId,
              requestType: r.requestType,
              purpose: r.purpose,
              institutionName: r.institutionName,
              deadline: r.deadline,
              priority: r.priority,
              status: RecommendationRequestStatus.inProgress,
              studentMessage: r.studentMessage,
              achievements: r.achievements,
              goals: r.goals,
              relationshipContext: r.relationshipContext,
              acceptedAt: r.acceptedAt,
              declinedAt: r.declinedAt,
              declineReason: r.declineReason,
              requestedAt: r.requestedAt,
              completedAt: r.completedAt,
              createdAt: r.createdAt,
              updatedAt: DateTime.now(),
              studentName: r.studentName,
              studentEmail: r.studentEmail,
              recommenderName: r.recommenderName,
              recommenderEmail: r.recommenderEmail,
              recommenderTitle: r.recommenderTitle,
              hasLetter: true,
              letterStatus: LetterStatus.draft,
            );
          }
          return r;
        }).toList();

        state = state.copyWith(letters: newLetters, requests: updatedRequests);
        return response.data;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create letter',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create letter: ${e.toString()}',
      );
      return null;
    }
  }

  /// Get a recommendation letter
  /// GET /api/v1/recommendation-letters/{letter_id}?user_id={recommender_id}
  Future<LetterOfRecommendation?> getLetter(String letterId) async {
    if (_recommenderId == null) return null;

    try {
      final response = await _apiClient.get(
        '/recommendation-letters/$letterId?user_id=$_recommenderId',
        fromJson: (data) => LetterOfRecommendation.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Store letter in local state
        final newLetters = Map<String, LetterOfRecommendation>.from(state.letters);
        newLetters[response.data!.requestId] = response.data!;
        state = state.copyWith(letters: newLetters);
        return response.data;
      }
      return null;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch letter: ${e.toString()}',
      );
      return null;
    }
  }

  /// Update a recommendation letter (save draft)
  /// PUT /api/v1/recommendation-letters/{letter_id}?recommender_id={recommender_id}
  Future<bool> updateLetter(String letterId, {
    String? content,
    String? letterType,
    bool? isVisibleToStudent,
  }) async {
    if (_recommenderId == null) return false;

    try {
      final response = await _apiClient.put(
        '/recommendation-letters/$letterId?recommender_id=$_recommenderId',
        data: UpdateLetterDto(
          content: content,
          letterType: letterType,
          isVisibleToStudent: isVisibleToStudent,
        ).toJson(),
        fromJson: (data) => LetterOfRecommendation.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Update letter in local state
        final newLetters = Map<String, LetterOfRecommendation>.from(state.letters);
        newLetters[response.data!.requestId] = response.data!;
        state = state.copyWith(letters: newLetters);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update letter',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update letter: ${e.toString()}',
      );
      return false;
    }
  }

  /// Submit a recommendation letter
  /// POST /api/v1/recommendation-letters/{letter_id}/submit?recommender_id={recommender_id}
  Future<bool> submitLetter(String letterId) async {
    if (_recommenderId == null) return false;

    try {
      final response = await _apiClient.post(
        '/recommendation-letters/$letterId/submit?recommender_id=$_recommenderId',
        fromJson: (data) => LetterOfRecommendation.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Update letter in local state
        final newLetters = Map<String, LetterOfRecommendation>.from(state.letters);
        newLetters[response.data!.requestId] = response.data!;

        // Update request status to completed
        final updatedRequests = state.requests.map((r) {
          if (r.id == response.data!.requestId) {
            return RecommendationRequest(
              id: r.id,
              studentId: r.studentId,
              recommenderId: r.recommenderId,
              requestType: r.requestType,
              purpose: r.purpose,
              institutionName: r.institutionName,
              deadline: r.deadline,
              priority: r.priority,
              status: RecommendationRequestStatus.completed,
              studentMessage: r.studentMessage,
              achievements: r.achievements,
              goals: r.goals,
              relationshipContext: r.relationshipContext,
              acceptedAt: r.acceptedAt,
              declinedAt: r.declinedAt,
              declineReason: r.declineReason,
              requestedAt: r.requestedAt,
              completedAt: DateTime.now(),
              createdAt: r.createdAt,
              updatedAt: DateTime.now(),
              studentName: r.studentName,
              studentEmail: r.studentEmail,
              recommenderName: r.recommenderName,
              recommenderEmail: r.recommenderEmail,
              recommenderTitle: r.recommenderTitle,
              hasLetter: true,
              letterStatus: LetterStatus.submitted,
            );
          }
          return r;
        }).toList();

        state = state.copyWith(letters: newLetters, requests: updatedRequests);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to submit letter',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to submit letter: ${e.toString()}',
      );
      return false;
    }
  }

  /// Generate share link for a letter
  /// POST /api/v1/recommendation-letters/{letter_id}/share?recommender_id={recommender_id}
  Future<String?> generateShareLink(String letterId) async {
    if (_recommenderId == null) return null;

    try {
      final response = await _apiClient.post(
        '/recommendation-letters/$letterId/share?recommender_id=$_recommenderId',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return response.data!['share_token'] as String?;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to generate share link',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to generate share link: ${e.toString()}',
      );
      return null;
    }
  }

  /// Filter requests by status
  List<RecommendationRequest> filterByStatus(RecommendationRequestStatus status) {
    return state.requests.where((r) => r.status == status).toList();
  }

  /// Get pending requests (sorted by deadline)
  List<RecommendationRequest> getPendingRequests() {
    return state.requests.where((r) => r.isPending).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get in-progress requests (accepted, working on letter)
  List<RecommendationRequest> getInProgressRequests() {
    return state.requests
        .where((r) => r.isAccepted || r.isInProgress)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get completed requests (submitted letters)
  List<RecommendationRequest> getCompletedRequests() {
    return state.requests.where((r) => r.isCompleted).toList()
      ..sort((a, b) {
        final aDate = a.completedAt ?? a.updatedAt;
        final bDate = b.completedAt ?? b.updatedAt;
        return bDate.compareTo(aDate);
      });
  }

  /// Get urgent requests (deadline within 7 days)
  List<RecommendationRequest> getUrgentRequests() {
    final sevenDaysFromNow = DateTime.now().add(const Duration(days: 7));
    return state.requests.where((r) {
      return !r.isCompleted && !r.isDeclined && r.deadline.isBefore(sevenDaysFromNow);
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get overdue requests
  List<RecommendationRequest> getOverdueRequests() {
    return state.requests.where((r) => r.isOverdue).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  /// Get request by ID
  RecommendationRequest? getRequestById(String id) {
    try {
      return state.requests.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get letter for a request
  LetterOfRecommendation? getLetterForRequest(String requestId) {
    return state.letters[requestId];
  }

  /// Search requests by student name or institution
  List<RecommendationRequest> searchRequests(String query) {
    if (query.isEmpty) return state.requests;

    final lowerQuery = query.toLowerCase();
    return state.requests.where((r) {
      return (r.studentName?.toLowerCase().contains(lowerQuery) ?? false) ||
          (r.institutionName?.toLowerCase().contains(lowerQuery) ?? false) ||
          r.purpose.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get request statistics
  Map<String, int> getRequestStatistics() {
    return {
      'total': state.requests.length,
      'pending': state.requests.where((r) => r.isPending).length,
      'inProgress': state.requests.where((r) => r.isAccepted || r.isInProgress).length,
      'completed': state.requests.where((r) => r.isCompleted).length,
      'declined': state.requests.where((r) => r.isDeclined).length,
      'overdue': state.requests.where((r) => r.isOverdue).length,
      'urgent': getUrgentRequests().length,
    };
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh all data
  Future<void> refresh() async {
    await fetchDashboard();
  }
}

/// Provider for recommender requests state
final recommenderRequestsProvider = StateNotifierProvider<RecommenderRequestsNotifier, RecommenderRequestsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final authState = ref.watch(authProvider);
  final recommenderId = authState.user?.id;
  return RecommenderRequestsNotifier(apiClient, recommenderId);
});

/// Provider for dashboard summary
final recommenderDashboardSummaryProvider = Provider<RecommenderDashboardSummary?>((ref) {
  final requestsState = ref.watch(recommenderRequestsProvider);
  return requestsState.dashboard;
});

/// Provider for all requests list
final recommenderRequestsListProvider = Provider<List<RecommendationRequest>>((ref) {
  final requestsState = ref.watch(recommenderRequestsProvider);
  return requestsState.requests;
});

/// Provider for pending requests
final pendingRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getPendingRequests();
});

/// Provider for in-progress requests
final inProgressRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getInProgressRequests();
});

/// Provider for completed requests
final completedRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getCompletedRequests();
});

/// Provider for urgent requests
final urgentRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getUrgentRequests();
});

/// Provider for overdue requests
final overdueRecommendationRequestsProvider = Provider<List<RecommendationRequest>>((ref) {
  final notifier = ref.watch(recommenderRequestsProvider.notifier);
  return notifier.getOverdueRequests();
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

// Legacy aliases for compatibility
final pendingRequestsProvider = pendingRecommendationRequestsProvider;
final submittedRequestsProvider = completedRecommendationRequestsProvider;
