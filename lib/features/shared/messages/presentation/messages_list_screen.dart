import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/message_widgets.dart' hide Conversation;
import '../../../shared/providers/conversations_realtime_provider.dart';
import '../../../../core/models/conversation_model.dart';
import '../../../../core/providers/service_providers.dart';

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

  /// Show dialog to search and select a user for new conversation
  void _showNewConversationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewConversationSheet(
        onUserSelected: (userId, userName) async {
          Navigator.pop(context);

          // Show loading indicator
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Text('Starting conversation with $userName...'),
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );

          // Get or create conversation
          final conversation = await ref
              .read(conversationsRealtimeProvider.notifier)
              .getOrCreateDirectConversation(userId);

          if (conversation != null && mounted) {
            context.push('/messages/${conversation.id}');
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.msgFailedToCreateConversation),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      ),
    );
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
            Text(_isSearching ? context.l10n.msgSearchMessages : context.l10n.msgMessages),
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
                      hintText: context.l10n.msgSearchConversations,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(conversationsRealtimeProvider.notifier).refresh();
                    },
                    child: Text(context.l10n.msgRetry),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final messagingService = ref.read(messagingServiceProvider);
                      final result = await messagingService.checkSetup();
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(context.l10n.msgDatabaseSetupStatus),
                            content: SingleChildScrollView(
                              child: Text(
                                result.success
                                    ? 'Ready: ${result.data?['ready']}\n'
                                      'Conversations table: ${result.data?['conversations_table']}\n'
                                      'Messages table: ${result.data?['messages_table']}\n\n'
                                      'Info: ${result.data?['tables_info']}'
                                    : 'Error: ${result.message}',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(context.l10n.msgCheckDatabaseSetup),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final messagingService = ref.read(messagingServiceProvider);
                      final result = await messagingService.testInsert();
                      if (mounted) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(context.l10n.msgTestInsertResult),
                            content: SingleChildScrollView(
                              child: Text(
                                result.success
                                    ? 'SUCCESS!\n\n${result.data}'
                                    : 'FAILED!\n\nError: ${result.message}\n\nData: ${result.data}',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(context.l10n.msgTestInsert),
                  ),
                ],
              ),
            )
          : isLoading && conversations.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : conversations.isEmpty
                  ? EmptyMessagesState(
                      message: context.l10n.msgNoConversationsYet,
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
        onPressed: _showNewConversationDialog,
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

/// Bottom sheet for searching and selecting a user to start a new conversation
class _NewConversationSheet extends ConsumerStatefulWidget {
  final Function(String userId, String userName) onUserSelected;

  const _NewConversationSheet({required this.onUserSelected});

  @override
  ConsumerState<_NewConversationSheet> createState() => _NewConversationSheetState();
}

class _NewConversationSheetState extends ConsumerState<_NewConversationSheet> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use backend API to search users
      final messagingService = ref.read(messagingServiceProvider);
      final response = await messagingService.searchUsers();

      if (response.success && response.data != null) {
        setState(() {
          _users = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load users';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load users: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _users;

    return _users.where((user) {
      final name = (user['display_name'] ?? '').toString().toLowerCase();
      final email = (user['email'] ?? '').toString().toLowerCase();
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredUsers = _getFilteredUsers();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  context.l10n.msgNewConversation,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: context.l10n.msgSearchByNameOrEmail,
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

          const SizedBox(height: 16),

          // Users list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 48),
                            const SizedBox(height: 16),
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadUsers,
                              child: Text(context.l10n.msgRetry),
                            ),
                          ],
                        ),
                      )
                    : filteredUsers.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_search, size: 48, color: Colors.grey[400]),
                                const SizedBox(height: 16),
                                Text(
                                  _searchController.text.isEmpty
                                      ? context.l10n.msgNoUsersFound
                                      : context.l10n.msgNoUsersMatch(_searchController.text),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              final userId = user['id'] as String;
                              final displayName = user['display_name'] as String? ?? 'Unknown User';
                              final email = user['email'] as String? ?? '';
                              final role = user['active_role'] as String? ?? 'user';
                              final photoUrl = user['photo_url'] as String?;

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                                  child: photoUrl == null
                                      ? Text(
                                          displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  displayName,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(email),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(role).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _formatRole(role),
                                    style: TextStyle(
                                      color: _getRoleColor(role),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                onTap: () => widget.onUserSelected(userId, displayName),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return AppColors.primary;
      case 'counselor':
        return Colors.green;
      case 'parent':
        return Colors.orange;
      case 'institution':
        return Colors.purple;
      case 'admin':
      case 'super_admin':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatRole(String role) {
    return role.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
