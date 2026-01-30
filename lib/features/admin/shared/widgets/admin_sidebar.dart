import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/admin_user_model.dart';

/// Navigation item for admin sidebar
class AdminNavigationItem {
  final IconData icon;
  final String label;
  final String route;
  final List<AdminNavigationItem>? children;

  const AdminNavigationItem({
    required this.icon,
    required this.label,
    required this.route,
    this.children,
  });
}

/// Admin Sidebar - Collapsible navigation with role-based menu items
class AdminSidebar extends StatefulWidget {
  final AdminUser adminUser;

  const AdminSidebar({
    required this.adminUser,
    super.key,
  });

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  bool _isCollapsed = false;
  String? _expandedItem;

  @override
  Widget build(BuildContext context) {
    final navigationItems = _getNavigationItems();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 80 : 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // Logo and collapse button
          _buildHeader(),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: navigationItems
                  .map((item) => _buildNavigationItem(item))
                  .toList(),
            ),
          ),

          // Collapse toggle button
          _buildCollapseButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // Logo icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Flow Admin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationItem(AdminNavigationItem item) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isActive = currentLocation.startsWith(item.route);
    final hasChildren = item.children != null && item.children!.isNotEmpty;
    final isExpanded = _expandedItem == item.route;

    return Column(
      children: [
        InkWell(
          onTap: () {
            if (hasChildren) {
              setState(() {
                _expandedItem = isExpanded ? null : item.route;
              });
            } else {
              context.go(item.route);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 20,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          color: isActive ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (hasChildren)
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
        // Children
        if (hasChildren && isExpanded && !_isCollapsed)
          ...item.children!.map(
            (child) => Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _buildChildNavigationItem(child),
            ),
          ),
      ],
    );
  }

  Widget _buildChildNavigationItem(AdminNavigationItem item) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final isActive = currentLocation == item.route;

    return InkWell(
      onTap: () => context.go(item.route),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 18,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapseButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isCollapsed = !_isCollapsed;
            if (_isCollapsed) {
              _expandedItem = null;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                color: AppColors.textSecondary,
              ),
              if (!_isCollapsed) ...[
                const SizedBox(width: 8),
                Text(
                  'Collapse',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<AdminNavigationItem> _getNavigationItems() {
    switch (widget.adminUser.adminRole) {
      case UserRole.superAdmin:
        return _getSuperAdminItems();
      case UserRole.regionalAdmin:
        return _getRegionalAdminItems();
      case UserRole.contentAdmin:
        return _getContentAdminItems();
      case UserRole.supportAdmin:
        return _getSupportAdminItems();
      case UserRole.financeAdmin:
        return _getFinanceAdminItems();
      case UserRole.analyticsAdmin:
        return _getAnalyticsAdminItems();
      default:
        return [];
    }
  }

  List<AdminNavigationItem> _getSuperAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.people,
        label: 'User Management',
        route: '/admin/users',
        children: [
          AdminNavigationItem(
            icon: Icons.school,
            label: 'Students',
            route: '/admin/users/students',
          ),
          AdminNavigationItem(
            icon: Icons.business,
            label: 'Institutions',
            route: '/admin/users/institutions',
          ),
          AdminNavigationItem(
            icon: Icons.family_restroom,
            label: 'Parents',
            route: '/admin/users/parents',
          ),
          AdminNavigationItem(
            icon: Icons.support_agent,
            label: 'Counselors',
            route: '/admin/users/counselors',
          ),
          AdminNavigationItem(
            icon: Icons.rate_review,
            label: 'Recommenders',
            route: '/admin/users/recommenders',
          ),
          AdminNavigationItem(
            icon: Icons.admin_panel_settings,
            label: 'Admins',
            route: '/admin/system/admins',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.library_books,
        label: 'Content',
        route: '/admin/content',
        children: [
          AdminNavigationItem(
            icon: Icons.menu_book,
            label: 'Courses',
            route: '/admin/content/courses',
          ),
          AdminNavigationItem(
            icon: Icons.school,
            label: 'Curriculum',
            route: '/admin/content/curriculum',
          ),
          AdminNavigationItem(
            icon: Icons.folder,
            label: 'Resources',
            route: '/admin/content/resources',
          ),
          AdminNavigationItem(
            icon: Icons.article,
            label: 'Page Content (CMS)',
            route: '/admin/pages',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.attach_money,
        label: 'Financial',
        route: '/admin/finance/transactions',
        children: [
          AdminNavigationItem(
            icon: Icons.receipt,
            label: 'Transactions',
            route: '/admin/finance/transactions',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.analytics,
        label: 'Analytics',
        route: '/admin/analytics',
      ),
      const AdminNavigationItem(
        icon: Icons.notifications,
        label: 'Communications',
        route: '/admin/communications',
      ),
      const AdminNavigationItem(
        icon: Icons.chat,
        label: 'Chatbot',
        route: '/admin/chatbot',
      ),
      const AdminNavigationItem(
        icon: Icons.support,
        label: 'Support',
        route: '/admin/support/tickets',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
        children: [
          AdminNavigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/admin/approvals',
          ),
          AdminNavigationItem(
            icon: Icons.list,
            label: 'All Requests',
            route: '/admin/approvals/list',
          ),
          AdminNavigationItem(
            icon: Icons.add_circle,
            label: 'New Request',
            route: '/admin/approvals/create',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.settings,
        label: 'System',
        route: '/admin/system',
        children: [
          AdminNavigationItem(
            icon: Icons.admin_panel_settings,
            label: 'Admins',
            route: '/admin/system/admins',
          ),
          AdminNavigationItem(
            icon: Icons.settings_applications,
            label: 'Settings',
            route: '/admin/system/settings',
          ),
          AdminNavigationItem(
            icon: Icons.history,
            label: 'Audit Logs',
            route: '/admin/system/audit-logs',
          ),
          AdminNavigationItem(
            icon: Icons.cookie,
            label: 'Cookie Analytics',
            route: '/admin/cookies/analytics',
          ),
          AdminNavigationItem(
            icon: Icons.people_alt,
            label: 'User Cookie Data',
            route: '/admin/cookies/users',
          ),
        ],
      ),
    ];
  }

  List<AdminNavigationItem> _getRegionalAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.people,
        label: 'User Management',
        route: '/admin/users',
        children: [
          AdminNavigationItem(
            icon: Icons.school,
            label: 'Students',
            route: '/admin/users/students',
          ),
          AdminNavigationItem(
            icon: Icons.business,
            label: 'Institutions',
            route: '/admin/users/institutions',
          ),
          AdminNavigationItem(
            icon: Icons.family_restroom,
            label: 'Parents',
            route: '/admin/users/parents',
          ),
          AdminNavigationItem(
            icon: Icons.support_agent,
            label: 'Counselors',
            route: '/admin/users/counselors',
          ),
          AdminNavigationItem(
            icon: Icons.rate_review,
            label: 'Recommenders',
            route: '/admin/users/recommenders',
          ),
          AdminNavigationItem(
            icon: Icons.admin_panel_settings,
            label: 'Admins',
            route: '/admin/system/admins',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.library_books,
        label: 'Content',
        route: '/admin/content',
        children: [
          AdminNavigationItem(
            icon: Icons.menu_book,
            label: 'Courses',
            route: '/admin/content/courses',
          ),
          AdminNavigationItem(
            icon: Icons.school,
            label: 'Curriculum',
            route: '/admin/content/curriculum',
          ),
          AdminNavigationItem(
            icon: Icons.folder,
            label: 'Resources',
            route: '/admin/content/resources',
          ),
          AdminNavigationItem(
            icon: Icons.article,
            label: 'Page Content (CMS)',
            route: '/admin/pages',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.attach_money,
        label: 'Financial',
        route: '/admin/finance/transactions',
        children: [
          AdminNavigationItem(
            icon: Icons.receipt,
            label: 'Transactions',
            route: '/admin/finance/transactions',
          ),
        ],
      ),
      const AdminNavigationItem(
        icon: Icons.analytics,
        label: 'Analytics',
        route: '/admin/analytics',
      ),
      const AdminNavigationItem(
        icon: Icons.notifications,
        label: 'Communications',
        route: '/admin/communications',
      ),
      const AdminNavigationItem(
        icon: Icons.chat,
        label: 'Chatbot',
        route: '/admin/chatbot',
      ),
      const AdminNavigationItem(
        icon: Icons.support,
        label: 'Support',
        route: '/admin/support/tickets',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
        children: [
          AdminNavigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/admin/approvals',
          ),
          AdminNavigationItem(
            icon: Icons.list,
            label: 'All Requests',
            route: '/admin/approvals/list',
          ),
          AdminNavigationItem(
            icon: Icons.add_circle,
            label: 'New Request',
            route: '/admin/approvals/create',
          ),
        ],
      ),
    ];
  }

  List<AdminNavigationItem> _getContentAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
      ),
      const AdminNavigationItem(
        icon: Icons.menu_book,
        label: 'Courses',
        route: '/admin/courses',
      ),
      const AdminNavigationItem(
        icon: Icons.school,
        label: 'Curriculum',
        route: '/admin/curriculum',
      ),
      const AdminNavigationItem(
        icon: Icons.quiz,
        label: 'Assessments',
        route: '/admin/assessments',
      ),
      const AdminNavigationItem(
        icon: Icons.folder,
        label: 'Resources',
        route: '/admin/resources',
      ),
      const AdminNavigationItem(
        icon: Icons.article,
        label: 'Page Content (CMS)',
        route: '/admin/pages',
      ),
      const AdminNavigationItem(
        icon: Icons.translate,
        label: 'Translations',
        route: '/admin/translations',
      ),
      const AdminNavigationItem(
        icon: Icons.analytics,
        label: 'Analytics',
        route: '/admin/analytics',
      ),
    ];
  }

  List<AdminNavigationItem> _getSupportAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
      ),
      const AdminNavigationItem(
        icon: Icons.confirmation_number,
        label: 'Tickets',
        route: '/admin/tickets',
      ),
      const AdminNavigationItem(
        icon: Icons.chat,
        label: 'Live Chat',
        route: '/admin/chat',
      ),
      const AdminNavigationItem(
        icon: Icons.help,
        label: 'Knowledge Base',
        route: '/admin/knowledge-base',
      ),
      const AdminNavigationItem(
        icon: Icons.people,
        label: 'User Lookup',
        route: '/admin/user-lookup',
      ),
      const AdminNavigationItem(
        icon: Icons.analytics,
        label: 'Analytics',
        route: '/admin/analytics',
      ),
    ];
  }

  List<AdminNavigationItem> _getFinanceAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
      ),
      const AdminNavigationItem(
        icon: Icons.receipt_long,
        label: 'Transactions',
        route: '/admin/transactions',
      ),
      const AdminNavigationItem(
        icon: Icons.replay,
        label: 'Refunds',
        route: '/admin/refunds',
      ),
      const AdminNavigationItem(
        icon: Icons.account_balance,
        label: 'Settlements',
        route: '/admin/settlements',
      ),
      const AdminNavigationItem(
        icon: Icons.warning,
        label: 'Fraud Detection',
        route: '/admin/fraud',
      ),
      const AdminNavigationItem(
        icon: Icons.assessment,
        label: 'Reports',
        route: '/admin/reports',
      ),
      const AdminNavigationItem(
        icon: Icons.settings,
        label: 'Fee Config',
        route: '/admin/fee-config',
      ),
    ];
  }

  List<AdminNavigationItem> _getAnalyticsAdminItems() {
    return [
      const AdminNavigationItem(
        icon: Icons.dashboard,
        label: 'Dashboard',
        route: '/admin/dashboard',
      ),
      const AdminNavigationItem(
        icon: Icons.approval,
        label: 'Approvals',
        route: '/admin/approvals',
      ),
      const AdminNavigationItem(
        icon: Icons.bar_chart,
        label: 'Custom Reports',
        route: '/admin/reports',
      ),
      const AdminNavigationItem(
        icon: Icons.grid_on,
        label: 'Data Explorer',
        route: '/admin/data-explorer',
      ),
      const AdminNavigationItem(
        icon: Icons.query_stats,
        label: 'SQL Queries',
        route: '/admin/sql',
      ),
      const AdminNavigationItem(
        icon: Icons.dashboard_customize,
        label: 'Dashboards',
        route: '/admin/dashboards',
      ),
      const AdminNavigationItem(
        icon: Icons.download,
        label: 'Exports',
        route: '/admin/exports',
      ),
    ];
  }
}
