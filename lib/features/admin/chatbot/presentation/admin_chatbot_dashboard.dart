import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../chatbot/application/services/conversation_storage_service.dart';
import '../../../chatbot/domain/models/conversation.dart';

/// Admin Chatbot Dashboard - Overview and Analytics
class AdminChatbotDashboard extends ConsumerStatefulWidget {
  const AdminChatbotDashboard({super.key});

  @override
  ConsumerState<AdminChatbotDashboard> createState() =>
      _AdminChatbotDashboardState();
}

class _AdminChatbotDashboardState
    extends ConsumerState<AdminChatbotDashboard> {
  final _storageService = ConversationStorageService();
  ConversationStats? _stats;
  List<Conversation> _recentConversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Use Supabase methods to get global data for admin dashboard
      final stats = await _storageService.getStatsFromSupabase();
      final conversations = await _storageService.getAllConversationsFromSupabase();

      // Sort by most recent
      conversations.sort((a, b) =>
          b.lastMessageTime.compareTo(a.lastMessageTime));

      setState(() {
        _stats = stats;
        _recentConversations = conversations.take(10).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chatbot Analytics'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.question_answer),
            onPressed: () => context.push('/admin/chatbot/faqs'),
            tooltip: 'Manage FAQs',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/admin/chatbot/conversations'),
            tooltip: 'View All Conversations',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Statistics Cards
                    _buildStatsGrid(),
                    const SizedBox(height: 32),

                    // Quick Actions
                    _buildQuickActions(),
                    const SizedBox(height: 32),

                    // Top Topics
                    _buildTopTopics(),
                    const SizedBox(height: 32),

                    // Recent Conversations
                    _buildRecentConversations(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatsGrid() {
    if (_stats == null) return const SizedBox();

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Conversations',
          _stats!.totalConversations.toString(),
          Icons.chat_bubble_outline,
          AppColors.primary,
        ),
        _buildStatCard(
          'Active Conversations',
          _stats!.activeConversations.toString(),
          Icons.chat,
          AppColors.success,
        ),
        _buildStatCard(
          'Total Messages',
          _stats!.totalMessages.toString(),
          Icons.message,
          AppColors.info,
        ),
        _buildStatCard(
          'Avg Messages/Chat',
          _stats!.averageMessagesPerConversation.toStringAsFixed(1),
          Icons.trending_up,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            'Manage FAQs',
            'Create, edit, and organize FAQ responses',
            Icons.question_answer,
            AppColors.primary,
            () => context.push('/admin/chatbot/faqs'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            'Conversation History',
            'View and search all user conversations',
            Icons.history,
            AppColors.info,
            () => context.push('/admin/chatbot/conversations'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            'Support Queue',
            'Handle escalated support requests',
            Icons.support_agent,
            AppColors.warning,
            () => context.push('/admin/chatbot/queue'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            'Live Monitoring',
            'Watch active conversations in real-time',
            Icons.visibility,
            AppColors.success,
            () => context.push('/admin/chatbot/live'),
          ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTopics() {
    if (_stats == null || _stats!.topTopics.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.topic, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Top Topics',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._stats!.topTopics.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(entry.key),
                    ),
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: entry.value /
                                  _stats!.totalConversations,
                              backgroundColor: AppColors.border,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            entry.value.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentConversations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, size: 20, color: AppColors.primary),
                  const SizedBox(width: 8),
                  const Text(
                    'Recent Conversations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () =>
                    context.push('/admin/chatbot/conversations'),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _recentConversations.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'No conversations yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _recentConversations.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: AppColors.border,
                  ),
                  itemBuilder: (context, index) {
                    final conversation = _recentConversations[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(conversation.userName),
                      subtitle: Text(
                        '${conversation.messageCount} messages • ${_formatDuration(conversation.duration)}',
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildStatusChip(conversation.status),
                          const SizedBox(height: 4),
                          Text(
                            _formatTime(conversation.lastMessageTime),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => context.push(
                          '/admin/chatbot/conversation/${conversation.id}'),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ConversationStatus status) {
    Color color;
    String label;

    switch (status) {
      case ConversationStatus.active:
        color = AppColors.success;
        label = 'Active';
        break;
      case ConversationStatus.archived:
        color = AppColors.textSecondary;
        label = 'Archived';
        break;
      case ConversationStatus.flagged:
        color = AppColors.error;
        label = 'Flagged';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) return '${duration.inSeconds}s';
    if (duration.inHours < 1) return '${duration.inMinutes}m';
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.month}/${time.day}';
  }
}
