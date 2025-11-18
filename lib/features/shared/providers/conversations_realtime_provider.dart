/// Conversations Real-Time Provider
/// Manages real-time subscriptions for conversations list

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/enhanced_realtime_service.dart';

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

/// StateNotifier for managing real-time conversations
class ConversationsRealtimeNotifier extends StateNotifier<RealtimeConversationsState> {
  final Ref ref;
  final EnhancedRealtimeService _realtimeService;
  final SupabaseClient _supabase;

  RealtimeChannel? _channel;
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  Timer? _refreshTimer;

  ConversationsRealtimeNotifier(
    this.ref,
    this._realtimeService,
    this._supabase,
  ) : super(const RealtimeConversationsState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchConversations();

    // Setup real-time subscription
    _setupRealtimeSubscription();

    // Monitor connection status
    _monitorConnectionStatus();

    // Setup periodic refresh as fallback
    _setupPeriodicRefresh();
  }

  /// Fetch conversations from database
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

      print('[RealtimeConversations] Fetching conversations for user: ${user.id}');

      // Fetch conversations where user is a participant
      // Note: This uses array contains operator with Postgres
      final response = await _supabase
          .from('conversations')
          .select('*')
          .contains('participant_ids', [user.id])
          .order('last_message_at', ascending: false)
          .limit(50);

      final conversations = (response as List<dynamic>)
          .map((json) => Conversation.fromJson(json))
          .toList();

      // Calculate total unread count
      final totalUnread = conversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );

      state = state.copyWith(
        conversations: conversations,
        totalUnreadCount: totalUnread,
        isLoading: false,
        lastUpdate: DateTime.now(),
      );

      print('[RealtimeConversations] Fetched ${conversations.length} conversations ($totalUnread unread)');

    } catch (e) {
      print('[RealtimeConversations] Error fetching: $e');
      state = state.copyWith(
        error: 'Failed to fetch conversations: $e',
        isLoading: false,
      );
    }
  }

  /// Setup real-time subscription for conversations
  void _setupRealtimeSubscription() {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      print('[RealtimeConversations] Cannot setup subscription - no user');
      return;
    }

    final channelName = 'user_conversations_${user.id}';

    print('[RealtimeConversations] Setting up real-time subscription');

    // Note: We can't filter by array contains in real-time, so we subscribe to all
    // conversations and filter in the handlers
    _channel = _realtimeService.subscribeToTable(
      table: 'conversations',
      channelName: channelName,
      onInsert: _handleInsert,
      onUpdate: _handleUpdate,
      onDelete: _handleDelete,
      onError: (error) {
        print('[RealtimeConversations] Subscription error: $error');
        state = state.copyWith(error: error);
      },
    );
  }

  /// Handle INSERT event (new conversation)
  void _handleInsert(Map<String, dynamic> payload) {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final newConversation = Conversation.fromJson(payload);

      // Only add if user is a participant
      if (!newConversation.participantIds.contains(user.id)) {
        return;
      }

      print('[RealtimeConversations] New conversation inserted: ${payload['id']}');

      // Add to top of list
      final updatedConversations = [newConversation, ...state.conversations];

      // Update total unread count
      final totalUnread = updatedConversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );

      state = state.copyWith(
        conversations: updatedConversations,
        totalUnreadCount: totalUnread,
        lastUpdate: DateTime.now(),
        latestConversation: newConversation,
      );

    } catch (e) {
      print('[RealtimeConversations] Error handling insert: $e');
    }
  }

  /// Handle UPDATE event (conversation updated - new message, etc.)
  void _handleUpdate(Map<String, dynamic> payload) {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final updatedConversation = Conversation.fromJson(payload);

      // Only update if user is a participant
      if (!updatedConversation.participantIds.contains(user.id)) {
        return;
      }

      print('[RealtimeConversations] Conversation updated: ${payload['id']}');

      // Update in list and move to top if last_message_at changed
      final existingIndex = state.conversations.indexWhere(
        (conv) => conv.id == updatedConversation.id,
      );

      List<Conversation> updatedConversations;

      if (existingIndex >= 0) {
        // Replace existing conversation
        updatedConversations = List.from(state.conversations);
        updatedConversations[existingIndex] = updatedConversation;

        // Sort by last_message_at to maintain order
        updatedConversations.sort((a, b) {
          if (a.lastMessageAt == null) return 1;
          if (b.lastMessageAt == null) return -1;
          return b.lastMessageAt!.compareTo(a.lastMessageAt!);
        });
      } else {
        // New conversation (might have been filtered out initially)
        updatedConversations = [updatedConversation, ...state.conversations];
      }

      // Update total unread count
      final totalUnread = updatedConversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );

      state = state.copyWith(
        conversations: updatedConversations,
        totalUnreadCount: totalUnread,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      print('[RealtimeConversations] Error handling update: $e');
    }
  }

  /// Handle DELETE event
  void _handleDelete(Map<String, dynamic> payload) {
    try {
      print('[RealtimeConversations] Conversation deleted: ${payload['id']}');

      final deletedId = payload['id'] as String;

      // Remove from state
      final updatedConversations = state.conversations
          .where((conversation) => conversation.id != deletedId)
          .toList();

      // Update total unread count
      final totalUnread = updatedConversations.fold<int>(
        0,
        (sum, conv) => sum + conv.unreadCount,
      );

      state = state.copyWith(
        conversations: updatedConversations,
        totalUnreadCount: totalUnread,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      print('[RealtimeConversations] Error handling delete: $e');
    }
  }

  /// Monitor connection status
  void _monitorConnectionStatus() {
    _connectionSubscription = _realtimeService.connectionStatus.listen((status) {
      final isConnected = status == ConnectionStatus.connected;
      state = state.copyWith(isConnected: isConnected);

      if (status == ConnectionStatus.connected && state.lastUpdate == null) {
        // First connection - fetch data
        _fetchConversations();
      }
    });
  }

  /// Setup periodic refresh as fallback
  void _setupPeriodicRefresh() {
    // Refresh every 60 seconds if not connected to real-time
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (!state.isConnected) {
        print('[RealtimeConversations] Periodic refresh (not connected to real-time)');
        refresh();
      }
    });
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchConversations();
  }

  /// Create new conversation
  Future<Conversation?> createConversation({
    required List<String> participantIds,
    ConversationType type = ConversationType.direct,
    String? title,
  }) async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return null;

      // Ensure current user is in participants
      if (!participantIds.contains(user.id)) {
        participantIds = [user.id, ...participantIds];
      }

      final response = await _supabase
          .from('conversations')
          .insert({
            'participant_ids': participantIds,
            'conversation_type': type.toJson(),
            if (title != null) 'title': title,
          })
          .select()
          .single();

      return Conversation.fromJson(response);

    } catch (e) {
      print('[RealtimeConversations] Error creating conversation: $e');
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
    // Clean up subscriptions
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _realtimeService.unsubscribe('user_conversations_${user.id}');
    }

    _connectionSubscription?.cancel();
    _refreshTimer?.cancel();

    super.dispose();
  }
}

/// Provider for real-time conversations
final conversationsRealtimeProvider = StateNotifierProvider.autoDispose<
    ConversationsRealtimeNotifier, RealtimeConversationsState>((ref) {
  final realtimeService = ref.watch(enhancedRealtimeServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return ConversationsRealtimeNotifier(ref, realtimeService, supabase);
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
