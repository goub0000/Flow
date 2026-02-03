import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';

/// Action bar that appears when items are selected in a data table
class BulkActionBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final List<BulkAction> actions;
  final bool isProcessing;

  const BulkActionBar({
    super.key,
    required this.selectedCount,
    required this.onClearSelection,
    required this.actions,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Selection count
          Builder(
            builder: (context) => Text(
              context.l10n.adminSharedItemsSelected(selectedCount),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Clear selection button
          Builder(
            builder: (context) => TextButton.icon(
              onPressed: isProcessing ? null : onClearSelection,
              icon: const Icon(Icons.close, size: 18),
              label: Text(context.l10n.adminSharedClear),
            ),
          ),

          const Spacer(),

          // Action buttons
          if (isProcessing)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            ...actions.map((action) {
              return Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildActionButton(context, action),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BulkAction action) {
    final isDestructive = action.isDestructive;

    if (isDestructive) {
      return OutlinedButton.icon(
        onPressed: action.onPressed,
        icon: Icon(action.icon, size: 18),
        label: Text(action.label),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: action.onPressed,
      icon: Icon(action.icon, size: 18),
      label: Text(action.label),
    );
  }
}

/// Represents a bulk action button
class BulkAction {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDestructive;

  const BulkAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
  });
}
