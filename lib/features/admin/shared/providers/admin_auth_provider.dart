import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/admin_user_model.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/services/auth_service.dart';

/// Admin authentication state
class AdminAuthState {
  final AdminUser? currentAdmin;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AdminAuthState({
    this.currentAdmin,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AdminAuthState copyWith({
    AdminUser? currentAdmin,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AdminAuthState(
      currentAdmin: currentAdmin ?? this.currentAdmin,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Admin authentication provider
class AdminAuthNotifier extends StateNotifier<AdminAuthState> {
  final AuthService _authService;

  AdminAuthNotifier(this._authService) : super(const AdminAuthState()) {
    // Check if there's an existing admin session
    _initializeFromAuthState();
  }

  /// Initialize admin state from main auth state
  Future<void> _initializeFromAuthState() async {
    state = state.copyWith(isLoading: true);

    try {
      // Wait for the session to be loaded from storage first
      await _authService.waitForSessionLoad();

      // Only call getCurrentUser if we have a stored session
      if (!_authService.isAuthenticated) {
        // No stored session - user not logged in
        state = const AdminAuthState(isLoading: false);
        return;
      }

      final response = await _authService.getCurrentUser();
      if (response.success && response.data != null) {
        final userData = response.data!;
        final role = UserRoleHelper.getRoleName(userData.activeRole).toLowerCase();
        // Check if user is an admin
        if (role.contains('admin')) {
          final adminUser = _createAdminUserFromUserModel(userData, role);
          state = AdminAuthState(
            currentAdmin: adminUser,
            isAuthenticated: true,
            isLoading: false,
          );
          return;
        }
      }
      // Not an admin or not logged in
      state = const AdminAuthState(isLoading: false);
    } catch (e) {
      state = AdminAuthState(isLoading: false, error: e.toString());
    }
  }

  /// Create AdminUser from UserModel
  AdminUser _createAdminUserFromUserModel(dynamic userData, String role) {
    // Map role string to UserRole enum
    UserRole adminRole;
    AdminPermissions permissions;

    if (role == 'superadmin' || role == 'admin_super') {
      adminRole = UserRole.superAdmin;
      permissions = AdminPermissions.superAdmin();
    } else if (role == 'regionaladmin' || role == 'admin_regional') {
      adminRole = UserRole.regionalAdmin;
      permissions = AdminPermissions.regionalAdmin('global');
    } else if (role == 'contentadmin' || role == 'admin_content') {
      adminRole = UserRole.contentAdmin;
      permissions = AdminPermissions.contentAdmin();
    } else if (role == 'supportadmin' || role == 'admin_support') {
      adminRole = UserRole.supportAdmin;
      permissions = AdminPermissions.supportAdmin();
    } else if (role == 'financeadmin' || role == 'admin_finance') {
      adminRole = UserRole.financeAdmin;
      permissions = AdminPermissions.financeAdmin();
    } else if (role == 'analyticsadmin' || role == 'admin_analytics') {
      adminRole = UserRole.analyticsAdmin;
      permissions = AdminPermissions.analyticsAdmin();
    } else {
      // Default to support admin for unknown admin types
      adminRole = UserRole.supportAdmin;
      permissions = AdminPermissions.supportAdmin();
    }

    return AdminUser(
      id: userData.id ?? '',
      email: userData.email ?? '',
      displayName: userData.displayName ?? 'Admin',
      adminRole: adminRole,
      permissions: permissions,
      mfaEnabled: false,
      createdAt: userData.createdAt ?? DateTime.now(),
      lastLogin: DateTime.now(),
      isActive: true,
    );
  }

  /// Refresh admin state from auth
  Future<void> refreshFromAuth() async {
    await _initializeFromAuthState();
  }

  /// Sign in admin user with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Attempt login - backend auto-confirms admin emails if needed
      var response = await _authService.login(
        email: email,
        password: password,
      );

      // If first attempt fails, wait and retry once (backend may need time
      // to auto-confirm admin email on first login)
      if (!response.success || response.data == null) {
        await Future.delayed(const Duration(seconds: 2));
        response = await _authService.login(
          email: email,
          password: password,
        );
      }

      if (!response.success || response.data == null) {
        throw Exception(response.message ?? 'Login failed');
      }

      final userData = response.data!;
      final role = UserRoleHelper.getRoleName(userData.activeRole).toLowerCase();

      if (!role.contains('admin')) {
        await _authService.logout();
        throw Exception('Access denied: admin role required');
      }

      final adminUser = _createAdminUserFromUserModel(userData, role);
      state = AdminAuthState(
        currentAdmin: adminUser,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      rethrow;
    }
  }

  /// Sign out admin user
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      // Sign out from Supabase auth
      await _authService.logout();

      // Clear admin state
      state = const AdminAuthState();
    } catch (e) {
      // Even if there's an error, clear the local state
      state = const AdminAuthState(error: 'Sign out error');
    }
  }

  /// Refresh admin session
  Future<void> refreshSession() async {
    if (state.currentAdmin == null) return;

    try {
      // TODO: Implement session refresh
      // Verify token
      // Reload permissions
      // Update last activity

      final updatedAdmin = state.currentAdmin!.copyWith(
        lastLogin: DateTime.now(),
      );

      state = state.copyWith(currentAdmin: updatedAdmin);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Update admin profile
  Future<void> updateProfile({
    String? displayName,
    String? profilePhotoUrl,
  }) async {
    if (state.currentAdmin == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // TODO: Implement Supabase profile update

      final updatedAdmin = state.currentAdmin!.copyWith(
        displayName: displayName ?? state.currentAdmin!.displayName,
        profilePhotoUrl: profilePhotoUrl ?? state.currentAdmin!.profilePhotoUrl,
      );

      state = state.copyWith(
        currentAdmin: updatedAdmin,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Enable MFA for admin user
  Future<Map<String, dynamic>> enableMFA() async {
    if (state.currentAdmin == null) {
      throw Exception('No admin user logged in');
    }

    try {
      // TODO: Implement actual MFA setup
      // Generate TOTP secret
      // Create QR code
      // Return setup details

      return {
        'secret': 'MOCK_SECRET_KEY',
        'qrCode': 'https://mock-qr-code.com',
        'backupCodes': ['123456', '234567', '345678', '456789', '567890'],
      };
    } catch (e) {
      throw Exception('Failed to enable MFA: $e');
    }
  }

  /// Verify MFA code
  Future<bool> verifyMFA(String code) async {
    try {
      // TODO: Implement actual MFA verification
      // For now, accept any 6-digit code
      if (code.length == 6 && int.tryParse(code) != null) {
        final updatedAdmin = state.currentAdmin!.copyWith(mfaEnabled: true);
        state = state.copyWith(currentAdmin: updatedAdmin);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Check if user has specific permission
  bool hasPermission(AdminPermission permission) {
    return state.currentAdmin?.hasPermission(permission) ?? false;
  }

  /// Check if user has any of the given permissions
  bool hasAnyPermission(List<AdminPermission> permissions) {
    return state.currentAdmin?.hasAnyPermission(permissions) ?? false;
  }

  /// Check if user has all of the given permissions
  bool hasAllPermissions(List<AdminPermission> permissions) {
    return state.currentAdmin?.hasAllPermissions(permissions) ?? false;
  }
}

/// Admin authentication state provider
final adminAuthProvider =
    StateNotifierProvider<AdminAuthNotifier, AdminAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AdminAuthNotifier(authService);
});

/// Current admin user provider (convenience)
final currentAdminUserProvider = Provider<AdminUser?>((ref) {
  return ref.watch(adminAuthProvider).currentAdmin;
});

/// Admin authentication status provider (convenience)
final isAdminAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(adminAuthProvider).isAuthenticated;
});

/// Admin loading status provider (convenience)
final isAdminLoadingProvider = Provider<bool>((ref) {
  return ref.watch(adminAuthProvider).isLoading;
});
