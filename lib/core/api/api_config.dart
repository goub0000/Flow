/// API Configuration
/// Contains all API endpoints and configuration settings
///
/// IMPORTANT: API keys MUST be provided via --dart-define flags during build:
/// flutter build web --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
/// flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
///
/// Production build example:
/// flutter build web \
///   --dart-define=SUPABASE_URL=https://your-project.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=your_anon_key \
///   --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ApiConfig {
  static final _logger = Logger('ApiConfig');

  // Base URLs - configured via environment variables
  // MUST be provided via --dart-define=API_BASE_URL=your_url
  // Production URL: https://web-production-51e34.up.railway.app
  static const String _apiBaseUrlEnv = String.fromEnvironment('API_BASE_URL');

  // Production backend URL (used when API_BASE_URL is not explicitly set)
  static const String _productionBackendUrl = 'https://web-production-51e34.up.railway.app';

  // Current environment - auto-detect based on kReleaseMode
  static bool get isProduction => kReleaseMode;

  // Get the active base URL - prioritize explicit env var, then use production URL in release mode
  static String get baseUrl {
    if (_apiBaseUrlEnv.isNotEmpty) {
      return _apiBaseUrlEnv;
    }
    // In release mode, default to production URL
    if (kReleaseMode) {
      return _productionBackendUrl;
    }
    // In debug mode, use localhost for development
    return 'http://localhost:8000';
  }

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
  //   --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app

  // NO DEFAULT VALUES - credentials MUST be provided at build time
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Validates that all required configuration is provided.
  /// Throws [StateError] if critical configuration is missing.
  /// This should be called during app initialization to fail fast.
  static void validateConfig() {
    final errors = <String>[];

    if (supabaseUrl.isEmpty) {
      errors.add('SUPABASE_URL not configured. '
          'Provide via --dart-define=SUPABASE_URL=https://your-project.supabase.co');
    }

    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY not configured. '
          'Provide via --dart-define=SUPABASE_ANON_KEY=your_anon_key');
    }

    if (errors.isNotEmpty) {
      final message = 'Missing required configuration:\n${errors.join('\n')}\n\n'
          'Build command example:\n'
          'flutter build web \\\n'
          '  --dart-define=SUPABASE_URL=https://your-project.supabase.co \\\n'
          '  --dart-define=SUPABASE_ANON_KEY=your_anon_key \\\n'
          '  --dart-define=API_BASE_URL=https://web-production-51e34.up.railway.app';
      _logger.severe(message);
      throw StateError(message);
    }

    // Log successful configuration (only log URL prefix for security)
    _logger.info('API Configuration validated successfully');
    _logger.config('Supabase URL: ${supabaseUrl.substring(0, supabaseUrl.length.clamp(0, 30))}...');
    _logger.config('API Base URL: $apiBaseUrl');
    _logger.config('Environment: ${isProduction ? "Production" : "Development"}');
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
