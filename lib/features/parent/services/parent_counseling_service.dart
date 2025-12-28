import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/counseling/models/counseling_models.dart';

/// Service for parent access to children's counseling data
class ParentCounselingService {
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _authToken;

  ParentCounselingService({
    http.Client? client,
    String? authToken,
  })  : _client = client ?? http.Client(),
        _authToken = authToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  /// Get child's assigned counselor
  Future<CounselorInfo?> getChildCounselor(String childId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/counseling/children/$childId/counselor'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json == null) return null;
        return CounselorInfo.fromJson(json as Map<String, dynamic>);
      } else if (response.statusCode == 403 || response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get child counselor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching child counselor: $e');
    }
  }

  /// Get child's counseling sessions
  Future<({List<CounselingSession> sessions, int total, bool hasMore})> getChildSessions({
    required String childId,
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null) queryParams['status'] = status;

      final uri = Uri.parse('$baseUrl/counseling/children/$childId/sessions')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final sessions = (json['sessions'] as List<dynamic>?)
                ?.map((s) => CounselingSession.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [];
        return (
          sessions: sessions,
          total: json['total'] as int? ?? 0,
          hasMore: json['has_more'] as bool? ?? false,
        );
      } else if (response.statusCode == 403) {
        throw Exception('Not authorized to view this child\'s sessions');
      } else {
        throw Exception('Failed to get child sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching child sessions: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
