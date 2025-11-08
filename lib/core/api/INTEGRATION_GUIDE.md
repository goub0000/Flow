# Flutter API Integration Guide

This guide explains how to use the backend API services in your Flutter app.

## Setup

### 1. Initialize in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/api/api_config.dart';
import 'core/providers/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: ApiConfig.supabaseUrl,
    anonKey: ApiConfig.supabaseAnonKey,
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the sharedPreferencesProvider with actual instance
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. Switch Between Development and Production

In `lib/core/api/api_config.dart`, change:

```dart
static const bool isProduction = false; // Development
static const bool isProduction = true;  // Production
```

## Authentication

### Login

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/service_providers.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return ElevatedButton(
      onPressed: () async {
        final response = await authService.login(
          email: 'student@example.com',
          password: 'password123',
        );

        if (response.success) {
          // Update current user in provider
          ref.read(currentUserProvider.notifier).state = response.data;

          // Navigate to dashboard
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message ?? 'Login failed')),
          );
        }
      },
      child: Text('Login'),
    );
  }
}
```

### Register

```dart
final response = await authService.register(
  email: 'newstudent@example.com',
  password: 'securepassword',
  confirmPassword: 'securepassword',
  role: UserRole.student,
  fullName: 'John Doe',
  phoneNumber: '+1234567890',
);
```

### Logout

```dart
await authService.logout();
ref.read(currentUserProvider.notifier).state = null;
```

### Check Authentication Status

```dart
final isAuthenticated = ref.watch(isAuthenticatedProvider);

if (isAuthenticated) {
  // Show authenticated content
} else {
  // Show login screen
}
```

## Courses

### Get Courses

```dart
final coursesService = ref.watch(coursesServiceProvider);

final response = await coursesService.getCourses(
  page: 1,
  pageSize: 20,
  search: 'Computer Science',
  level: 'undergraduate',
  isOnline: true,
);

if (response.success) {
  final courses = response.data!.items;
  final totalPages = response.data!.totalPages;
}
```

### Get Course by ID

```dart
final response = await coursesService.getCourseById('course-id-123');

if (response.success) {
  final course = response.data!;
  print('Course: ${course.title}');
}
```

### Create Course (Institution only)

```dart
final response = await coursesService.createCourse(
  title: 'Introduction to Flutter',
  description: 'Learn Flutter development from scratch',
  level: 'undergraduate',
  category: 'Computer Science',
  duration: 12, // months
  fee: 500.0,
  startDate: DateTime(2025, 9, 1),
  maxStudents: 50,
  isOnline: true,
);
```

## Enrollments

### Enroll in Course

```dart
final enrollmentsService = ref.watch(enrollmentsServiceProvider);

final response = await enrollmentsService.enrollInCourse(
  courseId: 'course-id-123',
);

if (response.success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Successfully enrolled!')),
  );
}
```

### Get My Enrollments

```dart
final response = await enrollmentsService.getMyEnrollments(
  status: EnrollmentStatus.active,
  page: 1,
  pageSize: 20,
);

if (response.success) {
  final enrollments = response.data!.items;
  // Display enrollments
}
```

### Drop Enrollment

```dart
final response = await enrollmentsService.dropEnrollment(
  enrollmentId: 'enrollment-id-123',
  reason: 'Personal reasons',
);
```

## Applications

### Create Application

```dart
final applicationsService = ref.watch(applicationsServiceProvider);

final response = await applicationsService.createApplication(
  programId: 'program-id-123',
  applicationData: {
    'personal_statement': 'I am passionate about...',
    'academic_records': {...},
  },
);
```

### Submit Application

```dart
final response = await applicationsService.submitApplication(
  'application-id-123',
);

if (response.success) {
  print('Application submitted successfully!');
  print('Status: ${response.data!.status.displayName}');
}
```

### Upload Application Document

```dart
import 'dart:io';

final file = File('/path/to/document.pdf');

final response = await applicationsService.uploadDocument(
  applicationId: 'application-id-123',
  file: file,
  documentType: 'transcript',
  description: 'Official Transcript',
  onProgress: (sent, total) {
    print('Upload progress: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

### Get My Applications

```dart
final response = await applicationsService.getMyApplications(
  status: ApplicationStatus.submitted,
);

if (response.success) {
  final applications = response.data!.items;
}
```

## Messaging

### Get Conversations

```dart
final messagingService = ref.watch(messagingServiceProvider);

final response = await messagingService.getConversations(
  page: 1,
  pageSize: 20,
);

if (response.success) {
  final conversations = response.data!.items;
  // Display conversations list
}
```

### Get Messages in Conversation

```dart
final response = await messagingService.getMessages(
  conversationId: 'conv-id-123',
  page: 1,
  pageSize: 50,
);

if (response.success) {
  final messages = response.data!.items;
}
```

### Send Message

```dart
final response = await messagingService.sendMessage(
  conversationId: 'conv-id-123',
  content: 'Hello! How are you?',
);
```

### Send Message with File

```dart
final file = File('/path/to/image.jpg');

final response = await messagingService.sendMessageWithFile(
  conversationId: 'conv-id-123',
  content: 'Check out this image',
  file: file,
  onProgress: (sent, total) {
    print('Upload: ${(sent / total * 100).toStringAsFixed(0)}%');
  },
);
```

### Real-time Messaging

```dart
class ChatScreen extends ConsumerStatefulWidget {
  final String conversationId;

  const ChatScreen({required this.conversationId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToMessages();
  }

  void _subscribeToMessages() async {
    final realtimeService = ref.read(realtimeServiceProvider);

    // Subscribe to conversation
    await realtimeService.subscribeToConversation(widget.conversationId);

    // Listen to new messages
    _messageSubscription = realtimeService.messagesStream.listen((message) {
      setState(() {
        // Add new message to your messages list
      });

      // Play notification sound, etc.
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    final realtimeService = ref.read(realtimeServiceProvider);
    realtimeService.unsubscribeFromMessages();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build your chat UI
    return Container();
  }
}
```

### Typing Indicators

```dart
// Subscribe to typing indicators
final realtimeService = ref.watch(realtimeServiceProvider);
await realtimeService.subscribeToTyping(conversationId);

// Listen to typing stream
realtimeService.typingStream.listen((data) {
  final isTyping = data['is_typing'] as bool;
  final userName = data['user_name'] as String;

  if (isTyping) {
    print('$userName is typing...');
  }
});

// Send typing indicator
await realtimeService.sendTypingIndicator(
  conversationId: conversationId,
  userId: currentUser.id,
  userName: currentUser.displayName ?? '',
  isTyping: true,
);
```

## Notifications

### Get Notifications

```dart
final notificationsService = ref.watch(notificationsServiceProvider);

final response = await notificationsService.getNotifications(
  page: 1,
  pageSize: 20,
  unreadOnly: true,
);

if (response.success) {
  final notifications = response.data!.items;
}
```

### Mark as Read

```dart
await notificationsService.markAsRead('notification-id-123');
```

### Mark All as Read

```dart
await notificationsService.markAllAsRead();
```

### Get Unread Count

```dart
// Using provider (auto-updates)
final unreadCount = ref.watch(unreadNotificationsCountProvider);

unreadCount.when(
  data: (count) => Text('$count unread'),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => Text('Error'),
);
```

### Real-time Notifications

```dart
class NotificationsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToNotifications();
  }

  void _subscribeToNotifications() async {
    final realtimeService = ref.read(realtimeServiceProvider);
    final currentUser = ref.read(currentUserProvider);

    if (currentUser != null) {
      await realtimeService.subscribeToNotifications(currentUser.id);

      _notificationSubscription = realtimeService.notificationsStream.listen((notification) {
        // Show notification banner
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notification.title)),
        );

        // Update notifications list
        setState(() {
          // Add new notification
        });
      });
    }
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    final realtimeService = ref.read(realtimeServiceProvider);
    realtimeService.unsubscribeFromNotifications();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Notification Preferences

```dart
// Get preferences
final response = await notificationsService.getPreferences();

if (response.success) {
  final prefs = response.data!;
  print('Email notifications: ${prefs.emailNotifications}');
}

// Update preferences
await notificationsService.updatePreferences(
  emailNotifications: true,
  pushNotifications: true,
  typePreferences: {
    NotificationType.application: true,
    NotificationType.course: true,
    NotificationType.message: false,
  },
);
```

## Error Handling

All API calls return `ApiResponse<T>` which has:

```dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? error;
}
```

### Handle Errors

```dart
final response = await coursesService.getCourseById('course-id-123');

if (response.success) {
  final course = response.data!;
  // Use course data
} else {
  // Handle error
  final errorMessage = response.message ?? 'Unknown error';
  final statusCode = response.statusCode;

  if (statusCode == 401) {
    // Unauthorized - redirect to login
  } else if (statusCode == 404) {
    // Not found
  } else {
    // Show generic error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
```

### Validation Errors

```dart
final response = await authService.register(...);

if (!response.success && response.statusCode == 422) {
  // Validation error
  final errors = response.error;

  if (errors != null) {
    // Show field-specific errors
    final emailError = errors['email'];
    final passwordError = errors['password'];
  }
}
```

## Best Practices

1. **Use Riverpod Providers**: Always access services through Riverpod providers for proper dependency injection
2. **Handle Loading States**: Show loading indicators during API calls
3. **Error Handling**: Always check `response.success` before accessing data
4. **Pagination**: Use pagination for large lists (courses, messages, notifications)
5. **Realtime**: Subscribe/unsubscribe from realtime channels properly to avoid memory leaks
6. **Token Refresh**: The API client automatically handles token refresh
7. **Network Errors**: Handle network errors gracefully with retry mechanisms

## API Configuration

Modify `lib/core/api/api_config.dart` to:
- Change between development/production
- Update API endpoints
- Configure timeouts
- Update Supabase credentials

## Testing

For testing, you can mock the services:

```dart
final mockAuthService = MockAuthService();

runApp(
  ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(mockAuthService),
    ],
    child: MyApp(),
  ),
);
```
