import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Institution Detail Screen - View and manage institution details
///
/// Features:
/// - View comprehensive institution information
/// - 6 tab views: Overview, Programs, Applicants, Statistics, Documents, Activity
/// - Verification actions (approve/reject)
/// - Edit institution profile
/// - Deactivate/activate institution
/// - Delete institution (with confirmation)
class InstitutionDetailScreen extends ConsumerStatefulWidget {
  final String institutionId;

  const InstitutionDetailScreen({
    super.key,
    required this.institutionId,
  });

  @override
  ConsumerState<InstitutionDetailScreen> createState() =>
      _InstitutionDetailScreenState();
}

class _InstitutionDetailScreenState
    extends ConsumerState<InstitutionDetailScreen>
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
    // Get institution from provider
    final institutions = ref.watch(adminInstitutionsProvider);
    final institution = institutions.firstWhere(
      (user) => user.id == widget.institutionId,
      orElse: () => institutions.first,
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
                  child: _buildProfileSidebar(institution),
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
                    child: _buildTabbedContent(institution),
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
            onPressed: () => context.go('/admin/users/institutions'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to Institutions'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSidebar(dynamic institution) {
    final name = institution.displayName ?? 'Unknown Institution';
    final email = institution.email;
    final institutionId = 'INS${institution.id.substring(0, 6).toUpperCase()}';
    final type = _getMockInstitutionType(institution.id.hashCode % 4);
    final location = _getMockLocation(institution.id.hashCode % 6);
    final status = _getMockVerificationStatus(institution.id.hashCode % 3);
    final programs = 5 + (institution.id.hashCode % 20);
    final students = 100 + (institution.id.hashCode % 900);
    final applicants = 50 + (institution.id.hashCode % 200);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Institution Icon/Logo
            LogoAvatar.institution(
              logoUrl: null, // TODO: Add logoUrl field to institution model
              name: name,
              size: 96,
            ),
            const SizedBox(height: 16),

            // Institution Name
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
                  _buildStatRow('Institution ID', institutionId),
                  const Divider(height: 16),
                  _buildStatRow('Type', type),
                  const Divider(height: 16),
                  _buildStatRow('Location', location),
                  const Divider(height: 16),
                  _buildStatRow('Programs', '$programs'),
                  const Divider(height: 16),
                  _buildStatRow('Students', '$students'),
                  const Divider(height: 16),
                  _buildStatRow('Applicants', '$applicants'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(institution, status),
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
      case 'verified':
        color = AppColors.success;
        label = 'Verified';
        icon = Icons.verified;
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending Verification';
        icon = Icons.pending;
        break;
      case 'rejected':
        color = AppColors.error;
        label = 'Rejected';
        icon = Icons.cancel;
        break;
      default:
        color = AppColors.primary;
        label = 'Active';
        icon = Icons.check_circle;
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

  Widget _buildActionButtons(dynamic institution, String status) {
    return Column(
      children: [
        // Edit Button
        PermissionGuard(
          permission: AdminPermission.editInstitutions,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/admin/users/institutions/${widget.institutionId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: const Text('Edit Institution'),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Verification Actions (only show if pending)
        if (status == 'pending') ...[
          Row(
            children: [
              Expanded(
                child: PermissionGuard(
                  permission: AdminPermission.verifyInstitutions,
                  child: ElevatedButton.icon(
                    onPressed: () => _showApproveDialog(institution),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PermissionGuard(
                  permission: AdminPermission.verifyInstitutions,
                  child: OutlinedButton.icon(
                    onPressed: () => _showRejectDialog(institution),
                    icon: const Icon(Icons.cancel, size: 18),
                    label: const Text('Reject'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],

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

        // Deactivate/Activate Button
        PermissionGuard(
          permission: AdminPermission.suspendUsers,
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSuspendDialog(institution),
              icon: Icon(
                status == 'active' ? Icons.block : Icons.check_circle,
                size: 18,
              ),
              label: Text(status == 'active' ? 'Deactivate' : 'Activate'),
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
              onPressed: () => _showDeleteDialog(institution),
              icon: const Icon(Icons.delete, size: 18),
              label: const Text('Delete Institution'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabbedContent(dynamic institution) {
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
              Tab(text: 'Programs'),
              Tab(text: 'Applicants'),
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
              _buildOverviewTab(institution),
              _buildProgramsTab(institution),
              _buildApplicantsTab(institution),
              _buildStatisticsTab(institution),
              _buildDocumentsTab(institution),
              _buildActivityTab(institution),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(dynamic institution) {
    final name = institution.displayName ?? 'Unknown Institution';
    final email = institution.email;
    final type = _getMockInstitutionType(institution.id.hashCode % 4);
    final location = _getMockLocation(institution.id.hashCode % 6);
    final joinedDate = _formatDate(institution.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Institution Information
          _buildInfoSection(
            'Institution Information',
            [
              _buildInfoRow('Full Name', name),
              _buildInfoRow('Institution Type', type),
              _buildInfoRow('Email', email),
              _buildInfoRow('Location', location),
              _buildInfoRow('Website', 'www.example.edu'),
              _buildInfoRow('Phone', '+254 712 345 678'),
            ],
          ),
          const SizedBox(height: 24),

          // Contact Person
          _buildInfoSection(
            'Contact Person',
            [
              _buildInfoRow('Name', 'Dr. John Kamau'),
              _buildInfoRow('Position', 'Admissions Director'),
              _buildInfoRow('Email', 'admissions@example.edu'),
              _buildInfoRow('Phone', '+254 712 345 679'),
            ],
          ),
          const SizedBox(height: 24),

          // Account Information
          _buildInfoSection(
            'Account Information',
            [
              _buildInfoRow('Account Created', joinedDate),
              _buildInfoRow('Last Updated', '2 weeks ago'),
              _buildInfoRow('Last Login', '3 hours ago'),
              _buildInfoRow('Verification Date', '1 month ago'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgramsTab(dynamic institution) {
    // Mock programs data
    final programs = _getMockPrograms(institution.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Programs (${programs.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add new program
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Program'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Programs List
          ...programs.map((program) => _buildProgramCard(program)),
        ],
      ),
    );
  }

  Widget _buildProgramCard(Map<String, dynamic> program) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                      program['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program['degree'],
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
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
                child: Text(
                  program['status'],
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${program['duration']} years',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.people, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${program['applicants']} applicants',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '\$${program['tuition']}/year',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantsTab(dynamic institution) {
    // Mock applicants data
    final applicants = _getMockApplicants(institution.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Applicants (${applicants.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Applicants List
          ...applicants.map((applicant) => _buildApplicantCard(applicant)),
        ],
      ),
    );
  }

  Widget _buildApplicantCard(Map<String, dynamic> applicant) {
    Color statusColor;
    switch (applicant['status']) {
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
      child: Row(
        children: [
          LogoAvatar.user(
            photoUrl: null, // TODO: Add applicant photo
            initials: applicant['initials'],
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  applicant['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  applicant['program'],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  applicant['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                applicant['date'],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab(dynamic institution) {
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
                  'Total Applicants',
                  '1,234',
                  Icons.people,
                  AppColors.primary,
                  '+12% from last month',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Acceptance Rate',
                  '45%',
                  Icons.check_circle,
                  AppColors.success,
                  'Above average',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Active Programs',
                  '24',
                  Icons.school,
                  AppColors.secondary,
                  '3 new this year',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Enrolled Students',
                  '856',
                  Icons.people_outline,
                  AppColors.warning,
                  '+8% from last year',
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
                    Icons.insert_chart,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Application Trends Chart',
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
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

  Widget _buildDocumentsTab(dynamic institution) {
    // Mock documents data
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
                'Verification Documents',
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

  Widget _buildActivityTab(dynamic institution) {
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
  void _showApproveDialog(dynamic institution) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Institution'),
        content: Text(
          'Are you sure you want to approve ${institution.displayName}? This will activate their account and allow them to start accepting applications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call approve API
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Institution approved successfully')),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(dynamic institution) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Institution'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure you want to reject ${institution.displayName}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for rejection',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call reject API
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Institution rejected')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(dynamic institution) {
    final isActive = institution.metadata?['isActive'] ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Deactivate Institution' : 'Activate Institution'),
        content: Text(
          isActive
              ? 'Are you sure you want to deactivate ${institution.displayName}? They will no longer be able to accept applications.'
              : 'Are you sure you want to activate ${institution.displayName}? They will be able to accept applications again.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call suspend/activate API
              // ref.read(adminInstitutionsProvider.notifier).toggleActive(institution.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? 'Institution deactivated successfully'
                        : 'Institution activated successfully',
                  ),
                ),
              );
            },
            child: Text(isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic institution) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Institution'),
        content: Text(
          'Are you sure you want to delete ${institution.displayName}? This action cannot be undone and will remove all associated data including programs, applications, and documents.',
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
              context.go('/admin/users/institutions');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Institution deleted successfully')),
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

  String _getMockInstitutionType(int index) {
    final types = ['University', 'College', 'Vocational School', 'Language School'];
    return types[index % types.length];
  }

  String _getMockLocation(int index) {
    final locations = [
      'Nairobi, Kenya',
      'Lagos, Nigeria',
      'Cape Town, South Africa',
      'Accra, Ghana',
      'Cairo, Egypt',
      'Dar es Salaam, Tanzania',
    ];
    return locations[index % locations.length];
  }

  String _getMockVerificationStatus(int index) {
    final statuses = ['verified', 'pending', 'active'];
    return statuses[index % statuses.length];
  }

  List<Map<String, dynamic>> _getMockPrograms(String institutionId) {
    return [
      {
        'name': 'Computer Science',
        'degree': 'Bachelor of Science',
        'duration': 4,
        'applicants': 156,
        'tuition': 8500,
        'status': 'Active',
      },
      {
        'name': 'Business Administration',
        'degree': 'Bachelor of Business Administration',
        'duration': 4,
        'applicants': 234,
        'tuition': 7500,
        'status': 'Active',
      },
      {
        'name': 'Mechanical Engineering',
        'degree': 'Bachelor of Engineering',
        'duration': 4,
        'applicants': 89,
        'tuition': 9200,
        'status': 'Active',
      },
      {
        'name': 'Medicine',
        'degree': 'Bachelor of Medicine and Surgery',
        'duration': 6,
        'applicants': 345,
        'tuition': 15000,
        'status': 'Active',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockApplicants(String institutionId) {
    return [
      {
        'name': 'Amina Hassan',
        'initials': 'AH',
        'program': 'Computer Science',
        'status': 'pending',
        'date': '2 days ago',
      },
      {
        'name': 'Kwame Osei',
        'initials': 'KO',
        'program': 'Business Administration',
        'status': 'accepted',
        'date': '5 days ago',
      },
      {
        'name': 'Fatima Diallo',
        'initials': 'FD',
        'program': 'Medicine',
        'status': 'pending',
        'date': '1 week ago',
      },
      {
        'name': 'Thabo Mokoena',
        'initials': 'TM',
        'program': 'Mechanical Engineering',
        'status': 'rejected',
        'date': '2 weeks ago',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDocuments() {
    return [
      {
        'name': 'Accreditation Certificate',
        'type': 'pdf',
        'date': '2 months ago',
        'size': '2.4 MB',
      },
      {
        'name': 'Business Registration',
        'type': 'pdf',
        'date': '2 months ago',
        'size': '1.8 MB',
      },
      {
        'name': 'Tax Clearance Certificate',
        'type': 'pdf',
        'date': '3 months ago',
        'size': '980 KB',
      },
      {
        'name': 'Campus Photos',
        'type': 'image',
        'date': '1 month ago',
        'size': '5.2 MB',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'type': 'verified',
        'title': 'Institution Verified',
        'description': 'Account was verified by Admin John Doe',
        'time': '2 hours ago',
      },
      {
        'type': 'program',
        'title': 'New Program Added',
        'description': 'Computer Science program was added',
        'time': '1 day ago',
      },
      {
        'type': 'applicant',
        'title': 'New Application Received',
        'description': 'Amina Hassan applied to Computer Science',
        'time': '2 days ago',
      },
      {
        'type': 'document',
        'title': 'Document Uploaded',
        'description': 'Accreditation Certificate uploaded',
        'time': '1 week ago',
      },
      {
        'type': 'account',
        'title': 'Account Created',
        'description': 'Institution registered on the platform',
        'time': '2 months ago',
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
      case 'verified':
        return Icons.verified;
      case 'program':
        return Icons.school;
      case 'applicant':
        return Icons.person_add;
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
      case 'verified':
        return AppColors.success;
      case 'program':
        return AppColors.primary;
      case 'applicant':
        return AppColors.secondary;
      case 'document':
        return AppColors.warning;
      case 'account':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }
}
