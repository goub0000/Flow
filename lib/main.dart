import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  // Initialize error handling
  ErrorHandler.init();

  // Initialize Supabase
  await Supabase.initialize(
    url: ApiConfig.supabaseUrl,
    anonKey: ApiConfig.supabaseAnonKey,
  );

  // Initialize SharedPreferences for cookie consent
  final prefs = await SharedPreferences.getInstance();

  // Hot reload trigger - comprehensive color fix
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
