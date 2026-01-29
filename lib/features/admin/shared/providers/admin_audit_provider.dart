import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// Audit log entry model
class AuditLogEntry {
  final String id;
  final String userId;
  final String userName;
  final String userRole;
  final String action; // 'create', 'update', 'delete', 'login', 'logout', etc.
  final String resource; // 'user', 'course', 'payment', 'settings', etc.
  final String? resourceId;
  final Map<String, dynamic>? metadata;
  final String ipAddress;
  final DateTime timestamp;

  const AuditLogEntry({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.action,
    required this.resource,
    this.resourceId,
    this.metadata,
    required this.ipAddress,
    required this.timestamp,
  });

  static AuditLogEntry mockEntry(int index) {
    final actions = ['create', 'update', 'delete', 'login', 'logout', 'view'];
    final resources = ['user', 'course', 'payment', 'settings', 'application'];

    return AuditLogEntry(
      id: 'audit_$index',
      userId: 'user_$index',
      userName: 'User ${index + 1}',
      userRole: 'admin',
      action: actions[index % actions.length],
      resource: resources[index % resources.length],
      resourceId: 'resource_$index',
      metadata: {'detail': 'Action detail $index'},
      ipAddress: '192.168.1.${index % 255 + 1}',
      timestamp: DateTime.now().subtract(Duration(hours: index)),
    );
  }
}

/// State class for audit logs
class AdminAuditState {
  final List<AuditLogEntry> logs;
  final bool isLoading;
  final String? error;

  const AdminAuditState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  AdminAuditState copyWith({
    List<AuditLogEntry>? logs,
    bool? isLoading,
    String? error,
  }) {
    return AdminAuditState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for audit logs
class AdminAuditNotifier extends StateNotifier<AdminAuditState> {
  final ApiClient _apiClient;

  AdminAuditNotifier(this._apiClient) : super(const AdminAuditState()) {
    fetchAuditLogs();
  }

  /// Fetch audit logs from backend API
  Future<void> fetchAuditLogs({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? action,
    String? resource,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/audit/logs',
        queryParameters: {
          if (startDate != null) 'start_date': startDate.toIso8601String(),
          if (endDate != null) 'end_date': endDate.toIso8601String(),
          if (userId != null) 'user_id': userId,
          if (action != null) 'action': action,
          if (resource != null) 'resource': resource,
        },
        fromJson: (data) {
          if (data is List) {
            // Backend may not have audit logs yet
            return <AuditLogEntry>[];
          }
          return <AuditLogEntry>[];
        },
      );

      if (response.success) {
        state = state.copyWith(
          logs: response.data ?? [],
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch audit logs',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch audit logs: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Log an action
  /// TODO: Connect to backend API
  Future<void> logAction({
    required String userId,
    required String userName,
    required String userRole,
    required String action,
    required String resource,
    String? resourceId,
    Map<String, dynamic>? metadata,
    required String ipAddress,
  }) async {
    try {
      // TODO: Write to backend API
      final entry = AuditLogEntry(
        id: 'audit_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        userName: userName,
        userRole: userRole,
        action: action,
        resource: resource,
        resourceId: resourceId,
        metadata: metadata,
        ipAddress: ipAddress,
        timestamp: DateTime.now(),
      );

      final updatedLogs = [entry, ...state.logs];
      state = state.copyWith(logs: updatedLogs);
    } catch (e) {
      // Don't show error to user for audit logging failures
      print('Failed to log action: $e');
    }
  }

  /// Filter logs
  List<AuditLogEntry> filterLogs({
    String? action,
    String? resource,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    var filtered = state.logs;

    if (action != null && action != 'all') {
      filtered = filtered.where((log) => log.action == action).toList();
    }

    if (resource != null && resource != 'all') {
      filtered = filtered.where((log) => log.resource == resource).toList();
    }

    if (userId != null && userId.isNotEmpty) {
      filtered = filtered.where((log) => log.userId == userId).toList();
    }

    if (startDate != null) {
      filtered = filtered.where((log) => log.timestamp.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      filtered = filtered.where((log) => log.timestamp.isBefore(endDate)).toList();
    }

    return filtered;
  }

  /// Export logs to CSV
  /// TODO: Implement CSV export
  Future<String?> exportLogs({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // TODO: Generate CSV and return file path
      await Future.delayed(const Duration(seconds: 1));

      return 'audit_logs_${DateTime.now().millisecondsSinceEpoch}.csv';
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to export logs: ${e.toString()}',
      );
      return null;
    }
  }

  /// Get log statistics
  Map<String, dynamic> getLogStatistics() {
    final Map<String, int> actionCounts = {};
    final Map<String, int> resourceCounts = {};

    for (final log in state.logs) {
      actionCounts[log.action] = (actionCounts[log.action] ?? 0) + 1;
      resourceCounts[log.resource] = (resourceCounts[log.resource] ?? 0) + 1;
    }

    return {
      'total': state.logs.length,
      'actionCounts': actionCounts,
      'resourceCounts': resourceCounts,
      'uniqueUsers': state.logs.map((l) => l.userId).toSet().length,
    };
  }
}

/// Provider for admin audit state
final adminAuditProvider = StateNotifierProvider<AdminAuditNotifier, AdminAuditState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminAuditNotifier(apiClient);
});

/// Provider for audit logs list
final adminAuditLogsListProvider = Provider<List<AuditLogEntry>>((ref) {
  final auditState = ref.watch(adminAuditProvider);
  return auditState.logs;
});

/// Provider for audit log statistics
final adminAuditStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(adminAuditProvider.notifier);
  return notifier.getLogStatistics();
});

/// Provider for checking if audit is loading
final adminAuditLoadingProvider = Provider<bool>((ref) {
  final auditState = ref.watch(adminAuditProvider);
  return auditState.isLoading;
});

/// Provider for audit error
final adminAuditErrorProvider = Provider<String?>((ref) {
  final auditState = ref.watch(adminAuditProvider);
  return auditState.error;
});
