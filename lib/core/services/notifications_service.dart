/// Notifications Service
/// Handles push notifications and in-app notifications
library;

import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';
import '../models/notification_model.dart';

enum NotificationType {
  application,
  course,
  payment,
  alert,
  message,
  enrollment,
  counseling,
  achievement,
}

extension NotificationTypeExtension on NotificationType {
  String get value => name;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.name == value.toLowerCase(),
      orElse: () => NotificationType.alert,
    );
  }
}

class NotificationPreferences {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final Map<NotificationType, bool> typePreferences;

  NotificationPreferences({
    this.emailNotifications = true,
    this.pushNotifications = true,
    this.smsNotifications = false,
    this.typePreferences = const {},
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> prefs = json['type_preferences'] ?? {};
    final typePrefs = <NotificationType, bool>{};

    prefs.forEach((key, value) {
      final type = NotificationTypeExtension.fromString(key);
      typePrefs[type] = value as bool;
    });

    return NotificationPreferences(
      emailNotifications: json['email_notifications'] ?? true,
      pushNotifications: json['push_notifications'] ?? true,
      smsNotifications: json['sms_notifications'] ?? false,
      typePreferences: typePrefs,
    );
  }

  Map<String, dynamic> toJson() {
    final typePrefsJson = <String, bool>{};
    typePreferences.forEach((key, value) {
      typePrefsJson[key.value] = value;
    });

    return {
      'email_notifications': emailNotifications,
      'push_notifications': pushNotifications,
      'sms_notifications': smsNotifications,
      'type_preferences': typePrefsJson,
    };
  }
}

class NotificationsService {
  final ApiClient _apiClient;

  NotificationsService(this._apiClient);

  /// Get notifications for current user
  Future<ApiResponse<PaginatedResponse<NotificationModel>>> getNotifications({
    int page = 1,
    int pageSize = 20,
    bool unreadOnly = false,
    NotificationType? type,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (unreadOnly) 'unread_only': unreadOnly,
      if (type != null) 'type': type.value,
    };

    return await _apiClient.get(
      ApiConfig.notifications,
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => NotificationModel.fromJson(json),
      ),
    );
  }

  /// Get notification by ID
  Future<ApiResponse<NotificationModel>> getNotificationById(
      String notificationId) async {
    return await _apiClient.get(
      '${ApiConfig.notifications}/$notificationId',
      fromJson: (data) => NotificationModel.fromJson(data),
    );
  }

  /// Mark notification as read
  Future<ApiResponse<NotificationModel>> markAsRead(String notificationId) async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/$notificationId/read',
      fromJson: (data) => NotificationModel.fromJson(data),
    );
  }

  /// Mark all notifications as read
  Future<ApiResponse<void>> markAllAsRead() async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/mark-all-read',
    );
  }

  /// Delete notification
  Future<ApiResponse<void>> deleteNotification(String notificationId) async {
    return await _apiClient.delete(
      '${ApiConfig.notifications}/$notificationId',
    );
  }

  /// Delete all read notifications
  Future<ApiResponse<void>> deleteAllRead() async {
    return await _apiClient.delete(
      '${ApiConfig.notifications}/read',
    );
  }

  /// Get unread notifications count
  Future<ApiResponse<Map<String, dynamic>>> getUnreadCount() async {
    return await _apiClient.get(
      '${ApiConfig.notifications}/unread-count',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Get notification preferences
  Future<ApiResponse<NotificationPreferences>> getPreferences() async {
    return await _apiClient.get(
      '${ApiConfig.notifications}/preferences',
      fromJson: (data) => NotificationPreferences.fromJson(data),
    );
  }

  /// Update notification preferences
  Future<ApiResponse<NotificationPreferences>> updatePreferences({
    bool? emailNotifications,
    bool? pushNotifications,
    bool? smsNotifications,
    Map<NotificationType, bool>? typePreferences,
  }) async {
    final typePrefsJson = <String, bool>{};
    typePreferences?.forEach((key, value) {
      typePrefsJson[key.value] = value;
    });

    return await _apiClient.patch(
      '${ApiConfig.notifications}/preferences',
      data: {
        if (emailNotifications != null)
          'email_notifications': emailNotifications,
        if (pushNotifications != null)
          'push_notifications': pushNotifications,
        if (smsNotifications != null) 'sms_notifications': smsNotifications,
        if (typePreferences != null) 'type_preferences': typePrefsJson,
      },
      fromJson: (data) => NotificationPreferences.fromJson(data),
    );
  }

  /// Register device for push notifications
  Future<ApiResponse<void>> registerDevice({
    required String deviceToken,
    required String platform, // 'android', 'ios', 'web'
    String? deviceName,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/devices',
      data: {
        'device_token': deviceToken,
        'platform': platform,
        if (deviceName != null) 'device_name': deviceName,
      },
    );
  }

  /// Unregister device from push notifications
  Future<ApiResponse<void>> unregisterDevice(String deviceToken) async {
    return await _apiClient.delete(
      '${ApiConfig.notifications}/devices/$deviceToken',
    );
  }

  /// Test push notification
  Future<ApiResponse<void>> testPushNotification() async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/test',
    );
  }

  /// Get notification statistics
  Future<ApiResponse<Map<String, dynamic>>> getNotificationStats() async {
    return await _apiClient.get(
      '${ApiConfig.notifications}/stats',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Snooze notification (hide for a period)
  Future<ApiResponse<void>> snoozeNotification({
    required String notificationId,
    required Duration duration,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/$notificationId/snooze',
      data: {
        'duration_minutes': duration.inMinutes,
      },
    );
  }

  /// Get snoozed notifications
  Future<ApiResponse<List<NotificationModel>>> getSnoozedNotifications() async {
    return await _apiClient.get(
      '${ApiConfig.notifications}/snoozed',
      fromJson: (data) {
        final List<dynamic> list = data;
        return list.map((json) => NotificationModel.fromJson(json)).toList();
      },
    );
  }

  /// Batch mark notifications as read
  Future<ApiResponse<void>> batchMarkAsRead(List<String> notificationIds) async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/batch-read',
      data: {
        'notification_ids': notificationIds,
      },
    );
  }

  /// Batch delete notifications
  Future<ApiResponse<void>> batchDelete(List<String> notificationIds) async {
    return await _apiClient.post(
      '${ApiConfig.notifications}/batch-delete',
      data: {
        'notification_ids': notificationIds,
      },
    );
  }
}
