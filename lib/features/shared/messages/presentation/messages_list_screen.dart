import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/message_widgets.dart';

/// Messages List Screen
///
/// Displays all conversations for the current user.
/// Shows conversation tiles with:
/// - Avatar and online status
/// - Last message preview
/// - Unread count badge
/// - Time ago indicator
///
/// Backend Integration TODO:
/// - Integrate with MessagingService to fetch real conversations
/// - Implement real-time updates via WebSocket
/// - Add pull-to-refresh functionality
/// - Implement search and filter capabilities
/// - Add pagination/infinite scroll

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Mock data - replace with actual API integration
  final List<Conversation> _mockConversations = [
    Conversation(
      id: '1',
      title: 'Dr. Sarah Johnson',
      subtitle: 'Academic Counselor',
      avatar: null,
      lastMessage: Message(
        id: 'm1',
        conversationId: '1',
        senderId: 'counselor1',
        senderName: 'Dr. Sarah Johnson',
        content: 'Great! I\'ve reviewed your application. Let\'s discuss the scholarship opportunities.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isCurrentUser: false,
      ),
      unreadCount: 2,
      isOnline: true,
      participantIds: ['current_user', 'counselor1'],
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    Conversation(
      id: '2',
      title: 'University of Nairobi',
      subtitle: 'Admissions Office',
      avatar: null,
      lastMessage: Message(
        id: 'm2',
        conversationId: '2',
        senderId: 'current_user',
        senderName: 'You',
        content: 'Thank you for the information. When can I expect a response?',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isCurrentUser: true,
      ),
      unreadCount: 0,
      isOnline: false,
      participantIds: ['current_user', 'institution1'],
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Conversation(
      id: '3',
      title: 'John Kamau',
      subtitle: 'Student',
      avatar: null,
      lastMessage: Message(
        id: 'm3',
        conversationId: '3',
        senderId: 'student2',
        senderName: 'John Kamau',
        content: 'Hey! Did you check out the new Computer Science program?',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isCurrentUser: false,
      ),
      unreadCount: 1,
      isOnline: true,
      participantIds: ['current_user', 'student2'],
      lastActivity: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Conversation(
      id: '4',
      title: 'Strathmore University',
      subtitle: 'Financial Aid Office',
      avatar: null,
      lastMessage: Message(
        id: 'm4',
        conversationId: '4',
        senderId: 'institution2',
        senderName: 'Financial Aid',
        content: 'Your scholarship application has been received and is under review.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isCurrentUser: false,
      ),
      unreadCount: 0,
      isOnline: false,
      participantIds: ['current_user', 'institution2'],
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Conversation(
      id: '5',
      title: 'Mary Wanjiku',
      subtitle: 'Career Counselor',
      avatar: null,
      lastMessage: Message(
        id: 'm5',
        conversationId: '5',
        senderId: 'current_user',
        senderName: 'You',
        content: 'I\'ll prepare the documents and send them by tomorrow.',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isCurrentUser: true,
      ),
      unreadCount: 0,
      isOnline: false,
      participantIds: ['current_user', 'counselor2'],
      lastActivity: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<Conversation> get _filteredConversations {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _mockConversations;

    return _mockConversations.where((conversation) {
      return conversation.title.toLowerCase().contains(query) ||
          (conversation.subtitle?.toLowerCase().contains(query) ?? false) ||
          (conversation.lastMessage?.content.toLowerCase().contains(query) ??
              false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conversations = _filteredConversations;
    final unreadCount =
        conversations.fold<int>(0, (sum, c) => sum + c.unreadCount);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isSearching ? 'Search Messages' : 'Messages'),
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
      body: conversations.isEmpty
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
                  child: ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = conversations[index];
                      return ConversationTile(
                        conversation: conversation,
                        onTap: () {
                          context.push(
                            '/messages/${conversation.id}',
                            extra: conversation,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'messages_fab',
        onPressed: () {
          // Navigate to new conversation screen
          // context.push('/messages/new');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('New conversation feature - Backend integration required'),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
