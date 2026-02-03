import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/conversation_model.dart';
import '../../../core/models/message_model.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/logo_avatar.dart';
import '../providers/messaging_provider.dart' hide Conversation;

/// @deprecated This screen is deprecated. Use MessagesListScreen instead which has
/// real-time messaging support with Supabase. This file is kept for backwards compatibility
/// but should not be used in new code.
///
/// See: lib/features/shared/messages/presentation/messages_list_screen.dart
@Deprecated('Use MessagesListScreen instead')
class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagingLoadingProvider);
    final error = ref.watch(messagingErrorProvider);
    final conversations = ref.watch(conversationsListProvider);

    final filteredConversations = conversations.where((conv) {
      return conv.participantName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: _showNewConversationDialog,
            tooltip: 'New Message',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Error State
          if (error != null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(error, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(messagingProvider.notifier).fetchConversations();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          // Loading State
          else if (isLoading)
            const Expanded(
              child: LoadingIndicator(message: 'Loading conversations...'),
            )
          // Conversations List
          else
            Expanded(
              child: filteredConversations.isEmpty
                  ? EmptyState(
                      icon: _searchQuery.isEmpty ? Icons.message : Icons.search_off,
                      title: _searchQuery.isEmpty ? 'No Messages' : 'Not Found',
                      message: _searchQuery.isEmpty
                          ? 'No conversations yet'
                          : 'No conversations found',
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(messagingProvider.notifier).fetchConversations();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredConversations.length,
                        itemBuilder: (context, index) {
                          final conversation = filteredConversations[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _ConversationCard(
                              conversation: conversation,
                              onTap: () {
                                context.go('/messages/${conversation.id}');
                              },
                            ),
                          );
                        },
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  void _showNewConversationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Conversation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a person...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                onChanged: (value) {
                  // TODO: Implement search filtering
                },
              ),
              const SizedBox(height: 20),

              Text(
                'SUGGESTED',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),

              // User List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 10, // TODO: Replace with actual user list
                  itemBuilder: (context, index) {
                    // TODO: Replace with actual user data
                    final userName = 'User ${index + 1}';
                    final userRole = index % 3 == 0
                        ? 'Student'
                        : index % 3 == 1
                            ? 'Teacher'
                            : 'Admin';
                    final initials = userName.split(' ').map((e) => e[0]).join();

                    return ListTile(
                      leading: LogoAvatar.user(
                        photoUrl: null, // TODO: Add actual user photo
                        initials: initials,
                        size: 40,
                      ),
                      title: Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        userRole,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Create new conversation with selected user
                        // For now, navigate to a demo conversation
                        context.go('/messages/new_${index + 1}');

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Starting conversation with $userName'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasUnread = conversation.unreadCount > 0;

    return CustomCard(
      onTap: onTap,
      color: hasUnread ? AppColors.primary.withValues(alpha: 0.05) : null,
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              LogoAvatar.user(
                photoUrl: conversation.participantPhotoUrl,
                initials: conversation.initials,
                size: 56,
              ),
              if (hasUnread)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.participantName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight:
                              hasUnread ? FontWeight.bold : FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      conversation.formattedLastActivity,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: hasUnread
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: hasUnread ? FontWeight.w600 : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (conversation.participantRole != null) ...[
                  Text(
                    conversation.participantRole!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.lastMessagePreview ?? '',
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
    );
  }
}
