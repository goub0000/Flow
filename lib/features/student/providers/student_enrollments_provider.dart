import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/course_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
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
  final ApiClient _apiClient;

  EnrollmentsNotifier(this.ref, this._apiClient) : super(const EnrollmentsState()) {
    fetchEnrollments();
  }

  /// Fetch student enrollments from backend API
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

      final response = await _apiClient.get(
        '${ApiConfig.students}/me/enrollments',
        fromJson: (data) {
          if (data is List) {
            return data.map((enrollmentJson) => Enrollment.fromJson(enrollmentJson)).toList();
          }
          return <Enrollment>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          enrollments: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch enrollments',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch enrollments: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Enroll in a course via backend API
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

      final response = await _apiClient.post(
        ApiConfig.enrollments,
        data: {
          'course_id': courseId,
        },
        fromJson: (data) => Enrollment.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Add new enrollment to local state
        state = state.copyWith(
          enrollments: [...state.enrollments, response.data!],
          isEnrolling: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to enroll in course',
          isEnrolling: false,
        );
        return false;
      }
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
  final apiClient = ref.watch(apiClientProvider);
  return EnrollmentsNotifier(ref, apiClient);
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
