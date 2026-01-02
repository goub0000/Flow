import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/service_providers.dart';

/// Live Conversations Screen - Real-time monitoring of active chats
class LiveConversationsScreen extends ConsumerStatefulWidget {
  const LiveConversationsScreen({super.key});

  @override
  ConsumerState<LiveConversationsScreen> createState() =>
      _LiveConversationsScreenState();
}

class _LiveConversationsScreenState
    extends ConsumerState<LiveConversationsScreen> {
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  List<LiveConversation> _conversations = [];
  bool _isLoading = true;
  String? _error;
  Timer? _refreshTimer;
  bool _autoRefresh = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (_autoRefresh) {
        _loadConversations(silent: true);
      }
    });
  }

  Future<void> _loadConversations({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final authService = ref.read(authServiceProvider);
      final token = authService.accessToken;

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/chatbot/admin/conversations?status_filter=active&page_size=50'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final convs = (data['conversations'] as List)
            .map((c) => LiveConversation.fromJson(c))
            .toList();

        // Sort by last message time (most recent first)
        convs.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

        setState(() {
          _conversations = convs;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      if (!silent) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Conversations'),
        backgroundColor: AppColors.surface,
        actions: [
          // Auto-refresh toggle
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Auto-refresh',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              Switch(
                value: _autoRefresh,
                onChanged: (value) => setState(() => _autoRefresh = value),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConversations,
            tooltip: 'Refresh Now',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Banner
          _buildStatsBanner(),

          // Conversations List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _conversations.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadConversations,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _conversations.length,
                              itemBuilder: (context, index) {
                                return _buildConversationCard(
                                    _conversations[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBanner() {
    final activeCount = _conversations.length;
    final escalatedCount =
        _conversations.where((c) => c.status == 'escalated').length;
    final recentCount = _conversations
        .where((c) =>
            DateTime.now().difference(c.updatedAt).inMinutes < 5)
        .length;

    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Row(
        children: [
          _buildMiniStat('Active', activeCount.toString(), AppColors.success),
          const SizedBox(width: 24),
          _buildMiniStat('Escalated', escalatedCount.toString(), AppColors.error),
          const SizedBox(width: 24),
          _buildMiniStat('Active (5m)', recentCount.toString(), AppColors.info),
          const Spacer(),
          // Live indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _autoRefresh
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _autoRefresh ? AppColors.success : AppColors.textSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _autoRefresh ? 'LIVE' : 'PAUSED',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: _autoRefresh ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildConversationCard(LiveConversation conv) {
    final isRecent = DateTime.now().difference(conv.updatedAt).inMinutes < 5;
    final isEscalated = conv.status == 'escalated';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isEscalated
              ? AppColors.error.withValues(alpha: 0.5)
              : isRecent
                  ? AppColors.success.withValues(alpha: 0.5)
                  : AppColors.border,
          width: isEscalated || isRecent ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () =>
            context.push('/admin/chatbot/conversation/${conv.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      (conv.userName?.isNotEmpty == true
                              ? conv.userName![0]
                              : 'U')
                          .toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isRecent)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conv.userName ?? 'Unknown User',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isEscalated)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.flag,
                                    size: 12, color: AppColors.error),
                                const SizedBox(width: 4),
                                Text(
                                  'ESCALATED',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (conv.userRole != null) ...[
                          Text(
                            conv.userRole!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(' • '),
                        ],
                        Text(
                          '${conv.messageCount} messages',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    if (conv.summary != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        conv.summary!,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Time and action
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTime(conv.updatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: isRecent ? AppColors.success : AppColors.textSecondary,
                      fontWeight: isRecent ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('MMM d').format(time);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No active conversations',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
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
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Failed to load conversations',
            style: TextStyle(fontSize: 16, color: AppColors.error),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadConversations,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Live Conversation Model
class LiveConversation {
  final String id;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userRole;
  final String status;
  final String? summary;
  final String? aiProvider;
  final int messageCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  LiveConversation({
    required this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.userRole,
    required this.status,
    this.summary,
    this.aiProvider,
    required this.messageCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveConversation.fromJson(Map<String, dynamic> json) {
    return LiveConversation(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      userRole: json['user_role'] as String?,
      status: json['status'] as String? ?? 'active',
      summary: json['summary'] as String?,
      aiProvider: json['ai_provider'] as String?,
      messageCount: json['message_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
