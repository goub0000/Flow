import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/university_model.dart';
import '../repositories/university_repository.dart';
import '../providers/university_search_provider.dart';

/// University Search Screen with filters and sorting
class UniversitySearchScreen extends ConsumerStatefulWidget {
  const UniversitySearchScreen({super.key});

  @override
  ConsumerState<UniversitySearchScreen> createState() => _UniversitySearchScreenState();
}

class _UniversitySearchScreenState extends ConsumerState<UniversitySearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(universitySearchProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(universitySearchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Universities'),
        actions: [
          if (state.filters.hasFilters)
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                ref.read(universitySearchProvider.notifier).clearFilters();
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by university name...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref.read(universitySearchProvider.notifier).setSearchQuery('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (value) {
                    ref.read(universitySearchProvider.notifier).setSearchQuery(value);
                  },
                ),
                const SizedBox(height: 12),
                // Filter Chips Row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Filters',
                        icon: Icons.tune,
                        isActive: state.filters.hasFilters,
                        onTap: () => _showFilterSheet(context),
                      ),
                      const SizedBox(width: 8),
                      _SortChip(
                        currentSort: state.sortOption,
                        onChanged: (option) {
                          ref.read(universitySearchProvider.notifier).setSortOption(option);
                        },
                      ),
                      if (state.filters.country != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(state.filters.country!),
                          onDeleted: () {
                            ref.read(universitySearchProvider.notifier).setCountryFilter(null);
                          },
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                      ],
                      if (state.filters.universityType != null) ...[
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(state.filters.universityType!),
                          onDeleted: () {
                            ref.read(universitySearchProvider.notifier).setUniversityTypeFilter(null);
                          },
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${state.totalCount} universities found',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (state.isLoading) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ],
            ),
          ),
          // University List
          Expanded(
            child: state.isLoading && state.universities.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.universities.isEmpty
                    ? _ErrorView(
                        error: state.error!,
                        onRetry: () => ref.read(universitySearchProvider.notifier).refresh(),
                      )
                    : state.universities.isEmpty
                        ? _EmptyView(hasFilters: state.filters.hasFilters)
                        : RefreshIndicator(
                            onRefresh: () => ref.read(universitySearchProvider.notifier).refresh(),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.universities.length + (state.isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == state.universities.length) {
                                  return const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                return _UniversityCard(
                                  university: state.universities[index],
                                  onTap: () {
                                    context.push(
                                      '/universities/${state.universities[index].id}',
                                      extra: state.universities[index],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _FilterSheet(),
    );
  }
}

/// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isActive ? theme.colorScheme.onPrimary : null,
      ),
      label: Text(label),
      backgroundColor: isActive ? theme.colorScheme.primary : null,
      labelStyle: TextStyle(
        color: isActive ? theme.colorScheme.onPrimary : null,
      ),
      onPressed: onTap,
    );
  }
}

/// Sort dropdown chip
class _SortChip extends StatelessWidget {
  final UniversitySortOption currentSort;
  final ValueChanged<UniversitySortOption> onChanged;

  const _SortChip({
    required this.currentSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<UniversitySortOption>(
      onSelected: onChanged,
      itemBuilder: (context) => UniversitySortOption.values
          .map((option) => PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    if (option == currentSort)
                      const Icon(Icons.check, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(option.label),
                  ],
                ),
              ))
          .toList(),
      child: Chip(
        avatar: const Icon(Icons.sort, size: 18),
        label: Text(currentSort.label),
      ),
    );
  }
}

/// Filter bottom sheet
class _FilterSheet extends ConsumerStatefulWidget {
  const _FilterSheet();

  @override
  ConsumerState<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<_FilterSheet> {
  String? _selectedCountry;
  String? _selectedType;
  String? _selectedLocationType;
  double? _maxTuition;
  RangeValues? _acceptanceRateRange;

  @override
  void initState() {
    super.initState();
    final state = ref.read(universitySearchProvider);
    _selectedCountry = state.filters.country;
    _selectedType = state.filters.universityType;
    _selectedLocationType = state.filters.locationType;
    _maxTuition = state.filters.maxTuition;
    if (state.filters.minAcceptanceRate != null || state.filters.maxAcceptanceRate != null) {
      _acceptanceRateRange = RangeValues(
        state.filters.minAcceptanceRate ?? 0,
        state.filters.maxAcceptanceRate ?? 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(universitySearchProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedCountry = null;
                          _selectedType = null;
                          _selectedLocationType = null;
                          _maxTuition = null;
                          _acceptanceRateRange = null;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Filter Options
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Country Filter
                    _FilterSection(
                      title: 'Country',
                      child: DropdownButtonFormField<String>(
                        value: _selectedCountry,
                        decoration: InputDecoration(
                          hintText: 'Select country',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Countries')),
                          ...state.availableCountries.map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          ),
                        ],
                        onChanged: (value) => setState(() => _selectedCountry = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // University Type Filter
                    _FilterSection(
                      title: 'University Type',
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          hintText: 'Select type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Types')),
                          ...state.availableTypes.map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          ),
                        ],
                        onChanged: (value) => setState(() => _selectedType = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Location Type Filter
                    _FilterSection(
                      title: 'Location Type',
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocationType,
                        decoration: InputDecoration(
                          hintText: 'Select location type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('All Locations')),
                          ...state.availableLocationTypes.map(
                            (l) => DropdownMenuItem(value: l, child: Text(l)),
                          ),
                        ],
                        onChanged: (value) => setState(() => _selectedLocationType = value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Max Tuition Filter
                    _FilterSection(
                      title: 'Maximum Tuition (USD/year)',
                      child: Column(
                        children: [
                          Slider(
                            value: _maxTuition ?? 100000,
                            min: 0,
                            max: 100000,
                            divisions: 100,
                            label: _maxTuition != null
                                ? '\$${_maxTuition!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                : 'Any',
                            onChanged: (value) {
                              setState(() {
                                _maxTuition = value == 100000 ? null : value;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('\$0'),
                              Text(_maxTuition != null
                                  ? 'Up to \$${_maxTuition!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
                                  : 'No limit'),
                              const Text('\$100,000+'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Acceptance Rate Filter
                    _FilterSection(
                      title: 'Acceptance Rate',
                      child: Column(
                        children: [
                          RangeSlider(
                            values: _acceptanceRateRange ?? const RangeValues(0, 1),
                            min: 0,
                            max: 1,
                            divisions: 100,
                            labels: RangeLabels(
                              '${((_acceptanceRateRange?.start ?? 0) * 100).toInt()}%',
                              '${((_acceptanceRateRange?.end ?? 1) * 100).toInt()}%',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _acceptanceRateRange = values.start == 0 && values.end == 1 ? null : values;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('0%'),
                              Text(_acceptanceRateRange != null
                                  ? '${(_acceptanceRateRange!.start * 100).toInt()}% - ${(_acceptanceRateRange!.end * 100).toInt()}%'
                                  : 'Any rate'),
                              const Text('100%'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final notifier = ref.read(universitySearchProvider.notifier);
                      notifier.setCountryFilter(_selectedCountry);
                      notifier.setUniversityTypeFilter(_selectedType);
                      notifier.setLocationTypeFilter(_selectedLocationType);
                      notifier.setMaxTuitionFilter(_maxTuition);
                      notifier.setAcceptanceRateFilter(
                        _acceptanceRateRange?.start,
                        _acceptanceRateRange?.end,
                      );
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Filter section widget
class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

/// University card widget
class _UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onTap;

  const _UniversityCard({
    required this.university,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Country
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo placeholder
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        university.name.isNotEmpty ? university.name[0].toUpperCase() : 'U',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          university.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                [
                                  university.city,
                                  university.state,
                                  university.country,
                                ].where((s) => s != null && s.isNotEmpty).join(', '),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Quick Stats
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (university.acceptanceRate != null)
                    _StatChip(
                      icon: Icons.percent,
                      label: '${(university.acceptanceRate! * 100).toStringAsFixed(0)}% acceptance',
                    ),
                  if (university.tuitionOutState != null)
                    _StatChip(
                      icon: Icons.payments,
                      label: '\$${university.tuitionOutState!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}/yr',
                    ),
                  if (university.totalStudents != null)
                    _StatChip(
                      icon: Icons.people,
                      label: '${_formatNumber(university.totalStudents!)} students',
                    ),
                  if (university.universityType != null)
                    _StatChip(
                      icon: Icons.school,
                      label: university.universityType!,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

/// Stat chip for university card
class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Empty view when no universities found
class _EmptyView extends StatelessWidget {
  final bool hasFilters;

  const _EmptyView({required this.hasFilters});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No universities match your filters' : 'No universities found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your filters to see more results'
                  : 'Try searching for a university name',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
