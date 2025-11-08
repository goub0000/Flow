import 'chat_message.dart';

/// Represents a complete conversation session with a user
class Conversation {
  final String id;
  final String userId;
  final String userName;
  final DateTime startTime;
  final DateTime lastMessageTime;
  final List<ChatMessage> messages;
  final ConversationStatus status;
  final int messageCount;
  final String? userEmail;
  final String? userRole;

  const Conversation({
    required this.id,
    required this.userId,
    required this.userName,
    required this.startTime,
    required this.lastMessageTime,
    required this.messages,
    required this.status,
    required this.messageCount,
    this.userEmail,
    this.userRole,
  });

  /// Create conversation from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
      status: ConversationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ConversationStatus.active,
      ),
      messageCount: json['messageCount'] as int,
      userEmail: json['userEmail'] as String?,
      userRole: json['userRole'] as String?,
    );
  }

  /// Convert conversation to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'startTime': startTime.toIso8601String(),
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'status': status.name,
      'messageCount': messageCount,
      'userEmail': userEmail,
      'userRole': userRole,
    };
  }

  /// Create a copy with updated fields
  Conversation copyWith({
    String? id,
    String? userId,
    String? userName,
    DateTime? startTime,
    DateTime? lastMessageTime,
    List<ChatMessage>? messages,
    ConversationStatus? status,
    int? messageCount,
    String? userEmail,
    String? userRole,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      startTime: startTime ?? this.startTime,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      messages: messages ?? this.messages,
      status: status ?? this.status,
      messageCount: messageCount ?? this.messageCount,
      userEmail: userEmail ?? this.userEmail,
      userRole: userRole ?? this.userRole,
    );
  }

  /// Get duration of conversation
  Duration get duration => lastMessageTime.difference(startTime);

  /// Get most recent message
  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  /// Count user messages
  int get userMessageCount =>
      messages.where((m) => m.sender == SenderType.user).length;

  /// Count bot messages
  int get botMessageCount =>
      messages.where((m) => m.sender == SenderType.bot).length;
}

/// Status of a conversation
enum ConversationStatus {
  active,
  archived,
  flagged,
}
