import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../core/services/auth_service.dart';
import '../../../../core/providers/service_providers.dart';

/// Live Chat Queue Item model
class LiveChatQueueItem {
  final String id;
  final String conversationId;
  final String summary;
  final String userName;
  final String userEmail;
  final String priority;
  final String reason;
  final String escalationType;
  final String? assignedTo;
  final String? assignedToName;
  final String status;
  final int? responseTimeSeconds;
  final DateTime createdAt;
  final DateTime? assignedAt;

  const LiveChatQueueItem({
    required this.id,
    required this.conversationId,
    required this.summary,
    required this.userName,
    required this.userEmail,
    required this.priority,
    required this.reason,
    required this.escalationType,
    this.assignedTo,
    this.assignedToName,
    required this.status,
    this.responseTimeSeconds,
    required this.createdAt,
    this.assignedAt,
  });

  factory LiveChatQueueItem.fromJson(Map<String, dynamic> json) {
    return LiveChatQueueItem(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      summary: json['conversation_summary']?.toString() ?? json['summary']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? 'Unknown',
      userEmail: json['user_email']?.toString() ?? '',
      priority: json['priority']?.toString() ?? 'medium',
      reason: json['reason']?.toString() ?? '',
      escalationType: json['escalation_type']?.toString() ?? 'manual',
      assignedTo: json['assigned_to']?.toString(),
      assignedToName: json['assigned_to_name']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      responseTimeSeconds: json['response_time_seconds'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      assignedAt: json['assigned_at'] != null
          ? DateTime.parse(json['assigned_at'].toString())
          : null,
    );
  }
}

/// State class for Live Chat admin
class AdminLiveChatState {
  final List<LiveChatQueueItem> queueItems;
  final bool isLoading;
  final String? error;
  final int pendingCount;
  final int assignedCount;
  final int inProgressCount;
  final int totalConversations;

  const AdminLiveChatState({
    this.queueItems = const [],
    this.isLoading = false,
    this.error,
    this.pendingCount = 0,
    this.assignedCount = 0,
    this.inProgressCount = 0,
    this.totalConversations = 0,
  });

  AdminLiveChatState copyWith({
    List<LiveChatQueueItem>? queueItems,
    bool? isLoading,
    String? error,
    int? pendingCount,
    int? assignedCount,
    int? inProgressCount,
    int? totalConversations,
  }) {
    return AdminLiveChatState(
      queueItems: queueItems ?? this.queueItems,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      pendingCount: pendingCount ?? this.pendingCount,
      assignedCount: assignedCount ?? this.assignedCount,
      inProgressCount: inProgressCount ?? this.inProgressCount,
      totalConversations: totalConversations ?? this.totalConversations,
    );
  }
}

/// StateNotifier for Live Chat admin
class AdminLiveChatNotifier extends StateNotifier<AdminLiveChatState> {
  static const String _baseUrl =
      'https://web-production-51e34.up.railway.app/api/v1';

  final http.Client _client;
  final AuthService? _authService;

  AdminLiveChatNotifier({
    http.Client? client,
    AuthService? authService,
  })  : _client = client ?? http.Client(),
        _authService = authService,
        super(const AdminLiveChatState()) {
    fetchQueue();
    fetchStats();
  }

  Map<String, String> _buildHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_authService != null) {
      final token = _authService.accessToken;
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Fetch the support queue
  Future<void> fetchQueue({String? status, String? priority}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final queryParams = <String, String>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (priority != null && priority.isNotEmpty) {
        queryParams['priority'] = priority;
      }

      final uri = Uri.parse('$_baseUrl/chatbot/admin/queue')
          .replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final itemsData = json['items'] as List<dynamic>? ?? [];
        final items = itemsData
            .map((e) => LiveChatQueueItem.fromJson(e as Map<String, dynamic>))
            .toList();

        final pendingCount = json['pending_count'] as int? ??
            items.where((i) => i.status == 'pending').length;
        final assignedCount = json['assigned_count'] as int? ??
            items.where((i) => i.status == 'assigned').length;
        final inProgressCount = json['in_progress_count'] as int? ??
            items.where((i) => i.status == 'in_progress').length;

        state = state.copyWith(
          queueItems: items,
          isLoading: false,
          pendingCount: pendingCount,
          assignedCount: assignedCount,
          inProgressCount: inProgressCount,
        );
      } else if (response.statusCode == 401) {
        state = state.copyWith(
          error: 'Unauthorized: Please log in again',
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: 'Failed to fetch queue: ${response.statusCode}',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch queue: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch chat stats
  Future<void> fetchStats() async {
    try {
      final uri = Uri.parse('$_baseUrl/chatbot/admin/stats');
      final response = await _client.get(uri, headers: _buildHeaders());

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        state = state.copyWith(
          totalConversations: json['total_conversations'] as int? ?? 0,
        );
      }
    } catch (_) {
      // Stats are non-critical, don't set error
    }
  }

  /// Assign a queue item to self
  Future<bool> assignToSelf(String queueId) async {
    try {
      final agentId = _authService?.currentUser?.id ?? '';
      final uri = Uri.parse('$_baseUrl/chatbot/admin/queue/$queueId/assign');
      final body = jsonEncode({'agent_id': agentId});
      final response = await _client.post(uri, headers: _buildHeaders(), body: body);

      if (response.statusCode == 200) {
        await fetchQueue();
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to assign: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to assign: ${e.toString()}',
      );
      return false;
    }
  }

  /// Send a reply to a conversation
  Future<bool> sendReply(String conversationId, String content, {bool resolve = false}) async {
    try {
      final uri = Uri.parse('$_baseUrl/chatbot/admin/conversations/$conversationId/reply');
      final body = jsonEncode({
        'content': content,
        'resolve': resolve,
      });

      final response = await _client.post(uri, headers: _buildHeaders(), body: body);

      if (response.statusCode == 200) {
        await fetchQueue();
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to send reply: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to send reply: ${e.toString()}',
      );
      return false;
    }
  }
}

/// Provider for Live Chat admin state
final adminLiveChatProvider =
    StateNotifierProvider<AdminLiveChatNotifier, AdminLiveChatState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AdminLiveChatNotifier(authService: authService);
});
