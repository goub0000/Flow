import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/services/find_your_path_service.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/recommendation.dart';

/// Service provider
final findYourPathServiceProvider = Provider<FindYourPathService>((ref) {
  return FindYourPathService();
});

/// Student profile state
class ProfileState {
  final StudentProfile? profile;
  final bool isLoading;
  final String? error;

  ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    StudentProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Profile notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final FindYourPathService _service;

  ProfileNotifier(this._service) : super(ProfileState());

  /// Load profile for user
  Future<void> loadProfile(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final profile = await _service.getProfile(userId);
      state = ProfileState(profile: profile, isLoading: false);
    } catch (e) {
      state = ProfileState(error: e.toString(), isLoading: false);
    }
  }

  /// Save profile
  Future<void> saveProfile(StudentProfile profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final savedProfile = await _service.saveProfile(profile);
      state = ProfileState(profile: savedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Update profile
  Future<void> updateProfile(StudentProfile profile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedProfile = await _service.updateProfile(profile);
      state = ProfileState(profile: updatedProfile, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Set profile locally (without saving)
  void setProfile(StudentProfile profile) {
    state = state.copyWith(profile: profile);
  }
}

/// Profile provider
final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final service = ref.read(findYourPathServiceProvider);
  return ProfileNotifier(service);
});

/// Recommendations state
class RecommendationsState {
  final RecommendationListResponse? recommendations;
  final bool isLoading;
  final String? error;

  RecommendationsState({
    this.recommendations,
    this.isLoading = false,
    this.error,
  });

  RecommendationsState copyWith({
    RecommendationListResponse? recommendations,
    bool? isLoading,
    String? error,
  }) {
    return RecommendationsState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Recommendations notifier
class RecommendationsNotifier extends StateNotifier<RecommendationsState> {
  final FindYourPathService _service;

  RecommendationsNotifier(this._service) : super(RecommendationsState());

  /// Generate recommendations
  Future<void> generateRecommendations({
    required String userId,
    int limit = 20,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final recommendations = await _service.generateRecommendations(
        userId: userId,
        limit: limit,
      );
      state = RecommendationsState(
        recommendations: recommendations,
        isLoading: false,
      );

      // Load university details for recommendations with null university
      await _loadUniversityDetails();
    } catch (e) {
      state = RecommendationsState(error: e.toString(), isLoading: false);
    }
  }

  /// Load saved recommendations
  Future<void> loadRecommendations(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final recommendations = await _service.getRecommendations(userId);
      state = RecommendationsState(
        recommendations: recommendations,
        isLoading: false,
      );

      // Load university details for recommendations with null university
      await _loadUniversityDetails();
    } catch (e) {
      state = RecommendationsState(error: e.toString(), isLoading: false);
    }
  }

  /// Load university details for recommendations that don't have them
  Future<void> _loadUniversityDetails() async {
    if (state.recommendations == null) return;

    final updatedRecs = <Recommendation>[];

    for (var rec in state.recommendations!.recommendations) {
      // If university is null but universityId exists, fetch it
      if (rec.university == null && rec.universityId != null) {
        try {
          final university = await _service.getUniversity(rec.universityId!);
          updatedRecs.add(rec.copyWith(university: university));
        } catch (e) {
          // If fetching fails, keep the recommendation without university
          updatedRecs.add(rec);
        }
      } else {
        updatedRecs.add(rec);
      }
    }

    // Update state with universities
    state = state.copyWith(
      recommendations: RecommendationListResponse(
        recommendations: updatedRecs,
        totalCount: state.recommendations!.totalCount,
        safetyCount: state.recommendations!.safetyCount,
        matchCount: state.recommendations!.matchCount,
        reachCount: state.recommendations!.reachCount,
      ),
    );
  }

  /// Toggle favorite
  Future<void> toggleFavorite(int recommendationId, int index) async {
    if (state.recommendations == null) return;

    try {
      final favorited = await _service.toggleFavorite(recommendationId);

      // Update local state
      final updatedRecs = List<Recommendation>.from(
        state.recommendations!.recommendations,
      );
      updatedRecs[index] = updatedRecs[index].copyWith(favorited: favorited);

      state = state.copyWith(
        recommendations: RecommendationListResponse(
          recommendations: updatedRecs,
          totalCount: state.recommendations!.totalCount,
          safetyCount: state.recommendations!.safetyCount,
          matchCount: state.recommendations!.matchCount,
          reachCount: state.recommendations!.reachCount,
        ),
      );
    } catch (e) {
      // Handle error silently or show snackbar
    }
  }
}

/// Recommendations provider
final recommendationsProvider =
    StateNotifierProvider<RecommendationsNotifier, RecommendationsState>((ref) {
  final service = ref.read(findYourPathServiceProvider);
  return RecommendationsNotifier(service);
});

/// Check if API is available
final apiHealthProvider = FutureProvider<bool>((ref) async {
  final service = ref.read(findYourPathServiceProvider);
  return await service.healthCheck();
});
