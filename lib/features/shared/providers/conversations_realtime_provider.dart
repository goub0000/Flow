/// Conversations Real-Time Provider
/// Manages conversations list via backend API with periodic refresh
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/messaging_service.dart';

/// State class for real-time conversations list
class RealtimeConversationsState {
  final List<Conversation> conversations;
  final int totalUnreadCount;
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final DateTime? lastUpdate;
  final Conversation? latestConversation;

  const RealtimeConversationsState({
    this.conversations = const [],
    this.totalUnreadCount = 0,
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.lastUpdate,
    this.latestConversation,
  });

  RealtimeConversationsState copyWith({
    List<Conversation>? conversations,
    int? totalUnreadCount,
    bool? isLoading,
    bool? isConnected,
    String? error,
    DateTime? lastUpdate,
    Conversation? latestConversation,
  }) {
    return RealtimeConversationsState(
      conversations: conversations ?? this.conversations,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      latestConversation: latestConversation ?? this.latestConversation,
    );
  }
}

/// StateNotifier for managing conversations via backend API
class ConversationsRealtimeNotifier extends StateNotifier<RealtimeConversationsState> {
  final Ref ref;
  final MessagingService _messagingService;

  Timer? _refreshTimer;

  ConversationsRealtimeNotifier(
    this.ref,
    this._messagingService,
  ) : super(const RealtimeConversationsState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchConversations();

    // Setup periodic refresh (every 10 seconds for near-realtime updates)
    _setupPeriodicRefresh();
  }

  /// Fetch conversations from backend API
  Future<void> _fetchConversations() async {
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

      // Fetch conversations via backend API
      final response = await _messagingService.getConversations(
        page: 1,
        pageSize: 50,
      );

      if (response.success && response.data != null) {
        final conversations = response.data!.items;

        // Calculate total unread count
        final totalUnread = conversations.fold<int>(
          0,
          (sum, conv) => sum + conv.unreadCount,
        );

        state = state.copyWith(
          conversations: conversations,
          totalUnreadCount: totalUnread,
          isLoading: false,
          isConnected: true,
          lastUpdate: DateTime.now(),
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch conversations',
          isLoading: false,
          isConnected: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch conversations: $e',
        isLoading: false,
        isConnected: false,
      );
    }
  }

  /// Setup periodic refresh for near-realtime updates
  void _setupPeriodicRefresh() {
    // Refresh every 10 seconds for near-realtime experience
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refresh();
    });
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchConversations();
  }

  /// Create new conversation via backend API
  Future<Conversation?> createConversation({
    required List<String> participantIds,
    ConversationType type = ConversationType.direct,
    String? title,
  }) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return null;

      // For direct conversations, use the getOrCreateConversation method
      if (type == ConversationType.direct && participantIds.length == 1) {
        final response = await _messagingService.getOrCreateConversation(
          participantId: participantIds.first,
        );

        if (response.success && response.data != null) {
          // Refresh the list to include the new conversation
          await refresh();
          return response.data;
        } else {
          state = state.copyWith(error: response.message ?? 'Failed to create conversation');
          return null;
        }
      }

      // For group conversations, we'd need a different endpoint
      // TODO: Implement group conversation creation when backend supports it
      state = state.copyWith(error: 'Group conversations not yet supported');
      return null;

    } catch (e) {
      state = state.copyWith(error: 'Failed to create conversation: $e');
      return null;
    }
  }

  /// Get conversation by ID
  Conversation? getConversationById(String id) {
    try {
      return state.conversations.firstWhere((conv) => conv.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get conversation with specific user (direct message)
  Conversation? getDirectConversationWithUser(String userId) {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return null;

      return state.conversations.firstWhere(
        (conv) =>
            conv.conversationType == ConversationType.direct &&
            conv.participantIds.contains(userId) &&
            conv.participantIds.contains(user.id) &&
            conv.participantIds.length == 2,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get or create direct conversation with user
  Future<Conversation?> getOrCreateDirectConversation(String userId) async {
    // First check if conversation already exists
    final existing = getDirectConversationWithUser(userId);
    if (existing != null) return existing;

    // Create new conversation
    return await createConversation(
      participantIds: [userId],
      type: ConversationType.direct,
    );
  }

  @override
  void dispose() {
    // Clean up timer
    _refreshTimer?.cancel();
    super.dispose();
  }
}

/// Provider for conversations (via backend API)
final conversationsRealtimeProvider = StateNotifierProvider.autoDispose<
    ConversationsRealtimeNotifier, RealtimeConversationsState>((ref) {
  final messagingService = ref.watch(messagingServiceProvider);

  return ConversationsRealtimeNotifier(ref, messagingService);
});

/// Provider for conversations list
final realtimeConversationsListProvider = Provider.autoDispose<List<Conversation>>((ref) {
  final state = ref.watch(conversationsRealtimeProvider);
  return state.conversations;
});

/// Provider for total unread count
final realtimeTotalUnreadCountProvider = Provider.autoDispose<int>((ref) {
  final state = ref.watch(conversationsRealtimeProvider);
  return state.totalUnreadCount;
});

/// Provider for connection status
final conversationsConnectionStatusProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(conversationsRealtimeProvider);
  return state.isConnected;
});
