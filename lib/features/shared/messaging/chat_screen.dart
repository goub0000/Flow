import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';
import '../../../core/providers/service_providers.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/logo_avatar.dart';
import '../widgets/typing_indicator.dart';
import '../providers/messaging_realtime_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();

    // Scroll to bottom when messages are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Send typing indicator when text changes
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();

    // Stop typing indicator
    if (_isTyping) {
      ref.read(conversationRealtimeProvider(widget.conversationId).notifier)
          .sendTypingIndicator(false);
    }

    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _messageController.text.trim().isNotEmpty;

    if (hasText && !_isTyping) {
      setState(() => _isTyping = true);
      ref.read(conversationRealtimeProvider(widget.conversationId).notifier)
          .sendTypingIndicator(true);
    } else if (!hasText && _isTyping) {
      setState(() => _isTyping = false);
      ref.read(conversationRealtimeProvider(widget.conversationId).notifier)
          .sendTypingIndicator(false);
    }
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

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);

    // Stop typing indicator
    if (_isTyping) {
      setState(() => _isTyping = false);
      ref.read(conversationRealtimeProvider(widget.conversationId).notifier)
          .sendTypingIndicator(false);
    }

    try {
      final message = await ref
          .read(conversationRealtimeProvider(widget.conversationId).notifier)
          .sendMessage(content);

      if (message != null && mounted) {
        _messageController.clear();

        // Scroll to bottom after sending
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.sharedMessagingFailedToSend(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversationState = ref.watch(conversationRealtimeProvider(widget.conversationId));
    final currentUser = ref.watch(currentUserProvider);
    final typingUsers = ref.watch(typingUsersProvider(widget.conversationId));

    final conversation = conversationState.conversation;
    final messages = conversationState.messages;
    final isLoading = conversationState.isLoading;
    final error = conversationState.error;
    final isConnected = conversationState.isConnected;

    // Get conversation title
    String title = context.l10n.sharedMessagingChat;
    if (conversation != null) {
      title = conversation.title ?? context.l10n.sharedMessagingChat;

      // For direct conversations, show the other participant's name
      if (conversation.conversationType == ConversationType.direct && currentUser != null) {
        final otherUserId = conversation.getOtherParticipantId(currentUser.id);
        // TODO: Fetch user profile for name
        title = 'User ${otherUserId?.substring(0, 8)}';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            LogoAvatar.user(
              photoUrl: null,
              initials: title.substring(0, 2),
              size: 36,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isConnected)
                    Text(
                      context.l10n.sharedMessagingConnecting,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.warning,
                      ),
                    )
                  else if (typingUsers.isNotEmpty)
                    Text(
                      typingUsers.length == 1 ? context.l10n.sharedMessagingTyping : context.l10n.sharedMessagingTypingMultiple(typingUsers.length),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showOptionsMenu();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Error State
          if (error != null)
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.error.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error,
                      style: TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref.read(conversationRealtimeProvider(widget.conversationId).notifier).refresh();
                    },
                    child: Text(context.l10n.sharedMessagingRetry),
                  ),
                ],
              ),
            ),

          // Loading State
          if (isLoading && messages.isEmpty)
            Expanded(
              child: LoadingIndicator(message: context.l10n.sharedMessagingLoadingMessages),
            )
          // Messages List
          else
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.message,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.sharedMessagingNoMessagesYet,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            context.l10n.sharedMessagingStartConversation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(conversationRealtimeProvider(widget.conversationId).notifier).refresh();
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length + (typingUsers.isNotEmpty ? 1 : 0),
                        itemBuilder: (context, index) {
                          // Show typing indicator at the end
                          if (typingUsers.isNotEmpty && index == messages.length) {
                            // TODO: Fetch user names from profile service
                            final typingUserNames = typingUsers.map((id) => 'User ${id.substring(0, 8)}').toList();
                            return TypingIndicatorBubble(typingUserNames: typingUserNames);
                          }

                          final message = messages[index];
                          final isCurrentUser = currentUser != null && message.senderId == currentUser.id;
                          final showDate = index == 0 ||
                              !_isSameDay(
                                message.timestamp,
                                messages[index - 1].timestamp,
                              );

                          return Column(
                            children: [
                              if (showDate) _DateDivider(date: message.timestamp),
                              _MessageBubble(
                                message: message,
                                isCurrentUser: isCurrentUser,
                                currentUserId: currentUser?.id,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),

          // Message Input
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Row(
                children: [
                  // Attach Button
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: _showAttachmentOptions,
                    color: AppColors.textSecondary,
                  ),

                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: context.l10n.sharedMessagingTypeMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Send Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Icon(Icons.send),
                      onPressed: _isSending ? null : _sendMessage,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search in conversation'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search feature coming soon'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.volume_off),
              title: const Text('Mute notifications'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mute feature coming soon'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attach File',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text('Photo & Video'),
              subtitle: const Text('From gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File attachments coming soon'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  final DateTime date;

  const _DateDivider({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final isYesterday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1;

    String dateText;
    if (isToday) {
      dateText = 'Today';
    } else if (isYesterday) {
      dateText = 'Yesterday';
    } else {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      dateText = '${date.day} ${months[date.month - 1]} ${date.year}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.border)),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isCurrentUser;
  final String? currentUserId;

  const _MessageBubble({
    required this.message,
    required this.isCurrentUser,
    this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = currentUserId != null && message.isReadBy(currentUserId!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            LogoAvatar.user(
              photoUrl: null,
              initials: message.senderId.substring(0, 2),
              size: 32,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isCurrentUser
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      Radius.circular(isCurrentUser ? 16 : 4),
                  bottomRight:
                      Radius.circular(isCurrentUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.isEdited)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Edited',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: isCurrentUser
                              ? Colors.white.withOpacity(0.7)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  if (message.isDeleted)
                    Text(
                      'This message was deleted',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isCurrentUser
                            ? Colors.white.withOpacity(0.7)
                            : AppColors.textSecondary,
                      ),
                    )
                  else
                    Text(
                      message.content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isCurrentUser
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: isCurrentUser
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          isRead
                              ? Icons.done_all
                              : Icons.done,
                          size: 14,
                          color: isRead
                              ? AppColors.success
                              : Colors.white.withValues(alpha: 0.8),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 24),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
