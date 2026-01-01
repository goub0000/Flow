import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course_model.dart';

/// Service for communicating with Courses API
/// Handles course management and enrollment
class CoursesApiService {
  // API base URL - Railway production deployment
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  CoursesApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  /// Build headers with optional authentication
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // ==================== Course Management ====================

  /// List courses with filters and pagination
  ///
  /// Optional filters:
  /// - page: Page number (default: 1)
  /// - pageSize: Items per page (default: 20, max: 100)
  /// - institutionId: Filter by institution
  /// - status: Filter by status (draft, published, archived)
  /// - category: Filter by category
  /// - level: Filter by level (beginner, intermediate, advanced, expert)
  /// - search: Search in course titles
  Future<CourseListResponse> listCourses({
    int page = 1,
    int pageSize = 20,
    String? institutionId,
    String? status,
    String? category,
    String? level,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (institutionId != null) queryParams['institution_id'] = institutionId;
      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;
      if (level != null) queryParams['level'] = level;
      if (search != null) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/courses')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  /// Get course by ID
  Future<Course> getCourse(String courseId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/$courseId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Course.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Course not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching course: $e');
    }
  }

  /// Create a new course (Institution only)
  /// Requires authentication with institution role
  Future<Course> createCourse(CourseRequest courseData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/courses'),
        headers: _buildHeaders(),
        body: jsonEncode(courseData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Course.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Validation error: ${error['detail']}');
      } else {
        throw Exception('Failed to create course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  /// Update an existing course (Institution only)
  /// Requires authentication and ownership
  Future<Course> updateCourse(
    String courseId,
    CourseRequest courseData,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/courses/$courseId'),
        headers: _buildHeaders(),
        body: jsonEncode(courseData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Course.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception('Failed to update course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  /// Delete course (Institution only)
  /// Soft delete by archiving
  Future<void> deleteCourse(String courseId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/courses/$courseId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Delete error: ${error['detail']}');
      } else {
        throw Exception('Failed to delete course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }

  /// Publish a course (Institution only)
  Future<Course> publishCourse(String courseId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/courses/$courseId/publish'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Course.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Publish error: ${error['detail']}');
      } else {
        throw Exception('Failed to publish course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error publishing course: $e');
    }
  }

  /// Unpublish a course (Institution only)
  Future<Course> unpublishCourse(String courseId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/courses/$courseId/unpublish'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Course.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Unpublish error: ${error['detail']}');
      } else {
        throw Exception('Failed to unpublish course: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error unpublishing course: $e');
    }
  }

  /// Get course statistics for current institution (Institution only)
  Future<CourseStatistics> getMyCourseStatistics() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/statistics/my-courses'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseStatistics.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Institution authentication required');
      } else {
        throw Exception(
            'Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching statistics: $e');
    }
  }

  /// Get all courses for a specific institution
  Future<CourseListResponse> getInstitutionCourses(
    String institutionId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final uri = Uri.parse('$baseUrl/institutions/$institutionId/courses')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CourseListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception(
            'Failed to load institution courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching institution courses: $e');
    }
  }

  /// Get courses assigned to the current student
  Future<List<Map<String, dynamic>>> getAssignedCourses() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/courses/my-assignments'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final courses = json['courses'] as List<dynamic>? ?? [];
        return courses.map((c) => c as Map<String, dynamic>).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception(
            'Failed to load assigned courses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching assigned courses: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
