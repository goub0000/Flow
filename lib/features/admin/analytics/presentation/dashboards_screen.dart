import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../shared/providers/admin_analytics_provider.dart';
import '../../shared/providers/admin_finance_provider.dart';

/// Widget definition for a dashboard card
class _DashboardWidget {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  bool visible;

  _DashboardWidget({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}

class DashboardsScreen extends ConsumerStatefulWidget {
  const DashboardsScreen({super.key});

  @override
  ConsumerState<DashboardsScreen> createState() => _DashboardsScreenState();
}

class _DashboardsScreenState extends ConsumerState<DashboardsScreen> {
  late final List<_DashboardWidget> _widgets;

  @override
  void initState() {
    super.initState();
    _widgets = [
      _DashboardWidget(id: 'kpi', title: 'Key Metrics', icon: Icons.speed, color: AppColors.primary),
      _DashboardWidget(id: 'users', title: 'User Summary', icon: Icons.people, color: AppColors.success),
      _DashboardWidget(id: 'finance', title: 'Finance Overview', icon: Icons.attach_money, color: Color(0xFFFAA61A)),
      _DashboardWidget(id: 'activity', title: 'Recent Activity', icon: Icons.history, color: AppColors.primaryLight),
      _DashboardWidget(id: 'content', title: 'Content Stats', icon: Icons.library_books, color: AppColors.secondary),
      _DashboardWidget(id: 'growth', title: 'User Growth', icon: Icons.trending_up, color: Color(0xFF4CAF50)),
    ];
  }

  void _refreshAll() {
    ref.read(adminAnalyticsProvider.notifier).fetchAnalytics();
    ref.read(adminFinanceProvider.notifier).fetchTransactions();
    ref.read(adminFinanceProvider.notifier).fetchStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildToolbar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: _buildGrid(),
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
          Icon(Icons.dashboard_customize, size: 32, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Dashboards',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Configure and view your analytics dashboard',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _refreshAll,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh All',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          const Text('Widgets:', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          const SizedBox(width: 12),
          ..._widgets.map((w) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                avatar: Icon(w.icon, size: 16, color: w.visible ? w.color : AppColors.textSecondary),
                label: Text(w.title, style: const TextStyle(fontSize: 12)),
                selected: w.visible,
                selectedColor: w.color.withValues(alpha: 0.15),
                onSelected: (v) => setState(() => w.visible = v),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final visible = _widgets.where((w) => w.visible).toList();

    if (visible.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.widgets_outlined, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No widgets selected', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              const Text('Use the chips above to toggle dashboard widgets'),
            ],
          ),
        ),
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: visible.map((w) => _buildWidgetCard(w)).toList(),
    );
  }

  Widget _buildWidgetCard(_DashboardWidget widget) {
    return SizedBox(
      width: 500,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, size: 20, color: widget.color),
                const SizedBox(width: 8),
                Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 16),
            _buildWidgetContent(widget.id),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetContent(String id) {
    switch (id) {
      case 'kpi':
        return _buildKpiWidget();
      case 'users':
        return _buildUsersWidget();
      case 'finance':
        return _buildFinanceWidget();
      case 'activity':
        return _buildActivityWidget();
      case 'content':
        return _buildContentWidget();
      case 'growth':
        return _buildGrowthWidget();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildKpiWidget() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final analyticsState = ref.watch(adminAnalyticsProvider);

    if (analyticsState.isLoading) return _buildLoading();

    return Row(
      children: [
        _buildMiniKpi('Total Users', '${metrics['total_users'] ?? 0}', Icons.people, AppColors.primary),
        const SizedBox(width: 12),
        _buildMiniKpi('Active (30d)', '${metrics['active_users_30days'] ?? 0}', Icons.person, AppColors.success),
        const SizedBox(width: 12),
        _buildMiniKpi('New (7d)', '${metrics['new_registrations_7days'] ?? 0}', Icons.person_add, Color(0xFFFAA61A)),
        const SizedBox(width: 12),
        _buildMiniKpi('Apps (7d)', '${metrics['applications_7days'] ?? 0}', Icons.description, AppColors.secondary),
      ],
    );
  }

  Widget _buildMiniKpi(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersWidget() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final analyticsState = ref.watch(adminAnalyticsProvider);

    if (analyticsState.isLoading) return _buildLoading();

    final roles = <MapEntry<String, int>>[
      MapEntry('Students', (metrics['total_students'] as int?) ?? 0),
      MapEntry('Institutions', (metrics['total_institutions'] as int?) ?? 0),
      MapEntry('Counselors', (metrics['total_counselors'] as int?) ?? 0),
      MapEntry('Recommenders', (metrics['total_recommenders'] as int?) ?? 0),
    ];
    final total = roles.fold<int>(0, (sum, e) => sum + e.value);

    return Column(
      children: roles.map((entry) {
        final fraction = total > 0 ? entry.value / total : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(width: 90, child: Text(entry.key, style: const TextStyle(fontSize: 13))),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text('${entry.value}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), textAlign: TextAlign.right),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFinanceWidget() {
    final stats = ref.watch(adminFinanceStatisticsProvider);
    final financeState = ref.watch(adminFinanceProvider);

    if (financeState.isLoading) return _buildLoading();

    String formatCurrency(dynamic v) {
      final num amount = v is num ? v : 0;
      return 'KES ${amount.toStringAsFixed(2)}';
    }

    return Column(
      children: [
        _buildFinanceRow('Total Revenue', formatCurrency(stats['totalRevenue'] ?? 0), AppColors.success),
        _buildFinanceRow('This Month', formatCurrency(stats['revenueThisMonth'] ?? 0), AppColors.primary),
        _buildFinanceRow('Transactions', '${stats['totalTransactions'] ?? 0}', Color(0xFFFAA61A)),
        _buildFinanceRow('Success Rate', '${(stats['successRate'] ?? 0).toStringAsFixed(1)}%', AppColors.success),
      ],
    );
  }

  Widget _buildFinanceRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: color)),
        ],
      ),
    );
  }

  Widget _buildActivityWidget() {
    final activity = ref.watch(adminRecentActivityProvider);
    final analyticsState = ref.watch(adminAnalyticsProvider);

    if (analyticsState.isLoading) return _buildLoading();

    if (activity.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text('No recent activity')),
      );
    }

    return Column(
      children: activity.take(5).map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Icon(_activityIcon(item.actionType), size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.description,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _timeAgo(item.timestamp),
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContentWidget() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final analyticsState = ref.watch(adminAnalyticsProvider);

    if (analyticsState.isLoading) return _buildLoading();

    return Row(
      children: [
        _buildMiniKpi('Courses', '${metrics['total_courses'] ?? 0}', Icons.school, AppColors.primary),
        const SizedBox(width: 12),
        _buildMiniKpi('Programs', '${metrics['total_programs'] ?? 0}', Icons.category, AppColors.success),
        const SizedBox(width: 12),
        _buildMiniKpi('Universities', '${metrics['total_universities'] ?? 0}', Icons.business, Color(0xFFFAA61A)),
      ],
    );
  }

  Widget _buildGrowthWidget() {
    final metrics = ref.watch(adminAnalyticsMetricsProvider);
    final analyticsState = ref.watch(adminAnalyticsProvider);

    if (analyticsState.isLoading) return _buildLoading();

    final change = (metrics['total_users_change_percent'] as num?)?.toDouble() ?? 0.0;
    final isPositive = change >= 0;

    return Row(
      children: [
        Icon(
          isPositive ? Icons.trending_up : Icons.trending_down,
          size: 40,
          color: isPositive ? AppColors.success : AppColors.error,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isPositive ? AppColors.success : AppColors.error,
              ),
            ),
            Text(
              'User growth vs previous period',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${metrics['new_registrations_7days'] ?? 0}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('New users this week', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  IconData _activityIcon(String type) {
    switch (type) {
      case 'registration':
        return Icons.person_add;
      case 'login':
        return Icons.login;
      case 'application':
        return Icons.description;
      default:
        return Icons.circle;
    }
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
