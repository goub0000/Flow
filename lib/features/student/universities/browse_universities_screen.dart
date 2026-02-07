// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/university_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/custom_card.dart';
import '../providers/universities_provider.dart';

class BrowseUniversitiesScreen extends ConsumerStatefulWidget {
  final bool selectionMode;

  const BrowseUniversitiesScreen({super.key, this.selectionMode = false});

  @override
  ConsumerState<BrowseUniversitiesScreen> createState() => _BrowseUniversitiesScreenState();
}

class _BrowseUniversitiesScreenState extends ConsumerState<BrowseUniversitiesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final universitiesState = ref.watch(universitiesProvider);
    final isLoading = universitiesState.isLoading;
    final error = universitiesState.error;
    final universities = universitiesState.universities;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(widget.selectionMode ? 'Select University' : 'Browse Universities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: () {
              _searchController.clear();
              ref.read(universitiesProvider.notifier).clearFilters();
            },
            tooltip: 'Clear filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name, city, or state...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(universitiesProvider.notifier).setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(universitiesProvider.notifier).setSearchQuery(value);
                  },
                ),
                const SizedBox(height: 12),
                // Sort dropdown
                Row(
                  children: [
                    const Text('Sort by: ', style: TextStyle(fontWeight: FontWeight.w500)),
                    Expanded(
                      child: DropdownButton<String>(
                        value: universitiesState.sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
                          DropdownMenuItem(value: 'acceptance_rate', child: Text('Acceptance Rate')),
                          DropdownMenuItem(value: 'tuition', child: Text('Tuition Cost')),
                          DropdownMenuItem(value: 'ranking', child: Text('Ranking')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(universitiesProvider.notifier).setSortBy(value);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        universitiesState.sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      onPressed: () {
                        ref.read(universitiesProvider.notifier).toggleSortOrder();
                      },
                      tooltip: universitiesState.sortAscending ? 'Ascending' : 'Descending',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results count
          if (!isLoading)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${universitiesState.total} universities found',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),

          // Universities list
          Expanded(
            child: _buildUniversitiesList(isLoading, error, universities),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversitiesList(bool isLoading, String? error, List<University> universities) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(error, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(universitiesProvider.notifier).fetchUniversities();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (universities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No universities found',
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: universities.length,
      itemBuilder: (context, index) {
        final university = universities[index];
        return _UniversityCard(
          university: university,
          onTap: widget.selectionMode
              ? () => context.pop(university)
              : () {
                  // Navigate to university details (can be implemented later)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Selected: ${university.name}')),
                  );
                },
        );
      },
    );
  }
}

class _UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;

  const _UniversityCard({
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: CustomCard(
        padding: EdgeInsets.zero,
        child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // University logo or placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: university.logoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          university.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.school,
                            size: 32,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.school,
                        size: 32,
                        color: AppColors.primary,
                      ),
              ),
              const SizedBox(width: 16),
              // University info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            university.location,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (university.formattedAcceptanceRate != null)
                          _InfoChip(
                            icon: Icons.trending_up,
                            label: university.formattedAcceptanceRate!,
                          ),
                        if (university.formattedTuition != null)
                          _InfoChip(
                            icon: Icons.attach_money,
                            label: university.formattedTuition!,
                          ),
                        if (university.universityType != null)
                          _InfoChip(
                            icon: Icons.business,
                            label: university.universityType!,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
