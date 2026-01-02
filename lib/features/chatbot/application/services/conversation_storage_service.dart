import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/chat_message.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/services/auth_service.dart';

/// Service for storing and retrieving chat conversations
/// Uses backend API for persistence instead of direct Supabase access
class ConversationStorageService {
  static const String _conversationsKey = 'chatbot_conversations';
  static const String _activeConversationKey = 'chatbot_active_conversation';

  final AuthService? authService;

  ConversationStorageService({this.authService});

  String get _baseUrl => ApiConfig.baseUrl;

  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = authService?.accessToken;
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Save a conversation (both locally and to backend)
  Future<void> saveConversation(Conversation conversation) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing conversations from local storage
    final conversations = await getAllConversations();

    // Update or add conversation
    final index = conversations.indexWhere((c) => c.id == conversation.id);
    if (index >= 0) {
      conversations[index] = conversation;
    } else {
      conversations.add(conversation);
    }

    // Save back to local storage
    final jsonList = conversations.map((c) => c.toJson()).toList();
    await prefs.setString(_conversationsKey, json.encode(jsonList));

    // Save to backend for admin tracking and cross-device sync
    try {
      final userMessageCount = conversation.messages.where((m) => m.sender == SenderType.user).length;
      final botMessageCount = conversation.messages.where((m) => m.sender == SenderType.bot).length;

      final body = {
        'id': conversation.id,
        'user_id': conversation.userId,
        'user_name': conversation.userName,
        'user_email': conversation.userEmail,
        'status': conversation.status.toString().split('.').last,
        'message_count': conversation.messageCount,
        'user_message_count': userMessageCount,
        'bot_message_count': botMessageCount,
        'created_at': conversation.startTime.toIso8601String(),
        'updated_at': conversation.lastMessageTime.toIso8601String(),
      };

      await http.post(
        Uri.parse('$_baseUrl/api/v1/chatbot/conversations/sync'),
        headers: _getHeaders(),
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));

      print('[ConversationStorage] Successfully synced conversation to backend: ${conversation.id}');
    } catch (e) {
      print('[ConversationStorage] Failed to sync conversation to backend: $e');
      // Don't fail the entire operation if backend sync fails
    }
  }

  /// Get all conversations from local storage
  Future<List<Conversation>> getAllConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_conversationsKey);

    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((json) => Conversation.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error loading conversations: $e');
      return [];
    }
  }

  /// Get conversation by ID
  Future<Conversation?> getConversation(String id) async {
    final conversations = await getAllConversations();
    try {
      return conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get conversations for a specific user
  Future<List<Conversation>> getUserConversations(String userId) async {
    final conversations = await getAllConversations();
    return conversations.where((c) => c.userId == userId).toList();
  }

  /// Delete a conversation
  Future<void> deleteConversation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final conversations = await getAllConversations();

    conversations.removeWhere((c) => c.id == id);

    final jsonList = conversations.map((c) => c.toJson()).toList();
    await prefs.setString(_conversationsKey, json.encode(jsonList));

    // Also delete from backend
    try {
      await http.delete(
        Uri.parse('$_baseUrl/api/v1/chatbot/conversations/$id'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 10));
    } catch (e) {
      print('[ConversationStorage] Failed to delete conversation from backend: $e');
    }
  }

  /// Update conversation status
  Future<void> updateConversationStatus(
    String id,
    ConversationStatus status,
  ) async {
    final conversation = await getConversation(id);
    if (conversation != null) {
      await saveConversation(conversation.copyWith(status: status));
    }
  }

  /// Save active conversation ID
  Future<void> saveActiveConversation(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeConversationKey, conversationId);
  }

  /// Get active conversation ID
  Future<String?> getActiveConversationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeConversationKey);
  }

  /// Clear active conversation
  Future<void> clearActiveConversation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeConversationKey);
  }

  /// Get conversation statistics from local storage
  Future<ConversationStats> getStats() async {
    final conversations = await getAllConversations();

    int totalMessages = 0;
    int totalUserMessages = 0;
    int totalBotMessages = 0;
    final Map<String, int> topicCounts = {};

    for (final conv in conversations) {
      totalMessages += conv.messageCount;
      totalUserMessages += conv.userMessageCount;
      totalBotMessages += conv.botMessageCount;

      // Count topics (simplified - based on first user message)
      if (conv.messages.isNotEmpty) {
        final firstUserMsg = conv.messages
            .firstWhere(
              (m) => m.sender == SenderType.user,
              orElse: () => conv.messages.first,
            )
            .content
            .toLowerCase();

        // Extract topic keywords
        if (firstUserMsg.contains('price') || firstUserMsg.contains('cost')) {
          topicCounts['Pricing'] = (topicCounts['Pricing'] ?? 0) + 1;
        } else if (firstUserMsg.contains('feature')) {
          topicCounts['Features'] = (topicCounts['Features'] ?? 0) + 1;
        } else if (firstUserMsg.contains('register') || firstUserMsg.contains('sign up')) {
          topicCounts['Registration'] = (topicCounts['Registration'] ?? 0) + 1;
        } else if (firstUserMsg.contains('help') || firstUserMsg.contains('support')) {
          topicCounts['Support'] = (topicCounts['Support'] ?? 0) + 1;
        } else {
          topicCounts['General'] = (topicCounts['General'] ?? 0) + 1;
        }
      }
    }

    return ConversationStats(
      totalConversations: conversations.length,
      activeConversations: conversations
          .where((c) => c.status == ConversationStatus.active)
          .length,
      totalMessages: totalMessages,
      totalUserMessages: totalUserMessages,
      totalBotMessages: totalBotMessages,
      topicCounts: topicCounts,
      flaggedConversations: conversations
          .where((c) => c.status == ConversationStatus.flagged)
          .length,
    );
  }

  /// Search conversations
  Future<List<Conversation>> searchConversations(String query) async {
    final conversations = await getAllConversations();
    final lowerQuery = query.toLowerCase();

    return conversations.where((conv) {
      // Search in user name, email, or message content
      if (conv.userName.toLowerCase().contains(lowerQuery)) return true;
      if (conv.userEmail?.toLowerCase().contains(lowerQuery) ?? false) {
        return true;
      }

      // Search in messages
      return conv.messages.any(
        (msg) => msg.content.toLowerCase().contains(lowerQuery),
      );
    }).toList();
  }

  /// Clear all conversations (for testing)
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_conversationsKey);
    await prefs.remove(_activeConversationKey);
  }

  /// Get all conversations from backend (for admin dashboard)
  Future<List<Conversation>> getAllConversationsFromBackend() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/chatbot/conversations'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final conversationsJson = data['conversations'] as List<dynamic>? ?? [];

        return conversationsJson.map((json) {
          try {
            return _parseConversationFromBackend(json);
          } catch (e) {
            print('[ConversationStorage] Error parsing conversation: $e');
            return null;
          }
        }).whereType<Conversation>().toList();
      }

      print('[ConversationStorage] Failed to fetch conversations: ${response.statusCode}');
      return [];
    } catch (e) {
      print('[ConversationStorage] Error fetching conversations from backend: $e');
      return [];
    }
  }

  /// Parse conversation from backend response
  Conversation _parseConversationFromBackend(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>?;
    final messages = <ChatMessage>[];

    if (messagesJson != null) {
      for (final m in messagesJson) {
        messages.add(ChatMessage(
          id: m['id'] as String,
          content: m['content'] as String,
          type: MessageType.text,
          sender: m['sender'] == 'user' ? SenderType.user : SenderType.bot,
          timestamp: DateTime.parse(m['created_at'] as String),
          quickActions: null,
        ));
      }
    }

    return Conversation(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String? ?? 'Unknown',
      startTime: DateTime.parse(json['created_at'] as String),
      lastMessageTime: DateTime.parse(json['updated_at'] as String),
      messages: messages,
      status: _parseConversationStatus(json['status'] as String?),
      messageCount: json['message_count'] as int? ?? messages.length,
      userEmail: json['user_email'] as String?,
    );
  }

  /// Get conversation statistics from backend (for admin dashboard)
  Future<ConversationStats> getStatsFromBackend() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/v1/chatbot/admin/stats'),
        headers: _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ConversationStats(
          totalConversations: data['total_conversations'] as int? ?? 0,
          activeConversations: data['active_conversations'] as int? ?? 0,
          totalMessages: data['total_messages'] as int? ?? 0,
          totalUserMessages: data['user_messages'] as int? ?? 0,
          totalBotMessages: data['bot_messages'] as int? ?? 0,
          topicCounts: Map<String, int>.from(data['topic_counts'] ?? {}),
          flaggedConversations: data['flagged_conversations'] as int? ?? 0,
        );
      }

      // Fallback to local stats
      return getStats();
    } catch (e) {
      print('[ConversationStorage] Error fetching stats from backend: $e');
      return getStats();
    }
  }

  /// Helper to parse conversation status from string
  ConversationStatus _parseConversationStatus(String? status) {
    switch (status) {
      case 'active':
        return ConversationStatus.active;
      case 'archived':
        return ConversationStatus.archived;
      case 'flagged':
        return ConversationStatus.flagged;
      default:
        return ConversationStatus.active;
    }
  }
}

/// Statistics about conversations
class ConversationStats {
  final int totalConversations;
  final int activeConversations;
  final int totalMessages;
  final int totalUserMessages;
  final int totalBotMessages;
  final Map<String, int> topicCounts;
  final int flaggedConversations;

  ConversationStats({
    required this.totalConversations,
    required this.activeConversations,
    required this.totalMessages,
    required this.totalUserMessages,
    required this.totalBotMessages,
    required this.topicCounts,
    required this.flaggedConversations,
  });

  double get averageMessagesPerConversation =>
      totalConversations > 0 ? totalMessages / totalConversations : 0;

  List<MapEntry<String, int>> get topTopics {
    final entries = topicCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(5).toList();
  }
}
