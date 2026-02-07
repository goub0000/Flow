import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'counselor_students_provider.dart';
import 'counselor_sessions_provider.dart';

/// State class for counselor dashboard data
class CounselorDashboardState {
  final Map<String, dynamic> statistics;
  final List<Map<String, dynamic>> recentActivity;
  final bool isLoading;
  final String? error;

  const CounselorDashboardState({
    this.statistics = const {},
    this.recentActivity = const [],
    this.isLoading = false,
    this.error,
  });

  CounselorDashboardState copyWith({
    Map<String, dynamic>? statistics,
    List<Map<String, dynamic>>? recentActivity,
    bool? isLoading,
    String? error,
  }) {
    return CounselorDashboardState(
      statistics: statistics ?? this.statistics,
      recentActivity: recentActivity ?? this.recentActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing counselor dashboard
class CounselorDashboardNotifier extends StateNotifier<CounselorDashboardState> {
  final Ref ref;

  CounselorDashboardNotifier(this.ref) : super(const CounselorDashboardState()) {
    loadDashboardData();
  }

  /// Load all dashboard data
  /// TODO: Connect to backend API
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual backend API queries

      await Future.delayed(const Duration(seconds: 1));

      // Get statistics from other providers
      final studentStats = ref.read(counselorStudentStatisticsProvider);
      final sessionStats = ref.read(counselorSessionStatisticsProvider);

      final statistics = {
        // Student statistics
        'totalStudents': studentStats['totalStudents'],
        'averageGpa': studentStats['averageGpa'],
        'studentsNeedingAttention': studentStats['studentsNeedingAttention'],

        // Session statistics
        'totalSessions': sessionStats['total'],
        'upcomingSessions': sessionStats['upcoming'],
        'todaySessions': sessionStats['today'],
        'completedSessions': sessionStats['completed'],
        'cancelledSessions': sessionStats['cancelled'],

        // Additional metrics
        'sessionsThisWeek': _calculateSessionsThisWeek(sessionStats),
        'sessionsThisMonth': sessionStats['completed'] ?? 0,
        'averageSessionsPerStudent': _calculateAverageSessionsPerStudent(
          studentStats['totalStudents'] as int,
          sessionStats['total'] as int,
        ),
      };

      // Mock recent activity
      final recentActivity = _generateMockActivity();

      state = state.copyWith(
        statistics: statistics,
        recentActivity: recentActivity,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load dashboard data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Calculate sessions this week
  int _calculateSessionsThisWeek(Map<String, dynamic> sessionStats) {
    // TODO: Calculate from actual session dates
    return (sessionStats['upcoming'] as int) + (sessionStats['today'] as int);
  }

  /// Calculate average sessions per student
  String _calculateAverageSessionsPerStudent(int totalStudents, int totalSessions) {
    if (totalStudents == 0) return '0.0';
    return (totalSessions / totalStudents).toStringAsFixed(1);
  }

  /// Generate mock recent activity
  /// TODO: Replace with actual data from backend API
  List<Map<String, dynamic>> _generateMockActivity() {
    return [
      {
        'type': 'session_completed',
        'title': 'Session Completed',
        'description': 'Career counseling session with John Smith',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'icon': 'check_circle',
        'color': 'green',
      },
      {
        'type': 'session_scheduled',
        'title': 'Session Scheduled',
        'description': 'Academic session with Sarah Johnson tomorrow at 2:00 PM',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'icon': 'event',
        'color': 'blue',
      },
      {
        'type': 'student_added',
        'title': 'New Student Assigned',
        'description': 'Michael Brown added to your caseload',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'icon': 'person_add',
        'color': 'purple',
      },
      {
        'type': 'action_item',
        'title': 'Action Item Completed',
        'description': 'Follow-up call completed for Emma Davis',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'task_alt',
        'color': 'teal',
      },
      {
        'type': 'alert',
        'title': 'Student Needs Attention',
        'description': 'Alex Wilson has not had a session in 30 days',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'warning',
        'color': 'orange',
      },
    ];
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Get statistics by key
  dynamic getStatistic(String key) {
    return state.statistics[key];
  }

  /// Get activity by type
  List<Map<String, dynamic>> getActivityByType(String type) {
    return state.recentActivity.where((activity) {
      return activity['type'] == type;
    }).toList();
  }

  /// Get activity count for today
  int getTodayActivityCount() {
    final today = DateTime.now();
    return state.recentActivity.where((activity) {
      final timestamp = activity['timestamp'] as DateTime;
      return timestamp.year == today.year &&
          timestamp.month == today.month &&
          timestamp.day == today.day;
    }).length;
  }
}

/// Provider for counselor dashboard state
final counselorDashboardProvider = StateNotifierProvider<CounselorDashboardNotifier, CounselorDashboardState>((ref) {
  return CounselorDashboardNotifier(ref);
});

/// Provider for dashboard statistics
final counselorDashboardStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final dashboardState = ref.watch(counselorDashboardProvider);
  return dashboardState.statistics;
});

/// Provider for recent activity
final counselorRecentActivityProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final dashboardState = ref.watch(counselorDashboardProvider);
  return dashboardState.recentActivity;
});

/// Provider for checking if dashboard is loading
final counselorDashboardLoadingProvider = Provider<bool>((ref) {
  final dashboardState = ref.watch(counselorDashboardProvider);
  return dashboardState.isLoading;
});

/// Provider for dashboard error
final counselorDashboardErrorProvider = Provider<String?>((ref) {
  final dashboardState = ref.watch(counselorDashboardProvider);
  return dashboardState.error;
});
