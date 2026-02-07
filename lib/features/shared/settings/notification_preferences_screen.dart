import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n_extension.dart';
import '../../../core/models/notification_models.dart';
import '../../../core/providers/notification_provider.dart';
import '../../../core/providers/service_providers.dart';

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
            ref.invalidate(notificationPreferencesProvider);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.l10n.notifPrefDefaultCreated),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.notifPrefErrorCreating(e.toString()))),
              );
            }
          }
        }
      },
      loading: () {},
      error: (_, __) {},
    );

    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferencesAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notifPrefTitle),
      ),
      body: preferencesAsync.when(
        data: (preferences) {
          if (_isInitializing) {
            return const Center(child: CircularProgressIndicator());
          }

          if (preferences.isEmpty) {
            // Watch AuthService (works with custom JWT) not Supabase auth
            final currentUser = ref.watch(currentUserProvider);
            final isAuthReady = currentUser != null;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(context.l10n.notifPrefNotFound),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isAuthReady ? _initializePreferences : null,
                    child: Text(isAuthReady
                      ? context.l10n.notifPrefCreateDefaults
                      : context.l10n.notifPrefWaitingAuth),
                  ),
                  if (!isAuthReady) ...[
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
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
                            context.l10n.notifPrefSettings,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.notifPrefDescription,
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
                _buildCategoryHeader(context, context.l10n.notifPrefCollegeApplications, Icons.school),
                ...applicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Academic notifications
              if (academicPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefAcademic, Icons.library_books),
                ...academicPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Communication notifications
              if (communicationPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefCommunication, Icons.chat),
                ...communicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Meeting & events
              if (meetingPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefMeetingsEvents, Icons.event),
                ...meetingPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Achievements
              if (achievementPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefAchievements, Icons.emoji_events),
                ...achievementPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // System
              if (systemPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, context.l10n.notifPrefSystem, Icons.settings),
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
              Text(context.l10n.notifPrefErrorLoading(error.toString())),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(notificationPreferencesProvider);
                },
                child: Text(context.l10n.notifPrefRetry),
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
                        _getNotificationDescription(preference.notificationType),
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
                      context.l10n.notifPrefEmail,
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
                      context.l10n.notifPrefPush,
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
                  context.l10n.notifPrefSoon,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getNotificationDescription(NotificationType type) {
    switch (type) {
      case NotificationType.applicationStatus:
        return context.l10n.notifPrefDescApplicationStatus;
      case NotificationType.gradePosted:
        return context.l10n.notifPrefDescGradePosted;
      case NotificationType.messageReceived:
        return context.l10n.notifPrefDescMessageReceived;
      case NotificationType.meetingScheduled:
        return context.l10n.notifPrefDescMeetingScheduled;
      case NotificationType.meetingReminder:
        return context.l10n.notifPrefDescMeetingReminder;
      case NotificationType.achievementEarned:
        return context.l10n.notifPrefDescAchievementEarned;
      case NotificationType.deadlineReminder:
        return context.l10n.notifPrefDescDeadlineReminder;
      case NotificationType.recommendationReady:
        return context.l10n.notifPrefDescRecommendationReady;
      case NotificationType.systemAnnouncement:
        return context.l10n.notifPrefDescSystemAnnouncement;
      case NotificationType.commentReceived:
        return context.l10n.notifPrefDescCommentReceived;
      case NotificationType.mention:
        return context.l10n.notifPrefDescMention;
      case NotificationType.eventReminder:
        return context.l10n.notifPrefDescEventReminder;
      case NotificationType.approvalRequestNew:
        return context.l10n.notifPrefDescApprovalNew;
      case NotificationType.approvalRequestActionNeeded:
        return context.l10n.notifPrefDescApprovalActionNeeded;
      case NotificationType.approvalRequestStatusChanged:
        return context.l10n.notifPrefDescApprovalStatusChanged;
      case NotificationType.approvalRequestEscalated:
        return context.l10n.notifPrefDescApprovalEscalated;
      case NotificationType.approvalRequestExpiring:
        return context.l10n.notifPrefDescApprovalExpiring;
      case NotificationType.approvalRequestComment:
        return context.l10n.notifPrefDescApprovalComment;
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.notifPrefUpdated),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.notifPrefErrorUpdating(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
