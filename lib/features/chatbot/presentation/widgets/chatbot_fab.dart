import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/providers/chatbot_provider.dart';
import 'chat_window.dart';

class ChatbotFAB extends ConsumerStatefulWidget {
  const ChatbotFAB({super.key});

  @override
  ConsumerState<ChatbotFAB> createState() => _ChatbotFABState();
}

class _ChatbotFABState extends ConsumerState<ChatbotFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _showTooltip = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Hide tooltip after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() => _showTooltip = false);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    ref.read(chatbotVisibleProvider.notifier).state =
        !ref.read(chatbotVisibleProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = ref.watch(chatbotVisibleProvider);

    return Stack(
      children: [
        // Chat Window
        if (isVisible) const ChatWindow(),

        // FAB with tooltip
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tooltip
              if (_showTooltip && !isVisible)
                Container(
                  margin: const EdgeInsets.only(bottom: 8, right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Hi! Need help? 👋',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => setState(() => _showTooltip = false),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

              // Floating Action Button
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _showTooltip && !isVisible
                        ? 1.0 + (_pulseController.value * 0.1)
                        : 1.0,
                    child: FloatingActionButton(
                      heroTag: 'chatbot_fab',
                      onPressed: _toggleChat,
                      backgroundColor: AppColors.primary,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          isVisible ? Icons.close : Icons.chat_bubble,
                          key: ValueKey(isVisible),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
