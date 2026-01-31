import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/theme/app_colors.dart';

/// Pre-built query template
class _QueryTemplate {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final String endpoint;
  final Map<String, String> params;
  final String dataKey;

  const _QueryTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.endpoint,
    this.params = const {},
    required this.dataKey,
  });
}

const _queryTemplates = <_QueryTemplate>[
  _QueryTemplate(
    id: 'all_users',
    name: 'All Users',
    description: 'List every registered user with profile data',
    icon: Icons.people,
    endpoint: '/admin/users',
    dataKey: 'users',
  ),
  _QueryTemplate(
    id: 'student_users',
    name: 'Students Only',
    description: 'Filter users to show only students',
    icon: Icons.school,
    endpoint: '/admin/users',
    params: {'role': 'student'},
    dataKey: 'users',
  ),
  _QueryTemplate(
    id: 'admin_users',
    name: 'Admin Users',
    description: 'List all administrator accounts',
    icon: Icons.admin_panel_settings,
    endpoint: '/admin/users/admins',
    dataKey: 'admins',
  ),
  _QueryTemplate(
    id: 'recent_activity',
    name: 'Recent Activity',
    description: 'Last 50 platform activities from the audit log',
    icon: Icons.history,
    endpoint: '/admin/dashboard/recent-activity',
    params: {'limit': '50'},
    dataKey: 'activities',
  ),
  _QueryTemplate(
    id: 'activity_stats',
    name: 'Activity Statistics',
    description: 'Aggregated activity counts by type',
    icon: Icons.bar_chart,
    endpoint: '/admin/dashboard/activity-stats',
    dataKey: '_root',
  ),
  _QueryTemplate(
    id: 'analytics_metrics',
    name: 'Platform Metrics',
    description: 'Key metrics: user counts, applications, growth rates',
    icon: Icons.analytics,
    endpoint: '/admin/analytics/metrics',
    dataKey: '_root',
  ),
  _QueryTemplate(
    id: 'finance_stats',
    name: 'Finance Overview',
    description: 'Revenue, transactions, and financial KPIs',
    icon: Icons.attach_money,
    endpoint: '/admin/finance/stats',
    dataKey: '_root',
  ),
  _QueryTemplate(
    id: 'content_stats',
    name: 'Content Statistics',
    description: 'Published, draft, and pending content counts',
    icon: Icons.library_books,
    endpoint: '/admin/content/stats',
    dataKey: '_root',
  ),
  _QueryTemplate(
    id: 'open_tickets',
    name: 'Open Support Tickets',
    description: 'All currently open support tickets',
    icon: Icons.support_agent,
    endpoint: '/admin/support/tickets',
    params: {'status': 'open'},
    dataKey: 'tickets',
  ),
  _QueryTemplate(
    id: 'transactions',
    name: 'Recent Transactions',
    description: 'Financial transactions (last 100)',
    icon: Icons.receipt_long,
    endpoint: '/admin/finance/transactions',
    params: {'limit': '100'},
    dataKey: 'transactions',
  ),
  _QueryTemplate(
    id: 'user_growth',
    name: 'User Growth (6 Months)',
    description: 'Monthly user registration trend',
    icon: Icons.trending_up,
    endpoint: '/admin/dashboard/analytics/user-growth',
    params: {'period': '6_months'},
    dataKey: '_root',
  ),
  _QueryTemplate(
    id: 'role_distribution',
    name: 'Role Distribution',
    description: 'Breakdown of users by role type',
    icon: Icons.pie_chart,
    endpoint: '/admin/dashboard/analytics/role-distribution',
    dataKey: '_root',
  ),
];

class SqlQueriesScreen extends ConsumerStatefulWidget {
  const SqlQueriesScreen({super.key});

  @override
  ConsumerState<SqlQueriesScreen> createState() => _SqlQueriesScreenState();
}

class _SqlQueriesScreenState extends ConsumerState<SqlQueriesScreen> {
  _QueryTemplate? _activeQuery;
  List<Map<String, dynamic>> _resultRows = [];
  List<String> _resultColumns = [];
  bool _loading = false;
  String? _error;
  Duration? _elapsed;
  String _search = '';

  Future<void> _runQuery(_QueryTemplate query) async {
    setState(() {
      _activeQuery = query;
      _loading = true;
      _error = null;
      _resultRows = [];
      _resultColumns = [];
      _elapsed = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      final apiClient = ref.read(apiClientProvider);
      String path = '${ApiConfig.admin}${query.endpoint.replaceFirst('/admin', '')}';
      if (query.params.isNotEmpty) {
        final qs = query.params.entries.map((e) => '${e.key}=${e.value}').join('&');
        path = '$path?$qs';
      }

      final response = await apiClient.get(
        path,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      stopwatch.stop();

      if (response.success && response.data != null) {
        final data = response.data!;

        if (query.dataKey == '_root') {
          // Single-row result: show entire response as key-value
          _resultRows = [data];
          _resultColumns = data.keys.where((k) {
            return data[k] is! Map && data[k] is! List;
          }).toList();

          // Also flatten nested maps one level deep
          for (final key in data.keys) {
            if (data[key] is Map) {
              final nested = data[key] as Map<String, dynamic>;
              for (final nk in nested.keys) {
                final flatKey = '$key.$nk';
                _resultColumns.add(flatKey);
                _resultRows[0][flatKey] = nested[nk];
              }
            }
          }
        } else {
          final rawList = data[query.dataKey];
          if (rawList is List) {
            _resultRows = rawList.whereType<Map<String, dynamic>>().toList();
          }
          // Extract columns
          final cols = <String>{};
          for (final row in _resultRows.take(5)) {
            for (final key in row.keys) {
              if (row[key] is! Map && row[key] is! List) {
                cols.add(key);
              }
            }
          }
          _resultColumns = cols.toList();
        }

        _elapsed = stopwatch.elapsed;
      } else {
        _error = response.message ?? 'Query failed';
      }
    } catch (e) {
      stopwatch.stop();
      _error = 'Error: $e';
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Query sidebar
              SizedBox(
                width: 320,
                child: _buildQueryList(),
              ),
              VerticalDivider(width: 1, color: AppColors.border),
              // Results area
              Expanded(child: _buildResults()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Icon(Icons.query_stats, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SQL Queries',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Run pre-built queries against platform data',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          if (_elapsed != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 14, color: AppColors.success),
                  const SizedBox(width: 4),
                  Text(
                    '${_elapsed!.inMilliseconds}ms',
                    style: TextStyle(color: AppColors.success, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQueryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search queries...',
              prefixIcon: const Icon(Icons.search, size: 18),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: _queryTemplates.where((q) {
              if (_search.isEmpty) return true;
              final s = _search.toLowerCase();
              return q.name.toLowerCase().contains(s) ||
                  q.description.toLowerCase().contains(s);
            }).map((q) {
              final isActive = _activeQuery?.id == q.id;
              return Card(
                color: isActive ? AppColors.primary.withValues(alpha: 0.08) : null,
                elevation: isActive ? 0 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isActive ? AppColors.primary : AppColors.border,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 6),
                child: InkWell(
                  onTap: () => _runQuery(q),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(q.icon, size: 20, color: isActive ? AppColors.primary : AppColors.textSecondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: isActive ? AppColors.primary : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                q.description,
                                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.play_arrow, size: 18, color: isActive ? AppColors.primary : Colors.grey[400]),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _activeQuery != null ? () => _runQuery(_activeQuery!) : null,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_activeQuery == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Select a query to run',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose from the query library on the left',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_resultRows.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No results', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Result header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Icon(_activeQuery!.icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                _activeQuery!.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              Text(
                '${_resultRows.length} rows  |  ${_resultColumns.length} columns',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        // Data table
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.surfaceVariant),
                  headingTextStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textPrimary),
                  dataTextStyle: const TextStyle(fontSize: 12),
                  columnSpacing: 20,
                  columns: _resultColumns.map((col) {
                    return DataColumn(label: Text(col.replaceAll('_', ' ').toUpperCase()));
                  }).toList(),
                  rows: _resultRows.take(200).map((row) {
                    return DataRow(
                      cells: _resultColumns.map((col) {
                        final val = row[col];
                        String display = val?.toString() ?? '-';
                        if (display.length > 50) display = '${display.substring(0, 47)}...';
                        return DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 220),
                            child: Text(display, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
