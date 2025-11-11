import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/course_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing courses list
class CoursesState {
  final List<Course> courses;
  final bool isLoading;
  final String? error;

  const CoursesState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
  });

  CoursesState copyWith({
    List<Course>? courses,
    bool? isLoading,
    String? error,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing courses
class CoursesNotifier extends StateNotifier<CoursesState> {
  final ApiClient _apiClient;

  CoursesNotifier(this._apiClient) : super(const CoursesState()) {
    fetchCourses();
  }

  /// Fetch all available courses from backend API
  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        ApiConfig.courses,
        queryParameters: {
          'is_published': true,  // Only fetch published courses
        },
        fromJson: (data) {
          if (data is List) {
            return data.map((courseJson) => Course.fromJson(courseJson)).toList();
          }
          return <Course>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          courses: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch courses',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch courses: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Search courses by title or institution
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return state.courses;

    final lowerQuery = query.toLowerCase();
    return state.courses.where((course) {
      return course.title.toLowerCase().contains(lowerQuery) ||
          course.institutionName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter courses by category
  List<Course> filterByCategory(String category) {
    if (category == 'All') return state.courses;

    return state.courses.where((course) {
      return course.category == category;
    }).toList();
  }

  /// Get course by ID
  Course? getCourseById(String id) {
    try {
      return state.courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Provider for courses state
final coursesProvider = StateNotifierProvider<CoursesNotifier, CoursesState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CoursesNotifier(apiClient);
});

/// Provider for available courses list
final availableCoursesProvider = Provider<List<Course>>((ref) {
  final coursesState = ref.watch(coursesProvider);
  return coursesState.courses;
});

/// Provider for checking if courses are loading
final coursesLoadingProvider = Provider<bool>((ref) {
  final coursesState = ref.watch(coursesProvider);
  return coursesState.isLoading;
});

/// Provider for courses error
final coursesErrorProvider = Provider<String?>((ref) {
  final coursesState = ref.watch(coursesProvider);
  return coursesState.error;
});
