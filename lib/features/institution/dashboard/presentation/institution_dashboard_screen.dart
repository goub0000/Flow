import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/widgets/notification_badge.dart';
import '../../../shared/widgets/message_badge.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import 'widgets/overview_tab.dart';
import '../../applicants/presentation/applicants_list_screen.dart';
import '../../programs/presentation/programs_list_screen.dart';
import '../../courses/presentation/institution_courses_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';
import '../../debug/institution_debug_screen.dart';

class InstitutionDashboardScreen extends ConsumerStatefulWidget {
  const InstitutionDashboardScreen({super.key});

  @override
  ConsumerState<InstitutionDashboardScreen> createState() =>
      _InstitutionDashboardScreenState();
}

class _InstitutionDashboardScreenState
    extends ConsumerState<InstitutionDashboardScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    OverviewTab(onNavigate: (index) => setState(() => _currentIndex = index)),
    const ApplicantsListScreen(),
    const ProgramsListScreen(),
    const InstitutionCoursesScreen(),
    const ProfileScreen(showBackButton: false),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: DashboardScaffold(
            title: _getTitle(),
            currentIndex: _currentIndex,
            onNavigationTap: (index) => setState(() => _currentIndex = index),
            actions: [
              // Notification badge - always visible
              DashboardAction(
                icon: Icons.notifications,
                onPressed: () => context.push('/notifications'),
                tooltip: 'Notifications',
              ),
              // Message badge - always visible
              DashboardAction(
                icon: Icons.message,
                onPressed: () => context.push('/messages'),
                tooltip: 'Messages',
              ),
              // Debug button for troubleshooting
              DashboardAction(
                icon: Icons.bug_report,
                tooltip: 'Debug Panel',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const InstitutionDebugScreen(),
                    ),
                  );
                },
              ),
            ],
            navigationItems: const [
            DashboardNavigationItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: 'Overview',
            ),
            DashboardNavigationItem(
              icon: Icons.people_outlined,
              activeIcon: Icons.people,
              label: 'Applicants',
            ),
            DashboardNavigationItem(
              icon: Icons.school_outlined,
              activeIcon: Icons.school,
              label: 'Programs',
            ),
            DashboardNavigationItem(
              icon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book,
              label: 'Courses',
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
          body: _screens[_currentIndex],
        ),
          floatingActionButton: _currentIndex == 2
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await context.push('/institution/programs/create');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Program'),
                )
              : _currentIndex == 3
                  ? FloatingActionButton.extended(
                      onPressed: () async {
                        await context.push('/institution/courses/create');
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('New Course'),
                    )
                  : null,
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

  String _getTitle() {
    // Always show "Institution Dashboard" to avoid redundancy with bottom nav labels
    return 'Institution Dashboard';
  }
}
