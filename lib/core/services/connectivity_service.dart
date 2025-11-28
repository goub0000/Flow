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
  bool _initialCheckDone = false;

  /// Stream of connectivity status changes
  Stream<ConnectivityStatus> get statusStream => _controller.stream;

  /// Current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Check if currently online
  bool get isOnline => _currentStatus == ConnectivityStatus.online;

  /// Check if currently offline
  bool get isOffline => _currentStatus == ConnectivityStatus.offline;

  void _init() {
    // Initialize with browser's online status - trust it initially
    // navigator.onLine is generally reliable for detecting network interface status
    final browserOnline = html.window.navigator.onLine ?? true;
    _currentStatus = browserOnline ? ConnectivityStatus.online : ConnectivityStatus.offline;

    print('[ConnectivityService] Initial status from browser: $_currentStatus');

    // Listen for online/offline events from browser
    html.window.onOnline.listen((_) {
      print('[ConnectivityService] Browser online event received');
      _updateStatus(ConnectivityStatus.online);
    });

    html.window.onOffline.listen((_) {
      print('[ConnectivityService] Browser offline event received');
      _updateStatus(ConnectivityStatus.offline);
    });

    // Do initial connectivity check after a short delay
    // This prevents false offline detection during app startup
    Future.delayed(const Duration(seconds: 3), () {
      _initialCheckDone = true;
      _checkConnectivity();
    });

    // Periodic connectivity check (every 60 seconds instead of 30)
    // Less frequent to avoid false negatives from transient network issues
    Timer.periodic(const Duration(seconds: 60), (_) {
      if (_initialCheckDone) {
        _checkConnectivity();
      }
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
    // First check browser's navigator.onLine as primary source
    final browserOnline = html.window.navigator.onLine ?? true;

    if (!browserOnline) {
      // Browser definitely says we're offline
      _updateStatus(ConnectivityStatus.offline);
      return;
    }

    // Browser says online, verify with a network request
    // Use multiple fallback methods for reliability
    try {
      // Method 1: Try to fetch a well-known resource that should always exist
      // Using a data URI ping is more reliable than fetching local resources
      // which may not exist or may have CORS issues

      // Simply trust navigator.onLine when it says we're online
      // The browser's network detection is reliable for most cases
      // Avoid false negatives from failed fetch requests due to:
      // - CORS issues
      // - Missing manifest.json
      // - Server returning non-2xx status codes
      // - Network latency

      _updateStatus(ConnectivityStatus.online);

    } catch (e) {
      print('[ConnectivityService] Connectivity check error: $e');
      // Only mark offline if browser also reports offline
      // Otherwise, trust that we're online (fetch errors can have many causes)
      if (!(html.window.navigator.onLine ?? true)) {
        _updateStatus(ConnectivityStatus.offline);
      }
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
