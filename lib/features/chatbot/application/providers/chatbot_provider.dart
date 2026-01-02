import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/conversation.dart';
import '../services/chatbot_service.dart';
import '../services/conversation_storage_service.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/providers/service_providers.dart';

/// Chatbot state
class ChatbotState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final List<QuickAction>? currentQuickActions;
  final String? error;
  final String? conversationId;
  final bool isEscalated;
  final bool isLoadingHistory;
  final String? currentPage;

  ChatbotState({
    required this.messages,
    this.isTyping = false,
    this.currentQuickActions,
    this.error,
    this.conversationId,
    this.isEscalated = false,
    this.isLoadingHistory = false,
    this.currentPage,
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    List<QuickAction>? currentQuickActions,
    String? error,
    String? conversationId,
    bool? isEscalated,
    bool? isLoadingHistory,
    String? currentPage,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      currentQuickActions: currentQuickActions ?? this.currentQuickActions,
      error: error,
      conversationId: conversationId ?? this.conversationId,
      isEscalated: isEscalated ?? this.isEscalated,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Chatbot notifier with backend sync
class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final ChatbotService _chatbotService;
  final ConversationStorageService _storageService;
  final Ref _ref;
  String? _lastUserId;

  ChatbotNotifier(this._chatbotService, this._storageService, this._ref)
      : super(ChatbotState(messages: [])) {
    // Listen to auth state changes
    _ref.listen<AuthState>(authProvider, (previous, next) {
      _onAuthStateChanged(previous, next);
    });
  }

  /// Handle auth state changes
  void _onAuthStateChanged(AuthState? previous, AuthState next) {
    final newUserId = next.user?.id;
    final wasLoggedIn = previous?.isAuthenticated ?? false;
    final isLoggedIn = next.isAuthenticated;

    // User just logged in
    if (!wasLoggedIn && isLoggedIn && newUserId != _lastUserId) {
      _lastUserId = newUserId;
      _onUserLoggedIn(next.user!.displayName);
    }
    // User logged out
    else if (wasLoggedIn && !isLoggedIn) {
      _lastUserId = null;
      _onUserLoggedOut();
    }
  }

  /// Called when user logs in
  void _onUserLoggedIn(String? userName) {
    // Add a personalized welcome message
    final welcomeMessage = ChatMessage.bot(
      content: userName != null
          ? 'Welcome back, $userName! 🎉 I can now sync our conversation to your account. How can I help you today?'
          : 'Welcome back! 🎉 Your conversations will now be synced to your account.',
      quickActions: [
        const QuickAction(
          id: 'view_profile',
          label: 'View Profile',
          action: 'view_profile',
        ),
        const QuickAction(
          id: 'what_is_flow',
          label: 'What is Flow?',
          action: 'what_is_flow',
        ),
        const QuickAction(
          id: 'get_help',
          label: 'Get Help',
          action: 'get_help',
        ),
      ],
    );

    state = state.copyWith(
      messages: [...state.messages, welcomeMessage],
      currentQuickActions: welcomeMessage.quickActions,
    );

    // Save conversation to sync with backend
    _saveCurrentConversation();
  }

  /// Called when user logs out
  void _onUserLoggedOut() {
    // Add a message about logging out
    final logoutMessage = ChatMessage.system(
      content: 'You have been signed out. Your conversation history on this device is still available.',
    );

    state = state.copyWith(
      messages: [...state.messages, logoutMessage],
      currentQuickActions: [
        const QuickAction(
          id: 'sign_in',
          label: 'Sign In',
          action: 'navigate_login',
        ),
        const QuickAction(
          id: 'what_is_flow',
          label: 'What is Flow?',
          action: 'what_is_flow',
        ),
      ],
    );
  }

  /// Initialize chatbot - try to resume existing conversation or start new
  Future<void> initialize() async {
    // Try to load last active conversation from backend
    final conversationId = _chatbotService.currentConversationId;

    if (conversationId != null) {
      await loadConversationHistory(conversationId);
    } else {
      sendInitialGreeting();
    }
  }

  /// Load conversation history from backend
  Future<void> loadConversationHistory(String conversationId) async {
    state = state.copyWith(isLoadingHistory: true);

    try {
      final messages = await _chatbotService.loadConversationHistory(conversationId);

      if (messages.isNotEmpty) {
        state = state.copyWith(
          messages: messages,
          conversationId: conversationId,
          isLoadingHistory: false,
          currentQuickActions: messages.last.quickActions,
        );
      } else {
        // No history found, start fresh
        state = state.copyWith(isLoadingHistory: false);
        sendInitialGreeting();
      }
    } catch (e) {
      state = state.copyWith(
        isLoadingHistory: false,
        error: 'Failed to load conversation history',
      );
      sendInitialGreeting();
    }
  }

  /// Send initial greeting
  void sendInitialGreeting() async {
    final greeting = _chatbotService.getInitialGreeting();

    // Start new conversation
    _chatbotService.startNewConversation();

    state = state.copyWith(
      messages: [greeting],
      currentQuickActions: greeting.quickActions,
      conversationId: null, // Will be set on first API call
      isEscalated: false,
    );

    // Save locally
    await _saveCurrentConversation();
  }

  /// Set current page context for personalization
  void setCurrentPage(String page) {
    state = state.copyWith(currentPage: page);
  }

  /// Send user message with backend sync
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage.user(content: text);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      currentQuickActions: null,
      isTyping: true,
      error: null,
    );

    try {
      // Build context for personalization
      final context = _buildUserContext();

      // Get bot response from API (with local fallback)
      final botResponse = await _chatbotService.processMessage(
        text,
        context: context,
      );

      // Update conversation ID if new
      if (_chatbotService.currentConversationId != null) {
        state = state.copyWith(
          conversationId: _chatbotService.currentConversationId,
        );
      }

      // Check if escalated
      final isEscalated = botResponse.shouldEscalate ||
          botResponse.sender == SenderType.agent ||
          botResponse.sender == SenderType.system;

      // Add bot response
      state = state.copyWith(
        messages: [...state.messages, botResponse],
        isTyping: false,
        currentQuickActions: botResponse.quickActions,
        isEscalated: isEscalated || state.isEscalated,
      );

      // Save locally
      await _saveCurrentConversation();
    } catch (e) {
      state = state.copyWith(
        isTyping: false,
        error: 'Failed to get response. Please try again.',
      );
    }
  }

  /// Handle quick action
  Future<void> handleQuickAction(String action) async {
    // Special handling for navigation actions
    if (action == 'navigate_register') {
      return;
    }

    // Special handling for escalation
    if (action == 'talk_to_human' || action == 'escalate') {
      await escalateToHuman();
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

    // Save locally
    await _saveCurrentConversation();
  }

  /// Submit feedback for a message
  Future<bool> submitFeedback(String messageId, MessageFeedback feedback, {String? comment}) async {
    try {
      final success = await _chatbotService.submitFeedback(messageId, feedback, comment: comment);

      if (success) {
        // Update local message state
        final updatedMessages = state.messages.map((msg) {
          if (msg.id == messageId) {
            return msg.copyWith(feedback: feedback, feedbackComment: comment);
          }
          return msg;
        }).toList();

        state = state.copyWith(messages: updatedMessages);
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Escalate conversation to human support
  Future<bool> escalateToHuman({String? reason}) async {
    if (state.isEscalated) return true;

    try {
      final success = await _chatbotService.escalateToHuman(reason: reason);

      if (success) {
        // Add system message
        final systemMessage = ChatMessage.system(
          content: 'Your conversation has been escalated to human support. An agent will assist you shortly.',
        );

        state = state.copyWith(
          messages: [...state.messages, systemMessage],
          isEscalated: true,
          currentQuickActions: null,
        );

        await _saveCurrentConversation();
      }

      return success;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to escalate. Please try again.',
      );
      return false;
    }
  }

  /// Clear conversation and start fresh
  void clearConversation() {
    _chatbotService.startNewConversation();
    state = ChatbotState(messages: []);
    sendInitialGreeting();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Build user context for personalization
  Map<String, dynamic> _buildUserContext() {
    final authState = _ref.read(authProvider);
    final user = authState.user;

    return {
      'current_page': state.currentPage,
      'user_role': user != null ? UserRoleHelper.getRoleName(user.activeRole) : null,
      'user_name': user?.displayName,
      'is_authenticated': user != null,
    };
  }

  /// Save current conversation to local storage
  Future<void> _saveCurrentConversation() async {
    if (state.messages.isEmpty) return;

    try {
      final authState = _ref.read(authProvider);
      final userId = authState.user?.id ?? 'anonymous';
      final userName = authState.user?.displayName ?? 'Guest User';
      final userEmail = authState.user?.email;
      final userRole = authState.user != null
          ? UserRoleHelper.getRoleName(authState.user!.activeRole)
          : null;

      final conversationId = state.conversationId ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final conversation = Conversation(
        id: conversationId,
        userId: userId,
        userName: userName,
        startTime: state.messages.first.timestamp,
        lastMessageTime: state.messages.last.timestamp,
        messages: state.messages,
        status: state.isEscalated
            ? ConversationStatus.flagged
            : ConversationStatus.active,
        messageCount: state.messages.length,
        userEmail: userEmail,
        userRole: userRole,
      );

      await _storageService.saveConversation(conversation);
      await _storageService.saveActiveConversation(conversationId);
    } catch (e) {
      // Don't show error to user, just log it
      print('Error saving conversation: $e');
    }
  }
}

/// Chatbot service provider with API integration
final chatbotServiceProvider = Provider<ChatbotService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ChatbotService(authService: authService);
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
