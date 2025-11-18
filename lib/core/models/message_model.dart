import 'package:equatable/equatable.dart';
import 'conversation_model.dart';

/// Model for a message in a conversation
class Message extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final MessageType messageType;
  final String? attachmentUrl;
  final String? replyToId;
  final bool isEdited;
  final bool isDeleted;
  final List<String> readBy;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.messageType = MessageType.text,
    this.attachmentUrl,
    this.replyToId,
    this.isEdited = false,
    this.isDeleted = false,
    this.readBy = const [],
    this.deliveredAt,
    this.readAt,
    this.metadata,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      messageType: MessageType.fromJson(
        json['message_type'] as String? ?? 'text',
      ),
      attachmentUrl: json['attachment_url'] as String?,
      replyToId: json['reply_to_id'] as String?,
      isEdited: json['is_edited'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      readBy: (json['read_by'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType.toJson(),
      'attachment_url': attachmentUrl,
      'reply_to_id': replyToId,
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'read_by': readBy,
      'delivered_at': deliveredAt?.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? messageType,
    String? attachmentUrl,
    String? replyToId,
    bool? isEdited,
    bool? isDeleted,
    List<String>? readBy,
    DateTime? deliveredAt,
    DateTime? readAt,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      replyToId: replyToId ?? this.replyToId,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      readBy: readBy ?? this.readBy,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if message is read by a specific user
  bool isReadBy(String userId) {
    return readBy.contains(userId);
  }

  /// Check if message is sent by a specific user
  bool isSentBy(String userId) {
    return senderId == userId;
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        messageType,
        attachmentUrl,
        replyToId,
        isEdited,
        isDeleted,
        readBy,
        deliveredAt,
        readAt,
        metadata,
        timestamp,
        createdAt,
        updatedAt,
      ];
}

/// Model for message list response
class MessageListResponse extends Equatable {
  final List<Message> messages;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const MessageListResponse({
    required this.messages,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory MessageListResponse.fromJson(Map<String, dynamic> json) {
    return MessageListResponse(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 50,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [messages, total, page, pageSize, hasMore];
}

/// Request model for sending a new message
class MessageCreateRequest {
  final String conversationId;
  final String content;
  final MessageType messageType;
  final String? attachmentUrl;
  final String? replyToId;
  final Map<String, dynamic>? metadata;

  const MessageCreateRequest({
    required this.conversationId,
    required this.content,
    this.messageType = MessageType.text,
    this.attachmentUrl,
    this.replyToId,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'content': content,
      'message_type': messageType.toJson(),
      if (attachmentUrl != null) 'attachment_url': attachmentUrl,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Request model for updating/editing a message
class MessageUpdateRequest {
  final String content;

  const MessageUpdateRequest({required this.content});

  Map<String, dynamic> toJson() {
    return {'content': content};
  }
}

/// Request model for marking messages as read
class ReadReceiptRequest {
  final List<String> messageIds;

  const ReadReceiptRequest({required this.messageIds});

  Map<String, dynamic> toJson() {
    return {'message_ids': messageIds};
  }
}

/// Request model for typing indicator
class TypingIndicatorRequest {
  final String conversationId;
  final bool isTyping;

  const TypingIndicatorRequest({
    required this.conversationId,
    required this.isTyping,
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'is_typing': isTyping,
    };
  }
}

/// Model for unread count response
class UnreadCountResponse extends Equatable {
  final int totalUnread;
  final Map<String, int> byConversation;

  const UnreadCountResponse({
    required this.totalUnread,
    required this.byConversation,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      totalUnread: (json['total_unread'] as num?)?.toInt() ?? 0,
      byConversation: Map<String, int>.from(
        json['by_conversation'] as Map? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [totalUnread, byConversation];
}
