import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/shared/profile/profile_screen.dart';
import '../../features/shared/profile/edit_profile_screen.dart';
import '../../features/shared/profile/change_password_screen.dart';
import '../../features/shared/settings/settings_screen.dart';
import '../../features/shared/settings/notification_preferences_screen.dart';
import '../../features/shared/cookies/presentation/cookie_settings_screen.dart';
import '../../features/shared/notifications/notifications_screen.dart';
import '../../features/shared/messages/presentation/messages_list_screen.dart';
import '../../features/shared/messages/presentation/conversation_detail_screen.dart';
import '../../features/shared/documents/documents_screen.dart';
import '../../features/shared/documents/document_viewer_screen.dart';
import '../../features/shared/payments/payment_method_screen.dart';
import '../../features/shared/payments/payment_history_screen.dart';
import '../../features/shared/resources/resource_viewer_screen.dart';
import '../../features/shared/schedule/add_event_screen.dart';
import '../../features/shared/schedule/event_details_screen.dart';
import '../../features/shared/exams/exam_results_screen.dart';
import '../../features/shared/exams/take_exam_screen.dart';
import '../../features/shared/quizzes/quiz_taking_screen.dart';
import '../../features/shared/quizzes/quiz_results_screen.dart';
import '../../features/shared/tasks/add_task_screen.dart';
import '../../features/shared/tasks/task_details_screen.dart';
import '../../features/shared/collaboration/study_groups_screen.dart';

// Model imports for type safety
import '../../features/shared/widgets/schedule_widgets.dart'; // EventModel
import '../../features/shared/widgets/quiz_widgets.dart'; // QuizModel
import '../../features/shared/widgets/task_widgets.dart'; // TaskModel
import '../../features/shared/widgets/exam_widgets.dart'; // ExamModel
import '../../features/shared/widgets/resource_widgets.dart'; // ResourceModel
import '../../core/models/document_model.dart' as doc_model; // Document

/// Shared routes available to all authenticated users
List<RouteBase> sharedRoutes = [
  // Profile routes
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

  // Settings routes
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

  // Notifications
  GoRoute(
    path: '/notifications',
    name: 'notifications',
    builder: (context, state) => const NotificationsScreen(),
  ),

  // Messages
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
      return ConversationDetailScreen(
        conversationId: conversationId,
      );
    },
  ),

  // Documents
  GoRoute(
    path: '/documents',
    name: 'documents',
    builder: (context, state) => const DocumentsScreen(),
  ),
  GoRoute(
    path: '/documents/:id',
    name: 'document-viewer',
    builder: (context, state) {
      // Document should be passed via state.extra
      final document = state.extra as doc_model.Document?;
      if (document == null) {
        // If no document provided, redirect back to documents list
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/documents');
        });
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return DocumentViewerScreen(document: document);
    },
  ),

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

  // Resources routes
  GoRoute(
    path: '/resources/view',
    name: 'resource-viewer',
    builder: (context, state) {
      final resource = state.extra as ResourceModel;
      return ResourceViewerScreen(resource: resource);
    },
  ),

  // Schedule/Calendar routes
  GoRoute(
    path: '/schedule/add-event',
    name: 'add-event',
    builder: (context, state) {
      final date = state.extra as DateTime?;
      return AddEventScreen(initialDate: date);
    },
  ),
  GoRoute(
    path: '/schedule/event-details',
    name: 'event-details',
    builder: (context, state) {
      final event = state.extra as EventModel;
      return EventDetailsScreen(event: event);
    },
  ),
  GoRoute(
    path: '/schedule/edit-event',
    name: 'edit-event',
    builder: (context, state) {
      final event = state.extra as EventModel;
      return EventDetailsScreen(event: event);
    },
  ),

  // Exam routes
  GoRoute(
    path: '/exams/results',
    name: 'exam-results',
    builder: (context, state) {
      final exam = state.extra as ExamModel;
      return ExamResultsScreen(exam: exam);
    },
  ),
  GoRoute(
    path: '/exams/details',
    name: 'exam-details',
    builder: (context, state) {
      final exam = state.extra as ExamModel;
      return TakeExamScreen(exam: exam);
    },
  ),
  GoRoute(
    path: '/exams/take',
    name: 'take-exam',
    builder: (context, state) {
      final exam = state.extra as ExamModel;
      return TakeExamScreen(exam: exam);
    },
  ),

  // Quiz routes
  GoRoute(
    path: '/quiz/take',
    name: 'take-quiz',
    builder: (context, state) {
      final quiz = state.extra as QuizModel;
      return QuizTakingScreen(quiz: quiz);
    },
  ),
  GoRoute(
    path: '/quiz/results',
    name: 'quiz-results',
    builder: (context, state) {
      final extraData = state.extra as Map<String, dynamic>;
      final quiz = extraData['quiz'] as QuizModel;
      final score = extraData['score'] as int;
      final totalPoints = extraData['totalPoints'] as int;
      final timeTaken = extraData['timeTaken'] as Duration;
      final passed = extraData['passed'] as bool;
      final answers = extraData['answers'] as Map<String, dynamic>;
      return QuizResultsScreen(
        quiz: quiz,
        score: score,
        totalPoints: totalPoints,
        timeTaken: timeTaken,
        passed: passed,
        answers: answers,
      );
    },
  ),

  // Task routes
  GoRoute(
    path: '/tasks/add',
    name: 'add-task',
    builder: (context, state) => const AddTaskScreen(),
  ),
  GoRoute(
    path: '/tasks/details',
    name: 'task-details',
    builder: (context, state) {
      final task = state.extra as TaskModel;
      return TaskDetailsScreen(task: task);
    },
  ),
  GoRoute(
    path: '/tasks/edit',
    name: 'edit-task',
    builder: (context, state) {
      final task = state.extra as TaskModel;
      return TaskDetailsScreen(task: task);
    },
  ),

  // Collaboration routes
  GoRoute(
    path: '/collaboration/group',
    name: 'study-group',
    builder: (context, state) {
      return const StudyGroupsScreen();
    },
  ),
];