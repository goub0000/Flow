import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Global Error Handler - Centralized error handling and logging
class ErrorHandler {
  static final _logger = Logger('ErrorHandler');
  static final List<ErrorListener> _listeners = [];

  /// Initialize error handling
  static void init() {
    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Set up platform error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };

    // Set up logging
    Logger.root.level = kDebugMode ? Level.ALL : Level.WARNING;
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          // ignore: avoid_print
          print('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          // ignore: avoid_print
          print('Stack trace:\n${record.stackTrace}');
        }
      }
    });
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    _logger.severe(
      'Flutter Error: ${details.exception}',
      details.exception,
      details.stack,
    );

    // Notify listeners
    for (final listener in _listeners) {
      listener.onError(details.exception, details.stack ?? StackTrace.current);
    }

    // In debug mode, also show the red screen
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle platform errors (outside Flutter framework)
  static void _handlePlatformError(Object error, StackTrace stack) {
    _logger.severe(
      'Platform Error: $error',
      error,
      stack,
    );

    // Notify listeners
    for (final listener in _listeners) {
      listener.onError(error, stack);
    }
  }

  /// Handle custom application errors
  static void handleError(
    Object error,
    StackTrace stackTrace, {
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    final message = context != null ? '$context: $error' : error.toString();

    _logger.severe(message, error, stackTrace);

    // Log metadata if provided
    if (metadata != null) {
      _logger.info('Error metadata: $metadata');
    }

    // Notify listeners
    for (final listener in _listeners) {
      listener.onError(error, stackTrace);
    }
  }

  /// Add error listener
  static void addListener(ErrorListener listener) {
    _listeners.add(listener);
  }

  /// Remove error listener
  static void removeListener(ErrorListener listener) {
    _listeners.remove(listener);
  }

  /// Clear all listeners
  static void clearListeners() {
    _listeners.clear();
  }

  /// Log info message
  static void logInfo(String message, {Map<String, dynamic>? metadata}) {
    _logger.info(message);
    if (metadata != null) {
      _logger.fine('Metadata: $metadata');
    }
  }

  /// Log warning message
  static void logWarning(String message, {Map<String, dynamic>? metadata}) {
    _logger.warning(message);
    if (metadata != null) {
      _logger.fine('Metadata: $metadata');
    }
  }

  /// Log error message
  static void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    _logger.severe(message, error, stackTrace);
    if (metadata != null) {
      _logger.fine('Metadata: $metadata');
    }
  }
}

/// Error listener interface
abstract class ErrorListener {
  void onError(Object error, StackTrace stackTrace);
}

/// Example error listener for analytics/monitoring
class AnalyticsErrorListener implements ErrorListener {
  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: Send error to analytics service (e.g., Sentry)
    if (kDebugMode) {
      // ignore: avoid_print
      print('AnalyticsErrorListener: $error');
    }
  }
}

/// Example error listener for user notifications
class NotificationErrorListener implements ErrorListener {
  final void Function(String message) onShowNotification;

  NotificationErrorListener({required this.onShowNotification});

  @override
  void onError(Object error, StackTrace stackTrace) {
    // Show user-friendly error message
    final message = _getUserFriendlyMessage(error);
    onShowNotification(message);
  }

  String _getUserFriendlyMessage(Object error) {
    // Convert technical errors to user-friendly messages
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('connection')) {
      return 'Network connection error. Please check your internet connection.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('permission')) {
      return 'Permission denied. Please check your access rights.';
    }

    if (errorString.contains('authentication') ||
        errorString.contains('unauthorized')) {
      return 'Authentication error. Please sign in again.';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}
