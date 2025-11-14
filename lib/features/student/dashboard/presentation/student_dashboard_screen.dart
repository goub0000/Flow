import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/widgets/stats_widgets.dart';
import '../../../shared/widgets/dashboard_widgets.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../applications/presentation/applications_list_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';
import '../../providers/student_enrollments_provider.dart';
import '../../providers/student_applications_provider.dart';
import '../../providers/student_progress_provider.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _DashboardHomeTab(),
    const ApplicationsListScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashboardScaffold(
          title: 'Student Dashboard',
          currentIndex: _currentIndex,
          onNavigationTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          navigationItems: const [
            DashboardNavigationItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
            ),
            DashboardNavigationItem(
              icon: Icons.description_outlined,
              activeIcon: Icons.description,
              label: 'Applications',
            ),
            DashboardNavigationItem(
              icon: Icons.analytics_outlined,
              activeIcon: Icons.analytics,
              label: 'Progress',
            ),
            DashboardNavigationItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile',
            ),
            DashboardNavigationItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Settings',
            ),
          ],
          body: _pages[_currentIndex],
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

class _DashboardHomeTab extends ConsumerWidget {
  const _DashboardHomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Get data from providers
    final enrollments = ref.watch(enrollmentsListProvider);
    final applications = ref.watch(applicationsListProvider);
    final completedCoursesCount = ref.watch(completedCoursesCountProvider);
    final pendingApplicationsCount = ref.watch(pendingApplicationsCountProvider);

    // Mock data for enhanced features
    final mockStats = [
      StatData(
        label: 'Enrolled Programs',
        value: '${enrollments.length}',
        icon: Icons.school,
        color: AppColors.primary,
        trend: 12.5,
        subtitle: 'vs last month',
      ),
      StatData(
        label: 'Completed',
        value: '$completedCoursesCount',
        icon: Icons.assignment_turned_in,
        color: AppColors.success,
        trend: 8.3,
      ),
      StatData(
        label: 'Pending',
        value: '$pendingApplicationsCount',
        icon: Icons.pending_actions,
        color: AppColors.warning,
        trend: -5.2,
      ),
      StatData(
        label: 'Applications',
        value: '${applications.length}',
        icon: Icons.description,
        color: AppColors.info,
        sparklineData: [3, 5, 4, 8, 6, 9, 7],
      ),
    ];

    final mockActivities = [
      ActivityItem(
        id: '1',
        title: 'Program Completed',
        description: 'You completed Introduction to Computer Science',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: ActivityType.achievement,
      ),
      ActivityItem(
        id: '2',
        title: 'New Application Submitted',
        description: 'Application to University of Nairobi submitted',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: ActivityType.application,
      ),
      ActivityItem(
        id: '3',
        title: 'Payment Received',
        description: 'Payment confirmed for Fall 2024 tuition',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: ActivityType.payment,
      ),
      ActivityItem(
        id: '4',
        title: 'New Message',
        description: 'Counselor sent you a message about scholarships',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        type: ActivityType.message,
      ),
    ];

    final mockRecommendations = [
      {
        'title': 'Data Science Fundamentals',
        'description': 'Learn the basics of data analysis and visualization',
        'imageUrl': '',
        'badge': 'NEW',
      },
      {
        'title': 'Web Development Bootcamp',
        'description': 'Build modern web applications from scratch',
        'imageUrl': '',
        'badge': 'POPULAR',
      },
      {
        'title': 'Mobile App Development',
        'description': 'Create iOS and Android apps with Flutter',
        'imageUrl': '',
      },
    ];

    return SingleChildScrollView(
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
                  AppColors.primary.withOpacity(0.7),
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
                  'Welcome Back!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Continue your learning journey',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
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
                            'Overall Progress',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: completedCoursesCount / (enrollments.length > 0 ? enrollments.length : 1),
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${((completedCoursesCount / (enrollments.length > 0 ? enrollments.length : 1)) * 100).toInt()}%',
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
            title: 'Quick Actions',
            onViewAll: null,
          ),
          const SizedBox(height: 12),
          QuickActionsGrid(
            crossAxisCount: 4,
            actions: [
              QuickAction(
                label: 'Browse Courses',
                icon: Icons.explore,
                color: AppColors.primary,
                onTap: () => context.go('/student/courses'),
              ),
              QuickAction(
                label: 'My Applications',
                icon: Icons.description,
                color: AppColors.info,
                badgeCount: pendingApplicationsCount,
                onTap: () => context.go('/student/applications'),
              ),
              QuickAction(
                label: 'Progress',
                icon: Icons.analytics,
                color: AppColors.success,
                onTap: () => context.go('/student/progress'),
              ),
              QuickAction(
                label: 'Messages',
                icon: Icons.message,
                color: AppColors.warning,
                badgeCount: 3,
                onTap: () => context.go('/messages'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Grid
          SectionHeader(
            title: 'Overview',
            onViewAll: null,
          ),
          const SizedBox(height: 12),
          StatsGrid(
            stats: mockStats,
            onStatTap: (stat) {
              // Navigate based on stat type
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
                            const Text(
                              'Find Your Path',
                              style: TextStyle(
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
                              child: const Text(
                                'NEW',
                                style: TextStyle(
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
                          'Discover universities that match your profile, goals, and preferences with AI-powered recommendations',
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
                              'Start Your Journey',
                              style: TextStyle(
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

          // Activity Feed
          ActivityFeed(
            activities: mockActivities,
            onViewAll: () {
              // Navigate to full activity log
            },
            onActivityTap: (activity) {
              // Navigate based on activity type
            },
          ),
          const SizedBox(height: 24),

          // Recommendations
          RecommendationsCarousel(
            recommendations: mockRecommendations,
            onTap: (rec) {
              // Navigate to course detail
              context.go('/student/courses');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
