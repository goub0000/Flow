/// Enhanced Realtime Service
/// Comprehensive Supabase real-time subscription management with auto-reconnection
/// and proper cleanup mechanisms

import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectionStatus {
  connected,
  connecting,
  disconnected,
  error,
}

/// Central service for managing Supabase real-time subscriptions
class EnhancedRealtimeService {
  final SupabaseClient _supabase;
  final Map<String, RealtimeChannel> _channels = {};
  final Map<String, Timer> _reconnectTimers = {};

  // Connection management
  final _connectionStatusController = StreamController<ConnectionStatus>.broadcast();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;
  bool _isInitialized = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  /// Stream of connection status updates
  Stream<ConnectionStatus> get connectionStatus => _connectionStatusController.stream;

  /// Current connection status
  ConnectionStatus get currentConnectionStatus => _currentStatus;

  EnhancedRealtimeService(this._supabase) {
    _initialize();
  }

  void _initialize() {
    if (_isInitialized) return;
    _isInitialized = true;

    // Start monitoring connectivity
    _startConnectivityMonitoring();

    // Initial connection attempt
    _updateConnectionStatus(ConnectionStatus.connecting);
    _attemptConnection();
  }

  void _startConnectivityMonitoring() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        if (results.isEmpty || results.every((result) => result == ConnectivityResult.none)) {
          _handleOffline();
        } else {
          _handleOnline();
        }
      },
    );
  }

  void _handleOffline() {
    print('[RealtimeService] Network offline detected');
    _updateConnectionStatus(ConnectionStatus.disconnected);
    _pauseAllChannels();
  }

  void _handleOnline() {
    print('[RealtimeService] Network online detected');
    if (_currentStatus == ConnectionStatus.disconnected) {
      _updateConnectionStatus(ConnectionStatus.connecting);
      _reconnectAll();
    }
  }

  void _updateConnectionStatus(ConnectionStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _connectionStatusController.add(status);
      print('[RealtimeService] Connection status: $status');
    }
  }

  void _attemptConnection() {
    // Check if we have any active channels
    if (_channels.isEmpty) {
      _updateConnectionStatus(ConnectionStatus.connected);
      return;
    }

    // Try to connect all channels
    _reconnectAll();
  }

  /// Subscribe to a table with comprehensive filtering
  RealtimeChannel? subscribeToTable({
    required String table,
    required String channelName,
    String schema = 'public',
    PostgresChangeFilter? filter,
    Function(Map<String, dynamic>)? onInsert,
    Function(Map<String, dynamic>)? onUpdate,
    Function(Map<String, dynamic>)? onDelete,
    Function(String)? onError,
  }) {
    try {
      // Remove existing channel if it exists
      if (_channels.containsKey(channelName)) {
        unsubscribe(channelName);
      }

      print('[RealtimeService] Subscribing to $table with channel: $channelName');

      final channel = _supabase.channel(channelName);

      // Subscribe to INSERT events
      if (onInsert != null) {
        channel.onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: schema,
          table: table,
          filter: filter,
          callback: (payload) {
            print('[RealtimeService] INSERT event on $table: ${payload.newRecord}');
            try {
              onInsert(payload.newRecord);
            } catch (e) {
              print('[RealtimeService] Error handling INSERT: $e');
              onError?.call('Error handling INSERT: $e');
            }
          },
        );
      }

      // Subscribe to UPDATE events
      if (onUpdate != null) {
        channel.onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: schema,
          table: table,
          filter: filter,
          callback: (payload) {
            print('[RealtimeService] UPDATE event on $table: ${payload.newRecord}');
            try {
              onUpdate(payload.newRecord);
            } catch (e) {
              print('[RealtimeService] Error handling UPDATE: $e');
              onError?.call('Error handling UPDATE: $e');
            }
          },
        );
      }

      // Subscribe to DELETE events
      if (onDelete != null) {
        channel.onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: schema,
          table: table,
          filter: filter,
          callback: (payload) {
            print('[RealtimeService] DELETE event on $table: ${payload.oldRecord}');
            try {
              onDelete(payload.oldRecord);
            } catch (e) {
              print('[RealtimeService] Error handling DELETE: $e');
              onError?.call('Error handling DELETE: $e');
            }
          },
        );
      }

      // Subscribe the channel
      channel.subscribe((status, [error]) async {
        if (status == RealtimeSubscribeStatus.subscribed) {
          print('[RealtimeService] Successfully subscribed to $channelName');
          _updateConnectionStatus(ConnectionStatus.connected);
          _reconnectAttempts = 0;
        } else if (status == RealtimeSubscribeStatus.closed) {
          print('[RealtimeService] Channel $channelName closed');
          _scheduleReconnect(channelName);
        } else if (status == RealtimeSubscribeStatus.channelError) {
          print('[RealtimeService] Channel $channelName error: $error');
          onError?.call('Channel error: $error');
          _scheduleReconnect(channelName);
        }
      });

      _channels[channelName] = channel;
      return channel;

    } catch (e) {
      print('[RealtimeService] Error subscribing to $table: $e');
      onError?.call('Subscription error: $e');
      _updateConnectionStatus(ConnectionStatus.error);
      return null;
    }
  }

  /// Subscribe to specific record changes
  RealtimeChannel? subscribeToRecord({
    required String table,
    required String channelName,
    required String recordId,
    String schema = 'public',
    String idColumn = 'id',
    Function(Map<String, dynamic>)? onUpdate,
    Function(Map<String, dynamic>)? onDelete,
    Function(String)? onError,
  }) {
    return subscribeToTable(
      table: table,
      channelName: channelName,
      schema: schema,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: idColumn,
        value: recordId,
      ),
      onUpdate: onUpdate,
      onDelete: onDelete,
      onError: onError,
    );
  }

  /// Subscribe to user-specific records
  RealtimeChannel? subscribeToUserRecords({
    required String table,
    required String channelName,
    required String userId,
    String schema = 'public',
    String userColumn = 'user_id',
    Function(Map<String, dynamic>)? onInsert,
    Function(Map<String, dynamic>)? onUpdate,
    Function(Map<String, dynamic>)? onDelete,
    Function(String)? onError,
  }) {
    return subscribeToTable(
      table: table,
      channelName: channelName,
      schema: schema,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: userColumn,
        value: userId,
      ),
      onInsert: onInsert,
      onUpdate: onUpdate,
      onDelete: onDelete,
      onError: onError,
    );
  }

  /// Schedule reconnection for a specific channel
  void _scheduleReconnect(String channelName) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('[RealtimeService] Max reconnect attempts reached for $channelName');
      _updateConnectionStatus(ConnectionStatus.error);
      return;
    }

    _reconnectTimers[channelName]?.cancel();
    _reconnectTimers[channelName] = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      print('[RealtimeService] Reconnect attempt $_reconnectAttempts for $channelName');
      _reconnectChannel(channelName);
    });
  }

  /// Reconnect a specific channel
  void _reconnectChannel(String channelName) {
    final channel = _channels[channelName];
    if (channel != null) {
      try {
        channel.subscribe();
      } catch (e) {
        print('[RealtimeService] Failed to reconnect $channelName: $e');
        _scheduleReconnect(channelName);
      }
    }
  }

  /// Pause all channels (when going offline)
  void _pauseAllChannels() {
    for (final timer in _reconnectTimers.values) {
      timer.cancel();
    }
    _reconnectTimers.clear();
  }

  /// Reconnect all channels
  void _reconnectAll() {
    _reconnectAttempts = 0;
    for (final entry in _channels.entries) {
      _reconnectChannel(entry.key);
    }
  }

  /// Force reconnect all subscriptions
  Future<void> reconnectAll() async {
    print('[RealtimeService] Forcing reconnection of all channels');
    _updateConnectionStatus(ConnectionStatus.connecting);
    _reconnectAll();
  }

  /// Unsubscribe from a channel
  Future<void> unsubscribe(String channelName) async {
    try {
      final channel = _channels[channelName];
      if (channel != null) {
        await _supabase.removeChannel(channel);
        _channels.remove(channelName);
        _reconnectTimers[channelName]?.cancel();
        _reconnectTimers.remove(channelName);
        print('[RealtimeService] Unsubscribed from $channelName');
      }
    } catch (e) {
      print('[RealtimeService] Error unsubscribing from $channelName: $e');
    }
  }

  /// Unsubscribe from all channels
  Future<void> unsubscribeAll() async {
    print('[RealtimeService] Unsubscribing from all channels');

    // Cancel all reconnect timers
    for (final timer in _reconnectTimers.values) {
      timer.cancel();
    }
    _reconnectTimers.clear();

    // Unsubscribe from all channels
    for (final channelName in _channels.keys.toList()) {
      await unsubscribe(channelName);
    }

    _updateConnectionStatus(ConnectionStatus.disconnected);
  }

  /// Check if a channel is subscribed
  bool isSubscribed(String channelName) {
    return _channels.containsKey(channelName);
  }

  /// Get list of active channel names
  List<String> getActiveChannels() {
    return _channels.keys.toList();
  }

  /// Dispose resources
  void dispose() {
    print('[RealtimeService] Disposing realtime service');

    // Cancel connectivity subscription
    _connectivitySubscription?.cancel();

    // Unsubscribe all channels
    unsubscribeAll();

    // Close stream controller
    _connectionStatusController.close();

    _isInitialized = false;
  }
}