import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';

class QuickReplies extends StatelessWidget {
  final List<QuickAction> actions;
  final Function(String) onActionTap;

  const QuickReplies({
    super.key,
    required this.actions,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: actions.map((action) => _buildActionChip(action)).toList(),
      ),
    );
  }

  Widget _buildActionChip(QuickAction action) {
    return ActionChip(
      label: Text(
        action.label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      avatar: action.icon != null
          ? Icon(action.icon, size: 16, color: AppColors.primary)
          : null,
      onPressed: () => onActionTap(action.action),
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: AppColors.primary),
      side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}
