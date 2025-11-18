import 'dart:async';
import 'dart:html' as html;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity status enum
enum ConnectivityStatus {
  online,
  offline,
}

/// Service for monitoring network connectivity
class ConnectivityService {
  ConnectivityService() {
    _init();
  }

  final _controller = StreamController<ConnectivityStatus>.broadcast();
  ConnectivityStatus _currentStatus = ConnectivityStatus.online;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Check if currently online
  bool get isOnline => _currentStatus == ConnectivityStatus.online;

  /// Check if currently offline
  bool get isOffline => _currentStatus == ConnectivityStatus.offline;

  void _init() {
    // Initialize with current online status
    _currentStatus = html.window.navigator.onLine
        ? ConnectivityStatus.online
        : ConnectivityStatus.offline;

    // Listen for online/offline events
    html.window.onOnline.listen((_) {
      _updateStatus(ConnectivityStatus.online);
    });

    html.window.onOffline.listen((_) {
      _updateStatus(ConnectivityStatus.offline);
    });

    // Periodic connectivity check (every 30 seconds)
    Timer.periodic(const Duration(seconds: 30), (_) {
      _checkConnectivity();
    });
  }

  void _updateStatus(ConnectivityStatus status) {
    if (_currentStatus != status) {
      _currentStatus = status;
      _controller.add(status);
      print('[ConnectivityService] Status changed to: $status');
    }
  }

  /// Manually check connectivity by pinging a server
  Future<void> _checkConnectivity() async {
    try {
      // Try to fetch a small resource to verify connectivity
      final response = await html.window.fetch('/manifest.json', {
        'method': 'HEAD',
        'cache': 'no-cache',
      });

      final isOnline = response.ok;
      _updateStatus(
        isOnline ? ConnectivityStatus.online : ConnectivityStatus.offline,
      );
    } catch (e) {
      _updateStatus(ConnectivityStatus.offline);
    }
  }

  /// Force a connectivity check
  Future<bool> checkNow() async {
    await _checkConnectivity();
    return isOnline;
  }

  void dispose() {
    _controller.close();
  }
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for current connectivity status
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});

/// Provider for checking if online
final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider);
  return status.when(
    data: (status) => status == ConnectivityStatus.online,
    loading: () => true, // Assume online while loading
    error: (_, __) => false,
  );
});
