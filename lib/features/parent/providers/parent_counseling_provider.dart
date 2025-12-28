import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../shared/counseling/models/counseling_models.dart';
import '../services/parent_counseling_service.dart';

/// Provider for the parent counseling service
final parentCounselingServiceProvider = Provider<ParentCounselingService>((ref) {
  final authState = ref.watch(authStateProvider);
  final token = authState.value?.session?.accessToken;
  return ParentCounselingService(authToken: token);
});

/// State for child's counseling data
class ChildCounselingState {
  final String? childId;
  final CounselorInfo? counselor;
  final List<CounselingSession> sessions;
  final bool isLoading;
  final String? error;

  const ChildCounselingState({
    this.childId,
    this.counselor,
    this.sessions = const [],
    this.isLoading = false,
    this.error,
  });

  ChildCounselingState copyWith({
    String? childId,
    CounselorInfo? counselor,
    List<CounselingSession>? sessions,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearCounselor = false,
  }) {
    return ChildCounselingState(
      childId: childId ?? this.childId,
      counselor: clearCounselor ? null : (counselor ?? this.counselor),
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  /// Get upcoming sessions
  List<CounselingSession> get upcomingSessions =>
      sessions.where((s) => s.isUpcoming).toList();

  /// Get past sessions
  List<CounselingSession> get pastSessions =>
      sessions.where((s) => !s.isUpcoming).toList();
}

/// Notifier for child's counseling state
class ChildCounselingNotifier extends StateNotifier<ChildCounselingState> {
  final ParentCounselingService _service;

  ChildCounselingNotifier(this._service) : super(const ChildCounselingState());

  /// Load counseling data for a child
  Future<void> loadChildCounseling(String childId) async {
    if (state.childId == childId && !state.isLoading && state.counselor != null) {
      return; // Already loaded
    }

    state = state.copyWith(
      childId: childId,
      isLoading: true,
      clearError: true,
    );

    try {
      // Load counselor and sessions in parallel
      final results = await Future.wait([
        _service.getChildCounselor(childId),
        _service.getChildSessions(childId: childId),
      ]);

      final counselor = results[0] as CounselorInfo?;
      final sessionsResult = results[1] as ({
        List<CounselingSession> sessions,
        int total,
        bool hasMore,
      });

      state = state.copyWith(
        counselor: counselor,
        sessions: sessionsResult.sessions,
        isLoading: false,
        clearCounselor: counselor == null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    if (state.childId != null) {
      state = state.copyWith(isLoading: true, clearError: true);
      await loadChildCounseling(state.childId!);
    }
  }

  /// Clear state
  void clear() {
    state = const ChildCounselingState();
  }
}

/// Provider for child's counseling state
final childCounselingProvider =
    StateNotifierProvider<ChildCounselingNotifier, ChildCounselingState>((ref) {
  final service = ref.watch(parentCounselingServiceProvider);
  return ChildCounselingNotifier(service);
});

/// Provider that loads counseling data for a specific child
final childCounselingDataProvider = FutureProvider.family<ChildCounselingState, String>(
  (ref, childId) async {
    final service = ref.watch(parentCounselingServiceProvider);

    try {
      final results = await Future.wait([
        service.getChildCounselor(childId),
        service.getChildSessions(childId: childId),
      ]);

      final counselor = results[0] as CounselorInfo?;
      final sessionsResult = results[1] as ({
        List<CounselingSession> sessions,
        int total,
        bool hasMore,
      });

      return ChildCounselingState(
        childId: childId,
        counselor: counselor,
        sessions: sessionsResult.sessions,
        isLoading: false,
      );
    } catch (e) {
      return ChildCounselingState(
        childId: childId,
        isLoading: false,
        error: e.toString(),
      );
    }
  },
);
