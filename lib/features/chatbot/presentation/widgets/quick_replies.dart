import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/chat_message.dart';

/// Quick Action Types for different styling
enum QuickActionType {
  navigation, // Navigates to another page
  info,       // Provides information
  action,     // Performs an action
  urgent,     // Urgent/important action
}

/// Smart Quick Replies widget with dynamic action support
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
    final actionType = _getActionType(action.action);
    final colors = _getActionColors(actionType);

    return ActionChip(
      label: Text(
        action.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: colors.foreground,
        ),
      ),
      avatar: action.icon != null
          ? Icon(action.icon, size: 16, color: colors.foreground)
          : _getDefaultIcon(actionType, colors.foreground),
      onPressed: () => onActionTap(action.action),
      backgroundColor: colors.background,
      side: BorderSide(color: colors.border),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  QuickActionType _getActionType(String action) {
    if (action.startsWith('navigate_') || action.contains('_page')) {
      return QuickActionType.navigation;
    }
    if (action.startsWith('urgent_') || action.contains('escalate')) {
      return QuickActionType.urgent;
    }
    if (action.startsWith('info_') || action.contains('about') || action.contains('help')) {
      return QuickActionType.info;
    }
    return QuickActionType.action;
  }

  Widget? _getDefaultIcon(QuickActionType type, Color color) {
    IconData? iconData;
    switch (type) {
      case QuickActionType.navigation:
        iconData = Icons.arrow_forward;
        break;
      case QuickActionType.info:
        iconData = Icons.info_outline;
        break;
      case QuickActionType.action:
        iconData = Icons.touch_app;
        break;
      case QuickActionType.urgent:
        iconData = Icons.priority_high;
        break;
    }
    return Icon(iconData, size: 16, color: color);
  }

  _ActionColors _getActionColors(QuickActionType type) {
    switch (type) {
      case QuickActionType.navigation:
        return _ActionColors(
          background: AppColors.primary.withValues(alpha: 0.1),
          foreground: AppColors.primary,
          border: AppColors.primary.withValues(alpha: 0.3),
        );
      case QuickActionType.info:
        return _ActionColors(
          background: AppColors.info.withValues(alpha: 0.1),
          foreground: AppColors.info,
          border: AppColors.info.withValues(alpha: 0.3),
        );
      case QuickActionType.action:
        return _ActionColors(
          background: AppColors.success.withValues(alpha: 0.1),
          foreground: AppColors.success,
          border: AppColors.success.withValues(alpha: 0.3),
        );
      case QuickActionType.urgent:
        return _ActionColors(
          background: AppColors.warning.withValues(alpha: 0.1),
          foreground: AppColors.warning,
          border: AppColors.warning.withValues(alpha: 0.3),
        );
    }
  }
}

class _ActionColors {
  final Color background;
  final Color foreground;
  final Color border;

  _ActionColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

/// Smart Quick Actions Generator
/// Generates context-aware quick actions based on user state
class SmartQuickActions {
  /// Generate quick actions based on current page
  static List<QuickAction> getPageActions(String? currentPage) {
    if (currentPage == null) return getDefaultActions();

    final page = currentPage.toLowerCase();

    if (page.contains('dashboard')) {
      return [
        const QuickAction(
          id: 'recommendations',
          label: 'View Recommendations',
          action: 'navigate_recommendations',
          icon: Icons.school,
        ),
        const QuickAction(
          id: 'questionnaire',
          label: 'Update Profile',
          action: 'navigate_questionnaire',
          icon: Icons.person,
        ),
        const QuickAction(
          id: 'applications',
          label: 'My Applications',
          action: 'navigate_applications',
          icon: Icons.description,
        ),
      ];
    }

    if (page.contains('recommendation')) {
      return [
        const QuickAction(
          id: 'compare',
          label: 'Compare Schools',
          action: 'action_compare_schools',
          icon: Icons.compare_arrows,
        ),
        const QuickAction(
          id: 'filter',
          label: 'Filter Results',
          action: 'action_filter_recommendations',
          icon: Icons.filter_list,
        ),
        const QuickAction(
          id: 'explain',
          label: 'Why These Schools?',
          action: 'info_explain_recommendations',
          icon: Icons.help_outline,
        ),
      ];
    }

    if (page.contains('application')) {
      return [
        const QuickAction(
          id: 'deadlines',
          label: 'View Deadlines',
          action: 'action_view_deadlines',
          icon: Icons.calendar_today,
        ),
        const QuickAction(
          id: 'essay_tips',
          label: 'Essay Tips',
          action: 'info_essay_tips',
          icon: Icons.edit_note,
        ),
        const QuickAction(
          id: 'checklist',
          label: 'Application Checklist',
          action: 'info_application_checklist',
          icon: Icons.checklist,
        ),
      ];
    }

    if (page.contains('questionnaire') || page.contains('profile')) {
      return [
        const QuickAction(
          id: 'help',
          label: 'Help with Questions',
          action: 'info_questionnaire_help',
          icon: Icons.help,
        ),
        const QuickAction(
          id: 'skip_tip',
          label: 'Can I Skip Sections?',
          action: 'info_skip_sections',
          icon: Icons.skip_next,
        ),
      ];
    }

    if (page.contains('university')) {
      return [
        const QuickAction(
          id: 'apply',
          label: 'Start Application',
          action: 'action_start_application',
          icon: Icons.send,
        ),
        const QuickAction(
          id: 'save',
          label: 'Save to Favorites',
          action: 'action_save_favorite',
          icon: Icons.favorite_border,
        ),
        const QuickAction(
          id: 'similar',
          label: 'Similar Schools',
          action: 'action_find_similar',
          icon: Icons.search,
        ),
      ];
    }

    return getDefaultActions();
  }

  /// Generate quick actions based on user's pending tasks
  static List<QuickAction> getTaskActions(List<String> pendingTasks) {
    final actions = <QuickAction>[];

    for (final task in pendingTasks.take(3)) {
      final taskLower = task.toLowerCase();

      if (taskLower.contains('essay')) {
        actions.add(const QuickAction(
          id: 'essay_help',
          label: 'Essay Writing Help',
          action: 'info_essay_writing',
          icon: Icons.create,
        ));
      } else if (taskLower.contains('deadline')) {
        actions.add(const QuickAction(
          id: 'deadline_reminder',
          label: 'Set Deadline Reminder',
          action: 'action_set_reminder',
          icon: Icons.alarm,
        ));
      } else if (taskLower.contains('letter') || taskLower.contains('recommendation')) {
        actions.add(const QuickAction(
          id: 'letter_tips',
          label: 'Letter Request Tips',
          action: 'info_recommendation_letters',
          icon: Icons.mail,
        ));
      } else if (taskLower.contains('transcript')) {
        actions.add(const QuickAction(
          id: 'transcript_help',
          label: 'Transcript Guide',
          action: 'info_transcript_submission',
          icon: Icons.article,
        ));
      }
    }

    return actions;
  }

  /// Generate quick actions for new users
  static List<QuickAction> getOnboardingActions() {
    return [
      const QuickAction(
        id: 'start_questionnaire',
        label: 'Start Questionnaire',
        action: 'navigate_questionnaire',
        icon: Icons.play_arrow,
      ),
      const QuickAction(
        id: 'how_it_works',
        label: 'How It Works',
        action: 'info_how_it_works',
        icon: Icons.info,
      ),
      const QuickAction(
        id: 'browse_universities',
        label: 'Browse Universities',
        action: 'navigate_explore',
        icon: Icons.explore,
      ),
    ];
  }

  /// Get default quick actions
  static List<QuickAction> getDefaultActions() {
    return [
      const QuickAction(
        id: 'help',
        label: 'How can you help?',
        action: 'info_help',
        icon: Icons.help_outline,
      ),
      const QuickAction(
        id: 'recommendations',
        label: 'Get Recommendations',
        action: 'navigate_recommendations',
        icon: Icons.school,
      ),
      const QuickAction(
        id: 'contact',
        label: 'Contact Support',
        action: 'urgent_escalate',
        icon: Icons.support_agent,
      ),
    ];
  }

  /// Generate actions for incomplete profile
  static List<QuickAction> getIncompleteProfileActions(int completeness) {
    return [
      QuickAction(
        id: 'complete_profile',
        label: 'Complete Profile ($completeness%)',
        action: 'navigate_questionnaire',
        icon: Icons.person_add,
      ),
      const QuickAction(
        id: 'why_complete',
        label: 'Why Complete Profile?',
        action: 'info_profile_benefits',
        icon: Icons.lightbulb,
      ),
    ];
  }

  /// Generate actions for users with recommendations
  static List<QuickAction> getRecommendationActions({
    required int totalCount,
    required int favoritedCount,
  }) {
    final actions = <QuickAction>[
      QuickAction(
        id: 'view_recommendations',
        label: 'View $totalCount Schools',
        action: 'navigate_recommendations',
        icon: Icons.list,
      ),
    ];

    if (favoritedCount > 0) {
      actions.add(QuickAction(
        id: 'view_favorites',
        label: 'My Favorites ($favoritedCount)',
        action: 'navigate_favorites',
        icon: Icons.favorite,
      ));
    }

    actions.add(const QuickAction(
      id: 'start_applying',
      label: 'Start Applying',
      action: 'action_start_applications',
      icon: Icons.send,
    ));

    return actions;
  }
}
