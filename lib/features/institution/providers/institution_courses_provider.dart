import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/course_model.dart';
import '../../../core/services/courses_api_service.dart';
import '../../../features/authentication/providers/auth_provider.dart';

/// State class for managing institution courses
class InstitutionCoursesState {
  final List<Course> courses;
  final int total;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final CourseStatus? filterStatus;
  final String? filterCategory;
  final CourseLevel? filterLevel;
  final int currentPage;
  final int pageSize;
  final bool hasMore;
  final CourseStatistics? statistics;

  const InstitutionCoursesState({
    this.courses = const [],
    this.total = 0,
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.filterStatus,
    this.filterCategory,
    this.filterLevel,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasMore = false,
    this.statistics,
  });

  InstitutionCoursesState copyWith({
    List<Course>? courses,
    int? total,
    bool? isLoading,
    String? error,
    String? searchQuery,
    CourseStatus? filterStatus,
    bool clearFilterStatus = false,
    String? filterCategory,
    bool clearFilterCategory = false,
    CourseLevel? filterLevel,
    bool clearFilterLevel = false,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
    CourseStatistics? statistics,
  }) {
    return InstitutionCoursesState(
      courses: courses ?? this.courses,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterStatus: clearFilterStatus ? null : (filterStatus ?? this.filterStatus),
      filterCategory: clearFilterCategory ? null : (filterCategory ?? this.filterCategory),
      filterLevel: clearFilterLevel ? null : (filterLevel ?? this.filterLevel),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      statistics: statistics ?? this.statistics,
    );
  }
}

/// StateNotifier for managing institution courses
class InstitutionCoursesNotifier
    extends StateNotifier<InstitutionCoursesState> {
  final Ref _ref;
  late final CoursesApiService _apiService;

  InstitutionCoursesNotifier(this._ref)
      : super(const InstitutionCoursesState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CoursesApiService(accessToken: accessToken);
    fetchCourses();
    fetchStatistics();
  }

  /// Fetch institution's courses with current filters
  Future<void> fetchCourses({bool loadMore = false}) async {
    if (state.isLoading) return;

    final page = loadMore ? state.currentPage + 1 : 1;
    final user = _ref.read(authProvider).user;

    if (user == null) {
      state = state.copyWith(
        error: 'User not authenticated',
        isLoading: false,
      );
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page,
    );

    try {
      final result = await _apiService.listCourses(
        page: page,
        pageSize: state.pageSize,
        institutionId: user.id, // Show only this institution's courses
        status: state.filterStatus?.value,
        category: state.filterCategory,
        level: state.filterLevel?.value,
        search: state.searchQuery,
      );

      final newCourses = loadMore
          ? [...state.courses, ...result.courses]
          : result.courses;

      state = state.copyWith(
        courses: newCourses,
        total: result.total,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch courses: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch course statistics
  Future<void> fetchStatistics() async {
    try {
      final stats = await _apiService.getMyCourseStatistics();
      state = state.copyWith(statistics: stats);
    } catch (e) {
      // Don't update error state, just log silently
    }
  }

  /// Create a new course
  Future<Course?> createCourse(CourseRequest courseData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final course = await _apiService.createCourse(courseData);

      // Add to local state
      state = state.copyWith(
        courses: [course, ...state.courses],
        total: state.total + 1,
        isLoading: false,
      );

      // Refresh statistics
      await fetchStatistics();

      return course;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create course: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Update an existing course
  Future<Course?> updateCourse(
    String courseId,
    CourseRequest courseData,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedCourse =
          await _apiService.updateCourse(courseId, courseData);

      // Update in local state
      final updatedCourses = state.courses.map((c) {
        return c.id == courseId ? updatedCourse : c;
      }).toList();

      state = state.copyWith(
        courses: updatedCourses,
        isLoading: false,
      );

      return updatedCourse;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update course: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Delete a course (soft delete by archiving)
  Future<bool> deleteCourse(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.deleteCourse(courseId);

      // Remove from local state or update status
      final updatedCourses = state.courses.where((c) => c.id != courseId).toList();

      state = state.copyWith(
        courses: updatedCourses,
        total: state.total - 1,
        isLoading: false,
      );

      // Refresh statistics
      await fetchStatistics();

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete course: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Publish a course
  Future<Course?> publishCourse(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final publishedCourse = await _apiService.publishCourse(courseId);

      // Update in local state
      final updatedCourses = state.courses.map((c) {
        return c.id == courseId ? publishedCourse : c;
      }).toList();

      state = state.copyWith(
        courses: updatedCourses,
        isLoading: false,
      );

      // Refresh statistics
      await fetchStatistics();

      return publishedCourse;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to publish course: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Unpublish a course
  Future<Course?> unpublishCourse(String courseId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final unpublishedCourse = await _apiService.unpublishCourse(courseId);

      // Update in local state
      final updatedCourses = state.courses.map((c) {
        return c.id == courseId ? unpublishedCourse : c;
      }).toList();

      state = state.copyWith(
        courses: updatedCourses,
        isLoading: false,
      );

      // Refresh statistics
      await fetchStatistics();

      return unpublishedCourse;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to unpublish course: ${e.toString()}',
        isLoading: false,
      );
      return null;
    }
  }

  /// Load more courses (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchCourses(loadMore: true);
  }

  /// Update search query and refetch
  Future<void> search(String query) async {
    state = state.copyWith(searchQuery: query);
    await fetchCourses();
  }

  /// Clear search query
  Future<void> clearSearch() async {
    state = state.copyWith(searchQuery: null);
    await fetchCourses();
  }

  /// Update status filter
  Future<void> filterByStatus(CourseStatus? status) async {
    if (status == null) {
      state = state.copyWith(clearFilterStatus: true);
    } else {
      state = state.copyWith(filterStatus: status);
    }
    await fetchCourses();
  }

  /// Update category filter
  Future<void> filterByCategory(String? category) async {
    if (category == null) {
      state = state.copyWith(clearFilterCategory: true);
    } else {
      state = state.copyWith(filterCategory: category);
    }
    await fetchCourses();
  }

  /// Update level filter
  Future<void> filterByLevel(CourseLevel? level) async {
    if (level == null) {
      state = state.copyWith(clearFilterLevel: true);
    } else {
      state = state.copyWith(filterLevel: level);
    }
    await fetchCourses();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = const InstitutionCoursesState();
    await fetchCourses();
    await fetchStatistics();
  }

  /// Refresh courses and statistics
  Future<void> refresh() async {
    await Future.wait([
      fetchCourses(),
      fetchStatistics(),
    ]);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for institution courses management
final institutionCoursesProvider = StateNotifierProvider<
    InstitutionCoursesNotifier, InstitutionCoursesState>((ref) {
  return InstitutionCoursesNotifier(ref);
});
