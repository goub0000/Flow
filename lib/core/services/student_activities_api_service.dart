import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/activity_models.dart';

/// Service for communicating with Student Activities API
class StudentActivitiesApiService {
  // API base URL - Railway production deployment
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  StudentActivitiesApiService({
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

  /// Get activity feed for the current student
  Future<StudentActivityFeedResponse> getMyActivities({
    StudentActivityFilterRequest? filters,
  }) async {
    try {
      filters ??= const StudentActivityFilterRequest();

      final queryParams = filters.toQueryParams();
      final uri = Uri.parse('$baseUrl/students/me/activities')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StudentActivityFeedResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Student access required');
      } else {
        throw Exception(
            'Failed to load activities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching activities: $e');
    }
  }

  /// Get activity feed for a specific student (parents/counselors)
  Future<StudentActivityFeedResponse> getStudentActivities({
    required String studentId,
    StudentActivityFilterRequest? filters,
  }) async {
    try {
      filters ??= const StudentActivityFilterRequest();

      final queryParams = filters.toQueryParams();
      final uri = Uri.parse('$baseUrl/students/$studentId/activities')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StudentActivityFeedResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception(
            'Forbidden: Not authorized to view this student\'s activities');
      } else if (response.statusCode == 404) {
        throw Exception('Student not found');
      } else {
        throw Exception(
            'Failed to load student activities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching student activities: $e');
    }
  }

  /// Load more activities (next page)
  Future<StudentActivityFeedResponse> loadMore({
    required int currentPage,
    int limit = 10,
    List<StudentActivityType>? activityTypes,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final filters = StudentActivityFilterRequest(
      page: currentPage + 1,
      limit: limit,
      activityTypes: activityTypes,
      startDate: startDate,
      endDate: endDate,
    );

    return getMyActivities(filters: filters);
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
