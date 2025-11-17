# Real-Time Subscriptions System Documentation

## Overview
This document describes the comprehensive real-time subscription system implemented for the Flow App using Supabase Realtime and Flutter Riverpod.

## Architecture

### Core Components

1. **EnhancedRealtimeService** (`lib/core/services/enhanced_realtime_service.dart`)
   - Central service managing all Supabase real-time subscriptions
   - Handles connection lifecycle, auto-reconnection, and error recovery
   - Provides connection status monitoring
   - Memory-safe with proper cleanup mechanisms

2. **Real-Time Providers**
   - **StudentApplicationsRealtimeProvider**: Manages student application updates
   - **InstitutionApplicantsRealtimeProvider**: Manages institution applicant updates
   - **NotificationsRealtimeProvider**: Manages user notifications in real-time

3. **Connection Status Indicators**
   - Visual feedback components showing real-time connection state
   - Multiple styles: Chip, AppBar, Dot, Animated indicators

## Features Implemented

### 1. Auto-Update Dashboards
- Student applications update automatically when status changes
- Institution sees new applications immediately
- Statistics refresh in real-time
- Activity feeds update without manual refresh

### 2. Real-Time Notifications
- Instant notification delivery
- Unread count badges update automatically
- Toast/snackbar alerts for important updates
- Notification types: acceptance, rejection, status updates, deadlines

### 3. Connection Management
- Automatic reconnection on network recovery
- Graceful offline mode handling
- Connection status indicators throughout the app
- Manual refresh as fallback option

### 4. Optimistic Updates
- Immediate UI updates before server confirmation
- Automatic rollback on errors
- Smooth user experience without waiting

### 5. Memory Management
- Proper subscription cleanup on widget disposal
- No memory leaks with broadcast streams
- Efficient channel management

## Usage Examples

### Basic Integration in a Screen

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_applications_realtime_provider.dart';
import '../../shared/widgets/connection_status_indicator.dart';

class MyDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch real-time applications
    final applications = ref.watch(realtimeApplicationsListProvider);
    final isConnected = ref.watch(applicationsRealtimeConnectedProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          // Show connection status
          ConnectionStatusIndicator(showInAppBar: true),
        ],
      ),
      body: RefreshIndicator(
        // Manual refresh fallback
        onRefresh: () async {
          await ref.read(studentApplicationsRealtimeProvider.notifier).refresh();
        },
        child: ListView.builder(
          itemCount: applications.length,
          itemBuilder: (context, index) {
            return ApplicationCard(application: applications[index]);
          },
        ),
      ),
    );
  }
}
```

### Optimistic Update Example

```dart
// Update with optimistic UI changes
Future<void> updateStatus(String id, String newStatus) async {
  final success = await ref.read(studentApplicationsRealtimeProvider.notifier)
      .updateApplicationStatus(id, newStatus);

  if (!success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update status')),
    );
  }
  // UI already updated optimistically, real-time will confirm
}
```

### Notification Handling

```dart
// Watch for new notifications
final hasNew = ref.watch(hasNewNotificationProvider);
final unreadCount = ref.watch(realtimeUnreadNotificationsCountProvider);

// Mark as read
await ref.read(notificationsRealtimeProvider.notifier)
    .markAsRead(notificationId);

// Mark all as read
await ref.read(notificationsRealtimeProvider.notifier)
    .markAllAsRead();
```

## Connection Status Indicators

### 1. Basic Chip Indicator
```dart
ConnectionStatusIndicator(
  showText: true,
  showInAppBar: false,
)
```

### 2. AppBar Indicator
```dart
AppBar(
  actions: [
    ConnectionStatusIndicator(showInAppBar: true),
  ],
)
```

### 3. Minimal Dot Indicator
```dart
ConnectionDotIndicator(
  size: 8,
  showAnimation: true,
)
```

### 4. Animated Indicator
```dart
AnimatedConnectionStatusIndicator(
  showText: true,
  size: 24,
)
```

## Database Requirements

### Required Tables and RLS Policies

1. **applications** table
   - RLS: Users can only see their own applications (student_id = auth.uid())
   - Institutions can see applications to their institution
   - Real-time enabled

2. **notifications** table
   - RLS: Users can only see their own notifications (user_id = auth.uid())
   - Real-time enabled

3. **Enable Realtime**
   ```sql
   -- Enable realtime for tables
   ALTER PUBLICATION supabase_realtime ADD TABLE applications;
   ALTER PUBLICATION supabase_realtime ADD TABLE notifications;
   ```

## Performance Considerations

1. **Subscription Limits**
   - Subscribe only to relevant data using filters
   - Unsubscribe when screens are not visible
   - Use unique channel names per user/context

2. **Data Volume**
   - Limit notification fetch to recent 50
   - Paginate large datasets
   - Use debouncing for rapid updates

3. **Network Efficiency**
   - Batch operations when possible
   - Use optimistic updates to reduce perceived latency
   - Implement exponential backoff for reconnection

## Testing Scenarios

### 1. Real-Time Updates
- Open app in multiple tabs/devices
- Create application in one, verify it appears in others
- Update status, verify immediate reflection

### 2. Connection Handling
- Disable network, verify offline mode
- Re-enable network, verify auto-reconnection
- Test with slow/unstable connections

### 3. Memory Management
- Navigate between screens repeatedly
- Verify subscriptions are cleaned up
- Check for memory leaks in DevTools

### 4. Edge Cases
- Rapid status changes
- Simultaneous updates from multiple sources
- Large notification volumes
- Session timeout handling

## Troubleshooting

### Common Issues and Solutions

1. **Subscriptions not working**
   - Check Supabase Realtime is enabled for tables
   - Verify RLS policies allow read access
   - Check network connectivity

2. **Memory leaks**
   - Ensure proper disposal in StatefulWidgets
   - Use autoDispose providers
   - Clean up timers and subscriptions

3. **Duplicate updates**
   - Check for multiple subscription instances
   - Verify unique channel names
   - Ensure single initialization

4. **Performance issues**
   - Reduce subscription scope with filters
   - Implement pagination
   - Use debouncing for UI updates

## Security Considerations

1. **Row Level Security**
   - All real-time data filtered by RLS policies
   - No client-side filtering of sensitive data
   - Validate all incoming real-time data

2. **Authentication**
   - Subscriptions tied to authenticated sessions
   - Auto-cleanup on logout
   - Token refresh handling

3. **Data Validation**
   - Validate payload structure
   - Handle malformed data gracefully
   - Log suspicious activities

## Future Enhancements

1. **Presence System**
   - Show online users
   - "User is typing" indicators
   - Active session tracking

2. **Advanced Notifications**
   - Push notifications
   - Email notifications
   - SMS alerts

3. **Analytics**
   - Real-time dashboard metrics
   - User activity tracking
   - Performance monitoring

4. **Collaboration Features**
   - Live document editing
   - Shared workspaces
   - Real-time comments

## Dependencies

```yaml
dependencies:
  supabase_flutter: ^2.0.0
  flutter_riverpod: ^2.4.0
  connectivity_plus: ^5.0.0
```

## Deployment Checklist

- [ ] Supabase Realtime enabled for required tables
- [ ] RLS policies configured correctly
- [ ] Environment variables set (SUPABASE_URL, SUPABASE_ANON_KEY)
- [ ] Connection retry logic tested
- [ ] Error handling implemented
- [ ] Monitoring/logging in place
- [ ] Performance tested with expected load
- [ ] Security audit completed

## Support and Maintenance

For issues or questions regarding the real-time system:
1. Check this documentation first
2. Review error logs in Supabase dashboard
3. Test with the example implementation
4. Contact the development team

---

Last Updated: November 2024
Version: 1.0.0