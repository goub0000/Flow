import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

/// Notification Preferences Screen
///
/// Allows users to customize notification settings:
/// - Push notifications on/off
/// - Email notifications on/off
/// - Notification types (courses, applications, payments, etc.)
/// - Quiet hours
/// - Notification sounds
///
/// Backend Integration TODO:
/// ```dart
/// // Save preferences to backend
/// import 'package:dio/dio.dart';
/// import 'package:shared_preferences/shared_preferences.dart';
///
/// class NotificationPreferencesService {
///   final Dio _dio;
///
///   Future<NotificationPreferences> getPreferences() async {
///     final response = await _dio.get('/api/user/notification-preferences');
///     return NotificationPreferences.fromJson(response.data);
///   }
///
///   Future<void> updatePreferences(NotificationPreferences prefs) async {
///     await _dio.put('/api/user/notification-preferences', data: prefs.toJson());
///
///     // Also save locally
///     final localPrefs = await SharedPreferences.getInstance();
///     await localPrefs.setString('notification_prefs', jsonEncode(prefs.toJson()));
///   }
///
///   Future<void> updatePushToken(String token) async {
///     await _dio.post('/api/user/push-token', data: {'token': token});
///   }
/// }
///
/// // Test notification
/// import 'package:firebase_messaging/firebase_messaging.dart';
///
/// Future<void> sendTestNotification() async {
///   await _dio.post('/api/notifications/test', data: {
///     'userId': currentUserId,
///     'title': 'Test Notification',
///     'body': 'This is a test notification',
///   });
/// }
/// ```

/// Notification Preferences Model
class NotificationPreferences {
  bool pushEnabled;
  bool emailEnabled;
  bool smsEnabled;

  // Notification types
  bool coursesEnabled;
  bool applicationsEnabled;
  bool paymentsEnabled;
  bool messagesEnabled;
  bool announcementsEnabled;
  bool remindersEnabled;
  bool achievementsEnabled;

  // Sound & vibration
  bool soundEnabled;
  bool vibrationEnabled;

  // Quiet hours
  bool quietHoursEnabled;
  TimeOfDay quietHoursStart;
  TimeOfDay quietHoursEnd;

  NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.smsEnabled = false,
    this.coursesEnabled = true,
    this.applicationsEnabled = true,
    this.paymentsEnabled = true,
    this.messagesEnabled = true,
    this.announcementsEnabled = true,
    this.remindersEnabled = true,
    this.achievementsEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.quietHoursEnabled = false,
    this.quietHoursStart = const TimeOfDay(hour: 22, minute: 0),
    this.quietHoursEnd = const TimeOfDay(hour: 7, minute: 0),
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushEnabled: json['pushEnabled'] ?? true,
      emailEnabled: json['emailEnabled'] ?? true,
      smsEnabled: json['smsEnabled'] ?? false,
      coursesEnabled: json['coursesEnabled'] ?? true,
      applicationsEnabled: json['applicationsEnabled'] ?? true,
      paymentsEnabled: json['paymentsEnabled'] ?? true,
      messagesEnabled: json['messagesEnabled'] ?? true,
      announcementsEnabled: json['announcementsEnabled'] ?? true,
      remindersEnabled: json['remindersEnabled'] ?? true,
      achievementsEnabled: json['achievementsEnabled'] ?? true,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      quietHoursEnabled: json['quietHoursEnabled'] ?? false,
      quietHoursStart: _timeOfDayFromString(json['quietHoursStart']),
      quietHoursEnd: _timeOfDayFromString(json['quietHoursEnd']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'smsEnabled': smsEnabled,
      'coursesEnabled': coursesEnabled,
      'applicationsEnabled': applicationsEnabled,
      'paymentsEnabled': paymentsEnabled,
      'messagesEnabled': messagesEnabled,
      'announcementsEnabled': announcementsEnabled,
      'remindersEnabled': remindersEnabled,
      'achievementsEnabled': achievementsEnabled,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': _timeOfDayToString(quietHoursStart),
      'quietHoursEnd': _timeOfDayToString(quietHoursEnd),
    };
  }

  static TimeOfDay _timeOfDayFromString(String? time) {
    if (time == null) return const TimeOfDay(hour: 22, minute: 0);
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  late NotificationPreferences _preferences;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _preferences = NotificationPreferences();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Load from backend
      // final prefs = await NotificationPreferencesService().getPreferences();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          // Use default preferences for now
          _preferences = NotificationPreferences();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load preferences: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _savePreferences() async {
    setState(() => _isSaving = true);

    try {
      // TODO: Save to backend
      // await NotificationPreferencesService().updatePreferences(_preferences);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preferences saved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save preferences: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _sendTestNotification() async {
    try {
      // TODO: Send test notification
      // await NotificationPreferencesService().sendTestNotification();

      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Test notification sent!'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send test: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notification Preferences'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Notification Preferences'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _savePreferences,
              child: const Text('Save'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Delivery Methods
          _buildSectionTitle('Delivery Methods'),
          _buildSwitchTile(
            title: 'Push Notifications',
            subtitle: 'Receive notifications on this device',
            value: _preferences.pushEnabled,
            icon: Icons.notifications_active,
            onChanged: (value) {
              setState(() => _preferences.pushEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Email Notifications',
            subtitle: 'Receive notifications via email',
            value: _preferences.emailEnabled,
            icon: Icons.email,
            onChanged: (value) {
              setState(() => _preferences.emailEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'SMS Notifications',
            subtitle: 'Receive important updates via SMS',
            value: _preferences.smsEnabled,
            icon: Icons.sms,
            onChanged: (value) {
              setState(() => _preferences.smsEnabled = value);
            },
          ),
          const SizedBox(height: 24),

          // Notification Types
          _buildSectionTitle('Notification Types'),
          _buildSwitchTile(
            title: 'Courses',
            subtitle: 'New courses, enrollments, and updates',
            value: _preferences.coursesEnabled,
            icon: Icons.school,
            onChanged: (value) {
              setState(() => _preferences.coursesEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Applications',
            subtitle: 'Application status and deadlines',
            value: _preferences.applicationsEnabled,
            icon: Icons.description,
            onChanged: (value) {
              setState(() => _preferences.applicationsEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Payments',
            subtitle: 'Payment confirmations and receipts',
            value: _preferences.paymentsEnabled,
            icon: Icons.payment,
            onChanged: (value) {
              setState(() => _preferences.paymentsEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Messages',
            subtitle: 'New messages from counselors and institutions',
            value: _preferences.messagesEnabled,
            icon: Icons.message,
            onChanged: (value) {
              setState(() => _preferences.messagesEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Announcements',
            subtitle: 'Important updates and news',
            value: _preferences.announcementsEnabled,
            icon: Icons.campaign,
            onChanged: (value) {
              setState(() => _preferences.announcementsEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Reminders',
            subtitle: 'Upcoming events and deadlines',
            value: _preferences.remindersEnabled,
            icon: Icons.alarm,
            onChanged: (value) {
              setState(() => _preferences.remindersEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Achievements',
            subtitle: 'Course completions and milestones',
            value: _preferences.achievementsEnabled,
            icon: Icons.emoji_events,
            onChanged: (value) {
              setState(() => _preferences.achievementsEnabled = value);
            },
          ),
          const SizedBox(height: 24),

          // Sound & Vibration
          _buildSectionTitle('Sound & Vibration'),
          _buildSwitchTile(
            title: 'Sound',
            subtitle: 'Play sound for notifications',
            value: _preferences.soundEnabled,
            icon: Icons.volume_up,
            onChanged: (value) {
              setState(() => _preferences.soundEnabled = value);
            },
          ),
          _buildSwitchTile(
            title: 'Vibration',
            subtitle: 'Vibrate for notifications',
            value: _preferences.vibrationEnabled,
            icon: Icons.vibration,
            onChanged: (value) {
              setState(() => _preferences.vibrationEnabled = value);
            },
          ),
          const SizedBox(height: 24),

          // Quiet Hours
          _buildSectionTitle('Quiet Hours'),
          _buildSwitchTile(
            title: 'Enable Quiet Hours',
            subtitle: 'Mute notifications during specific hours',
            value: _preferences.quietHoursEnabled,
            icon: Icons.bedtime,
            onChanged: (value) {
              setState(() => _preferences.quietHoursEnabled = value);
            },
          ),
          if (_preferences.quietHoursEnabled) ...[
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Start Time'),
              subtitle: Text(_formatTimeOfDay(_preferences.quietHoursStart)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _preferences.quietHoursStart,
                );
                if (time != null) {
                  setState(() => _preferences.quietHoursStart = time);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('End Time'),
              subtitle: Text(_formatTimeOfDay(_preferences.quietHoursEnd)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _preferences.quietHoursEnd,
                );
                if (time != null) {
                  setState(() => _preferences.quietHoursEnd = time);
                }
              },
            ),
          ],
          const SizedBox(height: 24),

          // Test Notification
          _buildSectionTitle('Testing'),
          OutlinedButton.icon(
            onPressed: _sendTestNotification,
            icon: const Icon(Icons.send),
            label: const Text('Send Test Notification'),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a test notification to verify your settings',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
