import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/university_model.dart';
import '../../../core/providers/service_providers.dart';
import '../repositories/university_repository.dart';

/// Provider for the university repository
final universityRepositoryProvider = Provider<UniversityRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return UniversityRepository(supabase);
});

/// State class for university search
class UniversitySearchState {
  final List<University> universities;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final UniversityFilters filters;
  final UniversitySortOption sortOption;
  final int currentPage;
  final bool hasMore;
  final int totalCount;

  // Filter options loaded from database
  final List<String> availableCountries;
  final List<String> availableTypes;
  final List<String> availableLocationTypes;

  const UniversitySearchState({
    this.universities = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.filters = const UniversityFilters(),
    this.sortOption = UniversitySortOption.nameAsc,
    this.currentPage = 0,
    this.hasMore = true,
    this.totalCount = 0,
    this.availableCountries = const [],
    this.availableTypes = const [],
    this.availableLocationTypes = const [],
  });

  UniversitySearchState copyWith({
    List<University>? universities,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    UniversityFilters? filters,
    UniversitySortOption? sortOption,
    int? currentPage,
    bool? hasMore,
    int? totalCount,
    List<String>? availableCountries,
    List<String>? availableTypes,
    List<String>? availableLocationTypes,
  }) {
    return UniversitySearchState(
      universities: universities ?? this.universities,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      filters: filters ?? this.filters,
      sortOption: sortOption ?? this.sortOption,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      availableCountries: availableCountries ?? this.availableCountries,
      availableTypes: availableTypes ?? this.availableTypes,
      availableLocationTypes: availableLocationTypes ?? this.availableLocationTypes,
    );
  }
}

/// StateNotifier for university search
class UniversitySearchNotifier extends StateNotifier<UniversitySearchState> {
  final UniversityRepository _repository;
  static const int _pageSize = 20;

  UniversitySearchNotifier(this._repository) : super(const UniversitySearchState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.wait([
      loadFilterOptions(),
      searchUniversities(),
    ]);
  }

  /// Load filter options from database
  Future<void> loadFilterOptions() async {
    try {
      final results = await Future.wait([
        _repository.getCountries(),
        _repository.getUniversityTypes(),
        _repository.getLocationTypes(),
      ]);

      state = state.copyWith(
        availableCountries: results[0],
        availableTypes: results[1],
        availableLocationTypes: results[2],
      );
    } catch (e) {
      // Silently fail, filters will just be empty
    }
  }

  /// Search universities with current filters
  Future<void> searchUniversities({bool resetPage = true}) async {
    if (resetPage) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 0,
      );
    }

    try {
      final page = resetPage ? 0 : state.currentPage;

      final result = await _repository.searchUniversities(
        filters: state.filters,
        sortOption: state.sortOption,
        page: page,
        pageSize: _pageSize,
      );

      state = state.copyWith(
        universities: resetPage
            ? result.universities
            : [...state.universities, ...result.universities],
        isLoading: false,
        isLoadingMore: false,
        hasMore: result.universities.length >= _pageSize,
        currentPage: page,
        totalCount: result.totalCount,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to search universities: ${e.toString()}',
        isLoading: false,
        isLoadingMore: false,
      );
    }
  }

  /// Load more universities (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(
      isLoadingMore: true,
      currentPage: state.currentPage + 1,
    );

    await searchUniversities(resetPage: false);
  }

  /// Update search query
  Future<void> setSearchQuery(String query) async {
    final hasQuery = query.isNotEmpty;
    final currentSort = state.sortOption;

    // Auto-switch to relevance sort when searching, back to nameAsc when cleared
    UniversitySortOption newSort = currentSort;
    if (hasQuery && currentSort == UniversitySortOption.nameAsc) {
      newSort = UniversitySortOption.relevance;
    } else if (!hasQuery && currentSort == UniversitySortOption.relevance) {
      newSort = UniversitySortOption.nameAsc;
    }

    state = state.copyWith(
      filters: state.filters.copyWith(searchQuery: hasQuery ? query : null),
      sortOption: newSort,
    );
    await searchUniversities();
  }

  /// Set country filter
  Future<void> setCountryFilter(String? country) async {
    state = state.copyWith(
      filters: state.filters.copyWith(country: country),
    );
    await searchUniversities();
  }

  /// Set university type filter
  Future<void> setUniversityTypeFilter(String? type) async {
    state = state.copyWith(
      filters: state.filters.copyWith(universityType: type),
    );
    await searchUniversities();
  }

  /// Set location type filter
  Future<void> setLocationTypeFilter(String? locationType) async {
    state = state.copyWith(
      filters: state.filters.copyWith(locationType: locationType),
    );
    await searchUniversities();
  }

  /// Set max tuition filter
  Future<void> setMaxTuitionFilter(double? maxTuition) async {
    state = state.copyWith(
      filters: state.filters.copyWith(maxTuition: maxTuition),
    );
    await searchUniversities();
  }

  /// Set acceptance rate range
  Future<void> setAcceptanceRateFilter(double? min, double? max) async {
    state = state.copyWith(
      filters: state.filters.copyWith(
        minAcceptanceRate: min,
        maxAcceptanceRate: max,
      ),
    );
    await searchUniversities();
  }

  /// Set sort option
  Future<void> setSortOption(UniversitySortOption option) async {
    state = state.copyWith(sortOption: option);
    await searchUniversities();
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    state = state.copyWith(
      filters: const UniversityFilters(),
      sortOption: UniversitySortOption.nameAsc,
    );
    await searchUniversities();
  }

  /// Refresh the list
  Future<void> refresh() async {
    await searchUniversities();
  }
}

/// Provider for university search state
final universitySearchProvider = StateNotifierProvider<UniversitySearchNotifier, UniversitySearchState>((ref) {
  final repository = ref.watch(universityRepositoryProvider);
  return UniversitySearchNotifier(repository);
});

/// Provider to get a single university by ID
final universityByIdProvider = FutureProvider.family<University?, int>((ref, id) async {
  final repository = ref.watch(universityRepositoryProvider);
  return repository.getUniversityById(id);
});

/// Derived providers for convenience
final universityListProvider = Provider<List<University>>((ref) {
  return ref.watch(universitySearchProvider).universities;
});

final universitySearchLoadingProvider = Provider<bool>((ref) {
  return ref.watch(universitySearchProvider).isLoading;
});

final universitySearchErrorProvider = Provider<String?>((ref) {
  return ref.watch(universitySearchProvider).error;
});

final universityTotalCountProvider = Provider<int>((ref) {
  return ref.watch(universitySearchProvider).totalCount;
});
