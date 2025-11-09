import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/university.dart';
import '../../domain/models/recommendation.dart';

/// Service for communicating with Find Your Path recommendation API
class FindYourPathService {
  // API base URL - Cloud-based Railway deployment
  static const String baseUrl = 'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;

  FindYourPathService({http.Client? client}) : _client = client ?? http.Client();

  /// Get authentication headers with Supabase JWT token
  Map<String, String> _getAuthHeaders() {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (session?.accessToken != null) {
      headers['Authorization'] = 'Bearer ${session!.accessToken}';
    }

    return headers;
  }

  /// Create or update student profile
  Future<StudentProfile> saveProfile(StudentProfile profile) async {
    try {
      print('[FYP] Saving profile for user: ${profile.userId}');
      final body = jsonEncode(profile.toJson());
      print('[FYP] Request body: $body');

      final response = await _client.post(
        Uri.parse('$baseUrl/students/profile'),
        headers: _getAuthHeaders(),
        body: body,
      );

      print('[FYP] Save profile response: ${response.statusCode}');
      print('[FYP] Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StudentProfile.fromJson(json);
      } else if (response.statusCode == 400) {
        // Profile exists, try update
        return await updateProfile(profile);
      } else {
        throw Exception('Failed to save profile: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('[FYP] Error saving profile: $e');
      throw Exception('Error saving profile: $e');
    }
  }

  /// Update existing student profile
  Future<StudentProfile> updateProfile(StudentProfile profile) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/students/profile/${profile.userId}'),
        headers: _getAuthHeaders(),
        body: jsonEncode(profile.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StudentProfile.fromJson(json);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  /// Get student profile by user ID
  Future<StudentProfile?> getProfile(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/students/profile/$userId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return StudentProfile.fromJson(json);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting profile: $e');
    }
  }

  /// Check if profile exists for user
  Future<bool> profileExists(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/students/profile/$userId/exists'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['exists'] as bool;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Generate recommendations for a user
  Future<RecommendationListResponse> generateRecommendations({
    required String userId,
    int limit = 20,
    bool includeReach = true,
    bool includeSafety = true,
    double minMatchScore = 50.0,
  }) async {
    try {
      print('[FYP] Generating recommendations for user: $userId');
      final body = jsonEncode({
        'user_id': userId,
        'limit': limit,
        'include_reach': includeReach,
        'include_safety': includeSafety,
        'min_match_score': minMatchScore,
      });
      print('[FYP] Request body: $body');

      final response = await _client.post(
        Uri.parse('$baseUrl/recommendations/generate'),
        headers: _getAuthHeaders(),
        body: body,
      );

      print('[FYP] Generate recommendations response: ${response.statusCode}');
      print('[FYP] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return RecommendationListResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to generate recommendations: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('[FYP] Error generating recommendations: $e');
      throw Exception('Error generating recommendations: $e');
    }
  }

  /// Get saved recommendations for a user
  Future<RecommendationListResponse> getRecommendations(String userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/recommendations/$userId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return RecommendationListResponse.fromJson(json);
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting recommendations: $e');
    }
  }

  /// Toggle favorite status for a recommendation
  Future<bool> toggleFavorite(int recommendationId) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/recommendations/$recommendationId/favorite'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json['favorited'] as bool;
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  /// Get university details by ID
  Future<University> getUniversity(int universityId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/universities/$universityId'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return University.fromJson(json);
      } else {
        throw Exception('Failed to get university: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting university: $e');
    }
  }

  /// Search universities
  Future<List<University>> searchUniversities({
    String? query,
    String? country,
    String? state,
    double? maxTuition,
    int limit = 20,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/universities/search'),
        headers: _getAuthHeaders(),
        body: jsonEncode({
          'query': query,
          'country': country,
          'state': state,
          'max_tuition': maxTuition,
          'limit': limit,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final universities = (json['universities'] as List<dynamic>)
            .map((u) => University.fromJson(u as Map<String, dynamic>))
            .toList();
        return universities;
      } else {
        throw Exception('Failed to search universities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching universities: $e');
    }
  }

  /// Get database statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/universities/stats/overview'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting statistics: $e');
    }
  }

  /// Check if API is healthy
  Future<bool> healthCheck() async {
    try {
      final response = await _client.get(
        Uri.parse('http://localhost:8000/health'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
