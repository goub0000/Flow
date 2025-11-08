import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Recommender Detail Screen - View and manage recommender details
///
/// Features:
/// - View comprehensive recommender information
/// - 6 tab views: Overview, Requests, Recommendations, Statistics, Documents, Activity
/// - Edit recommender profile
/// - Suspend/activate recommender account
/// - Delete recommender account (with confirmation)
class RecommenderDetailScreen extends ConsumerStatefulWidget {
  final String recommenderId;

  const RecommenderDetailScreen({
    super.key,
    required this.recommenderId,
  });

  @override
  ConsumerState<RecommenderDetailScreen> createState() =>
      _RecommenderDetailScreenState();
}

class _RecommenderDetailScreenState
    extends ConsumerState<RecommenderDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get recommender from provider
    final recommenders = ref.watch(adminRecommendersProvider);
    final recommender = recommenders.firstWhere(
      (user) => user.id == widget.recommenderId,
      orElse: () => recommenders.first,
    );

    return AdminShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb Navigation
          _buildBreadcrumb(),
          const SizedBox(height: 24),

          // Main Content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Sidebar - Profile Summary
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: _buildProfileSidebar(recommender),
                ),
                const SizedBox(width: 24),

                // Right Content - Tabbed Views
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _buildTabbedContent(recommender),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => context.go('/admin/users/recommenders'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to Recommenders'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSidebar(dynamic recommender) {
    final name = recommender.displayName ?? 'Unknown Recommender';
    final email = recommender.email;
    final recommenderId = 'REC${recommender.id.substring(0, 6).toUpperCase()}';
    final status = recommender.metadata?['isActive'] == true ? 'active' : 'inactive';
    final type = _getMockRecommenderType(recommender.id.hashCode % 3);
    final organization = _getMockOrganization(recommender.id.hashCode % 5);
    final requestsCount = 10 + (recommender.id.hashCode % 40);
    final completedCount = (requestsCount * 0.8).floor();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Recommender Avatar
            LogoAvatar.user(
              photoUrl: recommender.photoUrl,
              initials: _getInitials(name),
              size: 96,
            ),
            const SizedBox(height: 16),

            // Recommender Name
            Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              email,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Status Badge
            _buildStatusBadge(status),
            const SizedBox(height: 24),

            // Quick Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildStatRow('Recommender ID', recommenderId),
                  const Divider(height: 16),
                  _buildStatRow('Type', type),
                  const Divider(height: 16),
                  _buildStatRow('Organization', organization),
                  const Divider(height: 16),
                  _buildStatRow('Requests', '$requestsCount'),
                  const Divider(height: 16),
                  _buildStatRow('Completed', '$completedCount'),
                  const Divider(height: 16),
                  _buildStatRow('Completion Rate', '${((completedCount / requestsCount) * 100).toInt()}%'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(recommender, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status) {
      case 'active':
        color = AppColors.success;
        label = 'Active';
        icon = Icons.check_circle;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = 'Inactive';
        icon = Icons.cancel;
        break;
      case 'suspended':
        color = AppColors.error;
        label = 'Suspended';
        icon = Icons.block;
        break;
      default:
        color = AppColors.primary;
        label = status;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
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

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(dynamic recommender, String status) {
    return Column(
      children: [
        // Edit Button
        PermissionGuard(
          permission: AdminPermission.editUsers,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/admin/users/recommenders/${widget.recommenderId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Recommender'),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Message Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Open messaging
            },
            icon: const Icon(Icons.message, size: 18),
            label: const Text('Send Message'),
          ),
        ),
        const SizedBox(height: 12),

        // Suspend/Activate Button
        PermissionGuard(
          permission: AdminPermission.suspendUsers,
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSuspendDialog(recommender, status),
              icon: Icon(
                status == 'active' ? Icons.block : Icons.check_circle,
                size: 18,
              ),
              label: Text(status == 'active' ? 'Suspend Account' : 'Activate Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    status == 'active' ? AppColors.error : AppColors.success,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Delete Button
        PermissionGuard(
          permission: AdminPermission.deleteUsers,
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showDeleteDialog(recommender),
              icon: const Icon(Icons.delete, size: 18),
              label: const Text('Delete Recommender'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabbedContent(dynamic recommender) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.border),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Requests'),
              Tab(text: 'Recommendations'),
              Tab(text: 'Statistics'),
              Tab(text: 'Documents'),
              Tab(text: 'Activity'),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(recommender),
              _buildRequestsTab(recommender),
              _buildRecommendationsTab(recommender),
              _buildStatisticsTab(recommender),
              _buildDocumentsTab(recommender),
              _buildActivityTab(recommender),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(dynamic recommender) {
    final name = recommender.displayName ?? 'Unknown Recommender';
    final email = recommender.email;
    final type = _getMockRecommenderType(recommender.id.hashCode % 3);
    final organization = _getMockOrganization(recommender.id.hashCode % 5);
    final joinedDate = _formatDate(recommender.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Professional Information
          _buildInfoSection(
            'Professional Information',
            [
              _buildInfoRow('Full Name', name),
              _buildInfoRow('Email', email),
              _buildInfoRow('Type', type),
              _buildInfoRow('Organization', organization),
              _buildInfoRow('Position', 'Senior ${type.toLowerCase()}'),
              _buildInfoRow('Years at Organization', '5 years'),
            ],
          ),
          const SizedBox(height: 24),

          // Contact Information
          _buildInfoSection(
            'Contact Information',
            [
              _buildInfoRow('Phone', '+254 712 345 678'),
              _buildInfoRow('Office', 'Building B, Room 305'),
              _buildInfoRow('Preferred Contact', 'Email'),
            ],
          ),
          const SizedBox(height: 24),

          // Account Information
          _buildInfoSection(
            'Account Information',
            [
              _buildInfoRow('Account Created', joinedDate),
              _buildInfoRow('Last Login', '1 day ago'),
              _buildInfoRow('Email Verified', 'Yes'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsTab(dynamic recommender) {
    // Mock recommendation requests
    final requests = _getMockRequests(recommender.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendation Requests (${requests.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Requests List
          ...requests.map((request) => _buildRequestCard(request)),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    Color statusColor;
    switch (request['status']) {
      case 'completed':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'overdue':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['student'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request['program'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  request['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.school, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                request['institution'],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Due: ${request['dueDate']}',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab(dynamic recommender) {
    // Mock completed recommendations
    final recommendations = _getMockRecommendations(recommender.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Completed Recommendations (${recommendations.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Recommendations List
          ...recommendations.map((rec) => _buildRecommendationCard(rec)),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> rec) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec['student'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rec['program'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 14, color: AppColors.success),
                    const SizedBox(width: 4),
                    Text(
                      'Submitted',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Submitted: ${rec['submittedDate']}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab(dynamic recommender) {
    final requestsCount = 10 + (recommender.id.hashCode % 40);
    final completedCount = (requestsCount * 0.8).floor();
    final pendingCount = requestsCount - completedCount;
    final avgResponseTime = 3 + (recommender.id.hashCode % 5);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Requests',
                  '$requestsCount',
                  Icons.mail,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '$completedCount',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Pending',
                  '$pendingCount',
                  Icons.pending,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Avg Response Time',
                  '$avgResponseTime days',
                  Icons.access_time,
                  AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Chart Placeholder
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recommendation Trends',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Charts will be implemented with fl_chart',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
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
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(dynamic recommender) {
    // Mock documents
    final documents = _getMockDocuments();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Documents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Upload document
                },
                icon: const Icon(Icons.upload, size: 18),
                label: const Text('Upload'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Documents List
          ...documents.map((doc) => _buildDocumentCard(doc)),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Uploaded ${doc['date']} • ${doc['size']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // TODO: View document
                },
                icon: const Icon(Icons.visibility, size: 20),
                tooltip: 'View',
              ),
              IconButton(
                onPressed: () {
                  // TODO: Download document
                },
                icon: const Icon(Icons.download, size: 20),
                tooltip: 'Download',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(dynamic recommender) {
    // Mock activity data
    final activities = _getMockActivities();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity Timeline',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Activity Timeline
          ...activities.map((activity) => _buildActivityItem(activity)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Dot
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getActivityColor(activity['type']).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getActivityIcon(activity['type']),
              color: _getActivityColor(activity['type']),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Activity Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['description'],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: rows,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Actions
  void _showSuspendDialog(dynamic recommender, String status) {
    final isActive = status == 'active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Suspend Recommender Account' : 'Activate Recommender Account'),
        content: Text(
          isActive
              ? 'Are you sure you want to suspend ${recommender.displayName}\'s account? They will no longer be able to submit recommendations.'
              : 'Are you sure you want to activate ${recommender.displayName}\'s account? They will be able to submit recommendations again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call suspend/activate API
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? 'Recommender account suspended successfully'
                        : 'Recommender account activated successfully',
                  ),
                ),
              );
            },
            child: Text(isActive ? 'Suspend' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic recommender) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recommender Account'),
        content: Text(
          'Are you sure you want to delete ${recommender.displayName}\'s account? This action cannot be undone and will remove all recommendation history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call delete API
              Navigator.pop(context);
              context.go('/admin/users/recommenders');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Recommender account deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} months ago';
    return '${(diff.inDays / 365).floor()} years ago';
  }

  String _getMockRecommenderType(int index) {
    final types = ['Teacher', 'Professor', 'Employer'];
    return types[index % types.length];
  }

  String _getMockOrganization(int index) {
    final organizations = [
      'Nairobi High School',
      'University of Lagos',
      'Cape Town Tech Company',
      'Accra Business Institute',
      'Cairo Medical Center',
    ];
    return organizations[index % organizations.length];
  }

  List<Map<String, dynamic>> _getMockRequests(String recommenderId) {
    return [
      {
        'student': 'Amina Hassan',
        'program': 'Computer Science',
        'institution': 'University of Nairobi',
        'status': 'pending',
        'dueDate': 'Jan 20, 2025',
      },
      {
        'student': 'Kwame Osei',
        'program': 'Business Administration',
        'institution': 'Strathmore University',
        'status': 'pending',
        'dueDate': 'Jan 25, 2025',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockRecommendations(String recommenderId) {
    return [
      {
        'student': 'Fatima Diallo',
        'program': 'Medicine',
        'institution': 'Kenyatta University',
        'submittedDate': '2 weeks ago',
      },
      {
        'student': 'Thabo Mokoena',
        'program': 'Engineering',
        'institution': 'University of Cape Town',
        'submittedDate': '1 month ago',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDocuments() {
    return [
      {
        'name': 'Employment Verification',
        'date': '6 months ago',
        'size': '1.2 MB',
      },
      {
        'name': 'Professional Certificate',
        'date': '1 year ago',
        'size': '2.5 MB',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'type': 'recommendation',
        'title': 'Recommendation Submitted',
        'description': 'Submitted recommendation for Fatima Diallo',
        'time': '2 weeks ago',
      },
      {
        'type': 'request',
        'title': 'New Request Received',
        'description': 'Recommendation request from Amina Hassan',
        'time': '3 days ago',
      },
      {
        'type': 'document',
        'title': 'Document Uploaded',
        'description': 'Employment Verification uploaded',
        'time': '6 months ago',
      },
      {
        'type': 'account',
        'title': 'Account Created',
        'description': 'Recommender account registered',
        'time': '2 years ago',
      },
    ];
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'recommendation':
        return Icons.assignment_turned_in;
      case 'request':
        return Icons.mail;
      case 'document':
        return Icons.upload_file;
      case 'account':
        return Icons.account_circle;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'recommendation':
        return AppColors.success;
      case 'request':
        return AppColors.primary;
      case 'document':
        return AppColors.warning;
      case 'account':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
