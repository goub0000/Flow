import 'package:flutter/material.dart';

/// Feedback type for messages
enum MessageFeedback { helpful, notHelpful, none }

/// Represents a message in the chatbot conversation
class ChatMessage {
  final String id;
  final String content;
  final MessageType type;
  final SenderType sender;
  final DateTime timestamp;
  final List<QuickAction>? quickActions;
  final String? conversationId;
  final double? confidence;
  final String? aiProvider;
  final int? tokensUsed;
  final bool shouldEscalate;
  final String? escalationReason;
  final MessageFeedback feedback;
  final String? feedbackComment;

  ChatMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    required this.timestamp,
    this.quickActions,
    this.conversationId,
    this.confidence,
    this.aiProvider,
    this.tokensUsed,
    this.shouldEscalate = false,
    this.escalationReason,
    this.feedback = MessageFeedback.none,
    this.feedbackComment,
  });

  /// Factory constructor for bot messages
  factory ChatMessage.bot({
    required String content,
    List<QuickAction>? quickActions,
  }) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.text,
      sender: SenderType.bot,
      timestamp: DateTime.now(),
      quickActions: quickActions,
    );
  }

  /// Factory constructor for user messages
  factory ChatMessage.user({required String content}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.text,
      sender: SenderType.user,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for system messages
  factory ChatMessage.system({required String content}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.text,
      sender: SenderType.system,
      timestamp: DateTime.now(),
    );
  }

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    SenderType? sender,
    DateTime? timestamp,
    List<QuickAction>? quickActions,
    String? conversationId,
    double? confidence,
    String? aiProvider,
    int? tokensUsed,
    bool? shouldEscalate,
    String? escalationReason,
    MessageFeedback? feedback,
    String? feedbackComment,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      quickActions: quickActions ?? this.quickActions,
      conversationId: conversationId ?? this.conversationId,
      confidence: confidence ?? this.confidence,
      aiProvider: aiProvider ?? this.aiProvider,
      tokensUsed: tokensUsed ?? this.tokensUsed,
      shouldEscalate: shouldEscalate ?? this.shouldEscalate,
      escalationReason: escalationReason ?? this.escalationReason,
      feedback: feedback ?? this.feedback,
      feedbackComment: feedbackComment ?? this.feedbackComment,
    );
  }

  /// Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? json['message_id'] as String? ?? '',
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (t) => t.name == json['type'] || t.name == json['message_type'],
        orElse: () => MessageType.text,
      ),
      sender: SenderType.values.firstWhere(
        (s) => s.name == json['sender'],
        orElse: () => SenderType.user,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now(),
      quickActions: json['quickActions'] != null
          ? (json['quickActions'] as List)
              .map((q) => QuickAction.fromJson(q as Map<String, dynamic>))
              .toList()
          : json['quick_actions'] != null
              ? (json['quick_actions'] as List)
                  .map((q) => QuickAction.fromJson(q as Map<String, dynamic>))
                  .toList()
              : null,
      conversationId: json['conversation_id'] as String?,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      aiProvider: json['ai_provider'] as String?,
      tokensUsed: json['tokens_used'] as int?,
      shouldEscalate: json['should_escalate'] as bool? ?? false,
      escalationReason: json['escalation_reason'] as String?,
      feedback: json['feedback'] != null
          ? MessageFeedback.values.firstWhere(
              (f) => f.name == json['feedback'] ||
                  (json['feedback'] == 'helpful' && f == MessageFeedback.helpful) ||
                  (json['feedback'] == 'not_helpful' && f == MessageFeedback.notHelpful),
              orElse: () => MessageFeedback.none,
            )
          : MessageFeedback.none,
      feedbackComment: json['feedback_comment'] as String?,
    );
  }

  /// Create from API response
  factory ChatMessage.fromApiResponse(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['message_id'] as String? ?? '',
      content: json['content'] as String,
      type: MessageType.text,
      sender: SenderType.bot,
      timestamp: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      quickActions: json['quick_actions'] != null
          ? (json['quick_actions'] as List)
              .map((q) => QuickAction.fromJson(q as Map<String, dynamic>))
              .toList()
          : null,
      conversationId: json['conversation_id'] as String?,
      confidence: json['confidence'] != null
          ? (json['confidence'] as num).toDouble()
          : null,
      aiProvider: json['ai_provider'] as String?,
      tokensUsed: json['tokens_used'] as int?,
      shouldEscalate: json['should_escalate'] as bool? ?? false,
      escalationReason: json['escalation_reason'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'sender': sender.name,
      'timestamp': timestamp.toIso8601String(),
      'quickActions': quickActions?.map((q) => q.toJson()).toList(),
      'conversation_id': conversationId,
      'confidence': confidence,
      'ai_provider': aiProvider,
      'tokens_used': tokensUsed,
      'should_escalate': shouldEscalate,
      'escalation_reason': escalationReason,
      'feedback': feedback.name,
      'feedback_comment': feedbackComment,
    };
  }
}

/// Type of message
enum MessageType {
  text,
  quickReply,
  card,
  image,
}

/// Who sent the message
enum SenderType {
  user,
  bot,
  system,
  agent,
}

/// Quick action button for user to click
class QuickAction {
  final String id;
  final String label;
  final String action;
  final IconData? icon;

  const QuickAction({
    required this.id,
    required this.label,
    required this.action,
    this.icon,
  });

  /// Create from JSON
  factory QuickAction.fromJson(Map<String, dynamic> json) {
    return QuickAction(
      id: json['id'] as String,
      label: json['label'] as String,
      action: json['action'] as String,
      // Note: Icons can't be serialized, will be null when loaded
      icon: null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'action': action,
      // Note: Icons are not serialized
    };
  }
}
