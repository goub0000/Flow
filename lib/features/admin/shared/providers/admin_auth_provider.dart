import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/admin_user_model.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/constants/user_roles.dart';

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
  AdminAuthNotifier() : super(const AdminAuthState()) {
    // TEMPORARY: Mock login for testing UI only
    // TODO: REMOVE this before production - Replace with actual authentication
    _mockLoginForTesting();
  }

  // TODO: Initialize authentication state from backend
  // - Check for existing session/token
  // - Validate session with backend
  // - Load admin user data and permissions

  /// TEMPORARY: Mock login for testing purposes only
  /// TODO: REMOVE before production
  ///
  /// TESTING HIERARCHY:
  /// Change the adminRole below to test different admin levels:
  /// - UserRole.superAdmin (Level 3) - Can manage ALL admin types
  /// - UserRole.regionalAdmin (Level 2) - Can manage specialized admins only
  /// - UserRole.contentAdmin (Level 1) - Cannot manage any admin types
  /// - UserRole.supportAdmin (Level 1) - Cannot manage any admin types
  /// - UserRole.financeAdmin (Level 1) - Cannot manage any admin types
  /// - UserRole.analyticsAdmin (Level 1) - Cannot manage any admin types
  void _mockLoginForTesting() {
    final mockAdmin = AdminUser(
      id: 'mock-admin-001',
      email: 'admin@test.com',
      displayName: 'Test Super Admin',
      adminRole: UserRole.superAdmin, // <-- CHANGE THIS TO TEST DIFFERENT ADMIN LEVELS
      permissions: AdminPermissions.superAdmin(),
      mfaEnabled: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLogin: DateTime.now(),
      isActive: true,
    );

    state = AdminAuthState(
      currentAdmin: mockAdmin,
      isAuthenticated: true,
      isLoading: false,
    );
  }

  /// Sign in admin user with email, password, and MFA code
  Future<void> signIn({
    required String email,
    required String password,
    required String mfaCode,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Implement Firebase authentication
      // 1. Call Firebase Auth to validate email/password
      // 2. Verify MFA code with Firebase
      // 3. Fetch admin user data from Firestore
      // 4. Load admin permissions based on role
      // 5. Create secure session token
      // 6. Log authentication event to audit log

      throw UnimplementedError('Backend authentication not yet implemented');

      // Example of what the implementation should look like:
      // final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );
      //
      // final adminDoc = await FirebaseFirestore.instance
      //   .collection('admins')
      //   .doc(credential.user!.uid)
      //   .get();
      //
      // final adminUser = AdminUser.fromFirestore(adminDoc);
      //
      // state = state.copyWith(
      //   currentAdmin: adminUser,
      //   isLoading: false,
      //   isAuthenticated: true,
      // );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
    }
  }

  /// Sign out admin user
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      // TODO: Implement actual Firebase sign out
      // Clear session
      // Log audit event

      await Future.delayed(const Duration(milliseconds: 500));

      state = const AdminAuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
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
      // TODO: Implement Firebase profile update

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
  return AdminAuthNotifier();
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
