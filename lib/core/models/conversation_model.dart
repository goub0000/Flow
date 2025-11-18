import 'package:equatable/equatable.dart';

/// Message type enumeration
enum MessageType {
  text,
  image,
  file,
  audio,
  video;

  String toJson() => name;

  static MessageType fromJson(String json) {
    return MessageType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => MessageType.text,
    );
  }
}

/// Conversation type enumeration
enum ConversationType {
  direct, // 1-on-1
  group; // Multiple participants

  String toJson() => name;

  static ConversationType fromJson(String json) {
    return ConversationType.values.firstWhere(
      (e) => e.name == json,
      orElse: () => ConversationType.direct,
    );
  }
}

/// Model for a conversation
class Conversation extends Equatable {
  final String id;
  final ConversationType conversationType;
  final String? title;
  final List<String> participantIds;
  final DateTime? lastMessageAt;
  final String? lastMessagePreview;
  final int unreadCount;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.conversationType,
    this.title,
    required this.participantIds,
    this.lastMessageAt,
    this.lastMessagePreview,
    this.unreadCount = 0,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      conversationType: ConversationType.fromJson(
        json['conversation_type'] as String? ?? 'direct',
      ),
      title: json['title'] as String?,
      participantIds: (json['participant_ids'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastMessagePreview: json['last_message_preview'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_type': conversationType.toJson(),
      'title': title,
      'participant_ids': participantIds,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_message_preview': lastMessagePreview,
      'unread_count': unreadCount,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Conversation copyWith({
    String? id,
    ConversationType? conversationType,
    String? title,
    List<String>? participantIds,
    DateTime? lastMessageAt,
    String? lastMessagePreview,
    int? unreadCount,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      conversationType: conversationType ?? this.conversationType,
      title: title ?? this.title,
      participantIds: participantIds ?? this.participantIds,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      unreadCount: unreadCount ?? this.unreadCount,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Get the other participant ID in a direct conversation
  String? getOtherParticipantId(String currentUserId) {
    if (conversationType != ConversationType.direct) return null;
    return participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        conversationType,
        title,
        participantIds,
        lastMessageAt,
        lastMessagePreview,
        unreadCount,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Model for conversation list response
class ConversationListResponse extends Equatable {
  final List<Conversation> conversations;
  final int total;
  final int page;
  final int pageSize;
  final bool hasMore;

  const ConversationListResponse({
    required this.conversations,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) {
    return ConversationListResponse(
      conversations: (json['conversations'] as List<dynamic>?)
              ?.map((e) => Conversation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [conversations, total, page, pageSize, hasMore];
}

/// Request model for creating a new conversation
class ConversationCreateRequest {
  final List<String> participantIds;
  final ConversationType conversationType;
  final String? title;
  final Map<String, dynamic>? metadata;

  const ConversationCreateRequest({
    required this.participantIds,
    this.conversationType = ConversationType.direct,
    this.title,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'participant_ids': participantIds,
      'conversation_type': conversationType.toJson(),
      if (title != null) 'title': title,
      if (metadata != null) 'metadata': metadata,
    };
  }
}
