import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/connectivity_service.dart';
import '../services/offline_sync_service.dart';

/// Mixin for providers that support optimistic updates
///
/// Usage:
/// ```dart
/// class MyNotifier extends StateNotifier<MyState> with OptimisticUpdateMixin<MyState> {
///   MyNotifier(this.ref) : super(MyState());
///
///   final Ref ref;
///
///   Future<void> updateItem(Item item) async {
///     // Optimistically update UI
///     await performOptimisticUpdate(
///       optimisticState: state.copyWith(item: item),
///       onlineAction: () async {
///         // Perform actual API call
///         await api.updateItem(item);
///       },
///       offlineAction: () {
///         // Queue for later sync
///         queueOfflineAction(
///           type: 'update_item',
///           endpoint: '/api/items/${item.id}',
///           method: 'PUT',
///           data: item.toJson(),
///         );
///       },
///       onError: (error) {
///         // Revert to previous state on error
///         // (automatically done by mixin)
///       },
///     );
///   }
/// }
/// ```
mixin OptimisticUpdateMixin<T> on StateNotifier<T> {
  /// Reference to Riverpod container (must be provided by implementing class)
  Ref get ref;

  /// Perform an optimistic update
  ///
  /// Updates the state immediately (optimistic), then performs the actual update.
  /// If the update fails, reverts to the previous state.
  /// If offline, queues the action for later sync.
  Future<void> performOptimisticUpdate({
    required T optimisticState,
    required Future<void> Function() onlineAction,
    required void Function() offlineAction,
    void Function(dynamic error)? onError,
  }) async {
    final previousState = state;
    final connectivityService = ref.read(connectivityServiceProvider);
    final isOnline = connectivityService.isOnline;

    try {
      // 1. Update UI immediately (optimistic)
      state = optimisticState;

      if (isOnline) {
        // 2. Perform actual action online
        await onlineAction();
      } else {
        // 2. Queue action for later sync
        offlineAction();
      }
    } catch (error) {
      // 3. Revert to previous state on error
      state = previousState;

      // 4. Call error handler if provided
      onError?.call(error);

      rethrow;
    }
  }

  /// Queue an action for offline sync
  void queueOfflineAction({
    required String type,
    required String endpoint,
    required String method,
    required Map<String, dynamic> data,
  }) {
    final syncService = ref.read(offlineSyncServiceProvider);
    syncService.queueAction(
      type: type,
      endpoint: endpoint,
      method: method,
      data: data,
    );
  }
}

/// Extension on AsyncNotifier for optimistic updates
extension OptimisticAsyncNotifierExtension<T> on AsyncNotifier<T> {
  /// Perform an optimistic update on AsyncNotifier
  Future<void> performOptimisticUpdate({
    required T optimisticState,
    required Future<void> Function() onlineAction,
    required void Function() offlineAction,
    void Function(dynamic error)? onError,
  }) async {
    final previousState = state;
    final connectivityService = ref.read(connectivityServiceProvider);
    final isOnline = connectivityService.isOnline;

    try {
      // 1. Update UI immediately (optimistic)
      state = AsyncData(optimisticState);

      if (isOnline) {
        // 2. Perform actual action online
        await onlineAction();
      } else {
        // 2. Queue action for later sync
        offlineAction();
      }
    } catch (error, stackTrace) {
      // 3. Restore previous state on error
      state = previousState;

      // 4. Call error handler if provided
      onError?.call(error);

      // Set error state
      state = AsyncError(error, stackTrace);
    }
  }

  /// Queue an action for offline sync
  void queueOfflineAction({
    required String type,
    required String endpoint,
    required String method,
    required Map<String, dynamic> data,
  }) {
    final syncService = ref.read(offlineSyncServiceProvider);
    syncService.queueAction(
      type: type,
      endpoint: endpoint,
      method: method,
      data: data,
    );
  }
}

/// Helper class for managing optimistic updates in functional providers
class OptimisticUpdateHelper {
  OptimisticUpdateHelper(this.ref);

  final Ref ref;

  /// Check if online
  bool get isOnline {
    return ref.read(connectivityServiceProvider).isOnline;
  }

  /// Perform an optimistic update
  ///
  /// Returns true if the action was performed successfully (online or queued offline)
  Future<bool> performUpdate({
    required Future<void> Function() onlineAction,
    required Future<void> Function()? offlineAction,
  }) async {
    try {
      if (isOnline) {
        await onlineAction();
        return true;
      } else {
        if (offlineAction != null) {
          await offlineAction();
        }
        return false; // Queued for later
      }
    } catch (error) {
      rethrow;
    }
  }

  /// Queue an action for offline sync
  void queueAction({
    required String type,
    required String endpoint,
    required String method,
    required Map<String, dynamic> data,
  }) {
    final syncService = ref.read(offlineSyncServiceProvider);
    syncService.queueAction(
      type: type,
      endpoint: endpoint,
      method: method,
      data: data,
    );
  }
}
