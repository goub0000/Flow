import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';

/// Communications Hub Screen - Manage platform communications
///
/// Features:
/// - Send announcements to users
/// - Create and send email campaigns
/// - Send SMS messages
/// - Manage push notifications
/// - Message templates
/// - Campaign analytics
/// - Scheduled messages
/// - Audience segmentation
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch communications data from backend
    // - API endpoint: GET /api/admin/communications
    // - Support filtering by status, type, date
    // - Include campaign metrics and analytics

    return AdminShell(
      child: _buildContent(),
    );
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
                    'Communications Hub',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Manage announcements, campaigns, and user communications',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Templates button
              PermissionGuard(
                permission: AdminPermission.manageTemplates,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Navigate to templates screen
                  },
                  icon: const Icon(Icons.text_snippet, size: 20),
                  label: const Text('Templates'),
                ),
              ),
              const SizedBox(width: 12),
              // Create campaign button
              PermissionGuard(
                permission: AdminPermission.sendAnnouncements,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showCreateCampaignDialog();
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Campaign'),
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
          _buildTab('campaigns', 'Campaigns', Icons.campaign),
          _buildTab('announcements', 'Announcements', Icons.announcement),
          _buildTab('emails', 'Emails', Icons.email),
          _buildTab('sms', 'SMS', Icons.sms),
          _buildTab('push', 'Push Notifications', Icons.notifications),
          _buildTab('scheduled', 'Scheduled', Icons.schedule),
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
    switch (_selectedTab) {
      case 'campaigns':
        return _buildCampaignsTab();
      case 'announcements':
        return _buildAnnouncementsTab();
      case 'emails':
        return _buildEmailsTab();
      case 'sms':
        return _buildSMSTab();
      case 'push':
        return _buildPushNotificationsTab();
      case 'scheduled':
        return _buildScheduledTab();
      default:
        return _buildCampaignsTab();
    }
  }

  Widget _buildCampaignsTab() {
    return Column(
      children: [
        // Stats Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Campaigns',
                  '0',
                  'All campaigns',
                  Icons.campaign,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active',
                  '0',
                  'Running now',
                  Icons.play_circle,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Scheduled',
                  '0',
                  'Pending delivery',
                  Icons.schedule,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '0',
                  'Successfully sent',
                  Icons.check_circle,
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Search and Filters
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search campaigns...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Campaigns Data Table
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _buildCampaignsTable(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignsTable() {
    // TODO: Replace with actual data from backend
    final List<CampaignRowData> campaigns = [];

    return AdminDataTable<CampaignRowData>(
      columns: [
        DataTableColumn(
          label: 'Campaign Name',
          cellBuilder: (campaign) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                campaign.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                campaign.description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Type',
          cellBuilder: (campaign) => _buildTypeChip(campaign.type),
        ),
        DataTableColumn(
          label: 'Audience',
          cellBuilder: (campaign) => Text(
            campaign.audience,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        DataTableColumn(
          label: 'Recipients',
          cellBuilder: (campaign) => Text(
            campaign.recipients.toString(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataTableColumn(
          label: 'Sent/Delivered',
          cellBuilder: (campaign) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${campaign.sent} / ${campaign.delivered}',
                style: const TextStyle(fontSize: 13),
              ),
              Text(
                '${campaign.deliveryRate}% delivery',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (campaign) => _buildStatusChip(campaign.status),
        ),
        DataTableColumn(
          label: 'Scheduled',
          cellBuilder: (campaign) => Text(
            campaign.scheduledDate,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          sortable: true,
        ),
      ],
      data: campaigns,
      isLoading: false,
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        // TODO: Handle bulk actions
      },
      onRowTap: (campaign) {
        _showCampaignDetails(campaign);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.visibility,
          tooltip: 'View Details',
          onPressed: (campaign) {
            _showCampaignDetails(campaign);
          },
        ),
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit Campaign',
          onPressed: (campaign) {
            // TODO: Edit campaign
          },
        ),
        DataTableAction(
          icon: Icons.delete,
          tooltip: 'Delete',
          color: AppColors.error,
          onPressed: (campaign) {
            // TODO: Delete campaign
          },
        ),
      ],
    );
  }

  Widget _buildAnnouncementsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.announcement,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Announcements',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send platform-wide announcements to users',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          PermissionGuard(
            permission: AdminPermission.sendAnnouncements,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Create announcement
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Announcement'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.email,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Email Campaigns',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create and manage email campaigns',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          PermissionGuard(
            permission: AdminPermission.sendEmailCampaigns,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Create email campaign
              },
              icon: const Icon(Icons.add),
              label: const Text('New Email Campaign'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSMSTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sms,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'SMS Messages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send SMS notifications to users',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          PermissionGuard(
            permission: AdminPermission.sendSMS,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Create SMS campaign
              },
              icon: const Icon(Icons.add),
              label: const Text('Send SMS'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPushNotificationsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Push Notifications',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send push notifications to mobile apps',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          PermissionGuard(
            permission: AdminPermission.managePushNotifications,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Create push notification
              },
              icon: const Icon(Icons.add),
              label: const Text('Send Push Notification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduledTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Scheduled Messages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'View and manage scheduled communications',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 14,
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

  Widget _buildTypeChip(String type) {
    Color color;
    IconData icon;

    switch (type.toLowerCase()) {
      case 'email':
        color = AppColors.primary;
        icon = Icons.email;
        break;
      case 'sms':
        color = AppColors.success;
        icon = Icons.sms;
        break;
      case 'push':
        color = AppColors.warning;
        icon = Icons.notifications;
        break;
      case 'announcement':
        color = AppColors.error;
        icon = Icons.announcement;
        break;
      default:
        color = AppColors.textSecondary;
        icon = Icons.campaign;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'active':
      case 'sent':
        color = AppColors.success;
        label = status;
        break;
      case 'scheduled':
        color = AppColors.warning;
        label = status;
        break;
      case 'draft':
        color = AppColors.textSecondary;
        label = status;
        break;
      case 'failed':
        color = AppColors.error;
        label = status;
        break;
      default:
        color = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showCreateCampaignDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.campaign, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text('Create New Campaign'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select campaign type:'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Campaign'),
                subtitle: const Text('Send emails to users'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to email campaign creation
                },
              ),
              ListTile(
                leading: const Icon(Icons.sms),
                title: const Text('SMS Campaign'),
                subtitle: const Text('Send SMS messages'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to SMS campaign creation
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Push Notification'),
                subtitle: const Text('Send mobile push notifications'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to push notification creation
                },
              ),
              ListTile(
                leading: const Icon(Icons.announcement),
                title: const Text('Platform Announcement'),
                subtitle: const Text('In-app announcement'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to announcement creation
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCampaignDetails(CampaignRowData campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.campaign, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                campaign.name,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campaign details and analytics will be available with backend integration.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

/// Temporary data model for table rows
/// TODO: Replace with actual Campaign model from backend
class CampaignRowData {
  final String id;
  final String name;
  final String description;
  final String type;
  final String audience;
  final int recipients;
  final int sent;
  final int delivered;
  final int deliveryRate;
  final String status;
  final String scheduledDate;

  CampaignRowData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.audience,
    required this.recipients,
    required this.sent,
    required this.delivered,
    required this.deliveryRate,
    required this.status,
    required this.scheduledDate,
  });
}
