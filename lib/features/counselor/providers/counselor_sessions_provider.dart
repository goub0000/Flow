import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/counseling_models.dart';

const _uuid = Uuid();

/// State class for managing counseling sessions
class CounselorSessionsState {
  final List<CounselingSession> sessions;
  final bool isLoading;
  final String? error;

  const CounselorSessionsState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
  });

  CounselorSessionsState copyWith({
    List<CounselingSession>? sessions,
    bool? isLoading,
    String? error,
  }) {
    return CounselorSessionsState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing counseling sessions
class CounselorSessionsNotifier extends StateNotifier<CounselorSessionsState> {
  CounselorSessionsNotifier() : super(const CounselorSessionsState()) {
    fetchSessions();
  }

  /// Fetch all sessions
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchSessions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('counseling_sessions')
      //   .where('counselorId', isEqualTo: currentCounselorId)
      //   .orderBy('scheduledDate', descending: false)
      //   .get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockSessions = List<CounselingSession>.generate(
        15,
        (index) => CounselingSession.mockSession(index),
      );

      state = state.copyWith(
        sessions: mockSessions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch sessions: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new session
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> createSession({
    required String studentId,
    required String studentName,
    required String type,
    required DateTime scheduledDate,
    required Duration duration,
    required String location,
    String? notes,
  }) async {
    try {
      // TODO: Replace with actual Firebase write

      await Future.delayed(const Duration(milliseconds: 500));

      final session = CounselingSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: studentId,
        studentName: studentName,
        counselorId: 'counselor1', // TODO: Get from auth
        scheduledDate: scheduledDate,
        duration: duration,
        type: type,
        status: 'scheduled',
        notes: notes,
        createdAt: DateTime.now(),
        location: location,
      );

      final updatedSessions = [...state.sessions, session];
      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update session
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateSession(CounselingSession session) async {
    try {
      // TODO: Replace with actual Firebase update

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedSessions = state.sessions.map((s) {
        return s.id == session.id ? session : s;
      }).toList();

      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update session status
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateSessionStatus(String sessionId, String newStatus) async {
    try {
      // TODO: Update in Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedSessions = state.sessions.map((s) {
        if (s.id == sessionId) {
          return CounselingSession(
            id: s.id,
            studentId: s.studentId,
            studentName: s.studentName,
            counselorId: s.counselorId,
            type: s.type,
            scheduledDate: s.scheduledDate,
            duration: s.duration,
            location: s.location,
            status: newStatus,
            notes: s.notes,
            summary: s.summary,
            actionItems: s.actionItems,
            createdAt: s.createdAt,
            followUpDate: s.followUpDate,
          );
        }
        return s;
      }).toList();

      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update session status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add session notes
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addSessionNotes(String sessionId, String notes, String summary) async {
    try {
      // TODO: Update in Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedSessions = state.sessions.map((s) {
        if (s.id == sessionId) {
          return CounselingSession(
            id: s.id,
            studentId: s.studentId,
            studentName: s.studentName,
            counselorId: s.counselorId,
            type: s.type,
            scheduledDate: s.scheduledDate,
            duration: s.duration,
            location: s.location,
            status: s.status,
            notes: notes,
            summary: summary,
            actionItems: s.actionItems,
            createdAt: s.createdAt,
            followUpDate: s.followUpDate,
          );
        }
        return s;
      }).toList();

      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add session notes: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add action items
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addActionItems(String sessionId, List<String> actionItems) async {
    try {
      // TODO: Update in Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedSessions = state.sessions.map((s) {
        if (s.id == sessionId) {
          return CounselingSession(
            id: s.id,
            studentId: s.studentId,
            studentName: s.studentName,
            counselorId: s.counselorId,
            type: s.type,
            scheduledDate: s.scheduledDate,
            duration: s.duration,
            location: s.location,
            status: s.status,
            notes: s.notes,
            summary: s.summary,
            actionItems: actionItems,
            createdAt: s.createdAt,
            followUpDate: s.followUpDate,
          );
        }
        return s;
      }).toList();

      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add action items: ${e.toString()}',
      );
      return false;
    }
  }

  /// Cancel session
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> cancelSession(String sessionId, String reason) async {
    try {
      // TODO: Update in Firebase with cancellation reason

      await Future.delayed(const Duration(milliseconds: 300));

      return await updateSessionStatus(sessionId, 'cancelled');
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to cancel session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete session
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> deleteSession(String sessionId) async {
    try {
      // TODO: Delete from Firebase

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedSessions = state.sessions.where((s) => s.id != sessionId).toList();
      state = state.copyWith(sessions: updatedSessions);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Filter sessions by status
  List<CounselingSession> filterByStatus(String status) {
    if (status == 'all') return state.sessions;

    return state.sessions.where((session) => session.status == status).toList();
  }

  /// Filter sessions by type
  List<CounselingSession> filterByType(String type) {
    if (type == 'all') return state.sessions;

    return state.sessions.where((session) => session.type == type).toList();
  }

  /// Filter sessions by student
  List<CounselingSession> filterByStudent(String studentId) {
    return state.sessions.where((session) => session.studentId == studentId).toList();
  }

  /// Get upcoming sessions
  List<CounselingSession> getUpcomingSessions() {
    final now = DateTime.now();
    return state.sessions.where((session) {
      return session.scheduledDate.isAfter(now) && session.status == 'scheduled';
    }).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  /// Get today's sessions
  List<CounselingSession> getTodaySessions() {
    final now = DateTime.now();
    return state.sessions.where((session) {
      return session.scheduledDate.year == now.year &&
          session.scheduledDate.month == now.month &&
          session.scheduledDate.day == now.day;
    }).toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  /// Get completed sessions
  List<CounselingSession> getCompletedSessions() {
    return state.sessions.where((session) => session.status == 'completed').toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  /// Get session by ID
  CounselingSession? getSessionById(String id) {
    try {
      return state.sessions.firstWhere((session) => session.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get session statistics
  Map<String, dynamic> getSessionStatistics() {
    return {
      'total': state.sessions.length,
      'upcoming': getUpcomingSessions().length,
      'today': getTodaySessions().length,
      'completed': state.sessions.where((s) => s.status == 'completed').length,
      'cancelled': state.sessions.where((s) => s.status == 'cancelled').length,
      'inProgress': state.sessions.where((s) => s.status == 'in_progress').length,
    };
  }
}

/// Provider for counselor sessions state
final counselorSessionsProvider = StateNotifierProvider<CounselorSessionsNotifier, CounselorSessionsState>((ref) {
  return CounselorSessionsNotifier();
});

/// Provider for sessions list
final counselorSessionsListProvider = Provider<List<CounselingSession>>((ref) {
  final sessionsState = ref.watch(counselorSessionsProvider);
  return sessionsState.sessions;
});

/// Provider for upcoming sessions
final upcomingSessionsProvider = Provider<List<CounselingSession>>((ref) {
  final notifier = ref.watch(counselorSessionsProvider.notifier);
  return notifier.getUpcomingSessions();
});

/// Provider for today's sessions
final todaySessionsProvider = Provider<List<CounselingSession>>((ref) {
  final notifier = ref.watch(counselorSessionsProvider.notifier);
  return notifier.getTodaySessions();
});

/// Provider for completed sessions
final completedSessionsProvider = Provider<List<CounselingSession>>((ref) {
  final notifier = ref.watch(counselorSessionsProvider.notifier);
  return notifier.getCompletedSessions();
});

/// Provider for session statistics
final counselorSessionStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(counselorSessionsProvider.notifier);
  return notifier.getSessionStatistics();
});

/// Provider for checking if sessions are loading
final counselorSessionsLoadingProvider = Provider<bool>((ref) {
  final sessionsState = ref.watch(counselorSessionsProvider);
  return sessionsState.isLoading;
});

/// Provider for sessions error
final counselorSessionsErrorProvider = Provider<String?>((ref) {
  final sessionsState = ref.watch(counselorSessionsProvider);
  return sessionsState.error;
});
