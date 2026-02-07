import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/l10n_extension.dart';

/// Provider for tracking last refresh times per dashboard/screen
final lastRefreshTimeProvider = StateProvider.family<DateTime?, String>((ref, key) => null);

/// Widget to display last refresh timestamp
class LastRefreshIndicator extends ConsumerWidget {
  final String providerKey;

  const LastRefreshIndicator({
    super.key,
    required this.providerKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRefresh = ref.watch(lastRefreshTimeProvider(providerKey));

    if (lastRefresh == null) return const SizedBox.shrink();

    final timeAgo = _formatTimeAgo(DateTime.now().difference(lastRefresh), context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        context.l10n.swRefreshLastUpdated(timeAgo),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade600,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatTimeAgo(Duration duration, BuildContext context) {
    if (duration.inSeconds < 10) return context.l10n.swRefreshJustNow;
    if (duration.inSeconds < 60) return context.l10n.swRefreshSecondsAgo(duration.inSeconds);
    if (duration.inMinutes < 60) return context.l10n.swRefreshMinutesAgo(duration.inMinutes);
    if (duration.inHours < 24) return context.l10n.swRefreshHoursAgo(duration.inHours);
    if (duration.inDays == 1) return context.l10n.swRefreshYesterday;
    return context.l10n.swRefreshDaysAgo(duration.inDays);
  }
}

/// Mixin to handle common refresh logic and prevent duplicate refreshes
mixin RefreshableMixin {
  bool _isRefreshing = false;

  /// Wrapper to prevent duplicate refresh calls
  Future<void> handleRefresh(Future<void> Function() refreshLogic) async {
    if (_isRefreshing) return;

    _isRefreshing = true;
    try {
      await refreshLogic();
    } finally {
      _isRefreshing = false;
    }
  }

  /// Show refresh feedback with snackbar
  void showRefreshFeedback(
    BuildContext context, {
    required bool success,
    String? message,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
            ? message ?? context.l10n.swRefreshSuccess
            : message ?? context.l10n.swRefreshFailed,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: success ? 1 : 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}