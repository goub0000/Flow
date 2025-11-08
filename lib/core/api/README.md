# Backend API Integration - Flutter

Complete Flutter integration for the Find Your Path backend API with 80+ endpoints.

## What's Included

### API Infrastructure
- **API Client** (`api_client.dart`) - Dio-based HTTP client with automatic token management
- **API Configuration** (`api_config.dart`) - Environment configuration and endpoints
- **API Response Models** (`api_response.dart`) - Generic response wrappers with pagination
- **Exception Handling** (`api_exception.dart`) - Comprehensive error handling

### Services

#### Authentication Service (`auth_service.dart`)
- Login/Register/Logout
- Password reset & change
- Email verification
- Role switching
- Profile management
- Session persistence

#### Courses Service (`courses_service.dart`)
- Browse courses with filters
- Course details
- Create/Update/Delete courses (Institution)
- Course statistics
- Enrolled students
- Recommendations
- Search

#### Enrollments Service (`enrollments_service.dart`)
- Enroll in courses
- View enrollments
- Update progress & grades (Institution)
- Drop enrollments
- Completion tracking
- Statistics

#### Applications Service (`applications_service.dart`)
- Create applications
- Submit applications
- Upload documents
- Track application status
- Application timeline
- Withdraw applications
- Statistics

#### Messaging Service (`messaging_service.dart`)
- Conversations list
- Send/receive messages
- File attachments
- Mark as read
- Typing indicators
- Search messages
- Block/unblock users
- Archive conversations

#### Notifications Service (`notifications_service.dart`)
- Get notifications
- Mark as read/unread
- Delete notifications
- Notification preferences
- Push notification registration
- Snooze notifications
- Batch operations

#### Realtime Service (`realtime_service.dart`)
- Live messaging with Supabase Realtime
- Typing indicators
- Real-time notifications
- Presence tracking (online/offline)
- Auto-reconnection

### Riverpod Providers (`service_providers.dart`)
All services are accessible via Riverpod providers:
- `authServiceProvider`
- `coursesServiceProvider`
- `enrollmentsServiceProvider`
- `applicationsServiceProvider`
- `messagingServiceProvider`
- `notificationsServiceProvider`
- `realtimeServiceProvider`
- `currentUserProvider`
- `isAuthenticatedProvider`
- `unreadMessagesCountProvider`
- `unreadNotificationsCountProvider`

## Quick Start

### 1. Install Dependencies

Already added to `pubspec.yaml`:
```yaml
dependencies:
  supabase_flutter: ^2.5.0
  dio: ^5.4.0
  flutter_riverpod: ^2.4.9
  shared_preferences: ^2.2.2
```

Run:
```bash
flutter pub get
```

### 2. Initialize in main.dart

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
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}
```

### 3. Use Services

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/service_providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final coursesService = ref.watch(coursesServiceProvider);

    return ElevatedButton(
      onPressed: () async {
        // Login
        final response = await authService.login(
          email: 'student@example.com',
          password: 'password123',
        );

        if (response.success) {
          ref.read(currentUserProvider.notifier).state = response.data;
          // Navigate to dashboard
        }
      },
      child: Text('Login'),
    );
  }
}
```

## Features

### ✅ Automatic Token Management
- Tokens are automatically stored and attached to requests
- Automatic token refresh on expiry
- Session persistence across app restarts

### ✅ Comprehensive Error Handling
- Network errors
- Validation errors (422)
- Authentication errors (401)
- Authorization errors (403)
- Rate limiting (429)
- Server errors (500+)
- Timeout handling

### ✅ Real-time Capabilities
- Live messaging with Supabase Realtime
- Typing indicators
- Real-time notifications
- Presence tracking

### ✅ File Uploads
- Progress tracking
- Multiple file types
- Document management

### ✅ Pagination Support
- Automatic pagination handling
- Page navigation
- Total counts

### ✅ Type Safety
- Full Dart type safety
- Model validation
- Enum support

## Configuration

### Development vs Production

In `lib/core/api/api_config.dart`:

```dart
static const bool isProduction = false; // Development
static const bool isProduction = true;  // Production
```

### API Endpoints

All endpoints are configured in `ApiConfig`:
- Development: `http://localhost:8000`
- Production: `https://findyourpath-production.up.railway.app`

### Supabase Configuration

Update in `ApiConfig` if needed:
```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

## Documentation

See `INTEGRATION_GUIDE.md` for:
- Detailed usage examples
- Authentication flows
- Real-time messaging setup
- Error handling patterns
- Best practices
- Testing strategies

## Architecture

```
lib/core/
├── api/
│   ├── api_client.dart           # Main HTTP client
│   ├── api_config.dart           # Configuration
│   ├── api_response.dart         # Response models
│   ├── api_exception.dart        # Error handling
│   ├── INTEGRATION_GUIDE.md      # Detailed guide
│   └── README.md                 # This file
├── services/
│   ├── auth_service.dart         # Authentication
│   ├── courses_service.dart      # Courses API
│   ├── enrollments_service.dart  # Enrollments API
│   ├── applications_service.dart # Applications API
│   ├── messaging_service.dart    # Messaging API
│   ├── notifications_service.dart# Notifications API
│   └── realtime_service.dart     # Real-time events
└── providers/
    └── service_providers.dart    # Riverpod providers
```

## API Coverage

### Backend Endpoints: 80+
- ✅ Authentication (10 endpoints)
- ✅ Courses (8 endpoints)
- ✅ Enrollments (7 endpoints)
- ✅ Applications (10 endpoints)
- ✅ Messaging (12 endpoints)
- ✅ Notifications (12 endpoints)
- ✅ Students (6 endpoints)
- ✅ Universities (5 endpoints)
- ✅ Programs (5 endpoints)
- ✅ Recommendations (4 endpoints)
- And more...

## Next Steps

1. **Implement UI Screens** - Create screens that use these services
2. **Add State Management** - Use Riverpod StateNotifier for complex state
3. **Error UI** - Create user-friendly error screens
4. **Loading States** - Add skeleton loaders
5. **Offline Support** - Cache data locally
6. **Push Notifications** - Integrate FCM/APNS
7. **Testing** - Write unit & integration tests

## Support

- Backend API Docs: `http://localhost:8000/docs` (dev) or production URL
- OpenAPI Schema: `http://localhost:8000/openapi.json`

## License

Part of the Flow EdTech Platform
