import 'package:flutter/material.dart';
import '../../../core/l10n_extension.dart';

/// Typing indicator widget showing animated dots
class TypingIndicator extends StatefulWidget {
  final Color? color;
  final double size;

  const TypingIndicator({
    super.key,
    this.color,
    this.size = 8.0,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Stagger the animations
    _animation1 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    _animation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeInOut),
      ),
    );

    _animation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? Theme.of(context).colorScheme.secondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_animation1, dotColor),
        SizedBox(width: widget.size * 0.5),
        _buildDot(_animation2, dotColor),
        SizedBox(width: widget.size * 0.5),
        _buildDot(_animation3, dotColor),
      ],
    );
  }

  Widget _buildDot(Animation<double> animation, Color color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -widget.size * 0.5 * animation.value),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.5 + 0.5 * animation.value),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/// Typing indicator message bubble
class TypingIndicatorBubble extends StatelessWidget {
  final List<String> typingUserNames;

  const TypingIndicatorBubble({
    super.key,
    required this.typingUserNames,
  });

  @override
  Widget build(BuildContext context) {
    if (typingUserNames.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    String text;

    if (typingUserNames.length == 1) {
      text = context.l10n.typingIndicatorOneUser(typingUserNames[0]);
    } else if (typingUserNames.length == 2) {
      text = context.l10n.typingIndicatorTwoUsers(typingUserNames[0], typingUserNames[1]);
    } else {
      text = context.l10n.typingIndicatorMultipleUsers(typingUserNames[0], typingUserNames[1], (typingUserNames.length - 2).toString());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TypingIndicator(),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
