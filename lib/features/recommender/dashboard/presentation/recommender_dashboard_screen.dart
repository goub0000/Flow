import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import 'widgets/recommender_overview_tab.dart';
import '../../requests/presentation/requests_list_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';

class RecommenderDashboardScreen extends ConsumerStatefulWidget {
  const RecommenderDashboardScreen({super.key});

  @override
  ConsumerState<RecommenderDashboardScreen> createState() =>
      _RecommenderDashboardScreenState();
}

class _RecommenderDashboardScreenState
    extends ConsumerState<RecommenderDashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      RecommenderOverviewTab(
        onNavigateToRequests: () => setState(() => _currentIndex = 1),
      ),
      const RequestsListScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashboardScaffold(
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
              icon: Icons.assignment_outlined,
              activeIcon: Icons.assignment,
              label: 'Requests',
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
        return 'Recommender Dashboard';
      case 1:
        return 'Recommendations';
      case 2:
        return 'Profile';
      case 3:
        return 'Settings';
      default:
        return 'Recommender Dashboard';
    }
  }
}
