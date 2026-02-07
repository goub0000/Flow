import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/progress_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
import './student_enrollments_provider.dart';

/// State class for managing progress
class ProgressState {
  final OverallProgress? overallProgress;
  final List<CourseProgress> courseProgressList;
  final bool isLoading;
  final String? error;

  const ProgressState({
    this.overallProgress,
    this.courseProgressList = const [],
    this.isLoading = false,
    this.error,
  });

  ProgressState copyWith({
    OverallProgress? overallProgress,
    List<CourseProgress>? courseProgressList,
    bool? isLoading,
    String? error,
  }) {
    return ProgressState(
      overallProgress: overallProgress ?? this.overallProgress,
      courseProgressList: courseProgressList ?? this.courseProgressList,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing student progress
class ProgressNotifier extends StateNotifier<ProgressState> {
  final Ref ref;
  final ApiClient _apiClient;

  ProgressNotifier(this.ref, this._apiClient) : super(const ProgressState()) {
    fetchProgress();
  }

  /// Fetch student progress data from backend API
  /// Progress is derived from enrollments data
  Future<void> fetchProgress() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isLoading: false,
        );
        return;
      }

      // Fetch enrollments which contain progress information
      final enrollments = ref.read(enrollmentsListProvider);

      // Convert enrollments to program progress
      final courseProgressList = enrollments.map((enrollment) {
        return CourseProgress(
          courseId: enrollment.courseId,
          courseName: enrollment.courseName,
          completionPercentage: enrollment.progress.toDouble(),
          currentGrade: enrollment.grade ?? 0.0,
          assignmentsCompleted: 0, // TODO: Add assignments tracking
          totalAssignments: 0,
          quizzesCompleted: 0, // TODO: Add quiz tracking
          totalQuizzes: 0,
          timeSpent: Duration.zero, // TODO: Add time tracking
          lastAccessed: enrollment.enrolledAt,
          modules: [], // TODO: Add module progress tracking
          grades: [], // TODO: Add grade tracking
        );
      }).toList();

      state = state.copyWith(
        courseProgressList: courseProgressList,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch progress: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update progress for a specific enrollment
  Future<void> updateEnrollmentProgress(String enrollmentId, int progress) async {
    try {
      await _apiClient.put(
        '${ApiConfig.enrollments}/$enrollmentId/progress',
        data: {
          'progress': progress,
        },
      );

      // Refresh progress data after update
      await fetchProgress();
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update progress: ${e.toString()}',
      );
    }
  }

  /// Get course progress by course ID
  CourseProgress? getCourseProgress(String courseId) {
    try {
      return state.courseProgressList.firstWhere(
        (progress) => progress.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate average grade from course progress
  double calculateAverageGrade() {
    if (state.courseProgressList.isEmpty) return 0.0;

    final totalGrade = state.courseProgressList.fold<double>(
      0,
      (sum, progress) => sum + progress.currentGrade,
    );

    return totalGrade / state.courseProgressList.length;
  }

  /// Calculate overall completion from course progress
  double calculateOverallCompletion() {
    if (state.courseProgressList.isEmpty) return 0.0;

    final totalCompletion = state.courseProgressList.fold<double>(
      0,
      (sum, progress) => sum + progress.completionPercentage,
    );

    return totalCompletion / state.courseProgressList.length;
  }

  /// Get total assignments submitted
  int getTotalAssignmentsSubmitted() {
    return state.courseProgressList.fold<int>(
      0,
      (sum, progress) => sum + progress.assignmentsCompleted,
    );
  }

  /// Get total time spent across all courses
  Duration getTotalTimeSpent() {
    return state.courseProgressList.fold<Duration>(
      Duration.zero,
      (sum, progress) => sum + progress.timeSpent,
    );
  }

  /// Get number of completed courses
  int getCompletedCoursesCount() {
    return state.courseProgressList.where(
      (progress) => progress.completionPercentage >= 100,
    ).length;
  }
}

/// Provider for progress state
final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProgressNotifier(ref, apiClient);
});

/// Provider for overall progress
final overallProgressProvider = Provider<OverallProgress?>((ref) {
  final progressState = ref.watch(progressProvider);
  return progressState.overallProgress;
});

/// Provider for course progress list
final courseProgressListProvider = Provider<List<CourseProgress>>((ref) {
  final progressState = ref.watch(progressProvider);
  return progressState.courseProgressList;
});

/// Provider for checking if progress is loading
final progressLoadingProvider = Provider<bool>((ref) {
  final progressState = ref.watch(progressProvider);
  return progressState.isLoading;
});

/// Provider for progress error
final progressErrorProvider = Provider<String?>((ref) {
  final progressState = ref.watch(progressProvider);
  return progressState.error;
});

/// Provider for average grade
final averageGradeProvider = Provider<double>((ref) {
  final progressNotifier = ref.watch(progressProvider.notifier);
  return progressNotifier.calculateAverageGrade();
});

/// Provider for overall completion
final overallCompletionProvider = Provider<double>((ref) {
  final progressNotifier = ref.watch(progressProvider.notifier);
  return progressNotifier.calculateOverallCompletion();
});

/// Provider for total assignments submitted
final totalAssignmentsProvider = Provider<int>((ref) {
  final progressNotifier = ref.watch(progressProvider.notifier);
  return progressNotifier.getTotalAssignmentsSubmitted();
});

/// Provider for completed courses count
final completedCoursesCountProvider = Provider<int>((ref) {
  final progressNotifier = ref.watch(progressProvider.notifier);
  return progressNotifier.getCompletedCoursesCount();
});
