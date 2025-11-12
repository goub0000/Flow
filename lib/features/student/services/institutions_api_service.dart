import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api/api_config.dart';
import '../../../core/models/institution_model.dart';

/// Service for communicating with Institutions API
/// Fetches registered institutions (user accounts) from the main Flow platform
/// This is DIFFERENT from UniversitiesApiService which fetches from recommendation DB
class InstitutionsApiService {
  // API base URL - Main Flow platform (NOT recommendation service)
  static String get baseUrl => ApiConfig.apiBaseUrl;

  final http.Client _client;
  String? _authToken;

  InstitutionsApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Set authentication token for API requests
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Get headers with authentication
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  /// Get list of registered institutions with pagination and filters
  ///
  /// Parameters:
  /// - [search]: Search by institution name or email
  /// - [page]: Page number (starts at 1)
  /// - [pageSize]: Number of items per page (max 100)
  /// - [isVerified]: Filter by email verification status
  ///
  /// Returns [InstitutionsListResponse] with institutions list and pagination info
  Future<InstitutionsListResponse> getInstitutions({
    String? search,
    int page = 1,
    int pageSize = 20,
    bool? isVerified,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      if (isVerified != null) {
        queryParams['is_verified'] = isVerified.toString();
      }

      final uri = Uri.parse('$baseUrl${ApiConfig.institutions}')
          .replace(queryParameters: queryParams);

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return InstitutionsListResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Institutions endpoint not found');
      } else {
        throw Exception('Failed to load institutions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error fetching institutions: $e');
    }
  }

  /// Get a specific institution by ID
  ///
  /// Parameters:
  /// - [institutionId]: UUID of the institution
  ///
  /// Returns [Institution] object
  Future<Institution> getInstitution(String institutionId) async {
    try {
      final uri = Uri.parse('$baseUrl${ApiConfig.institutions}/$institutionId');

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return Institution.fromJson(json);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Institution not found');
      } else {
        throw Exception('Failed to load institution: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Error fetching institution: $e');
    }
  }

  /// Search institutions with a simple query
  /// This is a convenience method that wraps getInstitutions
  Future<List<Institution>> searchInstitutions(String query) async {
    try {
      final response = await getInstitutions(
        search: query,
        page: 1,
        pageSize: 50, // Get more results for search
      );
      return response.institutions;
    } catch (e) {
      throw Exception('Error searching institutions: $e');
    }
  }

  /// Get all institutions (without pagination)
  /// Note: This fetches the first page with a large page size
  /// For production, consider implementing proper pagination
  Future<List<Institution>> getAllInstitutions() async {
    try {
      final response = await getInstitutions(
        page: 1,
        pageSize: 100, // Get max allowed per page
      );
      return response.institutions;
    } catch (e) {
      throw Exception('Error fetching all institutions: $e');
    }
  }

  /// Get verified institutions only
  Future<InstitutionsListResponse> getVerifiedInstitutions({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await getInstitutions(
        isVerified: true,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw Exception('Error fetching verified institutions: $e');
    }
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
