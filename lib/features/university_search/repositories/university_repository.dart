import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/university_model.dart';

/// Sentinel value to distinguish between null and not provided
const _sentinel = Object();

/// Filter options for university search
class UniversityFilters {
  final String? searchQuery;
  final String? country;
  final String? universityType;
  final String? locationType;
  final double? maxTuition;
  final double? minAcceptanceRate;
  final double? maxAcceptanceRate;

  const UniversityFilters({
    this.searchQuery,
    this.country,
    this.universityType,
    this.locationType,
    this.maxTuition,
    this.minAcceptanceRate,
    this.maxAcceptanceRate,
  });

  UniversityFilters copyWith({
    Object? searchQuery = _sentinel,
    Object? country = _sentinel,
    Object? universityType = _sentinel,
    Object? locationType = _sentinel,
    Object? maxTuition = _sentinel,
    Object? minAcceptanceRate = _sentinel,
    Object? maxAcceptanceRate = _sentinel,
  }) {
    return UniversityFilters(
      searchQuery: searchQuery == _sentinel ? this.searchQuery : searchQuery as String?,
      country: country == _sentinel ? this.country : country as String?,
      universityType: universityType == _sentinel ? this.universityType : universityType as String?,
      locationType: locationType == _sentinel ? this.locationType : locationType as String?,
      maxTuition: maxTuition == _sentinel ? this.maxTuition : maxTuition as double?,
      minAcceptanceRate: minAcceptanceRate == _sentinel ? this.minAcceptanceRate : minAcceptanceRate as double?,
      maxAcceptanceRate: maxAcceptanceRate == _sentinel ? this.maxAcceptanceRate : maxAcceptanceRate as double?,
    );
  }

  bool get hasFilters =>
      (searchQuery?.isNotEmpty ?? false) ||
      country != null ||
      universityType != null ||
      locationType != null ||
      maxTuition != null ||
      minAcceptanceRate != null ||
      maxAcceptanceRate != null;

  UniversityFilters clear() => const UniversityFilters();
}

/// Sort options for university list
enum UniversitySortOption {
  relevance('Relevance', 'relevance', false),
  nameAsc('Name (A-Z)', 'name', true),
  nameDesc('Name (Z-A)', 'name', false),
  tuitionAsc('Tuition (Low to High)', 'tuition_out_state', true),
  tuitionDesc('Tuition (High to Low)', 'tuition_out_state', false),
  acceptanceAsc('Acceptance Rate (Low to High)', 'acceptance_rate', true),
  acceptanceDesc('Acceptance Rate (High to Low)', 'acceptance_rate', false),
  studentsDesc('Students (Most)', 'total_students', false),
  studentsAsc('Students (Least)', 'total_students', true);

  final String label;
  final String field;
  final bool ascending;

  const UniversitySortOption(this.label, this.field, this.ascending);
}

/// Result of a university search including both data and total count
class UniversitySearchResult {
  final List<University> universities;
  final int totalCount;

  const UniversitySearchResult({
    required this.universities,
    required this.totalCount,
  });
}

/// Repository for university data operations
class UniversityRepository {
  final SupabaseClient _supabase;

  UniversityRepository(this._supabase);

  /// Search universities with filters, relevance ranking, and pagination.
  /// Returns both the list of universities and the total count in one call.
  Future<UniversitySearchResult> searchUniversities({
    UniversityFilters filters = const UniversityFilters(),
    UniversitySortOption sortOption = UniversitySortOption.nameAsc,
    int page = 0,
    int pageSize = 20,
  }) async {
    final params = <String, dynamic>{
      'sort_by': sortOption.field,
      'sort_ascending': sortOption.ascending,
      'result_limit': pageSize,
      'result_offset': page * pageSize,
    };

    if (filters.searchQuery?.isNotEmpty ?? false) {
      params['search_term'] = filters.searchQuery;
    }
    if (filters.country != null) {
      params['filter_country'] = filters.country;
    }
    if (filters.universityType != null) {
      params['filter_university_type'] = filters.universityType;
    }
    if (filters.locationType != null) {
      params['filter_location_type'] = filters.locationType;
    }
    if (filters.maxTuition != null) {
      params['filter_max_tuition'] = filters.maxTuition;
    }
    if (filters.minAcceptanceRate != null) {
      params['filter_min_acceptance_rate'] = filters.minAcceptanceRate;
    }
    if (filters.maxAcceptanceRate != null) {
      params['filter_max_acceptance_rate'] = filters.maxAcceptanceRate;
    }

    final response = await _supabase.rpc('search_universities_ranked', params: params);

    final data = response as Map<String, dynamic>;
    final universitiesJson = data['universities'] as List<dynamic>? ?? [];
    final totalCount = data['total_count'] as int? ?? 0;

    final universities = universitiesJson
        .map((json) => University.fromJson(json as Map<String, dynamic>))
        .toList();

    return UniversitySearchResult(
      universities: universities,
      totalCount: totalCount,
    );
  }

  /// Get a single university by ID
  Future<University?> getUniversityById(int id) async {
    final response = await _supabase
        .from('universities')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return University.fromJson(response);
  }

  /// Get list of unique countries - fetches in batches to overcome 1000 row limit
  Future<List<String>> getCountries() async {
    final countries = <String>{};
    int offset = 0;
    const batchSize = 1000;

    while (true) {
      final response = await _supabase
          .from('universities')
          .select('country')
          .not('country', 'is', null)
          .order('country')
          .range(offset, offset + batchSize - 1);

      final batch = response as List;
      if (batch.isEmpty) break;

      for (final row in batch) {
        if (row['country'] != null) {
          countries.add(row['country'] as String);
        }
      }

      if (batch.length < batchSize) break;
      offset += batchSize;
    }

    return countries.toList()..sort();
  }

  /// Get list of unique university types
  Future<List<String>> getUniversityTypes() async {
    final types = <String>{};
    int offset = 0;
    const batchSize = 1000;

    while (true) {
      final response = await _supabase
          .from('universities')
          .select('university_type')
          .not('university_type', 'is', null)
          .range(offset, offset + batchSize - 1);

      final batch = response as List;
      if (batch.isEmpty) break;

      for (final row in batch) {
        if (row['university_type'] != null) {
          types.add(row['university_type'] as String);
        }
      }

      if (batch.length < batchSize) break;
      offset += batchSize;
    }

    return types.toList()..sort();
  }

  /// Get list of unique location types
  Future<List<String>> getLocationTypes() async {
    final types = <String>{};
    int offset = 0;
    const batchSize = 1000;

    while (true) {
      final response = await _supabase
          .from('universities')
          .select('location_type')
          .not('location_type', 'is', null)
          .range(offset, offset + batchSize - 1);

      final batch = response as List;
      if (batch.isEmpty) break;

      for (final row in batch) {
        if (row['location_type'] != null) {
          types.add(row['location_type'] as String);
        }
      }

      if (batch.length < batchSize) break;
      offset += batchSize;
    }

    return types.toList()..sort();
  }
}
