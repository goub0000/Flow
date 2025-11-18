import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../core/services/offline_sync_service.dart';

/// Widget that displays offline status at the top of the screen
class OfflineStatusIndicator extends ConsumerWidget {
  const OfflineStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);
    final pendingCount = ref.watch(pendingActionsCountProvider);

    return connectivityStatus.when(
      data: (status) {
        if (status == ConnectivityStatus.online) {
          // Show syncing indicator if there are pending actions
          if (pendingCount > 0) {
            return _buildSyncingBanner(context, pendingCount);
          }
          return const SizedBox.shrink();
        } else {
          // Show offline banner
          return _buildOfflineBanner(context, pendingCount);
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildOfflineBanner(BuildContext context, int pendingCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange.shade700,
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'You are offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (pendingCount > 0)
                  Text(
                    '$pendingCount ${pendingCount == 1 ? 'action' : 'actions'} pending sync',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _showOfflineDetails(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncingBanner(BuildContext context, int pendingCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.blue.shade700,
      child: Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Syncing $pendingCount ${pendingCount == 1 ? 'action' : 'actions'}...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOfflineDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _OfflineDetailsDialog(),
    );
  }
}

/// Dialog showing offline queue details
class _OfflineDetailsDialog extends ConsumerWidget {
  const _OfflineDetailsDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(offlineQueueProvider);
    final syncService = ref.watch(offlineSyncServiceProvider);

    return AlertDialog(
      title: const Text('Offline Actions'),
      content: SizedBox(
        width: double.maxFinite,
        child: queue.when(
          data: (actions) {
            if (actions.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Text('No pending actions'),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                return ListTile(
                  leading: Icon(
                    _getIconForAction(action.type),
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(action.type),
                  subtitle: Text(
                    '${action.method} ${action.endpoint}\n${_formatTimestamp(action.timestamp)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      syncService.removeAction(action.id);
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            syncService.clearQueue();
            Navigator.of(context).pop();
          },
          child: const Text('Clear All'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
        if (ref.watch(isOnlineProvider))
          ElevatedButton(
            onPressed: () {
              syncService.syncAll();
              Navigator.of(context).pop();
            },
            child: const Text('Sync Now'),
          ),
      ],
    );
  }

  IconData _getIconForAction(String type) {
    switch (type.toLowerCase()) {
      case 'application':
        return Icons.description;
      case 'profile':
        return Icons.person;
      case 'message':
        return Icons.message;
      case 'grade':
        return Icons.grade;
      default:
        return Icons.sync;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

/// Mini offline indicator for app bars
class CompactOfflineIndicator extends ConsumerWidget {
  const CompactOfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final pendingCount = ref.watch(pendingActionsCountProvider);

    if (isOnline && pendingCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.blue : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.sync : Icons.cloud_off,
            color: Colors.white,
            size: 14,
          ),
          if (pendingCount > 0) ...[
            const SizedBox(width: 4),
            Text(
              '$pendingCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
