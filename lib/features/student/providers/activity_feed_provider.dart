import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/shared/widgets/dashboard_widgets.dart';
import 'student_applications_provider.dart';

/// Provider for generating activity feed from various sources
/// Since we don't have a dedicated activities API endpoint yet,
/// we generate activities from existing application data
final activityFeedProvider = FutureProvider<List<ActivityItem>>((ref) async {
  try {
    // Get applications data
    final applicationsState = ref.watch(applicationsProvider);
    final applications = applicationsState.applications;

    // Generate activities from applications
    final activities = <ActivityItem>[];

    for (final app in applications) {
      // Create activity for each application based on status
      ActivityType type = ActivityType.application;
      String title = '';
      String description = '';

      // Generate activity based on application status
      if (app.isAccepted) {
        title = 'Application Accepted';
        description = 'Your application to ${app.institutionName} for ${app.programName} has been accepted!';
        type = ActivityType.achievement;
      } else if (app.isRejected) {
        title = 'Application Update';
        description = 'Your application to ${app.institutionName} has been reviewed';
        type = ActivityType.application;
      } else if (app.isUnderReview) {
        title = 'Application Under Review';
        description = '${app.institutionName} is reviewing your application for ${app.programName}';
        type = ActivityType.application;
      } else if (app.isPending) {
        title = 'Application Submitted';
        description = 'Successfully submitted application to ${app.institutionName}';
        type = ActivityType.application;
      }

      // Use appropriate timestamp
      final timestamp = app.reviewedAt ?? app.submittedAt;

      activities.add(ActivityItem(
        id: 'app-activity-${app.id}',
        title: title,
        description: description,
        timestamp: timestamp,
        type: type,
        metadata: {
          'applicationId': app.id,
          'institutionId': app.institutionId,
          'status': app.status,
        },
      ));

      // Add payment activity if there's an application fee
      if (app.applicationFee != null && app.applicationFee! > 0) {
        if (app.feePaid) {
          activities.add(ActivityItem(
            id: 'payment-${app.id}',
            title: 'Payment Confirmed',
            description: 'Application fee of \$${app.applicationFee!.toStringAsFixed(2)} paid for ${app.institutionName}',
            timestamp: app.submittedAt.add(const Duration(minutes: 5)), // Slightly after submission
            type: ActivityType.payment,
            metadata: {
              'applicationId': app.id,
              'amount': app.applicationFee,
            },
          ));
        } else {
          // Add payment reminder for unpaid fees
          activities.add(ActivityItem(
            id: 'payment-reminder-${app.id}',
            title: 'Payment Required',
            description: 'Application fee of \$${app.applicationFee!.toStringAsFixed(2)} pending for ${app.institutionName}',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            type: ActivityType.payment,
            metadata: {
              'applicationId': app.id,
              'amount': app.applicationFee,
            },
          ));
        }
      }
    }

    // Add some general activities if user has no applications
    if (activities.isEmpty) {
      activities.addAll([
        ActivityItem(
          id: 'welcome',
          title: 'Welcome to Flow!',
          description: 'Start your educational journey by browsing available programs',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: ActivityType.general,
        ),
        ActivityItem(
          id: 'profile-tip',
          title: 'Complete Your Profile',
          description: 'Add your academic information to get better recommendations',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: ActivityType.general,
        ),
      ]);
    }

    // Sort activities by timestamp (most recent first)
    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Return only the most recent activities (limit to 10)
    return activities.take(10).toList();

  } catch (e) {
    print('[DEBUG] Error generating activity feed: $e');
    // Return empty list on error
    return [];
  }
});

/// Provider for activity count (for badges)
final activityCountProvider = Provider<int>((ref) {
  final activities = ref.watch(activityFeedProvider);
  return activities.when(
    data: (list) => list.where((a) =>
      a.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 7)))
    ).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

/// Provider to refresh activity feed
final refreshActivityFeedProvider = Provider((ref) {
  return () {
    // Invalidate the provider to force refresh
    ref.invalidate(activityFeedProvider);
  };
});