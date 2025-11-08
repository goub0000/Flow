import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Filter Bar - Compact inline filter component
class FilterBar extends StatelessWidget {
  final List<QuickFilter> filters;
  final VoidCallback? onAdvancedFilter;
  final VoidCallback? onClearAll;
  final int? activeFilterCount;

  const FilterBar({
    required this.filters,
    this.onAdvancedFilter,
    this.onClearAll,
    this.activeFilterCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_alt, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: filters.map((filter) {
                return _buildQuickFilterChip(filter);
              }).toList(),
            ),
          ),
          if (onAdvancedFilter != null) ...[
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: onAdvancedFilter,
              icon: const Icon(Icons.tune, size: 18),
              label: Text(
                activeFilterCount != null && activeFilterCount! > 0
                    ? 'Filters ($activeFilterCount)'
                    : 'Advanced',
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ],
          if (onClearAll != null && activeFilterCount != null && activeFilterCount! > 0) ...[
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onClearAll,
              icon: const Icon(Icons.clear, size: 18),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickFilterChip(QuickFilter filter) {
    return DropdownButton<dynamic>(
      value: filter.selectedValue,
      hint: Text(
        filter.label,
        style: const TextStyle(fontSize: 13),
      ),
      underline: const SizedBox(),
      isDense: true,
      items: filter.options.map((option) {
        return DropdownMenuItem(
          value: option['value'],
          child: Text(
            option['label'] ?? option['value'].toString(),
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: filter.onChanged,
    );
  }
}

/// Quick Filter Configuration
class QuickFilter {
  final String label;
  final List<Map<String, dynamic>> options;
  final dynamic selectedValue;
  final void Function(dynamic value) onChanged;

  QuickFilter({
    required this.label,
    required this.options,
    this.selectedValue,
    required this.onChanged,
  });
}
