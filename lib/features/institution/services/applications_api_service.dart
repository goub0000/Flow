import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/applicant_model.dart';

/// Service for communicating with Applications API
class ApplicationsApiService {
  // API base URL - Railway production deployment
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  ApplicationsApiService({
    http.Client? client,
    String? accessToken,
  })  : _client = client ?? http.Client(),
        _accessToken = accessToken;

  /// Get all applications for the current institution
  Future<List<Applicant>> getInstitutionApplications({
    int page = 1,
    int pageSize = 100,
    String? status,
    String? programId,
  }) async {
    try {
      final queryParams = <String, String>{};
      queryParams['page'] = page.toString();
      queryParams['page_size'] = pageSize.toString();
      if (status != null) queryParams['status'] = status;
      if (programId != null) queryParams['program_id'] = programId;

      final uri = Uri.parse('$baseUrl/institutions/me/applications')
          .replace(queryParameters: queryParams);

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (_accessToken != null) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      final response = await _client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final applications = (json['applications'] as List)
            .map((app) => _mapApplicationToApplicant(app as Map<String, dynamic>))
            .toList();
        return applications;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load applications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching applications: $e');
    }
  }

  /// Get application statistics for the institution
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final uri = Uri.parse('$baseUrl/institutions/me/applications/statistics');

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (_accessToken != null) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      final response = await _client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching statistics: $e');
    }
  }

  /// Update application status
  Future<Applicant> updateApplicationStatus(
    String applicationId,
    String newStatus, {
    String? reviewerNotes,
  }) async {
    try {
      final body = {
        'status': newStatus,
        if (reviewerNotes != null) 'reviewer_notes': reviewerNotes,
      };

      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (_accessToken != null) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      final response = await _client.put(
        Uri.parse('$baseUrl/applications/$applicationId/status'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return _mapApplicationToApplicant(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to update status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating status: $e');
    }
  }

  /// Get a specific application by ID
  Future<Applicant> getApplication(String applicationId) async {
    try {
      final headers = <String, String>{
        'Content-Type': 'application/json',
      };
      if (_accessToken != null) {
        headers['Authorization'] = 'Bearer $_accessToken';
      }

      final response = await _client.get(
        Uri.parse('$baseUrl/applications/$applicationId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return _mapApplicationToApplicant(json);
      } else if (response.statusCode == 404) {
        throw Exception('Application not found');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load application: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching application: $e');
    }
  }

  /// Map backend Application model to frontend Applicant model
  Applicant _mapApplicationToApplicant(Map<String, dynamic> app) {
    // Extract data from nested objects
    final personalInfo = app['personal_info'] as Map<String, dynamic>? ?? {};
    final academicInfo = app['academic_info'] as Map<String, dynamic>? ?? {};
    final documents = app['documents'] as List? ?? [];

    // Extract student information from personal_info
    final studentName = personalInfo['full_name'] as String? ??
        personalInfo['first_name'] as String? ??
        'Unknown Student';
    final studentEmail = personalInfo['email'] as String? ?? 'N/A';
    final studentPhone = personalInfo['phone'] as String? ?? 'N/A';

    // Extract academic information
    final gpa = (academicInfo['gpa'] as num?)?.toDouble() ?? 0.0;
    final previousSchool = academicInfo['previous_school'] as String? ??
        academicInfo['high_school'] as String? ??
        'N/A';
    final testScores = academicInfo['test_scores'] as Map<String, dynamic>?;

    // Map documents
    final mappedDocuments = documents
        .map((doc) {
          if (doc is Map<String, dynamic>) {
            return Document(
              id: doc['id'] as String? ?? '',
              name: doc['name'] as String? ?? 'Document',
              type: doc['type'] as String? ?? 'other',
              url: doc['url'] as String? ?? '',
              uploadedAt: doc['uploadedAt'] != null
                  ? DateTime.parse(doc['uploadedAt'] as String)
                  : DateTime.now(),
            );
          }
          return null;
        })
        .whereType<Document>()
        .toList();

    return Applicant(
      id: app['id'] as String,
      applicationId: app['id'] as String,
      studentId: app['student_id'] as String,
      studentName: studentName,
      studentEmail: studentEmail,
      studentPhone: studentPhone,
      programId: app['program_id'] as String? ?? '',
      programName: 'Program', // TODO: Fetch from programs API or include in backend
      status: app['status'] as String? ?? 'pending',
      submittedAt: app['submitted_at'] != null
          ? DateTime.parse(app['submitted_at'] as String)
          : DateTime.parse(app['created_at'] as String),
      appliedDate: app['created_at'] != null
          ? DateTime.parse(app['created_at'] as String)
          : DateTime.now(),
      reviewedAt: app['reviewed_at'] != null
          ? DateTime.parse(app['reviewed_at'] as String)
          : null,
      reviewedBy: app['reviewed_by'] as String?,
      reviewNotes: app['reviewer_notes'] as String?,
      gpa: gpa,
      previousSchool: previousSchool,
      documents: mappedDocuments,
      statementOfPurpose: app['essay'] as String? ?? '',
      testScores: testScores,
    );
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
