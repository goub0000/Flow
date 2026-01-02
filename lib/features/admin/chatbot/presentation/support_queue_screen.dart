import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/service_providers.dart';

/// Admin Support Queue Screen - Manage escalated conversations
class SupportQueueScreen extends ConsumerStatefulWidget {
  const SupportQueueScreen({super.key});

  @override
  ConsumerState<SupportQueueScreen> createState() => _SupportQueueScreenState();
}

class _SupportQueueScreenState extends ConsumerState<SupportQueueScreen> {
  static const String baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  List<SupportQueueItem> _queueItems = [];
  bool _isLoading = true;
  String? _error;
  String _statusFilter = 'all';
  String _priorityFilter = 'all';

  int _pendingCount = 0;
  int _assignedCount = 0;
  int _inProgressCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQueue();
  }

  Future<void> _loadQueue() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final token = authService.accessToken;

      if (token == null) {
        throw Exception('Not authenticated');
      }

      final queryParams = <String, String>{};
      if (_statusFilter != 'all') queryParams['status_filter'] = _statusFilter;
      if (_priorityFilter != 'all') queryParams['priority_filter'] = _priorityFilter;

      final uri = Uri.parse('$baseUrl/chatbot/admin/queue')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = (data['items'] as List)
            .map((i) => SupportQueueItem.fromJson(i))
            .toList();

        setState(() {
          _queueItems = items;
          _pendingCount = data['pending_count'] ?? 0;
          _assignedCount = data['assigned_count'] ?? 0;
          _inProgressCount = data['in_progress_count'] ?? 0;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load queue');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _assignToSelf(SupportQueueItem item) async {
    try {
      final authService = ref.read(authServiceProvider);
      final token = authService.accessToken;

      final response = await http.post(
        Uri.parse('$baseUrl/chatbot/admin/queue/${item.id}/assign'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'agent_id': authService.currentUser?.id,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assigned to you')),
        );
        _loadQueue();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to assign: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Support Queue'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadQueue,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          _buildStatsRow(),

          // Filters
          _buildFilters(),

          // Queue List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _queueItems.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            onRefresh: _loadQueue,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _queueItems.length,
                              itemBuilder: (context, index) {
                                return _buildQueueItemCard(_queueItems[index]);
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Pending',
              _pendingCount.toString(),
              AppColors.warning,
              Icons.hourglass_empty,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Assigned',
              _assignedCount.toString(),
              AppColors.info,
              Icons.person_add,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'In Progress',
              _inProgressCount.toString(),
              AppColors.success,
              Icons.pending_actions,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _statusFilter,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'assigned', child: Text('Assigned')),
                DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
              ],
              onChanged: (value) {
                setState(() => _statusFilter = value ?? 'all');
                _loadQueue();
              },
            ),
          ),
          const SizedBox(width: 16),
          // Priority Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _priorityFilter,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'normal', child: Text('Normal')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() => _priorityFilter = value ?? 'all');
                _loadQueue();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItemCard(SupportQueueItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getPriorityColor(item.priority).withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => context.push('/admin/chatbot/conversation/${item.conversationId}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Priority Badge
                  _buildPriorityBadge(item.priority),
                  const SizedBox(width: 8),
                  // Status Badge
                  _buildStatusBadge(item.status),
                  const Spacer(),
                  // Time
                  Text(
                    _formatTime(item.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.person, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.userName ?? 'Unknown User',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (item.userEmail != null)
                          Text(
                            item.userEmail!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              // Reason
              if (item.reason != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reason: ${_formatReason(item.reason!)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // Summary
              if (item.conversationSummary != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.conversationSummary!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (item.status == 'pending')
                    TextButton.icon(
                      onPressed: () => _assignToSelf(item),
                      icon: const Icon(Icons.person_add, size: 18),
                      label: const Text('Assign to me'),
                    ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => context.push('/admin/chatbot/conversation/${item.conversationId}'),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text('Open'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
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

  Widget _buildPriorityBadge(String priority) {
    final color = _getPriorityColor(priority);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (priority == 'urgent')
            Icon(Icons.priority_high, size: 12, color: color),
          Text(
            priority.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = AppColors.warning;
        break;
      case 'assigned':
        color = AppColors.info;
        break;
      case 'in_progress':
        color = AppColors.success;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'normal':
        return AppColors.info;
      case 'low':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatReason(String reason) {
    switch (reason) {
      case 'user_request':
        return 'User requested human support';
      case 'negative_feedback':
        return 'Multiple negative feedback';
      case 'low_confidence':
        return 'AI confidence too low';
      case 'auto_escalation':
        return 'Automatic escalation';
      default:
        return reason.replaceAll('_', ' ');
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return DateFormat('MMM d, h:mm a').format(time);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No items in queue',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escalated conversations will appear here',
            style: TextStyle(
              fontSize: 14,
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
            'Failed to load queue',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _loadQueue,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Support Queue Item Model
class SupportQueueItem {
  final String id;
  final String conversationId;
  final String? conversationSummary;
  final String? userName;
  final String? userEmail;
  final String priority;
  final String? reason;
  final String? escalationType;
  final String? assignedTo;
  final String? assignedToName;
  final String status;
  final int? responseTimeSeconds;
  final DateTime createdAt;
  final DateTime? assignedAt;

  SupportQueueItem({
    required this.id,
    required this.conversationId,
    this.conversationSummary,
    this.userName,
    this.userEmail,
    required this.priority,
    this.reason,
    this.escalationType,
    this.assignedTo,
    this.assignedToName,
    required this.status,
    this.responseTimeSeconds,
    required this.createdAt,
    this.assignedAt,
  });

  factory SupportQueueItem.fromJson(Map<String, dynamic> json) {
    return SupportQueueItem(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      conversationSummary: json['conversation_summary'] as String?,
      userName: json['user_name'] as String?,
      userEmail: json['user_email'] as String?,
      priority: json['priority'] as String? ?? 'normal',
      reason: json['reason'] as String?,
      escalationType: json['escalation_type'] as String?,
      assignedTo: json['assigned_to'] as String?,
      assignedToName: json['assigned_to_name'] as String?,
      status: json['status'] as String? ?? 'pending',
      responseTimeSeconds: json['response_time_seconds'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'] as String)
          : null,
    );
  }
}
