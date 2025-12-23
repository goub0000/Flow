import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/child_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// Result class for link operations
class LinkResult {
  final bool success;
  final String message;
  final String? studentName;
  final String? studentEmail;

  const LinkResult({
    required this.success,
    required this.message,
    this.studentName,
    this.studentEmail,
  });
}

/// Model for a pending link request (parent's view)
class PendingLinkRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String relationship;
  final String status;
  final DateTime createdAt;

  const PendingLinkRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.relationship,
    required this.status,
    required this.createdAt,
  });

  factory PendingLinkRequest.fromJson(Map<String, dynamic> json) {
    return PendingLinkRequest(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? 'Unknown Student',
      studentEmail: json['student_email'] ?? '',
      relationship: json['relationship'] ?? 'parent',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}

/// State class for managing parent's children
class ParentChildrenState {
  final List<Child> children;
  final List<PendingLinkRequest> pendingLinks;
  final bool isLoading;
  final String? error;

  const ParentChildrenState({
    this.children = const [],
    this.pendingLinks = const [],
    this.isLoading = false,
    this.error,
  });

  ParentChildrenState copyWith({
    List<Child>? children,
    List<PendingLinkRequest>? pendingLinks,
    bool? isLoading,
    String? error,
  }) {
    return ParentChildrenState(
      children: children ?? this.children,
      pendingLinks: pendingLinks ?? this.pendingLinks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing parent's children
class ParentChildrenNotifier extends StateNotifier<ParentChildrenState> {
  final ApiClient _apiClient;

  ParentChildrenNotifier(this._apiClient) : super(const ParentChildrenState()) {
    fetchChildren();
    fetchPendingLinks();
  }

  /// Fetch all children for the parent from backend API
  Future<void> fetchChildren() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.parent}/children',
        fromJson: (data) {
          if (data is List) {
            return data.map((childJson) => Child.fromJson(childJson)).toList();
          }
          return <Child>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          children: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch children',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch children: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch pending link requests for the parent
  Future<void> fetchPendingLinks() async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.parent}/links',
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final links = (data['links'] as List? ?? [])
            .where((l) => l['status'] == 'pending')
            .map((l) {
              // Get student info from users if available
              return PendingLinkRequest(
                id: l['id'] ?? '',
                studentId: l['student_id'] ?? '',
                studentName: l['student_name'] ?? 'Unknown Student',
                studentEmail: l['student_email'] ?? '',
                relationship: l['relationship'] ?? 'parent',
                status: l['status'] ?? 'pending',
                createdAt: DateTime.tryParse(l['created_at'] ?? '') ?? DateTime.now(),
              );
            })
            .toList();
        state = state.copyWith(pendingLinks: links);
      }
    } catch (e) {
      // Silently fail - pending links are supplementary
    }
  }

  /// Link a child to parent account via backend API
  Future<bool> addChild(String studentId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.parent}/children',
        data: {
          'student_id': studentId,
        },
        fromJson: (data) => Child.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedChildren = [...state.children, response.data!];
        state = state.copyWith(children: updatedChildren);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to add child',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add child: ${e.toString()}',
      );
      return false;
    }
  }

  /// Link a child by email address
  Future<LinkResult> linkByEmail({
    required String studentEmail,
    String relationship = 'parent',
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.parent}/links/by-email',
        data: {
          'student_email': studentEmail,
          'relationship': relationship,
          'can_view_grades': true,
          'can_view_activity': true,
          'can_view_messages': false,
          'can_receive_alerts': true,
        },
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          // Refresh pending links to show the new request
          fetchPendingLinks();
          return LinkResult(
            success: true,
            message: data['message'] ?? 'Link request sent successfully',
            studentName: data['student_name'],
          );
        } else {
          return LinkResult(
            success: false,
            message: data['message'] ?? 'Failed to send link request',
          );
        }
      } else {
        return LinkResult(
          success: false,
          message: response.message ?? 'Failed to send link request',
        );
      }
    } catch (e) {
      return LinkResult(
        success: false,
        message: 'Failed to send link request: ${e.toString()}',
      );
    }
  }

  /// Link a child using invite code
  Future<LinkResult> linkByCode({
    required String code,
    String relationship = 'parent',
  }) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.parent}/links/use-code',
        data: {
          'code': code,
          'relationship': relationship,
        },
        fromJson: (data) => data,
      );

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true) {
          // Refresh pending links to show the new request
          fetchPendingLinks();
          return LinkResult(
            success: true,
            message: data['message'] ?? 'Link request sent successfully',
            studentName: data['student_name'],
            studentEmail: data['student_email'],
          );
        } else {
          return LinkResult(
            success: false,
            message: data['message'] ?? 'Failed to use invite code',
          );
        }
      } else {
        return LinkResult(
          success: false,
          message: response.message ?? 'Failed to use invite code',
        );
      }
    } catch (e) {
      return LinkResult(
        success: false,
        message: 'Failed to use invite code: ${e.toString()}',
      );
    }
  }

  /// Remove child link via backend API
  Future<bool> removeChild(String childId) async {
    try {
      await _apiClient.delete('${ApiConfig.parent}/children/$childId');

      final updatedChildren = state.children.where((c) => c.id != childId).toList();
      state = state.copyWith(children: updatedChildren);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to remove child: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update child information - kept for compatibility
  Future<bool> updateChild(Child child) async {
    try {
      // Child info is managed by student, parent can't directly update
      // This method exists for backwards compatibility
      final updatedChildren = state.children.map((c) {
        return c.id == child.id ? child : c;
      }).toList();

      state = state.copyWith(children: updatedChildren);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update child: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get child by ID
  Child? getChildById(String id) {
    try {
      return state.children.firstWhere((child) => child.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Search children by name
  List<Child> searchChildren(String query) {
    if (query.isEmpty) return state.children;

    final lowerQuery = query.toLowerCase();
    return state.children.where((child) {
      return child.name.toLowerCase().contains(lowerQuery) ||
          child.grade.toLowerCase().contains(lowerQuery) ||
          (child.school?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Get children statistics
  Map<String, dynamic> getChildrenStatistics() {
    final totalChildren = state.children.length;

    // Calculate average grade
    double totalGrade = 0;
    int gradeCount = 0;

    for (final child in state.children) {
      if (child.averageGrade > 0) {
        totalGrade += child.averageGrade;
        gradeCount++;
      }
    }

    final averageGrade = gradeCount > 0 ? totalGrade / gradeCount : 0;

    // Count total courses and applications
    int totalCourses = 0;
    int totalApplications = 0;
    int activeApplications = 0;

    for (final child in state.children) {
      totalCourses += child.enrolledCourses.length;
      totalApplications += child.applications.length;
      activeApplications += child.applications.where((app) =>
        app.status == 'pending' || app.status == 'under_review'
      ).length;
    }

    return {
      'totalChildren': totalChildren,
      'averageGrade': averageGrade,
      'totalCourses': totalCourses,
      'totalApplications': totalApplications,
      'pendingApplications': activeApplications,
      'childrenWithAlerts': state.children.where((c) => c.lastActive != null &&
        DateTime.now().difference(c.lastActive!).inDays > 3).length,
    };
  }

  /// Get children with low performance (grade < 60)
  List<Child> getChildrenNeedingAttention() {
    return state.children.where((child) => child.averageGrade < 60 && child.averageGrade > 0).toList();
  }

  /// Get children with recent activity (last 24 hours)
  List<Child> getActiveChildren() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return state.children.where((child) {
      return child.lastActive != null && child.lastActive!.isAfter(yesterday);
    }).toList();
  }
}

/// Provider for parent children state
final parentChildrenProvider = StateNotifierProvider<ParentChildrenNotifier, ParentChildrenState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ParentChildrenNotifier(apiClient);
});

/// Provider for children list
final parentChildrenListProvider = Provider<List<Child>>((ref) {
  final childrenState = ref.watch(parentChildrenProvider);
  return childrenState.children;
});

/// Provider for checking if children are loading
final parentChildrenLoadingProvider = Provider<bool>((ref) {
  final childrenState = ref.watch(parentChildrenProvider);
  return childrenState.isLoading;
});

/// Provider for children error
final parentChildrenErrorProvider = Provider<String?>((ref) {
  final childrenState = ref.watch(parentChildrenProvider);
  return childrenState.error;
});

/// Provider for children statistics
final parentChildrenStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(parentChildrenProvider.notifier);
  return notifier.getChildrenStatistics();
});

/// Provider for children needing attention
final childrenNeedingAttentionProvider = Provider<List<Child>>((ref) {
  final notifier = ref.watch(parentChildrenProvider.notifier);
  return notifier.getChildrenNeedingAttention();
});

/// Provider for active children
final activeChildrenProvider = Provider<List<Child>>((ref) {
  final notifier = ref.watch(parentChildrenProvider.notifier);
  return notifier.getActiveChildren();
});

/// Provider for pending link requests
final parentPendingLinksProvider = Provider<List<PendingLinkRequest>>((ref) {
  final childrenState = ref.watch(parentChildrenProvider);
  return childrenState.pendingLinks;
});

/// Provider for pending links count (for badges)
final parentPendingLinksCountProvider = Provider<int>((ref) {
  final childrenState = ref.watch(parentChildrenProvider);
  return childrenState.pendingLinks.length;
});
