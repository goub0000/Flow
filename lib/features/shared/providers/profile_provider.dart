import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing user profile
class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final bool isUpdating;
  final String? error;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.isUpdating = false,
    this.error,
  });

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    bool? isUpdating,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
    );
  }
}

/// StateNotifier for managing user profile
class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;
  final AuthService _authService;

  ProfileNotifier(this.ref, this._authService) : super(const ProfileState()) {
    loadProfile();
  }

  /// Load user profile from backend API
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get current user from auth provider
      final currentUser = ref.read(currentUserProvider);

      if (currentUser == null) {
        state = state.copyWith(
          error: 'No user logged in',
          isLoading: false,
        );
        return;
      }

      // Fetch fresh user data from backend
      final response = await _authService.getCurrentUser();

      if (response.success && response.data != null) {
        state = state.copyWith(
          user: response.data,
          isLoading: false,
        );

        // Update auth provider with fresh data
        ref.read(authProvider.notifier).refreshUser();
      } else {
        state = state.copyWith(
          user: currentUser,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load profile: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update profile information via backend API
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
  }) async {
    if (state.user == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      final response = await _authService.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        bio: bio,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          user: response.data,
          isUpdating: false,
        );

        // Update auth provider with new data
        ref.read(authProvider.notifier).refreshUser();
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update profile',
          isUpdating: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update profile: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Change password via backend API
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final response = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      if (response.success) {
        state = state.copyWith(isUpdating: false);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to change password',
          isUpdating: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to change password: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Deprecated method for backward compatibility
  @deprecated
  Future<bool> updateLegacyProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    Map<String, dynamic>? additionalMetadata,
  }) async {
    return updateProfile(
      fullName: displayName,
      phoneNumber: phoneNumber,
    );
  }

  /// Upload profile photo
  /// TODO: Upload to storage service when implemented
  Future<bool> uploadProfilePhoto(String localFilePath) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      // TODO: Implement file upload to Supabase Storage or other storage service
      // For now, this is a placeholder
      state = state.copyWith(
        error: 'Photo upload not yet implemented',
        isUpdating: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to upload photo: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Delete account via backend API
  Future<bool> deleteAccount() async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      // Call backend DELETE /auth/me endpoint
      final response = await _authService.getCurrentUser(); // Just to verify auth works

      // TODO: Backend needs to implement proper account deletion
      // For now, just sign out
      await ref.read(authProvider.notifier).signOut();

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete account: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Update notification preferences
  /// TODO: Backend needs notification preferences endpoint
  Future<bool> updateNotificationPreferences(Map<String, bool> preferences) async {
    if (state.user == null) return false;

    try {
      // TODO: Call backend notification preferences API when available
      // For now, store locally
      state = state.copyWith(
        error: 'Notification preferences update not yet implemented',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update preferences: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update privacy settings
  /// TODO: Backend needs privacy settings endpoint
  Future<bool> updatePrivacySettings(Map<String, dynamic> settings) async {
    if (state.user == null) return false;

    try {
      // TODO: Call backend privacy settings API when available
      // For now, store locally
      state = state.copyWith(
        error: 'Privacy settings update not yet implemented',
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update privacy settings: ${e.toString()}',
      );
      return false;
    }
  }

  /// Refresh profile
  Future<void> refresh() async {
    await loadProfile();
  }

  /// Get profile completeness percentage
  int getProfileCompleteness() {
    if (state.user == null) return 0;

    int completedFields = 0;
    const totalFields = 5;

    if (state.user!.displayName != null && state.user!.displayName!.isNotEmpty) completedFields++;
    if (state.user!.email.isNotEmpty) completedFields++;
    if (state.user!.phoneNumber != null && state.user!.phoneNumber!.isNotEmpty) completedFields++;
    if (state.user!.photoUrl != null && state.user!.photoUrl!.isNotEmpty) completedFields++;
    if (state.user!.metadata != null && state.user!.metadata!.isNotEmpty) completedFields++;

    return ((completedFields / totalFields) * 100).round();
  }
}

/// Provider for profile state
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ProfileNotifier(ref, authService);
});

/// Provider for current profile user
final currentProfileProvider = Provider<UserModel?>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.user;
});

/// Provider for profile completeness
final profileCompletenessProvider = Provider<int>((ref) {
  final notifier = ref.watch(profileProvider.notifier);
  return notifier.getProfileCompleteness();
});

/// Provider for checking if profile is loading
final profileLoadingProvider = Provider<bool>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.isLoading;
});

/// Provider for checking if profile is updating
final profileUpdatingProvider = Provider<bool>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.isUpdating;
});

/// Provider for profile error
final profileErrorProvider = Provider<String?>((ref) {
  final profileState = ref.watch(profileProvider);
  return profileState.error;
});
