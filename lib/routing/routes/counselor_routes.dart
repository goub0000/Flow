import 'package:go_router/go_router.dart';
import '../../core/models/counseling_models.dart';
import '../../features/counselor/dashboard/presentation/counselor_dashboard_screen.dart';
import '../../features/counselor/students/presentation/students_list_screen.dart';
import '../../features/counselor/students/presentation/student_detail_screen.dart';
import '../../features/counselor/sessions/presentation/sessions_list_screen.dart';
import '../../features/counselor/sessions/presentation/create_session_screen.dart';

/// Counselor-specific routes
List<RouteBase> counselorRoutes = [
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
];