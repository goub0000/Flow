import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Sort Options Widget
///
/// Provides sorting functionality for lists of courses, programs, and content:
/// - Sort by relevance
/// - Sort by date (newest/oldest)
/// - Sort by price (low to high, high to low)
/// - Sort by rating (highest first)
/// - Sort by popularity
/// - Sort by name (A-Z, Z-A)
///
/// Backend Integration TODO:
/// ```dart
/// // Apply sorting to API request
/// import 'package:dio/dio.dart';
///
/// class SortService {
///   final Dio _dio;
///
///   Future<List<Course>> getSortedCourses(SortOption sortBy) async {
///     final queryParams = {
///       'sortBy': sortBy.field,
///       'sortOrder': sortBy.order.name, // 'asc' or 'desc'
///     };
///
///     final response = await _dio.get('/api/courses', queryParameters: queryParams);
///     return (response.data['courses'] as List)
///         .map((json) => Course.fromJson(json))
///         .toList();
///   }
/// }
///
/// // Example with Algolia
/// import 'package:algolia/algolia.dart';
///
/// AlgoliaQuery query = algolia.instance
///     .index('courses')
///     .query(searchQuery)
///     .setAroundLatLng('${lat},${lng}') // Geo sort
///     .setAroundRadius(5000);
///
/// // Sort by attribute
/// switch (sortBy) {
///   case SortOption.priceAsc:
///     query = query.setFacetFilter('price:asc');
///     break;
///   case SortOption.rating:
///     query = query.setFacetFilter('rating:desc');
///     break;
/// }
/// ```

/// Sort Option Model
class SortOption {
  final String id;
  final String label;
  final String field;
  final SortOrder order;
  final IconData icon;

  const SortOption({
    required this.id,
    required this.label,
    required this.field,
    required this.order,
    required this.icon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SortOption && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Sort Order
enum SortOrder {
  ascending,
  descending,
}

/// Predefined Sort Options
class SortOptions {
  // General
  static const relevance = SortOption(
    id: 'relevance',
    label: 'Relevance',
    field: 'relevance',
    order: SortOrder.descending,
    icon: Icons.trending_up,
  );

  static const popularity = SortOption(
    id: 'popularity',
    label: 'Most Popular',
    field: 'enrollmentCount',
    order: SortOrder.descending,
    icon: Icons.people,
  );

  static const rating = SortOption(
    id: 'rating',
    label: 'Highest Rated',
    field: 'rating',
    order: SortOrder.descending,
    icon: Icons.star,
  );

  // Date
  static const newest = SortOption(
    id: 'newest',
    label: 'Newest First',
    field: 'createdAt',
    order: SortOrder.descending,
    icon: Icons.access_time,
  );

  static const oldest = SortOption(
    id: 'oldest',
    label: 'Oldest First',
    field: 'createdAt',
    order: SortOrder.ascending,
    icon: Icons.history,
  );

  // Price
  static const priceLowToHigh = SortOption(
    id: 'price_asc',
    label: 'Price: Low to High',
    field: 'price',
    order: SortOrder.ascending,
    icon: Icons.arrow_upward,
  );

  static const priceHighToLow = SortOption(
    id: 'price_desc',
    label: 'Price: High to Low',
    field: 'price',
    order: SortOrder.descending,
    icon: Icons.arrow_downward,
  );

  // Name
  static const nameAZ = SortOption(
    id: 'name_asc',
    label: 'Name: A to Z',
    field: 'name',
    order: SortOrder.ascending,
    icon: Icons.sort_by_alpha,
  );

  static const nameZA = SortOption(
    id: 'name_desc',
    label: 'Name: Z to A',
    field: 'name',
    order: SortOrder.descending,
    icon: Icons.sort_by_alpha,
  );

  // Duration
  static const durationShort = SortOption(
    id: 'duration_asc',
    label: 'Duration: Shortest',
    field: 'duration',
    order: SortOrder.ascending,
    icon: Icons.schedule,
  );

  static const durationLong = SortOption(
    id: 'duration_desc',
    label: 'Duration: Longest',
    field: 'duration',
    order: SortOrder.descending,
    icon: Icons.schedule,
  );

  // Get all course sort options
  static List<SortOption> get courseOptions => [
        relevance,
        popularity,
        rating,
        newest,
        priceLowToHigh,
        priceHighToLow,
        durationShort,
        nameAZ,
      ];

  // Get all program sort options
  static List<SortOption> get programOptions => [
        relevance,
        popularity,
        rating,
        newest,
        priceLowToHigh,
        priceHighToLow,
        nameAZ,
      ];

  // Get all application sort options
  static List<SortOption> get applicationOptions => [
        newest,
        oldest,
        nameAZ,
      ];
}

/// Sort Button (Compact)
class SortButton extends StatelessWidget {
  final SortOption currentSort;
  final VoidCallback onPressed;

  const SortButton({
    super.key,
    required this.currentSort,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(currentSort.icon, size: 18),
      label: Text(currentSort.label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

/// Sort Bottom Sheet
class SortBottomSheet extends StatelessWidget {
  final List<SortOption> options;
  final SortOption currentSort;
  final Function(SortOption) onSelected;

  const SortBottomSheet({
    super.key,
    required this.options,
    required this.currentSort,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            child: Text(
              'Sort By',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),

          // Sort Options
          ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option == currentSort;

              return ListTile(
                leading: Icon(
                  option.icon,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                title: Text(
                  option.label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () {
                  onSelected(option);
                  Navigator.pop(context);
                },
              );
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

/// Show Sort Bottom Sheet
Future<void> showSortBottomSheet({
  required BuildContext context,
  required List<SortOption> options,
  required SortOption currentSort,
  required Function(SortOption) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => SortBottomSheet(
      options: options,
      currentSort: currentSort,
      onSelected: onSelected,
    ),
  );
}

/// Sort Dropdown (for larger screens)
class SortDropdown extends StatelessWidget {
  final List<SortOption> options;
  final SortOption currentSort;
  final Function(SortOption?) onChanged;

  const SortDropdown({
    super.key,
    required this.options,
    required this.currentSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<SortOption>(
        value: currentSort,
        underline: const SizedBox.shrink(),
        icon: const Icon(Icons.arrow_drop_down, size: 20),
        items: options.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Row(
              children: [
                Icon(option.icon, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(option.label),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

/// Sort and Filter Bar (Combined)
class SortFilterBar extends StatelessWidget {
  final SortOption currentSort;
  final int activeFilters;
  final VoidCallback onSortPressed;
  final VoidCallback onFilterPressed;
  final String? resultsCount;

  const SortFilterBar({
    super.key,
    required this.currentSort,
    this.activeFilters = 0,
    required this.onSortPressed,
    required this.onFilterPressed,
    this.resultsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Results count
          if (resultsCount != null) ...[
            Expanded(
              child: Text(
                resultsCount!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          ] else
            const Spacer(),

          // Sort button
          OutlinedButton.icon(
            onPressed: onSortPressed,
            icon: Icon(currentSort.icon, size: 16),
            label: const Text('Sort'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),

          // Filter button
          Stack(
            children: [
              OutlinedButton.icon(
                onPressed: onFilterPressed,
                icon: const Icon(Icons.filter_list, size: 16),
                label: const Text('Filter'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              if (activeFilters > 0)
                Positioned(
                  right: 4,
                  top: 4,
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
          ),
        ],
      ),
    );
  }
}

/// Sort Helper Functions
class SortHelper {
  /// Sort a list of items by a given sort option
  static List<T> sortList<T>({
    required List<T> items,
    required SortOption sortBy,
    required dynamic Function(T) getValue,
  }) {
    final sorted = List<T>.from(items);

    sorted.sort((a, b) {
      final aValue = getValue(a);
      final bValue = getValue(b);

      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return 1;
      if (bValue == null) return -1;

      int comparison;
      if (aValue is num && bValue is num) {
        comparison = aValue.compareTo(bValue);
      } else if (aValue is String && bValue is String) {
        comparison = aValue.toLowerCase().compareTo(bValue.toLowerCase());
      } else if (aValue is DateTime && bValue is DateTime) {
        comparison = aValue.compareTo(bValue);
      } else {
        comparison = aValue.toString().compareTo(bValue.toString());
      }

      return sortBy.order == SortOrder.ascending ? comparison : -comparison;
    });

    return sorted;
  }

  /// Get sort field name for API
  static String getSortFieldForApi(SortOption sortBy) {
    return sortBy.field;
  }

  /// Get sort order for API
  static String getSortOrderForApi(SortOption sortBy) {
    return sortBy.order == SortOrder.ascending ? 'asc' : 'desc';
  }
}
