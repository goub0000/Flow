import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_communications_provider.dart';

/// Communications Hub Screen - Manage platform communications
class CommunicationsHubScreen extends ConsumerStatefulWidget {
  const CommunicationsHubScreen({super.key});

  @override
  ConsumerState<CommunicationsHubScreen> createState() =>
      _CommunicationsHubScreenState();
}

class _CommunicationsHubScreenState
    extends ConsumerState<CommunicationsHubScreen> {
  String _selectedTab = 'campaigns';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Content is wrapped by AdminShell via ShellRoute
    return _buildContent();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Header
        _buildHeader(),
        const SizedBox(height: 24),

        // Tab Navigation
        _buildTabNavigation(),
        const SizedBox(height: 24),

        // Tab Content
        Expanded(
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.campaign,
                    size: 32,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.adminCommTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminCommSubtitle,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Refresh button
              IconButton(
                onPressed: () {
                  ref.read(adminCommunicationsProvider.notifier).fetchCampaigns();
                },
                icon: const Icon(Icons.refresh),
                tooltip: context.l10n.adminCommRefresh,
              ),
              const SizedBox(width: 12),
              // Create campaign button
              PermissionGuard(
                permission: AdminPermission.sendAnnouncements,
                child: ElevatedButton.icon(
                  onPressed: () => _showCreateCampaignDialog(),
                  icon: const Icon(Icons.add, size: 20),
                  label: Text(context.l10n.adminCommNewCampaign),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _buildTab('campaigns', context.l10n.adminCommTabAllCampaigns, Icons.campaign),
          _buildTab('announcements', context.l10n.adminCommTabAnnouncements, Icons.announcement),
          _buildTab('emails', context.l10n.adminCommTabEmails, Icons.email),
          _buildTab('push', context.l10n.adminCommTabPushNotifications, Icons.notifications),
        ],
      ),
    );
  }

  Widget _buildTab(String id, String label, IconData icon) {
    final isSelected = _selectedTab == id;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() => _selectedTab = id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final commsState = ref.watch(adminCommunicationsProvider);
    final campaigns = commsState.campaigns;
    final isLoading = commsState.isLoading;
    final error = commsState.error;

    // Filter campaigns based on selected tab
    List<Campaign> filteredCampaigns;
    switch (_selectedTab) {
      case 'announcements':
        filteredCampaigns = campaigns.where((c) => c.type == 'in_app' || c.type == 'announcement').toList();
        break;
      case 'emails':
        filteredCampaigns = campaigns.where((c) => c.type == 'email').toList();
        break;
      case 'push':
        filteredCampaigns = campaigns.where((c) => c.type == 'push').toList();
        break;
      default:
        filteredCampaigns = campaigns;
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredCampaigns = filteredCampaigns
          .where((c) => c.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Column(
      children: [
        // Stats Cards
        _buildStatsRow(campaigns),
        const SizedBox(height: 24),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: context.l10n.adminCommSearchHint,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),
        const SizedBox(height: 16),

        // Campaign List
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
                  ? _buildErrorState(error)
                  : filteredCampaigns.isEmpty
                      ? _buildEmptyState()
                      : _buildCampaignsList(filteredCampaigns),
        ),
      ],
    );
  }

  Widget _buildStatsRow(List<Campaign> campaigns) {
    final stats = ref.read(adminCommunicationsProvider.notifier).getCampaignStatistics();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context.l10n.adminCommStatTotalCampaigns,
              '${stats['total'] ?? 0}',
              context.l10n.adminCommStatAllCampaigns,
              Icons.campaign,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminCommStatDraft,
              '${stats['draft'] ?? 0}',
              context.l10n.adminCommStatNotSentYet,
              Icons.edit_note,
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminCommStatScheduled,
              '${stats['scheduled'] ?? 0}',
              context.l10n.adminCommStatPendingDelivery,
              Icons.schedule,
              AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              context.l10n.adminCommStatSent,
              '${stats['sent'] ?? 0}',
              context.l10n.adminCommStatSuccessfullySent,
              Icons.check_circle,
              AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, size: 20, color: color.withValues(alpha: 0.6)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignsList(List<Campaign> campaigns) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final campaign = campaigns[index];
          return _buildCampaignCard(campaign);
        },
      ),
    );
  }

  Widget _buildCampaignCard(Campaign campaign) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Type Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getTypeColor(campaign.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTypeIcon(campaign.type),
                color: _getTypeColor(campaign.type),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Campaign Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatusChip(campaign.status),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(campaign.createdAt),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (campaign.message != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      campaign.message!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${campaign.recipientCount ?? 0} recipients',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${campaign.deliveredCount ?? 0} delivered',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Actions
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (action) => _handleCampaignAction(action, campaign),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      const Icon(Icons.visibility, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.adminCommActionViewDetails),
                    ],
                  ),
                ),
                if (campaign.status == 'draft') ...[
                  PopupMenuItem(
                    value: 'send',
                    child: Row(
                      children: [
                        const Icon(Icons.send, size: 18),
                        const SizedBox(width: 8),
                        Text(context.l10n.adminCommActionSendNow),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'schedule',
                    child: Row(
                      children: [
                        const Icon(Icons.schedule, size: 18),
                        const SizedBox(width: 8),
                        Text(context.l10n.adminCommActionSchedule),
                      ],
                    ),
                  ),
                ],
                PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      const Icon(Icons.copy, size: 18),
                      const SizedBox(width: 8),
                      Text(context.l10n.adminCommActionDuplicate),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(context.l10n.adminCommActionDelete, style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'sent':
        color = AppColors.success;
        break;
      case 'scheduled':
        color = AppColors.warning;
        break;
      case 'draft':
        color = AppColors.textSecondary;
        break;
      case 'failed':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.adminCommEmptyTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.adminCommEmptySubtitle,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateCampaignDialog(),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.adminCommCreateCampaign),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            context.l10n.adminCommErrorTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(adminCommunicationsProvider.notifier).fetchCampaigns();
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.adminCommRetry),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'email':
        return Icons.email;
      case 'sms':
        return Icons.sms;
      case 'push':
        return Icons.notifications;
      case 'in_app':
      case 'announcement':
        return Icons.announcement;
      default:
        return Icons.campaign;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'email':
        return AppColors.primary;
      case 'sms':
        return AppColors.success;
      case 'push':
        return AppColors.warning;
      case 'in_app':
      case 'announcement':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  void _handleCampaignAction(String action, Campaign campaign) async {
    switch (action) {
      case 'view':
        _showCampaignDetails(campaign);
        break;
      case 'send':
        final confirmed = await _showConfirmDialog(
          context.l10n.adminCommSendCampaignTitle,
          context.l10n.adminCommSendCampaignMessage(campaign.title),
        );
        if (confirmed && mounted) {
          // Update status to sent via API
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.adminCommSendingCampaign)),
          );
          ref.read(adminCommunicationsProvider.notifier).fetchCampaigns();
        }
        break;
      case 'schedule':
        _showScheduleDialog(campaign);
        break;
      case 'duplicate':
        _showCreateCampaignDialog(duplicateFrom: campaign);
        break;
      case 'delete':
        final confirmed = await _showConfirmDialog(
          context.l10n.adminCommDeleteCampaignTitle,
          context.l10n.adminCommDeleteCampaignMessage(campaign.title),
        );
        if (confirmed && mounted) {
          final success = await ref
              .read(adminCommunicationsProvider.notifier)
              .deleteCampaign(campaign.id);
          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.adminCommCampaignDeleted)),
            );
          }
        }
        break;
    }
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.l10n.adminCommCancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.l10n.adminCommConfirm),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showScheduleDialog(Campaign campaign) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = const TimeOfDay(hour: 9, minute: 0);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.adminCommScheduleCampaignTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormat('EEEE, MMMM d, yyyy').format(selectedDate)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setDialogState(() => selectedDate = date);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setDialogState(() => selectedTime = time);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.adminCommCancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final scheduledDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );
                Navigator.pop(context);
                final success = await ref
                    .read(adminCommunicationsProvider.notifier)
                    .scheduleCampaign(campaign.id, scheduledDateTime);
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n.adminCommCampaignScheduledFor(DateFormat('MMM d, yyyy HH:mm').format(scheduledDateTime)),
                      ),
                    ),
                  );
                }
              },
              child: Text(context.l10n.adminCommActionSchedule),
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignDetails(Campaign campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getTypeIcon(campaign.type), color: _getTypeColor(campaign.type)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                campaign.title,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context.l10n.adminCommDetailType, campaign.type.toUpperCase()),
              _buildDetailRow(context.l10n.adminCommDetailStatus, campaign.status.toUpperCase()),
              _buildDetailRow(context.l10n.adminCommDetailCreated, _formatDate(campaign.createdAt)),
              if (campaign.scheduledAt != null)
                _buildDetailRow(context.l10n.adminCommDetailScheduled, DateFormat('MMM d, yyyy HH:mm').format(campaign.scheduledAt!)),
              if (campaign.sentAt != null)
                _buildDetailRow(context.l10n.adminCommDetailSent, DateFormat('MMM d, yyyy HH:mm').format(campaign.sentAt!)),
              const Divider(height: 24),
              Text('${context.l10n.adminCommDetailMessage}:', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(campaign.message ?? context.l10n.adminCommNoMessageContent),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(context.l10n.adminCommDetailRecipients, '${campaign.recipientCount ?? 0}'),
                  _buildStatItem(context.l10n.adminCommDetailDelivered, '${campaign.deliveredCount ?? 0}'),
                  _buildStatItem(context.l10n.adminCommDetailOpened, '${campaign.openedCount ?? 0}'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.adminCommClose),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _showCreateCampaignDialog({Campaign? duplicateFrom}) {
    final titleController = TextEditingController(text: duplicateFrom?.title ?? '');
    final messageController = TextEditingController(text: duplicateFrom?.message ?? '');
    String selectedType = duplicateFrom?.type ?? 'email';
    List<String> selectedRoles = List.from(duplicateFrom?.targetRoles ?? ['student']);
    bool sendNow = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.campaign, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(duplicateFrom != null ? context.l10n.adminCommDuplicateCampaignDialogTitle : context.l10n.adminCommCreateCampaignDialogTitle),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Campaign Title
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: context.l10n.adminCommCampaignTitleLabel,
                      hintText: context.l10n.adminCommCampaignTitleHint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Campaign Type
                  const Text('Campaign Type', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildTypeOption('email', 'Email', Icons.email, selectedType, (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeOption('push', 'Push', Icons.notifications, selectedType, (type) {
                        setDialogState(() => selectedType = type);
                      }),
                      _buildTypeOption('in_app', 'In-App', Icons.announcement, selectedType, (type) {
                        setDialogState(() => selectedType = type);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Target Audience
                  const Text('Target Audience', style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['student', 'parent', 'counselor', 'recommender'].map((role) {
                      final isSelected = selectedRoles.contains(role);
                      return FilterChip(
                        label: Text(role[0].toUpperCase() + role.substring(1)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setDialogState(() {
                            if (selected) {
                              selectedRoles.add(role);
                            } else {
                              selectedRoles.remove(role);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Message Content
                  TextField(
                    controller: messageController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Message Content',
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Send Now Option
                  CheckboxListTile(
                    title: const Text('Send immediately after creation'),
                    value: sendNow,
                    onChanged: (value) {
                      setDialogState(() => sendNow = value ?? false);
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a campaign title')),
                  );
                  return;
                }
                if (messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a message')),
                  );
                  return;
                }
                if (selectedRoles.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select at least one target role')),
                  );
                  return;
                }

                Navigator.pop(context);

                bool success;
                if (sendNow) {
                  success = await ref
                      .read(adminCommunicationsProvider.notifier)
                      .sendAnnouncement(
                        title: titleController.text,
                        message: messageController.text,
                        targetRoles: selectedRoles,
                        type: selectedType,
                      );
                } else {
                  final campaign = Campaign(
                    id: '',
                    title: titleController.text,
                    type: selectedType,
                    status: 'draft',
                    message: messageController.text,
                    targetRoles: selectedRoles,
                    createdAt: DateTime.now(),
                  );
                  success = await ref
                      .read(adminCommunicationsProvider.notifier)
                      .createCampaign(campaign);
                }

                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        sendNow ? 'Campaign sent successfully!' : 'Campaign created as draft',
                      ),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: Text(sendNow ? 'Create & Send' : 'Create Draft'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    String type,
    String label,
    IconData icon,
    String selectedType,
    Function(String) onSelect,
  ) {
    final isSelected = type == selectedType;
    return InkWell(
      onTap: () => onSelect(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
