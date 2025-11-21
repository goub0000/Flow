import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/enrollment_model.dart';

/// Service for communicating with Enrollments API
/// Handles course enrollment operations
class EnrollmentsApiService {
  // API base URL - Railway production deployment
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  EnrollmentsApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  /// Build headers with authentication
  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // ==================== Enrollment Operations ====================

  /// Enroll in a course (Student only)
  Future<Enrollment> enrollInCourse(String courseId) async {
    try {
      final request = EnrollmentCreateRequest(courseId: courseId);

      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments'),
        headers: _buildHeaders(),
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Enrollment.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Student authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Enrollment error: ${error['detail']}');
      } else {
        throw Exception('Failed to enroll: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error enrolling in course: $e');
    }
  }

  /// Get enrollment by ID
  Future<Enrollment> getEnrollment(String enrollmentId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/enrollments/$enrollmentId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Enrollment.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Enrollment not found');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Not authorized to view this enrollment');
      } else {
        throw Exception('Failed to load enrollment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching enrollment: $e');
    }
  }

  /// Drop enrollment (unenroll from course)
  Future<Enrollment> dropEnrollment(String enrollmentId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/$enrollmentId/drop'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Enrollment.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Student authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Drop error: ${error['detail']}');
      } else {
        throw Exception('Failed to drop enrollment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error dropping enrollment: $e');
    }
  }

  /// Update enrollment progress
  Future<Enrollment> updateProgress(
    String enrollmentId,
    double progressPercentage,
  ) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/enrollments/$enrollmentId/progress'),
        headers: _buildHeaders(),
        body: jsonEncode({'progress_percentage': progressPercentage}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Enrollment.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Student authentication required');
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception('Update error: ${error['detail']}');
      } else {
        throw Exception(
            'Failed to update progress: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating progress: $e');
    }
  }

  /// Get current student's enrollments
  Future<EnrollmentListResponse> getMyEnrollments({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse('$baseUrl/students/me/enrollments')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return EnrollmentListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Student authentication required');
      } else {
        throw Exception(
            'Failed to load enrollments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching enrollments: $e');
    }
  }

  /// Get enrollments for a specific course
  Future<EnrollmentListResponse> getCourseEnrollments(
    String courseId, {
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse('$baseUrl/courses/$courseId/enrollments')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return EnrollmentListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in');
      } else {
        throw Exception(
            'Failed to load course enrollments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching course enrollments: $e');
    }
  }

  /// Check if student is enrolled in a course
  Future<bool> isEnrolledInCourse(String courseId) async {
    try {
      final response = await getMyEnrollments();
      return response.enrollments
          .any((enrollment) => enrollment.courseId == courseId && enrollment.isActive);
    } catch (e) {
      // If error fetching enrollments, assume not enrolled
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
