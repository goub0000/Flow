import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/models/program_model.dart';

/// Service for communicating with Programs API
class ProgramsApiService {
  // API base URL - update this to your Railway deployment URL
  static const String baseUrl = 'http://localhost:8000/api/v1';

  final http.Client _client;

  ProgramsApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Get all programs with optional filters
  Future<List<Program>> getPrograms({
    String? institutionId,
    String? category,
    String? level,
    bool? isActive,
    String? search,
    int skip = 0,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (institutionId != null) queryParams['institution_id'] = institutionId;
      if (category != null) queryParams['category'] = category;
      if (level != null) queryParams['level'] = level;
      if (isActive != null) queryParams['is_active'] = isActive.toString();
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      queryParams['skip'] = skip.toString();
      queryParams['limit'] = limit.toString();

      final uri = Uri.parse('$baseUrl/programs').replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final programs = (json['programs'] as List)
            .map((p) => Program.fromJson(p as Map<String, dynamic>))
            .toList();
        return programs;
      } else {
        throw Exception('Failed to load programs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching programs: $e');
    }
  }

  /// Get a specific program by ID
  Future<Program> getProgram(String programId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/programs/$programId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Program.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('Program not found');
      } else {
        throw Exception('Failed to load program: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching program: $e');
    }
  }

  /// Create a new program
  Future<Program> createProgram(Program program) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/programs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(program.toJson()),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Program.fromJson(json);
      } else {
        throw Exception('Failed to create program: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating program: $e');
    }
  }

  /// Update an existing program
  Future<Program> updateProgram(Program program) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/programs/${program.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(program.toJson()),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Program.fromJson(json);
      } else {
        throw Exception('Failed to update program: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating program: $e');
    }
  }

  /// Delete a program
  Future<void> deleteProgram(String programId) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/programs/$programId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete program: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting program: $e');
    }
  }

  /// Toggle program active status
  Future<Program> toggleProgramStatus(String programId) async {
    try {
      final response = await _client.patch(
        Uri.parse('$baseUrl/programs/$programId/toggle-status'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Program.fromJson(json);
      } else {
        throw Exception('Failed to toggle status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling status: $e');
    }
  }

  /// Get program statistics
  Future<Map<String, dynamic>> getProgramStatistics({String? institutionId}) async {
    try {
      final queryParams = <String, String>{};
      if (institutionId != null) queryParams['institution_id'] = institutionId;

      final uri = Uri.parse('$baseUrl/programs/statistics/overview')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await _client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching statistics: $e');
    }
  }

  /// Get programs for a specific institution
  Future<List<Program>> getInstitutionPrograms(
    String institutionId, {
    bool? isActive,
    int skip = 0,
    int limit = 20,
  }) async {
    return getPrograms(
      institutionId: institutionId,
      isActive: isActive,
      skip: skip,
      limit: limit,
    );
  }

  /// Enroll in a program (increment enrolled count)
  Future<Program> enrollInProgram(String programId) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/programs/$programId/enroll'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Program.fromJson(json);
      } else if (response.statusCode == 400) {
        throw Exception('Program is full');
      } else {
        throw Exception('Failed to enroll: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error enrolling: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
