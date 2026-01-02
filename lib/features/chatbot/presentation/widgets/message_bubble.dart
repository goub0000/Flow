import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final Function(String messageId, MessageFeedback feedback)? onFeedback;

  const MessageBubble({
    super.key,
    required this.message,
    this.onFeedback,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _showFeedbackOptions = false;
  MessageFeedback _localFeedback = MessageFeedback.none;

  @override
  void initState() {
    super.initState();
    _localFeedback = widget.message.feedback;
  }

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.sender == SenderType.user;
    final isBot = widget.message.sender == SenderType.bot;
    final isAgent = widget.message.sender == SenderType.agent;
    final isSystem = widget.message.sender == SenderType.system;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(isAgent, isSystem),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Agent/System label
                if (isAgent || isSystem)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      isAgent ? 'Support Agent' : 'System',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isAgent ? AppColors.primary : Colors.grey[600],
                      ),
                    ),
                  ),
                // Message bubble
                GestureDetector(
                  onLongPress: isBot && _localFeedback == MessageFeedback.none
                      ? () => setState(() => _showFeedbackOptions = true)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getBubbleColor(isUser, isAgent, isSystem),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser
                            ? const Radius.circular(16)
                            : const Radius.circular(4),
                        bottomRight: isUser
                            ? const Radius.circular(4)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: _buildMessageContent(isUser),
                  ),
                ),
                const SizedBox(height: 4),
                // Time and confidence indicator
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(widget.message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Show confidence indicator for bot messages
                    if (isBot && widget.message.confidence != null) ...[
                      const SizedBox(width: 8),
                      _buildConfidenceIndicator(widget.message.confidence!),
                    ],
                    // Show AI provider badge
                    if (isBot && widget.message.aiProvider != null) ...[
                      const SizedBox(width: 8),
                      _buildAiProviderBadge(widget.message.aiProvider!),
                    ],
                  ],
                ),
                // Feedback section for bot messages
                if (isBot) ...[
                  const SizedBox(height: 8),
                  _buildFeedbackSection(),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Color _getBubbleColor(bool isUser, bool isAgent, bool isSystem) {
    if (isUser) return AppColors.primary;
    if (isAgent) return Colors.blue[50]!;
    if (isSystem) return Colors.amber[50]!;
    return Colors.grey[100]!;
  }

  /// Build message content with markdown support for bot messages
  Widget _buildMessageContent(bool isUser) {
    final content = widget.message.content;

    // For user messages, just show plain text
    if (isUser) {
      return Text(
        content,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.4,
        ),
      );
    }

    // Check if content contains markdown indicators
    final hasMarkdown = _containsMarkdown(content);

    if (!hasMarkdown) {
      // Plain text for bot messages without markdown
      return Text(
        content,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
          height: 1.4,
        ),
      );
    }

    // Render markdown for bot messages with formatting
    return MarkdownBody(
      data: content,
      selectable: true,
      shrinkWrap: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          _launchUrl(href);
        }
      },
      styleSheet: _buildMarkdownStyleSheet(),
      builders: {
        'code': CodeBlockBuilder(),
      },
    );
  }

  bool _containsMarkdown(String content) {
    // Check for common markdown patterns
    return content.contains('**') ||
        content.contains('__') ||
        content.contains('*') ||
        content.contains('_') ||
        content.contains('`') ||
        content.contains('```') ||
        content.contains('#') ||
        content.contains('- ') ||
        content.contains('* ') ||
        content.contains('1. ') ||
        content.contains('[') && content.contains('](') ||
        content.contains('>');
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      p: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        height: 1.4,
      ),
      h1: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      h2: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      h3: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      strong: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      em: const TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.black87,
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        backgroundColor: Colors.grey[200],
        color: Colors.black87,
      ),
      codeblockDecoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      blockquote: TextStyle(
        color: Colors.grey[700],
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.5),
            width: 4,
          ),
        ),
      ),
      blockquotePadding: const EdgeInsets.only(left: 12),
      listBullet: TextStyle(
        color: AppColors.primary,
        fontSize: 14,
      ),
      a: TextStyle(
        color: AppColors.primary,
        decoration: TextDecoration.underline,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildAvatar(bool isAgent, bool isSystem) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isAgent
            ? Colors.blue.withOpacity(0.1)
            : isSystem
                ? Colors.amber.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isAgent
            ? Icons.person
            : isSystem
                ? Icons.info_outline
                : Icons.support_agent,
        color: isAgent
            ? Colors.blue
            : isSystem
                ? Colors.amber[700]
                : AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildConfidenceIndicator(double confidence) {
    Color color;
    String label;

    if (confidence >= 0.7) {
      color = Colors.green;
      label = 'High';
    } else if (confidence >= 0.4) {
      color = Colors.orange;
      label = 'Medium';
    } else {
      color = Colors.red;
      label = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiProviderBadge(String provider) {
    final displayName = provider == 'gemini'
        ? 'Gemini'
        : provider == 'claude'
            ? 'Claude'
            : provider == 'openai'
                ? 'GPT'
                : provider == 'faq'
                    ? 'FAQ'
                    : provider;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayName,
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    // Show feedback result if already provided
    if (_localFeedback != MessageFeedback.none) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _localFeedback == MessageFeedback.helpful
                ? Icons.thumb_up
                : Icons.thumb_down,
            size: 14,
            color: _localFeedback == MessageFeedback.helpful
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(width: 4),
          Text(
            _localFeedback == MessageFeedback.helpful
                ? 'Helpful'
                : 'Not helpful',
            style: TextStyle(
              fontSize: 11,
              color: _localFeedback == MessageFeedback.helpful
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ],
      );
    }

    // Show feedback buttons
    if (_showFeedbackOptions) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Was this helpful?',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          _buildFeedbackButton(
            icon: Icons.thumb_up_outlined,
            onTap: () => _submitFeedback(MessageFeedback.helpful),
            color: Colors.green,
          ),
          const SizedBox(width: 4),
          _buildFeedbackButton(
            icon: Icons.thumb_down_outlined,
            onTap: () => _submitFeedback(MessageFeedback.notHelpful),
            color: Colors.red,
          ),
        ],
      );
    }

    // Show hint to long-press
    return GestureDetector(
      onTap: () => setState(() => _showFeedbackOptions = true),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 14,
            color: Colors.grey[400],
          ),
          const SizedBox(width: 4),
          Text(
            'Rate this response',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  void _submitFeedback(MessageFeedback feedback) {
    setState(() {
      _localFeedback = feedback;
      _showFeedbackOptions = false;
    });

    // Notify parent
    widget.onFeedback?.call(widget.message.id, feedback);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Custom code block builder with copy functionality
class CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(element, preferredStyle) {
    final code = element.textContent;
    final language = element.attributes['class']?.replaceFirst('language-', '') ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with language and copy button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (language.isNotEmpty)
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                const Spacer(),
                _CopyButton(code: code),
              ],
            ),
          ),
          // Code content
          Padding(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyButton extends StatefulWidget {
  final String code;

  const _CopyButton({required this.code});

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  bool _copied = false;

  void _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _copy,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _copied ? Icons.check : Icons.copy,
              size: 14,
              color: _copied ? Colors.green : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              _copied ? 'Copied!' : 'Copy',
              style: TextStyle(
                fontSize: 11,
                color: _copied ? Colors.green : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
