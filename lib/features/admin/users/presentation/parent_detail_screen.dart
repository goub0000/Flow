// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/logo_avatar.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Parent Detail Screen - View and manage parent details
///
/// Features:
/// - View comprehensive parent information
/// - 6 tab views: Overview, Children, Applications, Documents, Payments, Activity
/// - Edit parent profile
/// - Suspend/activate parent account
/// - Delete parent account (with confirmation)
class ParentDetailScreen extends ConsumerStatefulWidget {
  final String parentId;

  const ParentDetailScreen({
    super.key,
    required this.parentId,
  });

  @override
  ConsumerState<ParentDetailScreen> createState() =>
      _ParentDetailScreenState();
}

class _ParentDetailScreenState extends ConsumerState<ParentDetailScreen>
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
    // Get parent from provider
    final parents = ref.watch(adminParentsProvider);
    final parent = parents.firstWhere(
      (user) => user.id == widget.parentId,
      orElse: () => parents.first,
    );

    // Content is wrapped by AdminShell via ShellRoute
    return Column(
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
                  child: _buildProfileSidebar(parent),
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
                    child: _buildTabbedContent(parent),
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => context.go('/admin/users/parents'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.adminParentDetailBackToParents),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSidebar(dynamic parent) {
    final name = parent.displayName ?? 'Unknown Parent';
    final email = parent.email;
    final parentId = 'PAR${parent.id.substring(0, 6).toUpperCase()}';
    final status = parent.metadata?['isActive'] == true ? 'active' : 'inactive';
    final children = 1 + (parent.id.hashCode % 3);
    final applications = children * (2 + (parent.id.hashCode % 3));

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Parent Avatar
            LogoAvatar.user(
              photoUrl: parent.photoUrl,
              initials: _getInitials(name),
              size: 96,
            ),
            const SizedBox(height: 16),

            // Parent Name
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
                  _buildStatRow(context.l10n.adminParentDetailParentId, parentId),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminParentDetailChildren, '$children'),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminParentDetailApplications, '$applications'),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminParentDetailMessages, '${12 + (parent.id.hashCode % 20)}'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(parent, status),
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
        label = context.l10n.adminParentDetailStatusActive;
        icon = Icons.check_circle;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = context.l10n.adminParentDetailStatusInactive;
        icon = Icons.cancel;
        break;
      case 'suspended':
        color = AppColors.error;
        label = context.l10n.adminParentDetailStatusSuspended;
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

  Widget _buildActionButtons(dynamic parent, String status) {
    return Column(
      children: [
        // Edit Button
        PermissionGuard(
          permission: AdminPermission.editUsers,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/admin/users/parents/${widget.parentId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: Text(context.l10n.adminParentDetailEditParent),
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
            label: Text(context.l10n.adminParentDetailSendMessage),
          ),
        ),
        const SizedBox(height: 12),

        // Suspend/Activate Button
        PermissionGuard(
          permission: AdminPermission.suspendUsers,
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSuspendDialog(parent, status),
              icon: Icon(
                status == 'active' ? Icons.block : Icons.check_circle,
                size: 18,
              ),
              label: Text(status == 'active' ? context.l10n.adminParentDetailSuspendAccount : context.l10n.adminParentDetailActivateAccount),
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
              onPressed: () => _showDeleteDialog(parent),
              icon: const Icon(Icons.delete, size: 18),
              label: Text(context.l10n.adminParentDetailDeleteParent),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabbedContent(dynamic parent) {
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
            tabs: [
              Tab(text: context.l10n.adminParentDetailTabOverview),
              Tab(text: context.l10n.adminParentDetailTabChildren),
              Tab(text: context.l10n.adminParentDetailTabApplications),
              Tab(text: context.l10n.adminParentDetailTabDocuments),
              Tab(text: context.l10n.adminParentDetailTabPayments),
              Tab(text: context.l10n.adminParentDetailTabActivity),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(parent),
              _buildChildrenTab(parent),
              _buildApplicationsTab(parent),
              _buildDocumentsTab(parent),
              _buildPaymentsTab(parent),
              _buildActivityTab(parent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(dynamic parent) {
    final name = parent.displayName ?? 'Unknown Parent';
    final email = parent.email;
    final joinedDate = _formatDate(parent.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Information
          _buildInfoSection(
            context.l10n.adminParentDetailPersonalInfo,
            [
              _buildInfoRow(context.l10n.adminParentDetailFullName, name),
              _buildInfoRow(context.l10n.adminParentDetailEmail, email),
              _buildInfoRow(context.l10n.adminParentDetailPhone, '+254 712 345 678'),
              _buildInfoRow(context.l10n.adminParentDetailLocation, 'Nairobi, Kenya'),
              _buildInfoRow(context.l10n.adminParentDetailOccupation, context.l10n.adminParentDetailBusinessOwner),
            ],
          ),
          const SizedBox(height: 24),

          // Account Information
          _buildInfoSection(
            context.l10n.adminParentDetailAccountInfo,
            [
              _buildInfoRow(context.l10n.adminParentDetailAccountCreated, joinedDate),
              _buildInfoRow(context.l10n.adminParentDetailLastLogin, context.l10n.adminParentDetailHoursAgo),
              _buildInfoRow(context.l10n.adminParentDetailEmailVerified, context.l10n.adminParentDetailYes),
              _buildInfoRow(context.l10n.adminParentDetailPhoneVerified, context.l10n.adminParentDetailYes),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChildrenTab(dynamic parent) {
    // Mock children data
    final children = _getMockChildren(parent.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.adminParentDetailChildrenCount(children.length),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Link child account
                },
                icon: const Icon(Icons.person_add, size: 18),
                label: Text(context.l10n.adminParentDetailLinkChild),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Children List
          ...children.map((child) => _buildChildCard(child)),
        ],
      ),
    );
  }

  Widget _buildChildCard(Map<String, dynamic> child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          LogoAvatar.user(
            photoUrl: null, // TODO: Add child photo
            initials: child['initials'],
            size: 48,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${child['grade']} • ${child['school']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.school, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${child['courses']} courses',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.description, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${child['applications']} applications',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to child detail
            },
            icon: const Icon(Icons.arrow_forward),
            tooltip: context.l10n.adminParentDetailViewDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab(dynamic parent) {
    // Mock applications from all children
    final applications = _getMockApplications(parent.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminParentDetailApplicationsFromChildren(applications.length),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Applications List
          ...applications.map((app) => _buildApplicationCard(app)),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(Map<String, dynamic> app) {
    Color statusColor;
    switch (app['status']) {
      case 'accepted':
        statusColor = AppColors.success;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        break;
      case 'rejected':
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
                      app['program'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app['institution'],
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
                  app['status'],
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
          Text(
            'Applied by: ${app['child']}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Submitted: ${app['date']}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(dynamic parent) {
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
              Text(
                context.l10n.adminParentDetailDocuments,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Upload document
                },
                icon: const Icon(Icons.upload, size: 18),
                label: Text(context.l10n.adminParentDetailUpload),
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
              _getDocumentIcon(doc['type']),
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
                tooltip: context.l10n.adminParentDetailView,
              ),
              IconButton(
                onPressed: () {
                  // TODO: Download document
                },
                icon: const Icon(Icons.download, size: 20),
                tooltip: context.l10n.adminParentDetailDownload,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab(dynamic parent) {
    // Mock payment data
    final payments = _getMockPayments(parent.id);
    final totalPaid = payments.fold<double>(
      0,
      (sum, payment) => sum + payment['amount'],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminParentDetailPaymentSummary,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context.l10n.adminParentDetailTotalPaid,
                  '\$${totalPaid.toStringAsFixed(2)}',
                  Icons.payments,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context.l10n.adminParentDetailTransactions,
                  '${payments.length}',
                  Icons.receipt,
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment History
          Text(
            context.l10n.adminParentDetailPaymentHistory,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          ...payments.map((payment) => _buildPaymentCard(payment)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
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
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['description'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment['date'],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${payment['amount'].toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(dynamic parent) {
    // Mock activity data
    final activities = _getMockActivities();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminParentDetailActivityTimeline,
            style: const TextStyle(
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
  void _showSuspendDialog(dynamic parent, String status) {
    final isActive = status == 'active';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isActive ? context.l10n.adminParentDetailSuspendTitle : context.l10n.adminParentDetailActivateTitle),
        content: Text(
          isActive
              ? context.l10n.adminParentDetailSuspendMessage(parent.displayName ?? '')
              : context.l10n.adminParentDetailActivateMessage(parent.displayName ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.adminParentDetailCancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call suspend/activate API
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? context.l10n.adminParentDetailSuspendSuccess
                        : context.l10n.adminParentDetailActivateSuccess,
                  ),
                ),
              );
            },
            child: Text(isActive ? context.l10n.adminParentDetailSuspend : context.l10n.adminParentDetailActivate),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic parent) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminParentDetailDeleteTitle),
        content: Text(
          context.l10n.adminParentDetailDeleteMessage(parent.displayName ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.adminParentDetailCancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call delete API
              Navigator.pop(dialogContext);
              context.go('/admin/users/parents');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.adminParentDetailDeleteSuccess)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.adminParentDetailDelete),
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

  List<Map<String, dynamic>> _getMockChildren(String parentId) {
    return [
      {
        'name': 'Sarah Mwangi',
        'initials': 'SM',
        'grade': 'Grade 11',
        'school': 'Nairobi High School',
        'courses': 6,
        'applications': 3,
      },
      {
        'name': 'James Mwangi',
        'initials': 'JM',
        'grade': 'Grade 9',
        'school': 'Nairobi High School',
        'courses': 5,
        'applications': 0,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockApplications(String parentId) {
    return [
      {
        'program': 'Computer Science',
        'institution': 'University of Nairobi',
        'child': 'Sarah Mwangi',
        'status': 'pending',
        'date': '2 weeks ago',
      },
      {
        'program': 'Business Administration',
        'institution': 'Strathmore University',
        'child': 'Sarah Mwangi',
        'status': 'accepted',
        'date': '1 month ago',
      },
      {
        'program': 'Medicine',
        'institution': 'Kenyatta University',
        'child': 'Sarah Mwangi',
        'status': 'rejected',
        'date': '2 months ago',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDocuments() {
    return [
      {
        'name': 'ID Document',
        'type': 'pdf',
        'date': '3 months ago',
        'size': '1.2 MB',
      },
      {
        'name': 'Proof of Residence',
        'type': 'pdf',
        'date': '3 months ago',
        'size': '890 KB',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockPayments(String parentId) {
    return [
      {
        'description': 'Application Fee - Computer Science',
        'amount': 50.0,
        'date': '2 weeks ago',
      },
      {
        'description': 'Application Fee - Business Administration',
        'amount': 50.0,
        'date': '1 month ago',
      },
      {
        'description': 'Course Registration - Advanced Math',
        'amount': 120.0,
        'date': '2 months ago',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'type': 'payment',
        'title': 'Payment Received',
        'description': 'Application fee payment processed',
        'time': '2 hours ago',
      },
      {
        'type': 'application',
        'title': 'New Application',
        'description': 'Sarah applied to Computer Science program',
        'time': '2 weeks ago',
      },
      {
        'type': 'child',
        'title': 'Child Linked',
        'description': 'James Mwangi linked to parent account',
        'time': '3 months ago',
      },
      {
        'type': 'account',
        'title': 'Account Created',
        'description': 'Parent account registered',
        'time': '6 months ago',
      },
    ];
  }

  IconData _getDocumentIcon(String type) {
    switch (type) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'doc':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'payment':
        return Icons.payments;
      case 'application':
        return Icons.description;
      case 'child':
        return Icons.person_add;
      case 'account':
        return Icons.account_circle;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'payment':
        return AppColors.success;
      case 'application':
        return AppColors.primary;
      case 'child':
        return AppColors.secondary;
      case 'account':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
