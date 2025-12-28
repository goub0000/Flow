import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/counseling/models/counseling_models.dart';

/// Service for institution counselor management API calls
class InstitutionCounselorsService {
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _authToken;

  InstitutionCounselorsService({
    http.Client? client,
    String? authToken,
  })  : _client = client ?? http.Client(),
        _authToken = authToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  /// Get list of counselors in institution
  Future<({List<InstitutionCounselor> counselors, int total, int totalPages})>
      getCounselors({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/counseling/institution/counselors')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final counselors = (json['counselors'] as List<dynamic>?)
                ?.map((c) => InstitutionCounselor.fromJson(c as Map<String, dynamic>))
                .toList() ??
            [];
        return (
          counselors: counselors,
          total: json['total'] as int? ?? 0,
          totalPages: json['total_pages'] as int? ?? 1,
        );
      } else {
        throw Exception('Failed to get counselors: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching counselors: $e');
    }
  }

  /// Assign a counselor to a student
  Future<void> assignCounselorToStudent({
    required String counselorId,
    required String studentId,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/counseling/assign'),
        headers: _headers,
        body: jsonEncode({
          'counselor_id': counselorId,
          'student_id': studentId,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to assign counselor');
      }
    } catch (e) {
      throw Exception('Error assigning counselor: $e');
    }
  }

  /// Get institution counseling statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/counseling/institution/stats'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }

  /// Get list of students for assignment
  Future<({List<Map<String, dynamic>> students, int total})> getStudents({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/counseling/students')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final students = (json['students'] as List<dynamic>?)
                ?.map((s) => s as Map<String, dynamic>)
                .toList() ??
            [];
        return (
          students: students,
          total: json['total'] as int? ?? 0,
        );
      } else {
        throw Exception('Failed to get students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
