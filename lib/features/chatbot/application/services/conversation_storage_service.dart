import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/chat_message.dart';

/// Service for storing and retrieving chat conversations
class ConversationStorageService {
  static const String _conversationsKey = 'chatbot_conversations';
  static const String _activeConversationKey = 'chatbot_active_conversation';
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Save a conversation (both locally and to Supabase)
  Future<void> saveConversation(Conversation conversation) async {
    final prefs = await SharedPreferences.getInstance();

    // Get existing conversations
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

    // Save to Supabase for admin tracking and cross-device sync
    try {
      final userMessageCount = conversation.messages.where((m) => m.sender == SenderType.user).length;
      final botMessageCount = conversation.messages.where((m) => m.sender == SenderType.bot).length;

      await _supabase.from('chatbot_conversations').upsert({
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
        'messages': conversation.messages.map((m) => {
          'id': m.id,
          'content': m.content,
          'sender': m.sender.toString().split('.').last,
          'timestamp': m.timestamp.toIso8601String(),
          'quick_actions': m.quickActions?.map((a) => {
            'id': a.id,
            'label': a.label,
            'action': a.action,
          }).toList(),
        }).toList(),
      }, onConflict: 'id');

      print('[ConversationStorage] Successfully saved conversation to Supabase: ${conversation.id}');
    } catch (e) {
      print('[ConversationStorage] Failed to save conversation to Supabase: $e');
      // Don't fail the entire operation if Supabase save fails
    }
  }

  /// Get all conversations
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

  /// Get conversation statistics
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
