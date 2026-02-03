import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/l10n_extension.dart';
import '../../models/approval_models.dart';
import '../../providers/approvals_provider.dart';

/// Screen for creating a new approval request
class CreateApprovalRequestScreen extends ConsumerStatefulWidget {
  const CreateApprovalRequestScreen({super.key});

  @override
  ConsumerState<CreateApprovalRequestScreen> createState() =>
      _CreateApprovalRequestScreenState();
}

class _CreateApprovalRequestScreenState
    extends ConsumerState<CreateApprovalRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _justificationController = TextEditingController();

  ApprovalRequestType _selectedRequestType = ApprovalRequestType.userManagement;
  String _selectedActionType = 'create_user';
  ApprovalPriority _selectedPriority = ApprovalPriority.normal;
  String _targetResourceType = 'user';
  String? _targetResourceId;

  bool _isSubmitting = false;

  // Action types grouped by request type
  final Map<ApprovalRequestType, List<Map<String, String>>> _actionTypes = {
    ApprovalRequestType.userManagement: [
      {'value': 'create_user', 'label': 'Create User'},
      {'value': 'delete_user_account', 'label': 'Delete User Account'},
      {'value': 'suspend_user_account', 'label': 'Suspend User Account'},
      {'value': 'unsuspend_user_account', 'label': 'Unsuspend User Account'},
      {'value': 'grant_admin_role', 'label': 'Grant Admin Role'},
      {'value': 'revoke_admin_role', 'label': 'Revoke Admin Role'},
      {'value': 'modify_user_permissions', 'label': 'Modify User Permissions'},
    ],
    ApprovalRequestType.contentManagement: [
      {'value': 'publish_content', 'label': 'Publish Content'},
      {'value': 'unpublish_content', 'label': 'Unpublish Content'},
      {'value': 'delete_content', 'label': 'Delete Content'},
      {'value': 'delete_program', 'label': 'Delete Program'},
      {'value': 'delete_institution_content', 'label': 'Delete Institution Content'},
    ],
    ApprovalRequestType.financial: [
      {'value': 'process_large_refund', 'label': 'Process Large Refund'},
      {'value': 'modify_fee_structure', 'label': 'Modify Fee Structure'},
      {'value': 'void_transaction', 'label': 'Void Transaction'},
    ],
    ApprovalRequestType.notifications: [
      {'value': 'send_bulk_notification', 'label': 'Send Bulk Notification'},
      {'value': 'send_platform_announcement', 'label': 'Send Platform Announcement'},
    ],
    ApprovalRequestType.dataExport: [
      {'value': 'export_sensitive_data', 'label': 'Export Sensitive Data'},
      {'value': 'export_user_data', 'label': 'Export User Data'},
    ],
    ApprovalRequestType.system: [
      {'value': 'modify_system_settings', 'label': 'Modify System Settings'},
      {'value': 'clear_cache', 'label': 'Clear Cache'},
    ],
    ApprovalRequestType.adminManagement: [
      {'value': 'create_admin', 'label': 'Create Admin'},
      {'value': 'modify_admin', 'label': 'Modify Admin'},
    ],
  };

  @override
  void dispose() {
    _justificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.adminApprovalCreateRequest),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/approvals'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Request Type
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.adminApprovalRequestType,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ApprovalRequestType>(
                        value: _selectedRequestType,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminApprovalCategory,
                          border: const OutlineInputBorder(),
                        ),
                        items: ApprovalRequestType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedRequestType = value;
                              _selectedActionType =
                                  _actionTypes[value]!.first['value']!;
                              _updateTargetResourceType();
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedActionType,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminApprovalAction,
                          border: const OutlineInputBorder(),
                        ),
                        items: _actionTypes[_selectedRequestType]!.map((action) {
                          return DropdownMenuItem(
                            value: action['value'],
                            child: Text(action['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedActionType = value;
                              _updateTargetResourceType();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Priority
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.adminApprovalPriority,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: ApprovalPriority.values.map((priority) {
                          final isSelected = _selectedPriority == priority;
                          return ChoiceChip(
                            label: Text(priority.displayName),
                            selected: isSelected,
                            selectedColor: priority.color.withOpacity(0.2),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedPriority = priority;
                                });
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Target Resource
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.adminApprovalTargetResource,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: context.l10n.adminApprovalResourceType,
                          border: const OutlineInputBorder(),
                          enabled: false,
                          hintText: _targetResourceType,
                        ),
                        initialValue: _targetResourceType,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: context.l10n.adminApprovalResourceIdOptional,
                          hintText: context.l10n.adminApprovalEnterResourceId,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _targetResourceId = value.isEmpty ? null : value;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Justification
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.adminApprovalJustification,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.adminApprovalJustificationDescription,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _justificationController,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminApprovalJustification,
                          hintText: context.l10n.adminApprovalJustificationHint,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.l10n.adminApprovalPleaseProvideJustification;
                          }
                          if (value.trim().length < 20) {
                            return context.l10n.adminApprovalJustificationMinLength;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () => context.go('/admin/approvals'),
                      child: Text(context.l10n.adminApprovalCancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSubmitting ? null : _submitRequest,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(context.l10n.adminApprovalSubmitRequest),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTargetResourceType() {
    if (_selectedActionType.contains('user') ||
        _selectedActionType.contains('admin')) {
      _targetResourceType = 'user';
    } else if (_selectedActionType.contains('content') ||
        _selectedActionType.contains('program')) {
      _targetResourceType = 'content';
    } else if (_selectedActionType.contains('refund') ||
        _selectedActionType.contains('fee') ||
        _selectedActionType.contains('transaction')) {
      _targetResourceType = 'transaction';
    } else if (_selectedActionType.contains('notification') ||
        _selectedActionType.contains('announcement')) {
      _targetResourceType = 'notification';
    } else if (_selectedActionType.contains('export') ||
        _selectedActionType.contains('data')) {
      _targetResourceType = 'data';
    } else if (_selectedActionType.contains('system') ||
        _selectedActionType.contains('cache')) {
      _targetResourceType = 'system';
    } else if (_selectedActionType.contains('institution')) {
      _targetResourceType = 'institution';
    }
  }

  void _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final createRequest = ApprovalRequestCreate(
        requestType: _selectedRequestType.name,
        actionType: _selectedActionType,
        targetResourceType: _targetResourceType,
        targetResourceId: _targetResourceId,
        justification: _justificationController.text.trim(),
        priority: _selectedPriority.name,
        actionPayload: {},
      );

      await ref.read(approvalsListProvider.notifier).createRequest(createRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminApprovalRequestSubmittedSuccess),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/admin/approvals');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.adminApprovalErrorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
