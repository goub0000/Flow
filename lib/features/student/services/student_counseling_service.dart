import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../shared/counseling/models/counseling_models.dart';

/// Service for student counseling API calls
class StudentCounselingService {
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _authToken;

  StudentCounselingService({
    http.Client? client,
    String? authToken,
  })  : _client = client ?? http.Client(),
        _authToken = authToken;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_authToken != null) 'Authorization': 'Bearer $_authToken',
      };

  /// Get assigned counselor for current student
  Future<CounselorInfo?> getAssignedCounselor() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/counseling/my-counselor'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json == null) return null;
        return CounselorInfo.fromJson(json as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get counselor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching counselor: $e');
    }
  }

  /// Get available booking slots for a counselor
  Future<List<BookingSlot>> getAvailableSlots({
    required String counselorId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final queryParams = {
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      };

      final uri = Uri.parse('$baseUrl/counseling/available-slots/$counselorId')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final slots = (json['slots'] as List<dynamic>?)
                ?.map((s) => BookingSlot.fromJson(s as Map<String, dynamic>))
                .toList() ??
            [];
        return slots;
      } else {
        throw Exception('Failed to get available slots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching available slots: $e');
    }
  }

  /// Book a counseling session
  Future<CounselingSession> bookSession(BookSessionRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/counseling/sessions/book'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CounselingSession.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to book session');
      }
    } catch (e) {
      throw Exception('Error booking session: $e');
    }
  }

  /// Get student's counseling sessions
  Future<({List<CounselingSession> sessions, int total, bool hasMore})> getSessions({
    int page = 1,
    int pageSize = 20,
    String? status,
    String? sessionType,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null) queryParams['status'] = status;
      if (sessionType != null) queryParams['session_type'] = sessionType;

      final uri = Uri.parse('$baseUrl/counseling/sessions')
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
      } else {
        throw Exception('Failed to get sessions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sessions: $e');
    }
  }

  /// Get session by ID
  Future<CounselingSession> getSession(String sessionId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/counseling/sessions/$sessionId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CounselingSession.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Session not found');
      } else {
        throw Exception('Failed to get session: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching session: $e');
    }
  }

  /// Cancel a session
  Future<CounselingSession> cancelSession(String sessionId, {String? reason}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/counseling/sessions/$sessionId/cancel'),
        headers: _headers,
        body: jsonEncode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CounselingSession.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to cancel session');
      }
    } catch (e) {
      throw Exception('Error cancelling session: $e');
    }
  }

  /// Submit feedback for a completed session
  Future<CounselingSession> submitFeedback(
    String sessionId,
    SessionFeedbackRequest feedback,
  ) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/counseling/sessions/$sessionId/feedback'),
        headers: _headers,
        body: jsonEncode(feedback.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CounselingSession.fromJson(json);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Failed to submit feedback');
      }
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }

  /// Get counseling statistics
  Future<CounselingStats> getStats() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/counseling/stats/me'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return CounselingStats.fromJson(json);
      } else {
        throw Exception('Failed to get stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching stats: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
