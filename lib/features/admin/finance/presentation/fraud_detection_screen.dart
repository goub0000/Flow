import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../shared/providers/admin_finance_provider.dart';

/// Risk level for a transaction
enum _RiskLevel { low, medium, high, critical }

/// Flagged transaction with risk assessment
class _FlaggedTransaction {
  final Transaction transaction;
  final _RiskLevel risk;
  final String reason;
  final bool reviewed;

  const _FlaggedTransaction({
    required this.transaction,
    required this.risk,
    required this.reason,
    this.reviewed = false,
  });

  _FlaggedTransaction copyWith({bool? reviewed}) {
    return _FlaggedTransaction(
      transaction: transaction,
      risk: risk,
      reason: reason,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}

class FraudDetectionScreen extends ConsumerStatefulWidget {
  const FraudDetectionScreen({super.key});

  @override
  ConsumerState<FraudDetectionScreen> createState() => _FraudDetectionScreenState();
}

class _FraudDetectionScreenState extends ConsumerState<FraudDetectionScreen> {
  String _riskFilter = 'all';
  bool _showReviewed = false;
  List<_FlaggedTransaction> _flagged = [];

  @override
  void initState() {
    super.initState();
    // Analyze transactions after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _analyzeTransactions());
  }

  void _analyzeTransactions() {
    final transactions = ref.read(adminFinanceProvider).transactions;
    final flagged = <_FlaggedTransaction>[];

    for (final txn in transactions) {
      // Rule 1: High amount transactions
      if (txn.amount > 50000) {
        flagged.add(_FlaggedTransaction(
          transaction: txn,
          risk: _RiskLevel.high,
          reason: 'Transaction amount exceeds KES 50,000 threshold',
        ));
        continue;
      }

      // Rule 2: Failed transactions
      if (txn.status == 'failed') {
        flagged.add(_FlaggedTransaction(
          transaction: txn,
          risk: _RiskLevel.medium,
          reason: 'Failed transaction — possible payment issue',
        ));
        continue;
      }

      // Rule 3: Very recent large transactions
      if (txn.amount > 10000 && txn.createdAt.isAfter(DateTime.now().subtract(const Duration(hours: 24)))) {
        flagged.add(_FlaggedTransaction(
          transaction: txn,
          risk: _RiskLevel.medium,
          reason: 'Large transaction within last 24 hours',
        ));
        continue;
      }

      // Rule 4: Unusual transaction types
      if (txn.type != 'payment' && txn.type != 'refund') {
        flagged.add(_FlaggedTransaction(
          transaction: txn,
          risk: _RiskLevel.low,
          reason: 'Unusual transaction type: ${txn.type}',
        ));
      }
    }

    // Sort by risk level (critical first)
    flagged.sort((a, b) => b.risk.index.compareTo(a.risk.index));
    setState(() => _flagged = flagged);
  }

  List<_FlaggedTransaction> get _filtered {
    var list = _flagged;
    if (!_showReviewed) {
      list = list.where((f) => !f.reviewed).toList();
    }
    if (_riskFilter != 'all') {
      final level = _RiskLevel.values.firstWhere(
        (r) => r.name == _riskFilter,
        orElse: () => _RiskLevel.low,
      );
      list = list.where((f) => f.risk == level).toList();
    }
    return list;
  }

  String _formatCurrency(dynamic v) {
    final num amount = v is num ? v : 0;
    return 'KES ${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color _riskColor(_RiskLevel risk) {
    switch (risk) {
      case _RiskLevel.critical:
        return const Color(0xFFD32F2F);
      case _RiskLevel.high:
        return AppColors.error;
      case _RiskLevel.medium:
        return AppColors.warning;
      case _RiskLevel.low:
        return AppColors.info;
    }
  }

  IconData _riskIcon(_RiskLevel risk) {
    switch (risk) {
      case _RiskLevel.critical:
        return Icons.gpp_bad;
      case _RiskLevel.high:
        return Icons.warning_amber;
      case _RiskLevel.medium:
        return Icons.shield;
      case _RiskLevel.low:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-analyze when transactions change
    ref.listen(adminFinanceProvider, (_, __) => _analyzeTransactions());

    final filtered = _filtered;
    final criticalCount = _flagged.where((f) => f.risk == _RiskLevel.critical || f.risk == _RiskLevel.high).length;
    final unreviewedCount = _flagged.where((f) => !f.reviewed).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(criticalCount, unreviewedCount),
        const SizedBox(height: 24),
        _buildFilters(),
        const SizedBox(height: 16),
        Expanded(child: _buildAlertsList(filtered)),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.security, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminFinanceFraudDetectionTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminFinanceFraudDetectionSubtitle,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(adminFinanceProvider.notifier).fetchTransactions();
                },
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminFinanceRescanTransactions,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int criticalCount, int unreviewedCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceTotalFlags,
              '${_flagged.length}',
              context.l10n.adminFinanceFlaggedTransactions,
              Icons.flag,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceHighRisk,
              '$criticalCount',
              context.l10n.adminFinanceCriticalHighRisk,
              Icons.warning_amber,
              AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceUnreviewed,
              '$unreviewedCount',
              context.l10n.adminFinancePendingReview,
              Icons.pending_actions,
              AppColors.info,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminFinanceReviewed,
              '${_flagged.where((f) => f.reviewed).length}',
              context.l10n.adminFinanceAlreadyReviewed,
              Icons.check_circle,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _riskFilter,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceRiskLevel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAllLevels)),
                DropdownMenuItem(value: 'critical', child: Text(context.l10n.adminFinanceCritical)),
                DropdownMenuItem(value: 'high', child: Text(context.l10n.adminFinanceHigh)),
                DropdownMenuItem(value: 'medium', child: Text(context.l10n.adminFinanceMedium)),
                DropdownMenuItem(value: 'low', child: Text(context.l10n.adminFinanceLow)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _riskFilter = v);
              },
            ),
          ),
          const SizedBox(width: 16),
          FilterChip(
            label: Text(context.l10n.adminFinanceShowReviewed),
            selected: _showReviewed,
            onSelected: (v) => setState(() => _showReviewed = v),
            selectedColor: AppColors.primary.withValues(alpha: 0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList(List<_FlaggedTransaction> items) {
    final financeState = ref.watch(adminFinanceProvider);

    if (financeState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 64, color: AppColors.success.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(
              _flagged.isEmpty ? context.l10n.adminFinanceNoSuspiciousActivity : context.l10n.adminFinanceNoMatchingAlerts,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
            if (_flagged.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                context.l10n.adminFinanceAllTransactionsNormal,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildAlertCard(item, index);
      },
    );
  }

  Widget _buildAlertCard(_FlaggedTransaction item, int originalIndex) {
    final txn = item.transaction;
    final color = _riskColor(item.risk);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.reviewed ? AppColors.border : color.withValues(alpha: 0.4),
          width: item.reviewed ? 1 : 2,
        ),
      ),
      child: Column(
        children: [
          // Risk badge bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              children: [
                Icon(_riskIcon(item.risk), size: 18, color: color),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.risk.name.toUpperCase(),
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.reason,
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ),
                if (item.reviewed)
                  Icon(Icons.check_circle, size: 18, color: AppColors.success)
                else
                  Text(
                    _timeAgo(txn.createdAt),
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
              ],
            ),
          ),
          // Transaction details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(txn.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'monospace')),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(txn.type.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${txn.userName}  |  ${_formatDate(txn.createdAt)}',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatCurrency(txn.amount),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                if (!item.reviewed)
                  OutlinedButton.icon(
                    onPressed: () {
                      final idx = _flagged.indexOf(item);
                      if (idx >= 0) {
                        setState(() {
                          _flagged[idx] = item.copyWith(reviewed: true);
                        });
                      }
                    },
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(context.l10n.adminFinanceMarkReviewed, style: const TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )
                else
                  Text(context.l10n.adminFinanceReviewed, style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
