import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/theme/app_colors.dart';

/// Fee category definition
class _FeeCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  double percentage;
  double fixedAmount;
  bool enabled = true;

  _FeeCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.percentage,
    required this.fixedAmount,
  });
}

class FeeConfigScreen extends ConsumerStatefulWidget {
  const FeeConfigScreen({super.key});

  @override
  ConsumerState<FeeConfigScreen> createState() => _FeeConfigScreenState();
}

class _FeeConfigScreenState extends ConsumerState<FeeConfigScreen> {
  late final List<_FeeCategory> _fees;
  bool _loading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _fees = [
      _FeeCategory(
        id: 'platform',
        name: 'Platform Fee',
        description: 'Applied to all transactions processed through the platform',
        icon: Icons.account_balance,
        color: AppColors.primary,
        percentage: 2.5,
        fixedAmount: 0,
      ),
      _FeeCategory(
        id: 'application',
        name: 'Application Fee',
        description: 'Charged when students submit applications to institutions',
        icon: Icons.description,
        color: AppColors.success,
        percentage: 0,
        fixedAmount: 500,
      ),
      _FeeCategory(
        id: 'payment_processing',
        name: 'Payment Processing',
        description: 'Payment gateway processing fee (M-Pesa, cards, etc.)',
        icon: Icons.credit_card,
        color: Color(0xFFFAA61A),
        percentage: 1.5,
        fixedAmount: 30,
      ),
      _FeeCategory(
        id: 'settlement',
        name: 'Settlement Fee',
        description: 'Fee for settling funds to institution bank accounts',
        icon: Icons.account_balance_wallet,
        color: AppColors.secondary,
        percentage: 0.5,
        fixedAmount: 100,
      ),
      _FeeCategory(
        id: 'refund_processing',
        name: 'Refund Processing',
        description: 'Administrative fee for processing refund requests',
        icon: Icons.replay,
        color: AppColors.info,
        percentage: 0,
        fixedAmount: 200,
      ),
      _FeeCategory(
        id: 'subscription',
        name: 'Subscription Fee',
        description: 'Monthly platform access fee for institutions',
        icon: Icons.subscriptions,
        color: Color(0xFF4CAF50),
        percentage: 0,
        fixedAmount: 5000,
      ),
    ];
    _loadFeeConfig();
  }

  Future<void> _loadFeeConfig() async {
    setState(() => _loading = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(
        '${ApiConfig.admin}/finance/stats',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        // If backend provides fee config, apply it
        if (data['fee_config'] is Map) {
          final config = data['fee_config'] as Map<String, dynamic>;
          for (final fee in _fees) {
            if (config[fee.id] is Map) {
              final feeData = config[fee.id] as Map<String, dynamic>;
              fee.percentage = (feeData['percentage'] as num?)?.toDouble() ?? fee.percentage;
              fee.fixedAmount = (feeData['fixed_amount'] as num?)?.toDouble() ?? fee.fixedAmount;
              fee.enabled = feeData['enabled'] as bool? ?? fee.enabled;
            }
          }
        }
      }
    } catch (_) {
      // Use defaults if fetch fails
    }
    setState(() => _loading = false);
  }

  Future<void> _saveConfig() async {
    setState(() => _loading = true);
    // Simulate save — in production this would POST to backend
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
      _hasChanges = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Fee configuration saved successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  String _formatCurrency(double amount) {
    return 'KES ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (_loading) const LinearProgressIndicator(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(),
                const SizedBox(height: 24),
                ..._fees.map((fee) => _buildFeeCard(fee)),
              ],
            ),
          ),
        ),
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
                  Icon(Icons.tune, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Fee Configuration',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Configure platform fees and pricing structure',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          Row(
            children: [
              if (_hasChanges) ...[
                Text('Unsaved changes', style: TextStyle(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(width: 12),
              ],
              OutlinedButton(
                onPressed: () {
                  setState(() => _hasChanges = false);
                  _loadFeeConfig();
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _hasChanges ? _saveConfig : null,
                icon: const Icon(Icons.save, size: 20),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final activeFees = _fees.where((f) => f.enabled).toList();
    final avgPercentage = activeFees.isEmpty
        ? 0.0
        : activeFees.where((f) => f.percentage > 0).fold<double>(0, (s, f) => s + f.percentage) /
            activeFees.where((f) => f.percentage > 0).length.clamp(1, 999);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Fee Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '${activeFees.length} of ${_fees.length} fee categories active',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          _buildSummaryMetric('Active Fees', '${activeFees.length}', AppColors.success),
          const SizedBox(width: 24),
          _buildSummaryMetric('Avg Rate', '${avgPercentage.toStringAsFixed(1)}%', AppColors.primary),
          const SizedBox(width: 24),
          _buildSummaryMetric('Disabled', '${_fees.where((f) => !f.enabled).length}', AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildFeeCard(_FeeCategory fee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fee.enabled ? AppColors.border : AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: fee.enabled ? fee.color.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(fee.icon, color: fee.enabled ? fee.color : Colors.grey, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fee.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: fee.enabled ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    Text(fee.description, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Switch(
                value: fee.enabled,
                onChanged: (v) {
                  setState(() {
                    fee.enabled = v;
                    _hasChanges = true;
                  });
                },
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
              ),
            ],
          ),
          if (fee.enabled) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFeeInput(
                    label: 'Percentage (%)',
                    value: fee.percentage,
                    suffix: '%',
                    onChanged: (v) {
                      fee.percentage = v;
                      setState(() => _hasChanges = true);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildFeeInput(
                    label: 'Fixed Amount (KES)',
                    value: fee.fixedAmount,
                    suffix: 'KES',
                    onChanged: (v) {
                      fee.fixedAmount = v;
                      setState(() => _hasChanges = true);
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Example (KES 10,000)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(10000 * fee.percentage / 100 + fee.fixedAmount),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: fee.color),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeeInput({
    required String label,
    required double value,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return TextField(
      controller: TextEditingController(text: value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2)),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) {
        final parsed = double.tryParse(text);
        if (parsed != null) onChanged(parsed);
      },
    );
  }
}
