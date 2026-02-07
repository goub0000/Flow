// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Advanced Filter Widget - Reusable filter component for data tables
class AdvancedFilter extends StatefulWidget {
  final List<FilterField> fields;
  final void Function(Map<String, dynamic> filters) onApply;
  final VoidCallback? onReset;
  final Map<String, dynamic>? initialValues;

  const AdvancedFilter({
    required this.fields,
    required this.onApply,
    this.onReset,
    this.initialValues,
    super.key,
  });

  @override
  State<AdvancedFilter> createState() => _AdvancedFilterState();
}

class _AdvancedFilterState extends State<AdvancedFilter> {
  late Map<String, dynamic> _filterValues;

  @override
  void initState() {
    super.initState();
    _filterValues = Map.from(widget.initialValues ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Advanced Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: _handleReset,
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Reset'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _handleApply,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Apply Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.border),
          const SizedBox(height: 20),

          // Filter Fields
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: widget.fields.map((field) {
              return SizedBox(
                width: _getFieldWidth(field.width),
                child: _buildFilterField(field),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterField(FilterField field) {
    switch (field.type) {
      case FilterFieldType.text:
        return _buildTextField(field);
      case FilterFieldType.dropdown:
        return _buildDropdownField(field);
      case FilterFieldType.multiSelect:
        return _buildMultiSelectField(field);
      case FilterFieldType.dateRange:
        return _buildDateRangeField(field);
      case FilterFieldType.numericRange:
        return _buildNumericRangeField(field);
      case FilterFieldType.checkbox:
        return _buildCheckboxField(field);
      case FilterFieldType.radio:
        return _buildRadioField(field);
    }
  }

  Widget _buildTextField(FilterField field) {
    return TextField(
      decoration: InputDecoration(
        labelText: field.label,
        hintText: field.hint,
        prefixIcon: field.icon != null ? Icon(field.icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onChanged: (value) {
        _filterValues[field.key] = value;
      },
    );
  }

  Widget _buildDropdownField(FilterField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButton<dynamic>(
            value: _filterValues[field.key],
            hint: Text(field.hint ?? 'Select ${field.label}'),
            isExpanded: true,
            underline: const SizedBox(),
            items: field.options?.map((option) {
              return DropdownMenuItem(
                value: option['value'],
                child: Text(option['label'] ?? option['value'].toString()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _filterValues[field.key] = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField(FilterField field) {
    final selectedValues = _filterValues[field.key] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: field.options?.map((option) {
            final value = option['value'];
            final isSelected = selectedValues.contains(value);

            return FilterChip(
              label: Text(option['label'] ?? value.toString()),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  final list = List.from(selectedValues);
                  if (selected) {
                    list.add(value);
                  } else {
                    list.remove(value);
                  }
                  _filterValues[field.key] = list;
                });
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              backgroundColor: AppColors.background,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            );
          }).toList() ?? [],
        ),
      ],
    );
  }

  Widget _buildDateRangeField(FilterField field) {
    final dateRange = _filterValues[field.key] as DateTimeRange?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _selectDateRange(field),
          icon: const Icon(Icons.date_range, size: 18),
          label: Text(
            dateRange == null
                ? field.hint ?? 'Select date range'
                : '${dateRange.start.day}/${dateRange.start.month}/${dateRange.start.year} - ${dateRange.end.day}/${dateRange.end.month}/${dateRange.end.year}',
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericRangeField(FilterField field) {
    final min = _filterValues['${field.key}_min'] as num? ?? field.min ?? 0;
    final max = _filterValues['${field.key}_max'] as num? ?? field.max ?? 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: RangeValues(min.toDouble(), max.toDouble()),
          min: (field.min ?? 0).toDouble(),
          max: (field.max ?? 100).toDouble(),
          divisions: field.divisions,
          labels: RangeLabels(
            min.toString(),
            max.toString(),
          ),
          onChanged: (values) {
            setState(() {
              _filterValues['${field.key}_min'] = values.start;
              _filterValues['${field.key}_max'] = values.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Min: ${min.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              'Max: ${max.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxField(FilterField field) {
    return CheckboxListTile(
      title: Text(field.label),
      subtitle: field.hint != null ? Text(field.hint!) : null,
      value: _filterValues[field.key] as bool? ?? false,
      onChanged: (value) {
        setState(() {
          _filterValues[field.key] = value ?? false;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildRadioField(FilterField field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          field.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...field.options?.map((option) {
          return RadioListTile(
            title: Text(option['label'] ?? option['value'].toString()),
            value: option['value'],
            groupValue: _filterValues[field.key],
            onChanged: (value) {
              setState(() {
                _filterValues[field.key] = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          );
        }).toList() ?? [],
      ],
    );
  }

  double _getFieldWidth(FilterFieldWidth? width) {
    switch (width) {
      case FilterFieldWidth.small:
        return 200;
      case FilterFieldWidth.medium:
        return 300;
      case FilterFieldWidth.large:
        return 400;
      case FilterFieldWidth.full:
        return double.infinity;
      case null:
        return 250;
    }
  }

  Future<void> _selectDateRange(FilterField field) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _filterValues[field.key] as DateTimeRange?,
    );

    if (picked != null) {
      setState(() {
        _filterValues[field.key] = picked;
      });
    }
  }

  void _handleApply() {
    widget.onApply(_filterValues);
  }

  void _handleReset() {
    setState(() {
      _filterValues.clear();
    });
    widget.onReset?.call();
  }
}

/// Filter Field Configuration
class FilterField {
  final String key;
  final String label;
  final FilterFieldType type;
  final String? hint;
  final IconData? icon;
  final List<Map<String, dynamic>>? options;
  final FilterFieldWidth? width;
  final num? min;
  final num? max;
  final int? divisions;

  FilterField({
    required this.key,
    required this.label,
    required this.type,
    this.hint,
    this.icon,
    this.options,
    this.width,
    this.min,
    this.max,
    this.divisions,
  });
}

/// Filter Field Type
enum FilterFieldType {
  text,
  dropdown,
  multiSelect,
  dateRange,
  numericRange,
  checkbox,
  radio,
}

/// Filter Field Width
enum FilterFieldWidth {
  small,
  medium,
  large,
  full,
}
