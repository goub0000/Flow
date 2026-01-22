import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/providers/service_providers.dart';
import '../models/approval_models.dart';
import '../services/approvals_api_service.dart';

/// State class for managing approval requests list
class ApprovalsListState {
  final List<ApprovalRequest> requests;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final ApprovalRequestFilter? currentFilter;

  const ApprovalsListState({
    this.requests = const [],
    this.total = 0,
    this.page = 1,
    this.pageSize = 20,
    this.hasMore = false,
    this.isLoading = false,
    this.error,
    this.currentFilter,
  });

  ApprovalsListState copyWith({
    List<ApprovalRequest>? requests,
    int? total,
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
    String? error,
    ApprovalRequestFilter? currentFilter,
  }) {
    return ApprovalsListState(
      requests: requests ?? this.requests,
      total: total ?? this.total,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentFilter: currentFilter ?? this.currentFilter,
    );
  }
}

/// State class for single approval request detail
class ApprovalDetailState {
  final ApprovalRequest? request;
  final List<ApprovalComment> comments;
  final bool isLoading;
  final String? error;
  final bool isPerformingAction;

  const ApprovalDetailState({
    this.request,
    this.comments = const [],
    this.isLoading = false,
    this.error,
    this.isPerformingAction = false,
  });

  ApprovalDetailState copyWith({
    ApprovalRequest? request,
    List<ApprovalComment>? comments,
    bool? isLoading,
    String? error,
    bool? isPerformingAction,
  }) {
    return ApprovalDetailState(
      request: request ?? this.request,
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isPerformingAction: isPerformingAction ?? this.isPerformingAction,
    );
  }
}

/// State class for approval statistics
class ApprovalStatsState {
  final ApprovalStatistics? statistics;
  final bool isLoading;
  final String? error;

  const ApprovalStatsState({
    this.statistics,
    this.isLoading = false,
    this.error,
  });

  ApprovalStatsState copyWith({
    ApprovalStatistics? statistics,
    bool? isLoading,
    String? error,
  }) {
    return ApprovalStatsState(
      statistics: statistics ?? this.statistics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// State class for pending actions
class PendingActionsState {
  final MyPendingActionsResponse? pendingActions;
  final bool isLoading;
  final String? error;

  const PendingActionsState({
    this.pendingActions,
    this.isLoading = false,
    this.error,
  });

  PendingActionsState copyWith({
    MyPendingActionsResponse? pendingActions,
    bool? isLoading,
    String? error,
  }) {
    return PendingActionsState(
      pendingActions: pendingActions ?? this.pendingActions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing approvals list
class ApprovalsListNotifier extends StateNotifier<ApprovalsListState> {
  final ApiClient _apiClient;
  late final ApprovalsApiService _service;

  ApprovalsListNotifier(this._apiClient) : super(const ApprovalsListState()) {
    _initService();
  }

  void _initService() {
    // Use token getter for dynamic token retrieval
    _service = ApprovalsApiService(tokenGetter: () => _apiClient.token);
  }

  /// Fetch approval requests with optional filters
  Future<void> fetchRequests({
    int page = 1,
    ApprovalRequestFilter? filter,
    bool append = false,
  }) async {
    if (!append) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await _service.listRequests(
        page: page,
        pageSize: state.pageSize,
        status: filter?.status,
        requestType: filter?.requestType,
        actionType: filter?.actionType,
        priority: filter?.priority,
        initiatedBy: filter?.initiatedBy,
        regionalScope: filter?.regionalScope,
        currentApprovalLevel: filter?.currentApprovalLevel,
        fromDate: filter?.fromDate,
        toDate: filter?.toDate,
        search: filter?.search,
      );

      final newRequests = append
          ? [...state.requests, ...response.requests]
          : response.requests;

      state = state.copyWith(
        requests: newRequests,
        total: response.total,
        page: page,
        hasMore: response.hasMore,
        isLoading: false,
        currentFilter: filter,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Load more requests (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchRequests(
      page: state.page + 1,
      filter: state.currentFilter,
      append: true,
    );
  }

  /// Refresh requests
  Future<void> refresh() async {
    await fetchRequests(page: 1, filter: state.currentFilter);
  }

  /// Apply filter
  Future<void> applyFilter(ApprovalRequestFilter filter) async {
    await fetchRequests(page: 1, filter: filter);
  }

  /// Clear filter
  Future<void> clearFilter() async {
    await fetchRequests(page: 1);
  }

  /// Create a new approval request
  Future<ApprovalRequest?> createRequest(ApprovalRequestCreate request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newRequest = await _service.createRequestFromStrings(request);
      // Refresh the list to include the new request
      await fetchRequests(page: 1, filter: state.currentFilter);
      return newRequest;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Update a request in the list (after action)
  void updateRequestInList(ApprovalRequest updatedRequest) {
    final index = state.requests.indexWhere((r) => r.id == updatedRequest.id);
    if (index != -1) {
      final newList = List<ApprovalRequest>.from(state.requests);
      newList[index] = updatedRequest;
      state = state.copyWith(requests: newList);
    }
  }
}

/// StateNotifier for managing single approval detail
class ApprovalDetailNotifier extends StateNotifier<ApprovalDetailState> {
  final ApiClient _apiClient;
  late final ApprovalsApiService _service;

  ApprovalDetailNotifier(this._apiClient) : super(const ApprovalDetailState()) {
    _initService();
  }

  void _initService() {
    // Use token getter for dynamic token retrieval
    _service = ApprovalsApiService(tokenGetter: () => _apiClient.token);
  }

  /// Fetch single approval request details
  Future<void> fetchRequest(String requestId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = await _service.getRequest(requestId);
      // Also fetch comments
      final comments = await _service.getComments(requestId);
      state = state.copyWith(
        request: request,
        comments: comments,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Alias for fetchRequest
  Future<void> loadRequest(String requestId) => fetchRequest(requestId);

  /// Approve request by ID
  Future<ApprovalRequest?> approveRequest(String requestId, {String? notes, bool mfaVerified = false}) async {
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.approveRequest(
        requestId,
        ApproveRequestData(notes: notes, mfaVerified: mfaVerified),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Deny request by ID
  Future<ApprovalRequest?> denyRequest(String requestId, {required String reason, String? notes, bool mfaVerified = false}) async {
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.denyRequest(
        requestId,
        DenyRequestData(reason: reason, notes: notes, mfaVerified: mfaVerified),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Request info by ID
  Future<ApprovalRequest?> requestInfo(String requestId, {required String question}) async {
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.requestInfo(
        requestId,
        RequestInfoData(infoRequested: question),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Escalate request by ID
  Future<ApprovalRequest?> escalateRequest(String requestId, {required String reason}) async {
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.escalateRequest(
        requestId,
        EscalateRequestData(reason: reason),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Add comment by request ID
  Future<ApprovalComment?> addComment(String requestId, {
    required String content,
    bool isInternal = false,
    List<Map<String, String>>? attachments,
    String? parentCommentId,
  }) async {
    try {
      final comment = await _service.addComment(
        requestId,
        CreateCommentData(
          content: content,
          isInternal: isInternal,
          attachments: attachments ?? [],
          parentCommentId: parentCommentId,
        ),
      );

      // Refresh comments
      final comments = await _service.getComments(requestId);
      state = state.copyWith(comments: comments);
      return comment;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  /// Approve request
  Future<ApprovalRequest?> approve({String? notes, bool mfaVerified = false}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.approveRequest(
        state.request!.id,
        ApproveRequestData(notes: notes, mfaVerified: mfaVerified),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Deny request
  Future<ApprovalRequest?> deny({required String reason, String? notes, bool mfaVerified = false}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.denyRequest(
        state.request!.id,
        DenyRequestData(reason: reason, notes: notes, mfaVerified: mfaVerified),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Respond to info request
  Future<ApprovalRequest?> respondToInfo({required String response, List<Map<String, String>>? attachments}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.respondToInfo(
        state.request!.id,
        RespondInfoData(response: response, attachments: attachments ?? []),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Delegate request
  Future<ApprovalRequest?> delegate({required String delegateTo, required String reason}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.delegateRequest(
        state.request!.id,
        DelegateRequestData(delegateTo: delegateTo, reason: reason),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Escalate request
  Future<ApprovalRequest?> escalate({required String reason}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.escalateRequest(
        state.request!.id,
        EscalateRequestData(reason: reason),
      );
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Withdraw request
  Future<ApprovalRequest?> withdraw({String? reason}) async {
    if (state.request == null) return null;
    state = state.copyWith(isPerformingAction: true, error: null);

    try {
      final result = await _service.withdrawRequest(state.request!.id, reason: reason);
      state = state.copyWith(
        request: result,
        isPerformingAction: false,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isPerformingAction: false,
      );
      return null;
    }
  }

  /// Clear state
  void clear() {
    state = const ApprovalDetailState();
  }
}

/// StateNotifier for managing approval statistics
class ApprovalStatsNotifier extends StateNotifier<ApprovalStatsState> {
  final ApiClient _apiClient;
  late final ApprovalsApiService _service;

  ApprovalStatsNotifier(this._apiClient) : super(const ApprovalStatsState()) {
    _initService();
  }

  void _initService() {
    // Use token getter for dynamic token retrieval
    _service = ApprovalsApiService(tokenGetter: () => _apiClient.token);
  }

  /// Fetch approval statistics
  Future<void> fetchStatistics({String? regionalScope}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final stats = await _service.getStatistics(regionalScope: regionalScope);
      state = state.copyWith(
        statistics: stats,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Refresh statistics
  Future<void> refresh({String? regionalScope}) async {
    await fetchStatistics(regionalScope: regionalScope);
  }
}

/// StateNotifier for managing pending actions
class PendingActionsNotifier extends StateNotifier<PendingActionsState> {
  final ApiClient _apiClient;
  late final ApprovalsApiService _service;

  PendingActionsNotifier(this._apiClient) : super(const PendingActionsState()) {
    _initService();
    fetchPendingActions();
  }

  void _initService() {
    // Use token getter for dynamic token retrieval
    _service = ApprovalsApiService(tokenGetter: () => _apiClient.token);
  }

  /// Fetch pending actions for current admin
  Future<void> fetchPendingActions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final pendingActions = await _service.getMyPendingActions();
      state = state.copyWith(
        pendingActions: pendingActions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  /// Refresh pending actions
  Future<void> refresh() async {
    await fetchPendingActions();
  }
}

// ============================================================================
// Providers
// ============================================================================

/// Provider for approvals list state
final approvalsListProvider =
    StateNotifierProvider<ApprovalsListNotifier, ApprovalsListState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApprovalsListNotifier(apiClient);
});

/// Provider for approval detail state
final approvalDetailProvider =
    StateNotifierProvider<ApprovalDetailNotifier, ApprovalDetailState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApprovalDetailNotifier(apiClient);
});

/// Provider for approval statistics state
final approvalStatsProvider =
    StateNotifierProvider<ApprovalStatsNotifier, ApprovalStatsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApprovalStatsNotifier(apiClient);
});

/// Provider for pending actions state
final pendingActionsProvider =
    StateNotifierProvider<PendingActionsNotifier, PendingActionsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PendingActionsNotifier(apiClient);
});

/// Provider for approval requests list
final approvalsListDataProvider = Provider<List<ApprovalRequest>>((ref) {
  final state = ref.watch(approvalsListProvider);
  return state.requests;
});

/// Provider for approvals loading state
final approvalsLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(approvalsListProvider);
  return state.isLoading;
});

/// Provider for approvals error
final approvalsErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(approvalsListProvider);
  return state.error;
});

/// Provider for current approval detail
final currentApprovalProvider = Provider<ApprovalRequest?>((ref) {
  final state = ref.watch(approvalDetailProvider);
  return state.request;
});

/// Provider for approval detail loading state
final approvalDetailLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(approvalDetailProvider);
  return state.isLoading;
});

/// Provider for approval action in progress
final approvalActionInProgressProvider = Provider<bool>((ref) {
  final state = ref.watch(approvalDetailProvider);
  return state.isPerformingAction;
});

/// Provider for pending actions count
final pendingActionsCountProvider = Provider<int>((ref) {
  final state = ref.watch(pendingActionsProvider);
  return state.pendingActions?.total ?? 0;
});

/// Provider for pending reviews
final pendingReviewsProvider = Provider<List<PendingApprovalItem>>((ref) {
  final state = ref.watch(pendingActionsProvider);
  return state.pendingActions?.pendingReviews ?? [];
});

/// Provider for approval statistics
final approvalStatisticsProvider = Provider<ApprovalStatistics?>((ref) {
  final state = ref.watch(approvalStatsProvider);
  return state.statistics;
});
