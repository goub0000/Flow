import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Fetch real data from backend API
      final apiService = ref.read(applicationsApiServiceProvider);

      // Get statistics from the API
      Map<String, dynamic> apiStatistics = {};
      try {
        apiStatistics = await apiService.getStatistics();
      } catch (e) {
        // Fall back to local provider statistics
      }

      // Also ensure applicants are loaded
      await ref.read(institutionApplicantsProvider.notifier).fetchApplicants();

      // Get statistics from providers (includes real data from API)
      final programStats = ref.read(institutionProgramStatisticsProvider);
      final applicantStats = ref.read(institutionApplicantStatisticsProvider);

      // Merge API statistics with local statistics
      final statistics = {
        // Use API statistics if available, otherwise use local
        'totalPrograms': apiStatistics['total_programs'] ?? programStats['totalPrograms'] ?? 0,
        'activePrograms': apiStatistics['active_programs'] ?? programStats['activePrograms'] ?? 0,
        'inactivePrograms': programStats['inactivePrograms'] ?? 0,
        'totalCapacity': programStats['totalCapacity'] ?? 0,
        'totalEnrolled': apiStatistics['total_enrolled'] ?? programStats['totalEnrolled'] ?? 0,
        'availableSpots': programStats['availableSpots'] ?? 0,
        'occupancyRate': programStats['occupancyRate'] ?? '0',

        // Applicant statistics from API or local
        'totalApplicants': apiStatistics['total_applications'] ?? applicantStats['total'] ?? 0,
        'pendingApplicants': apiStatistics['pending_applications'] ?? applicantStats['pending'] ?? 0,
        'underReviewApplicants': apiStatistics['under_review_applications'] ?? applicantStats['underReview'] ?? 0,
        'acceptedApplicants': apiStatistics['accepted_applications'] ?? applicantStats['accepted'] ?? 0,
        'rejectedApplicants': apiStatistics['rejected_applications'] ?? applicantStats['rejected'] ?? 0,

        // Additional metrics
        'acceptanceRate': apiStatistics['acceptance_rate'] ?? _calculateAcceptanceRate(applicantStats),
        'averageReviewTime': apiStatistics['average_review_time'] ?? '2.5 days',
        'newApplicationsThisWeek': apiStatistics['new_applications_this_week'] ?? applicantStats['pending'] ?? 0,
      };

      // Generate activity from real data
      final recentActivity = _generateActivityFromApplications();

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
  String _calculateAcceptanceRate(Map<String, dynamic> applicantStats) {
    final total = (applicantStats['total'] ?? 0) as int;
    final accepted = (applicantStats['accepted'] ?? 0) as int;

    if (total == 0) return '0.0';

    return (accepted / total * 100).toStringAsFixed(1);
  }

  /// Generate recent activity from actual applications data
  List<Map<String, dynamic>> _generateActivityFromApplications() {
    try {
      // Get recent applicants from the provider
      final recentApplicants = ref.read(recentApplicantsProvider);

      // Convert to activity items
      final activities = <Map<String, dynamic>>[];

      for (final applicant in recentApplicants.take(10)) {
        activities.add({
          'id': applicant.id,
          'type': 'new_application',
          'title': 'New Application',
          'description': '${applicant.studentName} applied for ${applicant.programName}',
          'timestamp': applicant.submittedAt,
          'icon': 'application',
          'status': applicant.status,
        });
      }

      // Sort by timestamp (most recent first)
      activities.sort((a, b) {
        final aTime = a['timestamp'] as DateTime;
        final bTime = b['timestamp'] as DateTime;
        return bTime.compareTo(aTime);
      });

      return activities;
    } catch (e) {
      return [];
    }
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
