import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Settings Widgets
///
/// Provides comprehensive settings UI components:
/// - Settings tiles (with navigation, switch, etc.)
/// - Settings sections
/// - Theme switchers
/// - Privacy controls
/// - Data management
///
/// Backend Integration TODO:
/// ```dart
/// // Save user preferences
/// import 'package:shared_preferences/shared_preferences.dart';
/// import 'package:dio/dio.dart';
///
/// class SettingsService {
///   final Dio _dio;
///   final SharedPreferences _prefs;
///
///   Future<void> updateTheme(String theme) async {
///     await _prefs.setString('theme', theme);
///     await _dio.put('/api/user/preferences', data: {'theme': theme});
///   }
///
///   Future<void> updateLanguage(String language) async {
///     await _prefs.setString('language', language);
///     await _dio.put('/api/user/preferences', data: {'language': language});
///   }
///
///   Future<void> updateNotificationPreferences(Map<String, bool> prefs) async {
///     await _prefs.setString('notifications', jsonEncode(prefs));
///     await _dio.put('/api/user/notification-preferences', data: prefs);
///   }
///
///   Future<void> deleteAccount() async {
///     await _dio.delete('/api/user/account');
///     await _prefs.clear();
///   }
/// }
/// ```

/// Settings Tile Widget
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing
                  if (trailing != null) ...[
                    const SizedBox(width: 12),
                    trailing!,
                  ] else if (onTap != null)
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 72),
            child: Divider(height: 1),
          ),
      ],
    );
  }
}

/// Settings Switch Tile
class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? iconColor;
  final bool showDivider;
  final bool enabled;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.iconColor,
    this.showDivider = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      showDivider: showDivider,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
        activeColor: AppColors.primary,
      ),
      onTap: enabled ? () => onChanged(!value) : null,
    );
  }
}

/// Settings Section Header
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Theme Selector Widget
class ThemeSelector extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeChanged;

  const ThemeSelector({
    super.key,
    required this.selectedTheme,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ThemeOption(
          title: 'Light',
          subtitle: 'Bright and clean interface',
          icon: Icons.light_mode,
          isSelected: selectedTheme == 'light',
          onTap: () => onThemeChanged('light'),
        ),
        _ThemeOption(
          title: 'Dark',
          subtitle: 'Easy on the eyes in low light',
          icon: Icons.dark_mode,
          isSelected: selectedTheme == 'dark',
          onTap: () => onThemeChanged('dark'),
        ),
        _ThemeOption(
          title: 'System',
          subtitle: 'Follow device settings',
          icon: Icons.brightness_auto,
          isSelected: selectedTheme == 'system',
          onTap: () => onThemeChanged('system'),
          showDivider: false,
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _ThemeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? AppColors.primary : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 56),
      ],
    );
  }
}

/// Language Selector Widget
class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String> onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'sw', 'name': 'Kiswahili', 'flag': '🇰🇪'},
      {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
      {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    ];

    return Column(
      children: languages.asMap().entries.map((entry) {
        final index = entry.key;
        final lang = entry.value;
        final isSelected = selectedLanguage == lang['code'];
        final isLast = index == languages.length - 1;

        return _LanguageOption(
          name: lang['name']!,
          flag: lang['flag']!,
          isSelected: isSelected,
          onTap: () => onLanguageChanged(lang['code']!),
          showDivider: !isLast,
        );
      }).toList(),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String name;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _LanguageOption({
    required this.name,
    required this.flag,
    required this.isSelected,
    required this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppColors.primary : null,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 56),
      ],
    );
  }
}

/// Data Usage Display Widget
class DataUsageDisplay extends StatelessWidget {
  final double totalBytes;
  final Map<String, double> breakdown;

  const DataUsageDisplay({
    super.key,
    required this.totalBytes,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalMB = totalBytes / (1024 * 1024);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Total Usage
          Text(
            'Total Data Usage',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${totalMB.toStringAsFixed(1)} MB',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Breakdown
          ...breakdown.entries.map((entry) {
            final mb = entry.value / (1024 * 1024);
            final percentage = (entry.value / totalBytes * 100).toInt();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${mb.toStringAsFixed(1)} MB',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Danger Zone Widget (for destructive actions)
class DangerZone extends StatelessWidget {
  final List<DangerAction> actions;

  const DangerZone({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          ...actions.asMap().entries.map((entry) {
            final index = entry.key;
            final action = entry.value;
            final isLast = index == actions.length - 1;

            return Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: action.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            action.icon,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  action.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.error,
                                  ),
                                ),
                                if (action.subtitle != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    action.subtitle!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.error,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isLast) const Divider(height: 1, indent: 52),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class DangerAction {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;

  DangerAction({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
  });
}

/// Settings Card (for grouping related settings)
class SettingsCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const SettingsCard({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title!,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

/// About App Info Widget
class AboutAppInfo extends StatelessWidget {
  final String appName;
  final String version;
  final String? buildNumber;
  final String? logoAsset;

  const AboutAppInfo({
    super.key,
    required this.appName,
    required this.version,
    this.buildNumber,
    this.logoAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          if (logoAsset != null)
            Image.asset(
              logoAsset!,
              width: 80,
              height: 80,
              errorBuilder: (_, __, ___) => const SizedBox(),
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.school,
                size: 40,
                color: AppColors.primary,
              ),
            ),
          const SizedBox(height: 16),
          Text(
            appName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version $version${buildNumber != null ? ' ($buildNumber)' : ''}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Flow EdTech Platform',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '© 2025 All rights reserved',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
