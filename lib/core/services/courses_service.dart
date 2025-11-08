/// Courses Service
/// Handles course-related API calls

import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';
import '../models/course_model.dart';

class CoursesService {
  final ApiClient _apiClient;

  CoursesService(this._apiClient);

  /// Get all courses with optional filters
  Future<ApiResponse<PaginatedResponse<Course>>> getCourses({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? level,
    String? category,
    String? institutionId,
    bool? isOnline,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (search != null) 'search': search,
      if (level != null) 'level': level,
      if (category != null) 'category': category,
      if (institutionId != null) 'institution_id': institutionId,
      if (isOnline != null) 'is_online': isOnline,
      if (isActive != null) 'is_active': isActive,
    };

    return await _apiClient.get(
      ApiConfig.courses,
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Course.fromJson(json),
      ),
    );
  }

  /// Get course by ID
  Future<ApiResponse<Course>> getCourseById(String courseId) async {
    return await _apiClient.get(
      '${ApiConfig.courses}/$courseId',
      fromJson: (data) => Course.fromJson(data),
    );
  }

  /// Create new course (Institution only)
  Future<ApiResponse<Course>> createCourse({
    required String title,
    required String description,
    required String level,
    required String category,
    required int duration,
    double? fee,
    String currency = 'USD',
    List<String> prerequisites = const [],
    required DateTime startDate,
    DateTime? endDate,
    int maxStudents = 100,
    bool isOnline = false,
  }) async {
    return await _apiClient.post(
      ApiConfig.courses,
      data: {
        'title': title,
        'description': description,
        'level': level,
        'category': category,
        'duration': duration,
        if (fee != null) 'fee': fee,
        'currency': currency,
        'prerequisites': prerequisites,
        'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        'max_students': maxStudents,
        'is_online': isOnline,
      },
      fromJson: (data) => Course.fromJson(data),
    );
  }

  /// Update course
  Future<ApiResponse<Course>> updateCourse({
    required String courseId,
    String? title,
    String? description,
    String? level,
    String? category,
    int? duration,
    double? fee,
    String? currency,
    List<String>? prerequisites,
    DateTime? startDate,
    DateTime? endDate,
    int? maxStudents,
    bool? isOnline,
    bool? isActive,
  }) async {
    return await _apiClient.patch(
      '${ApiConfig.courses}/$courseId',
      data: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (level != null) 'level': level,
        if (category != null) 'category': category,
        if (duration != null) 'duration': duration,
        if (fee != null) 'fee': fee,
        if (currency != null) 'currency': currency,
        if (prerequisites != null) 'prerequisites': prerequisites,
        if (startDate != null) 'start_date': startDate.toIso8601String(),
        if (endDate != null) 'end_date': endDate.toIso8601String(),
        if (maxStudents != null) 'max_students': maxStudents,
        if (isOnline != null) 'is_online': isOnline,
        if (isActive != null) 'is_active': isActive,
      },
      fromJson: (data) => Course.fromJson(data),
    );
  }

  /// Delete course
  Future<ApiResponse<void>> deleteCourse(String courseId) async {
    return await _apiClient.delete('${ApiConfig.courses}/$courseId');
  }

  /// Get course statistics (Institution only)
  Future<ApiResponse<Map<String, dynamic>>> getCourseStats(String courseId) async {
    return await _apiClient.get(
      '${ApiConfig.courses}/$courseId/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Get enrolled students in course (Institution/Counselor)
  Future<ApiResponse<PaginatedResponse<Map<String, dynamic>>>> getEnrolledStudents({
    required String courseId,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _apiClient.get(
      '${ApiConfig.courses}/$courseId/students',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => json,
      ),
    );
  }

  /// Get recommended courses for student
  Future<ApiResponse<List<Course>>> getRecommendedCourses() async {
    return await _apiClient.get(
      '${ApiConfig.courses}/recommended',
      fromJson: (data) {
        final List<dynamic> list = data;
        return list.map((json) => Course.fromJson(json)).toList();
      },
    );
  }

  /// Search courses
  Future<ApiResponse<PaginatedResponse<Course>>> searchCourses({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await _apiClient.get(
      '${ApiConfig.courses}/search',
      queryParameters: {
        'q': query,
        'page': page,
        'page_size': pageSize,
      },
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Course.fromJson(json),
      ),
    );
  }
}
