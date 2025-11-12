/// API Configuration
/// Contains all API endpoints and configuration settings

class ApiConfig {
  // Base URLs
  static const String productionBaseUrl = 'https://web-production-51e34.up.railway.app';
  static const String developmentBaseUrl = 'http://localhost:8000';

  // Current environment
  static const bool isProduction = true; // Set to true for production builds

  // Get the active base URL
  static String get baseUrl => isProduction ? productionBaseUrl : developmentBaseUrl;

  // API version prefix
  static const String apiVersion = '/api/v1';

  // Full API base URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // Timeout durations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Supabase Configuration
  static const String supabaseUrl = 'https://wmuarotbdjhqbyjyslqg.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NDU2ODEsImV4cCI6MjA3NzQyMTY4MX0.oQhvQe2iyDyHjxpvP4wWpqXUADfG7KBaO3SFsBM9qFo';

  // API Endpoints
  static const String auth = '/auth';
  static const String students = '/students';
  static const String institutions = '/institutions';
  static const String universities = '/universities';
  static const String programs = '/programs';
  static const String courses = '/courses';
  static const String enrollments = '/enrollments';
  static const String applications = '/applications';
  static const String recommendations = '/recommendations';
  static const String messaging = '/messages';
  static const String notifications = '/notifications';
  static const String counseling = '/counseling';
  static const String parent = '/parent';
  static const String parentMonitoring = '/parent';
  static const String achievements = '/achievements';
  static const String monitoring = '/monitoring';
  static const String admin = '/admin';
  static const String recommender = '/recommender';
  static const String documents = '/documents';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
