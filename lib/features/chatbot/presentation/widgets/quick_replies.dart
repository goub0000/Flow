import 'package:flutter/material.dart';
import '../../../../core/l10n_extension.dart';
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
  static List<QuickAction> getPageActions(BuildContext context, String? currentPage) {
    if (currentPage == null) return getDefaultActions(context);

    final page = currentPage.toLowerCase();

    if (page.contains('dashboard')) {
      return [
        QuickAction(
          id: 'recommendations',
          label: context.l10n.chatViewRecommendations,
          action: 'navigate_recommendations',
          icon: Icons.school,
        ),
        QuickAction(
          id: 'questionnaire',
          label: context.l10n.chatUpdateProfile,
          action: 'navigate_questionnaire',
          icon: Icons.person,
        ),
        QuickAction(
          id: 'applications',
          label: context.l10n.chatMyApplications,
          action: 'navigate_applications',
          icon: Icons.description,
        ),
      ];
    }

    if (page.contains('recommendation')) {
      return [
        QuickAction(
          id: 'compare',
          label: context.l10n.chatCompareSchools,
          action: 'action_compare_schools',
          icon: Icons.compare_arrows,
        ),
        QuickAction(
          id: 'filter',
          label: context.l10n.chatFilterResults,
          action: 'action_filter_recommendations',
          icon: Icons.filter_list,
        ),
        QuickAction(
          id: 'explain',
          label: context.l10n.chatWhyTheseSchools,
          action: 'info_explain_recommendations',
          icon: Icons.help_outline,
        ),
      ];
    }

    if (page.contains('application')) {
      return [
        QuickAction(
          id: 'deadlines',
          label: context.l10n.chatViewDeadlines,
          action: 'action_view_deadlines',
          icon: Icons.calendar_today,
        ),
        QuickAction(
          id: 'essay_tips',
          label: context.l10n.chatEssayTips,
          action: 'info_essay_tips',
          icon: Icons.edit_note,
        ),
        QuickAction(
          id: 'checklist',
          label: context.l10n.chatApplicationChecklist,
          action: 'info_application_checklist',
          icon: Icons.checklist,
        ),
      ];
    }

    if (page.contains('questionnaire') || page.contains('profile')) {
      return [
        QuickAction(
          id: 'help',
          label: context.l10n.chatHelpWithQuestions,
          action: 'info_questionnaire_help',
          icon: Icons.help,
        ),
        QuickAction(
          id: 'skip_tip',
          label: context.l10n.chatCanISkipSections,
          action: 'info_skip_sections',
          icon: Icons.skip_next,
        ),
      ];
    }

    if (page.contains('university')) {
      return [
        QuickAction(
          id: 'apply',
          label: context.l10n.chatStartApplication,
          action: 'action_start_application',
          icon: Icons.send,
        ),
        QuickAction(
          id: 'save',
          label: context.l10n.chatSaveToFavorites,
          action: 'action_save_favorite',
          icon: Icons.favorite_border,
        ),
        QuickAction(
          id: 'similar',
          label: context.l10n.chatSimilarSchools,
          action: 'action_find_similar',
          icon: Icons.search,
        ),
      ];
    }

    return getDefaultActions(context);
  }

  /// Generate quick actions based on user's pending tasks
  static List<QuickAction> getTaskActions(BuildContext context, List<String> pendingTasks) {
    final actions = <QuickAction>[];

    for (final task in pendingTasks.take(3)) {
      final taskLower = task.toLowerCase();

      if (taskLower.contains('essay')) {
        actions.add(QuickAction(
          id: 'essay_help',
          label: context.l10n.chatEssayWritingHelp,
          action: 'info_essay_writing',
          icon: Icons.create,
        ));
      } else if (taskLower.contains('deadline')) {
        actions.add(QuickAction(
          id: 'deadline_reminder',
          label: context.l10n.chatSetDeadlineReminder,
          action: 'action_set_reminder',
          icon: Icons.alarm,
        ));
      } else if (taskLower.contains('letter') || taskLower.contains('recommendation')) {
        actions.add(QuickAction(
          id: 'letter_tips',
          label: context.l10n.chatLetterRequestTips,
          action: 'info_recommendation_letters',
          icon: Icons.mail,
        ));
      } else if (taskLower.contains('transcript')) {
        actions.add(QuickAction(
          id: 'transcript_help',
          label: context.l10n.chatTranscriptGuide,
          action: 'info_transcript_submission',
          icon: Icons.article,
        ));
      }
    }

    return actions;
  }

  /// Generate quick actions for new users
  static List<QuickAction> getOnboardingActions(BuildContext context) {
    return [
      QuickAction(
        id: 'start_questionnaire',
        label: context.l10n.chatStartQuestionnaire,
        action: 'navigate_questionnaire',
        icon: Icons.play_arrow,
      ),
      QuickAction(
        id: 'how_it_works',
        label: context.l10n.chatHowItWorks,
        action: 'info_how_it_works',
        icon: Icons.info,
      ),
      QuickAction(
        id: 'browse_universities',
        label: context.l10n.chatBrowseUniversities,
        action: 'navigate_explore',
        icon: Icons.explore,
      ),
    ];
  }

  /// Get default quick actions
  static List<QuickAction> getDefaultActions(BuildContext context) {
    return [
      QuickAction(
        id: 'help',
        label: context.l10n.chatHowCanYouHelp,
        action: 'info_help',
        icon: Icons.help_outline,
      ),
      QuickAction(
        id: 'recommendations',
        label: context.l10n.chatGetRecommendations,
        action: 'navigate_recommendations',
        icon: Icons.school,
      ),
      QuickAction(
        id: 'contact',
        label: context.l10n.chatContactSupport,
        action: 'urgent_escalate',
        icon: Icons.support_agent,
      ),
    ];
  }

  /// Generate actions for incomplete profile
  static List<QuickAction> getIncompleteProfileActions(BuildContext context, int completeness) {
    return [
      QuickAction(
        id: 'complete_profile',
        label: context.l10n.chatCompleteProfile(completeness),
        action: 'navigate_questionnaire',
        icon: Icons.person_add,
      ),
      QuickAction(
        id: 'why_complete',
        label: context.l10n.chatWhyCompleteProfile,
        action: 'info_profile_benefits',
        icon: Icons.lightbulb,
      ),
    ];
  }

  /// Generate actions for users with recommendations
  static List<QuickAction> getRecommendationActions(
    BuildContext context, {
    required int totalCount,
    required int favoritedCount,
  }) {
    final actions = <QuickAction>[
      QuickAction(
        id: 'view_recommendations',
        label: context.l10n.chatViewSchools(totalCount),
        action: 'navigate_recommendations',
        icon: Icons.list,
      ),
    ];

    if (favoritedCount > 0) {
      actions.add(QuickAction(
        id: 'view_favorites',
        label: context.l10n.chatMyFavorites(favoritedCount),
        action: 'navigate_favorites',
        icon: Icons.favorite,
      ));
    }

    actions.add(QuickAction(
      id: 'start_applying',
      label: context.l10n.chatStartApplying,
      action: 'action_start_applications',
      icon: Icons.send,
    ));

    return actions;
  }
}
