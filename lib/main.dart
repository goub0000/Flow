import 'package:flutter/material.dart';
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

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Only log to console in debug mode
    // In production, logs will be captured by Sentry
    debugPrint('[${record.level.name}] ${record.loggerName}: ${record.message}');
    if (record.error != null) {
      debugPrint('Error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('Stack trace: ${record.stackTrace}');
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
    debugPrint('✅ Supabase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ Supabase initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    // Continue anyway - app can work without Supabase for some features
  }

  // Initialize SharedPreferences for cookie consent
  late final SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
    debugPrint('✅ SharedPreferences initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('❌ SharedPreferences initialization failed: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow; // This is critical, can't continue without it
  }

  // Initialize Sentry for crash reporting
  // DSN should be provided via --dart-define=SENTRY_DSN=your_dsn in production
  const sentryDsn = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn.isEmpty ? null : sentryDsn;
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
    );
  }
}
