import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../services/keyboard_shortcuts_service.dart';

/// Keyboard Shortcuts Help Dialog
/// Shows all available keyboard shortcuts in the admin dashboard
class KeyboardShortcutsDialog extends StatelessWidget {
  const KeyboardShortcutsDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const KeyboardShortcutsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortcuts = _getShortcutGroups();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.keyboard,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Keyboard Shortcuts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Speed up your workflow with keyboard shortcuts',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shortcuts List
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: shortcuts.entries.map((entry) {
                    return _buildShortcutGroup(
                      entry.key,
                      entry.value,
                    );
                  }).toList(),
                ),
              ),
            ),

            // Footer
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Press Shift + ? anywhere to view this dialog',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutGroup(String title, List<ShortcutItem> shortcuts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ...shortcuts.map((shortcut) => _buildShortcutRow(shortcut)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildShortcutRow(ShortcutItem shortcut) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              shortcut.description,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          _buildShortcutKeys(shortcut.keys),
        ],
      ),
    );
  }

  Widget _buildShortcutKeys(List<String> keys) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: keys.asMap().entries.map((entry) {
        final index = entry.key;
        final key = entry.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (index > 0) ...[
              const SizedBox(width: 4),
              Text(
                '+',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                key,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Map<String, List<ShortcutItem>> _getShortcutGroups() {
    return {
      'General': [
        ShortcutItem(['Ctrl', 'K'], 'Focus search bar'),
        ShortcutItem(['Ctrl', '/'], 'Toggle sidebar'),
        ShortcutItem(['Shift', '?'], 'Show keyboard shortcuts'),
        ShortcutItem(['Ctrl', 'H'], 'Show quick actions'),
        ShortcutItem(['Esc'], 'Close dialog/menu'),
      ],
      'Navigation': [
        ShortcutItem(['Ctrl', 'Alt', 'D'], 'Go to dashboard'),
        ShortcutItem(['Ctrl', 'F'], 'Refresh current page'),
      ],
      'Actions': [
        ShortcutItem(['Ctrl', 'N'], 'Create new item'),
        ShortcutItem(['Ctrl', 'S'], 'Save changes'),
        ShortcutItem(['Ctrl', 'P'], 'Print current view'),
        ShortcutItem(['Ctrl', 'Shift', 'E'], 'Export data'),
      ],
    };
  }
}

/// Shortcut Item Model
class ShortcutItem {
  final List<String> keys;
  final String description;

  ShortcutItem(this.keys, this.description);
}
