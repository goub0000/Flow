import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'institution_programs_provider.dart';
import 'institution_applicants_provider.dart';

/// State class for institution dashboard data
class InstitutionDashboardState {
  final Map<String, dynamic> statistics;
  final List<Map<String, dynamic>> recentActivity;
  final bool isLoading;
  final String? error;

  const InstitutionDashboardState({
    this.statistics = const {},
    this.recentActivity = const [],
    this.isLoading = false,
    this.error,
  });

  InstitutionDashboardState copyWith({
    Map<String, dynamic>? statistics,
    List<Map<String, dynamic>>? recentActivity,
    bool? isLoading,
    String? error,
  }) {
    return InstitutionDashboardState(
      statistics: statistics ?? this.statistics,
      recentActivity: recentActivity ?? this.recentActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing institution dashboard
class InstitutionDashboardNotifier extends StateNotifier<InstitutionDashboardState> {
  final Ref ref;

  InstitutionDashboardNotifier(this.ref) : super(const InstitutionDashboardState()) {
    loadDashboardData();
  }

  /// Load all dashboard data
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase aggregation queries

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Get statistics from other providers
      final programStats = ref.read(institutionProgramStatisticsProvider);
      final applicantStats = ref.read(institutionApplicantStatisticsProvider);

      final statistics = {
        // Program statistics
        'totalPrograms': programStats['totalPrograms'],
        'activePrograms': programStats['activePrograms'],
        'inactivePrograms': programStats['inactivePrograms'],
        'totalCapacity': programStats['totalCapacity'],
        'totalEnrolled': programStats['totalEnrolled'],
        'availableSpots': programStats['availableSpots'],
        'occupancyRate': programStats['occupancyRate'],

        // Applicant statistics
        'totalApplicants': applicantStats['total'],
        'pendingApplicants': applicantStats['pending'],
        'underReviewApplicants': applicantStats['underReview'],
        'acceptedApplicants': applicantStats['accepted'],
        'rejectedApplicants': applicantStats['rejected'],

        // Additional metrics
        'acceptanceRate': _calculateAcceptanceRate(applicantStats),
        'averageReviewTime': '2.5 days', // TODO: Calculate from actual data
        'newApplicationsThisWeek': applicantStats['pending'] ?? 0,
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

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Calculate acceptance rate
  String _calculateAcceptanceRate(Map<String, int> applicantStats) {
    final total = applicantStats['total'] ?? 0;
    final accepted = applicantStats['accepted'] ?? 0;

    if (total == 0) return '0.0';

    return (accepted / total * 100).toStringAsFixed(1);
  }

  /// Generate mock recent activity
  /// TODO: Replace with actual data from Firebase
  List<Map<String, dynamic>> _generateMockActivity() {
    return [
      {
        'type': 'new_application',
        'title': 'New Application Received',
        'description': 'John Smith applied for Computer Science',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
        'icon': 'person_add',
        'color': 'blue',
      },
      {
        'type': 'application_accepted',
        'title': 'Application Accepted',
        'description': 'Sarah Johnson accepted for Business Administration',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'icon': 'check_circle',
        'color': 'green',
      },
      {
        'type': 'program_updated',
        'title': 'Program Updated',
        'description': 'Engineering program capacity increased to 100',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
        'icon': 'edit',
        'color': 'orange',
      },
      {
        'type': 'document_verified',
        'title': 'Documents Verified',
        'description': '5 applicant documents verified',
        'timestamp': DateTime.now().subtract(const Duration(hours: 8)),
        'icon': 'verified',
        'color': 'purple',
      },
      {
        'type': 'new_enrollment',
        'title': 'New Enrollment',
        'description': '3 students enrolled in Medical Sciences',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'icon': 'school',
        'color': 'teal',
      },
    ];
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

/// Provider for institution dashboard state
final institutionDashboardProvider = StateNotifierProvider<InstitutionDashboardNotifier, InstitutionDashboardState>((ref) {
  return InstitutionDashboardNotifier(ref);
});

/// Provider for dashboard statistics
final institutionDashboardStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final dashboardState = ref.watch(institutionDashboardProvider);
  return dashboardState.statistics;
});

/// Provider for recent activity
final institutionRecentActivityProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final dashboardState = ref.watch(institutionDashboardProvider);
  return dashboardState.recentActivity;
});

/// Provider for checking if dashboard is loading
final institutionDashboardLoadingProvider = Provider<bool>((ref) {
  final dashboardState = ref.watch(institutionDashboardProvider);
  return dashboardState.isLoading;
});

/// Provider for dashboard error
final institutionDashboardErrorProvider = Provider<String?>((ref) {
  final dashboardState = ref.watch(institutionDashboardProvider);
  return dashboardState.error;
});
