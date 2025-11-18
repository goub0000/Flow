/// Messaging Service
/// Handles real-time messaging API calls

import 'dart:io';
import '../api/api_client.dart';
import '../api/api_config.dart';
import '../api/api_response.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

class MessagingService {
  final ApiClient _apiClient;

  MessagingService(this._apiClient);

  /// Get conversations for current user
  Future<ApiResponse<PaginatedResponse<Conversation>>> getConversations({
    int page = 1,
    int pageSize = 20,
    bool unreadOnly = false,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (unreadOnly) 'unread_only': unreadOnly,
    };

    return await _apiClient.get(
      '${ApiConfig.messaging}/conversations',
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Conversation.fromJson(json),
      ),
    );
  }

  /// Get conversation by ID
  Future<ApiResponse<Conversation>> getConversationById(String conversationId) async {
    return await _apiClient.get(
      '${ApiConfig.messaging}/conversations/$conversationId',
      fromJson: (data) => Conversation.fromJson(data),
    );
  }

  /// Create or get conversation with a user
  Future<ApiResponse<Conversation>> getOrCreateConversation({
    required String participantId,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations',
      data: {
        'participant_id': participantId,
      },
      fromJson: (data) => Conversation.fromJson(data),
    );
  }

  /// Get messages in a conversation
  Future<ApiResponse<PaginatedResponse<Message>>> getMessages({
    required String conversationId,
    int page = 1,
    int pageSize = 50,
    String? before,
    String? after,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      if (before != null) 'before': before,
      if (after != null) 'after': after,
    };

    return await _apiClient.get(
      '${ApiConfig.messaging}/conversations/$conversationId/messages',
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Message.fromJson(json),
      ),
    );
  }

  /// Send a text message
  Future<ApiResponse<Message>> sendMessage({
    required String conversationId,
    required String content,
    String? replyToId,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/messages',
      data: {
        'content': content,
        'type': 'text',
        if (replyToId != null) 'reply_to_id': replyToId,
      },
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Send a message with file attachment
  Future<ApiResponse<Message>> sendMessageWithFile({
    required String conversationId,
    required String content,
    required File file,
    String? replyToId,
    void Function(int, int)? onProgress,
  }) async {
    // First upload the file
    final uploadResponse = await _apiClient.uploadFile(
      '${ApiConfig.messaging}/upload',
      file,
      fieldName: 'file',
      onSendProgress: onProgress,
    );

    if (!uploadResponse.success || uploadResponse.data == null) {
      return ApiResponse.error(
        message: uploadResponse.message ?? 'Failed to upload file',
      );
    }

    final fileUrl = uploadResponse.data!['url'] as String;
    final fileType = uploadResponse.data!['type'] as String;

    // Then send the message with the file URL
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/messages',
      data: {
        'content': content,
        'type': fileType == 'image' ? 'image' : 'file',
        'attachments': [fileUrl],
        if (replyToId != null) 'reply_to_id': replyToId,
      },
      fromJson: (data) => Message.fromJson(data),
    );
  }

  /// Mark message as read
  Future<ApiResponse<void>> markAsRead({
    required String conversationId,
    required String messageId,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/messages/$messageId/read',
    );
  }

  /// Mark all messages in conversation as read
  Future<ApiResponse<void>> markConversationAsRead(String conversationId) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/read',
    );
  }

  /// Delete a message
  Future<ApiResponse<void>> deleteMessage({
    required String conversationId,
    required String messageId,
  }) async {
    return await _apiClient.delete(
      '${ApiConfig.messaging}/conversations/$conversationId/messages/$messageId',
    );
  }

  /// Archive a conversation
  Future<ApiResponse<void>> archiveConversation(String conversationId) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/archive',
    );
  }

  /// Unarchive a conversation
  Future<ApiResponse<void>> unarchiveConversation(String conversationId) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/unarchive',
    );
  }

  /// Get unread messages count
  Future<ApiResponse<Map<String, dynamic>>> getUnreadCount() async {
    return await _apiClient.get(
      '${ApiConfig.messaging}/unread-count',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Search messages
  Future<ApiResponse<PaginatedResponse<Message>>> searchMessages({
    required String query,
    String? conversationId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'q': query,
      'page': page,
      'page_size': pageSize,
      if (conversationId != null) 'conversation_id': conversationId,
    };

    return await _apiClient.get(
      '${ApiConfig.messaging}/search',
      queryParameters: queryParams,
      fromJson: (data) => PaginatedResponse.fromJson(
        data,
        (json) => Message.fromJson(json),
      ),
    );
  }

  /// Get typing indicator status
  Future<ApiResponse<Map<String, dynamic>>> getTypingStatus(
      String conversationId) async {
    return await _apiClient.get(
      '${ApiConfig.messaging}/conversations/$conversationId/typing',
      fromJson: (data) => data as Map<String, dynamic>,
    );
  }

  /// Send typing indicator
  Future<ApiResponse<void>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/conversations/$conversationId/typing',
      data: {
        'is_typing': isTyping,
      },
    );
  }

  /// Block a user
  Future<ApiResponse<void>> blockUser(String userId) async {
    return await _apiClient.post(
      '${ApiConfig.messaging}/block/$userId',
    );
  }

  /// Unblock a user
  Future<ApiResponse<void>> unblockUser(String userId) async {
    return await _apiClient.delete(
      '${ApiConfig.messaging}/block/$userId',
    );
  }

  /// Get blocked users list
  Future<ApiResponse<List<Map<String, dynamic>>>> getBlockedUsers() async {
    return await _apiClient.get(
      '${ApiConfig.messaging}/blocked',
      fromJson: (data) {
        final List<dynamic> list = data;
        return list.cast<Map<String, dynamic>>();
      },
    );
  }
}
