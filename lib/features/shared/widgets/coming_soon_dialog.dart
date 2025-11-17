import 'package:flutter/material.dart';
import 'package:flow_edtech/core/theme/app_colors.dart';

/// A reusable dialog widget to show for features that are not yet implemented.
///
/// Usage:
/// ```dart
/// ComingSoonDialog.show(context, featureName: 'Messaging');
/// ```
class ComingSoonDialog extends StatelessWidget {
  final String featureName;
  final String? customMessage;

  const ComingSoonDialog({
    super.key,
    this.featureName = 'This feature',
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.construction,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Coming Soon',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customMessage ?? '$featureName is currently under development and will be available in a future update.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Stay tuned for updates!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text('Got it'),
        ),
      ],
    );
  }

  /// Static method to show the dialog easily
  static Future<void> show(
    BuildContext context, {
    String featureName = 'This feature',
    String? customMessage,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ComingSoonDialog(
        featureName: featureName,
        customMessage: customMessage,
      ),
    );
  }
}