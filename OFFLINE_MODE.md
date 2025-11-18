# Offline Mode & Caching

**Phase 5.5 Implementation** - Offline functionality with service worker caching and background sync.

## Overview

The Flow app now supports offline functionality with the following features:

- **Service Worker Caching**: Static assets and API responses are cached for offline access
- **Network Connectivity Monitoring**: Automatic detection of online/offline status
- **Offline Status Indicator**: Visual feedback when offline or syncing
- **Background Sync**: Automatic synchronization of queued actions when back online
- **Optimistic Updates**: Immediate UI updates with background synchronization

## Features

### 1. Service Worker (`web/flutter_service_worker.js`)

The service worker provides:
- **Cache-first strategy** for static assets (HTML, CSS, JS, images)
- **Network-first strategy** for API calls with cache fallback
- **Background sync** for queued offline actions
- **Push notification support** (for future use)

### 2. Connectivity Service (`lib/core/services/connectivity_service.dart`)

Monitors network connectivity:
- Detects online/offline status changes
- Periodic connectivity checks (every 30 seconds)
- Provides stream of connectivity status
- Manual connectivity check method

### 3. Offline Sync Service (`lib/core/services/offline_sync_service.dart`)

Manages offline actions:
- Queues actions when offline
- Stores queue in localStorage
- Automatic sync when back online
- Manual sync trigger
- Background sync support

### 4. Offline Status Indicator (`lib/features/shared/widgets/offline_status_indicator.dart`)

Visual feedback:
- **Orange banner** when offline showing pending actions
- **Blue banner** when syncing showing progress
- **Details dialog** for viewing/managing queued actions
- **Compact indicator** for app bars

### 5. Optimistic Update Mixin (`lib/core/mixins/optimistic_update_mixin.dart`)

Helper for implementing optimistic updates:
- Update UI immediately
- Perform actual action in background
- Revert on error
- Queue for sync when offline

## Usage

### Displaying Offline Status

The offline indicator is automatically shown at the top of the app when offline or syncing.

#### Compact Indicator (for AppBars)

```dart
AppBar(
  title: Text('My Page'),
  actions: [
    CompactOfflineIndicator(),
  ],
)
```

### Implementing Optimistic Updates

#### Using the Mixin (for StateNotifier)

```dart
class MyNotifier extends StateNotifier<MyState> with OptimisticUpdateMixin<MyState> {
  MyNotifier(this.ref) : super(MyState());

  final Ref ref;

  Future<void> updateItem(Item item) async {
    await performOptimisticUpdate(
      optimisticState: state.copyWith(item: item),
      onlineAction: () async {
        // Perform actual API call
        await api.updateItem(item);
      },
      offlineAction: () {
        // Queue for later sync
        queueOfflineAction(
          type: 'update_item',
          endpoint: '/api/items/${item.id}',
          method: 'PUT',
          data: item.toJson(),
        );
      },
      onError: (error) {
        // Handle error (state automatically reverted)
        showErrorSnackbar(error);
      },
    );
  }
}
```

#### Using the Helper (for functional providers)

```dart
final myProvider = FutureProvider.family<void, Item>((ref, item) async {
  final helper = OptimisticUpdateHelper(ref);

  await helper.performUpdate(
    onlineAction: () async {
      await api.updateItem(item);
    },
    offlineAction: () async {
      helper.queueAction(
        type: 'update_item',
        endpoint: '/api/items/${item.id}',
        method: 'PUT',
        data: item.toJson(),
      );
    },
  );
});
```

### Manually Checking Connectivity

```dart
final isOnline = ref.watch(isOnlineProvider);

if (isOnline) {
  // Perform online-only action
} else {
  // Show offline message or queue action
}
```

### Manually Triggering Sync

```dart
final syncService = ref.read(offlineSyncServiceProvider);
await syncService.syncAll();
```

### Viewing Offline Queue

```dart
final queue = ref.watch(offlineQueueProvider);

queue.when(
  data: (actions) {
    // Display list of pending actions
    print('Pending: ${actions.length}');
  },
  loading: () => CircularProgressIndicator(),
  error: (error, _) => Text('Error: $error'),
);
```

## Testing Offline Functionality

### Chrome DevTools

1. Open Chrome DevTools (F12)
2. Go to **Application** tab
3. Click **Service Workers** to see registered workers
4. Click **Cache Storage** to view cached resources
5. Go to **Network** tab
6. Click **Offline** checkbox to simulate offline mode

### Testing Workflow

1. Load the app while online
2. Check service worker is registered (DevTools → Application → Service Workers)
3. Go offline (DevTools → Network → Offline)
4. Verify offline banner appears
5. Perform actions (they should be queued)
6. Check offline queue (click "Details" on banner)
7. Go back online
8. Verify automatic sync starts
9. Check that queued actions were processed

## Architecture

```
┌─────────────────────────────────────────┐
│          Flutter Application            │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   Offline Status Indicator       │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   Connectivity Service           │  │
│  │   - Monitor online/offline       │  │
│  │   - Periodic checks              │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   Offline Sync Service           │  │
│  │   - Queue actions                │  │
│  │   - localStorage persistence     │  │
│  │   - Auto-sync when online        │  │
│  └──────────────────────────────────┘  │
│                                         │
│  ┌──────────────────────────────────┐  │
│  │   Optimistic Update Mixin        │  │
│  │   - Immediate UI updates         │  │
│  │   - Background sync              │  │
│  └──────────────────────────────────┘  │
│                                         │
└─────────────────────────────────────────┘
              ↕
┌─────────────────────────────────────────┐
│          Service Worker                 │
├─────────────────────────────────────────┤
│  - Cache static assets                  │
│  - Cache API responses                  │
│  - Network-first with fallback          │
│  - Background sync support              │
└─────────────────────────────────────────┘
              ↕
┌─────────────────────────────────────────┐
│             Backend API                 │
└─────────────────────────────────────────┘
```

## Caching Strategy

### Static Assets
- **Strategy**: Cache-first
- **Assets**: HTML, CSS, JS, images, icons, manifest
- **Lifetime**: Until app update (cache version changes)

### API Responses
- **Strategy**: Network-first with cache fallback
- **Endpoints**: All `/api/*` requests
- **Lifetime**: Until successful network response
- **Fallback**: Serve stale data when offline

### Offline Actions
- **Storage**: localStorage (persistent)
- **Queue**: FIFO (First In, First Out)
- **Retry**: Automatic when back online
- **Cleanup**: Manual or automatic after successful sync

## Limitations

1. **Service Worker Scope**: Only works with HTTPS or localhost
2. **Cache Size**: Browser-dependent (typically 50MB+)
3. **Sync Reliability**: Depends on network stability
4. **Conflict Resolution**: Last-write-wins (basic implementation)
5. **Complex Operations**: Some operations may not work offline

## Future Enhancements

- [ ] Intelligent cache invalidation based on data freshness
- [ ] Conflict resolution for simultaneous edits
- [ ] Partial sync for large datasets
- [ ] Delta sync (only changes)
- [ ] Offline-first database (IndexedDB)
- [ ] Progressive download of course content
- [ ] Offline video playback
- [ ] Advanced retry strategies with exponential backoff

## Troubleshooting

### Service Worker Not Registering

**Problem**: Service worker fails to register
**Solution**: Ensure app is served over HTTPS or localhost

### Cache Not Working

**Problem**: Resources not being cached
**Solution**: Check service worker logs in DevTools → Application → Service Workers

### Sync Not Triggering

**Problem**: Actions not syncing when back online
**Solution**:
- Check connectivity service is running
- Verify actions are in queue (Details dialog)
- Manually trigger sync

### Actions Lost

**Problem**: Queued actions disappear
**Solution**:
- Check browser localStorage is enabled
- Verify no localStorage quota exceeded
- Check browser console for errors

## Performance Considerations

- **First Load**: Slightly slower due to service worker registration
- **Subsequent Loads**: Much faster due to caching
- **Offline**: Instant for cached resources
- **Background Sync**: Minimal impact on performance
- **Memory**: Service worker runs in separate thread

## Browser Support

- ✅ Chrome/Edge (full support)
- ✅ Firefox (full support)
- ✅ Safari (partial support - no background sync)
- ❌ Internet Explorer (not supported)

---

**Implemented**: 2025-11-18
**Phase**: 5.5 - Offline Mode & Caching
**Status**: Complete
