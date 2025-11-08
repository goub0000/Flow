import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/settings_widgets.dart';

/// Language & Localization Settings Screen
///
/// Allows users to customize language and regional preferences:
/// - App language selection
/// - Date and time format
/// - Number format
/// - Content language preferences
/// - Translation settings
/// - Regional preferences
///
/// Backend Integration TODO:
/// - Save language preferences to backend
/// - Apply language changes app-wide
/// - Sync with SharedPreferences
/// - Load user's saved preferences

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selectedLanguage = 'en';
  String _dateFormat = 'default';
  String _timeFormat = '12h';
  String _numberFormat = 'default';
  bool _autoTranslate = false;
  bool _showOriginalText = true;

  // Available languages with their display names and flags
  final List<LanguageOption> _languages = [
    LanguageOption(
      code: 'en',
      name: 'English',
      nativeName: 'English',
      flag: '🇬🇧',
    ),
    LanguageOption(
      code: 'sw',
      name: 'Kiswahili',
      nativeName: 'Kiswahili',
      flag: '🇰🇪',
    ),
    LanguageOption(
      code: 'fr',
      name: 'French',
      nativeName: 'Français',
      flag: '🇫🇷',
    ),
    LanguageOption(
      code: 'ar',
      name: 'Arabic',
      nativeName: 'العربية',
      flag: '🇸🇦',
    ),
    LanguageOption(
      code: 'es',
      name: 'Spanish',
      nativeName: 'Español',
      flag: '🇪🇸',
    ),
    LanguageOption(
      code: 'pt',
      name: 'Portuguese',
      nativeName: 'Português',
      flag: '🇵🇹',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Language & Region'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Selection Section
          SettingsSectionHeader(
            title: 'APP LANGUAGE',
            subtitle: 'Choose your preferred language',
          ),
          SettingsCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _languages.map((language) {
                    final isSelected = _selectedLanguage == language.code;
                    return _LanguageTile(
                      language: language,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedLanguage = language.code;
                        });
                        // TODO: Apply language change
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Language changed to ${language.name}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Date & Time Format Section
          SettingsSectionHeader(
            title: 'DATE & TIME',
            subtitle: 'Customize date and time display',
          ),
          SettingsCard(
            children: [
              _FormatSelector(
                icon: Icons.calendar_today,
                title: 'Date Format',
                selectedValue: _dateFormat,
                options: const {
                  'default': 'System Default',
                  'mdy': 'MM/DD/YYYY (12/31/2024)',
                  'dmy': 'DD/MM/YYYY (31/12/2024)',
                  'ymd': 'YYYY/MM/DD (2024/12/31)',
                  'long': 'December 31, 2024',
                },
                onChanged: (value) {
                  setState(() {
                    _dateFormat = value;
                  });
                },
              ),
              _FormatSelector(
                icon: Icons.access_time,
                title: 'Time Format',
                selectedValue: _timeFormat,
                options: const {
                  '12h': '12-hour (2:30 PM)',
                  '24h': '24-hour (14:30)',
                },
                onChanged: (value) {
                  setState(() {
                    _timeFormat = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Number Format Section
          SettingsSectionHeader(
            title: 'NUMBER FORMAT',
            subtitle: 'Currency and number display',
          ),
          SettingsCard(
            children: [
              _FormatSelector(
                icon: Icons.numbers,
                title: 'Number Format',
                selectedValue: _numberFormat,
                options: const {
                  'default': 'System Default',
                  'comma': '1,234,567.89',
                  'period': '1.234.567,89',
                  'space': '1 234 567,89',
                },
                onChanged: (value) {
                  setState(() {
                    _numberFormat = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Translation Settings Section
          SettingsSectionHeader(
            title: 'CONTENT TRANSLATION',
            subtitle: 'Automatic translation preferences',
          ),
          SettingsCard(
            children: [
              SettingsSwitchTile(
                icon: Icons.translate,
                title: 'Auto-Translate Content',
                subtitle: 'Automatically translate content to your language',
                value: _autoTranslate,
                onChanged: (value) {
                  setState(() {
                    _autoTranslate = value;
                  });
                },
              ),
              SettingsSwitchTile(
                icon: Icons.text_fields,
                title: 'Show Original Text',
                subtitle: 'Display original language alongside translation',
                value: _showOriginalText,
                enabled: _autoTranslate,
                onChanged: (value) {
                  setState(() {
                    _showOriginalText = value;
                  });
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Regional Settings Section
          SettingsSectionHeader(
            title: 'REGIONAL SETTINGS',
            subtitle: 'Location-based preferences',
          ),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.public,
                title: 'Region',
                subtitle: 'Kenya (East Africa)',
                onTap: () {
                  _showRegionSelector();
                },
              ),
              SettingsTile(
                icon: Icons.calendar_view_week,
                title: 'First Day of Week',
                subtitle: 'Monday',
                onTap: () {
                  _showFirstDaySelector();
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content Language Preferences
          SettingsSectionHeader(
            title: 'CONTENT PREFERENCES',
            subtitle: 'Languages for courses and materials',
          ),
          SettingsCard(
            children: [
              SettingsTile(
                icon: Icons.school,
                title: 'Preferred Course Languages',
                subtitle: 'English, Kiswahili',
                onTap: () {
                  _showCourseLanguageSelector();
                },
                showDivider: false,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Help Text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Language Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Changing your language will update all menus, buttons, and system messages. Course content may still appear in its original language.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRegionSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Region'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              'Kenya (East Africa)',
              'Nigeria (West Africa)',
              'South Africa (Southern Africa)',
              'Egypt (North Africa)',
              'United States',
              'United Kingdom',
            ].map((region) {
              return ListTile(
                title: Text(region),
                trailing: region == 'Kenya (East Africa)'
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Region changed to $region')),
                  );
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFirstDaySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('First Day of Week'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Sunday',
            'Monday',
            'Saturday',
          ].map((day) {
            return RadioListTile<String>(
              title: Text(day),
              value: day,
              groupValue: 'Monday',
              onChanged: (value) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('First day set to $value')),
                );
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCourseLanguageSelector() {
    final availableLanguages = _languages.map((l) => l.name).toList();
    final selectedLanguages = {'English', 'Kiswahili'};

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred Course Languages'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: availableLanguages.map((language) {
              final isSelected = selectedLanguages.contains(language);
              return CheckboxListTile(
                title: Text(language),
                value: isSelected,
                onChanged: (value) {
                  // TODO: Handle multi-select
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Course language preferences saved'),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

/// Language option model
class LanguageOption {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

/// Language selection tile
class _LanguageTile extends StatelessWidget {
  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Text(
              language.flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    language.nativeName,
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
    );
  }
}

/// Format selector widget for date/time/number formats
class _FormatSelector extends StatelessWidget {
  final IconData icon;
  final String title;
  final String selectedValue;
  final Map<String, String> options;
  final ValueChanged<String> onChanged;
  final bool showDivider;

  const _FormatSelector({
    required this.icon,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLabel = options[selectedValue] ?? 'Unknown';

    return Column(
      children: [
        InkWell(
          onTap: () => _showFormatDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 56, endIndent: 16),
      ],
    );
  }

  void _showFormatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: selectedValue,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
