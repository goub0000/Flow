import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import 'widgets/overview_tab.dart';
import '../../applicants/presentation/applicants_list_screen.dart';
import '../../programs/presentation/programs_list_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';

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
    const ProfileScreen(),
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
    switch (_currentIndex) {
      case 0:
        return 'Institution Dashboard';
      case 1:
        return 'Applicants';
      case 2:
        return 'Programs';
      case 3:
        return 'Profile';
      case 4:
        return 'Settings';
      default:
        return 'Institution Dashboard';
    }
  }
}
