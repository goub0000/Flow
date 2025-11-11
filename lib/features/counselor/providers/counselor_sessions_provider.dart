import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/counseling_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

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
  final ApiClient _apiClient;

  CounselorSessionsNotifier(this._apiClient) : super(const CounselorSessionsState()) {
    fetchSessions();
  }

  /// Fetch all sessions from backend API
  Future<void> fetchSessions() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.counseling}/sessions',
        fromJson: (data) {
          if (data is List) {
            return data.map((sessionJson) => CounselingSession.fromJson(sessionJson)).toList();
          }
          return <CounselingSession>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          sessions: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch sessions',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch sessions: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new session via backend API
  Future<bool> createSession({
    required String studentId,
    required String type,
    required DateTime scheduledDate,
    required Duration duration,
    required String location,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/sessions',
        data: {
          'student_id': studentId,
          'type': type,
          'scheduled_date': scheduledDate.toIso8601String(),
          'duration_minutes': duration.inMinutes,
          'location': location,
          'notes': notes,
        },
        fromJson: (data) => CounselingSession.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedSessions = [...state.sessions, response.data!];
        state = state.copyWith(sessions: updatedSessions);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create session',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update session via backend API
  Future<bool> updateSession(String sessionId, {
    DateTime? scheduledDate,
    Duration? duration,
    String? location,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.counseling}/sessions/$sessionId',
        data: {
          if (scheduledDate != null) 'scheduled_date': scheduledDate.toIso8601String(),
          if (duration != null) 'duration_minutes': duration.inMinutes,
          if (location != null) 'location': location,
          if (notes != null) 'notes': notes,
        },
        fromJson: (data) => CounselingSession.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedSessions = state.sessions.map((s) {
          return s.id == sessionId ? response.data! : s;
        }).toList();
        state = state.copyWith(sessions: updatedSessions);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update session',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update session: ${e.toString()}',
      );
      return false;
    }
  }

  /// Start session via backend API
  Future<bool> startSession(String sessionId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/sessions/$sessionId/start',
        fromJson: (data) => CounselingSession.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedSessions = state.sessions.map((s) {
          return s.id == sessionId ? response.data! : s;
        }).toList();
        state = state.copyWith(sessions: updatedSessions);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to start session: ${e.toString()}');
      return false;
    }
  }

  /// Complete session via backend API
  Future<bool> completeSession(String sessionId, {String? notes, String? summary}) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/sessions/$sessionId/complete',
        data: {
          if (notes != null) 'notes': notes,
          if (summary != null) 'summary': summary,
        },
        fromJson: (data) => CounselingSession.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedSessions = state.sessions.map((s) {
          return s.id == sessionId ? response.data! : s;
        }).toList();
        state = state.copyWith(sessions: updatedSessions);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to complete session: ${e.toString()}');
      return false;
    }
  }

  /// Add session notes via backend API
  Future<bool> addSessionNotes(String sessionId, String notes) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/sessions/$sessionId/notes',
        data: {'notes': notes},
        fromJson: (data) => data,
      );

      if (response.success) {
        // Refetch sessions to get updated data
        await fetchSessions();
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to add notes: ${e.toString()}');
      return false;
    }
  }

  /// Cancel session via backend API
  Future<bool> cancelSession(String sessionId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/sessions/$sessionId/cancel',
        fromJson: (data) => CounselingSession.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedSessions = state.sessions.map((s) {
          return s.id == sessionId ? response.data! : s;
        }).toList();
        state = state.copyWith(sessions: updatedSessions);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to cancel session: ${e.toString()}');
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
  final apiClient = ref.watch(apiClientProvider);
  return CounselorSessionsNotifier(apiClient);
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
