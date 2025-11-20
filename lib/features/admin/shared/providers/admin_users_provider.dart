import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

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
  final SupabaseClient _supabase = Supabase.instance.client;
  final ApiClient _apiClient;

  AdminUsersNotifier(this._apiClient) : super(const AdminUsersState()) {
    fetchAllUsers();
  }

  /// Fetch all users from Supabase
  Future<void> fetchAllUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Query profiles table from Supabase
      final profilesData = await _supabase.from('profiles').select('*') as List<dynamic>;

      final users = profilesData.map((profile) {
        try {
          // Parse user role
          final roleString = profile['role'] as String?;
          final activeRole = _parseUserRole(roleString);

          return UserModel(
            id: profile['id'] as String,
            email: profile['email'] as String? ?? '',
            displayName: profile['full_name'] as String? ?? profile['display_name'] as String? ?? 'Unknown User',
            photoUrl: profile['avatar_url'] as String?,
            phoneNumber: profile['phone'] as String?,
            activeRole: activeRole,
            availableRoles: [activeRole],
            createdAt: profile['created_at'] != null
                ? DateTime.parse(profile['created_at'] as String)
                : DateTime.now(),
            lastLoginAt: profile['last_login_at'] != null
                ? DateTime.parse(profile['last_login_at'] as String)
                : null,
            isEmailVerified: profile['email_verified'] as bool? ?? false,
            isPhoneVerified: profile['phone_verified'] as bool? ?? false,
            metadata: {
              'isActive': profile['is_active'] ?? true,
              'onboarding_completed': profile['onboarding_completed'] ?? false,
            },
          );
        } catch (e) {
          print('[AdminUsers] Error parsing user: $e');
          return null;
        }
      }).whereType<UserModel>().toList();

      state = state.copyWith(
        users: users,
        isLoading: false,
      );
    } catch (e) {
      print('[AdminUsers] Error fetching users from Supabase: $e');
      state = state.copyWith(
        error: 'Failed to fetch users: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Helper to parse user role from string
  UserRole _parseUserRole(String? roleString) {
    if (roleString == null) return UserRole.student;

    switch (roleString.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'parent':
        return UserRole.parent;
      case 'counselor':
        return UserRole.counselor;
      case 'recommender':
        return UserRole.recommender;
      case 'institution':
        return UserRole.institution;
      case 'admin':
      case 'superadmin':
        return UserRole.superAdmin;
      default:
        return UserRole.student;
    }
  }

  /// Update user status (activate/deactivate)
  Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.admin}/users/$userId/status',
        data: {'is_active': isActive},
        fromJson: (data) => data,
      );

      if (response.success) {
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
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update user status',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update user status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      await _apiClient.delete('${ApiConfig.admin}/users/$userId');

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
  Future<bool> bulkUpdateRoles(List<String> userIds, String newRole) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.admin}/users/bulk-update-roles',
        data: {
          'user_ids': userIds,
          'role': newRole,
        },
        fromJson: (data) => data,
      );

      if (response.success) {
        // Update locally
        final updatedUsers = state.users.map((user) {
          if (userIds.contains(user.id)) {
            final updatedRoles = {...user.availableRoles, UserRole.values.firstWhere((r) => r.roleName == newRole, orElse: () => user.activeRole)};
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
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to bulk update roles',
        );
        return false;
      }
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
        return user.availableRoles.any((role) => role.roleName == state.filter.role);
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
    return state.users.where((user) => user.availableRoles.any((r) => r.roleName == role)).toList();
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
  final apiClient = ref.watch(apiClientProvider);
  return AdminUsersNotifier(apiClient);
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
