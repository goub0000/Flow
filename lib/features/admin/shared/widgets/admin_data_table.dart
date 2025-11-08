import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// Admin Data Table - Reusable table component for admin list screens
///
/// Features:
/// - Sortable columns
/// - Row selection
/// - Pagination
/// - Responsive design
/// - Custom actions per row
/// - Column visibility toggle
class AdminDataTable<T> extends StatefulWidget {
  final List<DataTableColumn<T>> columns;
  final List<T> data;
  final void Function(T item)? onRowTap;
  final List<DataTableAction<T>>? rowActions;
  final bool enableSelection;
  final void Function(List<T> selectedItems)? onSelectionChanged;
  final int rowsPerPage;
  final bool isLoading;
  final bool enableColumnVisibility;

  const AdminDataTable({
    required this.columns,
    required this.data,
    this.onRowTap,
    this.rowActions,
    this.enableSelection = false,
    this.onSelectionChanged,
    this.rowsPerPage = 10,
    this.isLoading = false,
    this.enableColumnVisibility = true,
    super.key,
  });

  @override
  State<AdminDataTable<T>> createState() => _AdminDataTableState<T>();
}

class _AdminDataTableState<T> extends State<AdminDataTable<T>> {
  final Set<T> _selectedItems = {};
  int _currentPage = 0;
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late Set<int> _visibleColumnIndices;
  late int _rowsPerPage;

  @override
  void initState() {
    super.initState();
    // Initially all columns are visible
    _visibleColumnIndices = Set.from(
      List.generate(widget.columns.length, (index) => index),
    );
    _rowsPerPage = widget.rowsPerPage;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.data.isEmpty) {
      return _buildEmptyState();
    }

    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, widget.data.length);
    final pageData = widget.data.sublist(startIndex, endIndex);

    // Get visible columns
    final visibleColumns = widget.columns
        .asMap()
        .entries
        .where((entry) => _visibleColumnIndices.contains(entry.key))
        .toList();

    return Column(
      children: [
        // Column visibility control
        if (widget.enableColumnVisibility) _buildColumnVisibilityControl(),

        // Table
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width - 350,
              ),
              child: DataTable(
                showCheckboxColumn: widget.enableSelection,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  ...visibleColumns
                      .map((entry) => DataColumn(
                            label: Text(
                              entry.value.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            onSort: entry.value.sortable
                                ? (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = columnIndex;
                                      _sortAscending = ascending;
                                    });
                                  }
                                : null,
                          ))
                      .toList(),
                  // Add Actions column when rowActions are provided
                  if (widget.rowActions != null)
                    const DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
                rows: pageData.map((item) {
                  final isSelected = _selectedItems.contains(item);
                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: widget.enableSelection
                        ? (selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedItems.add(item);
                              } else {
                                _selectedItems.remove(item);
                              }
                            });
                            widget.onSelectionChanged?.call(_selectedItems.toList());
                          }
                        : null,
                    cells: [
                      ...visibleColumns.map((entry) {
                        return DataCell(
                          entry.value.cellBuilder(item),
                          onTap: widget.onRowTap != null
                              ? () => widget.onRowTap!(item)
                              : null,
                        );
                      }),
                      if (widget.rowActions != null)
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: widget.rowActions!
                                .map((action) => IconButton(
                                      icon: Icon(action.icon, size: 20),
                                      onPressed: () => action.onPressed(item),
                                      tooltip: action.tooltip,
                                      color: action.color,
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // Pagination
        _buildPagination(),
      ],
    );
  }

  Widget _buildColumnVisibilityControl() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PopupMenuButton<int>(
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.view_column, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Columns',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            tooltip: 'Show/Hide Columns',
            itemBuilder: (context) {
              return widget.columns.asMap().entries.map((entry) {
                final index = entry.key;
                final column = entry.value;
                final isVisible = _visibleColumnIndices.contains(index);

                return CheckedPopupMenuItem<int>(
                  value: index,
                  checked: isVisible,
                  child: Text(
                    column.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                );
              }).toList();
            },
            onSelected: (index) {
              setState(() {
                if (_visibleColumnIndices.contains(index)) {
                  // Don't allow hiding all columns
                  if (_visibleColumnIndices.length > 1) {
                    _visibleColumnIndices.remove(index);
                  }
                } else {
                  _visibleColumnIndices.add(index);
                }
              });
            },
          ),
          const SizedBox(width: 8),
          Text(
            '${_visibleColumnIndices.length} of ${widget.columns.length} visible',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    final totalPages = (widget.data.length / _rowsPerPage).ceil();
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, widget.data.length);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Showing ${startIndex + 1}-$endIndex of ${widget.data.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              // Rows per page selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  underline: const SizedBox(),
                  isDense: true,
                  items: const [
                    DropdownMenuItem(value: 10, child: Text('10 / page')),
                    DropdownMenuItem(value: 25, child: Text('25 / page')),
                    DropdownMenuItem(value: 50, child: Text('50 / page')),
                    DropdownMenuItem(value: 100, child: Text('100 / page')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _rowsPerPage = value;
                        _currentPage = 0; // Reset to first page
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              // First page button
              IconButton(
                icon: const Icon(Icons.first_page, size: 20),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage = 0)
                    : null,
                tooltip: 'First page',
              ),
              // Previous page button
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                tooltip: 'Previous page',
              ),
              // Page indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Page ${_currentPage + 1} of $totalPages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              // Next page button
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
                tooltip: 'Next page',
              ),
              // Last page button
              IconButton(
                icon: const Icon(Icons.last_page, size: 20),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage = totalPages - 1)
                    : null,
                tooltip: 'Last page',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Loading data...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No data available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters or search criteria',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int get endIndex => (_currentPage * widget.rowsPerPage + widget.rowsPerPage)
      .clamp(0, widget.data.length);
}

/// Column definition for AdminDataTable
class DataTableColumn<T> {
  final String label;
  final Widget Function(T item) cellBuilder;
  final bool sortable;

  const DataTableColumn({
    required this.label,
    required this.cellBuilder,
    this.sortable = false,
  });
}

/// Action button for table rows
class DataTableAction<T> {
  final IconData icon;
  final String tooltip;
  final void Function(T item) onPressed;
  final Color? color;

  const DataTableAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });
}
