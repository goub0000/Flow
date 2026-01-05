import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../application/providers/chatbot_provider.dart';
import 'message_bubble.dart';
import 'quick_replies.dart';
import 'typing_indicator.dart';
import 'input_field.dart';

class ChatWindow extends ConsumerStatefulWidget {
  const ChatWindow({super.key});

  @override
  ConsumerState<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends ConsumerState<ChatWindow>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  // Dialog state
  bool _showEscalationDialogInline = false;
  bool _showUserMenuInline = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation
    _animationController.forward();

    // Send initial greeting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatbotProvider.notifier).sendInitialGreeting();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    ref.read(chatbotProvider.notifier).sendMessage(text);
    _inputController.clear();
    _scrollToBottom();
  }

  void _handleQuickAction(String action) {
    // Handle navigation actions
    if (action == 'navigate_register') {
      _close();
      context.go('/register');
      return;
    }
    if (action == 'navigate_login') {
      // Set flag to reopen chat after login
      ref.read(chatbotPendingReopenProvider.notifier).state = true;
      _close();
      context.go('/login');
      return;
    }
    if (action == 'view_profile') {
      _close();
      context.go('/profile');
      return;
    }

    ref.read(chatbotProvider.notifier).handleQuickAction(action);
    _scrollToBottom();
  }

  void _showEscalationDialog() {
    setState(() => _showEscalationDialogInline = true);
  }

  void _escalateToHuman() {
    ref.read(chatbotProvider.notifier).escalateToHuman(
      reason: 'User requested human support',
    );
    _scrollToBottom();
  }

  void _close() {
    _animationController.reverse().then((_) {
      ref.read(chatbotVisibleProvider.notifier).state = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotProvider);
    final size = MediaQuery.of(context).size;

    // Auto-scroll when new messages arrive
    ref.listen(chatbotProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    final authState = ref.watch(authProvider);
    final isLoggedIn = authState.isAuthenticated;
    final user = authState.user;

    return Stack(
      children: [
        // Main chat window
        Positioned(
          bottom: 80,
          right: 16,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: size.width > 768 ? 400 : size.width - 32,
              height: size.height * 0.6,
              constraints: const BoxConstraints(
                maxHeight: 600,
                minHeight: 400,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Messages
                  Expanded(
                    child: state.messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return MessageBubble(message: message);
                            },
                          ),
                  ),

                  // Typing Indicator
                  if (state.isTyping)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TypingIndicator(),
                    ),

                  // Quick Replies
                  if (state.currentQuickActions != null &&
                      state.currentQuickActions!.isNotEmpty)
                    QuickReplies(
                      actions: state.currentQuickActions!,
                      onActionTap: _handleQuickAction,
                    ),

                  // Input Field
                  ChatInputField(
                    controller: _inputController,
                    onSend: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Inline Escalation Dialog
        if (_showEscalationDialogInline)
          _buildInlineDialog(
            title: Row(
              children: [
                Icon(Icons.support_agent, color: AppColors.primary),
                const SizedBox(width: 12),
                const Text('Talk to a Human'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Would you like to connect with a support agent?',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 12),
                Text(
                  'A member of our team will join this conversation to assist you.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => setState(() => _showEscalationDialogInline = false),
                child: const Text('Cancel'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() => _showEscalationDialogInline = false);
                  _escalateToHuman();
                },
                icon: const Icon(Icons.person, size: 18),
                label: const Text('Connect'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),

        // Inline User Menu Dialog
        if (_showUserMenuInline)
          _buildInlineDialog(
            title: Row(
              children: [
                Icon(
                  isLoggedIn ? Icons.account_circle : Icons.login,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(isLoggedIn ? 'Your Account' : 'Sign In'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoggedIn) ...[
                  Text(
                    'Signed in as:',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your conversations are being synced to your account.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ] else ...[
                  const Text(
                    'Sign in to sync your conversations across devices and get personalized assistance.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your chat history will be saved to your account.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => setState(() => _showUserMenuInline = false),
                child: const Text('Close'),
              ),
              if (!isLoggedIn)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showUserMenuInline = false);
                    ref.read(chatbotPendingReopenProvider.notifier).state = true;
                    _close();
                    context.go('/login');
                  },
                  icon: const Icon(Icons.login, size: 18),
                  label: const Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              if (isLoggedIn)
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showUserMenuInline = false);
                    _close();
                    context.go('/profile');
                  },
                  icon: const Icon(Icons.person, size: 18),
                  label: const Text('View Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildInlineDialog({
    required Widget title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() {
          _showEscalationDialogInline = false;
          _showUserMenuInline = false;
        }),
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping dialog
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      child: title,
                    ),
                    const SizedBox(height: 16),
                    content,
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final state = ref.watch(chatbotProvider);
    final authState = ref.watch(authProvider);
    final isEscalated = state.isEscalated;
    final isLoggedIn = authState.isAuthenticated;
    final user = authState.user;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEscalated ? AppColors.warning : AppColors.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: Icon(
              isEscalated ? Icons.person : Icons.support_agent,
              color: isEscalated ? AppColors.warning : AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEscalated ? 'Human Support' : 'Flow Assistant',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    if (isEscalated) ...[
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                          color: Colors.orangeAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Text(
                        'Waiting for agent...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ] else
                      const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          // User account button
          IconButton(
            icon: Icon(
              isLoggedIn ? Icons.account_circle : Icons.login,
              color: Colors.white,
            ),
            onPressed: () => _showUserMenu(isLoggedIn, user?.displayName),
          ),
          // Talk to Human button
          if (!isEscalated)
            IconButton(
              icon: const Icon(Icons.person_add, color: Colors.white),
              onPressed: _showEscalationDialog,
            ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: _close,
          ),
        ],
      ),
    );
  }

  void _showUserMenu(bool isLoggedIn, String? userName) {
    setState(() => _showUserMenuInline = true);
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
