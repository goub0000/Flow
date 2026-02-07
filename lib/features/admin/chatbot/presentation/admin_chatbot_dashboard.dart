// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../chatbot/application/services/conversation_storage_service.dart';
import '../../../chatbot/domain/models/conversation.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart

/// Admin Chatbot Dashboard - Overview and Analytics
class AdminChatbotDashboard extends ConsumerStatefulWidget {
  const AdminChatbotDashboard({super.key});

  @override
  ConsumerState<AdminChatbotDashboard> createState() =>
      _AdminChatbotDashboardState();
}

class _AdminChatbotDashboardState extends ConsumerState<AdminChatbotDashboard> {
  ConversationStorageService? _storageService;
  ConversationStats? _stats;
  List<Conversation> _recentConversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeService();
    });
  }

  void _initializeService() {
    final authService = ref.read(authServiceProvider);
    _storageService = ConversationStorageService(authService: authService);
    _loadData();
  }

  Future<void> _loadData() async {
    if (_storageService == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final stats = await _storageService!.getStatsFromBackend();
      final conversations = await _storageService!.getAllConversationsFromBackend();

      conversations.sort((a, b) =>
          b.lastMessageTime.compareTo(a.lastMessageTime));

      if (mounted) {
        setState(() {
          _stats = stats;
          _recentConversations = conversations.take(10).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Container(
      color: const Color(0xFFF8FAFC),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageHeader(),
                    const SizedBox(height: 24),
                    _buildStatsGrid(),
                    const SizedBox(height: 24),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildRecentConversations(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.adminChatDashTitle,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                context.l10n.adminChatDashSubtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: context.l10n.adminChatDashRefresh,
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    final stats = _stats ?? ConversationStats(
      totalConversations: 0,
      activeConversations: 0,
      totalMessages: 0,
      totalUserMessages: 0,
      totalBotMessages: 0,
      topicCounts: {},
      flaggedConversations: 0,
    );

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context.l10n.adminChatDashTotalConversations,
            stats.totalConversations.toString(),
            Icons.forum_outlined,
            const Color(0xFF6366F1),
            const Color(0xFFEEF2FF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context.l10n.adminChatDashActiveNow,
            stats.activeConversations.toString(),
            Icons.chat_bubble_outline,
            const Color(0xFF10B981),
            const Color(0xFFECFDF5),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context.l10n.adminChatDashTotalMessages,
            stats.totalMessages.toString(),
            Icons.message_outlined,
            const Color(0xFF3B82F6),
            const Color(0xFFEFF6FF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context.l10n.adminChatDashAvgMessagesPerChat,
            stats.averageMessagesPerConversation.toStringAsFixed(1),
            Icons.analytics_outlined,
            const Color(0xFFF59E0B),
            const Color(0xFFFFFBEB),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              Icon(Icons.trending_up, size: 16, color: Colors.green[400]),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            context.l10n.adminChatDashQuickActions,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context.l10n.adminChatDashManageFaqs,
                context.l10n.adminChatDashManageFaqsDesc,
                Icons.quiz_outlined,
                const Color(0xFF6366F1),
                () => context.push('/admin/chatbot/faqs'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context.l10n.adminChatDashConversationHistory,
                context.l10n.adminChatDashConversationHistoryDesc,
                Icons.history,
                const Color(0xFF3B82F6),
                () => context.push('/admin/chatbot/conversations'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context.l10n.adminChatDashSupportQueue,
                context.l10n.adminChatDashSupportQueueDesc,
                Icons.support_agent_outlined,
                const Color(0xFFF59E0B),
                () => context.push('/admin/chatbot/queue'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context.l10n.adminChatDashLiveMonitoring,
                context.l10n.adminChatDashLiveMonitoringDesc,
                Icons.monitor_heart_outlined,
                const Color(0xFF10B981),
                () => context.push('/admin/chatbot/live'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentConversations() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.history,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.l10n.adminChatDashRecentConversations,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/admin/chatbot/conversations'),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.adminChatDashViewAll,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          _recentConversations.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentConversations.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final conversation = _recentConversations[index];
                    return _buildConversationTile(conversation);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 32,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.adminChatDashNoConversations,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.adminChatDashNoConversationsDesc,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConversationTile(Conversation conversation) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/admin/chatbot/conversation/${conversation.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  conversation.userName.isNotEmpty
                      ? conversation.userName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      conversation.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.adminChatDashMessagesCount(conversation.messageCount),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildStatusChip(conversation.status),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(conversation.lastMessageTime),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ConversationStatus status) {
    Color color;
    Color bgColor;
    String label;

    switch (status) {
      case ConversationStatus.active:
        color = const Color(0xFF10B981);
        bgColor = const Color(0xFFECFDF5);
        label = context.l10n.adminChatDashStatusActive;
        break;
      case ConversationStatus.archived:
        color = const Color(0xFF64748B);
        bgColor = const Color(0xFFF1F5F9);
        label = context.l10n.adminChatDashStatusArchived;
        break;
      case ConversationStatus.flagged:
        color = const Color(0xFFEF4444);
        bgColor = const Color(0xFFFEF2F2);
        label = context.l10n.adminChatDashStatusFlagged;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return context.l10n.adminChatDashJustNow;
    if (diff.inHours < 1) return context.l10n.adminChatDashMinutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return context.l10n.adminChatDashHoursAgo(diff.inHours);
    if (diff.inDays < 7) return context.l10n.adminChatDashDaysAgo(diff.inDays);
    return '${time.month}/${time.day}';
  }
}
