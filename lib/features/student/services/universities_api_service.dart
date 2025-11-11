import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/university_model.dart';

/// Service for communicating with Universities API
class UniversitiesApiService {
  // API base URL - Railway production deployment
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;

  UniversitiesApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Search/get universities with filters
  Future<Map<String, dynamic>> getUniversities({
    String? country,
    String? state,
    String? universityType,
    String? locationType,
    double? minAcceptanceRate,
    double? maxAcceptanceRate,
    double? maxTuition,
    String? search,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (country != null) queryParams['country'] = country;
      if (state != null) queryParams['state'] = state;
      if (universityType != null) queryParams['university_type'] = universityType;
      if (locationType != null) queryParams['location_type'] = locationType;
      if (minAcceptanceRate != null) queryParams['min_acceptance_rate'] = minAcceptanceRate.toString();
      if (maxAcceptanceRate != null) queryParams['max_acceptance_rate'] = maxAcceptanceRate.toString();
      if (maxTuition != null) queryParams['max_tuition'] = maxTuition.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      queryParams['skip'] = skip.toString();
      queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$baseUrl/universities').replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final universities = (json['universities'] as List)
            .map((u) => University.fromJson(u as Map<String, dynamic>))
            .toList();

        return {
          'total': json['total'] as int,
          'universities': universities,
        };
      } else {
        throw Exception('Failed to load universities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching universities: $e');
    }
  }

  /// Get a specific university by ID
  Future<University> getUniversity(int universityId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/universities/$universityId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return University.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('University not found');
      } else {
        throw Exception('Failed to load university: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching university: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
