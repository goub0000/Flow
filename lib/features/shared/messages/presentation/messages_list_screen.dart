import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/message_widgets.dart';
import '../../../shared/providers/conversations_realtime_provider.dart';
import '../../../../core/models/conversation_model.dart';

/// Messages List Screen
///
/// Displays all conversations for the current user with real-time updates.
/// Shows conversation tiles with:
/// - Avatar and online status
/// - Last message preview
/// - Unread count badge
/// - Time ago indicator
/// - Real-time message updates
/// - Connection status indicator

class MessagesListScreen extends ConsumerStatefulWidget {
  const MessagesListScreen({super.key});

  @override
  ConsumerState<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends ConsumerState<MessagesListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Conversation> _getFilteredConversations(List<Conversation> conversations) {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return conversations;

    return conversations.where((conversation) {
      // Search in title (if available)
      if (conversation.title?.toLowerCase().contains(query) ?? false) {
        return true;
      }
      // Search in last message preview
      if (conversation.lastMessagePreview?.toLowerCase().contains(query) ?? false) {
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversationsState = ref.watch(conversationsRealtimeProvider);
    final allConversations = conversationsState.conversations;
    final conversations = _getFilteredConversations(allConversations);
    final unreadCount = conversationsState.totalUnreadCount;
    final isConnected = conversationsState.isConnected;
    final isLoading = conversationsState.isLoading;
    final error = conversationsState.error;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            Text(_isSearching ? 'Search Messages' : 'Messages'),
            if (!isConnected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.cloud_off, size: 16, color: AppColors.warning),
            ],
          ],
        ),
        centerTitle: false,
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
        bottom: _isSearching
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              )
            : null,
      ),
      body: error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(error, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(conversationsRealtimeProvider.notifier).refresh();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : isLoading && conversations.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : conversations.isEmpty
                  ? const EmptyMessagesState(
                      message: 'No conversations yet',
                      icon: Icons.chat_bubble_outline,
                    )
                  : Column(
                      children: [
                        // Unread messages banner
                        if (unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            color: AppColors.primary.withValues(alpha: 0.1),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'You have $unreadCount unread message${unreadCount > 1 ? 's' : ''}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Conversations list
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              await ref.read(conversationsRealtimeProvider.notifier).refresh();
                            },
                            child: ListView.builder(
                              itemCount: conversations.length,
                              itemBuilder: (context, index) {
                                final conversation = conversations[index];
                                return _ConversationListTile(
                                  conversation: conversation,
                                  onTap: () {
                                    context.push('/messages/${conversation.id}');
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'messages_fab',
        onPressed: () {
          // TODO: Implement new conversation flow with user search
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New conversation feature - Coming soon'),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

/// Custom conversation list tile for real-time conversations
class _ConversationListTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationListTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = conversation.unreadCount > 0;
    final lastMessageTime = conversation.lastMessageAt;
    final timeAgo = lastMessageTime != null ? _formatTimeAgo(lastMessageTime) : '';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: hasUnread ? AppColors.primary.withValues(alpha: 0.05) : null,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar (placeholder for now)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.primary),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.title ?? 'Conversation',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timeAgo.isNotEmpty)
                        Text(
                          timeAgo,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hasUnread ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: hasUnread ? FontWeight.w600 : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessagePreview ?? 'No messages yet',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: hasUnread ? FontWeight.w600 : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
