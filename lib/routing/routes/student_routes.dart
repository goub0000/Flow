import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/application_model.dart';
import '../../core/models/course_model.dart';
import '../../features/student/dashboard/presentation/student_dashboard_screen.dart';
import '../../features/student/applications/presentation/applications_list_screen.dart';
import '../../features/student/applications/presentation/application_detail_screen.dart';
import '../../features/student/applications/presentation/create_application_screen.dart';
import '../../features/student/progress/presentation/progress_screen.dart';
import '../../features/student/courses/presentation/courses_list_screen.dart';
import '../../features/student/courses/presentation/course_detail_screen.dart';
import '../../features/student/courses/presentation/my_courses_screen.dart';
import '../../features/student/courses/presentation/course_learning_screen.dart';
import '../../features/student/recommendations/presentation/recommendation_requests_screen.dart';
import '../../features/student/parent_linking/presentation/parent_linking_screen.dart';

/// Student-specific routes
List<RouteBase> studentRoutes = [
  GoRoute(
    path: '/student/dashboard',
    name: 'student-dashboard',
    builder: (context, state) => const StudentDashboardScreen(),
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
  GoRoute(
    path: '/student/courses',
    name: 'student-courses',
    builder: (context, state) => const CoursesListScreen(),
  ),
  GoRoute(
    path: '/student/courses/:id',
    name: 'student-course-detail',
    builder: (context, state) {
      // final courseId = state.pathParameters['id']!;
      final course = state.extra as Course?;
      if (course == null) {
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
    path: '/student/my-courses',
    name: 'student-my-courses',
    builder: (context, state) => const MyCoursesScreen(),
  ),
  GoRoute(
    path: '/student/courses/:id/learn',
    name: 'student-course-learn',
    builder: (context, state) {
      final course = state.extra as Course?;
      if (course == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/student/my-courses');
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return CourseLearningScreen(course: course);
    },
  ),
  GoRoute(
    path: '/student/recommendations',
    name: 'student-recommendations',
    builder: (context, state) => const RecommendationRequestsScreen(),
  ),
  GoRoute(
    path: '/student/parent-linking',
    name: 'student-parent-linking',
    builder: (context, state) => const ParentLinkingScreen(),
  ),
];