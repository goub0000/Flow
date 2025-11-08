import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/course_model.dart';
import '../../authentication/providers/auth_provider.dart';

/// State class for managing enrollments
class EnrollmentsState {
  final List<Enrollment> enrollments;
  final bool isLoading;
  final String? error;
  final bool isEnrolling;

  const EnrollmentsState({
    this.enrollments = const [],
    this.isLoading = false,
    this.error,
    this.isEnrolling = false,
  });

  EnrollmentsState copyWith({
    List<Enrollment>? enrollments,
    bool? isLoading,
    String? error,
    bool? isEnrolling,
  }) {
    return EnrollmentsState(
      enrollments: enrollments ?? this.enrollments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isEnrolling: isEnrolling ?? this.isEnrolling,
    );
  }
}

/// StateNotifier for managing enrollments
class EnrollmentsNotifier extends StateNotifier<EnrollmentsState> {
  final Ref ref;
  final Uuid _uuid = const Uuid();

  EnrollmentsNotifier(this.ref) : super(const EnrollmentsState()) {
    fetchEnrollments();
  }

  /// Fetch student enrollments
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchEnrollments() async {
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
      // Example: FirebaseFirestore.instance.collection('enrollments')
      //   .where('studentId', isEqualTo: user.id).get()

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, return empty list since mock data is removed
      // Backend should provide actual enrollment data
      state = state.copyWith(
        enrollments: [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch enrollments: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Enroll in a course
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> enrollInCourse(String courseId, Course? course) async {
    state = state.copyWith(isEnrolling: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isEnrolling: false,
        );
        return false;
      }

      // Check if already enrolled
      final alreadyEnrolled = state.enrollments.any(
        (enrollment) => enrollment.courseId == courseId,
      );

      if (alreadyEnrolled) {
        state = state.copyWith(
          error: 'Already enrolled in this course',
          isEnrolling: false,
        );
        return false;
      }

      final enrollment = Enrollment(
        id: _uuid.v4(),
        studentId: user.id,
        courseId: courseId,
        course: course,
        enrolledAt: DateTime.now(),
        status: 'active',
        progress: 0,
      );

      // TODO: Replace with actual Firebase write
      // Example: await FirebaseFirestore.instance.collection('enrollments').add(enrollment.toJson())
      // Also update course enrolledStudents count

      // Simulating API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Add to local state
      state = state.copyWith(
        enrollments: [...state.enrollments, enrollment],
        isEnrolling: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to enroll in course: ${e.toString()}',
        isEnrolling: false,
      );
      return false;
    }
  }

  /// Check if enrolled in a course
  bool isEnrolledInCourse(String courseId) {
    return state.enrollments.any(
      (enrollment) => enrollment.courseId == courseId && enrollment.status == 'active',
    );
  }

  /// Get enrollment for a course
  Enrollment? getEnrollmentForCourse(String courseId) {
    try {
      return state.enrollments.firstWhere(
        (enrollment) => enrollment.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get active enrollments
  List<Enrollment> getActiveEnrollments() {
    return state.enrollments.where(
      (enrollment) => enrollment.status == 'active',
    ).toList();
  }

  /// Get completed enrollments
  List<Enrollment> getCompletedEnrollments() {
    return state.enrollments.where(
      (enrollment) => enrollment.status == 'completed',
    ).toList();
  }
}

/// Provider for enrollments state
final enrollmentsProvider = StateNotifierProvider<EnrollmentsNotifier, EnrollmentsState>((ref) {
  return EnrollmentsNotifier(ref);
});

/// Provider for enrollments list
final enrollmentsListProvider = Provider<List<Enrollment>>((ref) {
  final enrollmentsState = ref.watch(enrollmentsProvider);
  return enrollmentsState.enrollments;
});

/// Provider for active enrollments
final activeEnrollmentsProvider = Provider<List<Enrollment>>((ref) {
  final notifier = ref.watch(enrollmentsProvider.notifier);
  return notifier.getActiveEnrollments();
});

/// Provider for completed enrollments
final completedEnrollmentsProvider = Provider<List<Enrollment>>((ref) {
  final notifier = ref.watch(enrollmentsProvider.notifier);
  return notifier.getCompletedEnrollments();
});

/// Provider for checking if enrollments are loading
final enrollmentsLoadingProvider = Provider<bool>((ref) {
  final enrollmentsState = ref.watch(enrollmentsProvider);
  return enrollmentsState.isLoading;
});

/// Provider for checking if enrolling
final isEnrollingProvider = Provider<bool>((ref) {
  final enrollmentsState = ref.watch(enrollmentsProvider);
  return enrollmentsState.isEnrolling;
});

/// Provider for enrollments error
final enrollmentsErrorProvider = Provider<String?>((ref) {
  final enrollmentsState = ref.watch(enrollmentsProvider);
  return enrollmentsState.error;
});
