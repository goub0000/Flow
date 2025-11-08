import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/user_model.dart';
import '../../authentication/providers/auth_provider.dart';

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

  ProfileNotifier(this.ref) : super(const ProfileState()) {
    loadProfile();
  }

  /// Load user profile
  /// TODO: Connect to backend API (Firebase Firestore)
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

      // TODO: Fetch additional profile data from Firestore
      // Example: FirebaseFirestore.instance
      //   .collection('users')
      //   .doc(currentUser.id)
      //   .get()

      await Future.delayed(const Duration(milliseconds: 500));

      state = state.copyWith(
        user: currentUser,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load profile: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update profile information
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
    Map<String, dynamic>? additionalMetadata,
  }) async {
    if (state.user == null) return false;

    state = state.copyWith(isUpdating: true, error: null);

    try {
      // TODO: Update in Firebase Firestore
      // TODO: Update Firebase Auth profile if displayName or photoURL changed

      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = UserModel(
        id: state.user!.id,
        email: state.user!.email,
        displayName: displayName ?? state.user!.displayName,
        photoUrl: photoURL ?? state.user!.photoUrl,
        phoneNumber: phoneNumber ?? state.user!.phoneNumber,
        activeRole: state.user!.activeRole,
        availableRoles: state.user!.availableRoles,
        createdAt: state.user!.createdAt,
        lastLoginAt: state.user!.lastLoginAt,
        isEmailVerified: state.user!.isEmailVerified,
        isPhoneVerified: state.user!.isPhoneVerified,
        metadata: state.user!.metadata != null
            ? {...state.user!.metadata!, if (additionalMetadata != null) ...additionalMetadata}
            : additionalMetadata,
      );

      state = state.copyWith(
        user: updatedUser,
        isUpdating: false,
      );

      // Also update auth provider
      // TODO: Implement updateUser method in AuthNotifier
      // ref.read(authProvider.notifier).updateUser(updatedUser);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update profile: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Upload profile photo
  /// TODO: Connect to backend API (Firebase Storage)
  Future<bool> uploadProfilePhoto(String localFilePath) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      // TODO: Upload to Firebase Storage
      // TODO: Get download URL
      // TODO: Update user profile with new photo URL

      await Future.delayed(const Duration(seconds: 2));

      final photoURL = 'https://example.com/photos/${state.user!.id}.jpg';

      return await updateProfile(photoURL: photoURL);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to upload photo: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Change password
  /// TODO: Connect to backend API (Firebase Auth)
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      // TODO: Re-authenticate user with current password
      // TODO: Update password with Firebase Auth
      // Example: FirebaseAuth.instance.currentUser?.updatePassword(newPassword)

      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isUpdating: false);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to change password: ${e.toString()}',
        isUpdating: false,
      );
      return false;
    }
  }

  /// Delete account
  /// TODO: Connect to backend API (Firebase Auth & Firestore)
  Future<bool> deleteAccount(String password) async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      // TODO: Re-authenticate user
      // TODO: Delete user data from Firestore
      // TODO: Delete Firebase Auth account

      await Future.delayed(const Duration(seconds: 2));

      // Sign out after deletion
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
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateNotificationPreferences(Map<String, bool> preferences) async {
    if (state.user == null) return false;

    try {
      // TODO: Update in Firestore

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedMetadata = {
        ...?state.user!.metadata,
        'notificationPreferences': preferences,
      };

      return await updateProfile(additionalMetadata: updatedMetadata);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update preferences: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update privacy settings
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updatePrivacySettings(Map<String, dynamic> settings) async {
    if (state.user == null) return false;

    try {
      // TODO: Update in Firestore

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedMetadata = {
        ...?state.user!.metadata,
        'privacySettings': settings,
      };

      return await updateProfile(additionalMetadata: updatedMetadata);
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
  return ProfileNotifier(ref);
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
