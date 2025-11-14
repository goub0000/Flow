/// API Configuration
/// Contains all API endpoints and configuration settings
///
/// IMPORTANT: API keys should be provided via --dart-define flags during build:
/// flutter build web --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key
/// flutter run --dart-define=SUPABASE_URL=your_url --dart-define=SUPABASE_ANON_KEY=your_key

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
    // NO DEFAULT VALUE for security - will fail fast if not provided
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    // NO DEFAULT VALUE for security - will fail fast if not provided
  );

  // Validation: Ensure critical configuration is provided
  static void validateConfig() {
    if (supabaseUrl.isEmpty) {
      throw Exception(
        'SUPABASE_URL not configured. '
        'Please provide via --dart-define=SUPABASE_URL=your_url'
      );
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception(
        'SUPABASE_ANON_KEY not configured. '
        'Please provide via --dart-define=SUPABASE_ANON_KEY=your_key'
      );
    }
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
