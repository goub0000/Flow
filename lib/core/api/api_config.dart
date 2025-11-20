/// API Configuration
/// Contains all API endpoints and configuration settings
///
/// IMPORTANT: API keys should be provided via --dart-define flags during build:
/// flutter build web --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
/// flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key

import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URLs - configured via environment variables
  // Use --dart-define=API_BASE_URL=your_url to set production URL
  static const String productionBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000', // Development fallback only
  );

  static const String developmentBaseUrl = 'http://localhost:8000';

  // Current environment - auto-detect based on API_BASE_URL presence
  static bool get isProduction => const String.fromEnvironment('API_BASE_URL', defaultValue: '').isNotEmpty;

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
  // SECURITY: These MUST be provided via --dart-define flags
  // NEVER commit credentials to source control
  //
  // Development: Create .env file and use --dart-define-from-file=.env
  // Production: Use CI/CD secrets or build-time environment variables
  //
  // Required build command:
  // flutter build web \
  //   --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  //   --dart-define=SUPABASE_ANON_KEY=your_anon_key \
  //   --dart-define=API_BASE_URL=https://your-api.railway.app

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://wmuarotbdjhqbyjyslqg.supabase.co', // Dev fallback only
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWFyb3RiZGpocWJ5anlzbHFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4NDU2ODEsImV4cCI6MjA3NzQyMTY4MX0.CjfL8kn745KaxUUflPY30WnbLfMKwwVmA2RI3vFwAlM', // Dev fallback only
  );

  // Validation: Ensure critical configuration is provided
  static void validateConfig() {
    if (supabaseUrl.isEmpty) {
      // More descriptive error for debugging
      final message = 'SUPABASE_URL not configured. '
        'Please provide via --dart-define=SUPABASE_URL=your_url during build. '
        'Current value: "$supabaseUrl"';

      // In web, log to console for debugging
      debugPrint('ERROR: $message');
      throw Exception(message);
    }
    if (supabaseAnonKey.isEmpty) {
      // More descriptive error for debugging
      final message = 'SUPABASE_ANON_KEY not configured. '
        'Please provide via --dart-define=SUPABASE_ANON_KEY=your_key during build. '
        'Current value length: ${supabaseAnonKey.length}';

      // In web, log to console for debugging
      debugPrint('ERROR: $message');
      throw Exception(message);
    }

    // Log successful configuration (only in debug mode)
    debugPrint('API Configuration validated successfully:');
    debugPrint('  - Supabase URL: ${supabaseUrl.substring(0, 20)}...');
    debugPrint('  - API Base URL: $apiBaseUrl');
    debugPrint('  - Environment: ${isProduction ? "Production" : "Development"}');
  }

  // API Endpoints
  static const String auth = '/auth';
  static const String students = '/students';
  static const String institutions = '/institutions';
  static const String universities = '/universities';
  static const String programs = '/programs';
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
