import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/auth_provider.dart';
import '../../shared/counseling/models/counseling_models.dart';
import '../services/institution_counselors_service.dart';

/// Provider for the institution counselors service
final institutionCounselorsServiceProvider = Provider<InstitutionCounselorsService>((ref) {
  final authState = ref.watch(authStateProvider);
  final token = authState.value?.session?.accessToken;
  return InstitutionCounselorsService(authToken: token);
});

/// State for institution counselors management
class InstitutionCounselorsState {
  final List<InstitutionCounselor> counselors;
  final int total;
  final int totalPages;
  final int currentPage;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final Map<String, dynamic>? stats;

  const InstitutionCounselorsState({
    this.counselors = const [],
    this.total = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.stats,
  });

  InstitutionCounselorsState copyWith({
    List<InstitutionCounselor>? counselors,
    int? total,
    int? totalPages,
    int? currentPage,
    bool? isLoading,
    String? error,
    String? searchQuery,
    Map<String, dynamic>? stats,
    bool clearError = false,
  }) {
    return InstitutionCounselorsState(
      counselors: counselors ?? this.counselors,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      stats: stats ?? this.stats,
    );
  }
}

/// Notifier for institution counselors state
class InstitutionCounselorsNotifier extends StateNotifier<InstitutionCounselorsState> {
  final InstitutionCounselorsService _service;

  InstitutionCounselorsNotifier(this._service)
      : super(const InstitutionCounselorsState());

  /// Load counselors
  Future<void> loadCounselors({int page = 1, String? search}) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      currentPage: page,
      searchQuery: search ?? state.searchQuery,
    );

    try {
      final result = await _service.getCounselors(
        page: page,
        search: search ?? state.searchQuery,
      );

      state = state.copyWith(
        counselors: result.counselors,
        total: result.total,
        totalPages: result.totalPages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load stats
  Future<void> loadStats() async {
    try {
      final stats = await _service.getStats();
      state = state.copyWith(stats: stats);
    } catch (e) {
      // Stats are optional
    }
  }

  /// Search counselors
  void search(String query) {
    loadCounselors(page: 1, search: query);
  }

  /// Go to next page
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      loadCounselors(page: state.currentPage + 1);
    }
  }

  /// Go to previous page
  void previousPage() {
    if (state.currentPage > 1) {
      loadCounselors(page: state.currentPage - 1);
    }
  }

  /// Assign counselor to student
  Future<bool> assignCounselor({
    required String counselorId,
    required String studentId,
  }) async {
    try {
      await _service.assignCounselorToStudent(
        counselorId: counselorId,
        studentId: studentId,
      );
      // Reload counselors to update student counts
      await loadCounselors(page: state.currentPage);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Refresh
  Future<void> refresh() async {
    await Future.wait([
      loadCounselors(page: 1),
      loadStats(),
    ]);
  }
}

/// Provider for institution counselors state
final institutionCounselorsProvider =
    StateNotifierProvider<InstitutionCounselorsNotifier, InstitutionCounselorsState>(
        (ref) {
  final service = ref.watch(institutionCounselorsServiceProvider);
  return InstitutionCounselorsNotifier(service);
});

/// Provider for students list (for assignment)
final institutionStudentsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String?>((ref, search) async {
  final service = ref.watch(institutionCounselorsServiceProvider);
  final result = await service.getStudents(search: search);
  return result.students;
});
