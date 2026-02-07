import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Data source definition for the explorer
class _DataSource {
  final String id;
  final String label;
  final IconData icon;
  final String endpoint;
  final String dataKey;
  final Color color;

  const _DataSource({
    required this.id,
    required this.label,
    required this.icon,
    required this.endpoint,
    required this.dataKey,
    required this.color,
  });
}

const _dataSources = <_DataSource>[
  _DataSource(
    id: 'users',
    label: 'Users',
    icon: Icons.people,
    endpoint: '/admin/users',
    dataKey: 'users',
    color: AppColors.primary,
  ),
  _DataSource(
    id: 'content',
    label: 'Content',
    icon: Icons.library_books,
    endpoint: '/admin/content',
    dataKey: 'content',
    color: AppColors.success,
  ),
  _DataSource(
    id: 'transactions',
    label: 'Transactions',
    icon: Icons.receipt_long,
    endpoint: '/admin/finance/transactions',
    dataKey: 'transactions',
    color: Color(0xFFFAA61A),
  ),
  _DataSource(
    id: 'tickets',
    label: 'Support Tickets',
    icon: Icons.support_agent,
    endpoint: '/admin/support/tickets',
    dataKey: 'tickets',
    color: AppColors.secondary,
  ),
  _DataSource(
    id: 'campaigns',
    label: 'Campaigns',
    icon: Icons.campaign,
    endpoint: '/admin/communications/campaigns',
    dataKey: 'campaigns',
    color: AppColors.primaryLight,
  ),
  _DataSource(
    id: 'courses',
    label: 'Courses',
    icon: Icons.school,
    endpoint: '/admin/courses/list',
    dataKey: 'courses',
    color: Color(0xFF4CAF50),
  ),
];

class DataExplorerScreen extends ConsumerStatefulWidget {
  const DataExplorerScreen({super.key});

  @override
  ConsumerState<DataExplorerScreen> createState() => _DataExplorerScreenState();
}

class _DataExplorerScreenState extends ConsumerState<DataExplorerScreen> {
  _DataSource _selected = _dataSources.first;
  List<Map<String, dynamic>> _rows = [];
  List<String> _columns = [];
  bool _loading = false;
  String? _error;
  int _totalCount = 0;
  String _searchQuery = '';
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(
        '${ApiConfig.admin}${_selected.endpoint.replaceFirst('/admin', '')}',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final rawList = data[_selected.dataKey];
        List<Map<String, dynamic>> rows = [];

        if (rawList is List) {
          rows = rawList
              .whereType<Map<String, dynamic>>()
              .toList();
        }

        // Extract column names from first row
        final cols = <String>{};
        for (final row in rows.take(5)) {
          for (final key in row.keys) {
            if (row[key] is! Map && row[key] is! List) {
              cols.add(key);
            }
          }
        }

        setState(() {
          _rows = rows;
          _columns = cols.toList();
          _totalCount = (data['total'] as int?) ??
              (data['total_count'] as int?) ??
              rows.length;
          _loading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to fetch data';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredRows {
    if (_searchQuery.isEmpty) return _rows;
    final q = _searchQuery.toLowerCase();
    return _rows.where((row) {
      return row.values.any(
        (v) => v?.toString().toLowerCase().contains(q) == true,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildDataSourceTabs(),
        if (_error != null) _buildErrorBanner(),
        if (_loading)
          const LinearProgressIndicator()
        else
          const SizedBox(height: 2),
        _buildSearchBar(),
        Expanded(child: _buildDataTable()),
        _buildFooter(),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.grid_on, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminAnalyticsDataExplorer,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  context.l10n.adminAnalyticsDataExplorerSubtitle,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.adminAnalyticsRefreshData,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSourceTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: _dataSources.map((ds) {
          final isSelected = ds.id == _selected.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selected = ds);
                _fetchData();
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? ds.color : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? ds.color : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(ds.icon, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      ds.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: context.l10n.adminAnalyticsSearchColumns,
          prefixIcon: const Icon(Icons.search, size: 20),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: TextStyle(color: AppColors.error, fontSize: 13))),
          IconButton(icon: const Icon(Icons.refresh, size: 18), onPressed: _fetchData),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final filtered = _filteredRows;

    if (!_loading && filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.table_rows_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              _rows.isEmpty ? context.l10n.adminAnalyticsNoDataAvailable : context.l10n.adminAnalyticsNoMatchingRows,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.surfaceContainerHighest),
            headingTextStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary),
            dataTextStyle: const TextStyle(fontSize: 13),
            columnSpacing: 24,
            columns: _columns.map((col) {
              return DataColumn(label: Text(col.replaceAll('_', ' ').toUpperCase()));
            }).toList(),
            rows: filtered.take(200).map((row) {
              return DataRow(
                cells: _columns.map((col) {
                  final val = row[col];
                  String display = '';
                  if (val == null) {
                    display = '-';
                  } else if (val is String && val.length > 60) {
                    display = '${val.substring(0, 57)}...';
                  } else {
                    display = val.toString();
                  }
                  return DataCell(
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(display, overflow: TextOverflow.ellipsis),
                    ),
                    onTap: () => _showCellDetail(col, val),
                  );
                }).toList(),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final filtered = _filteredRows;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Icon(_selected.icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            '${_selected.label}  |  ${context.l10n.adminAnalyticsShowingRows(filtered.length, _totalCount)}',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const Spacer(),
          Text(
            context.l10n.adminAnalyticsColumnsCount(_columns.length),
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _showCellDetail(String column, dynamic value) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(column.replaceAll('_', ' ').toUpperCase()),
        content: SelectableText(
          value?.toString() ?? 'null',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(context.l10n.adminAnalyticsClose)),
        ],
      ),
    );
  }
}
