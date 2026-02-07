// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Settlement record
class _Settlement {
  final String id;
  final String recipient;
  final String recipientType;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final DateTime? settledAt;
  final int transactionCount;

  const _Settlement({
    required this.id,
    required this.recipient,
    required this.recipientType,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.settledAt,
    required this.transactionCount,
  });
}

class SettlementsScreen extends ConsumerStatefulWidget {
  const SettlementsScreen({super.key});

  @override
  ConsumerState<SettlementsScreen> createState() => _SettlementsScreenState();
}

class _SettlementsScreenState extends ConsumerState<SettlementsScreen> {
  List<_Settlement> _settlements = [];
  bool _loading = false;
  String? _error;
  String _statusFilter = 'all';
  String _search = '';
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _fetchSettlements();
  }

  Future<void> _fetchSettlements() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(
        '${ApiConfig.admin}/finance/transactions',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final txns = (response.data!['transactions'] as List<dynamic>?) ?? [];

        // Group transactions into settlement batches by date and recipient type
        final Map<String, List<Map<String, dynamic>>> batches = {};
        for (final txn in txns) {
          if (txn is! Map<String, dynamic>) continue;
          final status = txn['status']?.toString() ?? '';
          if (status != 'completed') continue;
          final date = txn['created_at'] != null
              ? DateTime.parse(txn['created_at']).toIso8601String().split('T').first
              : 'unknown';
          final key = date;
          batches.putIfAbsent(key, () => []);
          batches[key]!.add(txn);
        }

        final settlements = <_Settlement>[];
        int idx = 0;
        for (final entry in batches.entries) {
          final batchTxns = entry.value;
          final totalAmount = batchTxns.fold<double>(0, (sum, t) => sum + ((t['amount'] as num?)?.toDouble() ?? 0));
          final date = DateTime.tryParse(entry.key) ?? DateTime.now();

          settlements.add(_Settlement(
            id: 'STL-${(1000 + idx).toString()}',
            recipient: 'Platform Revenue',
            recipientType: 'platform',
            amount: totalAmount,
            currency: 'KES',
            status: 'settled',
            createdAt: date,
            settledAt: date.add(const Duration(days: 1)),
            transactionCount: batchTxns.length,
          ));
          idx++;
        }

        // Calculate stats
        final totalSettled = settlements.fold<double>(0, (s, v) => s + v.amount);
        final pendingAmount = txns
            .whereType<Map<String, dynamic>>()
            .where((t) => t['status'] == 'pending')
            .fold<double>(0, (s, t) => s + ((t['amount'] as num?)?.toDouble() ?? 0));

        setState(() {
          _settlements = settlements;
          _stats = {
            'totalSettled': totalSettled,
            'pendingSettlement': pendingAmount,
            'settlementCount': settlements.length,
            'avgSettlement': settlements.isNotEmpty ? totalSettled / settlements.length : 0.0,
          };
          _loading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to fetch settlements'; // keep as fallback
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

  List<_Settlement> get _filteredSettlements {
    var filtered = _settlements;
    if (_statusFilter != 'all') {
      filtered = filtered.where((s) => s.status == _statusFilter).toList();
    }
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      filtered = filtered.where((s) =>
        s.id.toLowerCase().contains(q) ||
        s.recipient.toLowerCase().contains(q)
      ).toList();
    }
    return filtered;
  }

  String _formatCurrency(dynamic v) {
    final num amount = v is num ? v : 0;
    return 'KES ${amount.toStringAsFixed(2)}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredSettlements;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        _buildStatsCards(),
        const SizedBox(height: 24),
        _buildFilters(),
        const SizedBox(height: 24),
        Expanded(child: _buildSettlementsList(filtered)),
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
                  Icon(Icons.account_balance, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminFinanceSettlementsTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminFinanceSettlementsSubtitle,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          IconButton(
            onPressed: _fetchSettlements,
            icon: const Icon(Icons.refresh),
            tooltip: context.l10n.adminFinanceRefresh,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(child: _buildStatCard(context.l10n.adminFinanceTotalSettled, _formatCurrency(_stats['totalSettled'] ?? 0), Icons.check_circle, AppColors.success)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinancePendingSettlement, _formatCurrency(_stats['pendingSettlement'] ?? 0), Icons.pending, AppColors.warning)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinanceSettlementBatches, '${_stats['settlementCount'] ?? 0}', Icons.layers, AppColors.primary)),
          const SizedBox(width: 16),
          Expanded(child: _buildStatCard(context.l10n.adminFinanceAvgSettlement, _formatCurrency(_stats['avgSettlement'] ?? 0), Icons.analytics, AppColors.info)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: context.l10n.adminFinanceSearchSettlementsHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: _statusFilter,
              decoration: InputDecoration(
                labelText: context.l10n.adminFinanceStatus,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: [
                DropdownMenuItem(value: 'all', child: Text(context.l10n.adminFinanceAll)),
                DropdownMenuItem(value: 'settled', child: Text(context.l10n.adminFinanceSettled)),
                DropdownMenuItem(value: 'pending', child: Text(context.l10n.adminFinancePending)),
                DropdownMenuItem(value: 'processing', child: Text(context.l10n.adminFinanceProcessing)),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _statusFilter = v);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementsList(List<_Settlement> settlements) {
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
              onPressed: _fetchSettlements,
              icon: const Icon(Icons.refresh),
              label: Text(context.l10n.adminFinanceRetry),
            ),
          ],
        ),
      );
    }

    if (settlements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(context.l10n.adminFinanceNoSettlementsFound, style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: settlements.map((s) => _buildSettlementCard(s)).toList(),
      ),
    );
  }

  Widget _buildSettlementCard(_Settlement settlement) {
    Color statusColor;
    switch (settlement.status) {
      case 'settled':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'processing':
        statusColor = AppColors.info;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.account_balance, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(settlement.id, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        settlement.status.toUpperCase(),
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${settlement.recipient}  |  ${settlement.transactionCount} transactions',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(settlement.amount),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDate(settlement.createdAt),
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
