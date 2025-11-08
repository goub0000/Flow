import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/conversation.dart';
import '../services/chatbot_service.dart';
import '../services/conversation_storage_service.dart';
import '../../../authentication/providers/auth_provider.dart';

/// Chatbot state
class ChatbotState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final List<QuickAction>? currentQuickActions;
  final String? error;
  final String? conversationId;

  ChatbotState({
    required this.messages,
    this.isTyping = false,
    this.currentQuickActions,
    this.error,
    this.conversationId,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    List<QuickAction>? currentQuickActions,
    String? error,
    String? conversationId,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      currentQuickActions: currentQuickActions ?? this.currentQuickActions,
      error: error,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}

/// Chatbot notifier
class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final ChatbotService _chatbotService;
  final ConversationStorageService _storageService;
  final Ref _ref;

  ChatbotNotifier(this._chatbotService, this._storageService, this._ref)
      : super(ChatbotState(messages: []));

  /// Send initial greeting
  void sendInitialGreeting() async {
    final greeting = _chatbotService.getInitialGreeting();

    // Create new conversation ID
    final conversationId = DateTime.now().millisecondsSinceEpoch.toString();

    state = state.copyWith(
      messages: [greeting],
      currentQuickActions: greeting.quickActions,
      conversationId: conversationId,
    );

    // Save conversation
    await _saveCurrentConversation();
  }

  /// Send user message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(content: text);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentQuickActions: null,
      isTyping: true,
    );

    try {
      // Get bot response
      final botResponse = await _chatbotService.processMessage(text);

      // Add bot response
      state = state.copyWith(
        messages: [...state.messages, botResponse],
        isTyping: false,
        currentQuickActions: botResponse.quickActions,
      );

      // Save conversation
      await _saveCurrentConversation();
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  /// Handle quick action
  void handleQuickAction(String action) async {
    // Special handling for navigation actions
    if (action == 'navigate_register') {
      // This will be handled by the UI layer
      return;
    }

    // Clear current quick actions
    state = state.copyWith(
      currentQuickActions: null,
      isTyping: true,
    );

    // Get response for action
    final botResponse = _chatbotService.processQuickAction(action);

    // Add bot response
    state = state.copyWith(
      messages: [...state.messages, botResponse],
      isTyping: false,
      currentQuickActions: botResponse.quickActions,
    );

    // Save conversation
    await _saveCurrentConversation();
  }

  /// Clear conversation
  void clearConversation() {
    state = ChatbotState(messages: []);
    sendInitialGreeting();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Save current conversation to storage
  Future<void> _saveCurrentConversation() async {
    if (state.messages.isEmpty || state.conversationId == null) return;

    try {
      // Get user info from auth provider
      final authState = _ref.read(authProvider);
      final userId = authState.user?.id ?? 'anonymous';
      final userName = authState.user?.displayName ?? 'Guest User';
      final userEmail = authState.user?.email;
      final userRole = authState.user?.activeRole.name;

      // Create conversation object
      final conversation = Conversation(
        id: state.conversationId!,
        userId: userId,
        userName: userName,
        startTime: state.messages.first.timestamp,
        lastMessageTime: state.messages.last.timestamp,
        messages: state.messages,
        status: ConversationStatus.active,
        messageCount: state.messages.length,
        userEmail: userEmail,
        userRole: userRole,
      );

      // Save to storage
      await _storageService.saveConversation(conversation);
      await _storageService.saveActiveConversation(state.conversationId!);
    } catch (e) {
      print('Error saving conversation: $e');
      // Don't show error to user, just log it
    }
  }
}

/// Chatbot service provider
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  return ChatbotService();
});

/// Conversation storage service provider
final conversationStorageServiceProvider =
    Provider<ConversationStorageService>((ref) {
  return ConversationStorageService();
});

/// Chatbot state provider
final chatbotProvider =
    StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(
    ref.read(chatbotServiceProvider),
    ref.read(conversationStorageServiceProvider),
    ref,
  );
});

/// Chatbot visibility provider
final chatbotVisibleProvider = StateProvider<bool>((ref) => false);
