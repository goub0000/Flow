import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/enrollment_model.dart';
import '../../../core/services/enrollments_api_service.dart';
import '../../../features/authentication/providers/auth_provider.dart';

/// State class for managing student enrollments
class EnrollmentsState {
  final List<Enrollment> enrollments;
  final int total;
  final bool isLoading;
  final String? error;
  final EnrollmentStatus? filterStatus;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const EnrollmentsState({
    this.enrollments = const [],
    this.total = 0,
    this.isLoading = false,
    this.error,
    this.filterStatus,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasMore = false,
  });

  EnrollmentsState copyWith({
    List<Enrollment>? enrollments,
    int? total,
    bool? isLoading,
    String? error,
    EnrollmentStatus? filterStatus,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
  }) {
    return EnrollmentsState(
      enrollments: enrollments ?? this.enrollments,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterStatus: filterStatus ?? this.filterStatus,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// StateNotifier for managing student enrollments
class EnrollmentsNotifier extends StateNotifier<EnrollmentsState> {
  final Ref _ref;
  late final EnrollmentsApiService _apiService;

  EnrollmentsNotifier(this._ref) : super(const EnrollmentsState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = EnrollmentsApiService(accessToken: accessToken);
    fetchEnrollments();
  }

  /// Fetch enrollments with current filters
  Future<void> fetchEnrollments({bool loadMore = false}) async {
    if (state.isLoading) return;

    final page = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page,
    );

    try {
      final result = await _apiService.getMyEnrollments(
        page: page,
        pageSize: state.pageSize,
        status: state.filterStatus?.value,
      );

      final newEnrollments = loadMore
          ? [...state.enrollments, ...result.enrollments]
          : result.enrollments;

      state = state.copyWith(
        enrollments: newEnrollments,
        total: result.total,
        hasMore: result.hasMore,
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
  Future<Enrollment?> enrollInCourse(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final enrollment = await _apiService.enrollInCourse(courseId);

      // Add to local state
      state = state.copyWith(
        enrollments: [enrollment, ...state.enrollments],
        total: state.total + 1,
        isLoading: false,
      );

      return enrollment;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to enroll: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Drop enrollment (unenroll from course)
  Future<bool> dropEnrollment(String enrollmentId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedEnrollment = await _apiService.dropEnrollment(enrollmentId);

      // Update in local state
      final updatedEnrollments = state.enrollments.map((e) {
        return e.id == enrollmentId ? updatedEnrollment : e;
      }).toList();

      state = state.copyWith(
        enrollments: updatedEnrollments,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to drop enrollment: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Update progress for an enrollment
  Future<bool> updateProgress(String enrollmentId, double progress) async {
    try {
      final updatedEnrollment =
          await _apiService.updateProgress(enrollmentId, progress);

      // Update in local state
      final updatedEnrollments = state.enrollments.map((e) {
        return e.id == enrollmentId ? updatedEnrollment : e;
      }).toList();

      state = state.copyWith(enrollments: updatedEnrollments);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update progress: ${e.toString()}',
      );
      return false;
    }
  }

  /// Check if enrolled in a specific course
  bool isEnrolledInCourse(String courseId) {
    return state.enrollments
        .any((e) => e.courseId == courseId && e.isActive);
  }

  /// Get enrollment for a specific course
  Enrollment? getEnrollmentForCourse(String courseId) {
    try {
      return state.enrollments.firstWhere(
        (e) => e.courseId == courseId && e.isActive,
      );
    } catch (e) {
      return null;
    }
  }

  /// Load more enrollments (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchEnrollments(loadMore: true);
  }

  /// Filter by status
  Future<void> filterByStatus(EnrollmentStatus? status) async {
    state = state.copyWith(filterStatus: status);
    await fetchEnrollments();
  }

  /// Refresh enrollments
  Future<void> refresh() async {
    await fetchEnrollments();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for student enrollments
final enrollmentsProvider =
    StateNotifierProvider<EnrollmentsNotifier, EnrollmentsState>((ref) {
  return EnrollmentsNotifier(ref);
});

/// Provider for checking if enrolled in a specific course
final isEnrolledProvider =
    FutureProvider.family<bool, String>((ref, courseId) async {
  final accessToken = ref.read(authProvider).accessToken;
  final apiService = EnrollmentsApiService(accessToken: accessToken);

  try {
    return await apiService.isEnrolledInCourse(courseId);
  } catch (e) {
    return false;
  } finally {
    apiService.dispose();
  }
});

/// Provider for API service instance
final enrollmentsApiServiceProvider = Provider<EnrollmentsApiService>((ref) {
  final accessToken = ref.watch(authProvider).accessToken;
  return EnrollmentsApiService(accessToken: accessToken);
});
