import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/dashboard_scaffold.dart';
import '../../../shared/cookies/presentation/cookie_banner.dart';
import 'widgets/counselor_overview_tab.dart';
import '../../students/presentation/students_list_screen.dart';
import '../../sessions/presentation/sessions_list_screen.dart';
import '../../../shared/profile/profile_screen.dart';
import '../../../shared/settings/settings_screen.dart';
import '../../../../core/l10n_extension.dart';

class CounselorDashboardScreen extends ConsumerStatefulWidget {
  const CounselorDashboardScreen({super.key});

  @override
  ConsumerState<CounselorDashboardScreen> createState() =>
      _CounselorDashboardScreenState();
}

class _CounselorDashboardScreenState
    extends ConsumerState<CounselorDashboardScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      CounselorOverviewTab(
        onNavigateToStudents: () => setState(() => _currentIndex = 1),
        onNavigateToSessions: () => setState(() => _currentIndex = 2),
      ),
      const StudentsListScreen(),
      const SessionsListScreen(),
      const ProfileScreen(showBackButton: false),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DashboardScaffold(
          title: _getTitle(context),
          currentIndex: _currentIndex,
          onNavigationTap: (index) => setState(() => _currentIndex = index),
          navigationItems: [
            DashboardNavigationItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard,
              label: context.l10n.dashCommonOverview,
            ),
            DashboardNavigationItem(
              icon: Icons.people_outlined,
              activeIcon: Icons.people,
              label: context.l10n.dashCounselorStudents,
            ),
            DashboardNavigationItem(
              icon: Icons.event_outlined,
              activeIcon: Icons.event,
              label: context.l10n.dashCounselorSessions,
            ),
            DashboardNavigationItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: context.l10n.dashCommonProfile,
            ),
            DashboardNavigationItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: context.l10n.dashCommonSettings,
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

  String _getTitle(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return context.l10n.dashCounselorTitle;
      case 1:
        return context.l10n.dashCounselorMyStudents;
      case 2:
        return context.l10n.dashCounselorSessions;
      case 3:
        return context.l10n.dashCommonProfile;
      case 4:
        return context.l10n.dashCommonSettings;
      default:
        return context.l10n.dashCounselorTitle;
    }
  }
}
