import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/progress_model.dart';
import '../../authentication/providers/auth_provider.dart';

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

  ProgressNotifier(this.ref) : super(const ProgressState()) {
    fetchProgress();
  }

  /// Fetch student progress data
  /// TODO: Connect to backend API (Firebase Firestore)
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

      // TODO: Replace with actual Firebase query
      // Example:
      // - Fetch overall progress: FirebaseFirestore.instance.collection('progress').doc(user.id).get()
      // - Fetch course progress: FirebaseFirestore.instance.collection('courseProgress')
      //     .where('studentId', isEqualTo: user.id).get()

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, return empty/default data since mock data is removed
      // Backend should provide actual progress data
      state = state.copyWith(
        overallProgress: null,
        courseProgressList: [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch progress: ${e.toString()}',
        isLoading: false,
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
  return ProgressNotifier(ref);
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
