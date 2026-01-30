import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/approval_models.dart';
import '../../providers/approvals_provider.dart';

/// Screen displaying approval workflow configurations
class ApprovalConfigScreen extends ConsumerStatefulWidget {
  const ApprovalConfigScreen({super.key});

  @override
  ConsumerState<ApprovalConfigScreen> createState() =>
      _ApprovalConfigScreenState();
}

class _ApprovalConfigScreenState extends ConsumerState<ApprovalConfigScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(approvalConfigProvider.notifier).fetchConfigs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(approvalConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/approvals'),
        ),
        title: const Text('Approval Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(approvalConfigProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(state, theme),
    );
  }

  Widget _buildBody(ApprovalConfigState state, ThemeData theme) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load configurations',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(approvalConfigProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.configs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings_outlined,
                size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              'No configurations found',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Approval workflow configurations will appear here.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(approvalConfigProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.configs.length,
        itemBuilder: (context, index) =>
            _buildConfigCard(state.configs[index], theme),
      ),
    );
  }

  Widget _buildConfigCard(ApprovalConfig config, ThemeData theme) {
    final actionLabel =
        config.actionType.replaceAll('_', ' ').toUpperCase();
    final typeLabel =
        config.requestType.replaceAll('_', ' ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusChip(config.isActive, theme),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Type: $typeLabel',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            if (config.description != null) ...[
              const SizedBox(height: 8),
              Text(
                config.description!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            const Divider(height: 24),

            // Settings grid
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildInfoChip(
                  'Approval Level',
                  config.requiredApprovalLevel.toString(),
                  Icons.security,
                  theme,
                ),
                _buildInfoChip(
                  'Priority',
                  config.defaultPriority,
                  Icons.flag,
                  theme,
                ),
                if (config.defaultExpirationHours != null)
                  _buildInfoChip(
                    'Expires',
                    '${config.defaultExpirationHours}h',
                    Icons.timer,
                    theme,
                  ),
                _buildInfoChip(
                  'Auto Execute',
                  config.autoExecute ? 'Yes' : 'No',
                  Icons.play_circle_outline,
                  theme,
                ),
                _buildInfoChip(
                  'MFA Required',
                  config.requiresMfa ? 'Yes' : 'No',
                  Icons.verified_user,
                  theme,
                ),
                _buildInfoChip(
                  'Skip Levels',
                  config.canSkipLevels ? 'Allowed' : 'No',
                  Icons.skip_next,
                  theme,
                ),
              ],
            ),

            // Roles
            if (config.allowedInitiatorRoles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Initiator Roles',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: config.allowedInitiatorRoles
                    .map((role) => Chip(
                          label: Text(role.replaceAll('_', ' ')),
                          visualDensity: VisualDensity.compact,
                          labelStyle: theme.textTheme.labelSmall,
                        ))
                    .toList(),
              ),
            ],
            if (config.allowedApproverRoles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Approver Roles',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: config.allowedApproverRoles
                    .map((role) => Chip(
                          label: Text(role.replaceAll('_', ' ')),
                          visualDensity: VisualDensity.compact,
                          labelStyle: theme.textTheme.labelSmall,
                        ))
                    .toList(),
              ),
            ],

            // Notification channels
            if (config.notificationChannels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Notifications',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: config.notificationChannels
                    .map((ch) => Chip(
                          avatar: Icon(
                            ch == 'email'
                                ? Icons.email
                                : ch == 'sms'
                                    ? Icons.sms
                                    : Icons.notifications,
                            size: 16,
                          ),
                          label: Text(ch),
                          visualDensity: VisualDensity.compact,
                          labelStyle: theme.textTheme.labelSmall,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(bool isActive, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: theme.textTheme.labelSmall?.copyWith(
          color: isActive ? Colors.green : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      String label, String value, IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.outline),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
