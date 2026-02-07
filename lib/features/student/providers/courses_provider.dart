import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/course_model.dart';
import '../../../core/services/courses_api_service.dart';
import '../../../core/constants/user_roles.dart';
import '../../../features/authentication/providers/auth_provider.dart';

/// State class for managing courses (student view)
class CoursesState {
  final List<Course> courses;
  final int total;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? filterInstitution;
  final String? filterCategory;
  final CourseLevel? filterLevel;
  final CourseType? filterType;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const CoursesState({
    this.courses = const [],
    this.total = 0,
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.filterInstitution,
    this.filterCategory,
    this.filterLevel,
    this.filterType,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasMore = false,
  });

  CoursesState copyWith({
    List<Course>? courses,
    int? total,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? filterInstitution,
    String? filterCategory,
    CourseLevel? filterLevel,
    CourseType? filterType,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterInstitution: filterInstitution ?? this.filterInstitution,
      filterCategory: filterCategory ?? this.filterCategory,
      filterLevel: filterLevel ?? this.filterLevel,
      filterType: filterType ?? this.filterType,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// StateNotifier for managing courses (student view)
class CoursesNotifier extends StateNotifier<CoursesState> {
  final Ref _ref;
  late final CoursesApiService _apiService;

  CoursesNotifier(this._ref) : super(const CoursesState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = CoursesApiService(accessToken: accessToken);
    fetchCourses();
  }

  /// Fetch courses with current filters
  Future<void> fetchCourses({bool loadMore = false}) async {
    if (state.isLoading) return;

    final page = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page,
    );

    try {
      final result = await _apiService.listCourses(
        page: page,
        pageSize: state.pageSize,
        institutionId: state.filterInstitution,
        status: 'published', // Students only see published courses
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

  /// Update category filter
  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(filterCategory: category);
    await fetchCourses();
  }

  /// Update level filter
  Future<void> filterByLevel(CourseLevel? level) async {
    state = state.copyWith(filterLevel: level);
    await fetchCourses();
  }

  /// Update type filter
  Future<void> filterByType(CourseType? type) async {
    state = state.copyWith(filterType: type);
    await fetchCourses();
  }

  /// Update institution filter
  Future<void> filterByInstitution(String? institutionId) async {
    state = state.copyWith(filterInstitution: institutionId);
    await fetchCourses();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = const CoursesState();
    await fetchCourses();
  }

  /// Refresh courses
  Future<void> refresh() async {
    await fetchCourses();
  }

  /// Get a single course by ID
  Future<Course?> getCourseById(String courseId) async {
    try {
      return await _apiService.getCourse(courseId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load course: ${e.toString()}',
      );
      return null;
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for courses list (student view)
final coursesProvider =
    StateNotifierProvider<CoursesNotifier, CoursesState>((ref) {
  return CoursesNotifier(ref);
});

/// Provider for single course detail
final courseDetailProvider =
    FutureProvider.family<Course, String>((ref, courseId) async {
  final accessToken = ref.read(authProvider).accessToken;
  final apiService = CoursesApiService(accessToken: accessToken);

  try {
    return await apiService.getCourse(courseId);
  } catch (e) {
    throw Exception('Failed to load course: $e');
  } finally {
    apiService.dispose();
  }
});

/// Provider for API service instance
final coursesApiServiceProvider = Provider<CoursesApiService>((ref) {
  final accessToken = ref.watch(authProvider).accessToken;
  return CoursesApiService(accessToken: accessToken);
});

/// State class for assigned courses
class AssignedCoursesState {
  final List<Map<String, dynamic>> courses;
  final bool isLoading;
  final String? error;

  const AssignedCoursesState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
  });

  AssignedCoursesState copyWith({
    List<Map<String, dynamic>>? courses,
    bool? isLoading,
    String? error,
  }) {
    return AssignedCoursesState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for assigned courses
class AssignedCoursesNotifier extends StateNotifier<AssignedCoursesState> {
  final Ref _ref;

  AssignedCoursesNotifier(this._ref) : super(const AssignedCoursesState()) {
    fetchAssignedCourses();
  }

  Future<void> fetchAssignedCourses() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Only fetch assigned courses for student users
      final authState = _ref.read(authProvider);
      final user = authState.user;
      if (user == null || user.activeRole != UserRole.student) {
        state = state.copyWith(
          courses: [],
          isLoading: false,
        );
        return;
      }

      final accessToken = authState.accessToken;
      final apiService = CoursesApiService(accessToken: accessToken);

      final result = await apiService.getAssignedCourses();

      state = state.copyWith(
        courses: result,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch assigned courses: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> refresh() async {
    await fetchAssignedCourses();
  }
}

/// Provider for assigned courses
final assignedCoursesProvider =
    StateNotifierProvider<AssignedCoursesNotifier, AssignedCoursesState>((ref) {
  return AssignedCoursesNotifier(ref);
});
