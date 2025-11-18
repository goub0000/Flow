# Notification System

**Phase 5.2 Implementation** - Comprehensive in-app notification system with real-time updates, preferences, and database-backed storage.

## Overview

The Flow app now has a complete notification system with the following features:

- **Real-time Notifications**: Live updates via Supabase real-time subscriptions
- **Notification Center**: Full-featured UI for viewing and managing notifications
- **Notification Bell**: Badge icon showing unread count in app bars
- **User Preferences**: Granular control over notification types
- **Database Storage**: Persistent storage in Supabase PostgreSQL
- **Mark as Read/Unread**: Individual and bulk operations
- **Archive/Delete**: Manage notification history
- **Filtering**: Filter by read status and notification type
- **Infinite Scroll**: Load more notifications on scroll
- **Pull to Refresh**: Refresh notifications list

## Architecture

```
┌─────────────────────────────────────────┐
│        Flutter Application              │
├─────────────────────────────────────────┤
│                                         │
│  NotificationBell (App Bar Widget)      │
│    ↓                                    │
│  NotificationProvider (Riverpod)        │
│    ↓                                    │
│  NotificationService (API)              │
│    ↓                                    │
│  Supabase PostgreSQL Database           │
│    - notifications table                │
│    - notification_preferences table     │
│                                         │
└─────────────────────────────────────────┘
```

## Database Schema

The notification system uses two main tables:

### 1. `notifications` Table

Stores all notifications for users.

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    action_url TEXT,
    is_read BOOLEAN DEFAULT false,
    is_archived BOOLEAN DEFAULT false,
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    archived_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);
```

### 2. `notification_preferences` Table

User preferences for each notification type.

```sql
CREATE TABLE notification_preferences (
    id UUID PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    notification_type notification_type NOT NULL,
    in_app_enabled BOOLEAN DEFAULT true,
    email_enabled BOOLEAN DEFAULT true,
    push_enabled BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, notification_type)
);
```

## Notification Types

The system supports 12 notification types:

1. **application_status**: College application status changes
2. **grade_posted**: New grades posted
3. **message_received**: New messages
4. **meeting_scheduled**: Meeting scheduled
5. **meeting_reminder**: Upcoming meeting reminders
6. **achievement_earned**: New achievements/badges
7. **deadline_reminder**: Deadline approaching
8. **recommendation_ready**: New recommendations available
9. **system_announcement**: System-wide announcements
10. **comment_received**: Comments on posts
11. **mention**: User mentioned in content
12. **event_reminder**: Event reminders

## Usage

### 1. Adding Notification Bell to App Bar

```dart
import 'package:flow/features/shared/widgets/notification_bell.dart';

AppBar(
  title: Text('Dashboard'),
  actions: [
    NotificationBell(),  // Shows bell icon with unread count badge
  ],
)
```

### 2. Using Notification Bell Menu (Dropdown)

```dart
import 'package:flow/features/shared/widgets/notification_bell.dart';

AppBar(
  title: Text('Dashboard'),
  actions: [
    NotificationBellMenu(),  // Shows dropdown with recent notifications
  ],
)
```

### 3. Navigating to Notification Center

```dart
import 'package:go_router/go_router.dart';

// Navigate to full notification center
context.push('/notifications');
```

### 4. Checking Unread Count

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/core/providers/notification_provider.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);

    return Text('You have $unreadCount unread notifications');
  }
}
```

### 5. Creating a Notification (Server-Side/Admin Only)

```dart
import 'package:flow/core/services/notification_service.dart';
import 'package:flow/core/models/notification_models.dart';

final service = NotificationService();

await service.createNotification(
  CreateNotificationRequest(
    userId: 'user-uuid',
    type: NotificationType.gradePosted,
    title: 'New Grade Posted',
    message: 'Your grade for Assignment 1 is now available',
    metadata: {
      'course_id': 'cs101',
      'assignment_id': 'hw1',
      'grade': 95,
    },
    actionUrl: '/student/courses/cs101',
    priority: NotificationPriority.normal,
  ),
);
```

### 6. Managing Notification Preferences

Users can manage their preferences via:

```dart
context.push('/settings/notifications');
```

Or programmatically:

```dart
import 'package:flow/core/providers/notification_provider.dart';

// Update preference
await ref.read(updateNotificationPreferenceProvider)(
  UpdateNotificationPreferencesRequest(
    notificationType: NotificationType.gradePosted,
    inAppEnabled: false,  // Disable in-app notifications for grades
  ),
);
```

## Features

### Real-Time Updates

Notifications automatically appear via Supabase real-time subscriptions. When a new notification is inserted in the database, it instantly appears in the notification bell and center.

### Notification Bell Badge

The bell icon shows:
- **Filled icon** when there are unread notifications
- **Outlined icon** when all notifications are read
- **Red badge** with unread count

### Notification Center

Full-featured screen for managing notifications:

- **Date Grouping**: Notifications grouped by Today, Yesterday, This Week, Older
- **Swipe Actions**:
  - Swipe right: Mark as read/unread
  - Swipe left: Archive
- **Long Press Menu**: Mark as read, archive, delete
- **Filter**: Filter by read/unread status
- **Infinite Scroll**: Automatically loads more on scroll
- **Pull to Refresh**: Refresh notification list

### Notification Preferences

Users can control which notifications they receive:

- **In-App Notifications**: Show in notification center
- **Email Notifications**: (Future feature)
- **Push Notifications**: (Future feature)

Preferences are grouped by category:
- College Applications
- Academic
- Communication
- Meetings & Events
- Achievements
- System

## Database Setup

### 1. Run SQL Migration

Execute the SQL schema file in your Supabase SQL editor:

```sql
-- File: database_migrations/notification_schema.sql
```

This creates:
- `notification_type` enum
- `notifications` table with indexes and RLS policies
- `notification_preferences` table with indexes and RLS policies
- Helper functions for marking as read, getting unread count, etc.

### 2. Create Default Preferences for Existing Users

For existing users, run:

```sql
-- Create default preferences for all users
DO $$
DECLARE
  user_record RECORD;
BEGIN
  FOR user_record IN SELECT id FROM auth.users
  LOOP
    PERFORM create_default_notification_preferences(user_record.id);
  END LOOP;
END $$;
```

## API Methods

### NotificationService

```dart
// Get notifications with filters
Future<NotificationsResponse> getNotifications({NotificationFilter? filter});

// Get unread count
Future<int> getUnreadCount();

// Mark as read
Future<void> markAsRead(String notificationId);
Future<int> markAllAsRead();

// Mark as unread
Future<void> markAsUnread(String notificationId);

// Archive
Future<void> archiveNotification(String notificationId);
Future<void> unarchiveNotification(String notificationId);

// Delete (soft delete)
Future<void> deleteNotification(String notificationId);

// Create (admin/system only)
Future<AppNotification> createNotification(CreateNotificationRequest request);

// Preferences
Future<List<NotificationPreference>> getPreferences();
Future<void> updatePreference(UpdateNotificationPreferencesRequest request);
Future<void> createDefaultPreferences();

// Real-time subscription
RealtimeChannel subscribeToNotifications(void Function(AppNotification) onNotification);
Future<void> unsubscribe(RealtimeChannel channel);
```

## Models

### AppNotification

```dart
class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String message;
  final Map<String, dynamic> metadata;
  final String? actionUrl;
  final bool isRead;
  final bool isArchived;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? readAt;
  final DateTime? archivedAt;
  final DateTime? deletedAt;
}
```

### NotificationFilter

```dart
class NotificationFilter {
  final int page;              // Page number (default: 1)
  final int limit;             // Items per page (default: 20)
  final bool? isRead;          // Filter by read status
  final bool? isArchived;      // Filter by archived status
  final List<NotificationType>? types;  // Filter by types
  final DateTime? startDate;   // Filter by date range
  final DateTime? endDate;
  final NotificationPriority? priority;  // Filter by priority
}
```

## Providers

### Main Providers

- `notificationsProvider`: Main provider for notification state
- `unreadNotificationCountProvider`: Unread count
- `hasUnreadNotificationsProvider`: Boolean for unread check
- `unreadNotificationsProvider`: List of unread notifications only
- `notificationPreferencesProvider`: User preferences
- `notificationsByDateProvider`: Notifications grouped by date
- `notificationsByTypeProvider`: Notifications filtered by type

## Testing

### 1. Test Notification Creation

Run in Supabase SQL editor:

```sql
-- Create a test notification for current user
INSERT INTO notifications (user_id, type, title, message, metadata, action_url)
SELECT
    auth.uid(),
    'grade_posted',
    'Test Notification',
    'This is a test notification to verify the system works',
    '{"test": true}'::jsonb,
    '/dashboard'
WHERE auth.uid() IS NOT NULL;
```

### 2. Test Real-Time Updates

1. Open the app in two browser windows
2. Create a notification for the user (via SQL or admin panel)
3. Notification should appear instantly in both windows

### 3. Test Preferences

1. Navigate to `/settings/notifications`
2. Toggle preferences on/off
3. Verify changes are saved
4. Refresh page to verify persistence

## Troubleshooting

### Notifications Not Appearing

**Problem**: Notifications don't show up in the notification center

**Solutions**:
1. Check database connection in Supabase dashboard
2. Verify RLS policies allow user to view their notifications
3. Check browser console for errors
4. Ensure notification was created with correct `user_id`

### Real-Time Updates Not Working

**Problem**: New notifications don't appear automatically

**Solutions**:
1. Check Supabase real-time is enabled for `notifications` table
2. Verify websocket connection in browser DevTools
3. Check notification provider is subscribed (see provider logs)
4. Try refreshing the page

### Preferences Not Saving

**Problem**: Notification preferences reset after page refresh

**Solutions**:
1. Check database permissions for `notification_preferences` table
2. Verify RLS policies allow user to update their preferences
3. Check browser console for API errors
4. Ensure default preferences were created for user

### Badge Count Incorrect

**Problem**: Notification bell shows wrong unread count

**Solutions**:
1. Refresh the notification provider: `ref.invalidate(notificationsProvider)`
2. Check database query is filtering correctly
3. Verify `is_read` field is being updated correctly
4. Check for duplicate subscriptions

## Performance Considerations

- **Pagination**: Notifications load 20 at a time by default
- **Infinite Scroll**: Only loads more when scrolled to 90%
- **Real-time**: Uses Supabase real-time with minimal bandwidth
- **Caching**: Provider caches current state in memory
- **Database Indexes**: Optimized indexes on `user_id`, `created_at`, `is_read`

## Future Enhancements

- [ ] Push notifications (web push API)
- [ ] Email notifications
- [ ] Notification sounds
- [ ] Custom notification preferences per type
- [ ] Quiet hours/Do Not Disturb mode
- [ ] Notification grouping (e.g., "5 new messages")
- [ ] Rich media notifications (images, actions)
- [ ] Notification templates
- [ ] Scheduled notifications
- [ ] Notification analytics

## Security

- **Row Level Security (RLS)**: Enabled on all tables
- **User Isolation**: Users can only see their own notifications
- **Service Role**: Admin/system uses service role for creating notifications
- **No Client-Side Creation**: Regular users cannot create notifications
- **Audit Trail**: All changes tracked with timestamps
- **Soft Delete**: Notifications are soft-deleted, not permanently removed

## Files Created

### Database
- `database_migrations/notification_schema.sql`: Complete database schema

### Models
- `lib/core/models/notification_models.dart`: All notification models with Freezed
- `lib/core/models/notification_models.freezed.dart`: Generated Freezed code
- `lib/core/models/notification_models.g.dart`: Generated JSON serialization

### Services
- `lib/core/services/notification_service.dart`: API service for notifications

### Providers
- `lib/core/providers/notification_provider.dart`: Riverpod state management

### UI Components
- `lib/features/shared/notifications/notifications_screen.dart`: Notification center screen
- `lib/features/shared/widgets/notification_bell.dart`: Bell icon widgets
- `lib/features/shared/widgets/notification_center.dart`: Center component (alternate implementation)
- `lib/features/shared/settings/notification_preferences_screen.dart`: Preferences screen
- `lib/features/settings/presentation/notification_preferences_screen.dart`: Preferences screen (alternate path)

## Routes

The following routes are available:

- `/notifications`: Notification center
- `/settings/notifications`: Notification preferences

---

**Implemented**: 2025-11-18
**Phase**: 5.2 - Notification System
**Status**: Complete
**Dependencies**: Supabase, Riverpod, Freezed, Go Router
