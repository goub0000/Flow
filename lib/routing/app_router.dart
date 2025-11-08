import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/user_roles.dart';
import '../core/theme/app_colors.dart';
import '../core/models/user_model.dart';
import '../core/error/error_handling.dart';
import '../core/models/course_model.dart';
import '../core/models/application_model.dart';
import '../core/models/program_model.dart';
import '../core/models/applicant_model.dart';
import '../core/models/child_model.dart' hide Application;
import '../core/models/counseling_models.dart';
import '../core/models/document_model.dart' as doc_model;
import '../core/models/message_model.dart';
import '../features/authentication/providers/auth_provider.dart';
import '../features/authentication/presentation/screens/login_screen.dart';
import '../features/authentication/presentation/screens/register_screen.dart';
import '../features/authentication/presentation/screens/forgot_password_screen.dart';
import '../features/authentication/presentation/screens/email_verification_screen.dart';
import '../features/authentication/presentation/screens/onboarding_screen.dart';
import '../features/authentication/presentation/screens/biometric_setup_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/home/presentation/modern_home_screen.dart';

// Student
import '../features/student/dashboard/presentation/student_dashboard_screen.dart';
import '../features/student/courses/presentation/courses_list_screen.dart';
import '../features/student/courses/presentation/course_detail_screen.dart';
import '../features/student/applications/presentation/applications_list_screen.dart';
import '../features/student/applications/presentation/application_detail_screen.dart';
import '../features/student/applications/presentation/create_application_screen.dart';
import '../features/student/progress/presentation/progress_screen.dart';

// Institution
import '../features/institution/dashboard/presentation/institution_dashboard_screen.dart';
import '../features/institution/applicants/presentation/applicants_list_screen.dart';
import '../features/institution/applicants/presentation/applicant_detail_screen.dart';
import '../features/institution/programs/presentation/programs_list_screen.dart';
import '../features/institution/programs/presentation/program_detail_screen.dart';
import '../features/institution/programs/presentation/create_program_screen.dart';

// Parent
import '../features/parent/dashboard/presentation/parent_dashboard_screen.dart';
import '../features/parent/children/presentation/children_list_screen.dart';
import '../features/parent/children/presentation/child_detail_screen.dart';

// Counselor
import '../features/counselor/dashboard/presentation/counselor_dashboard_screen.dart';
import '../features/counselor/students/presentation/students_list_screen.dart';
import '../features/counselor/students/presentation/student_detail_screen.dart';
import '../features/counselor/sessions/presentation/sessions_list_screen.dart';
import '../features/counselor/sessions/presentation/create_session_screen.dart';

// Recommender
import '../features/recommender/dashboard/presentation/recommender_dashboard_screen.dart';
import '../features/recommender/requests/presentation/requests_list_screen.dart';
import '../features/recommender/requests/presentation/write_recommendation_screen.dart';

// Admin
import '../features/admin/authentication/presentation/admin_login_screen.dart';
import '../features/admin/dashboard/presentation/admin_dashboard_screen.dart';
import '../features/admin/users/presentation/students_list_screen.dart' as admin_students;
import '../features/admin/users/presentation/student_detail_screen.dart' as admin_student;
import '../features/admin/users/presentation/student_form_screen.dart';
import '../features/admin/users/presentation/institutions_list_screen.dart';
import '../features/admin/users/presentation/institution_detail_screen.dart';
import '../features/admin/users/presentation/institution_form_screen.dart';
import '../features/admin/users/presentation/parents_list_screen.dart';
import '../features/admin/users/presentation/parent_detail_screen.dart';
import '../features/admin/users/presentation/parent_form_screen.dart';
import '../features/admin/users/presentation/counselors_list_screen.dart';
import '../features/admin/users/presentation/counselor_detail_screen.dart';
import '../features/admin/users/presentation/counselor_form_screen.dart';
import '../features/admin/users/presentation/recommenders_list_screen.dart';
import '../features/admin/users/presentation/recommender_detail_screen.dart';
import '../features/admin/users/presentation/recommender_form_screen.dart';
import '../features/admin/users/presentation/admins_list_screen.dart';
import '../features/admin/system/presentation/audit_log_screen.dart';
import '../features/admin/finance/presentation/transactions_screen.dart';
import '../features/admin/content/presentation/content_management_screen.dart';
import '../features/admin/system/presentation/system_settings_screen.dart';
import '../features/admin/analytics/presentation/analytics_dashboard_screen.dart';
import '../features/admin/communications/presentation/communications_hub_screen.dart';
import '../features/admin/support/presentation/support_tickets_screen.dart';
import '../features/admin/cookies/presentation/consent_analytics_screen.dart';
import '../features/admin/cookies/presentation/user_data_viewer_screen.dart';
import '../features/admin/chatbot/presentation/admin_chatbot_dashboard.dart';
import '../features/admin/chatbot/presentation/conversation_history_screen.dart';
import '../features/admin/chatbot/presentation/conversation_detail_screen.dart' as chatbot;
import '../features/admin/shared/widgets/placeholder_screen.dart';

// Shared
import '../features/shared/profile/profile_screen.dart';
import '../features/shared/profile/edit_profile_screen.dart';
import '../features/shared/profile/change_password_screen.dart';
import '../features/shared/settings/settings_screen.dart';
import '../features/shared/settings/notification_preferences_screen.dart';
import '../features/shared/cookies/presentation/cookie_settings_screen.dart';
import '../features/shared/notifications/notifications_screen.dart';
import '../features/shared/messages/presentation/messages_list_screen.dart';
import '../features/shared/messages/presentation/conversation_detail_screen.dart';
import '../features/shared/widgets/message_widgets.dart' as msg_widgets;
import '../features/shared/documents/documents_screen.dart';
import '../features/shared/payments/payment_method_screen.dart';
import '../features/shared/payments/payment_history_screen.dart';

// Find Your Path
import '../features/find_your_path/presentation/screens/find_your_path_landing_screen.dart';
import '../features/find_your_path/presentation/screens/questionnaire_screen.dart';
import '../features/find_your_path/presentation/screens/results_screen.dart';
import '../features/find_your_path/presentation/screens/university_detail_screen.dart';

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _RouterNotifier(ref),
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation.startsWith('/forgot-password') ||
          state.matchedLocation.startsWith('/email-verification') ||
          state.matchedLocation.startsWith('/onboarding') ||
          state.matchedLocation.startsWith('/biometric-setup');
      final isHomeRoute = state.matchedLocation == '/' ||
          state.matchedLocation.startsWith('/home');

      // Check if accessing find-your-path routes (public access)
      final isFindYourPathRoute = state.matchedLocation.startsWith('/find-your-path');

      print('🔀 Router redirect: location=${state.matchedLocation}, isAuthenticated=$isAuthenticated');

      // PRIORITY 1: Redirect authenticated users away from auth routes and home page
      if (isAuthenticated) {
        if (isAuthRoute || isHomeRoute) {
          final user = authState.user!;
          final dashboardRoute = user.activeRole.dashboardRoute;
          print('🔀 Redirecting authenticated user to dashboard: $dashboardRoute');
          return dashboardRoute;
        }
      }

      // PRIORITY 2: Allow unauthenticated access to public routes
      if (isHomeRoute || isFindYourPathRoute) {
        return null;
      }

      // PRIORITY 3: Redirect unauthenticated users to login
      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      // Check role-based access
      if (isAuthenticated && !isAuthRoute) {
        final user = authState.user!;
        final location = state.matchedLocation;

        // Extract the role from the route
        final pathSegments = location.split('/');
        if (pathSegments.length > 1) {
          final routeRole = pathSegments[1];

          // Shared routes accessible to all authenticated users
          if (routeRole == 'profile' ||
              routeRole == 'settings' ||
              routeRole == 'notifications' ||
              routeRole == 'messages' ||
              routeRole == 'documents' ||
              routeRole == 'payments' ||
              routeRole == 'find-your-path') {
            return null;
          }

          // Check if user has access to this role's routes
          if (!_hasRoleAccess(user, routeRole)) {
            return user.activeRole.dashboardRoute;
          }
        }
      }

      return null;
    },
    routes: [
      // ============================================================
      // PUBLIC ROUTES
      // ============================================================

      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const ModernHomeScreen(),
      ),

      // Authentication routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/admin/login',
        name: 'admin-login',
        builder: (context, state) => const AdminLoginScreen(),
      ),

      // Additional authentication routes
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/email-verification',
        name: 'email-verification',
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          return EmailVerificationScreen(
            email: email,
            onVerified: () {
              // Navigate to onboarding after verification
              context.go('/onboarding');
            },
          );
        },
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/biometric-setup',
        name: 'biometric-setup',
        builder: (context, state) {
          final isSetup = state.uri.queryParameters['setup'] == 'true';
          return BiometricSetupScreen(isSetup: isSetup);
        },
      ),

      // ============================================================
      // STUDENT ROUTES
      // ============================================================

      GoRoute(
        path: '/student/dashboard',
        name: 'student-dashboard',
        builder: (context, state) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: '/student/courses',
        name: 'student-courses',
        builder: (context, state) => const CoursesListScreen(),
      ),
      GoRoute(
        path: '/student/courses/:id',
        name: 'student-course-detail',
        builder: (context, state) {
          // Course object should be passed via state.extra
          final course = state.extra as Course?;
          if (course == null) {
            // If no course provided, redirect back to courses list
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/student/courses');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return CourseDetailScreen(course: course);
        },
      ),
      GoRoute(
        path: '/student/applications',
        name: 'student-applications',
        builder: (context, state) => const ApplicationsListScreen(),
      ),
      GoRoute(
        path: '/student/applications/create',
        name: 'student-create-application',
        builder: (context, state) => const CreateApplicationScreen(),
      ),
      GoRoute(
        path: '/student/applications/:id',
        name: 'student-application-detail',
        builder: (context, state) {
          // Application object should be passed via state.extra
          final application = state.extra as Application?;
          if (application == null) {
            // If no application provided, redirect back to applications list
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/student/applications');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return ApplicationDetailScreen(application: application);
        },
      ),
      GoRoute(
        path: '/student/progress',
        name: 'student-progress',
        builder: (context, state) => const ProgressScreen(),
      ),

      // ============================================================
      // INSTITUTION ROUTES
      // ============================================================

      GoRoute(
        path: '/institution/dashboard',
        name: 'institution-dashboard',
        builder: (context, state) => const InstitutionDashboardScreen(),
      ),
      GoRoute(
        path: '/institution/applicants',
        name: 'institution-applicants',
        builder: (context, state) => const ApplicantsListScreen(),
      ),
      // TODO: Re-enable when backend is connected
      // GoRoute(
      //   path: '/institution/applicants/:id',
      //   name: 'institution-applicant-detail',
      //   builder: (context, state) {
      //     final applicantId = state.pathParameters['id']!;
      //     // Fetch applicant from backend
      //     return ApplicantDetailScreen(applicant: applicant);
      //   },
      // ),
      GoRoute(
        path: '/institution/programs',
        name: 'institution-programs',
        builder: (context, state) => const ProgramsListScreen(),
      ),
      GoRoute(
        path: '/institution/programs/create',
        name: 'institution-create-program',
        builder: (context, state) => const CreateProgramScreen(),
      ),
      // TODO: Re-enable when backend is connected
      // GoRoute(
      //   path: '/institution/programs/:id',
      //   name: 'institution-program-detail',
      //   builder: (context, state) {
      //     final programId = state.pathParameters['id']!;
      //     // Fetch program from backend
      //     return ProgramDetailScreen(program: program);
      //   },
      // ),

      // ============================================================
      // PARENT ROUTES
      // ============================================================

      GoRoute(
        path: '/parent/dashboard',
        name: 'parent-dashboard',
        builder: (context, state) => const ParentDashboardScreen(),
      ),
      GoRoute(
        path: '/parent/children',
        name: 'parent-children',
        builder: (context, state) => const ChildrenListScreen(),
      ),
      // TODO: Re-enable when backend is connected
      // GoRoute(
      //   path: '/parent/children/:id',
      //   name: 'parent-child-detail',
      //   builder: (context, state) {
      //     final childId = state.pathParameters['id']!;
      //     // Fetch child from backend
      //     return ChildDetailScreen(child: child);
      //   },
      // ),

      // ============================================================
      // COUNSELOR ROUTES
      // ============================================================

      GoRoute(
        path: '/counselor/dashboard',
        name: 'counselor-dashboard',
        builder: (context, state) => const CounselorDashboardScreen(),
      ),
      GoRoute(
        path: '/counselor/students',
        name: 'counselor-students',
        builder: (context, state) => const StudentsListScreen(),
      ),
      GoRoute(
        path: '/counselor/students/:id',
        name: 'counselor-student-detail',
        builder: (context, state) {
          // Get student from provider using state.extra
          final student = state.extra as StudentRecord;
          return StudentDetailScreen(student: student);
        },
      ),
      GoRoute(
        path: '/counselor/sessions',
        name: 'counselor-sessions',
        builder: (context, state) => const SessionsListScreen(),
      ),
      GoRoute(
        path: '/counselor/sessions/create',
        name: 'counselor-create-session',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final student = extra?['student'] as StudentRecord?;
          return CreateSessionScreen(student: student);
        },
      ),

      // ============================================================
      // RECOMMENDER ROUTES
      // ============================================================

      GoRoute(
        path: '/recommender/dashboard',
        name: 'recommender-dashboard',
        builder: (context, state) => const RecommenderDashboardScreen(),
      ),
      GoRoute(
        path: '/recommender/requests',
        name: 'recommender-requests',
        builder: (context, state) => const RequestsListScreen(),
      ),
      GoRoute(
        path: '/recommender/requests/:id',
        name: 'recommender-write-recommendation',
        builder: (context, state) {
          // Get recommendation from provider using state.extra
          final request = state.extra as Recommendation;
          return WriteRecommendationScreen(request: request);
        },
      ),

      // ============================================================
      // ADMIN ROUTES (All admin roles)
      // ============================================================

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

      // Admin User Management
      GoRoute(
        path: '/admin/system/admins',
        name: 'admin-admins',
        builder: (context, state) => const AdminsListScreen(),
        routes: [
          // TODO: Add admin create and detail routes when screens are implemented
          // GoRoute(
          //   path: 'create',
          //   name: 'admin-admin-create',
          //   builder: (context, state) => const AdminFormScreen(),
          // ),
          // GoRoute(
          //   path: ':id',
          //   name: 'admin-admin-detail',
          //   builder: (context, state) {
          //     final adminId = state.pathParameters['id']!;
          //     return AdminDetailScreen(adminId: adminId);
          //   },
          //   routes: [
          //     GoRoute(
          //       path: 'edit',
          //       name: 'admin-admin-edit',
          //       builder: (context, state) {
          //         final adminId = state.pathParameters['id']!;
          //         return AdminFormScreen(adminId: adminId);
          //       },
          //     ),
          //   ],
          // ),
        ],
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
            builder: (context, state) => const AdminPlaceholderScreen(
              title: 'Courses Management',
              description: 'Manage educational courses, lessons, and curriculum content.',
              icon: Icons.menu_book,
            ),
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

      // ============================================================
      // SPECIALIZED ADMIN ROUTES
      // ============================================================

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
        path: '/admin/courses',
        name: 'admin-courses-management',
        builder: (context, state) => const AdminPlaceholderScreen(
          title: 'Courses Management',
          description: 'Manage all educational courses and their content.',
          icon: Icons.menu_book,
        ),
      ),
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

      // ============================================================
      // SHARED ROUTES (Available to all authenticated users)
      // ============================================================

      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/change-password',
        name: 'change-password',
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/notifications',
        name: 'notification-preferences',
        builder: (context, state) => const NotificationPreferencesScreen(),
      ),
      GoRoute(
        path: '/settings/cookies',
        name: 'cookie-settings',
        builder: (context, state) {
          // Get userId from query parameter or use a default for demo
          final userId = state.uri.queryParameters['userId'] ?? 'demo-user';
          return CookieSettingsScreen(userId: userId);
        },
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const MessagesListScreen(),
      ),
      GoRoute(
        path: '/messages/:id',
        name: 'chat',
        builder: (context, state) {
          final conversationId = state.pathParameters['id']!;
          final conversation = state.extra as msg_widgets.Conversation?;
          return ConversationDetailScreen(
            conversationId: conversationId,
            conversation: conversation,
          );
        },
      ),
      GoRoute(
        path: '/documents',
        name: 'documents',
        builder: (context, state) => const DocumentsScreen(),
      ),
      // TODO: Re-enable when backend is connected
      // GoRoute(
      //   path: '/documents/:id',
      //   name: 'document-viewer',
      //   builder: (context, state) {
      //     final documentId = state.pathParameters['id']!;
      //     // Fetch document from backend
      //     return DocumentViewerScreen(document: document);
      //   },
      // ),

      // Payment routes
      GoRoute(
        path: '/payments/method',
        name: 'payment-method',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PaymentMethodScreen(
            itemId: extra?['itemId'] ?? '',
            itemName: extra?['itemName'] ?? '',
            itemType: extra?['itemType'] ?? '',
            amount: extra?['amount'] ?? 0.0,
            currency: extra?['currency'] ?? 'USD',
          );
        },
      ),
      GoRoute(
        path: '/payments/history',
        name: 'payment-history',
        builder: (context, state) => const PaymentHistoryScreen(),
      ),

      // ============================================================
      // FIND YOUR PATH ROUTES
      // ============================================================

      GoRoute(
        path: '/find-your-path',
        name: 'find-your-path',
        builder: (context, state) => const FindYourPathLandingScreen(),
      ),
      GoRoute(
        path: '/find-your-path/questionnaire',
        name: 'find-your-path-questionnaire',
        builder: (context, state) => const QuestionnaireScreen(),
      ),
      GoRoute(
        path: '/find-your-path/results',
        name: 'find-your-path-results',
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/find-your-path/university/:id',
        name: 'find-your-path-university-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UniversityDetailScreen(universityId: id);
        },
      ),
    ],
    errorBuilder: (context, state) => NotFoundScreen(
      path: state.matchedLocation,
    ),
  );
});

/// Check if user has access to a specific role's routes
bool _hasRoleAccess(UserModel user, String routeRole) {
  switch (routeRole) {
    case 'student':
      return user.activeRole == UserRole.student ||
          user.availableRoles.contains(UserRole.student);
    case 'institution':
      return user.activeRole == UserRole.institution ||
          user.availableRoles.contains(UserRole.institution);
    case 'parent':
      return user.activeRole == UserRole.parent ||
          user.availableRoles.contains(UserRole.parent);
    case 'counselor':
      return user.activeRole == UserRole.counselor ||
          user.availableRoles.contains(UserRole.counselor);
    case 'recommender':
      return user.activeRole == UserRole.recommender ||
          user.availableRoles.contains(UserRole.recommender);
    case 'admin':
      // All admin roles have access to /admin routes
      return user.activeRole.isAdmin ||
          user.availableRoles.any((role) => role.isAdmin);
    default:
      return false;
  }
}

/// Router notifier for refreshing routes on auth state change
class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen(
      authProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }
}
