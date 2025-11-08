class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final List<String>? attachments;

  Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.content,
    required this.type,
    required this.timestamp,
    required this.isRead,
    this.attachments,
  });

  String get initials {
    final names = senderName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return senderName.substring(0, 1).toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversationId': conversationId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'content': content,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'attachments': attachments,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderPhotoUrl: json['senderPhotoUrl'] as String?,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : null,
    );
  }

  static List<Message> mockMessages(String conversationId) {
    return [
      Message(
        id: 'msg1',
        conversationId: conversationId,
        senderId: 'user2',
        senderName: 'Dr. Sarah Johnson',
        content: 'Hello! How can I help you today?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      Message(
        id: 'msg2',
        conversationId: conversationId,
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'I have a question about the upcoming assignment.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
        isRead: true,
      ),
      Message(
        id: 'msg3',
        conversationId: conversationId,
        senderId: 'user2',
        senderName: 'Dr. Sarah Johnson',
        content: 'Of course! What would you like to know?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
        isRead: true,
      ),
      Message(
        id: 'msg4',
        conversationId: conversationId,
        senderId: 'user1',
        senderName: 'John Doe',
        content: 'Is it due this Friday or next Friday?',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
        isRead: true,
      ),
      Message(
        id: 'msg5',
        conversationId: conversationId,
        senderId: 'user2',
        senderName: 'Dr. Sarah Johnson',
        content: 'The assignment is due next Friday, March 15th, at 11:59 PM.',
        type: MessageType.text,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
    ];
  }

  /// Single mock message for development
  static Message mockMessage([int index = 0]) {
    final senders = [
      {'id': 'user1', 'name': 'John Doe'},
      {'id': 'user2', 'name': 'Dr. Sarah Johnson'},
      {'id': 'user3', 'name': 'Prof. Michael Chen'},
      {'id': 'user4', 'name': 'Emily Brown'},
    ];
    final contents = [
      'Hello! This is a test message.',
      'The assignment is due next Friday.',
      'Thank you for the information!',
      'Can we schedule a meeting?',
    ];

    final sender = senders[index % senders.length];
    return Message(
      id: 'msg${index + 1}',
      conversationId: 'conv${(index % 3) + 1}',
      senderId: sender['id']!,
      senderName: sender['name']!,
      content: contents[index % contents.length],
      type: MessageType.text,
      timestamp: DateTime.now().subtract(Duration(hours: index + 1)),
      isRead: index % 2 == 0,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  system,
}

class Conversation {
  final String id;
  final String participantId;
  final String participantName;
  final String? participantPhotoUrl;
  final String? participantRole;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime lastActivity;

  Conversation({
    required this.id,
    required this.participantId,
    required this.participantName,
    this.participantPhotoUrl,
    this.participantRole,
    this.lastMessage,
    required this.unreadCount,
    required this.lastActivity,
  });

  String get initials {
    final names = participantName.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return participantName.substring(0, 1).toUpperCase();
  }

  String get lastMessagePreview {
    if (lastMessage == null) return 'No messages yet';
    if (lastMessage!.type == MessageType.image) return '📷 Image';
    if (lastMessage!.type == MessageType.file) return '📎 File';
    if (lastMessage!.content.length > 50) {
      return '${lastMessage!.content.substring(0, 50)}...';
    }
    return lastMessage!.content;
  }

  String get formattedLastActivity {
    final now = DateTime.now();
    final difference = now.difference(lastActivity);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastActivity.day}/${lastActivity.month}/${lastActivity.year}';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantId': participantId,
      'participantName': participantName,
      'participantPhotoUrl': participantPhotoUrl,
      'participantRole': participantRole,
      'lastMessage': lastMessage?.toJson(),
      'unreadCount': unreadCount,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      participantPhotoUrl: json['participantPhotoUrl'] as String?,
      participantRole: json['participantRole'] as String?,
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      unreadCount: json['unreadCount'] as int,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }

  static List<Conversation> mockConversations() {
    return [
      Conversation(
        id: 'conv1',
        participantId: 'user2',
        participantName: 'Dr. Sarah Johnson',
        participantRole: 'Counselor',
        lastMessage: Message(
          id: 'msg1',
          conversationId: 'conv1',
          senderId: 'user2',
          senderName: 'Dr. Sarah Johnson',
          content: 'The assignment is due next Friday, March 15th, at 11:59 PM.',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: false,
        ),
        unreadCount: 1,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Conversation(
        id: 'conv2',
        participantId: 'user3',
        participantName: 'Prof. Michael Chen',
        participantRole: 'Institution',
        lastMessage: Message(
          id: 'msg2',
          conversationId: 'conv2',
          senderId: 'user1',
          senderName: 'John Doe',
          content: 'Thank you for the information!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: true,
        ),
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Conversation(
        id: 'conv3',
        participantId: 'user4',
        participantName: 'Emily Brown',
        participantRole: 'Student',
        lastMessage: Message(
          id: 'msg3',
          conversationId: 'conv3',
          senderId: 'user4',
          senderName: 'Emily Brown',
          content: 'Can we schedule a meeting to discuss my application?',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: false,
        ),
        unreadCount: 2,
        lastActivity: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Conversation(
        id: 'conv4',
        participantId: 'user5',
        participantName: 'David Wilson',
        participantRole: 'Recommender',
        lastMessage: Message(
          id: 'msg4',
          conversationId: 'conv4',
          senderId: 'user5',
          senderName: 'David Wilson',
          content: 'I\'ve submitted your recommendation letter.',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
        ),
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Conversation(
        id: 'conv5',
        participantId: 'user6',
        participantName: 'Lisa Anderson',
        participantRole: 'Parent',
        lastMessage: Message(
          id: 'msg5',
          conversationId: 'conv5',
          senderId: 'user1',
          senderName: 'John Doe',
          content: 'I\'ll send you the progress report soon.',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
        ),
        unreadCount: 0,
        lastActivity: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
