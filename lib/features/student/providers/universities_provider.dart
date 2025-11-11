import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/university_model.dart';
import '../services/universities_api_service.dart';

/// State class for managing universities
class UniversitiesState {
  final List<University> universities;
  final int total;
  final bool isLoading;
  final String? error;
  final String? searchQuery;
  final String? filterCountry;
  final String? filterState;
  final String? filterUniversityType;
  final String sortBy;  // name, acceptance_rate, tuition, ranking
  final bool sortAscending;

  const UniversitiesState({
    this.universities = const [],
    this.total = 0,
    this.isLoading = false,
    this.error,
    this.searchQuery,
    this.filterCountry,
    this.filterState,
    this.filterUniversityType,
    this.sortBy = 'name',
    this.sortAscending = true,
  });

  UniversitiesState copyWith({
    List<University>? universities,
    int? total,
    bool? isLoading,
    String? error,
    String? searchQuery,
    String? filterCountry,
    String? filterState,
    String? filterUniversityType,
    String? sortBy,
    bool? sortAscending,
  }) {
    return UniversitiesState(
      universities: universities ?? this.universities,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      searchQuery: searchQuery,
      filterCountry: filterCountry,
      filterState: filterState,
      filterUniversityType: filterUniversityType,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}

/// StateNotifier for managing universities
class UniversitiesNotifier extends StateNotifier<UniversitiesState> {
  final UniversitiesApiService _apiService;

  UniversitiesNotifier()
      : _apiService = UniversitiesApiService(),
        super(const UniversitiesState()) {
    fetchUniversities();
  }

  /// Fetch universities with current filters
  Future<void> fetchUniversities({int skip = 0, int limit = 50}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _apiService.getUniversities(
        country: state.filterCountry,
        state: state.filterState,
        universityType: state.filterUniversityType,
        search: state.searchQuery,
        skip: skip,
        limit: limit,
      );

      var universities = result['universities'] as List<University>;

      // Apply client-side sorting
      universities = _sortUniversities(universities);

      state = state.copyWith(
        universities: universities,
        total: result['total'] as int,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch universities: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update search query and refetch
  Future<void> setSearchQuery(String query) async {
    state = state.copyWith(searchQuery: query.isEmpty ? null : query);
    await fetchUniversities();
  }

  /// Set country filter and refetch
  Future<void> setCountryFilter(String? country) async {
    state = state.copyWith(
      filterCountry: country,
      filterState: null,  // Reset state when country changes
    );
    await fetchUniversities();
  }

  /// Set state filter and refetch
  Future<void> setStateFilter(String? stateValue) async {
    state = state.copyWith(filterState: stateValue);
    await fetchUniversities();
  }

  /// Set university type filter and refetch
  Future<void> setUniversityTypeFilter(String? type) async {
    state = state.copyWith(filterUniversityType: type);
    await fetchUniversities();
  }

  /// Set sort criteria and re-sort
  void setSortBy(String sortBy, {bool? ascending}) {
    state = state.copyWith(
      sortBy: sortBy,
      sortAscending: ascending ?? state.sortAscending,
    );
    // Re-sort current universities
    final sorted = _sortUniversities(state.universities);
    state = state.copyWith(universities: sorted);
  }

  /// Toggle sort order
  void toggleSortOrder() {
    state = state.copyWith(sortAscending: !state.sortAscending);
    final sorted = _sortUniversities(state.universities);
    state = state.copyWith(universities: sorted);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = const UniversitiesState();
    await fetchUniversities();
  }

  /// Sort universities based on current criteria
  List<University> _sortUniversities(List<University> universities) {
    final sorted = List<University>.from(universities);

    sorted.sort((a, b) {
      int comparison = 0;

      switch (state.sortBy) {
        case 'name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'acceptance_rate':
          final aRate = a.acceptanceRate ?? double.infinity;
          final bRate = b.acceptanceRate ?? double.infinity;
          comparison = aRate.compareTo(bRate);
          break;
        case 'tuition':
          final aCost = a.totalCost ?? a.tuitionOutState ?? double.infinity;
          final bCost = b.totalCost ?? b.tuitionOutState ?? double.infinity;
          comparison = aCost.compareTo(bCost);
          break;
        case 'ranking':
          final aRank = a.globalRank ?? a.nationalRank ?? 999999;
          final bRank = b.globalRank ?? b.nationalRank ?? 999999;
          comparison = aRank.compareTo(bRank);
          break;
        default:
          comparison = a.name.compareTo(b.name);
      }

      return state.sortAscending ? comparison : -comparison;
    });

    return sorted;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for universities state
final universitiesProvider = StateNotifierProvider<UniversitiesNotifier, UniversitiesState>((ref) {
  return UniversitiesNotifier();
});

/// Provider for universities list
final universitiesListProvider = Provider<List<University>>((ref) {
  final universitiesState = ref.watch(universitiesProvider);
  return universitiesState.universities;
});

/// Provider for checking if universities are loading
final universitiesLoadingProvider = Provider<bool>((ref) {
  final universitiesState = ref.watch(universitiesProvider);
  return universitiesState.isLoading;
});

/// Provider for universities error
final universitiesErrorProvider = Provider<String?>((ref) {
  final universitiesState = ref.watch(universitiesProvider);
  return universitiesState.error;
});
