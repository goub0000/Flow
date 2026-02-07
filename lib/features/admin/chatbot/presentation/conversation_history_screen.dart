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

/// Conversation History Screen - List all conversations with search/filter
class ConversationHistoryScreen extends ConsumerStatefulWidget {
  const ConversationHistoryScreen({super.key});

  @override
  ConsumerState<ConversationHistoryScreen> createState() =>
      _ConversationHistoryScreenState();
}

class _ConversationHistoryScreenState
    extends ConsumerState<ConversationHistoryScreen> {
  ConversationStorageService? _storageService;
  final _searchController = TextEditingController();
  List<Conversation> _allConversations = [];
  List<Conversation> _filteredConversations = [];
  ConversationStatus? _filterStatus;
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
    _loadConversations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    if (_storageService == null) return;

    setState(() => _isLoading = true);

    try {
      // Use backend API method to get all conversations globally for admin
      final conversations = await _storageService!.getAllConversationsFromBackend();
      conversations.sort((a, b) =>
          b.lastMessageTime.compareTo(a.lastMessageTime));

      if (mounted) {
        setState(() {
          _allConversations = conversations;
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _applyFilters() {
    var filtered = _allConversations;

    // Apply status filter
    if (_filterStatus != null) {
      filtered =
          filtered.where((c) => c.status == _filterStatus).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((c) {
        return c.userName.toLowerCase().contains(query) ||
            (c.userEmail?.toLowerCase().contains(query) ?? false) ||
            c.messages.any(
                (m) => m.content.toLowerCase().contains(query));
      }).toList();
    }

    setState(() => _filteredConversations = filtered);
  }

  Future<void> _updateStatus(String id, ConversationStatus status) async {
    if (_storageService == null) return;
    await _storageService!.updateConversationStatus(id, status);
    await _loadConversations();
  }

  Future<void> _deleteConversation(String id) async {
    if (_storageService == null) return;
    await _storageService!.deleteConversation(id);
    await _loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Page Header
          _buildPageHeader(),

          // Search and Filter Bar
          _buildSearchAndFilter(),

          // Conversations List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredConversations.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadConversations,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredConversations.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final conversation =
                                _filteredConversations[index];
                            return _buildConversationCard(conversation);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.history, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminChatConvHistoryTitle,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  context.l10n.adminChatConvHistorySubtitle,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadConversations,
            tooltip: context.l10n.adminChatRefresh,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.adminChatSearchConversations,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _applyFilters();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            onChanged: (_) => _applyFilters(),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Row(
            children: [
              Text(
                context.l10n.adminChatFilter,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              _buildFilterChip(context.l10n.adminChatFilterAll, null),
              _buildFilterChip(context.l10n.adminChatStatusActive, ConversationStatus.active),
              _buildFilterChip(context.l10n.adminChatStatusArchived, ConversationStatus.archived),
              _buildFilterChip(context.l10n.adminChatStatusFlagged, ConversationStatus.flagged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ConversationStatus? status) {
    final isSelected = _filterStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() => _filterStatus = status);
          _applyFilters();
        },
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildConversationCard(Conversation conversation) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => context
            .push('/admin/chatbot/conversation/${conversation.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (conversation.userEmail != null)
                          Text(
                            conversation.userEmail!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _buildStatusChip(conversation.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.message,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    context.l10n.adminChatMessageCount(conversation.messageCount),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(conversation.lastMessageTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.timer,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(conversation.duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (conversation.status != ConversationStatus.archived)
                    TextButton.icon(
                      onPressed: () => _updateStatus(
                          conversation.id, ConversationStatus.archived),
                      icon: const Icon(Icons.archive, size: 16),
                      label: Text(context.l10n.adminChatArchive),
                    ),
                  if (conversation.status != ConversationStatus.flagged)
                    TextButton.icon(
                      onPressed: () => _updateStatus(
                          conversation.id, ConversationStatus.flagged),
                      icon: const Icon(Icons.flag, size: 16),
                      label: Text(context.l10n.adminChatFlag),
                    ),
                  TextButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(context.l10n.adminChatDeleteConvTitle),
                          content: Text(context.l10n.adminChatDeleteConvConfirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(context.l10n.adminChatCancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text(context.l10n.adminChatDelete),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await _deleteConversation(conversation.id);
                      }
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: Text(context.l10n.adminChatDelete),
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
    String label;

    switch (status) {
      case ConversationStatus.active:
        color = AppColors.success;
        label = context.l10n.adminChatStatusActive;
        break;
      case ConversationStatus.archived:
        color = AppColors.textSecondary;
        label = context.l10n.adminChatStatusArchived;
        break;
      case ConversationStatus.flagged:
        color = AppColors.error;
        label = context.l10n.adminChatStatusFlagged;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.adminChatNoConversations,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
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
    return '${time.month}/${time.day}/${time.year}';
  }
}
