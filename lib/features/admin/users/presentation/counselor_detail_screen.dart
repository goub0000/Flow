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

/// Counselor Detail Screen - View and manage counselor details
///
/// Features:
/// - View comprehensive counselor information
/// - 6 tab views: Overview, Students, Sessions, Schedule, Documents, Activity
/// - Edit counselor profile
/// - Suspend/activate counselor account
/// - Delete counselor account (with confirmation)
class CounselorDetailScreen extends ConsumerStatefulWidget {
  final String counselorId;

  const CounselorDetailScreen({
    super.key,
    required this.counselorId,
  });

  @override
  ConsumerState<CounselorDetailScreen> createState() =>
      _CounselorDetailScreenState();
}

class _CounselorDetailScreenState extends ConsumerState<CounselorDetailScreen>
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
    // Get counselor from provider
    final counselors = ref.watch(adminCounselorsProvider);
    final counselor = counselors.firstWhere(
      (user) => user.id == widget.counselorId,
      orElse: () => counselors.first,
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
                  child: _buildProfileSidebar(counselor),
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
                    child: _buildTabbedContent(counselor),
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
            onPressed: () => context.go('/admin/users/counselors'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.adminCounselorDetailBackToCounselors),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSidebar(dynamic counselor) {
    final name = counselor.displayName ?? 'Unknown Counselor';
    final email = counselor.email;
    final counselorId = 'COU${counselor.id.substring(0, 6).toUpperCase()}';
    final status = counselor.metadata?['isActive'] == true ? 'active' : 'inactive';
    final specialty = _getMockSpecialty(counselor.id.hashCode % 5);
    final students = 10 + (counselor.id.hashCode % 40);
    final sessions = 50 + (counselor.id.hashCode % 200);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Counselor Avatar
            LogoAvatar.user(
              photoUrl: counselor.photoUrl,
              initials: _getInitials(name),
              size: 96,
            ),
            const SizedBox(height: 16),

            // Counselor Name
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
                  _buildStatRow(context.l10n.adminCounselorDetailCounselorId, counselorId),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminCounselorDetailSpecialty, specialty),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminCounselorDetailStudents, '$students'),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminCounselorDetailSessions, '$sessions'),
                  const Divider(height: 16),
                  _buildStatRow(context.l10n.adminCounselorDetailRating, '4.8 ⭐'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(counselor, status),
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
        label = context.l10n.adminCounselorDetailStatusActive;
        icon = Icons.check_circle;
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = context.l10n.adminCounselorDetailStatusInactive;
        icon = Icons.cancel;
        break;
      case 'suspended':
        color = AppColors.error;
        label = context.l10n.adminCounselorDetailStatusSuspended;
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

  Widget _buildActionButtons(dynamic counselor, String status) {
    return Column(
      children: [
        // Edit Button
        PermissionGuard(
          permission: AdminPermission.editUsers,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                context.go('/admin/users/counselors/${widget.counselorId}/edit');
              },
              icon: const Icon(Icons.edit, size: 18),
              label: Text(context.l10n.adminCounselorDetailEditCounselor),
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
            label: Text(context.l10n.adminCounselorDetailSendMessage),
          ),
        ),
        const SizedBox(height: 12),

        // Suspend/Activate Button
        PermissionGuard(
          permission: AdminPermission.suspendUsers,
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSuspendDialog(counselor, status),
              icon: Icon(
                status == 'active' ? Icons.block : Icons.check_circle,
                size: 18,
              ),
              label: Text(status == 'active' ? context.l10n.adminCounselorDetailSuspendAccount : context.l10n.adminCounselorDetailActivateAccount),
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
              onPressed: () => _showDeleteDialog(counselor),
              icon: const Icon(Icons.delete, size: 18),
              label: Text(context.l10n.adminCounselorDetailDeleteCounselor),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabbedContent(dynamic counselor) {
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
              Tab(text: context.l10n.adminCounselorDetailTabOverview),
              Tab(text: context.l10n.adminCounselorDetailTabStudents),
              Tab(text: context.l10n.adminCounselorDetailTabSessions),
              Tab(text: context.l10n.adminCounselorDetailTabSchedule),
              Tab(text: context.l10n.adminCounselorDetailTabDocuments),
              Tab(text: context.l10n.adminCounselorDetailTabActivity),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(counselor),
              _buildStudentsTab(counselor),
              _buildSessionsTab(counselor),
              _buildScheduleTab(counselor),
              _buildDocumentsTab(counselor),
              _buildActivityTab(counselor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab(dynamic counselor) {
    final name = counselor.displayName ?? 'Unknown Counselor';
    final email = counselor.email;
    final specialty = _getMockSpecialty(counselor.id.hashCode % 5);
    final joinedDate = _formatDate(counselor.createdAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Professional Information
          _buildInfoSection(
            context.l10n.adminCounselorDetailProfessionalInfo,
            [
              _buildInfoRow(context.l10n.adminCounselorDetailFullName, name),
              _buildInfoRow(context.l10n.adminCounselorDetailEmail, email),
              _buildInfoRow(context.l10n.adminCounselorDetailSpecialty, specialty),
              _buildInfoRow(context.l10n.adminCounselorDetailCredentials, 'M.A. Counseling Psychology'),
              _buildInfoRow(context.l10n.adminCounselorDetailLicenseNumber, 'LPC-${counselor.id.substring(0, 8).toUpperCase()}'),
              _buildInfoRow(context.l10n.adminCounselorDetailYearsExperience, context.l10n.adminCounselorDetailYearsValue),
            ],
          ),
          const SizedBox(height: 24),

          // Contact Information
          _buildInfoSection(
            context.l10n.adminCounselorDetailContactInfo,
            [
              _buildInfoRow(context.l10n.adminCounselorDetailPhone, '+254 712 345 678'),
              _buildInfoRow(context.l10n.adminCounselorDetailOfficeLocation, 'Building A, Room 203'),
              _buildInfoRow(context.l10n.adminCounselorDetailAvailability, 'Mon-Fri, 9AM-5PM'),
            ],
          ),
          const SizedBox(height: 24),

          // Account Information
          _buildInfoSection(
            context.l10n.adminCounselorDetailAccountInfo,
            [
              _buildInfoRow(context.l10n.adminCounselorDetailAccountCreated, joinedDate),
              _buildInfoRow(context.l10n.adminCounselorDetailLastLogin, context.l10n.adminCounselorDetailHoursAgo),
              _buildInfoRow(context.l10n.adminCounselorDetailEmailVerified, context.l10n.adminCounselorDetailYes),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab(dynamic counselor) {
    // Mock students data
    final students = _getMockStudents(counselor.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminCounselorDetailAssignedStudents(students.length),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Students List
          ...students.map((student) => _buildStudentCard(student)),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
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
            photoUrl: null, // TODO: Add student photo
            initials: student['initials'],
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  student['grade'],
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            context.l10n.adminCounselorDetailSessionsCount(student['sessions']),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {
              // TODO: Navigate to student detail
            },
            icon: const Icon(Icons.arrow_forward, size: 20),
            tooltip: context.l10n.adminCounselorDetailViewDetails,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsTab(dynamic counselor) {
    // Mock sessions data
    final sessions = _getMockSessions(counselor.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminCounselorDetailRecentSessions(sessions.length),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Sessions List
          ...sessions.map((session) => _buildSessionCard(session)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
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
                child: Text(
                  session['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSessionStatusColor(session['status']).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  session['status'],
                  style: TextStyle(
                    color: _getSessionStatusColor(session['status']),
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
              Icon(Icons.person, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                session['student'],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.schedule, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                session['date'],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                session['duration'],
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

  Widget _buildScheduleTab(dynamic counselor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminCounselorDetailWeeklySchedule,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Calendar Placeholder
          Container(
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.adminCounselorDetailScheduleCalendar,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.adminCounselorDetailCalendarComingSoon,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(dynamic counselor) {
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
                context.l10n.adminCounselorDetailProfessionalDocuments,
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
                label: Text(context.l10n.adminCounselorDetailUpload),
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
                tooltip: context.l10n.adminCounselorDetailView,
              ),
              IconButton(
                onPressed: () {
                  // TODO: Download document
                },
                icon: const Icon(Icons.download, size: 20),
                tooltip: context.l10n.adminCounselorDetailDownload,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityTab(dynamic counselor) {
    // Mock activity data
    final activities = _getMockActivities();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.adminCounselorDetailActivityTimeline,
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
  void _showSuspendDialog(dynamic counselor, String status) {
    final isActive = status == 'active';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isActive ? context.l10n.adminCounselorDetailSuspendTitle : context.l10n.adminCounselorDetailActivateTitle),
        content: Text(
          isActive
              ? context.l10n.adminCounselorDetailSuspendMessage(counselor.displayName ?? '')
              : context.l10n.adminCounselorDetailActivateMessage(counselor.displayName ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.adminCounselorDetailCancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call suspend/activate API
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? context.l10n.adminCounselorDetailSuspendSuccess
                        : context.l10n.adminCounselorDetailActivateSuccess,
                  ),
                ),
              );
            },
            child: Text(isActive ? context.l10n.adminCounselorDetailSuspend : context.l10n.adminCounselorDetailActivate),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(dynamic counselor) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.adminCounselorDetailDeleteTitle),
        content: Text(
          context.l10n.adminCounselorDetailDeleteMessage(counselor.displayName ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.adminCounselorDetailCancel),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Call delete API
              Navigator.pop(dialogContext);
              context.go('/admin/users/counselors');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.adminCounselorDetailDeleteSuccess)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: Text(context.l10n.adminCounselorDetailDelete),
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

  String _getMockSpecialty(int index) {
    final specialties = [
      'Academic Counseling',
      'Career Guidance',
      'College Admissions',
      'Mental Health',
      'Study Skills',
    ];
    return specialties[index % specialties.length];
  }

  List<Map<String, dynamic>> _getMockStudents(String counselorId) {
    return [
      {
        'name': 'Amina Hassan',
        'initials': 'AH',
        'grade': 'Grade 11',
        'sessions': 8,
      },
      {
        'name': 'Kwame Osei',
        'initials': 'KO',
        'grade': 'Grade 12',
        'sessions': 12,
      },
      {
        'name': 'Fatima Diallo',
        'initials': 'FD',
        'grade': 'Grade 10',
        'sessions': 5,
      },
    ];
  }

  List<Map<String, dynamic>> _getMockSessions(String counselorId) {
    return [
      {
        'title': 'College Application Review',
        'student': 'Amina Hassan',
        'date': 'Today, 10:00 AM',
        'duration': '60 min',
        'status': 'completed',
      },
      {
        'title': 'Career Path Discussion',
        'student': 'Kwame Osei',
        'date': 'Tomorrow, 2:00 PM',
        'duration': '45 min',
        'status': 'scheduled',
      },
      {
        'title': 'Academic Planning',
        'student': 'Fatima Diallo',
        'date': 'Jan 15, 3:00 PM',
        'duration': '60 min',
        'status': 'scheduled',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockDocuments() {
    return [
      {
        'name': 'Counseling License',
        'date': '1 year ago',
        'size': '1.5 MB',
      },
      {
        'name': 'Master\'s Degree Certificate',
        'date': '1 year ago',
        'size': '2.1 MB',
      },
      {
        'name': 'Professional Liability Insurance',
        'date': '6 months ago',
        'size': '890 KB',
      },
    ];
  }

  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'type': 'session',
        'title': 'Session Completed',
        'description': 'Completed session with Amina Hassan',
        'time': '2 hours ago',
      },
      {
        'type': 'student',
        'title': 'New Student Assigned',
        'description': 'Fatima Diallo assigned to counselor',
        'time': '3 days ago',
      },
      {
        'type': 'document',
        'title': 'Document Uploaded',
        'description': 'Professional Liability Insurance uploaded',
        'time': '1 week ago',
      },
      {
        'type': 'account',
        'title': 'Account Created',
        'description': 'Counselor account registered',
        'time': '1 year ago',
      },
    ];
  }

  Color _getSessionStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppColors.success;
      case 'scheduled':
        return AppColors.primary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'session':
        return Icons.event_available;
      case 'student':
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
      case 'session':
        return AppColors.success;
      case 'student':
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
