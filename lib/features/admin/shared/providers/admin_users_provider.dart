import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/constants/user_roles.dart';

/// User filter options
class UserFilter {
  final String? role;
  final String? status;
  final String? searchQuery;

  const UserFilter({
    this.role,
    this.status,
    this.searchQuery,
  });

  UserFilter copyWith({
    String? role,
    String? status,
    String? searchQuery,
  }) {
    return UserFilter(
      role: role ?? this.role,
      status: status ?? this.status,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// State class for managing users (admin view)
class AdminUsersState {
  final List<UserModel> users;
  final UserFilter filter;
  final bool isLoading;
  final String? error;

  const AdminUsersState({
    this.users = const [],
    this.filter = const UserFilter(),
    this.isLoading = false,
    this.error,
  });

  AdminUsersState copyWith({
    List<UserModel>? users,
    UserFilter? filter,
    bool? isLoading,
    String? error,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing users (admin)
class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  AdminUsersNotifier() : super(const AdminUsersState()) {
    fetchAllUsers();
  }

  /// Fetch all users
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchAllUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance.collection('users').get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockUsers = List.generate(
        50,
        (index) => UserModel(
          id: 'user_$index',
          email: 'user$index@example.com',
          displayName: 'User $index',
          photoUrl: null,
          phoneNumber: '+254700${(100000 + index).toString().substring(0, 6)}',
          activeRole: UserRole.values[index % UserRole.values.length],
          availableRoles: [UserRole.values[index % UserRole.values.length]],
          createdAt: DateTime.now().subtract(Duration(days: index)),
          lastLoginAt: DateTime.now().subtract(Duration(hours: index)),
          isEmailVerified: index % 2 == 0,
          isPhoneVerified: index % 3 == 0,
          metadata: {'isActive': true, 'index': index},
        ),
      );

      state = state.copyWith(
        users: mockUsers,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch users: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update user status (activate/deactivate)
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      // TODO: Update in Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedUsers = state.users.map((user) {
        if (user.id == userId) {
          return UserModel(
            id: user.id,
            email: user.email,
            displayName: user.displayName,
            photoUrl: user.photoUrl,
            phoneNumber: user.phoneNumber,
            activeRole: user.activeRole,
            availableRoles: user.availableRoles,
            createdAt: user.createdAt,
            lastLoginAt: user.lastLoginAt,
            isEmailVerified: user.isEmailVerified,
            isPhoneVerified: user.isPhoneVerified,
            metadata: {...?user.metadata, 'isActive': isActive},
          );
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update user status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete user
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> deleteUser(String userId) async {
    try {
      // TODO: Delete from Firebase (soft delete recommended)

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedUsers = state.users.where((user) => user.id != userId).toList();
      state = state.copyWith(users: updatedUsers);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete user: ${e.toString()}',
      );
      return false;
    }
  }

  /// Bulk update user roles
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> bulkUpdateRoles(List<String> userIds, String newRole) async {
    try {
      // TODO: Batch update in Firebase

      await Future.delayed(const Duration(milliseconds: 800));

      // Update locally
      final updatedUsers = state.users.map((user) {
        if (userIds.contains(user.id)) {
          final updatedRoles = {...user.availableRoles, UserRole.values.firstWhere((r) => r.name == newRole, orElse: () => user.activeRole)};
          return UserModel(
            id: user.id,
            email: user.email,
            displayName: user.displayName,
            photoUrl: user.photoUrl,
            phoneNumber: user.phoneNumber,
            activeRole: user.activeRole,
            availableRoles: updatedRoles.toList(),
            createdAt: user.createdAt,
            lastLoginAt: user.lastLoginAt,
            isEmailVerified: user.isEmailVerified,
            isPhoneVerified: user.isPhoneVerified,
            metadata: user.metadata,
          );
        }
        return user;
      }).toList();

      state = state.copyWith(users: updatedUsers);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to bulk update roles: ${e.toString()}',
      );
      return false;
    }
  }

  /// Set filter
  void setFilter(UserFilter filter) {
    state = state.copyWith(filter: filter);
  }

  /// Get filtered users
  List<UserModel> getFilteredUsers() {
    var filteredUsers = state.users;

    // Filter by role
    if (state.filter.role != null && state.filter.role!.isNotEmpty && state.filter.role != 'all') {
      filteredUsers = filteredUsers.where((user) {
        return user.availableRoles.any((role) => role.name == state.filter.role);
      }).toList();
    }

    // Filter by search query
    if (state.filter.searchQuery != null && state.filter.searchQuery!.isNotEmpty) {
      final query = state.filter.searchQuery!.toLowerCase();
      filteredUsers = filteredUsers.where((user) {
        return (user.displayName?.toLowerCase().contains(query) ?? false) ||
            user.email.toLowerCase().contains(query);
      }).toList();
    }

    // Filter by status
    if (state.filter.status != null && state.filter.status!.isNotEmpty) {
      filteredUsers = filteredUsers.where((user) {
        final isActive = user.metadata?['isActive'] ?? true;
        return state.filter.status == 'active' ? isActive : !isActive;
      }).toList();
    }

    return filteredUsers;
  }

  /// Get users by role
  List<UserModel> getUsersByRole(String role) {
    return state.users.where((user) => user.availableRoles.any((r) => r.name == role)).toList();
  }

  /// Get user statistics
  Map<String, int> getUserStatistics() {
    return {
      'total': state.users.length,
      'students': getUsersByRole('student').length,
      'institutions': getUsersByRole('institution').length,
      'parents': getUsersByRole('parent').length,
      'counselors': getUsersByRole('counselor').length,
      'recommenders': getUsersByRole('recommender').length,
      'active': state.users.where((u) => u.metadata?['isActive'] ?? true).length,
      'inactive': state.users.where((u) => !(u.metadata?['isActive'] ?? true)).length,
    };
  }
}

/// Provider for admin users state
final adminUsersProvider = StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  return AdminUsersNotifier();
});

/// Provider for filtered users list
final filteredUsersProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getFilteredUsers();
});

/// Provider for user statistics
final userStatisticsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUserStatistics();
});

/// Provider for students list (admin view)
final adminStudentsProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUsersByRole('student');
});

/// Provider for institutions list (admin view)
final adminInstitutionsProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUsersByRole('institution');
});

/// Provider for parents list (admin view)
final adminParentsProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUsersByRole('parent');
});

/// Provider for counselors list (admin view)
final adminCounselorsProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUsersByRole('counselor');
});

/// Provider for recommenders list (admin view)
final adminRecommendersProvider = Provider<List<UserModel>>((ref) {
  final notifier = ref.watch(adminUsersProvider.notifier);
  return notifier.getUsersByRole('recommender');
});

/// Provider for checking if users are loading
final adminUsersLoadingProvider = Provider<bool>((ref) {
  final usersState = ref.watch(adminUsersProvider);
  return usersState.isLoading;
});

/// Provider for users error
final adminUsersErrorProvider = Provider<String?>((ref) {
  final usersState = ref.watch(adminUsersProvider);
  return usersState.error;
});
