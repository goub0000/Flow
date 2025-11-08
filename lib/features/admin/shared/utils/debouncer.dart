import 'dart:async';

/// Debouncer utility to delay function execution
/// Useful for search inputs to avoid excessive API calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Call the action after the delay
  /// If called again before delay completes, cancels previous timer
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending action
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose and clean up
  void dispose() {
    _timer?.cancel();
  }
}
