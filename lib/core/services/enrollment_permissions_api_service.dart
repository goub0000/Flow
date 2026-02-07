import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for enrollment permissions API
class EnrollmentPermissionsApiService {
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  EnrollmentPermissionsApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }
    return headers;
  }

  // ==================== Student Operations ====================

  /// Student requests enrollment permission
  Future<Map<String, dynamic>> requestPermission(
    String courseId, {
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/request-permission'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'course_id': courseId,
          if (notes != null) 'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to request permission');
      } else {
        throw Exception('Failed to request permission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting permission: $e');
    }
  }

  /// Get student's enrollment permissions
  Future<Map<String, dynamic>> getMyPermissions() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/students/me/enrollment-permissions'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load permissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching permissions: $e');
    }
  }

  /// Check permission status for a course
  Future<Map<String, dynamic>?> getPermissionForCourse(String courseId) async {
    try {
      final result = await getMyPermissions();
      final permissions = result['permissions'] as List?;

      if (permissions != null) {
        for (var permission in permissions) {
          if (permission['course_id'] == courseId) {
            return permission as Map<String, dynamic>;
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== Institution Operations ====================

  /// Institution grants permission to student
  Future<Map<String, dynamic>> grantPermission(
    String studentId,
    String courseId, {
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/grant-permission'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'student_id': studentId,
          'course_id': courseId,
          if (notes != null) 'notes': notes,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to grant permission');
      } else {
        throw Exception('Failed to grant permission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error granting permission: $e');
    }
  }

  /// Approve permission request
  Future<Map<String, dynamic>> approvePermission(
    String permissionId, {
    String? notes,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/permissions/$permissionId/approve'),
        headers: _buildHeaders(),
        body: jsonEncode({
          if (notes != null) 'notes': notes,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final errorBody = response.body;
        throw Exception('Failed to approve permission: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      throw Exception('Error approving permission: $e');
    }
  }

  /// Deny permission request
  Future<Map<String, dynamic>> denyPermission(
    String permissionId,
    String denialReason,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/permissions/$permissionId/deny'),
        headers: _buildHeaders(),
        body: jsonEncode({
          'denial_reason': denialReason,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        final errorBody = response.body;
        throw Exception('Failed to deny permission: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      throw Exception('Error denying permission: $e');
    }
  }

  /// Revoke permission
  Future<Map<String, dynamic>> revokePermission(
    String permissionId, {
    String? reason,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/enrollments/permissions/$permissionId/revoke'),
        headers: _buildHeaders(),
        body: jsonEncode({
          if (reason != null) 'reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to revoke permission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error revoking permission: $e');
    }
  }

  /// Get permission requests for a course
  Future<Map<String, dynamic>> getCoursePermissions(
    String courseId, {
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      final uri = Uri.parse('$baseUrl/courses/$courseId/permissions')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load permissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching course permissions: $e');
    }
  }

  /// Get admitted students for institution (with permission status for a course)
  Future<Map<String, dynamic>> getAdmittedStudents({
    String? courseId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (courseId != null) {
        queryParams['course_id'] = courseId;
      }

      final uri = Uri.parse('$baseUrl/institutions/me/admitted-students')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load admitted students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching admitted students: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
