/// Messaging Real-Time Provider
/// Manages real-time subscriptions for conversations and messages

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/enhanced_realtime_service.dart';

/// State class for real-time conversation
class RealtimeConversationState {
  final Conversation? conversation;
  final List<Message> messages;
  final Map<String, bool> typingUsers; // userId -> isTyping
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final DateTime? lastUpdate;
  final Message? latestMessage;

  const RealtimeConversationState({
    this.conversation,
    this.messages = const [],
    this.typingUsers = const {},
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.lastUpdate,
    this.latestMessage,
  });

  RealtimeConversationState copyWith({
    Conversation? conversation,
    List<Message>? messages,
    Map<String, bool>? typingUsers,
    bool? isLoading,
    bool? isConnected,
    String? error,
    DateTime? lastUpdate,
    Message? latestMessage,
  }) {
    return RealtimeConversationState(
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      latestMessage: latestMessage ?? this.latestMessage,
    );
  }

  /// Get unread messages for current user
  List<Message> getUnreadMessages(String currentUserId) {
    return messages.where((m) =>
      m.senderId != currentUserId && !m.isReadBy(currentUserId)
    ).toList();
  }

  /// Get users who are currently typing (excluding current user)
  List<String> getTypingUsers(String currentUserId) {
    return typingUsers.entries
        .where((e) => e.value && e.key != currentUserId)
        .map((e) => e.key)
        .toList();
  }
}

/// StateNotifier for managing real-time conversation
class ConversationRealtimeNotifier extends StateNotifier<RealtimeConversationState> {
  final String conversationId;
  final Ref ref;
  final EnhancedRealtimeService _realtimeService;
  final SupabaseClient _supabase;

  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _conversationChannel;
  RealtimeChannel? _typingChannel;
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  Timer? _typingCleanupTimer;
  Timer? _readReceiptTimer;

  ConversationRealtimeNotifier(
    this.conversationId,
    this.ref,
    this._realtimeService,
    this._supabase,
  ) : super(const RealtimeConversationState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchConversationAndMessages();

    // Setup real-time subscriptions
    _setupMessageSubscription();
    _setupConversationSubscription();
    _setupTypingSubscription();

    // Monitor connection status
    _monitorConnectionStatus();

    // Setup periodic typing cleanup
    _setupTypingCleanup();

    // Setup auto-read receipts
    _setupAutoReadReceipts();
  }

  /// Fetch conversation and messages from database
  Future<void> _fetchConversationAndMessages() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isLoading: false,
        );
        return;
      }

      print('[RealtimeMessaging] Fetching conversation: $conversationId');

      // Fetch conversation
      final conversationResponse = await _supabase
          .from('conversations')
          .select('*')
          .eq('id', conversationId)
          .single();

      final conversation = Conversation.fromJson(conversationResponse);

      // Fetch messages
      final messagesResponse = await _supabase
          .from('messages')
          .select('*')
          .eq('conversation_id', conversationId)
          .order('timestamp', ascending: true)
          .limit(100); // Last 100 messages

      final messages = (messagesResponse as List<dynamic>)
          .map((json) => Message.fromJson(json))
          .toList();

      state = state.copyWith(
        conversation: conversation,
        messages: messages,
        isLoading: false,
        lastUpdate: DateTime.now(),
      );

      print('[RealtimeMessaging] Fetched ${messages.length} messages');

      // Mark unread messages as read
      _markMessagesAsRead();

    } catch (e) {
      print('[RealtimeMessaging] Error fetching: $e');
      state = state.copyWith(
        error: 'Failed to fetch conversation: $e',
        isLoading: false,
      );
    }
  }

  /// Setup real-time subscription for messages
  void _setupMessageSubscription() {
    final channelName = 'conversation_messages_$conversationId';

    print('[RealtimeMessaging] Setting up messages subscription');

    _messagesChannel = _realtimeService.subscribeToTable(
      table: 'messages',
      channelName: channelName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      onInsert: _handleMessageInsert,
      onUpdate: _handleMessageUpdate,
      onDelete: _handleMessageDelete,
      onError: (error) {
        print('[RealtimeMessaging] Messages subscription error: $error');
        state = state.copyWith(error: error);
      },
    );
  }

  /// Setup real-time subscription for conversation updates
  void _setupConversationSubscription() {
    final channelName = 'conversation_update_$conversationId';

    print('[RealtimeMessaging] Setting up conversation subscription');

    _conversationChannel = _realtimeService.subscribeToRecord(
      table: 'conversations',
      channelName: channelName,
      recordId: conversationId,
      onUpdate: _handleConversationUpdate,
      onError: (error) {
        print('[RealtimeMessaging] Conversation subscription error: $error');
      },
    );
  }

  /// Setup real-time subscription for typing indicators
  void _setupTypingSubscription() {
    final channelName = 'conversation_typing_$conversationId';

    print('[RealtimeMessaging] Setting up typing subscription');

    _typingChannel = _realtimeService.subscribeToTable(
      table: 'typing_indicators',
      channelName: channelName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'conversation_id',
        value: conversationId,
      ),
      onInsert: _handleTypingInsert,
      onUpdate: _handleTypingUpdate,
      onDelete: _handleTypingDelete,
      onError: (error) {
        print('[RealtimeMessaging] Typing subscription error: $error');
      },
    );
  }

  /// Handle new message
  void _handleMessageInsert(Map<String, dynamic> payload) {
    try {
      print('[RealtimeMessaging] New message inserted: ${payload['id']}');

      final newMessage = Message.fromJson(payload);
      final updatedMessages = [...state.messages, newMessage];

      state = state.copyWith(
        messages: updatedMessages,
        lastUpdate: DateTime.now(),
        latestMessage: newMessage,
      );

      // Auto-mark as read if from another user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser != null && newMessage.senderId != currentUser.id) {
        _markMessagesAsRead();
      }

    } catch (e) {
      print('[RealtimeMessaging] Error handling message insert: $e');
    }
  }

  /// Handle message update (edited, read receipts, etc.)
  void _handleMessageUpdate(Map<String, dynamic> payload) {
    try {
      print('[RealtimeMessaging] Message updated: ${payload['id']}');

      final updatedMessage = Message.fromJson(payload);
      final updatedMessages = state.messages.map((message) {
        if (message.id == updatedMessage.id) {
          return updatedMessage;
        }
        return message;
      }).toList();

      state = state.copyWith(
        messages: updatedMessages,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      print('[RealtimeMessaging] Error handling message update: $e');
    }
  }

  /// Handle message delete
  void _handleMessageDelete(Map<String, dynamic> payload) {
    try {
      print('[RealtimeMessaging] Message deleted: ${payload['id']}');

      final deletedId = payload['id'] as String;
      final updatedMessages = state.messages
          .where((message) => message.id != deletedId)
          .toList();

      state = state.copyWith(
        messages: updatedMessages,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      print('[RealtimeMessaging] Error handling message delete: $e');
    }
  }

  /// Handle conversation update
  void _handleConversationUpdate(Map<String, dynamic> payload) {
    try {
      print('[RealtimeMessaging] Conversation updated');

      final updatedConversation = Conversation.fromJson(payload);

      state = state.copyWith(
        conversation: updatedConversation,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      print('[RealtimeMessaging] Error handling conversation update: $e');
    }
  }

  /// Handle typing indicator insert
  void _handleTypingInsert(Map<String, dynamic> payload) {
    try {
      final userId = payload['user_id'] as String;
      final isTyping = payload['is_typing'] as bool? ?? true;

      print('[RealtimeMessaging] User $userId typing: $isTyping');

      final updatedTypingUsers = Map<String, bool>.from(state.typingUsers);
      updatedTypingUsers[userId] = isTyping;

      state = state.copyWith(typingUsers: updatedTypingUsers);

    } catch (e) {
      print('[RealtimeMessaging] Error handling typing insert: $e');
    }
  }

  /// Handle typing indicator update
  void _handleTypingUpdate(Map<String, dynamic> payload) {
    _handleTypingInsert(payload); // Same logic
  }

  /// Handle typing indicator delete
  void _handleTypingDelete(Map<String, dynamic> payload) {
    try {
      final userId = payload['user_id'] as String;

      print('[RealtimeMessaging] User $userId stopped typing');

      final updatedTypingUsers = Map<String, bool>.from(state.typingUsers);
      updatedTypingUsers.remove(userId);

      state = state.copyWith(typingUsers: updatedTypingUsers);

    } catch (e) {
      print('[RealtimeMessaging] Error handling typing delete: $e');
    }
  }

  /// Setup periodic typing indicators cleanup
  void _setupTypingCleanup() {
    _typingCleanupTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      // Remove typing indicators that haven't been updated
      final updatedTypingUsers = Map<String, bool>.from(state.typingUsers);
      updatedTypingUsers.removeWhere((_, isTyping) => !isTyping);

      if (updatedTypingUsers.length != state.typingUsers.length) {
        state = state.copyWith(typingUsers: updatedTypingUsers);
      }
    });
  }

  /// Setup auto read receipts
  void _setupAutoReadReceipts() {
    // Mark messages as read after 2 seconds of viewing
    _readReceiptTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _markMessagesAsRead();
    });
  }

  /// Mark unread messages as read
  Future<void> _markMessagesAsRead() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final unreadMessages = state.getUnreadMessages(user.id);
      if (unreadMessages.isEmpty) return;

      final messageIds = unreadMessages.map((m) => m.id).toList();

      print('[RealtimeMessaging] Marking ${messageIds.length} messages as read');

      // Update in database - add user to read_by array
      for (final messageId in messageIds) {
        await _supabase
            .from('messages')
            .update({
              'read_by': [...unreadMessages.firstWhere((m) => m.id == messageId).readBy, user.id],
              'read_at': DateTime.now().toIso8601String(),
            })
            .eq('id', messageId);
      }

    } catch (e) {
      print('[RealtimeMessaging] Error marking messages as read: $e');
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(bool isTyping) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      await _supabase
          .from('typing_indicators')
          .upsert({
            'conversation_id': conversationId,
            'user_id': user.id,
            'is_typing': isTyping,
            'expires_at': DateTime.now().add(const Duration(seconds: 10)).toIso8601String(),
          });

    } catch (e) {
      print('[RealtimeMessaging] Error sending typing indicator: $e');
    }
  }

  /// Send message
  Future<Message?> sendMessage(String content, {MessageType type = MessageType.text}) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return null;

      final response = await _supabase
          .from('messages')
          .insert({
            'conversation_id': conversationId,
            'sender_id': user.id,
            'content': content,
            'message_type': type.toJson(),
            'timestamp': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return Message.fromJson(response);

    } catch (e) {
      print('[RealtimeMessaging] Error sending message: $e');
      state = state.copyWith(error: 'Failed to send message: $e');
      return null;
    }
  }

  /// Monitor connection status
  void _monitorConnectionStatus() {
    _connectionSubscription = _realtimeService.connectionStatus.listen((status) {
      final isConnected = status == ConnectionStatus.connected;
      state = state.copyWith(isConnected: isConnected);

      if (status == ConnectionStatus.connected && state.lastUpdate == null) {
        // First connection - fetch data
        _fetchConversationAndMessages();
      }
    });
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchConversationAndMessages();
  }

  @override
  void dispose() {
    // Clean up subscriptions
    _realtimeService.unsubscribe('conversation_messages_$conversationId');
    _realtimeService.unsubscribe('conversation_update_$conversationId');
    _realtimeService.unsubscribe('conversation_typing_$conversationId');

    _connectionSubscription?.cancel();
    _typingCleanupTimer?.cancel();
    _readReceiptTimer?.cancel();

    super.dispose();
  }
}

/// Provider family for real-time conversation
final conversationRealtimeProvider = StateNotifierProvider.family.autoDispose<
    ConversationRealtimeNotifier, RealtimeConversationState, String>((ref, conversationId) {
  final realtimeService = ref.watch(enhancedRealtimeServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return ConversationRealtimeNotifier(conversationId, ref, realtimeService, supabase);
});

/// Provider for messages in a conversation
final conversationMessagesProvider = Provider.family.autoDispose<List<Message>, String>((ref, conversationId) {
  final state = ref.watch(conversationRealtimeProvider(conversationId));
  return state.messages;
});

/// Provider for typing users in a conversation
final typingUsersProvider = Provider.family.autoDispose<List<String>, String>((ref, conversationId) {
  final state = ref.watch(conversationRealtimeProvider(conversationId));
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];
  return state.getTypingUsers(user.id);
});

/// Provider for connection status
final conversationConnectionStatusProvider = Provider.family.autoDispose<bool, String>((ref, conversationId) {
  final state = ref.watch(conversationRealtimeProvider(conversationId));
  return state.isConnected;
});
