import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../application/providers/find_your_path_provider.dart';
import '../../domain/models/recommendation.dart';

/// Results screen showing university recommendations
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  String? _filterCategory;

  @override
  void initState() {
    super.initState();
    // Delay loading until after build completes
    Future.microtask(() => _loadRecommendations());
  }

  void _loadRecommendations() {
    // Only load if we don't already have recommendations
    final currentState = ref.read(recommendationsProvider);
    if (currentState.recommendations != null) {
      // Already have recommendations, no need to load
      return;
    }

    final authState = ref.read(authProvider);
    final userId = authState.user?.id;
    if (userId != null) {
      ref.read(recommendationsProvider.notifier).loadRecommendations(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recsState = ref.watch(recommendationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Your Recommendations'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRecommendations,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: recsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : recsState.error != null
              ? _buildErrorState(recsState.error!)
              : recsState.recommendations == null
                  ? _buildEmptyState()
                  : _buildResultsContent(recsState.recommendations!),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading recommendations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadRecommendations,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No recommendations yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete the questionnaire to get personalized recommendations',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/find-your-path/questionnaire');
            },
            icon: const Icon(Icons.edit_note),
            label: const Text('Start Questionnaire'),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsContent(RecommendationListResponse response) {
    // Apply filter
    var recommendations = response.recommendations;
    if (_filterCategory != null) {
      recommendations = recommendations
          .where((r) => r.category == _filterCategory)
          .toList();
    }

    return Column(
      children: [
        // Summary Stats
        _buildSummaryStats(response),

        // Filter Chips
        _buildFilterChips(response),

        // Results List
        Expanded(
          child: recommendations.isEmpty
              ? Center(
                  child: Text(
                    'No universities match the selected filter',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    return _buildUniversityCard(
                      recommendations[index],
                      index,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(RecommendationListResponse response) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const Text(
            'We found your perfect matches!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatCard(
                'Total',
                response.totalCount.toString(),
                AppColors.primary,
                Icons.school,
              ),
              _buildStatCard(
                'Safety',
                response.safetyCount.toString(),
                AppColors.success,
                Icons.check_circle,
              ),
              _buildStatCard(
                'Match',
                response.matchCount.toString(),
                AppColors.info,
                Icons.favorite,
              ),
              _buildStatCard(
                'Reach',
                response.reachCount.toString(),
                AppColors.warning,
                Icons.star,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(RecommendationListResponse response) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            FilterChip(
              label: Text('All (${response.totalCount})'),
              selected: _filterCategory == null,
              onSelected: (selected) {
                setState(() {
                  _filterCategory = null;
                });
              },
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: Text('Safety (${response.safetyCount})'),
              selected: _filterCategory == 'Safety',
              onSelected: (selected) {
                setState(() {
                  _filterCategory = selected ? 'Safety' : null;
                });
              },
              selectedColor: AppColors.success.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: Text('Match (${response.matchCount})'),
              selected: _filterCategory == 'Match',
              onSelected: (selected) {
                setState(() {
                  _filterCategory = selected ? 'Match' : null;
                });
              },
              selectedColor: AppColors.info.withValues(alpha: 0.2),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: Text('Reach (${response.reachCount})'),
              selected: _filterCategory == 'Reach',
              onSelected: (selected) {
                setState(() {
                  _filterCategory = selected ? 'Reach' : null;
                });
              },
              selectedColor: AppColors.warning.withValues(alpha: 0.2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversityCard(Recommendation rec, int index) {
    final university = rec.university;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: university != null
            ? () {
                context.push('/find-your-path/university/${university.id}');
              }
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // University Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.school,
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // University Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university?.name ?? 'Loading university details...',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          university?.location ?? 'Location not available',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildCategoryChip(rec.category),
                            const SizedBox(width: 8),
                            _buildMatchScore(rec.matchScore),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Favorite Button
                  IconButton(
                    icon: Icon(
                      rec.favorited ? Icons.favorite : Icons.favorite_border,
                      color: rec.favorited ? AppColors.error : null,
                    ),
                    onPressed: () {
                      ref
                          .read(recommendationsProvider.notifier)
                          .toggleFavorite(rec.id, index);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Divider(color: AppColors.border),
              const SizedBox(height: 16),

              // University Stats
              if (university != null)
                Wrap(
                  spacing: 24,
                  runSpacing: 8,
                  children: [
                    if (university.acceptanceRate != null)
                      _buildStat(
                        Icons.percent,
                        'Acceptance',
                        university.formattedAcceptanceRate!,
                      ),
                    if (university.tuitionOutState != null)
                      _buildStat(
                        Icons.attach_money,
                        'Tuition',
                        university.formattedTuition!,
                      ),
                    if (university.totalStudents != null)
                      _buildStat(
                        Icons.people,
                        'Students',
                        '${(university.totalStudents! / 1000).toStringAsFixed(1)}k',
                      ),
                    if (university.nationalRank != null)
                      _buildStat(
                        Icons.emoji_events,
                        'Rank',
                        '#${university.nationalRank}',
                      ),
                  ],
                ),

              // Strengths
              if (rec.strengths.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Why it\'s a good match:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...rec.strengths.take(3).map((strength) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            strength,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],

              // View Details Button
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: university != null
                      ? () {
                          context.push('/find-your-path/university/${university.id}');
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    Color color;
    switch (category) {
      case 'Safety':
        color = AppColors.success;
        break;
      case 'Reach':
        color = AppColors.warning;
        break;
      default:
        color = AppColors.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMatchScore(double score) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            '${score.toStringAsFixed(0)}% Match',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
