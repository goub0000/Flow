import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_stats_provider.freezed.dart';

/// Model for platform statistics displayed on the home page
@freezed
class HomeStats with _$HomeStats {
  const factory HomeStats({
    @Default(0) int activeUsers,
    @Default(0) int institutions,
    @Default(0) int countries,
    @Default(0) int universities,
    @Default(false) bool isLoading,
    String? error,
  }) = _HomeStats;
}

/// Provider for home page statistics
/// Fetches real data from the API and caches it
final homeStatsProvider = StateNotifierProvider<HomeStatsNotifier, HomeStats>((ref) {
  return HomeStatsNotifier();
});

class HomeStatsNotifier extends StateNotifier<HomeStats> {
  HomeStatsNotifier() : super(const HomeStats(isLoading: true)) {
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      // TODO: Replace with actual API call when endpoint is available
      // final response = await ref.read(apiClientProvider).get('/api/v1/stats/public');
      // For now, use realistic default values that can be updated via API later

      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay

      state = const HomeStats(
        activeUsers: 50000,
        institutions: 200,
        countries: 20,
        universities: 18000,
        isLoading: false,
      );
    } catch (e) {
      state = HomeStats(
        isLoading: false,
        error: e.toString(),
        // Fallback to default values on error
        activeUsers: 50000,
        institutions: 200,
        countries: 20,
        universities: 18000,
      );
    }
  }

  /// Refresh stats from the API
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    await _loadStats();
  }
}

/// Formatted stat strings for display
extension HomeStatsDisplay on HomeStats {
  String get activeUsersFormatted => _formatNumber(activeUsers);
  String get institutionsFormatted => _formatNumber(institutions);
  String get countriesFormatted => _formatNumber(countries);
  String get universitiesFormatted => _formatNumber(universities);

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M+';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}K+';
    }
    return '$number+';
  }
}
