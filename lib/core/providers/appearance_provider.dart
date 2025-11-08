import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Appearance preferences state
class AppearancePreferences {
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;
  final bool compactMode;
  final Color accentColor;

  const AppearancePreferences({
    this.themeMode = ThemeMode.system,
    this.fontSize = 16.0,
    this.fontFamily = 'System Default',
    this.compactMode = false,
    this.accentColor = const Color(0xFF6B4CE6), // AppColors.primary
  });

  AppearancePreferences copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    String? fontFamily,
    bool? compactMode,
    Color? accentColor,
  }) {
    return AppearancePreferences(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      compactMode: compactMode ?? this.compactMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'fontSize': fontSize,
      'fontFamily': fontFamily,
      'compactMode': compactMode,
      'accentColor': accentColor.value,
    };
  }

  factory AppearancePreferences.fromJson(Map<String, dynamic> json) {
    return AppearancePreferences(
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
      fontSize: json['fontSize']?.toDouble() ?? 16.0,
      fontFamily: json['fontFamily'] ?? 'System Default',
      compactMode: json['compactMode'] ?? false,
      accentColor: Color(json['accentColor'] ?? 0xFF6B4CE6),
    );
  }
}

/// Appearance preferences notifier
class AppearanceNotifier extends StateNotifier<AppearancePreferences> {
  AppearanceNotifier() : super(const AppearancePreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    final fontSize = prefs.getDouble('fontSize') ?? 16.0;
    final fontFamily = prefs.getString('fontFamily') ?? 'System Default';
    final compactMode = prefs.getBool('compactMode') ?? false;
    final accentColor = prefs.getInt('accentColor') ?? 0xFF6B4CE6;

    state = AppearancePreferences(
      themeMode: ThemeMode.values[themeModeIndex],
      fontSize: fontSize,
      fontFamily: fontFamily,
      compactMode: compactMode,
      accentColor: Color(accentColor),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', mode.index);
  }

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', size);
  }

  Future<void> setFontFamily(String family) async {
    state = state.copyWith(fontFamily: family);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fontFamily', family);
  }

  Future<void> setCompactMode(bool compact) async {
    state = state.copyWith(compactMode: compact);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('compactMode', compact);
  }

  Future<void> setAccentColor(Color color) async {
    state = state.copyWith(accentColor: color);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('accentColor', color.value);
  }
}

/// Available font families
const availableFonts = [
  'System Default',
  'Roboto',
  'Open Sans',
  'Lato',
  'Montserrat',
  'Poppins',
  'Raleway',
  'Ubuntu',
];

/// Provider for appearance preferences
final appearanceProvider =
    StateNotifierProvider<AppearanceNotifier, AppearancePreferences>((ref) {
  return AppearanceNotifier();
});

/// Provider for current theme mode
final themeModeProvider = Provider<ThemeMode>((ref) {
  return ref.watch(appearanceProvider).themeMode;
});

/// Provider for current font family
final fontFamilyProvider = Provider<String>((ref) {
  return ref.watch(appearanceProvider).fontFamily;
});

/// Provider for current font size
final fontSizeProvider = Provider<double>((ref) {
  return ref.watch(appearanceProvider).fontSize;
});
