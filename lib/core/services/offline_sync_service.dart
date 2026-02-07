// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'connectivity_service.dart';

/// Represents an offline action to be synced
class OfflineAction {
  final String id;
  final String type;
  final String endpoint;
  final String method;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  OfflineAction({
    required this.id,
    required this.type,
    required this.endpoint,
    required this.method,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'endpoint': endpoint,
        'method': method,
        'data': data,
        'timestamp': timestamp.toIso8601String(),
      };

  factory OfflineAction.fromJson(Map<String, dynamic> json) => OfflineAction(
        id: json['id'] as String,
        type: json['type'] as String,
        endpoint: json['endpoint'] as String,
        method: json['method'] as String,
        data: json['data'] as Map<String, dynamic>,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

/// Service for managing offline actions and syncing when online
class OfflineSyncService {
  OfflineSyncService(this._connectivityService) {
    _init();
  }

  final ConnectivityService _connectivityService;
  final _queueController = StreamController<List<OfflineAction>>.broadcast();
  final List<OfflineAction> _queue = [];
  final _logger = Logger('OfflineSyncService');
  bool _isSyncing = false;

  static const _storageKey = 'offline_actions_queue';

  /// Stream of queue updates
  Stream<List<OfflineAction>> get queueStream => _queueController.stream;

  /// Current queue of offline actions
  List<OfflineAction> get queue => List.unmodifiable(_queue);

  /// Number of pending actions
  int get pendingCount => _queue.length;

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  void _init() {
    // Load queued actions from localStorage
    _loadQueue();

    // Listen for connectivity changes
    _connectivityService.statusStream.listen((status) {
      if (status == ConnectivityStatus.online && _queue.isNotEmpty) {
        // Auto-sync when back online
        syncAll();
      }
    });

    // Listen for background sync events from service worker
    html.window.addEventListener('background-sync', (event) {
      if (_connectivityService.isOnline) {
        syncAll();
      }
    });
  }

  /// Add an action to the offline queue
  Future<void> queueAction({
    required String type,
    required String endpoint,
    required String method,
    required Map<String, dynamic> data,
  }) async {
    final action = OfflineAction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      endpoint: endpoint,
      method: method,
      data: data,
      timestamp: DateTime.now(),
    );

    _queue.add(action);
    await _saveQueue();
    _queueController.add(queue);

    _logger.fine('Action queued: $type');

    // Try to sync immediately if online
    if (_connectivityService.isOnline) {
      syncAll();
    }
  }

  /// Sync all queued actions
  Future<void> syncAll() async {
    if (_isSyncing || _queue.isEmpty) return;
    if (!_connectivityService.isOnline) {
      _logger.fine('Cannot sync: offline');
      return;
    }

    _isSyncing = true;
    _logger.info('Starting sync of ${_queue.length} actions');

    final actionsToSync = List<OfflineAction>.from(_queue);

    for (final action in actionsToSync) {
      try {
        await _syncAction(action);
        _queue.remove(action);
        await _saveQueue();
        _queueController.add(queue);
      } catch (e) {
        _logger.warning('Failed to sync action ${action.id}: $e', e);
        // Continue with next action
      }
    }

    _isSyncing = false;
    _logger.info('Sync complete. Remaining: ${_queue.length}');
  }

  /// Sync a single action
  Future<void> _syncAction(OfflineAction action) async {
    try {
      final response = await html.window.fetch(action.endpoint, {
        'method': action.method,
        'headers': {
          'Content-Type': 'application/json',
        },
        'body': jsonEncode(action.data),
      });

      if (!response.ok) {
        throw Exception('HTTP ${response.status}: ${response.statusText}');
      }

      _logger.fine('Successfully synced action: ${action.type}');
    } catch (e) {
      _logger.warning('Error syncing action: $e', e);
      rethrow;
    }
  }

  /// Remove an action from the queue
  Future<void> removeAction(String id) async {
    _queue.removeWhere((action) => action.id == id);
    await _saveQueue();
    _queueController.add(queue);
  }

  /// Clear all queued actions
  Future<void> clearQueue() async {
    _queue.clear();
    await _saveQueue();
    _queueController.add(queue);
    _logger.fine('Queue cleared');
  }

  /// Load queue from localStorage
  void _loadQueue() {
    try {
      final storage = html.window.localStorage;
      final queueJson = storage[_storageKey];

      if (queueJson != null) {
        final List<dynamic> decoded = jsonDecode(queueJson);
        _queue.addAll(
          decoded.map((json) => OfflineAction.fromJson(json)).toList(),
        );
        _logger.fine('Loaded ${_queue.length} queued actions');
      }
    } catch (e) {
      _logger.warning('Error loading queue: $e', e);
    }
  }

  /// Save queue to localStorage
  Future<void> _saveQueue() async {
    try {
      final storage = html.window.localStorage;
      final queueJson = jsonEncode(_queue.map((a) => a.toJson()).toList());
      storage[_storageKey] = queueJson;
    } catch (e) {
      _logger.warning('Error saving queue: $e', e);
    }
  }

  void dispose() {
    _queueController.close();
  }
}

/// Provider for offline sync service
final offlineSyncServiceProvider = Provider<OfflineSyncService>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  final service = OfflineSyncService(connectivityService);
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for offline queue
final offlineQueueProvider = StreamProvider<List<OfflineAction>>((ref) {
  final service = ref.watch(offlineSyncServiceProvider);
  return service.queueStream;
});

/// Provider for pending actions count
final pendingActionsCountProvider = Provider<int>((ref) {
  final queue = ref.watch(offlineQueueProvider);
  return queue.when(
    data: (actions) => actions.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
});
