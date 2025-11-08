import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Advanced Filter Widget
///
/// Provides comprehensive filtering options for courses, programs, and content:
/// - Multi-select categories
/// - Price range slider
/// - Duration filter
/// - Level/difficulty filter
/// - Location/country filter
/// - Institution type filter
/// - Rating filter
///
/// Backend Integration TODO:
/// ```dart
/// // Apply filters to API request
/// import 'package:dio/dio.dart';
///
/// class FilterService {
///   final Dio _dio;
///
///   Future<List<Course>> getFilteredCourses(FilterOptions filters) async {
///     final queryParams = {
///       'categories': filters.categories.join(','),
///       'minPrice': filters.priceRange.start,
///       'maxPrice': filters.priceRange.end,
///       'levels': filters.levels.join(','),
///       'countries': filters.countries.join(','),
///       'minRating': filters.minRating,
///       'minDuration': filters.durationRange?.start,
///       'maxDuration': filters.durationRange?.end,
///     };
///
///     // Remove null/empty values
///     queryParams.removeWhere((key, value) =>
///       value == null || (value is String && value.isEmpty) ||
///       (value is List && value.isEmpty)
///     );
///
///     final response = await _dio.get('/api/courses', queryParameters: queryParams);
///     return (response.data['courses'] as List)
///         .map((json) => Course.fromJson(json))
///         .toList();
///   }
/// }
/// ```

/// Filter Options Model
class FilterOptions {
  List<String> categories;
  RangeValues priceRange;
  List<String> levels;
  List<String> countries;
  double? minRating;
  RangeValues? durationRange; // in weeks
  List<String> institutionTypes;
  bool onlineOnly;
  bool hasFinancialAid;

  FilterOptions({
    this.categories = const [],
    this.priceRange = const RangeValues(0, 10000),
    this.levels = const [],
    this.countries = const [],
    this.minRating,
    this.durationRange,
    this.institutionTypes = const [],
    this.onlineOnly = false,
    this.hasFinancialAid = false,
  });

  FilterOptions copyWith({
    List<String>? categories,
    RangeValues? priceRange,
    List<String>? levels,
    List<String>? countries,
    double? minRating,
    RangeValues? durationRange,
    List<String>? institutionTypes,
    bool? onlineOnly,
    bool? hasFinancialAid,
  }) {
    return FilterOptions(
      categories: categories ?? this.categories,
      priceRange: priceRange ?? this.priceRange,
      levels: levels ?? this.levels,
      countries: countries ?? this.countries,
      minRating: minRating ?? this.minRating,
      durationRange: durationRange ?? this.durationRange,
      institutionTypes: institutionTypes ?? this.institutionTypes,
      onlineOnly: onlineOnly ?? this.onlineOnly,
      hasFinancialAid: hasFinancialAid ?? this.hasFinancialAid,
    );
  }

  int get activeFilterCount {
    int count = 0;
    if (categories.isNotEmpty) count++;
    if (priceRange.start > 0 || priceRange.end < 10000) count++;
    if (levels.isNotEmpty) count++;
    if (countries.isNotEmpty) count++;
    if (minRating != null) count++;
    if (durationRange != null) count++;
    if (institutionTypes.isNotEmpty) count++;
    if (onlineOnly) count++;
    if (hasFinancialAid) count++;
    return count;
  }

  void reset() {
    categories.clear();
    priceRange = const RangeValues(0, 10000);
    levels.clear();
    countries.clear();
    minRating = null;
    durationRange = null;
    institutionTypes.clear();
    onlineOnly = false;
    hasFinancialAid = false;
  }
}

/// Filter Button with Badge
class FilterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int activeFilters;

  const FilterButton({
    super.key,
    required this.onPressed,
    this.activeFilters = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: onPressed,
        ),
        if (activeFilters > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$activeFilters',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// Filter Bottom Sheet
class FilterBottomSheet extends StatefulWidget {
  final FilterOptions initialFilters;
  final Function(FilterOptions) onApply;
  final FilterType filterType;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onApply,
    this.filterType = FilterType.courses,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late FilterOptions _filters;

  // Available options (would come from backend in production)
  final List<String> _availableCategories = [
    'Computer Science',
    'Business',
    'Engineering',
    'Medicine',
    'Law',
    'Arts & Humanities',
    'Social Sciences',
    'Natural Sciences',
  ];

  final List<String> _availableLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  final List<String> _availableCountries = [
    'Kenya',
    'Nigeria',
    'South Africa',
    'Ghana',
    'Ethiopia',
    'Tanzania',
    'Uganda',
    'Rwanda',
  ];

  final List<String> _availableInstitutionTypes = [
    'University',
    'College',
    'Technical School',
    'Online Platform',
  ];

  @override
  void initState() {
    super.initState();
    _filters = FilterOptions(
      categories: List.from(widget.initialFilters.categories),
      priceRange: widget.initialFilters.priceRange,
      levels: List.from(widget.initialFilters.levels),
      countries: List.from(widget.initialFilters.countries),
      minRating: widget.initialFilters.minRating,
      durationRange: widget.initialFilters.durationRange,
      institutionTypes: List.from(widget.initialFilters.institutionTypes),
      onlineOnly: widget.initialFilters.onlineOnly,
      hasFinancialAid: widget.initialFilters.hasFinancialAid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
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
                          _filters.reset();
                        });
                      },
                      child: const Text('Reset All'),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Filters Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Categories
                    _buildSectionTitle('Categories'),
                    _buildChipList(
                      options: _availableCategories,
                      selected: _filters.categories,
                      onChanged: (selected) {
                        setState(() {
                          _filters.categories = selected;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Price Range
                    _buildSectionTitle('Price Range (USD)'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          RangeSlider(
                            values: _filters.priceRange,
                            min: 0,
                            max: 10000,
                            divisions: 100,
                            labels: RangeLabels(
                              '\$${_filters.priceRange.start.round()}',
                              '\$${_filters.priceRange.end.round()}',
                            ),
                            onChanged: (values) {
                              setState(() {
                                _filters.priceRange = values;
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${_filters.priceRange.start.round()}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                '\$${_filters.priceRange.end.round()}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Level/Difficulty
                    _buildSectionTitle('Level'),
                    _buildChipList(
                      options: _availableLevels,
                      selected: _filters.levels,
                      onChanged: (selected) {
                        setState(() {
                          _filters.levels = selected;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Country
                    if (widget.filterType == FilterType.institutions ||
                        widget.filterType == FilterType.programs) ...[
                      _buildSectionTitle('Country'),
                      _buildChipList(
                        options: _availableCountries,
                        selected: _filters.countries,
                        onChanged: (selected) {
                          setState(() {
                            _filters.countries = selected;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Institution Type
                    if (widget.filterType == FilterType.programs) ...[
                      _buildSectionTitle('Institution Type'),
                      _buildChipList(
                        options: _availableInstitutionTypes,
                        selected: _filters.institutionTypes,
                        onChanged: (selected) {
                          setState(() {
                            _filters.institutionTypes = selected;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Rating
                    _buildSectionTitle('Minimum Rating'),
                    _buildRatingFilter(),
                    const SizedBox(height: 24),

                    // Duration (for courses)
                    if (widget.filterType == FilterType.courses) ...[
                      _buildSectionTitle('Duration (weeks)'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            RangeSlider(
                              values: _filters.durationRange ??
                                  const RangeValues(1, 52),
                              min: 1,
                              max: 52,
                              divisions: 51,
                              labels: RangeLabels(
                                '${(_filters.durationRange?.start ?? 1).round()} weeks',
                                '${(_filters.durationRange?.end ?? 52).round()} weeks',
                              ),
                              onChanged: (values) {
                                setState(() {
                                  _filters.durationRange = values;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(_filters.durationRange?.start ?? 1).round()} weeks',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                Text(
                                  '${(_filters.durationRange?.end ?? 52).round()} weeks',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Special Options
                    _buildSectionTitle('Special Options'),
                    CheckboxListTile(
                      title: const Text('Online Only'),
                      subtitle: const Text('Show only online courses/programs'),
                      value: _filters.onlineOnly,
                      onChanged: (value) {
                        setState(() {
                          _filters.onlineOnly = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Financial Aid Available'),
                      subtitle:
                          const Text('Show only items with financial aid'),
                      value: _filters.hasFinancialAid,
                      onChanged: (value) {
                        setState(() {
                          _filters.hasFinancialAid = value ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 80), // Padding for apply button
                  ],
                ),
              ),

              // Apply Button
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_filters);
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Apply Filters'),
                        if (_filters.activeFilterCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_filters.activeFilterCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildChipList({
    required List<String> options,
    required List<String> selected,
    required Function(List<String>) onChanged,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (value) {
            final newSelected = List<String>.from(selected);
            if (value) {
              newSelected.add(option);
            } else {
              newSelected.remove(option);
            }
            onChanged(newSelected);
          },
          selectedColor: AppColors.primary.withOpacity(0.2),
          checkmarkColor: AppColors.primary,
        );
      }).toList(),
    );
  }

  Widget _buildRatingFilter() {
    return Wrap(
      spacing: 8,
      children: [4.5, 4.0, 3.5, 3.0].map((rating) {
        final isSelected = _filters.minRating == rating;
        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: AppColors.warning),
              const SizedBox(width: 4),
              Text('$rating+'),
            ],
          ),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _filters.minRating = selected ? rating : null;
            });
          },
          selectedColor: AppColors.primary.withOpacity(0.2),
        );
      }).toList(),
    );
  }
}

/// Show Filter Bottom Sheet
Future<void> showFilterBottomSheet({
  required BuildContext context,
  required FilterOptions currentFilters,
  required Function(FilterOptions) onApply,
  FilterType filterType = FilterType.courses,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(
      initialFilters: currentFilters,
      onApply: onApply,
      filterType: filterType,
    ),
  );
}

/// Active Filters Chips (display selected filters)
class ActiveFiltersChips extends StatelessWidget {
  final FilterOptions filters;
  final Function(FilterOptions) onFilterRemoved;

  const ActiveFiltersChips({
    super.key,
    required this.filters,
    required this.onFilterRemoved,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    // Add category chips
    for (final category in filters.categories) {
      chips.add(_buildChip(
        label: category,
        onDeleted: () {
          final newFilters = filters.copyWith();
          newFilters.categories.remove(category);
          onFilterRemoved(newFilters);
        },
      ));
    }

    // Add level chips
    for (final level in filters.levels) {
      chips.add(_buildChip(
        label: level,
        onDeleted: () {
          final newFilters = filters.copyWith();
          newFilters.levels.remove(level);
          onFilterRemoved(newFilters);
        },
      ));
    }

    // Add country chips
    for (final country in filters.countries) {
      chips.add(_buildChip(
        label: country,
        onDeleted: () {
          final newFilters = filters.copyWith();
          newFilters.countries.remove(country);
          onFilterRemoved(newFilters);
        },
      ));
    }

    // Add rating chip
    if (filters.minRating != null) {
      chips.add(_buildChip(
        label: '${filters.minRating}+ stars',
        onDeleted: () {
          onFilterRemoved(filters.copyWith(minRating: null));
        },
      ));
    }

    // Add price range chip
    if (filters.priceRange.start > 0 || filters.priceRange.end < 10000) {
      chips.add(_buildChip(
        label:
            '\$${filters.priceRange.start.round()}-\$${filters.priceRange.end.round()}',
        onDeleted: () {
          onFilterRemoved(
            filters.copyWith(priceRange: const RangeValues(0, 10000)),
          );
        },
      ));
    }

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          ...chips.map((chip) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: chip,
              )),
          TextButton.icon(
            onPressed: () {
              final newFilters = filters.copyWith();
              newFilters.reset();
              onFilterRemoved(newFilters);
            },
            icon: const Icon(Icons.clear_all, size: 16),
            label: const Text('Clear all'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Chip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: const TextStyle(
        color: AppColors.primary,
        fontSize: 12,
      ),
    );
  }
}

/// Filter Type Enum
enum FilterType {
  courses,
  programs,
  institutions,
}
