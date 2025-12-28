import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../shared/counseling/models/counseling_models.dart';
import '../services/student_counseling_service.dart';

/// Provider for the counseling service
final studentCounselingServiceProvider = Provider<StudentCounselingService>((ref) {
  final authState = ref.watch(authStateProvider);
  final token = authState.value?.session?.accessToken;
  return StudentCounselingService(authToken: token);
});

/// State for student counseling data
class StudentCounselingState {
  final CounselorInfo? counselor;
  final List<CounselingSession> sessions;
  final CounselingStats? stats;
  final bool isLoading;
  final String? error;
  final List<BookingSlot> availableSlots;
  final DateTime? selectedDate;

  const StudentCounselingState({
    this.counselor,
    this.sessions = const [],
    this.stats,
    this.isLoading = false,
    this.error,
    this.availableSlots = const [],
    this.selectedDate,
  });

  StudentCounselingState copyWith({
    CounselorInfo? counselor,
    List<CounselingSession>? sessions,
    CounselingStats? stats,
    bool? isLoading,
    String? error,
    List<BookingSlot>? availableSlots,
    DateTime? selectedDate,
    bool clearError = false,
    bool clearCounselor = false,
  }) {
    return StudentCounselingState(
      counselor: clearCounselor ? null : (counselor ?? this.counselor),
      sessions: sessions ?? this.sessions,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      availableSlots: availableSlots ?? this.availableSlots,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  /// Get upcoming sessions
  List<CounselingSession> get upcomingSessions =>
      sessions.where((s) => s.isUpcoming).toList();

  /// Get past sessions
  List<CounselingSession> get pastSessions =>
      sessions.where((s) => !s.isUpcoming).toList();
}

/// Notifier for student counseling state
class StudentCounselingNotifier extends StateNotifier<StudentCounselingState> {
  final StudentCounselingService _service;

  StudentCounselingNotifier(this._service) : super(const StudentCounselingState());

  /// Load assigned counselor
  Future<void> loadCounselor() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final counselor = await _service.getAssignedCounselor();
      state = state.copyWith(
        counselor: counselor,
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

  /// Load counseling sessions
  Future<void> loadSessions({String? status}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _service.getSessions(status: status);
      state = state.copyWith(
        sessions: result.sessions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load counseling stats
  Future<void> loadStats() async {
    try {
      final stats = await _service.getStats();
      state = state.copyWith(stats: stats);
    } catch (e) {
      // Stats are optional, don't set error
    }
  }

  /// Load available booking slots
  Future<void> loadAvailableSlots({
    required String counselorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final slots = await _service.getAvailableSlots(
        counselorId: counselorId,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(
        availableSlots: slots,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Select a date for booking
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  /// Book a session
  Future<CounselingSession?> bookSession(BookSessionRequest request) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _service.bookSession(request);
      // Reload sessions after booking
      await loadSessions();
      return session;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return null;
    }
  }

  /// Cancel a session
  Future<bool> cancelSession(String sessionId, {String? reason}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _service.cancelSession(sessionId, reason: reason);
      // Reload sessions after cancellation
      await loadSessions();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Submit feedback for a session
  Future<bool> submitFeedback(
    String sessionId,
    double rating,
    String? comment,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final feedback = SessionFeedbackRequest(rating: rating, comment: comment);
      await _service.submitFeedback(sessionId, feedback);
      // Reload sessions after feedback
      await loadSessions();
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await Future.wait([
      loadCounselor(),
      loadSessions(),
      loadStats(),
    ]);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for student counseling state
final studentCounselingProvider =
    StateNotifierProvider<StudentCounselingNotifier, StudentCounselingState>((ref) {
  final service = ref.watch(studentCounselingServiceProvider);
  return StudentCounselingNotifier(service);
});

/// Provider for assigned counselor only
final studentCounselorProvider = FutureProvider<CounselorInfo?>((ref) async {
  final service = ref.watch(studentCounselingServiceProvider);
  return await service.getAssignedCounselor();
});

/// Provider for student sessions
final studentSessionsProvider =
    FutureProvider<List<CounselingSession>>((ref) async {
  final service = ref.watch(studentCounselingServiceProvider);
  final result = await service.getSessions();
  return result.sessions;
});

/// Provider for upcoming sessions only
final upcomingSessionsProvider = Provider<List<CounselingSession>>((ref) {
  final state = ref.watch(studentCounselingProvider);
  return state.upcomingSessions;
});

/// Provider for past sessions only
final pastSessionsProvider = Provider<List<CounselingSession>>((ref) {
  final state = ref.watch(studentCounselingProvider);
  return state.pastSessions;
});
