import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Alert model
class ParentAlert {
  final String id;
  final String childId;
  final String childName;
  final String type; // 'low_grade', 'missed_assignment', 'low_attendance', 'new_application', 'course_complete'
  final String title;
  final String message;
  final String severity; // 'low', 'medium', 'high'
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  const ParentAlert({
    required this.id,
    required this.childId,
    required this.childName,
    required this.type,
    required this.title,
    required this.message,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
    this.metadata,
  });

  ParentAlert copyWith({
    String? id,
    String? childId,
    String? childName,
    String? type,
    String? title,
    String? message,
    String? severity,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? metadata,
  }) {
    return ParentAlert(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      childName: childName ?? this.childName,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      severity: severity ?? this.severity,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'childName': childName,
      'type': type,
      'title': title,
      'message': message,
      'severity': severity,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'metadata': metadata,
    };
  }

  factory ParentAlert.fromJson(Map<String, dynamic> json) {
    return ParentAlert(
      id: json['id'],
      childId: json['childId'],
      childName: json['childName'],
      type: json['type'],
      title: json['title'],
      message: json['message'],
      severity: json['severity'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      metadata: json['metadata'],
    );
  }
}

/// State class for parent alerts
class ParentAlertsState {
  final List<ParentAlert> alerts;
  final bool isLoading;
  final String? error;

  const ParentAlertsState({
    this.alerts = const [],
    this.isLoading = false,
    this.error,
  });

  ParentAlertsState copyWith({
    List<ParentAlert>? alerts,
    bool? isLoading,
    String? error,
  }) {
    return ParentAlertsState(
      alerts: alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing parent alerts
class ParentAlertsNotifier extends StateNotifier<ParentAlertsState> {
  ParentAlertsNotifier() : super(const ParentAlertsState()) {
    fetchAlerts();
  }

  /// Fetch all alerts for the parent
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchAlerts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('alerts')
      //   .where('parentId', isEqualTo: currentParentId)
      //   .orderBy('timestamp', descending: true)
      //   .get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockAlerts = _generateMockAlerts();

      state = state.copyWith(
        alerts: mockAlerts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch alerts: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Generate mock alerts
  List<ParentAlert> _generateMockAlerts() {
    return [
      ParentAlert(
        id: '1',
        childId: 'child1',
        childName: 'Sarah Johnson',
        type: 'low_grade',
        title: 'Low Grade Alert',
        message: 'Sarah received a D on Mathematics Quiz 3',
        severity: 'high',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ParentAlert(
        id: '2',
        childId: 'child1',
        childName: 'Sarah Johnson',
        type: 'missed_assignment',
        title: 'Missed Assignment',
        message: 'Sarah has 1 overdue assignment in Physics',
        severity: 'medium',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      ParentAlert(
        id: '3',
        childId: 'child2',
        childName: 'Michael Johnson',
        type: 'new_application',
        title: 'Application Update',
        message: 'Michael\'s application to Stanford was accepted!',
        severity: 'low',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      ParentAlert(
        id: '4',
        childId: 'child1',
        childName: 'Sarah Johnson',
        type: 'course_complete',
        title: 'Course Completed',
        message: 'Sarah completed Introduction to Biology with grade A',
        severity: 'low',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      ParentAlert(
        id: '5',
        childId: 'child2',
        childName: 'Michael Johnson',
        type: 'low_attendance',
        title: 'Low Attendance',
        message: 'Michael\'s attendance in Chemistry is below 75%',
        severity: 'high',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  /// Mark alert as read
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> markAsRead(String alertId) async {
    try {
      // TODO: Update in Firebase

      final updatedAlerts = state.alerts.map((alert) {
        return alert.id == alertId ? alert.copyWith(isRead: true) : alert;
      }).toList();

      state = state.copyWith(alerts: updatedAlerts);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark alert as read: ${e.toString()}',
      );
    }
  }

  /// Mark all alerts as read
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> markAllAsRead() async {
    try {
      // TODO: Update in Firebase

      final updatedAlerts = state.alerts.map((alert) {
        return alert.copyWith(isRead: true);
      }).toList();

      state = state.copyWith(alerts: updatedAlerts);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to mark all alerts as read: ${e.toString()}',
      );
    }
  }

  /// Delete an alert
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> deleteAlert(String alertId) async {
    try {
      // TODO: Delete from Firebase

      final updatedAlerts = state.alerts.where((alert) => alert.id != alertId).toList();
      state = state.copyWith(alerts: updatedAlerts);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete alert: ${e.toString()}',
      );
    }
  }

  /// Filter alerts by type
  List<ParentAlert> filterByType(String type) {
    if (type == 'all') return state.alerts;

    return state.alerts.where((alert) => alert.type == type).toList();
  }

  /// Filter alerts by child
  List<ParentAlert> filterByChild(String childId) {
    return state.alerts.where((alert) => alert.childId == childId).toList();
  }

  /// Filter alerts by severity
  List<ParentAlert> filterBySeverity(String severity) {
    return state.alerts.where((alert) => alert.severity == severity).toList();
  }

  /// Get unread alerts
  List<ParentAlert> getUnreadAlerts() {
    return state.alerts.where((alert) => !alert.isRead).toList();
  }

  /// Get unread count
  int getUnreadCount() {
    return state.alerts.where((alert) => !alert.isRead).length;
  }

  /// Get high severity alerts
  List<ParentAlert> getHighSeverityAlerts() {
    return state.alerts.where((alert) => alert.severity == 'high' && !alert.isRead).toList();
  }
}

/// Provider for parent alerts state
final parentAlertsProvider = StateNotifierProvider<ParentAlertsNotifier, ParentAlertsState>((ref) {
  return ParentAlertsNotifier();
});

/// Provider for alerts list
final parentAlertsListProvider = Provider<List<ParentAlert>>((ref) {
  final alertsState = ref.watch(parentAlertsProvider);
  return alertsState.alerts;
});

/// Provider for unread alerts
final unreadAlertsProvider = Provider<List<ParentAlert>>((ref) {
  final notifier = ref.watch(parentAlertsProvider.notifier);
  return notifier.getUnreadAlerts();
});

/// Provider for unread count
final unreadAlertsCountProvider = Provider<int>((ref) {
  final notifier = ref.watch(parentAlertsProvider.notifier);
  return notifier.getUnreadCount();
});

/// Provider for high severity alerts
final highSeverityAlertsProvider = Provider<List<ParentAlert>>((ref) {
  final notifier = ref.watch(parentAlertsProvider.notifier);
  return notifier.getHighSeverityAlerts();
});

/// Provider for checking if alerts are loading
final parentAlertsLoadingProvider = Provider<bool>((ref) {
  final alertsState = ref.watch(parentAlertsProvider);
  return alertsState.isLoading;
});

/// Provider for alerts error
final parentAlertsErrorProvider = Provider<String?>((ref) {
  final alertsState = ref.watch(parentAlertsProvider);
  return alertsState.error;
});
