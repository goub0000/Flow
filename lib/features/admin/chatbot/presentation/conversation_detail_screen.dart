// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../chatbot/application/services/conversation_storage_service.dart';
import '../../../chatbot/domain/models/conversation.dart';
import '../../../chatbot/domain/models/chat_message.dart';

/// Conversation Detail Screen - View and reply to conversations
class ConversationDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ConversationDetailScreen({
    super.key,
    required this.conversationId,
  });

  @override
  ConsumerState<ConversationDetailScreen> createState() =>
      _ConversationDetailScreenState();
}

class _ConversationDetailScreenState
    extends ConsumerState<ConversationDetailScreen> {
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final _storageService = ConversationStorageService();
  final _replyController = TextEditingController();
  final _scrollController = ScrollController();

  Conversation? _conversation;
  bool _isLoading = true;
  bool _isSending = false;
  String? _selectedCannedResponse;

  List<Map<String, String>> _getCannedResponses(BuildContext context) => [
    {'label': context.l10n.adminChatCannedGreetingLabel, 'text': context.l10n.adminChatCannedGreetingText},
    {'label': context.l10n.adminChatCannedFollowUpLabel, 'text': context.l10n.adminChatCannedFollowUpText},
    {'label': context.l10n.adminChatCannedMoreInfoLabel, 'text': context.l10n.adminChatCannedMoreInfoText},
    {'label': context.l10n.adminChatCannedEscalatingLabel, 'text': context.l10n.adminChatCannedEscalatingText},
    {'label': context.l10n.adminChatCannedResolutionLabel, 'text': context.l10n.adminChatCannedResolutionText},
    {'label': context.l10n.adminChatCannedClosingLabel, 'text': context.l10n.adminChatCannedClosingText},
  ];

  @override
  void initState() {
    super.initState();
    _loadConversation();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadConversation() async {
    setState(() => _isLoading = true);

    try {
      // Try to load from backend first
      final authService = ref.read(authServiceProvider);
      final token = authService.accessToken;

      if (token != null) {
        final messagesResponse = await http.get(
          Uri.parse('$baseUrl/chatbot/conversations/${widget.conversationId}/messages'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (messagesResponse.statusCode == 200) {
          final data = jsonDecode(messagesResponse.body);
          final messages = (data['messages'] as List)
              .map((m) => ChatMessage.fromJson(m))
              .toList();

          // Get conversation metadata
          final convResponse = await http.get(
            Uri.parse('$baseUrl/chatbot/conversations/${widget.conversationId}'),
            headers: {'Authorization': 'Bearer $token'},
          );

          if (convResponse.statusCode == 200) {
            final convData = jsonDecode(convResponse.body);
            setState(() {
              _conversation = Conversation(
                id: widget.conversationId,
                userId: convData['user_id'] ?? '',
                userName: convData['user_name'] ?? 'Unknown User',
                userEmail: convData['user_email'],
                userRole: convData['user_role'],
                startTime: DateTime.parse(convData['created_at']),
                lastMessageTime: DateTime.parse(convData['updated_at']),
                messages: messages,
                status: _parseStatus(convData['status']),
                messageCount: messages.length,
              );
              _isLoading = false;
            });
            _scrollToBottom();
            return;
          }
        }
      }

      // Fallback to local storage
      final conversation =
          await _storageService.getConversation(widget.conversationId);
      setState(() {
        _conversation = conversation;
        _isLoading = false;
      });
    } catch (e) {
      // Try local storage as fallback
      try {
        final conversation =
            await _storageService.getConversation(widget.conversationId);
        setState(() {
          _conversation = conversation;
          _isLoading = false;
        });
      } catch (_) {
        setState(() => _isLoading = false);
      }
    }
  }

  ConversationStatus _parseStatus(String? status) {
    switch (status) {
      case 'archived':
        return ConversationStatus.archived;
      case 'escalated':
      case 'flagged':
        return ConversationStatus.flagged;
      default:
        return ConversationStatus.active;
    }
  }

  Future<void> _sendReply({bool resolve = false}) async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() => _isSending = true);

    try {
      final authService = ref.read(authServiceProvider);
      final token = authService.accessToken;

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/admin/conversations/${widget.conversationId}/reply'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'content': _replyController.text.trim(),
          'resolve': resolve,
        }),
      );

      if (response.statusCode == 200) {
        _replyController.clear();
        _selectedCannedResponse = null;
        await _loadConversation();

        if (mounted && resolve) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.adminChatReplySentResolved)),
          );
        }
      } else {
        throw Exception('Failed to send reply');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.adminChatFailedSendReply(e.toString()))),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _updateStatus(ConversationStatus status) async {
    await _storageService.updateConversationStatus(
        widget.conversationId, status);
    await _loadConversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(context.l10n.adminChatConvDetailsTitle),
        backgroundColor: AppColors.surface,
        actions: [
          if (_conversation != null) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadConversation,
              tooltip: context.l10n.adminChatRefresh,
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                if (_conversation!.status != ConversationStatus.archived)
                  PopupMenuItem(
                    onTap: () => _updateStatus(ConversationStatus.archived),
                    child: Row(
                      children: [
                        Icon(Icons.archive, size: 18),
                        SizedBox(width: 12),
                        Text(context.l10n.adminChatArchive),
                      ],
                    ),
                  ),
                if (_conversation!.status != ConversationStatus.flagged)
                  PopupMenuItem(
                    onTap: () => _updateStatus(ConversationStatus.flagged),
                    child: Row(
                      children: [
                        Icon(Icons.flag, size: 18),
                        SizedBox(width: 12),
                        Text(context.l10n.adminChatFlag),
                      ],
                    ),
                  ),
                if (_conversation!.status != ConversationStatus.active)
                  PopupMenuItem(
                    onTap: () => _updateStatus(ConversationStatus.active),
                    child: Row(
                      children: [
                        Icon(Icons.restore, size: 18),
                        SizedBox(width: 12),
                        Text(context.l10n.adminChatRestore),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversation == null
              ? _buildErrorState()
              : Column(
                  children: [
                    // Conversation Info Header
                    _buildInfoHeader(),

                    // Messages
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _conversation!.messages.length,
                        itemBuilder: (context, index) {
                          final message = _conversation!.messages[index];
                          return _buildMessageBubble(message);
                        },
                      ),
                    ),

                    // Reply Input
                    _buildReplyInput(),
                  ],
                ),
    );
  }

  Widget _buildInfoHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _conversation!.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_conversation!.userEmail != null)
                      Text(
                        _conversation!.userEmail!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    if (_conversation!.userRole != null)
                      Text(
                        context.l10n.adminChatRole(_conversation!.userRole!),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              _buildStatusChip(_conversation!.status),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              _buildInfoItem(
                Icons.message,
                context.l10n.adminChatMessageCount(_conversation!.messageCount),
              ),
              _buildInfoItem(
                Icons.schedule,
                context.l10n.adminChatStarted(_formatDateTime(_conversation!.startTime)),
              ),
              _buildInfoItem(
                Icons.update,
                context.l10n.adminChatLastMessage(_formatDateTime(_conversation!.lastMessageTime)),
              ),
              _buildInfoItem(
                Icons.timer,
                context.l10n.adminChatDuration(_formatDuration(_conversation!.duration)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Canned Responses
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  context.l10n.adminChatQuickReplies,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                ..._getCannedResponses(context).map((response) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(
                          response['label']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedCannedResponse = response['label'];
                            _replyController.text = response['text']!;
                          });
                        },
                        backgroundColor: _selectedCannedResponse == response['label']
                            ? AppColors.primary.withValues(alpha: 0.2)
                            : null,
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Reply TextField
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _replyController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: context.l10n.adminChatReplyHint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (_) {
                    if (_selectedCannedResponse != null) {
                      setState(() => _selectedCannedResponse = null);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  // Send button
                  IconButton.filled(
                    onPressed: _isSending ? null : () => _sendReply(),
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    tooltip: context.l10n.adminChatSendReply,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Send & Resolve button
                  IconButton.filled(
                    onPressed: _isSending ? null : () => _sendReply(resolve: true),
                    icon: const Icon(Icons.check_circle, size: 20),
                    tooltip: context.l10n.adminChatSendAndResolve,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.sender == SenderType.user;
    final isSystem = message.sender == SenderType.system;
    final isAgent = message.sender == SenderType.agent;

    if (isSystem) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.info,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: isAgent
                  ? Colors.blue.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                isAgent ? Icons.support_agent : Icons.smart_toy,
                size: 16,
                color: isAgent ? Colors.blue : AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (isAgent)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      context.l10n.adminChatSupportAgent,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppColors.primary
                        : isAgent
                            ? Colors.blue.withValues(alpha: 0.1)
                            : AppColors.surface,
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
                    border: isUser || isAgent
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : AppColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMM d, y • h:mm a').format(message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (message.feedback != MessageFeedback.none) ...[
                      const SizedBox(width: 8),
                      Icon(
                        message.feedback == MessageFeedback.helpful
                            ? Icons.thumb_up
                            : Icons.thumb_down,
                        size: 12,
                        color: message.feedback == MessageFeedback.helpful
                            ? Colors.green
                            : Colors.red,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(ConversationStatus status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case ConversationStatus.active:
        color = AppColors.success;
        label = context.l10n.adminChatStatusActive;
        icon = Icons.check_circle;
        break;
      case ConversationStatus.archived:
        color = AppColors.textSecondary;
        label = context.l10n.adminChatStatusArchived;
        icon = Icons.archive;
        break;
      case ConversationStatus.flagged:
        color = AppColors.error;
        label = context.l10n.adminChatStatusEscalated;
        icon = Icons.flag;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.adminChatConvNotFound,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, y • h:mm a').format(dateTime);
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) return '${duration.inSeconds}s';
    if (duration.inHours < 1) return '${duration.inMinutes}m';
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }
}
