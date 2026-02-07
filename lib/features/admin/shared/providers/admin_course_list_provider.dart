import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Lightweight course item for dropdown selectors
class CourseListItem {
  final String id;
  final String title;
  final String? status;

  const CourseListItem({
    required this.id,
    required this.title,
    this.status,
  });

  factory CourseListItem.fromJson(Map<String, dynamic> json) {
    return CourseListItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String?,
    );
  }
}

/// Lightweight module item for dropdown selectors
class ModuleListItem {
  final String id;
  final String title;
  final int orderIndex;

  const ModuleListItem({
    required this.id,
    required this.title,
    this.orderIndex = 0,
  });

  factory ModuleListItem.fromJson(Map<String, dynamic> json) {
    return ModuleListItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
    );
  }
}

/// State for course list
class AdminCourseListState {
  final List<CourseListItem> courses;
  final bool isLoading;
  final String? error;

  const AdminCourseListState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
  });

  AdminCourseListState copyWith({
    List<CourseListItem>? courses,
    bool? isLoading,
    String? error,
  }) {
    return AdminCourseListState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for course list
class AdminCourseListNotifier extends StateNotifier<AdminCourseListState> {
  final ApiClient _apiClient;

  AdminCourseListNotifier(this._apiClient) : super(const AdminCourseListState()) {
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/courses/list',
        fromJson: (data) => data as Map<String, dynamic>,
      );
      if (response.success && response.data != null) {
        final coursesData = response.data!['courses'] as List<dynamic>? ?? [];
        final courses = coursesData
            .map((c) => CourseListItem.fromJson(c as Map<String, dynamic>))
            .toList();
        state = state.copyWith(courses: courses, isLoading: false);
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

  /// Fetch modules for a specific course
  Future<List<ModuleListItem>> fetchModules(String courseId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/courses/$courseId/modules/list',
        fromJson: (data) => data as Map<String, dynamic>,
      );
      if (response.success && response.data != null) {
        final modulesData = response.data!['modules'] as List<dynamic>? ?? [];
        return modulesData
            .map((m) => ModuleListItem.fromJson(m as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

/// Provider for admin course list (for dropdowns)
final adminCourseListProvider =
    StateNotifierProvider<AdminCourseListNotifier, AdminCourseListState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminCourseListNotifier(apiClient);
});
