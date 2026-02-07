// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

/// API Configuration
/// Contains all API endpoints and configuration settings
///
/// Credentials are resolved in this order:
/// 1. Compile-time: --dart-define flags (local dev)
/// 2. Runtime: window.FLOW_CONFIG injected by server.js (production on Railway)
///
/// Local dev:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
///
/// Production:
///   server.js reads Railway env vars and serves /env-config.js before Flutter boots.
library;

import 'dart:js' as js;

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class ApiConfig {
  static final _logger = Logger('ApiConfig');

  // ── Compile-time values (from --dart-define, used in local dev) ──
  static const String _apiBaseUrlCompile = String.fromEnvironment('API_BASE_URL');
  static const String _supabaseUrlCompile = String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKeyCompile = String.fromEnvironment('SUPABASE_ANON_KEY');

  // Production backend URL (hard-coded fallback)
  static const String _productionBackendUrl = 'https://web-production-51e34.up.railway.app';

  // Current environment - auto-detect based on kReleaseMode
  static bool get isProduction => kReleaseMode;

  // Get the active base URL
  static String get baseUrl {
    if (_apiBaseUrlCompile.isNotEmpty) return _apiBaseUrlCompile;
    final runtime = _readRuntimeConfig('API_BASE_URL');
    if (runtime.isNotEmpty) return runtime;
    if (kReleaseMode) return _productionBackendUrl;
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

  // ── Supabase credentials (compile-time → runtime fallback) ──
  static String get supabaseUrl =>
      _supabaseUrlCompile.isNotEmpty ? _supabaseUrlCompile : _readRuntimeConfig('SUPABASE_URL');

  static String get supabaseAnonKey =>
      _supabaseAnonKeyCompile.isNotEmpty ? _supabaseAnonKeyCompile : _readRuntimeConfig('SUPABASE_ANON_KEY');

  /// Read a value from the runtime JS config (window.FLOW_CONFIG).
  static String _readRuntimeConfig(String key) {
    try {
      final config = js.context['FLOW_CONFIG'];
      if (config == null) return '';
      final value = config[key];
      return value?.toString() ?? '';
    } catch (_) {
      return '';
    }
  }

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
  static const String consent = '/consent';

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
