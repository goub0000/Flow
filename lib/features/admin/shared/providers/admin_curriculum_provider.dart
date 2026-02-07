import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Curriculum module model for admin management
class CurriculumModule {
  final String id;
  final String courseId;
  final String courseTitle;
  final String? courseStatus;
  final String title;
  final String? description;
  final int orderIndex;
  final int lessonCount;
  final int durationMinutes;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const CurriculumModule({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    this.courseStatus,
    required this.title,
    this.description,
    this.orderIndex = 0,
    this.lessonCount = 0,
    this.durationMinutes = 0,
    this.isPublished = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory CurriculumModule.fromJson(Map<String, dynamic> json) {
    return CurriculumModule(
      id: json['id'] as String? ?? '',
      courseId: json['course_id'] as String? ?? '',
      courseTitle: json['course_title'] as String? ?? 'Unknown Course',
      courseStatus: json['course_status'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      orderIndex: json['order_index'] as int? ?? 0,
      lessonCount: json['lesson_count'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }
}

/// Curriculum statistics model
class CurriculumStats {
  final int totalModules;
  final int publishedModules;
  final int draftModules;
  final int totalLessons;
  final int totalCoursesWithModules;

  const CurriculumStats({
    this.totalModules = 0,
    this.publishedModules = 0,
    this.draftModules = 0,
    this.totalLessons = 0,
    this.totalCoursesWithModules = 0,
  });

  factory CurriculumStats.fromJson(Map<String, dynamic> json) {
    return CurriculumStats(
      totalModules: json['total_modules'] as int? ?? 0,
      publishedModules: json['published_modules'] as int? ?? 0,
      draftModules: json['draft_modules'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
      totalCoursesWithModules: json['total_courses_with_modules'] as int? ?? 0,
    );
  }
}

/// State class for curriculum management
class AdminCurriculumState {
  final List<CurriculumModule> modules;
  final CurriculumStats stats;
  final bool isLoading;
  final String? error;

  const AdminCurriculumState({
    this.modules = const [],
    this.stats = const CurriculumStats(),
    this.isLoading = false,
    this.error,
  });

  AdminCurriculumState copyWith({
    List<CurriculumModule>? modules,
    CurriculumStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return AdminCurriculumState(
      modules: modules ?? this.modules,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for curriculum management
class AdminCurriculumNotifier extends StateNotifier<AdminCurriculumState> {
  final ApiClient _apiClient;

  AdminCurriculumNotifier(this._apiClient) : super(const AdminCurriculumState()) {
    fetchCurriculum();
  }

  /// Fetch all curriculum modules from backend API
  Future<void> fetchCurriculum({
    String? search,
    String? courseId,
    bool? isPublished,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (courseId != null && courseId.isNotEmpty) queryParams['course_id'] = courseId;
      if (isPublished != null) queryParams['is_published'] = isPublished.toString();

      final queryString = queryParams.isNotEmpty
          ? '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}'
          : '';

      final response = await _apiClient.get(
        '${ApiConfig.admin}/curriculum$queryString',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final modulesData = response.data!['modules'] as List<dynamic>? ?? [];
        final statsData = response.data!['stats'] as Map<String, dynamic>? ?? {};

        final modulesList = modulesData
            .map((item) => CurriculumModule.fromJson(item as Map<String, dynamic>))
            .toList();

        final stats = CurriculumStats.fromJson(statsData);

        state = state.copyWith(
          modules: modulesList,
          stats: stats,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch curriculum',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch curriculum: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new module in a course
  Future<bool> createModule({
    required String courseId,
    required String title,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/curriculum',
        data: {
          'course_id': courseId,
          'title': title,
          'description': description,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success) {
        await fetchCurriculum();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to create module',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create module: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider for admin curriculum state
final adminCurriculumProvider =
    StateNotifierProvider<AdminCurriculumNotifier, AdminCurriculumState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminCurriculumNotifier(apiClient);
});

/// Provider for curriculum statistics
final adminCurriculumStatsProvider = Provider<CurriculumStats>((ref) {
  final curriculumState = ref.watch(adminCurriculumProvider);
  return curriculumState.stats;
});
