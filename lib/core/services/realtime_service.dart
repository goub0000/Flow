/// Realtime Service
/// Handles Supabase Realtime subscriptions for live updates

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';

class RealtimeService {
  final SupabaseClient _supabase;

  // Stream controllers for different real-time events
  final _messagesController = StreamController<Message>.broadcast();
  final _notificationsController = StreamController<NotificationModel>.broadcast();
  final _typingController = StreamController<Map<String, dynamic>>.broadcast();

  // Active subscriptions
  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _notificationsChannel;
  RealtimeChannel? _typingChannel;

  RealtimeService(this._supabase);

  /// Message stream
  Stream<Message> get messagesStream => _messagesController.stream;

  /// Notification stream
  Stream<NotificationModel> get notificationsStream => _notificationsController.stream;

  /// Typing indicator stream
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;

  /// Subscribe to messages for a specific conversation
  Future<void> subscribeToConversation(String conversationId) async {
    // Unsubscribe from previous conversation
    await unsubscribeFromMessages();

    try {
      _messagesChannel = _supabase
          .channel('messages:$conversationId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'conversation_id',
              value: conversationId,
            ),
            callback: (payload) {
              final data = payload.newRecord;
              try {
                final message = Message.fromJson(data);
                _messagesController.add(message);
              } catch (e) {
                print('Error parsing message: $e');
              }
            },
          )
          .subscribe();

      print('Subscribed to conversation: $conversationId');
    } catch (e) {
      print('Error subscribing to conversation: $e');
    }
  }

  /// Subscribe to typing indicators for a conversation
  Future<void> subscribeToTyping(String conversationId) async {
    await unsubscribeFromTyping();

    try {
      _typingChannel = _supabase
          .channel('typing:$conversationId')
          .onBroadcast(
            event: 'typing',
            callback: (payload) {
              _typingController.add(payload);
            },
          )
          .subscribe();

      print('Subscribed to typing indicators: $conversationId');
    } catch (e) {
      print('Error subscribing to typing: $e');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator({
    required String conversationId,
    required String userId,
    required String userName,
    required bool isTyping,
  }) async {
    if (_typingChannel == null) return;

    try {
      await _typingChannel!.sendBroadcastMessage(
        event: 'typing',
        payload: {
          'user_id': userId,
          'user_name': userName,
          'is_typing': isTyping,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      print('Error sending typing indicator: $e');
    }
  }

  /// Subscribe to notifications for current user
  Future<void> subscribeToNotifications(String userId) async {
    await unsubscribeFromNotifications();

    try {
      _notificationsChannel = _supabase
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
              final data = payload.newRecord;
              try {
                final notification = NotificationModel.fromJson(data);
                _notificationsController.add(notification);
              } catch (e) {
                print('Error parsing notification: $e');
              }
            },
          )
          .subscribe();

      print('Subscribed to notifications for user: $userId');
    } catch (e) {
      print('Error subscribing to notifications: $e');
    }
  }

  /// Subscribe to presence (online/offline status)
  /// Note: Presence API requires additional Supabase configuration
  Future<void> subscribeToPresence(String roomId) async {
    try {
      // TODO: Implement presence tracking when needed
      // Presence tracking requires specific Supabase realtime configuration
      print('Presence tracking not yet implemented for room: $roomId');
    } catch (e) {
      print('Error subscribing to presence: $e');
    }
  }

  /// Unsubscribe from messages
  Future<void> unsubscribeFromMessages() async {
    if (_messagesChannel != null) {
      await _supabase.removeChannel(_messagesChannel!);
      _messagesChannel = null;
      print('Unsubscribed from messages');
    }
  }

  /// Unsubscribe from notifications
  Future<void> unsubscribeFromNotifications() async {
    if (_notificationsChannel != null) {
      await _supabase.removeChannel(_notificationsChannel!);
      _notificationsChannel = null;
      print('Unsubscribed from notifications');
    }
  }

  /// Unsubscribe from typing indicators
  Future<void> unsubscribeFromTyping() async {
    if (_typingChannel != null) {
      await _supabase.removeChannel(_typingChannel!);
      _typingChannel = null;
      print('Unsubscribed from typing');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    await unsubscribeFromMessages();
    await unsubscribeFromNotifications();
    await unsubscribeFromTyping();
  }

  /// Dispose resources
  void dispose() {
    unsubscribeAll();
    _messagesController.close();
    _notificationsController.close();
    _typingController.close();
  }
}
