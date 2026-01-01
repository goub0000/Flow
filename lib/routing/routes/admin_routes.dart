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
import '../../features/admin/shared/widgets/placeholder_screen.dart';

/// Admin-specific routes (all admin roles)
List<RouteBase> adminRoutes = [
  // Admin login
  GoRoute(
    path: '/admin/login',
    name: 'admin-login',
    builder: (context, state) => const AdminLoginScreen(),
  ),

  // Admin dashboard
  GoRoute(
    path: '/admin/dashboard',
    name: 'admin-dashboard',
    builder: (context, state) => const AdminDashboardScreen(),
  ),

  // User Management
  GoRoute(
    path: '/admin/users/students',
    name: 'admin-students',
    builder: (context, state) => const admin_students.StudentsListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        name: 'admin-student-create',
        builder: (context, state) => const StudentFormScreen(),
      ),
      GoRoute(
        path: ':id',
        name: 'admin-student-detail',
        builder: (context, state) {
          final studentId = state.pathParameters['id']!;
          return admin_student.StudentDetailScreen(studentId: studentId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'admin-student-edit',
            builder: (context, state) {
              final studentId = state.pathParameters['id']!;
              return StudentFormScreen(studentId: studentId);
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/admin/users/institutions',
    name: 'admin-institutions',
    builder: (context, state) => const InstitutionsListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        name: 'admin-institution-create',
        builder: (context, state) => const InstitutionFormScreen(),
      ),
      GoRoute(
        path: ':id',
        name: 'admin-institution-detail',
        builder: (context, state) {
          final institutionId = state.pathParameters['id']!;
          return InstitutionDetailScreen(institutionId: institutionId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'admin-institution-edit',
            builder: (context, state) {
              final institutionId = state.pathParameters['id']!;
              return InstitutionFormScreen(institutionId: institutionId);
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/admin/users/parents',
    name: 'admin-parents',
    builder: (context, state) => const ParentsListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        name: 'admin-parent-create',
        builder: (context, state) => const ParentFormScreen(),
      ),
      GoRoute(
        path: ':id',
        name: 'admin-parent-detail',
        builder: (context, state) {
          final parentId = state.pathParameters['id']!;
          return ParentDetailScreen(parentId: parentId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'admin-parent-edit',
            builder: (context, state) {
              final parentId = state.pathParameters['id']!;
              return ParentFormScreen(parentId: parentId);
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/admin/users/counselors',
    name: 'admin-counselors',
    builder: (context, state) => const CounselorsListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        name: 'admin-counselor-create',
        builder: (context, state) => const CounselorFormScreen(),
      ),
      GoRoute(
        path: ':id',
        name: 'admin-counselor-detail',
        builder: (context, state) {
          final counselorId = state.pathParameters['id']!;
          return CounselorDetailScreen(counselorId: counselorId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'admin-counselor-edit',
            builder: (context, state) {
              final counselorId = state.pathParameters['id']!;
              return CounselorFormScreen(counselorId: counselorId);
            },
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/admin/users/recommenders',
    name: 'admin-recommenders',
    builder: (context, state) => const RecommendersListScreen(),
    routes: [
      GoRoute(
        path: 'create',
        name: 'admin-recommender-create',
        builder: (context, state) => const RecommenderFormScreen(),
      ),
      GoRoute(
        path: ':id',
        name: 'admin-recommender-detail',
        builder: (context, state) {
          final recommenderId = state.pathParameters['id']!;
          return RecommenderDetailScreen(recommenderId: recommenderId);
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'admin-recommender-edit',
            builder: (context, state) {
              final recommenderId = state.pathParameters['id']!;
              return RecommenderFormScreen(recommenderId: recommenderId);
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
    builder: (context, state) => const AdminsListScreen(),
  ),

  // Financial Management
  GoRoute(
    path: '/admin/finance/transactions',
    name: 'admin-transactions',
    builder: (context, state) => const TransactionsScreen(),
  ),

  // Chatbot Management
  GoRoute(
    path: '/admin/chatbot',
    name: 'admin-chatbot',
    builder: (context, state) => const AdminChatbotDashboard(),
  ),
  GoRoute(
    path: '/admin/chatbot/conversations',
    name: 'admin-chatbot-conversations',
    builder: (context, state) => const ConversationHistoryScreen(),
  ),
  GoRoute(
    path: '/admin/chatbot/conversation/:id',
    name: 'admin-chatbot-conversation-detail',
    builder: (context, state) {
      final conversationId = state.pathParameters['id']!;
      return chatbot.ConversationDetailScreen(conversationId: conversationId);
    },
  ),

  // Content Management
  GoRoute(
    path: '/admin/content',
    name: 'admin-content',
    builder: (context, state) => const ContentManagementScreen(),
    routes: [
      GoRoute(
        path: 'courses',
        name: 'admin-content-courses',
        builder: (context, state) => const ContentManagementScreen(),
      ),
      GoRoute(
        path: 'curriculum',
        name: 'admin-content-curriculum',
        builder: (context, state) => const AdminPlaceholderScreen(
          title: 'Curriculum Management',
          description: 'Design and organize curriculum structure and learning paths.',
          icon: Icons.school,
        ),
      ),
      GoRoute(
        path: 'resources',
        name: 'admin-content-resources',
        builder: (context, state) => const AdminPlaceholderScreen(
          title: 'Resources Management',
          description: 'Manage educational resources, materials, and learning assets.',
          icon: Icons.folder,
        ),
      ),
    ],
  ),

  // System Administration
  GoRoute(
    path: '/admin/system',
    name: 'admin-system',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'System Administration',
      description: 'Manage system settings, admins, and audit logs. Use the sidebar to access specific system features.',
      icon: Icons.settings,
    ),
  ),
  GoRoute(
    path: '/admin/system/audit-logs',
    name: 'admin-audit-logs',
    builder: (context, state) => const AuditLogScreen(),
  ),
  GoRoute(
    path: '/admin/system/settings',
    name: 'admin-system-settings',
    builder: (context, state) => const SystemSettingsScreen(),
  ),

  // Cookie Management
  GoRoute(
    path: '/admin/cookies/analytics',
    name: 'admin-consent-analytics',
    builder: (context, state) => const ConsentAnalyticsScreen(),
  ),
  GoRoute(
    path: '/admin/cookies/users',
    name: 'admin-user-data',
    builder: (context, state) => const UserDataViewerScreen(),
  ),

  // Analytics & Reports
  GoRoute(
    path: '/admin/analytics',
    name: 'admin-analytics',
    builder: (context, state) => const AnalyticsDashboardScreen(),
  ),

  // Communications
  GoRoute(
    path: '/admin/communications',
    name: 'admin-communications',
    builder: (context, state) => const CommunicationsHubScreen(),
  ),

  // Support & Helpdesk
  GoRoute(
    path: '/admin/support/tickets',
    name: 'admin-support-tickets',
    builder: (context, state) => const SupportTicketsScreen(),
  ),

  // General User Management (for Regional Admin)
  GoRoute(
    path: '/admin/users',
    name: 'admin-users',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'User Management',
      description: 'Manage all users in the system. Use the sidebar menu to access specific user types.',
      icon: Icons.people,
    ),
  ),

  // Content Admin Routes
  GoRoute(
    path: '/admin/curriculum',
    name: 'admin-curriculum-management',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Curriculum Management',
      description: 'Design and manage curriculum structure.',
      icon: Icons.school,
    ),
  ),
  GoRoute(
    path: '/admin/assessments',
    name: 'admin-assessments',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Assessments Management',
      description: 'Create and manage quizzes, tests, and assessments.',
      icon: Icons.quiz,
    ),
  ),
  GoRoute(
    path: '/admin/resources',
    name: 'admin-resources-management',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Resources Management',
      description: 'Manage educational resources and learning materials.',
      icon: Icons.folder,
    ),
  ),
  GoRoute(
    path: '/admin/translations',
    name: 'admin-translations',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Translations Management',
      description: 'Manage multilingual content and translations.',
      icon: Icons.translate,
    ),
  ),

  // Support Admin Routes
  GoRoute(
    path: '/admin/tickets',
    name: 'admin-tickets',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Support Tickets',
      description: 'View and manage customer support tickets.',
      icon: Icons.confirmation_number,
    ),
  ),
  GoRoute(
    path: '/admin/chat',
    name: 'admin-live-chat',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Live Chat Support',
      description: 'Provide real-time chat support to users.',
      icon: Icons.chat,
    ),
  ),
  GoRoute(
    path: '/admin/knowledge-base',
    name: 'admin-knowledge-base',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Knowledge Base',
      description: 'Manage help articles and documentation.',
      icon: Icons.help,
    ),
  ),
  GoRoute(
    path: '/admin/user-lookup',
    name: 'admin-user-lookup',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'User Lookup',
      description: 'Search and view detailed user information.',
      icon: Icons.search,
    ),
  ),

  // Finance Admin Routes
  GoRoute(
    path: '/admin/transactions',
    name: 'admin-all-transactions',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Transactions',
      description: 'View and manage all financial transactions.',
      icon: Icons.receipt_long,
    ),
  ),
  GoRoute(
    path: '/admin/refunds',
    name: 'admin-refunds',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Refunds Management',
      description: 'Process and track refund requests.',
      icon: Icons.replay,
    ),
  ),
  GoRoute(
    path: '/admin/settlements',
    name: 'admin-settlements',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Settlements',
      description: 'Manage payment settlements and disbursements.',
      icon: Icons.account_balance,
    ),
  ),
  GoRoute(
    path: '/admin/fraud',
    name: 'admin-fraud-detection',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Fraud Detection',
      description: 'Monitor and prevent fraudulent activities.',
      icon: Icons.warning,
    ),
  ),
  GoRoute(
    path: '/admin/reports',
    name: 'admin-financial-reports',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Financial Reports',
      description: 'Generate and view financial reports and analytics.',
      icon: Icons.assessment,
    ),
  ),
  GoRoute(
    path: '/admin/fee-config',
    name: 'admin-fee-config',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Fee Configuration',
      description: 'Configure platform fees and pricing.',
      icon: Icons.settings,
    ),
  ),

  // Analytics Admin Routes
  GoRoute(
    path: '/admin/data-explorer',
    name: 'admin-data-explorer',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Data Explorer',
      description: 'Explore and analyze platform data.',
      icon: Icons.grid_on,
    ),
  ),
  GoRoute(
    path: '/admin/sql',
    name: 'admin-sql-queries',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'SQL Query Tool',
      description: 'Run custom SQL queries for advanced analytics.',
      icon: Icons.query_stats,
    ),
  ),
  GoRoute(
    path: '/admin/dashboards',
    name: 'admin-custom-dashboards',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Custom Dashboards',
      description: 'Create and manage custom analytics dashboards.',
      icon: Icons.dashboard_customize,
    ),
  ),
  GoRoute(
    path: '/admin/exports',
    name: 'admin-data-exports',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Data Exports',
      description: 'Export data in various formats for analysis.',
      icon: Icons.download,
    ),
  ),

  // Regional Admin Institutions Route
  GoRoute(
    path: '/admin/institutions',
    name: 'admin-all-institutions',
    builder: (context, state) => const AdminPlaceholderScreen(
      title: 'Institutions Management',
      description: 'Manage all educational institutions in your region.',
      icon: Icons.business,
    ),
  ),
];