import 'package:flutter/material.dart';

import '../../../../../core/l10n_extension.dart';
import '../../models/approval_models.dart';

/// Dialog for filtering approval requests
class ApprovalFilterDialog extends StatefulWidget {
  final ApprovalRequestFilter? currentFilter;
  final void Function(ApprovalRequestFilter) onApply;

  const ApprovalFilterDialog({
    super.key,
    this.currentFilter,
    required this.onApply,
  });

  @override
  State<ApprovalFilterDialog> createState() => _ApprovalFilterDialogState();
}

class _ApprovalFilterDialogState extends State<ApprovalFilterDialog> {
  late List<ApprovalStatus> _selectedStatus;
  late List<ApprovalPriority> _selectedPriority;
  late List<ApprovalRequestType> _selectedRequestType;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentFilter?.status?.toList() ?? [];
    _selectedPriority = widget.currentFilter?.priority?.toList() ?? [];
    _selectedRequestType = widget.currentFilter?.requestType?.toList() ?? [];
    _searchController.text = widget.currentFilter?.search ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.adminApprovalFilterRequests),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Search
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: context.l10n.adminApprovalSearch,
                  hintText: context.l10n.adminApprovalSearchHint,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Status filter
              Text(
                context.l10n.adminApprovalStatus,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ApprovalStatus.values.map((status) {
                  final isSelected = _selectedStatus.contains(status);
                  return FilterChip(
                    label: Text(status.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedStatus.add(status);
                        } else {
                          _selectedStatus.remove(status);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Priority filter
              Text(
                context.l10n.adminApprovalPriority,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ApprovalPriority.values.map((priority) {
                  final isSelected = _selectedPriority.contains(priority);
                  return FilterChip(
                    label: Text(priority.displayName),
                    selected: isSelected,
                    selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedPriority.add(priority);
                        } else {
                          _selectedPriority.remove(priority);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Request type filter
              Text(
                context.l10n.adminApprovalRequestType,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ApprovalRequestType.values.map((type) {
                  final isSelected = _selectedRequestType.contains(type);
                  return FilterChip(
                    label: Text(_getRequestTypeDisplayName(type)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedRequestType.add(type);
                        } else {
                          _selectedRequestType.remove(type);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _selectedStatus.clear();
              _selectedPriority.clear();
              _selectedRequestType.clear();
              _searchController.clear();
            });
          },
          child: Text(context.l10n.adminApprovalClearAll),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.adminApprovalCancel),
        ),
        FilledButton(
          onPressed: _applyFilter,
          child: Text(context.l10n.adminApprovalApply),
        ),
      ],
    );
  }

  void _applyFilter() {
    final filter = ApprovalRequestFilter(
      status: _selectedStatus.isNotEmpty ? _selectedStatus : null,
      priority: _selectedPriority.isNotEmpty ? _selectedPriority : null,
      requestType: _selectedRequestType.isNotEmpty ? _selectedRequestType : null,
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
    );
    widget.onApply(filter);
  }

  Color _getPriorityColor(ApprovalPriority priority) {
    switch (priority) {
      case ApprovalPriority.urgent:
        return Colors.red;
      case ApprovalPriority.high:
        return Colors.orange;
      case ApprovalPriority.normal:
        return Colors.blue;
      case ApprovalPriority.low:
        return Colors.grey;
    }
  }

  String _getRequestTypeDisplayName(ApprovalRequestType type) {
    switch (type) {
      case ApprovalRequestType.userManagement:
        return context.l10n.adminApprovalTypeUserManagement;
      case ApprovalRequestType.contentManagement:
        return context.l10n.adminApprovalTypeContent;
      case ApprovalRequestType.financial:
        return context.l10n.adminApprovalTypeFinancial;
      case ApprovalRequestType.system:
        return context.l10n.adminApprovalTypeSystem;
      case ApprovalRequestType.notifications:
        return context.l10n.adminApprovalTypeNotifications;
      case ApprovalRequestType.dataExport:
        return context.l10n.adminApprovalTypeDataExport;
      case ApprovalRequestType.adminManagement:
        return context.l10n.adminApprovalTypeAdminManagement;
    }
  }
}
