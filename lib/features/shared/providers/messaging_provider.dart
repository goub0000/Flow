import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/message_model.dart';

const _uuid = Uuid();

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
  MessagingNotifier() : super(const MessagingState()) {
    fetchConversations();
  }

  /// Fetch all conversations for current user
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchConversations() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('conversations')
      //   .where('participants', arrayContains: currentUserId)
      //   .orderBy('updatedAt', descending: true)
      //   .get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockConversations = List<Conversation>.generate(
        10,
        (index) => Conversation(
          id: 'conv_$index',
          participantId: 'user_$index',
          participantName: 'User ${index + 1}',
          participantPhotoUrl: null,
          lastMessage: Message.mockMessage(index),
          unreadCount: index % 3 == 0 ? index : 0,
          lastActivity: DateTime.now().subtract(Duration(hours: index)),
        ),
      );

      state = state.copyWith(
        conversations: mockConversations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch conversations: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch messages for a conversation
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchMessages(String conversationId) async {
    try {
      // TODO: Replace with actual Firebase query
      // Listen to real-time updates

      await Future.delayed(const Duration(milliseconds: 500));

      // Mock messages
      final mockMessages = List<Message>.generate(
        15,
        (index) => Message.mockMessage(index),
      );

      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      updatedMessages[conversationId] = mockMessages;

      state = state.copyWith(messages: updatedMessages);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch messages: ${e.toString()}',
      );
    }
  }

  /// Send a message
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> sendMessage(String conversationId, String content, String senderId) async {
    try {
      // TODO: Write to Firebase and update conversation

      await Future.delayed(const Duration(milliseconds: 300));

      final newMessage = Message(
        id: _uuid.v4(),
        conversationId: conversationId,
        senderId: senderId,
        senderName: 'Current User', // TODO: Get actual sender name from auth
        content: content,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isRead: false,
      );

      // Add to messages
      final updatedMessages = Map<String, List<Message>>.from(state.messages);
      final conversationMessages = updatedMessages[conversationId] ?? [];
      updatedMessages[conversationId] = [...conversationMessages, newMessage];

      // Update conversation
      final updatedConversations = state.conversations.map((conv) {
        if (conv.id == conversationId) {
          return Conversation(
            id: conv.id,
            participantId: conv.participantId,
            participantName: conv.participantName,
            participantPhotoUrl: conv.participantPhotoUrl,
            participantRole: conv.participantRole,
            lastMessage: newMessage,
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
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send message: ${e.toString()}',
      );
      return false;
    }
  }

  /// Mark conversation as read
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> markConversationAsRead(String conversationId) async {
    try {
      // TODO: Update in Firebase

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

  /// Delete conversation
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> deleteConversation(String conversationId) async {
    try {
      // TODO: Delete from Firebase

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
  return MessagingNotifier();
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
