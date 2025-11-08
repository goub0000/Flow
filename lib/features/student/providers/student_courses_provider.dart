import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/course_model.dart';

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
  CoursesNotifier() : super(const CoursesState()) {
    fetchCourses();
  }

  /// Fetch all available courses
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance.collection('courses').where('isActive', isEqualTo: true).get()

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, return empty list since mock data is removed
      // Backend should provide actual course data
      state = state.copyWith(
        courses: [],
        isLoading: false,
      );
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
  return CoursesNotifier();
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
