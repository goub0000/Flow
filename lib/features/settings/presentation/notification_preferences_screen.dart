import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/notification_models.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/l10n_extension.dart';

/// Notification preferences screen
class NotificationPreferencesScreen extends ConsumerStatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  ConsumerState<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends ConsumerState<NotificationPreferencesScreen> {
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    setState(() => _isInitializing = true);

    // Check if preferences exist
    final preferencesAsync = ref.read(notificationPreferencesProvider);

    await preferencesAsync.when(
      data: (preferences) async {
        // If no preferences exist, create defaults
        if (preferences.isEmpty) {
          try {
            await ref.read(createDefaultPreferencesProvider)();
            if (!mounted) return;
            ref.invalidate(notificationPreferencesProvider);
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${context.l10n.notifPrefScreenErrorCreating}: $e')),
            );
          }
        }
      },
      loading: () {},
      error: (_, __) {},
    );

    if (!mounted) return;
    setState(() => _isInitializing = false);
  }

  @override
  Widget build(BuildContext context) {
    final preferencesAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifPrefScreenTitle),
      ),
      body: preferencesAsync.when(
        data: (preferences) {
          if (_isInitializing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (preferences.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(context.l10n.notifPrefScreenNoPreferences),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializePreferences,
                    child: Text(context.l10n.notifPrefScreenCreateDefaults),
                  ),
                ],
              ),
            );
          }

          // Group preferences by category
          final applicationPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.applicationStatus).toList();
          final academicPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.gradePosted ||
              p.notificationType == NotificationType.deadlineReminder).toList();
          final communicationPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.messageReceived ||
              p.notificationType == NotificationType.commentReceived ||
              p.notificationType == NotificationType.mention).toList();
          final meetingPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.meetingScheduled ||
              p.notificationType == NotificationType.meetingReminder ||
              p.notificationType == NotificationType.eventReminder).toList();
          final achievementPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.achievementEarned).toList();
          final systemPrefs = preferences.where((p) =>
              p.notificationType == NotificationType.systemAnnouncement ||
              p.notificationType == NotificationType.recommendationReady).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Description
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.l10n.notifPrefScreenSettingsTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.notifPrefScreenDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Application notifications
              if (applicationPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenCollegeApplications, Icons.school),
                ...applicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Academic notifications
              if (academicPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenAcademic, Icons.library_books),
                ...academicPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Communication notifications
              if (communicationPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenCommunication, Icons.chat),
                ...communicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Meeting & events
              if (meetingPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenMeetingsEvents, Icons.event),
                ...meetingPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Achievements
              if (achievementPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenAchievements, Icons.emoji_events),
                ...achievementPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // System
              if (systemPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefScreenSystem, Icons.settings),
                ...systemPrefs.map((pref) => _buildPreferenceItem(pref)),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('${context.l10n.notifPrefScreenErrorLoading}: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(notificationPreferencesProvider);
                },
                child: Text(context.l10n.notifPrefScreenRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(NotificationPreference preference) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preference.notificationType.displayText,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getNotificationDescription(preference.notificationType, context),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.6),
                            ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: preference.inAppEnabled,
                  onChanged: (value) => _updatePreference(
                    preference,
                    inAppEnabled: value,
                  ),
                ),
              ],
            ),

            // Additional toggles (for future features)
            if (preference.inAppEnabled) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleOption(
                      context,
                      context.l10n.notifPrefScreenEmail,
                      Icons.email_outlined,
                      preference.emailEnabled,
                      (value) => _updatePreference(
                        preference,
                        emailEnabled: value,
                      ),
                      enabled: false, // Future feature
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildToggleOption(
                      context,
                      context.l10n.notifPrefScreenPush,
                      Icons.notifications_outlined,
                      preference.pushEnabled,
                      (value) => _updatePreference(
                        preference,
                        pushEnabled: value,
                      ),
                      enabled: false, // Future feature
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    BuildContext context,
    String label,
    IconData icon,
    bool value,
    void Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: InkWell(
        onTap: enabled ? () => onChanged(!value) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: value && enabled
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
            color: value && enabled
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: value && enabled
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: value && enabled
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                  fontWeight: value && enabled ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (!enabled) ...[
                const SizedBox(width: 4),
                Text(
                  context.l10n.notifPrefScreenSoon,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationDescription(NotificationType type, BuildContext context) {
    switch (type) {
      case NotificationType.applicationStatus:
        return context.l10n.notifPrefScreenDescApplicationStatus;
      case NotificationType.gradePosted:
        return context.l10n.notifPrefScreenDescGradePosted;
      case NotificationType.messageReceived:
        return context.l10n.notifPrefScreenDescMessageReceived;
      case NotificationType.meetingScheduled:
        return context.l10n.notifPrefScreenDescMeetingScheduled;
      case NotificationType.meetingReminder:
        return context.l10n.notifPrefScreenDescMeetingReminder;
      case NotificationType.achievementEarned:
        return context.l10n.notifPrefScreenDescAchievementEarned;
      case NotificationType.deadlineReminder:
        return context.l10n.notifPrefScreenDescDeadlineReminder;
      case NotificationType.recommendationReady:
        return context.l10n.notifPrefScreenDescRecommendationReady;
      case NotificationType.systemAnnouncement:
        return context.l10n.notifPrefScreenDescSystemAnnouncement;
      case NotificationType.commentReceived:
        return context.l10n.notifPrefScreenDescCommentReceived;
      case NotificationType.mention:
        return context.l10n.notifPrefScreenDescMention;
      case NotificationType.eventReminder:
        return context.l10n.notifPrefScreenDescEventReminder;
      case NotificationType.approvalRequestNew:
        return context.l10n.notifPrefScreenDescApprovalRequestNew;
      case NotificationType.approvalRequestActionNeeded:
        return context.l10n.notifPrefScreenDescApprovalRequestActionNeeded;
      case NotificationType.approvalRequestStatusChanged:
        return context.l10n.notifPrefScreenDescApprovalRequestStatusChanged;
      case NotificationType.approvalRequestEscalated:
        return context.l10n.notifPrefScreenDescApprovalRequestEscalated;
      case NotificationType.approvalRequestExpiring:
        return context.l10n.notifPrefScreenDescApprovalRequestExpiring;
      case NotificationType.approvalRequestComment:
        return context.l10n.notifPrefScreenDescApprovalRequestComment;
    }
  }

  Future<void> _updatePreference(
    NotificationPreference preference, {
    bool? inAppEnabled,
    bool? emailEnabled,
    bool? pushEnabled,
  }) async {
    final request = UpdateNotificationPreferencesRequest(
      notificationType: preference.notificationType,
      inAppEnabled: inAppEnabled,
      emailEnabled: emailEnabled,
      pushEnabled: pushEnabled,
    );

    try {
      await ref.read(updateNotificationPreferenceProvider)(request);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.notifPrefScreenPreferencesUpdated),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.notifPrefScreenErrorUpdating}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
