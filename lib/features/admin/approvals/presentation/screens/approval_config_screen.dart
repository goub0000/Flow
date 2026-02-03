import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n_extension.dart';
import '../../models/approval_models.dart';
import '../../providers/approvals_provider.dart';

/// Screen displaying and editing approval workflow configurations
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
        title: Text(context.l10n.adminApprovalConfiguration),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(approvalConfigProvider.notifier).refresh(),
            tooltip: context.l10n.adminApprovalRefresh,
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
              Text(context.l10n.adminApprovalFailedToLoadConfigurations,
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(state.error!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    ref.read(approvalConfigProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: Text(context.l10n.adminApprovalRetry),
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
            Text(context.l10n.adminApprovalNoConfigurationsFound,
                style: theme.textTheme.titleMedium),
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
            _ConfigCard(config: state.configs[index]),
      ),
    );
  }
}

class _ConfigCard extends ConsumerWidget {
  final ApprovalConfig config;

  const _ConfigCard({required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final actionLabel = config.actionType.replaceAll('_', ' ').toUpperCase();
    final typeLabel = config.requestType.replaceAll('_', ' ');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with edit button
            Row(
              children: [
                Expanded(
                  child: Text(actionLabel,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ),
                _StatusChip(isActive: config.isActive),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  tooltip: context.l10n.adminApprovalEditConfiguration,
                  onPressed: () => _showEditDialog(context, ref),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text('${context.l10n.adminApprovalType}: $typeLabel',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.outline)),
            if (config.description != null && config.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(config.description!, style: theme.textTheme.bodyMedium),
            ],
            const Divider(height: 24),

            // Settings
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _InfoChip(
                    label: context.l10n.adminApprovalApprovalLevel,
                    value: config.requiredApprovalLevel.toString(),
                    icon: Icons.security),
                _InfoChip(
                    label: context.l10n.adminApprovalPriority,
                    value: config.defaultPriority,
                    icon: Icons.flag),
                if (config.defaultExpirationHours != null)
                  _InfoChip(
                      label: context.l10n.adminApprovalExpires,
                      value: '${config.defaultExpirationHours}h',
                      icon: Icons.timer),
                _InfoChip(
                    label: context.l10n.adminApprovalAutoExecute,
                    value: config.autoExecute ? context.l10n.adminApprovalYes : context.l10n.adminApprovalNo,
                    icon: Icons.play_circle_outline),
                _InfoChip(
                    label: context.l10n.adminApprovalMfaRequired,
                    value: config.requiresMfa ? context.l10n.adminApprovalYes : context.l10n.adminApprovalNo,
                    icon: Icons.verified_user),
                _InfoChip(
                    label: context.l10n.adminApprovalSkipLevels,
                    value: config.canSkipLevels ? context.l10n.adminApprovalAllowed : context.l10n.adminApprovalNo,
                    icon: Icons.skip_next),
              ],
            ),

            // Roles
            if (config.allowedInitiatorRoles.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(context.l10n.adminApprovalInitiatorRoles,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: config.allowedInitiatorRoles
                    .map((r) => Chip(
                        label: Text(r.replaceAll('_', ' ')),
                        visualDensity: VisualDensity.compact,
                        labelStyle: theme.textTheme.labelSmall))
                    .toList(),
              ),
            ],
            if (config.allowedApproverRoles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(context.l10n.adminApprovalApproverRoles,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: config.allowedApproverRoles
                    .map((r) => Chip(
                        label: Text(r.replaceAll('_', ' ')),
                        visualDensity: VisualDensity.compact,
                        labelStyle: theme.textTheme.labelSmall))
                    .toList(),
              ),
            ],

            // Notification channels
            if (config.notificationChannels.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(context.l10n.adminApprovalNotifications,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline)),
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
                                    : ch == 'push'
                                        ? Icons.notifications_active
                                        : Icons.notifications,
                            size: 16),
                        label: Text(ch),
                        visualDensity: VisualDensity.compact,
                        labelStyle: theme.textTheme.labelSmall))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => _EditConfigDialog(config: config, ref: ref),
    );
  }
}

class _EditConfigDialog extends StatefulWidget {
  final ApprovalConfig config;
  final WidgetRef ref;

  const _EditConfigDialog({required this.config, required this.ref});

  @override
  State<_EditConfigDialog> createState() => _EditConfigDialogState();
}

class _EditConfigDialogState extends State<_EditConfigDialog> {
  late bool _isActive;
  late bool _canSkipLevels;
  late bool _requiresMfa;
  late bool _autoExecute;
  late String _defaultPriority;
  late TextEditingController _expirationController;
  late TextEditingController _descriptionController;
  late bool _notifyInApp;
  late bool _notifyEmail;
  late bool _notifyPush;
  late bool _notifySms;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isActive = widget.config.isActive;
    _canSkipLevels = widget.config.canSkipLevels;
    _requiresMfa = widget.config.requiresMfa;
    _autoExecute = widget.config.autoExecute;
    _defaultPriority = widget.config.defaultPriority;
    _expirationController = TextEditingController(
        text: widget.config.defaultExpirationHours?.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.config.description ?? '');
    _notifyInApp = widget.config.notificationChannels.contains('in_app');
    _notifyEmail = widget.config.notificationChannels.contains('email');
    _notifyPush = widget.config.notificationChannels.contains('push');
    _notifySms = widget.config.notificationChannels.contains('sms');
  }

  @override
  void dispose() {
    _expirationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildUpdates() {
    final updates = <String, dynamic>{};
    final c = widget.config;

    if (_isActive != c.isActive) updates['is_active'] = _isActive;
    if (_canSkipLevels != c.canSkipLevels) {
      updates['can_skip_levels'] = _canSkipLevels;
    }
    if (_requiresMfa != c.requiresMfa) updates['requires_mfa'] = _requiresMfa;
    if (_autoExecute != c.autoExecute) updates['auto_execute'] = _autoExecute;
    if (_defaultPriority != c.defaultPriority) {
      updates['default_priority'] = _defaultPriority;
    }

    final expText = _expirationController.text.trim();
    final newExp = expText.isEmpty ? null : int.tryParse(expText);
    if (newExp != c.defaultExpirationHours) {
      updates['default_expiration_hours'] = newExp;
    }

    final descText = _descriptionController.text.trim();
    final oldDesc = c.description ?? '';
    if (descText != oldDesc) updates['description'] = descText;

    final channels = <String>[
      if (_notifyInApp) 'in_app',
      if (_notifyEmail) 'email',
      if (_notifyPush) 'push',
      if (_notifySms) 'sms',
    ];
    final oldChannels = List<String>.from(c.notificationChannels)..sort();
    final newChannels = List<String>.from(channels)..sort();
    if (oldChannels.join(',') != newChannels.join(',')) {
      updates['notification_channels'] = channels;
    }

    return updates;
  }

  Future<void> _save() async {
    final updates = _buildUpdates();
    if (updates.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() => _saving = true);
    final success = await widget.ref
        .read(approvalConfigProvider.notifier)
        .updateConfig(widget.config.id, updates);

    if (!mounted) return;
    setState(() => _saving = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.adminApprovalConfigurationUpdated)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminApprovalFailedToUpdateConfiguration),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionLabel =
        widget.config.actionType.replaceAll('_', ' ').toUpperCase();

    return AlertDialog(
      title: Text('${context.l10n.adminApprovalEdit}: $actionLabel',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: context.l10n.adminApprovalDescription,
                  hintText: context.l10n.adminApprovalDescribeWorkflow,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Priority
              DropdownButtonFormField<String>(
                initialValue: _defaultPriority,
                decoration: InputDecoration(
                  labelText: context.l10n.adminApprovalDefaultPriority,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'low', child: Text(context.l10n.adminApprovalPriorityLow)),
                  DropdownMenuItem(value: 'normal', child: Text(context.l10n.adminApprovalPriorityNormal)),
                  DropdownMenuItem(value: 'high', child: Text(context.l10n.adminApprovalPriorityHigh)),
                  DropdownMenuItem(value: 'urgent', child: Text(context.l10n.adminApprovalPriorityUrgent)),
                ],
                onChanged: (v) => setState(() => _defaultPriority = v!),
              ),
              const SizedBox(height: 16),

              // Expiration
              TextField(
                controller: _expirationController,
                decoration: InputDecoration(
                  labelText: context.l10n.adminApprovalExpirationHours,
                  hintText: context.l10n.adminApprovalLeaveEmptyNoExpiration,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Toggle switches
              Text(context.l10n.adminApprovalSettings,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(context.l10n.adminApprovalActive),
                subtitle: Text(context.l10n.adminApprovalEnableDisableWorkflow),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: Text(context.l10n.adminApprovalAutoExecuteTitle),
                subtitle: Text(context.l10n.adminApprovalAutoExecuteSubtitle),
                value: _autoExecute,
                onChanged: (v) => setState(() => _autoExecute = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: Text(context.l10n.adminApprovalRequireMfa),
                subtitle: Text(context.l10n.adminApprovalRequireMfaSubtitle),
                value: _requiresMfa,
                onChanged: (v) => setState(() => _requiresMfa = v),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                title: Text(context.l10n.adminApprovalAllowLevelSkipping),
                subtitle: Text(context.l10n.adminApprovalAllowLevelSkippingSubtitle),
                value: _canSkipLevels,
                onChanged: (v) => setState(() => _canSkipLevels = v),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 16),

              // Notification channels
              Text(context.l10n.adminApprovalNotificationChannels,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              CheckboxListTile(
                title: Text(context.l10n.adminApprovalInApp),
                value: _notifyInApp,
                onChanged: (v) => setState(() => _notifyInApp = v!),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text(context.l10n.adminApprovalEmail),
                value: _notifyEmail,
                onChanged: (v) => setState(() => _notifyEmail = v!),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text(context.l10n.adminApprovalPush),
                value: _notifyPush,
                onChanged: (v) => setState(() => _notifyPush = v!),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: Text(context.l10n.adminApprovalSms),
                value: _notifySms,
                onChanged: (v) => setState(() => _notifySms = v!),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(context.l10n.adminApprovalCancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(context.l10n.adminApprovalSaveChanges),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isActive;

  const _StatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? context.l10n.adminApprovalStatusActive : context.l10n.adminApprovalStatusInactive,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Text('$label: ',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.outline)),
          Text(value,
              style: theme.textTheme.labelSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
