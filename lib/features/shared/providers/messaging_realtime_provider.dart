/// Messaging Real-Time Provider
/// Manages messages within conversations via backend API with periodic refresh

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/messaging_service.dart';

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

/// StateNotifier for managing conversation messages via backend API
class ConversationRealtimeNotifier extends StateNotifier<RealtimeConversationState> {
  final String conversationId;
  final Ref ref;
  final MessagingService _messagingService;

  Timer? _refreshTimer;

  ConversationRealtimeNotifier(
    this.conversationId,
    this.ref,
    this._messagingService,
  ) : super(const RealtimeConversationState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchConversationAndMessages();

    // Setup periodic refresh (every 3 seconds for near-realtime chat)
    _setupPeriodicRefresh();
  }

  /// Fetch conversation and messages from backend API
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
      final conversationResponse = await _messagingService.getConversationById(conversationId);

      if (!conversationResponse.success || conversationResponse.data == null) {
        state = state.copyWith(
          error: conversationResponse.message ?? 'Failed to fetch conversation',
          isLoading: false,
          isConnected: false,
        );
        return;
      }

      final conversation = conversationResponse.data!;

      // Fetch messages
      final messagesResponse = await _messagingService.getMessages(
        conversationId: conversationId,
        page: 1,
        pageSize: 100,
      );

      List<Message> messages = [];
      if (messagesResponse.success && messagesResponse.data != null) {
        messages = messagesResponse.data!.items;
      }

      state = state.copyWith(
        conversation: conversation,
        messages: messages,
        isLoading: false,
        isConnected: true,
        lastUpdate: DateTime.now(),
      );

      print('[RealtimeMessaging] Fetched ${messages.length} messages');

      // Mark conversation as read
      _markConversationAsRead();

    } catch (e) {
      print('[RealtimeMessaging] Error fetching: $e');
      state = state.copyWith(
        error: 'Failed to fetch conversation: $e',
        isLoading: false,
        isConnected: false,
      );
    }
  }

  /// Setup periodic refresh for near-realtime chat updates
  void _setupPeriodicRefresh() {
    // Refresh every 3 seconds for chat (more frequent than conversations list)
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _fetchMessages(); // Only fetch messages, not full conversation
    });
  }

  /// Fetch only messages (for periodic refresh)
  Future<void> _fetchMessages() async {
    try {
      final messagesResponse = await _messagingService.getMessages(
        conversationId: conversationId,
        page: 1,
        pageSize: 100,
      );

      if (messagesResponse.success && messagesResponse.data != null) {
        final messages = messagesResponse.data!.items;

        // Check if there are new messages
        if (messages.length != state.messages.length ||
            (messages.isNotEmpty && state.messages.isNotEmpty &&
             messages.last.id != state.messages.last.id)) {
          state = state.copyWith(
            messages: messages,
            lastUpdate: DateTime.now(),
            latestMessage: messages.isNotEmpty ? messages.last : null,
          );
        }
      }
    } catch (e) {
      print('[RealtimeMessaging] Error fetching messages: $e');
    }
  }

  /// Mark conversation as read via backend API
  Future<void> _markConversationAsRead() async {
    try {
      await _messagingService.markConversationAsRead(conversationId);
      print('[RealtimeMessaging] Marked conversation as read');
    } catch (e) {
      print('[RealtimeMessaging] Error marking conversation as read: $e');
    }
  }

  /// Send typing indicator via backend API
  Future<void> sendTypingIndicator(bool isTyping) async {
    try {
      await _messagingService.sendTypingIndicator(
        conversationId: conversationId,
        isTyping: isTyping,
      );
    } catch (e) {
      print('[RealtimeMessaging] Error sending typing indicator: $e');
    }
  }

  /// Send message via backend API
  Future<Message?> sendMessage(String content, {MessageType type = MessageType.text}) async {
    try {
      final response = await _messagingService.sendMessage(
        conversationId: conversationId,
        content: content,
      );

      if (response.success && response.data != null) {
        // Add message to local state immediately for responsiveness
        final newMessage = response.data!;
        final updatedMessages = [...state.messages, newMessage];

        state = state.copyWith(
          messages: updatedMessages,
          lastUpdate: DateTime.now(),
          latestMessage: newMessage,
        );

        return newMessage;
      } else {
        state = state.copyWith(error: response.message ?? 'Failed to send message');
        return null;
      }
    } catch (e) {
      print('[RealtimeMessaging] Error sending message: $e');
      state = state.copyWith(error: 'Failed to send message: $e');
      return null;
    }
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchConversationAndMessages();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}

/// Provider family for conversation messages (via backend API)
final conversationRealtimeProvider = StateNotifierProvider.family.autoDispose<
    ConversationRealtimeNotifier, RealtimeConversationState, String>((ref, conversationId) {
  final messagingService = ref.watch(messagingServiceProvider);

  return ConversationRealtimeNotifier(conversationId, ref, messagingService);
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
