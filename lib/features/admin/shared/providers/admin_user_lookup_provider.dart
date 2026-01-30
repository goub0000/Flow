import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';

/// State class for User Lookup admin
class AdminUserLookupState {
  final List<UserModel> allUsers;
  final List<UserModel> searchResults;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final int totalUsers;
  final int activeUsers;
  final int studentCount;
  final int institutionCount;

  const AdminUserLookupState({
    this.allUsers = const [],
    this.searchResults = const [],
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.studentCount = 0,
    this.institutionCount = 0,
  });

  AdminUserLookupState copyWith({
    List<UserModel>? allUsers,
    List<UserModel>? searchResults,
    bool? isLoading,
    String? error,
    String? searchQuery,
    int? totalUsers,
    int? activeUsers,
    int? studentCount,
    int? institutionCount,
  }) {
    return AdminUserLookupState(
      allUsers: allUsers ?? this.allUsers,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      totalUsers: totalUsers ?? this.totalUsers,
      activeUsers: activeUsers ?? this.activeUsers,
      studentCount: studentCount ?? this.studentCount,
      institutionCount: institutionCount ?? this.institutionCount,
    );
  }
}

/// StateNotifier for User Lookup admin
class AdminUserLookupNotifier extends StateNotifier<AdminUserLookupState> {
  final ApiClient _apiClient;

  AdminUserLookupNotifier(this._apiClient) : super(const AdminUserLookupState()) {
    fetchAllUsers();
  }

  /// Fetch all users from backend API
  Future<void> fetchAllUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.admin}/users',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final usersData = response.data!['users'] as List<dynamic>? ?? [];

        final users = usersData.map((userData) {
          try {
            return UserModel.fromJson(userData as Map<String, dynamic>);
          } catch (e) {
            return null;
          }
        }).whereType<UserModel>().toList();

        final activeCount = users.where((u) {
          final isActive = u.metadata?['isActive'];
          return isActive == true || isActive == null;
        }).length;
        final studentCount = users.where((u) => u.activeRole == UserRole.student).length;
        final institutionCount = users.where((u) => u.activeRole == UserRole.institution).length;

        state = state.copyWith(
          allUsers: users,
          searchResults: users,
          isLoading: false,
          totalUsers: users.length,
          activeUsers: activeCount,
          studentCount: studentCount,
          institutionCount: institutionCount,
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

  /// Search users (client-side filter)
  void searchUsers(String query) {
    state = state.copyWith(searchQuery: query);

    if (query.isEmpty) {
      state = state.copyWith(searchResults: state.allUsers);
      return;
    }

    final lowerQuery = query.toLowerCase();
    final filtered = state.allUsers.where((user) {
      return (user.displayName?.toLowerCase().contains(lowerQuery) ?? false) ||
          user.email.toLowerCase().contains(lowerQuery) ||
          user.id.toLowerCase().contains(lowerQuery) ||
          user.activeRole.displayName.toLowerCase().contains(lowerQuery);
    }).toList();

    state = state.copyWith(searchResults: filtered);
  }

  /// Get user details by ID
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConfig.auth}/users/$userId',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        return response.data;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Provider for User Lookup admin state
final adminUserLookupProvider =
    StateNotifierProvider<AdminUserLookupNotifier, AdminUserLookupState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminUserLookupNotifier(apiClient);
});
