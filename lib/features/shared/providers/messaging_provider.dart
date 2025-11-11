import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/message_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing messaging
class MessagingState {
  final List<Conversation> conversations;
  final Map<String, List<Message>> messages; // conversationId -> messages
  final bool isLoading;
  final String? error;

  const MessagingState({
    this.conversations = const [],
    this.messages = const {},
    this.isLoading = false,
    this.error,
  });

  MessagingState copyWith({
    List<Conversation>? conversations,
    Map<String, List<Message>>? messages,
    bool? isLoading,
    String? error,
  }) {
    return MessagingState(
      conversations: conversations ?? this.conversations,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing messaging
class MessagingNotifier extends StateNotifier<MessagingState> {
  final ApiClient _apiClient;

  MessagingNotifier(this._apiClient) : super(const MessagingState()) {
    fetchConversations();
  }

  /// Fetch all conversations for current user from backend API
  Future<void> fetchConversations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.messaging}/conversations',
        fromJson: (data) {
          if (data is List) {
            return data.map((convJson) => Conversation.fromJson(convJson)).toList();
          }
          return <Conversation>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          conversations: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch conversations',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch conversations: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch messages for a conversation from backend API
  Future<void> fetchMessages(String conversationId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.messaging}/conversations/$conversationId/messages',
        fromJson: (data) {
          if (data is List) {
            return data.map((msgJson) => Message.fromJson(msgJson)).toList();
          }
          return <Message>[];
        },
      );

      if (response.success && response.data != null) {
        final updatedMessages = Map<String, List<Message>>.from(state.messages);
        updatedMessages[conversationId] = response.data!;
        state = state.copyWith(messages: updatedMessages);
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch messages',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch messages: ${e.toString()}',
      );
    }
  }

  /// Send a message via backend API
  Future<bool> sendMessage(String conversationId, String content, String senderId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.messaging}/conversations/$conversationId/messages',
        data: {
          'content': content,
          'type': 'text',
        },
        fromJson: (data) => Message.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Add new message to local state
        final updatedMessages = Map<String, List<Message>>.from(state.messages);
        final conversationMessages = updatedMessages[conversationId] ?? [];
        updatedMessages[conversationId] = [...conversationMessages, response.data!];

        // Update conversation's last message
        final updatedConversations = state.conversations.map((conv) {
          if (conv.id == conversationId) {
            return Conversation(
              id: conv.id,
              participantId: conv.participantId,
              participantName: conv.participantName,
              participantPhotoUrl: conv.participantPhotoUrl,
              participantRole: conv.participantRole,
              lastMessage: response.data!,
              unreadCount: conv.unreadCount,
              lastActivity: DateTime.now(),
            );
          }
          return conv;
        }).toList();

        state = state.copyWith(
          messages: updatedMessages,
          conversations: updatedConversations,
        );

        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to send message',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send message: ${e.toString()}',
      );
      return false;
    }
  }

  /// Start new conversation via backend API
  Future<Conversation?> startConversation(String participantId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.messaging}/conversations',
        data: {
          'participant_id': participantId,
        },
        fromJson: (data) => Conversation.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Add to conversations list
        state = state.copyWith(
          conversations: [response.data!, ...state.conversations],
        );
        return response.data!;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to start conversation',
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to start conversation: ${e.toString()}',
      );
      return null;
    }
  }

  /// Mark conversation messages as read via backend API
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      // Get all message IDs from this conversation
      final messages = state.messages[conversationId] ?? [];
      final messageIds = messages.where((m) => !m.isRead).map((m) => m.id).toList();

      if (messageIds.isNotEmpty) {
        await _apiClient.post(
          '${ApiConfig.messaging}/messages/read',
          data: {
            'message_ids': messageIds,
          },
        );
      }

      // Update local state
      final updatedConversations = state.conversations.map((conv) {
        if (conv.id == conversationId) {
          return Conversation(
            id: conv.id,
            participantId: conv.participantId,
            participantName: conv.participantName,
            participantPhotoUrl: conv.participantPhotoUrl,
            participantRole: conv.participantRole,
            lastMessage: conv.lastMessage,
            unreadCount: 0,
            lastActivity: conv.lastActivity,
          );
        }
        return conv;
      }).toList();

      state = state.copyWith(conversations: updatedConversations);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark as read: ${e.toString()}',
      );
    }
  }

  /// Delete message via backend API
  Future<void> deleteMessage(String messageId, String conversationId) async {
    try {
      await _apiClient.delete('${ApiConfig.messaging}/messages/$messageId');

      // Remove from local state
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      final conversationMessages = updatedMessages[conversationId] ?? [];
      updatedMessages[conversationId] = conversationMessages
          .where((msg) => msg.id != messageId)
          .toList();

      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete message: ${e.toString()}',
      );
    }
  }

  /// Delete conversation (note: backend may not support this yet)
  Future<void> deleteConversation(String conversationId) async {
    try {
      // Note: API doesn't have explicit delete conversation endpoint
      // This removes it locally only
      final updatedConversations = state.conversations
          .where((conv) => conv.id != conversationId)
          .toList();

      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages.remove(conversationId);

      state = state.copyWith(
        conversations: updatedConversations,
        messages: updatedMessages,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete conversation: ${e.toString()}',
      );
    }
  }

  /// Get messages for conversation
  List<Message> getMessages(String conversationId) {
    return state.messages[conversationId] ?? [];
  }

  /// Get total unread count
  int getTotalUnreadCount() {
    return state.conversations.fold<int>(0, (sum, conv) => sum + conv.unreadCount);
  }

  /// Search conversations
  List<Conversation> searchConversations(String query) {
    if (query.isEmpty) return state.conversations;

    final lowerQuery = query.toLowerCase();
    return state.conversations.where((conv) {
      return conv.participantName.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}

/// Provider for messaging state
final messagingProvider = StateNotifierProvider<MessagingNotifier, MessagingState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MessagingNotifier(apiClient);
});

/// Provider for conversations list
final conversationsListProvider = Provider<List<Conversation>>((ref) {
  final messagingState = ref.watch(messagingProvider);
  return messagingState.conversations;
});

/// Provider for total unread messages count
final totalUnreadMessagesCountProvider = Provider<int>((ref) {
  final notifier = ref.watch(messagingProvider.notifier);
  return notifier.getTotalUnreadCount();
});

/// Provider for checking if messaging is loading
final messagingLoadingProvider = Provider<bool>((ref) {
  final messagingState = ref.watch(messagingProvider);
  return messagingState.isLoading;
});

/// Provider for messaging error
final messagingErrorProvider = Provider<String?>((ref) {
  final messagingState = ref.watch(messagingProvider);
  return messagingState.error;
});

/// Provider for messages list for a specific conversation
/// Returns messages for the currently selected conversation
final messagesListProvider = Provider.family<List<Message>, String>((ref, conversationId) {
  final messagingState = ref.watch(messagingProvider);
  return messagingState.messages[conversationId] ?? [];
});
