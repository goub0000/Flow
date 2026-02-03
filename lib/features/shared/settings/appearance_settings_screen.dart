import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/providers/appearance_provider.dart';
import '../../../main.dart';
import '../widgets/settings_widgets.dart';

/// Appearance Settings Screen
///
/// Allows users to customize the app's appearance:
/// - Theme (Light/Dark/System)
/// - Font size
/// - Color scheme
/// - Display density
///
/// Backend Integration TODO:
/// - Save preferences to SharedPreferences
/// - Sync with backend user preferences
/// - Apply theme changes in real-time

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appearance = ref.watch(appearanceProvider);
    final appearanceNotifier = ref.read(appearanceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Appearance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              RestartWidget.restartApp(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('App refreshed! Changes applied.'),
                  duration: Duration(seconds: 2),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            tooltip: 'Refresh App',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Theme and accent changes apply automatically. For other changes, tap the refresh button above.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Theme Section
          SettingsSectionHeader(
            title: 'THEME',
            subtitle: 'Choose how Flow looks to you',
          ),
          SettingsCard(
            children: [
              ThemeSelector(
                selectedTheme: appearance.themeMode.name,
                onThemeChanged: (theme) {
                  final ThemeMode mode;
                  switch (theme) {
                    case 'light':
                      mode = ThemeMode.light;
                      break;
                    case 'dark':
                      mode = ThemeMode.dark;
                      break;
                    default:
                      mode = ThemeMode.system;
                  }
                  appearanceNotifier.setThemeMode(mode);
                  // Automatically refresh app to apply theme changes
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (context.mounted) {
                      RestartWidget.restartApp(context);
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Text Size Section
          SettingsSectionHeader(
            title: 'TEXT SIZE',
            subtitle: 'Adjust the size of text throughout the app',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The quick brown fox jumps over the lazy dog',
                      style: TextStyle(
                        fontSize: appearance.fontSize,
                        fontFamily: appearance.fontFamily != 'System Default'
                            ? appearance.fontFamily
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('A'),
                        Expanded(
                          child: Slider(
                            value: appearance.fontSize,
                            min: 12.0,
                            max: 24.0,
                            divisions: 12,
                            label: appearance.fontSize.toStringAsFixed(0),
                            onChanged: (value) {
                              appearanceNotifier.setFontSize(value);
                            },
                          ),
                        ),
                        Text(
                          'A',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${appearance.fontSize.toStringAsFixed(0)} px',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Font Family Section
          SettingsSectionHeader(
            title: 'FONT FAMILY',
            subtitle: 'Choose your preferred font',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: availableFonts.map((font) {
                    final isSelected = appearance.fontFamily == font;
                    return RadioListTile<String>(
                      title: Text(
                        font,
                        style: TextStyle(
                          fontFamily: font != 'System Default' ? font : null,
                        ),
                      ),
                      subtitle: Text(
                        'The quick brown fox',
                        style: TextStyle(
                          fontFamily: font != 'System Default' ? font : null,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      value: font,
                      groupValue: appearance.fontFamily,
                      onChanged: (value) {
                        if (value != null) {
                          appearanceNotifier.setFontFamily(value);
                        }
                      },
                      activeColor: AppColors.primary,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Display Options Section
          SettingsSectionHeader(
            title: 'DISPLAY OPTIONS',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.view_compact,
                title: 'Compact Mode',
                subtitle: 'Show more content on screen',
                value: appearance.compactMode,
                onChanged: (value) {
                  appearanceNotifier.setCompactMode(value);
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Color Scheme Section (Preview)
          SettingsSectionHeader(
            title: 'COLOR ACCENT',
            subtitle: 'Customize app colors',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your accent color',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        AppColors.primary,
                        Colors.blue,
                        Colors.purple,
                        Colors.green,
                        Colors.orange,
                        Colors.pink,
                      ].map((color) {
                        final isSelected = color.value == appearance.accentColor.value;
                        return GestureDetector(
                          onTap: () {
                            appearanceNotifier.setAccentColor(color);
                            // Automatically refresh app to apply accent color changes
                            Future.delayed(const Duration(milliseconds: 500), () {
                              if (context.mounted) {
                                RestartWidget.restartApp(context);
                              }
                            });
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: isSelected
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
