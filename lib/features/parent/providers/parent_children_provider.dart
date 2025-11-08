import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/child_model.dart';

/// State class for managing parent's children
class ParentChildrenState {
  final List<Child> children;
  final bool isLoading;
  final String? error;

  const ParentChildrenState({
    this.children = const [],
    this.isLoading = false,
    this.error,
  });

  ParentChildrenState copyWith({
    List<Child>? children,
    bool? isLoading,
    String? error,
  }) {
    return ParentChildrenState(
      children: children ?? this.children,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing parent's children
class ParentChildrenNotifier extends StateNotifier<ParentChildrenState> {
  ParentChildrenNotifier() : super(const ParentChildrenState()) {
    fetchChildren();
  }

  /// Fetch all children for the parent
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchChildren() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('children')
      //   .where('parentId', isEqualTo: currentParentId)
      //   .get()

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockChildren = [
        Child.mockChild(0),
        Child.mockChild(1),
      ];

      state = state.copyWith(
        children: mockChildren,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch children: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Add a new child
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addChild(Child child) async {
    try {
      // TODO: Replace with actual Firebase write
      // Example: FirebaseFirestore.instance.collection('children').add(child.toJson())

      await Future.delayed(const Duration(milliseconds: 500));

      // Add to local state
      final updatedChildren = [...state.children, child];
      state = state.copyWith(children: updatedChildren);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add child: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update child information
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateChild(Child child) async {
    try {
      // TODO: Replace with actual Firebase update

      await Future.delayed(const Duration(milliseconds: 500));

      // Update in local state
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

  /// Remove a child
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> removeChild(String childId) async {
    try {
      // TODO: Replace with actual Firebase delete

      await Future.delayed(const Duration(milliseconds: 500));

      // Remove from local state
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
  return ParentChildrenNotifier();
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
