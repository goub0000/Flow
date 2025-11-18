import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';

/// State class for conversations
class ConversationsState {
  final List<Conversation> conversations;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const ConversationsState({
    this.conversations = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  ConversationsState copyWith({
    List<Conversation>? conversations,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return ConversationsState(
      conversations: conversations ?? this.conversations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// StateNotifier for managing conversations
class ConversationsNotifier extends StateNotifier<ConversationsState> {
  final ApiClient _apiClient;

  ConversationsNotifier(this._apiClient) : super(const ConversationsState()) {
    fetchConversations();
  }

  /// Fetch user's conversations
  Future<void> fetchConversations({int page = 1, int pageSize = 20}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.messaging}/conversations?page=$page&page_size=$pageSize',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final conversationListResponse = ConversationListResponse.fromJson(response.data!);

        // If first page, replace conversations; otherwise append
        final updatedConversations = page == 1
            ? conversationListResponse.conversations
            : [...state.conversations, ...conversationListResponse.conversations];

        state = state.copyWith(
          conversations: updatedConversations,
          isLoading: false,
          currentPage: conversationListResponse.page,
          hasMore: conversationListResponse.hasMore,
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

  /// Load more conversations (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchConversations(page: state.currentPage + 1);
  }

  /// Create a new conversation
  Future<Conversation?> createConversation(ConversationCreateRequest request) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.messaging}/conversations',
        data: request.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final conversation = Conversation.fromJson(response.data!);

        // Add to beginning of conversations list
        state = state.copyWith(
          conversations: [conversation, ...state.conversations],
        );

        return conversation;
      }
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Failed to create conversation: ${e.toString()}');
      return null;
    }
  }

  /// Refresh conversations
  Future<void> refresh() async {
    await fetchConversations(page: 1);
  }

  /// Update conversation locally (for real-time updates)
  void updateConversation(Conversation updatedConversation) {
    final updatedList = state.conversations.map((conv) {
      return conv.id == updatedConversation.id ? updatedConversation : conv;
    }).toList();

    state = state.copyWith(conversations: updatedList);
  }

  /// Add new conversation to list (for real-time updates)
  void addConversation(Conversation conversation) {
    if (!state.conversations.any((c) => c.id == conversation.id)) {
      state = state.copyWith(conversations: [conversation, ...state.conversations]);
    }
  }

  /// Get total unread count
  int getTotalUnreadCount() {
    return state.conversations.fold<int>(0, (sum, conv) => sum + conv.unreadCount);
  }
}

/// State class for messages in a conversation
class MessagesState {
  final List<Message> messages;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const MessagesState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  MessagesState copyWith({
    List<Message>? messages,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return MessagesState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// StateNotifier for managing messages in a conversation
class MessagesNotifier extends StateNotifier<MessagesState> {
  final ApiClient _apiClient;
  final String conversationId;

  MessagesNotifier(this._apiClient, this.conversationId) : super(const MessagesState()) {
    fetchMessages();
  }

  /// Fetch messages for this conversation
  Future<void> fetchMessages({int page = 1, int pageSize = 50}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.messaging}/conversations/$conversationId/messages?page=$page&page_size=$pageSize',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final messageListResponse = MessageListResponse.fromJson(response.data!);

        // If first page, replace messages; otherwise prepend (older messages)
        final updatedMessages = page == 1
            ? messageListResponse.messages
            : [...messageListResponse.messages, ...state.messages];

        state = state.copyWith(
          messages: updatedMessages,
          isLoading: false,
          currentPage: messageListResponse.page,
          hasMore: messageListResponse.hasMore,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch messages',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch messages: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Load older messages (pagination)
  Future<void> loadOlderMessages() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchMessages(page: state.currentPage + 1);
  }

  /// Send a new message
  Future<Message?> sendMessage(MessageCreateRequest request) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.messaging}/conversations/$conversationId/messages',
        data: request.toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final message = Message.fromJson(response.data!);

        // Add to end of messages list (newest)
        state = state.copyWith(
          messages: [...state.messages, message],
        );

        return message;
      }
      return null;
    } catch (e) {
      state = state.copyWith(error: 'Failed to send message: ${e.toString()}');
      return null;
    }
  }

  /// Edit a message
  Future<bool> editMessage(String messageId, String newContent) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.messaging}/messages/$messageId',
        data: MessageUpdateRequest(content: newContent).toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final updatedMessage = Message.fromJson(response.data!);
        updateMessage(updatedMessage);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to edit message: ${e.toString()}');
      return false;
    }
  }

  /// Delete a message
  Future<bool> deleteMessage(String messageId) async {
    try {
      final response = await _apiClient.delete(
        '${ApiConfig.messaging}/messages/$messageId',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final updatedMessage = Message.fromJson(response.data!);
        updateMessage(updatedMessage);
        return true;
      }
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete message: ${e.toString()}');
      return false;
    }
  }

  /// Mark messages as read
  Future<void> markMessagesAsRead(List<String> messageIds) async {
    if (messageIds.isEmpty) return;

    try {
      await _apiClient.post(
        '${ApiConfig.messaging}/messages/read',
        data: ReadReceiptRequest(messageIds: messageIds).toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );
      // Messages will be updated via real-time subscription
    } catch (e) {
      // Silently fail for read receipts
    }
  }

  /// Send typing indicator
  Future<void> sendTypingIndicator(bool isTyping) async {
    try {
      await _apiClient.post(
        '${ApiConfig.messaging}/conversations/$conversationId/typing',
        data: TypingIndicatorRequest(
          conversationId: conversationId,
          isTyping: isTyping,
        ).toJson(),
        fromJson: (data) => data as Map<String, dynamic>,
      );
    } catch (e) {
      // Silently fail for typing indicators
    }
  }

  /// Refresh messages
  Future<void> refresh() async {
    await fetchMessages(page: 1);
  }

  /// Update message locally (for real-time updates)
  void updateMessage(Message updatedMessage) {
    final updatedList = state.messages.map((msg) {
      return msg.id == updatedMessage.id ? updatedMessage : msg;
    }).toList();

    state = state.copyWith(messages: updatedList);
  }

  /// Add new message to list (for real-time updates)
  void addMessage(Message message) {
    if (!state.messages.any((m) => m.id == message.id)) {
      state = state.copyWith(messages: [...state.messages, message]);
    }
  }

  /// Remove message from list
  void removeMessage(String messageId) {
    final updatedList = state.messages.where((m) => m.id != messageId).toList();
    state = state.copyWith(messages: updatedList);
  }
}

/// Provider for conversations list
final conversationsProvider = StateNotifierProvider<ConversationsNotifier, ConversationsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ConversationsNotifier(apiClient);
});

/// Provider family for messages in a specific conversation
final messagesProvider = StateNotifierProvider.family<MessagesNotifier, MessagesState, String>((ref, conversationId) {
  final apiClient = ref.watch(apiClientProvider);
  return MessagesNotifier(apiClient, conversationId);
});

/// Provider for unread message count
final unreadMessageCountProvider = FutureProvider<UnreadCountResponse>((ref) async {
  final apiClient = ref.watch(apiClientProvider);

  try {
    final response = await apiClient.get(
      '${ApiConfig.messaging}/messages/unread-count',
      fromJson: (data) => data as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return UnreadCountResponse.fromJson(response.data!);
    }
    return const UnreadCountResponse(totalUnread: 0, byConversation: {});
  } catch (e) {
    return const UnreadCountResponse(totalUnread: 0, byConversation: {});
  }
});

/// Provider for total unread count (for badges)
final totalUnreadMessagesProvider = Provider<int>((ref) {
  final unreadCountAsync = ref.watch(unreadMessageCountProvider);
  return unreadCountAsync.when(
    data: (unreadCount) => unreadCount.totalUnread,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Legacy providers for backward compatibility
final messagingProvider = conversationsProvider;
final conversationsListProvider = Provider<List<Conversation>>((ref) {
  final state = ref.watch(conversationsProvider);
  return state.conversations;
});

final totalUnreadMessagesCountProvider = totalUnreadMessagesProvider;

final messagingLoadingProvider = Provider<bool>((ref) {
  final state = ref.watch(conversationsProvider);
  return state.isLoading;
});

final messagingErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(conversationsProvider);
  return state.error;
});
