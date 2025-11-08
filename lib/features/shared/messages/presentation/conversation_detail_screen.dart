import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/message_widgets.dart';

/// Conversation Detail Screen
///
/// Displays a single conversation with message history and input field.
/// Features:
/// - Message bubbles (sent/received)
/// - Date dividers
/// - Typing indicators
/// - Message status indicators
/// - Auto-scroll to bottom
///
/// Backend Integration TODO:
/// - Integrate with MessagingService to fetch and send messages
/// - Implement WebSocket for real-time message updates
/// - Add message delivery/read status tracking
/// - Implement attachment support (images, files)
/// - Add message reactions and replies
/// - Implement message deletion/editing

class ConversationDetailScreen extends StatefulWidget {
  final String conversationId;
  final Conversation? conversation;

  const ConversationDetailScreen({
    super.key,
    required this.conversationId,
    this.conversation,
  });

  @override
  State<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTypingIndicator = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Mock messages - replace with actual API integration
  List<Message> _mockMessages = [];

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
    // Scroll to bottom after build
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _loadMockMessages() {
    _mockMessages = [
      Message(
        id: '1',
        conversationId: widget.conversationId,
        senderId: 'counselor1',
        senderName: widget.conversation?.title ?? 'User',
        content: 'Hi! I hope you\'re doing well. I wanted to discuss your application.',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 3)),
        isCurrentUser: false,
        status: MessageStatus.read,
      ),
      Message(
        id: '2',
        conversationId: widget.conversationId,
        senderId: 'current_user',
        senderName: 'You',
        content: 'Hello! Yes, I\'m looking forward to hearing your feedback.',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        isCurrentUser: true,
        status: MessageStatus.read,
      ),
      Message(
        id: '3',
        conversationId: widget.conversationId,
        senderId: 'counselor1',
        senderName: widget.conversation?.title ?? 'User',
        content: 'Your academic records are impressive. Have you considered applying for the merit scholarship?',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 2)),
        isCurrentUser: false,
        status: MessageStatus.read,
      ),
      Message(
        id: '4',
        conversationId: widget.conversationId,
        senderId: 'current_user',
        senderName: 'You',
        content: 'That sounds great! What are the requirements?',
        timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
        isCurrentUser: true,
        status: MessageStatus.read,
      ),
      Message(
        id: '5',
        conversationId: widget.conversationId,
        senderId: 'counselor1',
        senderName: widget.conversation?.title ?? 'User',
        content: 'You\'ll need to submit your transcripts, a recommendation letter, and a personal statement. The deadline is next month.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
        isCurrentUser: false,
        status: MessageStatus.read,
      ),
      Message(
        id: '6',
        conversationId: widget.conversationId,
        senderId: 'current_user',
        senderName: 'You',
        content: 'Perfect! I already have most of those documents ready.',
        timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 7)),
        isCurrentUser: true,
        status: MessageStatus.read,
      ),
      Message(
        id: '7',
        conversationId: widget.conversationId,
        senderId: 'counselor1',
        senderName: widget.conversation?.title ?? 'User',
        content: 'Great! I\'ve reviewed your application. Let\'s discuss the scholarship opportunities.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isCurrentUser: false,
        status: MessageStatus.delivered,
      ),
    ];
  }

  void _handleSendMessage(String content) {
    setState(() {
      // Add new message to list
      _mockMessages.add(
        Message(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
          conversationId: widget.conversationId,
          senderId: 'current_user',
          senderName: 'You',
          content: content,
          timestamp: DateTime.now(),
          isCurrentUser: true,
          status: MessageStatus.sending,
        ),
      );

      // Simulate typing indicator
      _showTypingIndicator = true;
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    // Simulate message being sent and response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          // Update message status to sent
          final lastMessageIndex = _mockMessages.length - 1;
          _mockMessages[lastMessageIndex] = Message(
            id: _mockMessages[lastMessageIndex].id,
            conversationId: _mockMessages[lastMessageIndex].conversationId,
            senderId: _mockMessages[lastMessageIndex].senderId,
            senderName: _mockMessages[lastMessageIndex].senderName,
            content: _mockMessages[lastMessageIndex].content,
            timestamp: _mockMessages[lastMessageIndex].timestamp,
            isCurrentUser: _mockMessages[lastMessageIndex].isCurrentUser,
            status: MessageStatus.sent,
          );
        });
      }
    });

    // Simulate response after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTypingIndicator = false;
          _mockMessages.add(
            Message(
              id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
              conversationId: widget.conversationId,
              senderId: 'counselor1',
              senderName: widget.conversation?.title ?? 'User',
              content: 'Thanks for your message! I\'ll get back to you shortly.',
              timestamp: DateTime.now(),
              isCurrentUser: false,
              status: MessageStatus.delivered,
            ),
          );
        });
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    // TODO: Replace with actual API call
    // await messagingService.sendMessage(
    //   conversationId: widget.conversationId,
    //   content: content,
    // );
  }

  Widget _buildMessageList() {
    final groupedMessages = <DateTime, List<Message>>{};

    // Group messages by date
    for (final message in _mockMessages) {
      final date = DateTime(
        message.timestamp.year,
        message.timestamp.month,
        message.timestamp.day,
      );
      groupedMessages.putIfAbsent(date, () => []).add(message);
    }

    final sortedDates = groupedMessages.keys.toList()..sort();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sortedDates.length + (_showTypingIndicator ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end
        if (_showTypingIndicator && index == sortedDates.length) {
          return TypingIndicator(
            userName: widget.conversation?.title ?? 'User',
          );
        }

        final date = sortedDates[index];
        final messages = groupedMessages[date]!;

        return Column(
          children: [
            MessageDateDivider(date: date),
            ...messages.map((message) => MessageBubble(
                  message: message,
                  onLongPress: () {
                    _showMessageOptions(message);
                  },
                )),
          ],
        );
      },
    );
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.isCurrentUser)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Delete Message'),
                onTap: () {
                  context.pop();
                  // TODO: Implement delete functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Delete message - Backend integration required'),
                    ),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Text'),
              onTap: () {
                context.pop();
                // TODO: Implement copy to clipboard
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Text copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                context.pop();
                // TODO: Implement reply functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: conversation?.avatar != null
                      ? NetworkImage(conversation!.avatar!)
                      : null,
                  child: conversation?.avatar == null
                      ? Text(
                          (conversation?.title ?? 'U')[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (conversation?.isOnline ?? false)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation?.title ?? 'Conversation',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (conversation?.subtitle != null)
                    Text(
                      conversation!.subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    )
                  else if (conversation?.isOnline ?? false)
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined),
            onPressed: () {
              // TODO: Implement video call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video call - Feature coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {
              // TODO: Implement voice call
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice call - Feature coming soon'),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: Show more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _mockMessages.isEmpty
                ? const EmptyMessagesState(
                    message: 'No messages yet\nSend a message to start the conversation',
                    icon: Icons.chat_bubble_outline,
                  )
                : _buildMessageList(),
          ),

          // Message input field
          MessageInputField(
            onSend: _handleSendMessage,
            onAttachment: () {
              // TODO: Implement attachment picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Attachments - Backend integration required'),
                ),
              );
            },
            placeholder: 'Type a message...',
          ),
        ],
      ),
    );
  }
}
