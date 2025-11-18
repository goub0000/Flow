import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meeting_models.dart';

/// Service for communicating with Meetings API
/// Handles parent-teacher/counselor meeting scheduling
class MeetingsApiService {
  // API base URL - Railway production deployment
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final String? _accessToken;

  MeetingsApiService({
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

  // ==================== Staff Management ====================

  /// Get list of teachers and counselors
  /// Optional role filter: 'teacher' or 'counselor'
  Future<List<StaffMember>> getStaffList({String? role}) async {
    try {
      final queryParams = <String, String>{};
      if (role != null) {
        queryParams['role'] = role;
      }

      final uri = Uri.parse('$baseUrl/staff/list')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => StaffMember.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load staff list: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching staff list: $e');
    }
  }

  /// Set availability schedule (Staff only)
  Future<StaffAvailability> setStaffAvailability({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final body = {
        'day_of_week': dayOfWeek,
        'start_time': startTime,
        'end_time': endTime,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/staff/availability'),
        headers: _buildHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StaffAvailability.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Only teachers and counselors can set availability');
      } else {
        throw Exception('Failed to set availability: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error setting availability: $e');
    }
  }

  /// Get availability schedule for a staff member
  Future<List<StaffAvailability>> getStaffAvailability(String staffId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/staff/$staffId/availability'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => StaffAvailability.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load availability: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching availability: $e');
    }
  }

  /// Update availability schedule (Staff only)
  Future<StaffAvailability> updateStaffAvailability({
    required String availabilityId,
    String? startTime,
    String? endTime,
    bool? isActive,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (startTime != null) body['start_time'] = startTime;
      if (endTime != null) body['end_time'] = endTime;
      if (isActive != null) body['is_active'] = isActive;

      final response = await _client.put(
        Uri.parse('$baseUrl/staff/availability/$availabilityId'),
        headers: _buildHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StaffAvailability.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only update your own availability');
      } else {
        throw Exception('Failed to update availability: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating availability: $e');
    }
  }

  /// Delete availability slot (Staff only)
  Future<void> deleteStaffAvailability(String availabilityId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/staff/availability/$availabilityId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only delete your own availability');
      } else {
        throw Exception('Failed to delete availability: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting availability: $e');
    }
  }

  // ==================== Meeting Requests (Parent) ====================

  /// Request a meeting with a teacher or counselor (Parent only)
  Future<Meeting> requestMeeting(MeetingRequestDTO meetingData) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/meetings/request'),
        headers: _buildHeaders(),
        body: jsonEncode(meetingData.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Meeting.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Only parents can request meetings');
      } else if (response.statusCode == 409) {
        throw Exception('Conflict: Meeting time conflicts with existing meeting');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to request meeting: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error requesting meeting: $e');
    }
  }

  /// Get all meetings for a parent
  Future<List<Meeting>> getParentMeetings({
    required String parentId,
    String? statusFilter,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (statusFilter != null) {
        queryParams['status'] = statusFilter;
      }

      final uri = Uri.parse('$baseUrl/meetings/parent/$parentId')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => Meeting.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only view your own meetings');
      } else {
        throw Exception('Failed to load meetings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching parent meetings: $e');
    }
  }

  /// Cancel a meeting (Parent or Staff)
  Future<Meeting> cancelMeeting({
    required String meetingId,
    String? cancellationReason,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (cancellationReason != null) {
        queryParams['cancellation_reason'] = cancellationReason;
      }

      final uri = Uri.parse('$baseUrl/meetings/$meetingId/cancel')
          .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await _client.put(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Meeting.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only cancel your own meetings');
      } else if (response.statusCode == 404) {
        throw Exception('Meeting not found');
      } else {
        throw Exception('Failed to cancel meeting: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error cancelling meeting: $e');
    }
  }

  // ==================== Meeting Management (Staff) ====================

  /// Get all meetings for a staff member (Teacher/Counselor)
  Future<List<Meeting>> getStaffMeetings({
    required String staffId,
    String? statusFilter,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
        'offset': offset.toString(),
      };
      if (statusFilter != null) {
        queryParams['status'] = statusFilter;
      }

      final uri = Uri.parse('$baseUrl/meetings/staff/$staffId')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => Meeting.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only view your own meetings');
      } else {
        throw Exception('Failed to load meetings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching staff meetings: $e');
    }
  }

  /// Approve a meeting request and set scheduled time (Staff only)
  Future<Meeting> approveMeeting({
    required String meetingId,
    required MeetingApprovalDTO approvalData,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/meetings/$meetingId/approve'),
        headers: _buildHeaders(),
        body: jsonEncode(approvalData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Meeting.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Only teachers and counselors can approve meetings');
      } else if (response.statusCode == 404) {
        throw Exception('Meeting not found');
      } else if (response.statusCode == 409) {
        throw Exception('Conflict: Scheduled time conflicts with existing meeting');
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['detail'] ?? 'Failed to approve meeting: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error approving meeting: $e');
    }
  }

  /// Decline a meeting request (Staff only)
  Future<Meeting> declineMeeting({
    required String meetingId,
    required MeetingDeclineDTO declineData,
  }) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/meetings/$meetingId/decline'),
        headers: _buildHeaders(),
        body: jsonEncode(declineData.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Meeting.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: Only teachers and counselors can decline meetings');
      } else if (response.statusCode == 404) {
        throw Exception('Meeting not found');
      } else {
        throw Exception('Failed to decline meeting: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error declining meeting: $e');
    }
  }

  // ==================== Utilities ====================

  /// Get available time slots for a staff member
  Future<List<AvailableSlot>> getAvailableSlots({
    required String staffId,
    required DateTime startDate,
    required DateTime endDate,
    required int durationMinutes,
  }) async {
    try {
      final body = {
        'staff_id': staffId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'duration_minutes': durationMinutes,
      };

      final response = await _client.post(
        Uri.parse('$baseUrl/meetings/available-slots'),
        headers: _buildHeaders(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
        return json
            .map((item) => AvailableSlot.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load available slots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching available slots: $e');
    }
  }

  /// Get meeting details
  Future<Meeting> getMeeting(String meetingId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/meetings/$meetingId'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Meeting.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden: You can only view your own meetings');
      } else if (response.statusCode == 404) {
        throw Exception('Meeting not found');
      } else {
        throw Exception('Failed to load meeting: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meeting: $e');
    }
  }

  /// Get meeting statistics for current user
  Future<MeetingStatistics> getMeetingStatistics() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/meetings/statistics/me'),
        headers: _buildHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return MeetingStatistics.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching meeting statistics: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
