import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// System setting model
class SystemSetting {
  final String key;
  final String category;
  final dynamic value;
  final String type; // 'boolean', 'string', 'number', 'json'
  final String? description;

  const SystemSetting({
    required this.key,
    required this.category,
    required this.value,
    required this.type,
    this.description,
  });

  SystemSetting copyWith({
    String? key,
    String? category,
    dynamic value,
    String? type,
    String? description,
  }) {
    return SystemSetting(
      key: key ?? this.key,
      category: category ?? this.category,
      value: value ?? this.value,
      type: type ?? this.type,
      description: description ?? this.description,
    );
  }
}

/// State class for system settings
class AdminSystemState {
  final Map<String, SystemSetting> settings;
  final Map<String, dynamic> systemInfo;
  final bool isLoading;
  final String? error;

  const AdminSystemState({
    this.settings = const {},
    this.systemInfo = const {},
    this.isLoading = false,
    this.error,
  });

  AdminSystemState copyWith({
    Map<String, SystemSetting>? settings,
    Map<String, dynamic>? systemInfo,
    bool? isLoading,
    String? error,
  }) {
    return AdminSystemState(
      settings: settings ?? this.settings,
      systemInfo: systemInfo ?? this.systemInfo,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for system settings
class AdminSystemNotifier extends StateNotifier<AdminSystemState> {
  final ApiClient _apiClient;

  AdminSystemNotifier(this._apiClient) : super(const AdminSystemState()) {
    fetchSettings();
    fetchSystemInfo();
  }

  /// Fetch system settings from backend API
  Future<void> fetchSettings() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/system/settings',
        fromJson: (data) => data as Map<String, dynamic>? ?? {},
      );

      if (response.success && response.data != null) {
        // Convert backend settings to local format
        final Map<String, SystemSetting> settings = {};
        response.data!.forEach((key, value) {
          if (value is Map) {
            settings[key] = SystemSetting(
              key: key,
              category: value['category'] ?? 'general',
              value: value['value'],
              type: value['type'] ?? 'string',
              description: value['description'],
            );
          }
        });

        state = state.copyWith(
          settings: settings.isNotEmpty ? settings : _getDefaultSettings(),
          isLoading: false,
        );
        return;
      }

      // If backend doesn't have settings yet, use defaults
      state = state.copyWith(
        settings: _getDefaultSettings(),
        isLoading: false,
      );
    } catch (e) {
      // Fallback to default settings on error
      state = state.copyWith(
        settings: _getDefaultSettings(),
        isLoading: false,
      );
    }
  }

  /// Get default settings as fallback
  Map<String, SystemSetting> _getDefaultSettings() {
    return {

      // General settings
      'app_name': SystemSetting(
          key: 'app_name',
          category: 'general',
          value: 'Flow EdTech',
          type: 'string',
          description: 'Application name',
        ),
        'maintenance_mode': SystemSetting(
          key: 'maintenance_mode',
          category: 'general',
          value: false,
          type: 'boolean',
          description: 'Enable maintenance mode',
        ),
        'allow_registration': SystemSetting(
          key: 'allow_registration',
          category: 'general',
          value: true,
          type: 'boolean',
          description: 'Allow new user registration',
        ),

        // Feature flags
        'enable_messaging': SystemSetting(
          key: 'enable_messaging',
          category: 'features',
          value: true,
          type: 'boolean',
          description: 'Enable messaging feature',
        ),
        'enable_payments': SystemSetting(
          key: 'enable_payments',
          category: 'features',
          value: true,
          type: 'boolean',
          description: 'Enable payment processing',
        ),

        // Security settings
        'session_timeout': SystemSetting(
          key: 'session_timeout',
          category: 'security',
          value: 30,
          type: 'number',
          description: 'Session timeout in minutes',
        ),
        'require_email_verification': SystemSetting(
          key: 'require_email_verification',
          category: 'security',
          value: true,
          type: 'boolean',
          description: 'Require email verification for new users',
        ),

        // Payment settings
        'payment_gateway': SystemSetting(
          key: 'payment_gateway',
          category: 'payment',
          value: 'flutterwave',
          type: 'string',
          description: 'Default payment gateway',
        ),
        'currency': SystemSetting(
          key: 'currency',
          category: 'payment',
          value: 'USD',
          type: 'string',
          description: 'Default currency',
        ),
    };
  }

  /// Fetch system information
  /// TODO: Connect to backend API
  Future<void> fetchSystemInfo() async {
    try {
      // TODO: Fetch system stats from Supabase
      await Future.delayed(const Duration(milliseconds: 500));

      final info = {
        'version': '1.0.0',
        'environment': 'production',
        'database': 'Supabase PostgreSQL',
        'storage': 'Supabase Storage',
        'uptime': '99.9%',
        'lastBackup': DateTime.now().subtract(const Duration(hours: 2)),
        'storageUsed': '2.5 GB',
        'storageLimit': '10 GB',
      };

      state = state.copyWith(systemInfo: info);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch system info: ${e.toString()}',
      );
    }
  }

  /// Update a single setting via backend API
  Future<bool> updateSetting(String key, dynamic value) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.admin}/system/settings',
        data: {
          'settings': {key: value},
        },
      );

      if (response.success) {
        // Update local state
        final setting = state.settings[key];
        if (setting == null) return false;

        final updatedSetting = setting.copyWith(value: value);
        final updatedSettings =
            Map<String, SystemSetting>.from(state.settings);
        updatedSettings[key] = updatedSetting;

        state = state.copyWith(settings: updatedSettings);
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update setting: ${e.toString()}',
      );
      return false;
    }
  }

  /// Batch update settings via backend API
  Future<bool> batchUpdateSettings(Map<String, dynamic> updates) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.admin}/system/settings',
        data: {
          'settings': updates,
        },
      );

      if (response.success) {
        // Update local state
        final updatedSettings =
            Map<String, SystemSetting>.from(state.settings);

        updates.forEach((key, value) {
          final setting = updatedSettings[key];
          if (setting != null) {
            updatedSettings[key] = setting.copyWith(value: value);
          }
        });

        state = state.copyWith(settings: updatedSettings);
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to batch update settings: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get settings by category
  Map<String, SystemSetting> getSettingsByCategory(String category) {
    return Map.fromEntries(
      state.settings.entries.where((entry) => entry.value.category == category),
    );
  }

  /// Clear cache
  /// TODO: Implement cache clearing
  Future<bool> clearCache() async {
    try {
      // TODO: Clear various caches
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to clear cache: ${e.toString()}',
      );
      return false;
    }
  }

  /// Backup database
  /// TODO: Implement database backup
  Future<bool> backupDatabase() async {
    try {
      // TODO: Trigger database backup
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to backup database: ${e.toString()}',
      );
      return false;
    }
  }

  /// Refresh settings
  Future<void> refresh() async {
    await fetchSettings();
    await fetchSystemInfo();
  }
}

/// Provider for admin system state
final adminSystemProvider = StateNotifierProvider<AdminSystemNotifier, AdminSystemState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminSystemNotifier(apiClient);
});

/// Provider for all settings
final adminSystemSettingsProvider = Provider<Map<String, SystemSetting>>((ref) {
  final systemState = ref.watch(adminSystemProvider);
  return systemState.settings;
});

/// Provider for system info
final adminSystemInfoProvider = Provider<Map<String, dynamic>>((ref) {
  final systemState = ref.watch(adminSystemProvider);
  return systemState.systemInfo;
});

/// Provider for checking if system is loading
final adminSystemLoadingProvider = Provider<bool>((ref) {
  final systemState = ref.watch(adminSystemProvider);
  return systemState.isLoading;
});

/// Provider for system error
final adminSystemErrorProvider = Provider<String?>((ref) {
  final systemState = ref.watch(adminSystemProvider);
  return systemState.error;
});
