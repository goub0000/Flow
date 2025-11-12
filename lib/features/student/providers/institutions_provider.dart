import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/institution_model.dart';
import '../../../core/api/api_config.dart';
import '../services/institutions_api_service.dart';

/// State class for managing institutions
class InstitutionsState {
  final List<Institution> institutions;
  final int total;
  final int currentPage;
  final int pageSize;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final bool? filterVerified;
  final String sortBy; // name, offerings, created_at
  final bool sortAscending;
  final bool hasMorePages;

  const InstitutionsState({
    this.institutions = const [],
    this.total = 0,
    this.currentPage = 1,
    this.pageSize = 20,
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.filterVerified,
    this.sortBy = 'name',
    this.sortAscending = true,
    this.hasMorePages = false,
  });

  InstitutionsState copyWith({
    List<Institution>? institutions,
    int? total,
    int? currentPage,
    int? pageSize,
    bool? isLoading,
    String? error,
    String? searchQuery,
    bool? filterVerified,
    String? sortBy,
    bool? sortAscending,
    bool? hasMorePages,
  }) {
    return InstitutionsState(
      institutions: institutions ?? this.institutions,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery,
      filterVerified: filterVerified,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      hasMorePages: hasMorePages ?? this.hasMorePages,
    );
  }

  /// Calculate total number of pages
  int get totalPages {
    if (total == 0 || pageSize == 0) return 0;
    return (total / pageSize).ceil();
  }
}

/// StateNotifier for managing institutions
class InstitutionsNotifier extends StateNotifier<InstitutionsState> {
  final InstitutionsApiService _apiService;
  final Ref _ref;

  InstitutionsNotifier(this._ref)
      : _apiService = InstitutionsApiService(),
        super(const InstitutionsState()) {
    _initialize();
  }

  /// Initialize authentication token from SharedPreferences and fetch institutions
  Future<void> _initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConfig.accessTokenKey);
      if (token != null) {
        _apiService.setAuthToken(token);
        // Only fetch after token is set
        await fetchInstitutions();
      } else {
        state = state.copyWith(
          error: 'Authentication required. Please login.',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to initialize: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch institutions with current filters and pagination
  Future<void> fetchInstitutions({bool loadMore = false}) async {
    if (state.isLoading) return; // Prevent duplicate requests

    // If loading more, increment page, otherwise start from page 1
    final page = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page,
    );

    try {
      final response = await _apiService.getInstitutions(
        search: state.searchQuery,
        page: page,
        pageSize: state.pageSize,
        isVerified: state.filterVerified,
      );

      // Apply client-side sorting
      var institutions = _sortInstitutions(response.institutions);

      // If loading more, append to existing list
      if (loadMore && page > 1) {
        institutions = [...state.institutions, ...institutions];
      }

      state = state.copyWith(
        institutions: institutions,
        total: response.total,
        isLoading: false,
        hasMorePages: response.hasMorePages,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch institutions: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Load more institutions (pagination)
  Future<void> loadMore() async {
    if (!state.hasMorePages || state.isLoading) return;
    await fetchInstitutions(loadMore: true);
  }

  /// Update search query and refetch
  Future<void> setSearchQuery(String query) async {
    state = state.copyWith(
      searchQuery: query.isEmpty ? null : query,
      currentPage: 1, // Reset to first page
    );
    await fetchInstitutions();
  }

  /// Set verified filter and refetch
  Future<void> setVerifiedFilter(bool? isVerified) async {
    state = state.copyWith(
      filterVerified: isVerified,
      currentPage: 1, // Reset to first page
    );
    await fetchInstitutions();
  }

  /// Set sort criteria and re-sort
  void setSortBy(String sortBy, {bool? ascending}) {
    state = state.copyWith(
      sortBy: sortBy,
      sortAscending: ascending ?? state.sortAscending,
    );
    // Re-sort current institutions
    final sorted = _sortInstitutions(state.institutions);
    state = state.copyWith(institutions: sorted);
  }

  /// Toggle sort order
  void toggleSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
    final sorted = _sortInstitutions(state.institutions);
    state = state.copyWith(institutions: sorted);
  }

  /// Clear all filters and reset
  Future<void> clearFilters() async {
    state = const InstitutionsState();
    await _initialize();
  }

  /// Refresh institutions (pull-to-refresh)
  Future<void> refresh() async {
    state = state.copyWith(currentPage: 1);
    await fetchInstitutions();
  }

  /// Sort institutions based on current criteria
  List<Institution> _sortInstitutions(List<Institution> institutions) {
    final sorted = List<Institution>.from(institutions);

    sorted.sort((a, b) {
      int comparison = 0;

      switch (state.sortBy) {
        case 'name':
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case 'offerings':
          comparison = a.totalOfferings.compareTo(b.totalOfferings);
          break;
        case 'programs':
          comparison = a.programsCount.compareTo(b.programsCount);
          break;
        case 'courses':
          comparison = a.coursesCount.compareTo(b.coursesCount);
          break;
        case 'created_at':
          if (a.createdAt != null && b.createdAt != null) {
            comparison = a.createdAt!.compareTo(b.createdAt!);
          }
          break;
        default:
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }

      return state.sortAscending ? comparison : -comparison;
    });

    return sorted;
  }

  /// Get institution by ID
  Future<Institution?> getInstitutionById(String institutionId) async {
    try {
      return await _apiService.getInstitution(institutionId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch institution: ${e.toString()}',
      );
      return null;
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for institutions state
final institutionsProvider =
    StateNotifierProvider<InstitutionsNotifier, InstitutionsState>((ref) {
  return InstitutionsNotifier(ref);
});

/// Provider for institutions list
final institutionsListProvider = Provider<List<Institution>>((ref) {
  final institutionsState = ref.watch(institutionsProvider);
  return institutionsState.institutions;
});

/// Provider for checking if institutions are loading
final institutionsLoadingProvider = Provider<bool>((ref) {
  final institutionsState = ref.watch(institutionsProvider);
  return institutionsState.isLoading;
});

/// Provider for institutions error
final institutionsErrorProvider = Provider<String?>((ref) {
  final institutionsState = ref.watch(institutionsProvider);
  return institutionsState.error;
});

/// Provider for total institutions count
final institutionsTotalProvider = Provider<int>((ref) {
  final institutionsState = ref.watch(institutionsProvider);
  return institutionsState.total;
});

/// Provider for checking if more pages are available
final institutionsHasMoreProvider = Provider<bool>((ref) {
  final institutionsState = ref.watch(institutionsProvider);
  return institutionsState.hasMorePages;
});
