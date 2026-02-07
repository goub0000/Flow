// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/institution_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../shared/widgets/custom_card.dart';
import '../providers/institutions_provider.dart';

/// Screen for browsing registered institutions
/// This is DIFFERENT from BrowseUniversitiesScreen which shows recommendation data
/// This screen shows ONLY registered institution accounts that can accept applications
class BrowseInstitutionsScreen extends ConsumerStatefulWidget {
  final bool selectionMode;

  const BrowseInstitutionsScreen({super.key, this.selectionMode = false});

  @override
  ConsumerState<BrowseInstitutionsScreen> createState() =>
      _BrowseInstitutionsScreenState();
}

class _BrowseInstitutionsScreenState
    extends ConsumerState<BrowseInstitutionsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when reaching 80% of scroll extent
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      ref.read(institutionsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final institutionsState = ref.watch(institutionsProvider);
    final isLoading = institutionsState.isLoading;
    final error = institutionsState.error;
    final institutions = institutionsState.institutions;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: Text(widget.selectionMode
            ? 'Select Institution'
            : 'Browse Institutions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: () {
              _searchController.clear();
              ref.read(institutionsProvider.notifier).clearFilters();
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
                    hintText: 'Search by institution name or email...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(institutionsProvider.notifier)
                                  .setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    ref
                        .read(institutionsProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
                const SizedBox(height: 12),
                // Sort and filter row
                Row(
                  children: [
                    const Text('Sort by: ',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Expanded(
                      child: DropdownButton<String>(
                        value: institutionsState.sortBy,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                              value: 'name', child: Text('Name (A-Z)')),
                          DropdownMenuItem(
                              value: 'offerings', child: Text('Total Offerings')),
                          DropdownMenuItem(
                              value: 'programs', child: Text('Programs')),
                          DropdownMenuItem(
                              value: 'courses', child: Text('Courses')),
                          DropdownMenuItem(
                              value: 'created_at', child: Text('Newest')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref
                                .read(institutionsProvider.notifier)
                                .setSortBy(value);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        institutionsState.sortAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      onPressed: () {
                        ref
                            .read(institutionsProvider.notifier)
                            .toggleSortOrder();
                      },
                      tooltip: institutionsState.sortAscending
                          ? 'Ascending'
                          : 'Descending',
                    ),
                  ],
                ),
                // Verified filter
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show verified only'),
                  value: institutionsState.filterVerified ?? false,
                  onChanged: (value) {
                    ref
                        .read(institutionsProvider.notifier)
                        .setVerifiedFilter(value == true ? true : null);
                  },
                ),
              ],
            ),
          ),

          // Results count
          if (!isLoading || institutions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${institutionsState.total} registered institution${institutionsState.total == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  if (widget.selectionMode)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Tap to select',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Institutions list
          Expanded(
            child: _buildInstitutionsList(
                isLoading, error, institutions, institutionsState.hasMorePages),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionsList(bool isLoading, String? error,
      List<Institution> institutions, bool hasMorePages) {
    if (isLoading && institutions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null && institutions.isEmpty) {
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
                ref.read(institutionsProvider.notifier).fetchInstitutions();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (institutions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined,
                size: 64,
                color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              'No institutions found',
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

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(institutionsProvider.notifier).refresh();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: institutions.length + (hasMorePages ? 1 : 0),
        itemBuilder: (context, index) {
          // Show loading indicator at the end if more pages available
          if (index == institutions.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final institution = institutions[index];
          return _InstitutionCard(
            institution: institution,
            onTap: widget.selectionMode
                ? () => context.pop(institution)
                : () {
                    // Navigate to institution details (can be implemented later)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected: ${institution.name}')),
                    );
                  },
          );
        },
      ),
    );
  }
}

class _InstitutionCard extends StatelessWidget {
  final Institution institution;
  final VoidCallback onTap;

  const _InstitutionCard({
    required this.institution,
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
                // Institution logo or placeholder
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: institution.photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            institution.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.business,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.business,
                          size: 32,
                          color: AppColors.primary,
                        ),
                ),
                const SizedBox(width: 16),
                // Institution info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              institution.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (institution.isVerified)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified,
                                      size: 14, color: AppColors.success),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              institution.email,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
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
                          if (institution.programsCount > 0)
                            _InfoChip(
                              icon: Icons.school,
                              label: institution.formattedProgramsCount,
                              color: AppColors.primary,
                            ),
                          if (institution.coursesCount > 0)
                            _InfoChip(
                              icon: Icons.book,
                              label: institution.formattedCoursesCount,
                              color: AppColors.secondary,
                            ),
                          if (institution.totalOfferings == 0)
                            _InfoChip(
                              icon: Icons.info_outline,
                              label: 'No offerings yet',
                              color: AppColors.textSecondary,
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
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
