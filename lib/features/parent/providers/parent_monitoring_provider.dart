import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/child_model.dart' hide Application, CourseProgress;
import '../../../core/models/progress_model.dart';
import '../../../core/models/application_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for child monitoring data
class ChildMonitoringState {
  final String? selectedChildId;
  final List<CourseProgress> courseProgress;
  final List<Application> applications;
  final Map<String, dynamic> performanceMetrics;
  final bool isLoading;
  final String? error;

  const ChildMonitoringState({
    this.selectedChildId,
    this.courseProgress = const [],
    this.applications = const [],
    this.performanceMetrics = const {},
    this.isLoading = false,
    this.error,
  });

  ChildMonitoringState copyWith({
    String? selectedChildId,
    List<CourseProgress>? courseProgress,
    List<Application>? applications,
    Map<String, dynamic>? performanceMetrics,
    bool? isLoading,
    String? error,
  }) {
    return ChildMonitoringState(
      selectedChildId: selectedChildId ?? this.selectedChildId,
      courseProgress: courseProgress ?? this.courseProgress,
      applications: applications ?? this.applications,
      performanceMetrics: performanceMetrics ?? this.performanceMetrics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for monitoring child progress
class ChildMonitoringNotifier extends StateNotifier<ChildMonitoringState> {
  final ApiClient _apiClient;

  ChildMonitoringNotifier(this._apiClient) : super(const ChildMonitoringState());

  /// Select a child to monitor
  void selectChild(String childId) {
    state = state.copyWith(selectedChildId: childId);
    loadChildData(childId);
  }

  /// Load all data for selected child from backend API
  Future<void> loadChildData(String childId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Fetch child's enrollments (contains progress)
      final enrollmentsResponse = await _apiClient.get(
        '${ApiConfig.parent}/children/$childId/enrollments',
        fromJson: (data) {
          if (data is List) {
            // Convert enrollments to course progress
            return data.map((e) {
              return CourseProgress(
                courseId: e['course_id'] ?? '',
                courseName: e['course']?['title'] ?? 'Unknown',
                completionPercentage: (e['progress'] ?? 0).toDouble(),
                currentGrade: 0.0,
                assignmentsCompleted: 0,
                totalAssignments: 0,
                quizzesCompleted: 0,
                totalQuizzes: 0,
                timeSpent: Duration.zero,
                lastAccessed: DateTime.now(),
                modules: [],
                grades: [],
              );
            }).toList();
          }
          return <CourseProgress>[];
        },
      );

      // Fetch child's applications
      final applicationsResponse = await _apiClient.get(
        '${ApiConfig.parent}/children/$childId/applications',
        fromJson: (data) {
          if (data is List) {
            return data.map((appJson) => Application.fromJson(appJson)).toList();
          }
          return <Application>[];
        },
      );

      final courseProgress = enrollmentsResponse.data ?? [];
      final applications = applicationsResponse.data ?? [];
      final metrics = _calculatePerformanceMetrics(courseProgress);

      state = state.copyWith(
        courseProgress: courseProgress,
        applications: applications,
        performanceMetrics: metrics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load child data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Calculate performance metrics from course progress
  Map<String, dynamic> _calculatePerformanceMetrics(List<CourseProgress> progress) {
    if (progress.isEmpty) {
      return {
        'averageGrade': 0.0,
        'averageCompletion': 0.0,
        'completedCourses': 0,
        'inProgressCourses': 0,
        'totalAssignments': 0,
        'completedAssignments': 0,
        'pendingAssignments': 0,
        'gradeDistribution': {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'F': 0},
      };
    }

    double totalGrade = 0;
    double totalCompletion = 0;
    int completedCourses = 0;
    int totalAssignments = 0;
    int completedAssignments = 0;
    Map<String, int> gradeDistribution = {'A': 0, 'B': 0, 'C': 0, 'D': 0, 'F': 0};

    for (final course in progress) {
      // Average grade - currentGrade is already a double
      totalGrade += course.currentGrade;

      // Average completion
      totalCompletion += course.completionPercentage;

      // Completed courses
      if (course.completionPercentage >= 100) {
        completedCourses++;
      }

      // Assignments
      totalAssignments += course.totalAssignments;
      completedAssignments += course.assignmentsCompleted;

      // Grade distribution
      final letterGrade = _getLetterGrade(course.currentGrade);
      gradeDistribution[letterGrade] = (gradeDistribution[letterGrade] ?? 0) + 1;
    }

    return {
      'averageGrade': (totalGrade / progress.length).toStringAsFixed(1),
      'averageCompletion': (totalCompletion / progress.length).toStringAsFixed(1),
      'completedCourses': completedCourses,
      'inProgressCourses': progress.length - completedCourses,
      'totalAssignments': totalAssignments,
      'completedAssignments': completedAssignments,
      'pendingAssignments': totalAssignments - completedAssignments,
      'gradeDistribution': gradeDistribution,
    };
  }

  /// Parse grade string to numeric value
  double _parseGrade(String grade) {
    // Handle letter grades
    switch (grade.toUpperCase()) {
      case 'A':
        return 95.0;
      case 'A-':
        return 90.0;
      case 'B+':
        return 87.0;
      case 'B':
        return 85.0;
      case 'B-':
        return 80.0;
      case 'C+':
        return 77.0;
      case 'C':
        return 75.0;
      case 'C-':
        return 70.0;
      case 'D':
        return 65.0;
      case 'F':
        return 50.0;
      default:
        // Try to parse as number
        return double.tryParse(grade.replaceAll('%', '')) ?? 0.0;
    }
  }

  /// Get letter grade from numeric value
  String _getLetterGrade(double grade) {
    if (grade >= 90) return 'A';
    if (grade >= 80) return 'B';
    if (grade >= 70) return 'C';
    if (grade >= 60) return 'D';
    return 'F';
  }

  /// Get courses by status
  List<CourseProgress> getCoursesByStatus(String status) {
    if (status == 'all') return state.courseProgress;

    if (status == 'completed') {
      return state.courseProgress.where((c) => c.completionPercentage >= 100).toList();
    } else if (status == 'in_progress') {
      return state.courseProgress.where((c) => c.completionPercentage < 100).toList();
    }

    return state.courseProgress;
  }

  /// Get applications by status
  List<Application> getApplicationsByStatus(String status) {
    if (status == 'all') return state.applications;

    return state.applications.where((app) => app.status == status).toList();
  }

  /// Refresh child data
  Future<void> refresh() async {
    if (state.selectedChildId != null) {
      await loadChildData(state.selectedChildId!);
    }
  }
}

/// Provider for child monitoring state
final childMonitoringProvider = StateNotifierProvider<ChildMonitoringNotifier, ChildMonitoringState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChildMonitoringNotifier(apiClient);
});

/// Provider for selected child's course progress
final selectedChildCourseProgressProvider = Provider<List<CourseProgress>>((ref) {
  final monitoringState = ref.watch(childMonitoringProvider);
  return monitoringState.courseProgress;
});

/// Provider for selected child's applications
final selectedChildApplicationsProvider = Provider<List<Application>>((ref) {
  final monitoringState = ref.watch(childMonitoringProvider);
  return monitoringState.applications;
});

/// Provider for selected child's performance metrics
final selectedChildPerformanceMetricsProvider = Provider<Map<String, dynamic>>((ref) {
  final monitoringState = ref.watch(childMonitoringProvider);
  return monitoringState.performanceMetrics;
});

/// Provider for checking if child data is loading
final childMonitoringLoadingProvider = Provider<bool>((ref) {
  final monitoringState = ref.watch(childMonitoringProvider);
  return monitoringState.isLoading;
});

/// Provider for child monitoring error
final childMonitoringErrorProvider = Provider<String?>((ref) {
  final monitoringState = ref.watch(childMonitoringProvider);
  return monitoringState.error;
});
