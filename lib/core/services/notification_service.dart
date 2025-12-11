import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_models.dart';
import '../api/api_client.dart';
import '../api/api_config.dart';

/// Service for managing notifications via Supabase
class NotificationService {
  final SupabaseClient _supabase;
  final ApiClient _apiClient;
  final _logger = Logger('NotificationService');

  NotificationService({
    SupabaseClient? supabase,
    required ApiClient apiClient,
  })  : _supabase = supabase ?? Supabase.instance.client,
        _apiClient = apiClient;

  /// Get notifications for current user with optional filters
  Future<NotificationsResponse> getNotifications({
    NotificationFilter? filter,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _logger.warning('Cannot fetch notifications - user not authenticated yet');
        // Return empty response instead of throwing - allows graceful retry
        return NotificationsResponse(
          notifications: [],
          totalCount: 0,
          unreadCount: 0,
          page: filter?.page ?? 1,
          limit: filter?.limit ?? 20,
          hasMore: false,
        );
      }

      // Start building query - use dynamic to handle type changes through the chain
      dynamic query = _supabase
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .isFilter('deleted_at', null);

      // Apply optional filters before ordering
      if (filter != null) {
        if (filter.isRead != null) {
          query = query.eq('is_read', filter.isRead!);
        }
        if (filter.isArchived != null) {
          query = query.eq('is_archived', filter.isArchived!);
        }
        if (filter.types != null && filter.types!.isNotEmpty) {
          query = query.inFilter(
            'type',
            filter.types!.map((t) => _notificationTypeToString(t)).toList(),
          );
        }
        if (filter.startDate != null) {
          query = query.gte('created_at', filter.startDate!.toIso8601String());
        }
        if (filter.endDate != null) {
          query = query.lte('created_at', filter.endDate!.toIso8601String());
        }
        if (filter.priority != null) {
          query = query.eq('priority', filter.priority!.index);
        }
      }

      // Apply ordering after all filters
      query = query.order('created_at', ascending: false);

      // Apply pagination
      if (filter != null) {
        final offset = (filter.page - 1) * filter.limit;
        query = query.range(offset, offset + filter.limit - 1);
      } else {
        query = query.range(0, 19);
      }

      final response = await query;
      final data = response as List;

      final notifications = data.map((json) {
        return AppNotification.fromJson({
          ...json,
          'user_id': json['user_id'],
        });
      }).toList();

      // Get total count
      final countResponse = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .isFilter('deleted_at', null);
      final count = (countResponse as List).length;

      // Get unread count separately
      final unreadCountResponse = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .isFilter('deleted_at', null);

      final unreadCount = (unreadCountResponse as List).length;

      final limit = filter?.limit ?? 20;
      final page = filter?.page ?? 1;
      final hasMore = (page * limit) < count;

      return NotificationsResponse(
        notifications: notifications,
        totalCount: count,
        unreadCount: unreadCount,
        page: page,
        limit: limit,
        hasMore: hasMore,
      );
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return 0;
      }

      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false)
          .isFilter('deleted_at', null);

      return (response as List).length;
    } catch (e) {
      _logger.warning('Error getting unread count: $e', e);
      return 0;
    }
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase.rpc('mark_notification_read', params: {
        'notification_id': notificationId,
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<int> markAllAsRead() async {
    try {
      final response = await _supabase.rpc('mark_all_notifications_read');
      return response as int? ?? 0;
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  /// Mark a notification as unread
  /// Pass [userId] from AuthService since Supabase auth doesn't work with custom JWTs
  Future<void> markAsUnread(String notificationId, {String? userId}) async {
    try {
      // Use provided userId or fall back to Supabase auth (won't work with custom JWT)
      final effectiveUserId = userId ?? _supabase.auth.currentUser?.id;
      if (effectiveUserId == null) {
        _logger.warning('Cannot mark notification as unread - no user ID provided');
        throw Exception('Please wait for the app to finish loading, then try again.');
      }

      await _supabase.from('notifications').update({
        'is_read': false,
        'read_at': null,
      }).eq('id', notificationId).eq('user_id', effectiveUserId);
    } catch (e) {
      throw Exception('Failed to mark notification as unread: $e');
    }
  }

  /// Archive a notification
  /// Pass [userId] from AuthService since Supabase auth doesn't work with custom JWTs
  Future<void> archiveNotification(String notificationId, {String? userId}) async {
    try {
      // Use provided userId or fall back to Supabase auth (won't work with custom JWT)
      final effectiveUserId = userId ?? _supabase.auth.currentUser?.id;
      if (effectiveUserId == null) {
        _logger.warning('Cannot archive notification - no user ID provided');
        throw Exception('Please wait for the app to finish loading, then try again.');
      }

      await _supabase.from('notifications').update({
        'is_archived': true,
        'archived_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId).eq('user_id', effectiveUserId);
    } catch (e) {
      throw Exception('Failed to archive notification: $e');
    }
  }

  /// Unarchive a notification
  /// Pass [userId] from AuthService since Supabase auth doesn't work with custom JWTs
  Future<void> unarchiveNotification(String notificationId, {String? userId}) async {
    try {
      // Use provided userId or fall back to Supabase auth (won't work with custom JWT)
      final effectiveUserId = userId ?? _supabase.auth.currentUser?.id;
      if (effectiveUserId == null) {
        _logger.warning('Cannot unarchive notification - no user ID provided');
        throw Exception('Please wait for the app to finish loading, then try again.');
      }

      await _supabase.from('notifications').update({
        'is_archived': false,
        'archived_at': null,
      }).eq('id', notificationId).eq('user_id', effectiveUserId);
    } catch (e) {
      throw Exception('Failed to unarchive notification: $e');
    }
  }

  /// Delete a notification (soft delete)
  /// Pass [userId] from AuthService since Supabase auth doesn't work with custom JWTs
  Future<void> deleteNotification(String notificationId, {String? userId}) async {
    try {
      // Use provided userId or fall back to Supabase auth (won't work with custom JWT)
      final effectiveUserId = userId ?? _supabase.auth.currentUser?.id;
      if (effectiveUserId == null) {
        _logger.warning('Cannot delete notification - no user ID provided');
        throw Exception('Please wait for the app to finish loading, then try again.');
      }

      await _supabase.from('notifications').update({
        'deleted_at': DateTime.now().toIso8601String(),
      }).eq('id', notificationId).eq('user_id', effectiveUserId);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  /// Create a notification (admin/system only, typically done server-side)
  Future<AppNotification> createNotification(
      CreateNotificationRequest request) async {
    try {
      final response = await _supabase.from('notifications').insert({
        'user_id': request.userId,
        'type': _notificationTypeToString(request.type),
        'title': request.title,
        'message': request.message,
        'metadata': request.metadata,
        'action_url': request.actionUrl,
        'priority': request.priority.index,
      }).select().single();

      return AppNotification.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  /// Get notification preferences for current user
  Future<List<NotificationPreference>> getPreferences() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        _logger.warning('Cannot fetch notification preferences - user not authenticated yet');
        // Return empty list instead of throwing - allows graceful retry
        return [];
      }

      final response = await _supabase
          .from('notification_preferences')
          .select()
          .eq('user_id', userId);

      final data = response as List;
      return data
          .map((json) => NotificationPreference.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notification preferences: $e');
    }
  }

  /// Update notification preference
  /// Pass [userId] from AuthService since Supabase auth doesn't work with custom JWTs
  Future<void> updatePreference(
      UpdateNotificationPreferencesRequest request, {String? userId}) async {
    try {
      // Use provided userId or fall back to Supabase auth (won't work with custom JWT)
      final effectiveUserId = userId ?? _supabase.auth.currentUser?.id;
      if (effectiveUserId == null) {
        _logger.warning('Cannot update notification preference - no user ID provided');
        throw Exception('Please wait for the app to finish loading, then try again.');
      }

      final updates = <String, dynamic>{};
      if (request.inAppEnabled != null) {
        updates['in_app_enabled'] = request.inAppEnabled;
      }
      if (request.emailEnabled != null) {
        updates['email_enabled'] = request.emailEnabled;
      }
      if (request.pushEnabled != null) {
        updates['push_enabled'] = request.pushEnabled;
      }
      if (request.quietHoursStart != null) {
        updates['quiet_hours_start'] = request.quietHoursStart;
      }
      if (request.quietHoursEnd != null) {
        updates['quiet_hours_end'] = request.quietHoursEnd;
      }

      if (updates.isEmpty) return;

      await _supabase
          .from('notification_preferences')
          .update(updates)
          .eq('user_id', effectiveUserId)
          .eq('notification_type',
              _notificationTypeToString(request.notificationType));
    } catch (e) {
      throw Exception('Failed to update notification preference: $e');
    }
  }

  /// Create default preferences for current user
  /// Uses backend API with service role to bypass RLS restrictions
  Future<void> createDefaultPreferences({String? userId}) async {
    try {
      // Call backend API endpoint which uses service role (bypasses RLS)
      final response = await _apiClient.post('${ApiConfig.notifications}/preferences/defaults');

      if (!response.success) {
        throw Exception(response.message ?? 'Failed to create default preferences');
      }

      _logger.info('Successfully created default notification preferences via backend API');
    } catch (e) {
      _logger.severe('Failed to create default preferences: $e');
      throw Exception('Failed to create default preferences: $e');
    }
  }

  /// Subscribe to real-time notification updates
  RealtimeChannel? subscribeToNotifications(
      void Function(AppNotification) onNotification) {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _logger.warning('Cannot subscribe to notifications - user not authenticated yet');
      return null;
    }

    final channel = _supabase
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            try {
              final notification =
                  AppNotification.fromJson(payload.newRecord);
              onNotification(notification);
            } catch (e) {
              _logger.warning('Error parsing notification: $e', e);
            }
          },
        )
        .subscribe();

    return channel;
  }

  /// Unsubscribe from real-time updates
  Future<void> unsubscribe(RealtimeChannel channel) async {
    await _supabase.removeChannel(channel);
  }

  /// Helper to convert NotificationType to string for database
  String _notificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.applicationStatus:
        return 'application_status';
      case NotificationType.gradePosted:
        return 'grade_posted';
      case NotificationType.messageReceived:
        return 'message_received';
      case NotificationType.meetingScheduled:
        return 'meeting_scheduled';
      case NotificationType.meetingReminder:
        return 'meeting_reminder';
      case NotificationType.achievementEarned:
        return 'achievement_earned';
      case NotificationType.deadlineReminder:
        return 'deadline_reminder';
      case NotificationType.recommendationReady:
        return 'recommendation_ready';
      case NotificationType.systemAnnouncement:
        return 'system_announcement';
      case NotificationType.commentReceived:
        return 'comment_received';
      case NotificationType.mention:
        return 'mention';
      case NotificationType.eventReminder:
        return 'event_reminder';
    }
  }
}
