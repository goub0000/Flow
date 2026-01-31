import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:logging/logging.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/appearance_provider.dart';
import 'core/providers/cookie_providers.dart';
import 'core/providers/service_providers.dart' as service_providers;
import 'core/error/error_handling.dart';
import 'core/api/api_config.dart';
import 'routing/app_router.dart';
import 'features/shared/widgets/offline_status_indicator.dart';
import 'features/authentication/providers/auth_provider.dart';
import 'features/chatbot/presentation/widgets/chatbot_fab.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Enable semantics tree for screen readers without requiring user opt-in
  SemanticsBinding.instance.ensureSemantics();

  // Initialize logging
  final mainLogger = Logger('Main');
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((record) {
    // Only log to console in debug mode
    // In production, logs will be captured by Sentry
    if (kDebugMode) {
      debugPrint('[${record.level.name}] ${record.loggerName}: ${record.message}');
      if (record.error != null) {
        debugPrint('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        debugPrint('Stack trace: ${record.stackTrace}');
      }
    }
  });

  // Initialize error handling
  ErrorHandler.init();

  // Validate API configuration (will throw if required env vars missing)
  ApiConfig.validateConfig();

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: ApiConfig.supabaseUrl,
      anonKey: ApiConfig.supabaseAnonKey,
    );
    mainLogger.info('Supabase initialized successfully');

    // Clear any invalid sessions from previous deployments
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        mainLogger.fine('Found existing session, validating...');
        // Try to refresh - if it fails, clear the session
        final response = await Supabase.instance.client.auth.refreshSession();
        if (response.session == null) {
          mainLogger.warning('Session refresh failed, clearing invalid session...');
          await Supabase.instance.client.auth.signOut();
        } else {
          mainLogger.fine('Session is valid');
        }
      }
    } catch (e) {
      mainLogger.warning('Invalid session detected, clearing: $e');
      try {
        await Supabase.instance.client.auth.signOut();
        mainLogger.fine('Cleared invalid session');
      } catch (signOutError) {
        mainLogger.warning('Failed to clear session: $signOutError');
      }
    }
  } catch (e, stackTrace) {
    mainLogger.severe('Supabase initialization failed: $e', e, stackTrace);
    // Continue anyway - app can work without Supabase for some features
  }

  // Initialize SharedPreferences for cookie consent
  late final SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    mainLogger.info('SharedPreferences initialized successfully');
  } catch (e, stackTrace) {
    mainLogger.severe('SharedPreferences initialization failed: $e', e, stackTrace);
    rethrow; // This is critical, can't continue without it
  }

  // Initialize Sentry for crash reporting (optional, skip on web if it causes issues)
  // DSN should be provided via --dart-define=SENTRY_DSN=your_dsn in production
  const sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  try {
    mainLogger.info('Starting app initialization...');

    // Skip Sentry on web for now - it can cause initialization issues
    if (kIsWeb || sentryDsn.isEmpty) {
      mainLogger.config('Sentry disabled (web platform or no DSN)');
      runApp(
        ProviderScope(
          overrides: [
            // Override SharedPreferences provider for cookie consent
            sharedPreferencesProvider.overrideWithValue(prefs),
            // Override SharedPreferences provider for API services
            service_providers.sharedPreferencesProvider.overrideWithValue(prefs),
          ],
          child: const RestartWidget(
            child: FlowApp(),
          ),
        ),
      );
    } else {
      mainLogger.config('Initializing Sentry...');
      await SentryFlutter.init(
        (options) {
          options.dsn = sentryDsn;
          options.environment = ApiConfig.isProduction ? 'production' : 'development';
          options.tracesSampleRate = 0.2; // 20% of transactions
          options.enableAutoSessionTracking = true;
          options.attachStacktrace = true;
          options.beforeSend = (event, hint) {
            // Filter out sensitive data if needed
            return event;
          };
        },
        appRunner: () => runApp(
          ProviderScope(
            overrides: [
              // Override SharedPreferences provider for cookie consent
              sharedPreferencesProvider.overrideWithValue(prefs),
              // Override SharedPreferences provider for API services
              service_providers.sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: const RestartWidget(
              child: FlowApp(),
            ),
          ),
        ),
      );
    }
    mainLogger.info('App started successfully');
  } catch (e, stackTrace) {
    mainLogger.severe('Fatal error during app startup: $e', e, stackTrace);
    rethrow;
  }
}

/// Widget that allows restarting the entire app
class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}

class FlowApp extends ConsumerWidget {
  const FlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final appearance = ref.watch(appearanceProvider);
    final authState = ref.watch(authProvider);

    return MaterialApp.router(
      title: 'Flow - African EdTech Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(
        fontSize: appearance.fontSize,
        fontFamily: appearance.fontFamily != 'System Default' ? appearance.fontFamily : null,
        accentColor: appearance.accentColor,
        compactMode: appearance.compactMode,
      ),
      darkTheme: AppTheme.getDarkTheme(
        fontSize: appearance.fontSize,
        fontFamily: appearance.fontFamily != 'System Default' ? appearance.fontFamily : null,
        accentColor: appearance.accentColor,
        compactMode: appearance.compactMode,
      ),
      themeMode: appearance.themeMode,
      routerConfig: router,
      builder: (context, child) {
        // Show loading screen while auth state is being determined
        // This prevents flash of wrong content during page refresh
        if (authState.isLoading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.school,
                      size: 80,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            if (child != null) child,
            // Offline status indicator at the top
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: OfflineStatusIndicator(),
            ),
            // Global chatbot FAB - available on all pages
            // Positioned to fill the screen so chat window can position itself
            const Positioned.fill(
              child: ChatbotFAB(),
            ),
          ],
        );
      },
    );
  }
}
