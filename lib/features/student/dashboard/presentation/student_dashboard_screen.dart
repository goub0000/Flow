// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/activity_models.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/widgets/stats_widgets.dart';
import '../../../shared/widgets/dashboard_widgets.dart';
import '../../../shared/widgets/coming_soon_dialog.dart';
import '../../../shared/widgets/refresh_utilities.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../applications/presentation/applications_list_screen.dart';
import '../../courses/presentation/my_courses_screen.dart';
import '../../../shared/profile/profile_screen.dart';
// Settings removed from bottom nav - accessible via profile menu in app bar
import '../../providers/student_applications_provider.dart';
import '../../../shared/providers/profile_provider.dart';
import '../../providers/recommendations_provider.dart';
import '../../providers/dashboard_statistics_provider.dart';
import '../../providers/student_applications_realtime_provider.dart';
import '../../../../core/providers/student_activities_provider.dart';
import '../../providers/student_parent_linking_provider.dart';
import '../../providers/student_counseling_provider.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  int _currentIndex = 0;

  // IMPORTANT: Removed 'const' from widgets that use providers
  // ProfileScreen, ApplicationsListScreen use ConsumerWidget and need to rebuild
  // NOTE: Consolidated to 5 navigation items per Material Design guidelines
  // Settings is accessible via profile menu in app bar
  late final List<Widget> _pages = [
    _DashboardHomeTab(
      key: const PageStorageKey('home'),
      onNavigateToTab: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ),
    ApplicationsListScreen(key: const PageStorageKey('applications')),
    MyCoursesScreen(key: const PageStorageKey('my_courses')),
    ProgressScreen(key: const PageStorageKey('progress')),
    ProfileScreen(key: const PageStorageKey('profile'), showBackButton: false),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Add this to prevent unnecessary navigation conflicts
  // NOTE: Consolidated to 5 tabs - Settings removed from bottom nav
  String _getTitleForIndex(int index, BuildContext context) {
    switch (index) {
      case 0:
        return context.l10n.dashStudentTitle;
      case 1:
        return context.l10n.dashStudentMyApplications;
      case 2:
        return context.l10n.dashStudentMyCourses;
      case 3:
        return context.l10n.dashStudentProgress;
      case 4:
        return context.l10n.dashCommonProfile;
      default:
        return context.l10n.dashStudentTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current user for profile edit action
    final user = ref.watch(currentProfileProvider);

    return Stack(
      children: [
        DashboardScaffold(
          title: _getTitleForIndex(_currentIndex, context),
          currentIndex: _currentIndex,
          actions: [
            // Notification badge - always visible
            DashboardAction(
              icon: Icons.notifications,
              onPressed: () => context.push('/notifications'),
              tooltip: context.l10n.dashCommonNotifications,
            ),
            // Message badge - always visible
            DashboardAction(
              icon: Icons.message,
              onPressed: () => context.push('/messages'),
              tooltip: context.l10n.dashCommonMessages,
            ),
            // Edit button - only on Profile tab
            if (_currentIndex == 4 && user != null)
              DashboardAction(
                icon: Icons.edit,
                onPressed: () {
                  context.push('/profile/edit');
                },
                tooltip: context.l10n.dashStudentEditProfile,
              ),
          ],
          onNavigationTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // NOTE: Consolidated to 5 items per Material Design guidelines
          // Settings is accessible via profile menu in app bar
          navigationItems: [
            DashboardNavigationItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: context.l10n.dashCommonHome,
            ),
            DashboardNavigationItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description,
              label: context.l10n.dashCommonApplications,
            ),
            DashboardNavigationItem(
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book,
              label: context.l10n.dashStudentCourses,
            ),
            DashboardNavigationItem(
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics,
              label: context.l10n.dashStudentProgress,
            ),
            DashboardNavigationItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: context.l10n.dashCommonProfile,
            ),
          ],
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ),
        // Cookie consent banner
        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CookieBanner(),
        ),
      ],
    );
  }
}

class _DashboardHomeTab extends ConsumerStatefulWidget {
  const _DashboardHomeTab({super.key, this.onNavigateToTab});

  final void Function(int)? onNavigateToTab;

  @override
  ConsumerState<_DashboardHomeTab> createState() => _DashboardHomeTabState();
}

class _DashboardHomeTabState extends ConsumerState<_DashboardHomeTab> with RefreshableMixin {
  Future<void> _handleRefresh() async {
    return handleRefresh(() async {
      try {
        // Refresh all data sources - invalidate providers to force refresh
        ref.invalidate(dashboardStatisticsProvider);
        ref.invalidate(studentActivitiesProvider);
        ref.invalidate(recommendationsProvider);
        ref.invalidate(applicationsListProvider);

        // Wait for async providers to complete (if needed)
        await Future.wait([
          ref.read(recommendationsProvider.future),
        ]);

        // If using real-time provider, refresh it too
        try {
          ref.read(studentApplicationsRealtimeProvider.notifier).refresh();
        } catch (e) {
          // Real-time provider might not be available
        }

        // Update last refresh time
        ref.read(lastRefreshTimeProvider('student_dashboard').notifier).state = DateTime.now();

        // Show success feedback
        if (mounted) {
          showRefreshFeedback(context, success: true);
        }
      } catch (e) {
        // Show error feedback
        if (mounted) {
          showRefreshFeedback(
            context,
            success: false,
            message: 'Failed to refresh: ${e.toString()}',
          );
        }
        rethrow;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get real data from providers
    final applications = ref.watch(applicationsListProvider);
    final pendingApplicationsCount = ref.watch(pendingApplicationsCountProvider);
    final acceptedApplicationsCount = applications.where((app) => app.isAccepted).length;

    // Get real statistics from provider
    final statistics = ref.watch(dashboardStatisticsProvider);

    // Get real activity feed from new provider
    final activitiesState = ref.watch(studentActivitiesProvider);

    // Get real recommendations
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card with Progress
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashCommonWelcomeBack,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.dashStudentContinueJourney,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.dashStudentSuccessRate,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: acceptedApplicationsCount / (applications.isNotEmpty ? applications.length : 1),
                              backgroundColor: Colors.white.withValues(alpha: 0.3),
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${((acceptedApplicationsCount / (applications.isNotEmpty ? applications.length : 1)) * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          SectionHeader(
            title: context.l10n.dashCommonQuickActions,
            onViewAll: null,
          ),
          const SizedBox(height: 12),
          QuickActionsGrid(
            crossAxisCount: 4,
            actions: [
              QuickAction(
                label: context.l10n.dashStudentMyCourses,
                icon: Icons.menu_book,
                color: AppColors.primary,
                onTap: () {
                  widget.onNavigateToTab?.call(2); // Navigate to My Courses tab
                },
              ),
              QuickAction(
                label: context.l10n.dashCommonApplications,
                icon: Icons.description,
                color: AppColors.info,
                badgeCount: pendingApplicationsCount,
                onTap: () {
                  // Use tab navigation instead of route navigation
                  widget.onNavigateToTab?.call(1); // Navigate to Applications tab
                },
              ),
              QuickAction(
                label: context.l10n.dashStudentLetters,
                icon: Icons.recommend,
                color: AppColors.success,
                onTap: () {
                  context.push('/student/recommendations');
                },
              ),
              QuickAction(
                label: context.l10n.dashStudentParentLink,
                icon: Icons.family_restroom,
                color: AppColors.parentRole,
                badgeCount: ref.watch(pendingLinksCountProvider),
                onTap: () {
                  context.push('/student/parent-linking');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Second row of quick actions
          QuickActionsGrid(
            crossAxisCount: 4,
            actions: [
              QuickAction(
                label: context.l10n.dashStudentCounseling,
                icon: Icons.psychology,
                color: Colors.teal,
                badgeCount: ref.watch(studentCounselingProvider).upcomingSessions.length,
                onTap: () {
                  context.push('/student/counseling');
                },
              ),
              QuickAction(
                label: context.l10n.dashStudentSchedule,
                icon: Icons.calendar_month,
                color: Colors.orange,
                onTap: () {
                  context.push('/student/schedule');
                },
              ),
              QuickAction(
                label: context.l10n.dashStudentResources,
                icon: Icons.library_books,
                color: Colors.purple,
                onTap: () {
                  context.push('/student/resources');
                },
              ),
              QuickAction(
                label: context.l10n.dashStudentHelp,
                icon: Icons.help_outline,
                color: Colors.grey,
                onTap: () {
                  context.push('/student/help');
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Grid
          SectionHeader(
            title: context.l10n.dashCommonOverview,
            onViewAll: null,
          ),
          const SizedBox(height: 12),
          StatsGrid(
            stats: statistics,  // Use real statistics
            onStatTap: (stat) {
              // Navigate based on stat type
              switch (stat.label) {
                case 'Total Applications':
                case 'Applications':
                  // Navigate to Applications tab
                  widget.onNavigateToTab?.call(1);
                  break;
                case 'Accepted':
                  // Navigate to Applications tab - ideally with accepted filter
                  // For now, just go to applications tab
                  widget.onNavigateToTab?.call(1);
                  break;
                case 'Pending':
                  // Navigate to Applications tab - ideally with pending filter
                  // For now, just go to applications tab
                  widget.onNavigateToTab?.call(1);
                  break;
                case 'Under Review':
                case 'In Review':
                  // Navigate to Applications tab - ideally with review filter
                  // For now, just go to applications tab
                  widget.onNavigateToTab?.call(1);
                  break;
                default:
                  // For any other stats, navigate to applications
                  widget.onNavigateToTab?.call(1);
              }
            },
          ),
          const SizedBox(height: 24),

          // Find Your Path Featured Card
          GestureDetector(
            onTap: () {
              context.push('/find-your-path');
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.info,
                    AppColors.info.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.info.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.explore,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              context.l10n.dashStudentFindYourPath,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                context.l10n.dashStudentNew,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          context.l10n.dashStudentFindYourPathDesc,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.95),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              context.l10n.dashStudentStartJourney,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Activity Feed with loading/error states
          if (activitiesState.isLoading && activitiesState.activities.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (activitiesState.error != null && activitiesState.activities.isEmpty)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.dashStudentFailedActivities,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activitiesState.error!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => ref.read(studentActivitiesProvider.notifier).refresh(),
                    icon: const Icon(Icons.refresh),
                    label: Text(context.l10n.dashCommonRetry),
                  ),
                ],
              ),
            )
          else
            ActivityFeed(
              activities: activitiesState.activities.map((a) {
                // Map StudentActivityType to ActivityType
                ActivityType activityType;
                switch (a.type) {
                  case StudentActivityType.applicationSubmitted:
                  case StudentActivityType.applicationStatusChanged:
                    activityType = ActivityType.application;
                    break;
                  case StudentActivityType.achievementEarned:
                    activityType = ActivityType.achievement;
                    break;
                  case StudentActivityType.paymentMade:
                    activityType = ActivityType.payment;
                    break;
                  case StudentActivityType.messageReceived:
                    activityType = ActivityType.message;
                    break;
                  case StudentActivityType.courseCompleted:
                  default:
                    activityType = ActivityType.course;
                }

                return ActivityItem(
                  id: a.id,
                  title: a.title,
                  description: a.description,
                  timestamp: a.timestamp,
                  type: activityType,
                  metadata: a.metadata,
                );
              }).toList(),
              onViewAll: () {
                // Show coming soon dialog for full activity log
                ComingSoonDialog.show(
                  context,
                  featureName: context.l10n.dashStudentActivityHistory,
                  customMessage: context.l10n.dashStudentActivityHistoryMsg,
                );
              },
              onActivityTap: (activity) {
                // Navigate based on activity type
                final metadata = activity.metadata;

                // Handle based on activity type
                if (activity.type == ActivityType.application) {
                  // Navigate to application detail or applications tab
                  if (metadata != null && metadata['applicationId'] != null) {
                    // TODO: Navigate to specific application detail when implemented
                    // For now, navigate to Applications tab
                    widget.onNavigateToTab?.call(1);
                  } else {
                    widget.onNavigateToTab?.call(1); // Go to Applications tab
                  }
                } else if (activity.type == ActivityType.achievement) {
                  // Show achievement details in a dialog
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Row(
                        children: [
                          const Icon(Icons.emoji_events, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Text(context.l10n.dashStudentAchievement),
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.title,
                            style: Theme.of(dialogContext).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(activity.description),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: Text(context.l10n.dashCommonClose),
                        ),
                      ],
                    ),
                  );
                } else if (activity.type == ActivityType.payment) {
                  // Navigate to payment history if available
                  ComingSoonDialog.show(
                    context,
                    featureName: context.l10n.dashStudentPaymentHistory,
                    customMessage: context.l10n.dashStudentPaymentHistoryMsg,
                  );
                } else if (activity.type == ActivityType.message) {
                  // Navigate to messages
                  context.go('/messages');
                } else {
                  // For unknown activity types, try to navigate to applications
                  widget.onNavigateToTab?.call(1);
                }
              },
            ),

          const SizedBox(height: 24),

          // Recommendations with loading state
          recommendationsAsync.when(
            data: (recommendations) => RecommendationsCarousel(
              recommendations: recommendations.map((rec) => rec.toMap()).toList(),
              onTap: (rec) {
                // Navigate based on recommendation type
                final title = rec['title'] as String?;
                final id = rec['id'] as String?;
                final type = rec['type'] as String?;

                if (title == 'Find Your Path Assessment') {
                  // Navigate to the assessment
                  context.push('/find-your-path');
                } else if (id != null && type == 'course') {
                  // Navigate to specific course detail
                  // TODO: When course detail page is implemented, use: context.go('/student/courses/$id')
                  // For now, navigate to find your path
                  context.go('/find-your-path');
                } else if (id != null && type == 'program') {
                  // Navigate to specific program detail
                  // TODO: When program detail page is implemented, use: context.go('/student/programs/$id')
                  // For now, navigate to find your path
                  context.go('/find-your-path');
                } else {
                  // Default navigation to find your path
                  context.go('/find-your-path');
                }
              },
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: 8),
                  Text(context.l10n.dashStudentFailedRecommendations, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.refresh(recommendationsProvider),
                    child: Text(context.l10n.dashCommonRetry),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Last refresh timestamp
          const LastRefreshIndicator(providerKey: 'student_dashboard'),
          const SizedBox(height: 8),
        ],
        ),
      ),
    );
  }
}
