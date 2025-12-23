import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../providers/student_parent_linking_provider.dart';

/// Screen for students to manage parent linking
class ParentLinkingScreen extends ConsumerWidget {
  const ParentLinkingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parent Linking'),
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(
                icon: Badge(
                  isLabelVisible: ref.watch(linkedParentsCountProvider) > 0,
                  label: Text('${ref.watch(linkedParentsCountProvider)}'),
                  child: const Icon(Icons.family_restroom),
                ),
                text: 'Linked',
              ),
              Tab(
                icon: Badge(
                  isLabelVisible: ref.watch(pendingLinksCountProvider) > 0,
                  label: Text('${ref.watch(pendingLinksCountProvider)}'),
                  child: const Icon(Icons.notifications_outlined),
                ),
                text: 'Requests',
              ),
              const Tab(
                icon: Icon(Icons.vpn_key_outlined),
                text: 'Invite Codes',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _LinkedParentsTab(),
            _PendingLinksTab(),
            _InviteCodesTab(),
          ],
        ),
      ),
    );
  }
}

/// Tab for viewing linked parents
class _LinkedParentsTab extends ConsumerWidget {
  const _LinkedParentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkedParents = ref.watch(linkedParentsProvider);
    final state = ref.watch(studentParentLinkingProvider);

    if (state.isLoading) {
      return const LoadingIndicator(message: 'Loading linked parents...');
    }

    if (linkedParents.isEmpty) {
      return EmptyState(
        icon: Icons.family_restroom,
        title: 'No Linked Parents',
        message: 'When a parent links their account to yours, they will appear here.',
        onAction: () => ref.read(studentParentLinkingProvider.notifier).fetchLinkedParents(),
        actionLabel: 'Refresh',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(studentParentLinkingProvider.notifier).fetchLinkedParents(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: linkedParents.length,
        itemBuilder: (context, index) {
          final parent = linkedParents[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _LinkedParentCard(parent: parent),
          );
        },
      ),
    );
  }
}

/// Card for a linked parent
class _LinkedParentCard extends StatelessWidget {
  final LinkedParent parent;

  const _LinkedParentCard({required this.parent});

  @override
  Widget build(BuildContext context) {
    final permissions = parent.permissions;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.success.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: AppColors.success),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parent.parentName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      parent.parentEmail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Linked',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Permissions
          Text(
            'Permissions:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (permissions['can_view_grades'] == true)
                _PermissionChip(label: 'View Grades', icon: Icons.grade),
              if (permissions['can_view_activity'] == true)
                _PermissionChip(label: 'View Activity', icon: Icons.timeline),
              if (permissions['can_view_messages'] == true)
                _PermissionChip(label: 'View Messages', icon: Icons.message, isPrivate: true),
              if (permissions['can_receive_alerts'] == true)
                _PermissionChip(label: 'Receive Alerts', icon: Icons.notifications),
            ],
          ),
          const SizedBox(height: 12),

          // Relationship and linked date
          Row(
            children: [
              Text(
                parent.relationship[0].toUpperCase() + parent.relationship.substring(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                '• Linked ${_timeAgo(parent.linkedAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

/// Tab for viewing and responding to pending parent link requests
class _PendingLinksTab extends ConsumerWidget {
  const _PendingLinksTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentParentLinkingProvider);

    if (state.isLoading) {
      return const LoadingIndicator(message: 'Loading requests...');
    }

    if (state.pendingLinks.isEmpty) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Pending Requests',
        message: 'You don\'t have any parent link requests to review.',
        onAction: () => ref.read(studentParentLinkingProvider.notifier).fetchPendingLinks(),
        actionLabel: 'Refresh',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(studentParentLinkingProvider.notifier).fetchPendingLinks(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.pendingLinks.length,
        itemBuilder: (context, index) {
          final link = state.pendingLinks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _PendingLinkCard(link: link),
          );
        },
      ),
    );
  }
}

/// Card for a pending parent link request
class _PendingLinkCard extends ConsumerStatefulWidget {
  final PendingParentLink link;

  const _PendingLinkCard({required this.link});

  @override
  ConsumerState<_PendingLinkCard> createState() => _PendingLinkCardState();
}

class _PendingLinkCardState extends ConsumerState<_PendingLinkCard> {
  bool _isProcessing = false;

  Future<void> _handleApprove() async {
    setState(() => _isProcessing = true);

    final success = await ref
        .read(studentParentLinkingProvider.notifier)
        .approveLink(widget.link.id);

    if (mounted) {
      setState(() => _isProcessing = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.link.parentName} has been linked to your account'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _handleDecline() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Request'),
        content: Text('Are you sure you want to decline the link request from ${widget.link.parentName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Decline'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);

    final success = await ref
        .read(studentParentLinkingProvider.notifier)
        .declineLink(widget.link.id);

    if (mounted) {
      setState(() => _isProcessing = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request declined'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final link = widget.link;
    final permissions = link.requestedPermissions;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      link.parentName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      link.parentEmail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  link.relationship[0].toUpperCase() + link.relationship.substring(1),
                  style: TextStyle(
                    color: AppColors.info,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Requested Permissions
          Text(
            'Requested Permissions:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (permissions['can_view_grades'] == true)
                _PermissionChip(label: 'View Grades', icon: Icons.grade),
              if (permissions['can_view_activity'] == true)
                _PermissionChip(label: 'View Activity', icon: Icons.timeline),
              if (permissions['can_view_messages'] == true)
                _PermissionChip(label: 'View Messages', icon: Icons.message, isPrivate: true),
              if (permissions['can_receive_alerts'] == true)
                _PermissionChip(label: 'Receive Alerts', icon: Icons.notifications),
            ],
          ),
          const SizedBox(height: 16),

          // Time ago
          Text(
            'Requested ${_timeAgo(link.createdAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isProcessing ? null : _handleDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}

class _PermissionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrivate;

  const _PermissionChip({
    required this.label,
    required this.icon,
    this.isPrivate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isPrivate
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPrivate
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPrivate ? AppColors.warning : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isPrivate ? AppColors.warning : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tab for managing invite codes
class _InviteCodesTab extends ConsumerWidget {
  const _InviteCodesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(studentParentLinkingProvider);
    final activeCodes = ref.watch(activeInviteCodesProvider);

    return Column(
      children: [
        // Generate code button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showGenerateCodeDialog(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Generate New Invite Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        // Info card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Share your invite code with your parent so they can link their account to yours.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Codes list
        Expanded(
          child: state.inviteCodes.isEmpty
              ? const EmptyState(
                  icon: Icons.vpn_key_outlined,
                  title: 'No Invite Codes',
                  message: 'Generate an invite code to share with your parent.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.inviteCodes.length,
                  itemBuilder: (context, index) {
                    final code = state.inviteCodes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InviteCodeCard(code: code),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Future<void> _showGenerateCodeDialog(BuildContext context, WidgetRef ref) async {
    int expiresInDays = 7;
    int maxUses = 1;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Generate Invite Code'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Configure your invite code settings:'),
              const SizedBox(height: 16),

              // Expires in days
              Text(
                'Expires in: $expiresInDays days',
                style: const TextStyle(fontSize: 14),
              ),
              Slider(
                value: expiresInDays.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$expiresInDays days',
                onChanged: (value) => setState(() => expiresInDays = value.toInt()),
              ),

              const SizedBox(height: 8),

              // Max uses
              Text(
                'Maximum uses: $maxUses',
                style: const TextStyle(fontSize: 14),
              ),
              Slider(
                value: maxUses.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$maxUses use${maxUses > 1 ? 's' : ''}',
                onChanged: (value) => setState(() => maxUses = value.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generate'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final code = await ref.read(studentParentLinkingProvider.notifier).generateInviteCode(
        expiresInDays: expiresInDays,
        maxUses: maxUses,
      );

      if (code != null && context.mounted) {
        _showCodeGeneratedDialog(context, code);
      }
    }
  }

  void _showCodeGeneratedDialog(BuildContext context, InviteCode code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: 8),
            const Text('Code Generated!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your parent:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    code.code,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code.code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied to clipboard')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

/// Card for displaying an invite code
class _InviteCodeCard extends ConsumerWidget {
  final InviteCode code;

  const _InviteCodeCard({required this.code});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUsable = code.isUsable;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  code.code,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: isUsable ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: isUsable
                    ? () {
                        Clipboard.setData(ClipboardData(text: code.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Code copied to clipboard')),
                        );
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                onPressed: () => _deleteCode(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatusChip(
                label: isUsable ? 'Active' : (code.isExpired ? 'Expired' : 'Used'),
                color: isUsable ? AppColors.success : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                '${code.usesRemaining}/${code.maxUses} uses left',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const Spacer(),
              Text(
                'Expires: ${_formatDate(code.expiresAt)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: code.isExpired ? AppColors.error : AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCode(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Invite Code'),
        content: const Text('Are you sure you want to delete this invite code?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(studentParentLinkingProvider.notifier).deleteInviteCode(code.id);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
