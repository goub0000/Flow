import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
  final ApiClient _apiClient;

  AdminUsersNotifier(this._apiClient) : super(const AdminUsersState()) {
    fetchAllUsers();
  }

  /// Fetch all users from backend API (bypasses Supabase RLS)
  Future<void> fetchAllUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Use backend API instead of direct Supabase query
      final response = await _apiClient.get(
        '${ApiConfig.admin}/users',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final usersData = response.data!['users'] as List<dynamic>? ?? [];

        final users = usersData.map((userData) {
          try {
            // Parse user role - use active_role field
            final roleString = userData['active_role'] as String?;
            final activeRole = _parseUserRole(roleString);

            // Parse available_roles array
            List<UserRole> availableRoles = [activeRole];
            if (userData['available_roles'] != null) {
              final rolesArray = userData['available_roles'] as List<dynamic>?;
              if (rolesArray != null && rolesArray.isNotEmpty) {
                availableRoles = rolesArray
                    .map((r) => _parseUserRole(r.toString()))
                    .toList();
              }
            }

            return UserModel(
              id: userData['id'] as String? ?? '',
              email: userData['email'] as String? ?? '',
              displayName: userData['display_name'] as String? ?? 'Unknown User',
              photoUrl: userData['photo_url'] as String?,
              phoneNumber: userData['phone_number'] as String?,
              activeRole: activeRole,
              availableRoles: availableRoles,
              createdAt: userData['created_at'] != null
                  ? DateTime.parse(userData['created_at'] as String)
                  : DateTime.now(),
              lastLoginAt: userData['last_login_at'] != null
                  ? DateTime.parse(userData['last_login_at'] as String)
                  : null,
              isEmailVerified: userData['is_email_verified'] as bool? ?? false,
              isPhoneVerified: userData['is_phone_verified'] as bool? ?? false,
              metadata: {
                // General fields
                'isActive': userData['is_active'] ?? true,
                // Student fields
                'school': userData['school'],
                'grade': userData['grade'],
                'graduation_year': userData['graduation_year'],
                // Institution fields
                'institution_type': userData['institution_type'],
                'location': userData['location'],
                'website': userData['website'],
                // Counselor fields
                'specialty': userData['specialty'],
                // Recommender fields
                'organization': userData['organization'],
                'position': userData['position'],
                // Parent fields
                'children_count': userData['children_count'],
                'occupation': userData['occupation'],
              },
            );
          } catch (e) {
            return null;
          }
        }).whereType<UserModel>().toList();

        state = state.copyWith(
          users: users,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch users',
          isLoading: false,
        );
      }
    } catch (e) {
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
      case 'admin_super':
        return UserRole.superAdmin;
      case 'regionaladmin':
      case 'admin_regional':
        return UserRole.regionalAdmin;
      case 'contentadmin':
      case 'admin_content':
        return UserRole.contentAdmin;
      case 'supportadmin':
      case 'admin_support':
        return UserRole.supportAdmin;
      case 'financeadmin':
      case 'admin_finance':
        return UserRole.financeAdmin;
      case 'analyticsadmin':
      case 'admin_analytics':
        return UserRole.analyticsAdmin;
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
            final updatedRoles = {...user.availableRoles, UserRole.values.firstWhere((r) => UserRoleHelper.getRoleName(r) == newRole, orElse: () => user.activeRole)};
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
        return user.availableRoles.any((role) => UserRoleHelper.getRoleName(role) == state.filter.role);
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
    return state.users.where((user) => user.availableRoles.any((r) => UserRoleHelper.getRoleName(r) == role)).toList();
  }

  /// Get all admin users (users with any admin role)
  List<UserModel> getAdminUsers() {
    final adminRoles = [
      'superadmin', 'regionaladmin', 'contentadmin',
      'supportadmin', 'financeadmin', 'analyticsadmin'
    ];
    return state.users.where((user) =>
      user.availableRoles.any((r) => adminRoles.contains(UserRoleHelper.getRoleName(r)))
    ).toList();
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
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getFilteredUsers();
});

/// Provider for user statistics
final userStatisticsProvider = Provider<Map<String, int>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUserStatistics();
});

/// Provider for students list (admin view)
final adminStudentsProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUsersByRole('student');
});

/// Provider for institutions list (admin view)
final adminInstitutionsProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUsersByRole('institution');
});

/// Provider for parents list (admin view)
final adminParentsProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUsersByRole('parent');
});

/// Provider for counselors list (admin view)
final adminCounselorsProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUsersByRole('counselor');
});

/// Provider for recommenders list (admin view)
final adminRecommendersProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getUsersByRole('recommender');
});

/// Provider for admin users list (all admin roles)
final adminAdminsProvider = Provider<List<UserModel>>((ref) {
  // Watch state to trigger rebuilds when users change
  ref.watch(adminUsersProvider);
  final notifier = ref.read(adminUsersProvider.notifier);
  return notifier.getAdminUsers();
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
