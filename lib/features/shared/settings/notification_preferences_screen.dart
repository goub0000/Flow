import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
                const SnackBar(
                  content: Text('Default notification preferences created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error creating preferences: $e')),
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
        title: const Text('Notification Preferences'),
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
                  const Text('No notification preferences found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: isAuthReady ? _initializePreferences : null,
                    child: Text(isAuthReady
                      ? 'Create Default Preferences'
                      : 'Waiting for authentication...'),
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
                            'Notification Settings',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Control which notifications you want to receive. Changes are saved automatically.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Application notifications
              if (applicationPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'College Applications', Icons.school),
                ...applicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Academic notifications
              if (academicPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'Academic', Icons.library_books),
                ...academicPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Communication notifications
              if (communicationPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'Communication', Icons.chat),
                ...communicationPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Meeting & events
              if (meetingPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'Meetings & Events', Icons.event),
                ...meetingPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // Achievements
              if (achievementPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'Achievements', Icons.emoji_events),
                ...achievementPrefs.map((pref) => _buildPreferenceItem(pref)),
                const SizedBox(height: 16),
              ],

              // System
              if (systemPrefs.isNotEmpty) ...[
                _buildCategoryHeader(context, 'System', Icons.settings),
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
              Text('Error loading preferences: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(notificationPreferencesProvider);
                },
                child: const Text('Retry'),
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
                                  .withOpacity(0.6),
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
                      'Email',
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
                      'Push',
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
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
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
                const Text(
                  '(soon)',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
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
        return 'Get notified when your application status changes';
      case NotificationType.gradePosted:
        return 'Receive notifications when new grades are posted';
      case NotificationType.messageReceived:
        return 'Get notified about new messages';
      case NotificationType.meetingScheduled:
        return 'Receive notifications for scheduled meetings';
      case NotificationType.meetingReminder:
        return 'Get reminders before your meetings';
      case NotificationType.achievementEarned:
        return 'Celebrate when you earn new achievements';
      case NotificationType.deadlineReminder:
        return 'Get reminded about upcoming deadlines';
      case NotificationType.recommendationReady:
        return 'Receive notifications for new recommendations';
      case NotificationType.systemAnnouncement:
        return 'Stay updated with system announcements';
      case NotificationType.commentReceived:
        return 'Get notified when someone comments on your posts';
      case NotificationType.mention:
        return 'Receive notifications when you are mentioned';
      case NotificationType.eventReminder:
        return 'Get reminders about upcoming events';
      case NotificationType.approvalRequestNew:
        return 'Get notified about new approval requests';
      case NotificationType.approvalRequestActionNeeded:
        return 'Receive reminders about pending approval actions';
      case NotificationType.approvalRequestStatusChanged:
        return 'Get notified when your request status changes';
      case NotificationType.approvalRequestEscalated:
        return 'Receive notifications when requests are escalated to you';
      case NotificationType.approvalRequestExpiring:
        return 'Get reminders about expiring approval requests';
      case NotificationType.approvalRequestComment:
        return 'Get notified about new comments on requests';
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
          const SnackBar(
            content: Text('Preferences updated'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
