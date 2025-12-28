import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import 'widgets/parent_home_tab.dart';
import '../../children/presentation/children_list_screen.dart';
import '../../../shared/notifications/notifications_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  final int initialTab;

  const ParentDashboardScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<ParentDashboardScreen> createState() =>
      _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab.clamp(0, 4);
    _screens = [
      ParentHomeTab(
        onNavigateToChildren: () => setState(() => _currentIndex = 1),
        onNavigateToNotifications: () => setState(() => _currentIndex = 2),
        onNavigateToSettings: () => setState(() => _currentIndex = 4),
      ),
      const ChildrenListScreen(),
      const NotificationsScreen(),
      const ProfileScreen(showBackButton: false),
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
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
            ),
            DashboardNavigationItem(
              icon: Icons.child_care_outlined,
              activeIcon: Icons.child_care,
              label: 'Children',
            ),
            DashboardNavigationItem(
              icon: Icons.notifications_outlined,
              activeIcon: Icons.notifications,
              label: 'Alerts',
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
        return 'Parent Dashboard';
      case 1:
        return 'My Children';
      case 2:
        return 'Alerts';
      case 3:
        return 'Profile';
      case 4:
        return 'Settings';
      default:
        return 'Parent Dashboard';
    }
  }
}
