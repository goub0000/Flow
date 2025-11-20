import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/service_providers.dart';

/// Authentication state
class AuthState {
  final UserModel? user;
  final String? accessToken;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.accessToken,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    String? accessToken,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  AuthState clearUser() {
    return AuthState(
      user: null,
      accessToken: null,
      isLoading: isLoading,
      error: error,
    );
  }
}

/// Auth provider using StateNotifier with backend API
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _checkAuthState();
  }

  /// Check authentication state on init
  Future<void> _checkAuthState() async {
    state = state.copyWith(isLoading: true);

    try {
      // Check if user is already logged in
      if (_authService.isAuthenticated) {
        final user = _authService.currentUser;
        final token = _authService.accessToken;
        state = state.copyWith(user: user, accessToken: token, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      print('Error checking auth state: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// Sign in with email and password
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        final token = _authService.accessToken;
        print('✅ Login successful! User: ${response.data!.email}, Role: ${response.data!.activeRole.roleName}');
        state = state.copyWith(user: response.data, accessToken: token, isLoading: false);
        print('✅ Auth state updated. isAuthenticated: ${state.isAuthenticated}');
      } else {
        print('❌ Login failed: ${response.message}');
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Login failed',
        );
      }
    } catch (e) {
      print('❌ Login error: $e');
      state = state.copyWith(
        isLoading: false,
        error: 'Sign in failed: ${e.toString()}',
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
    required String displayName,
    required UserRole role,
    String? phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        role: role,
        fullName: displayName,
        phoneNumber: phoneNumber,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(user: response.data, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Registration failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sign up failed: ${e.toString()}',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Sign out failed: ${e.toString()}',
      );
    }
  }

  /// Switch active role
  Future<void> switchRole(UserRole newRole) async {
    if (state.user == null) return;

    if (!state.user!.canSwitchTo(newRole)) {
      state = state.copyWith(error: 'Cannot switch to this role');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      final response = await _authService.switchRole(newRole);

      if (response.success && response.data != null) {
        state = state.copyWith(user: response.data, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Role switch failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Role switch failed: ${e.toString()}',
      );
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      final response = await _authService.requestPasswordReset(email: email);

      if (!response.success) {
        throw Exception(response.message ?? 'Password reset failed');
      }
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  /// Refresh current user data
  Future<void> refreshUser() async {
    if (state.user == null) return;

    try {
      final response = await _authService.getCurrentUser();

      if (response.success && response.data != null) {
        state = state.copyWith(user: response.data);
      }
    } catch (e) {
      print('Error refreshing user: $e');
    }
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});
