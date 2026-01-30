import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/authentication/presentation/admin_login_screen.dart';
import '../../features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import '../../features/admin/users/presentation/students_list_screen.dart' as admin_students;
import '../../features/admin/users/presentation/student_detail_screen.dart' as admin_student;
import '../../features/admin/users/presentation/student_form_screen.dart';
import '../../features/admin/users/presentation/institutions_list_screen.dart';
import '../../features/admin/users/presentation/institution_detail_screen.dart';
import '../../features/admin/users/presentation/institution_form_screen.dart';
import '../../features/admin/users/presentation/parents_list_screen.dart';
import '../../features/admin/users/presentation/parent_detail_screen.dart';
import '../../features/admin/users/presentation/parent_form_screen.dart';
import '../../features/admin/users/presentation/counselors_list_screen.dart';
import '../../features/admin/users/presentation/counselor_detail_screen.dart';
import '../../features/admin/users/presentation/counselor_form_screen.dart';
import '../../features/admin/users/presentation/recommenders_list_screen.dart';
import '../../features/admin/users/presentation/recommender_detail_screen.dart';
import '../../features/admin/users/presentation/recommender_form_screen.dart';
import '../../features/admin/users/presentation/admins_list_screen.dart';
// Admin creation removed for security - admins are created via database or Super Admin promotion
import '../../features/admin/system/presentation/audit_log_screen.dart';
import '../../features/admin/finance/presentation/transactions_screen.dart';
import '../../features/admin/content/presentation/content_management_screen.dart';
import '../../features/admin/system/presentation/system_settings_screen.dart';
import '../../features/admin/analytics/presentation/analytics_dashboard_screen.dart';
import '../../features/admin/communications/presentation/communications_hub_screen.dart';
import '../../features/admin/support/presentation/support_tickets_screen.dart';
import '../../features/admin/cookies/presentation/consent_analytics_screen.dart';
import '../../features/admin/cookies/presentation/user_data_viewer_screen.dart';
import '../../features/admin/chatbot/presentation/admin_chatbot_dashboard.dart';
import '../../features/admin/chatbot/presentation/conversation_history_screen.dart';
import '../../features/admin/chatbot/presentation/conversation_detail_screen.dart' as chatbot;
import '../../features/admin/chatbot/presentation/faq_management_screen.dart';
import '../../features/admin/chatbot/presentation/support_queue_screen.dart';
import '../../features/admin/chatbot/presentation/live_conversations_screen.dart';
import '../../features/admin/content/presentation/page_content_list_screen.dart';
import '../../features/admin/content/presentation/page_content_editor_screen.dart';
import '../../features/admin/shared/widgets/placeholder_screen.dart';
import '../../features/admin/notifications/presentation/notifications_center_screen.dart';
import '../../features/admin/reports/presentation/reports_screen.dart';
import '../../features/admin/shared/widgets/admin_shell.dart';
import '../../features/institution/courses/presentation/course_content_builder_screen.dart';
import '../../features/admin/approvals/presentation/screens/approval_dashboard_screen.dart';
import '../../features/admin/approvals/presentation/screens/approval_list_screen.dart';
import '../../features/admin/approvals/presentation/screens/approval_detail_screen.dart';
import '../../features/admin/approvals/presentation/screens/create_approval_request_screen.dart';
import '../../features/admin/approvals/presentation/screens/approval_config_screen.dart';

/// Custom page with no transition for seamless admin navigation
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({required super.child, super.key})
      : super(
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
        );
}

/// Admin-specific routes (all admin roles)
List<RouteBase> adminRoutes = [
  // Admin login (outside shell - no sidebar/topbar)
  GoRoute(
    path: '/admin/login',
    name: 'admin-login',
    builder: (context, state) => const AdminLoginScreen(),
  ),

  // All admin routes wrapped in ShellRoute for persistent sidebar
  ShellRoute(
    builder: (context, state, child) => AdminShell(child: child),
    routes: [
      // Admin dashboard
      GoRoute(
        path: '/admin/dashboard',
        name: 'admin-dashboard',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminDashboardScreen(),
        ),
      ),

      // User Management
      GoRoute(
        path: '/admin/users/students',
        name: 'admin-students',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const admin_students.StudentsListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'admin-student-create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const StudentFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'admin-student-detail',
            pageBuilder: (context, state) {
              final studentId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: admin_student.StudentDetailScreen(studentId: studentId),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'admin-student-edit',
                pageBuilder: (context, state) {
                  final studentId = state.pathParameters['id']!;
                  return NoTransitionPage(
                    child: StudentFormScreen(studentId: studentId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin/users/institutions',
        name: 'admin-institutions',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const InstitutionsListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'admin-institution-create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const InstitutionFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'admin-institution-detail',
            pageBuilder: (context, state) {
              final institutionId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: InstitutionDetailScreen(institutionId: institutionId),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'admin-institution-edit',
                pageBuilder: (context, state) {
                  final institutionId = state.pathParameters['id']!;
                  return NoTransitionPage(
                    child: InstitutionFormScreen(institutionId: institutionId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin/users/parents',
        name: 'admin-parents',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ParentsListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'admin-parent-create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ParentFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'admin-parent-detail',
            pageBuilder: (context, state) {
              final parentId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: ParentDetailScreen(parentId: parentId),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'admin-parent-edit',
                pageBuilder: (context, state) {
                  final parentId = state.pathParameters['id']!;
                  return NoTransitionPage(
                    child: ParentFormScreen(parentId: parentId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin/users/counselors',
        name: 'admin-counselors',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const CounselorsListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'admin-counselor-create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const CounselorFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'admin-counselor-detail',
            pageBuilder: (context, state) {
              final counselorId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: CounselorDetailScreen(counselorId: counselorId),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'admin-counselor-edit',
                pageBuilder: (context, state) {
                  final counselorId = state.pathParameters['id']!;
                  return NoTransitionPage(
                    child: CounselorFormScreen(counselorId: counselorId),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/admin/users/recommenders',
        name: 'admin-recommenders',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const RecommendersListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'create',
            name: 'admin-recommender-create',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const RecommenderFormScreen(),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'admin-recommender-detail',
            pageBuilder: (context, state) {
              final recommenderId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: RecommenderDetailScreen(recommenderId: recommenderId),
              );
            },
            routes: [
              GoRoute(
                path: 'edit',
                name: 'admin-recommender-edit',
                pageBuilder: (context, state) {
                  final recommenderId = state.pathParameters['id']!;
                  return NoTransitionPage(
                    child: RecommenderFormScreen(recommenderId: recommenderId),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      // Admin User Management (view only - creation is done via database)
      GoRoute(
        path: '/admin/system/admins',
        name: 'admin-admins',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminsListScreen(),
        ),
      ),

      // Financial Management
      GoRoute(
        path: '/admin/finance/transactions',
        name: 'admin-transactions',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const TransactionsScreen(),
        ),
      ),

      // Chatbot Management
      GoRoute(
        path: '/admin/chatbot',
        name: 'admin-chatbot',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminChatbotDashboard(),
        ),
      ),
      GoRoute(
        path: '/admin/chatbot/conversations',
        name: 'admin-chatbot-conversations',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ConversationHistoryScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/chatbot/conversation/:id',
        name: 'admin-chatbot-conversation-detail',
        pageBuilder: (context, state) {
          final conversationId = state.pathParameters['id']!;
          return NoTransitionPage(
            child: chatbot.ConversationDetailScreen(conversationId: conversationId),
          );
        },
      ),
      GoRoute(
        path: '/admin/chatbot/faqs',
        name: 'admin-chatbot-faqs',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const FAQManagementScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/chatbot/queue',
        name: 'admin-chatbot-queue',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const SupportQueueScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/chatbot/live',
        name: 'admin-chatbot-live',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const LiveConversationsScreen(),
        ),
      ),

      // Content Management
      GoRoute(
        path: '/admin/content',
        name: 'admin-content',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ContentManagementScreen(),
        ),
        routes: [
          GoRoute(
            path: 'courses',
            name: 'admin-content-courses',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ContentManagementScreen(pageTitle: 'Courses'),
            ),
          ),
          GoRoute(
            path: 'curriculum',
            name: 'admin-content-curriculum',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ContentManagementScreen(pageTitle: 'Curriculum'),
            ),
          ),
          GoRoute(
            path: 'resources',
            name: 'admin-content-resources',
            pageBuilder: (context, state) => NoTransitionPage(
              child: const ContentManagementScreen(pageTitle: 'Resources'),
            ),
          ),
          // Course content builder for editing
          GoRoute(
            path: ':id/edit',
            name: 'admin-content-edit',
            pageBuilder: (context, state) {
              final courseId = state.pathParameters['id']!;
              return NoTransitionPage(
                child: CourseContentBuilderScreen(courseId: courseId),
              );
            },
          ),
        ],
      ),

      // Page Content Management (CMS for footer pages)
      GoRoute(
        path: '/admin/pages',
        name: 'admin-pages',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const PageContentListScreen(),
        ),
        routes: [
          GoRoute(
            path: ':slug/edit',
            name: 'admin-page-edit',
            pageBuilder: (context, state) {
              final pageSlug = state.pathParameters['slug']!;
              return NoTransitionPage(
                child: PageContentEditorScreen(pageSlug: pageSlug),
              );
            },
          ),
        ],
      ),

      // System Administration
      GoRoute(
        path: '/admin/system',
        name: 'admin-system',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'System Administration',
            description: 'Manage system settings, admins, and audit logs. Use the sidebar to access specific system features.',
            icon: Icons.settings,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/system/audit-logs',
        name: 'admin-audit-logs',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AuditLogScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/system/settings',
        name: 'admin-system-settings',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const SystemSettingsScreen(),
        ),
      ),

      // Cookie Management
      GoRoute(
        path: '/admin/cookies/analytics',
        name: 'admin-consent-analytics',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ConsentAnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/cookies/users',
        name: 'admin-user-data',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const UserDataViewerScreen(),
        ),
      ),

      // Analytics & Reports
      GoRoute(
        path: '/admin/analytics',
        name: 'admin-analytics',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AnalyticsDashboardScreen(),
        ),
      ),

      // Communications
      GoRoute(
        path: '/admin/communications',
        name: 'admin-communications',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const CommunicationsHubScreen(),
        ),
      ),

      // Notifications
      GoRoute(
        path: '/admin/notifications',
        name: 'admin-notifications',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const NotificationsCenterScreen(),
        ),
      ),

      // Support & Helpdesk
      GoRoute(
        path: '/admin/support/tickets',
        name: 'admin-support-tickets',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const SupportTicketsScreen(),
        ),
      ),

      // General User Management (for Regional Admin)
      GoRoute(
        path: '/admin/users',
        name: 'admin-users',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'User Management',
            description: 'Manage all users in the system. Use the sidebar menu to access specific user types.',
            icon: Icons.people,
          ),
        ),
      ),

      // Content Admin Routes
      GoRoute(
        path: '/admin/curriculum',
        name: 'admin-curriculum-management',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Curriculum Management',
            description: 'Design and manage curriculum structure.',
            icon: Icons.school,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/assessments',
        name: 'admin-assessments',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Assessments Management',
            description: 'Create and manage quizzes, tests, and assessments.',
            icon: Icons.quiz,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/resources',
        name: 'admin-resources-management',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Resources Management',
            description: 'Manage educational resources and learning materials.',
            icon: Icons.folder,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/translations',
        name: 'admin-translations',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Translations Management',
            description: 'Manage multilingual content and translations.',
            icon: Icons.translate,
          ),
        ),
      ),

      // Support Admin Routes
      GoRoute(
        path: '/admin/tickets',
        name: 'admin-tickets',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Support Tickets',
            description: 'View and manage customer support tickets.',
            icon: Icons.confirmation_number,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/chat',
        name: 'admin-live-chat',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Live Chat Support',
            description: 'Provide real-time chat support to users.',
            icon: Icons.chat,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/knowledge-base',
        name: 'admin-knowledge-base',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Knowledge Base',
            description: 'Manage help articles and documentation.',
            icon: Icons.help,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/user-lookup',
        name: 'admin-user-lookup',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'User Lookup',
            description: 'Search and view detailed user information.',
            icon: Icons.search,
          ),
        ),
      ),

      // Finance Admin Routes
      GoRoute(
        path: '/admin/transactions',
        name: 'admin-all-transactions',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Transactions',
            description: 'View and manage all financial transactions.',
            icon: Icons.receipt_long,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/refunds',
        name: 'admin-refunds',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Refunds Management',
            description: 'Process and track refund requests.',
            icon: Icons.replay,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/settlements',
        name: 'admin-settlements',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Settlements',
            description: 'Manage payment settlements and disbursements.',
            icon: Icons.account_balance,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/fraud',
        name: 'admin-fraud-detection',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Fraud Detection',
            description: 'Monitor and prevent fraudulent activities.',
            icon: Icons.warning,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/reports',
        name: 'admin-financial-reports',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ReportsScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/fee-config',
        name: 'admin-fee-config',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Fee Configuration',
            description: 'Configure platform fees and pricing.',
            icon: Icons.settings,
          ),
        ),
      ),

      // Analytics Admin Routes
      GoRoute(
        path: '/admin/data-explorer',
        name: 'admin-data-explorer',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Data Explorer',
            description: 'Explore and analyze platform data.',
            icon: Icons.grid_on,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/sql',
        name: 'admin-sql-queries',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'SQL Query Tool',
            description: 'Run custom SQL queries for advanced analytics.',
            icon: Icons.query_stats,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/dashboards',
        name: 'admin-custom-dashboards',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Custom Dashboards',
            description: 'Create and manage custom analytics dashboards.',
            icon: Icons.dashboard_customize,
          ),
        ),
      ),
      GoRoute(
        path: '/admin/exports',
        name: 'admin-data-exports',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Data Exports',
            description: 'Export data in various formats for analysis.',
            icon: Icons.download,
          ),
        ),
      ),

      // Regional Admin Institutions Route
      GoRoute(
        path: '/admin/institutions',
        name: 'admin-all-institutions',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const AdminPlaceholderScreen(
            title: 'Institutions Management',
            description: 'Manage all educational institutions in your region.',
            icon: Icons.business,
          ),
        ),
      ),

      // Approval Workflow Routes
      GoRoute(
        path: '/admin/approvals',
        name: 'admin-approvals',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ApprovalDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/approvals/list',
        name: 'admin-approvals-list',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ApprovalListScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/approvals/create',
        name: 'admin-approval-create',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const CreateApprovalRequestScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/approvals/config',
        name: 'admin-approvals-config',
        pageBuilder: (context, state) => NoTransitionPage(
          child: const ApprovalConfigScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/approvals/:id',
        name: 'admin-approval-detail',
        pageBuilder: (context, state) {
          final approvalId = state.pathParameters['id']!;
          return NoTransitionPage(
            child: ApprovalDetailScreen(requestId: approvalId),
          );
        },
      ),
    ],
  ),
];
