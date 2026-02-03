import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/l10n_extension.dart';
import '../../../shared/widgets/logo_avatar.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/providers/admin_users_provider.dart';

/// Student Detail Screen - Comprehensive view of student profile
///
/// Features:
/// - Full profile information with avatar
/// - Quick stats cards
/// - Tabbed interface: Overview, Academic, Applications, Documents, Payments, Activity
/// - Action buttons: Edit, Suspend, Delete, Message
class StudentDetailScreen extends ConsumerStatefulWidget {
  final String studentId;

  const StudentDetailScreen({
    super.key,
    required this.studentId,
  });

  @override
  ConsumerState<StudentDetailScreen> createState() =>
      _StudentDetailScreenState();
}

class _StudentDetailScreenState extends ConsumerState<StudentDetailScreen>
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
    // Get student from provider
    final users = ref.watch(adminUsersProvider).users;
    final student = users.firstWhere(
      (u) => u.id == widget.studentId,
      orElse: () => users.first, // Fallback to first user if not found
    );

    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Breadcrumb
        _buildBreadcrumb(),
          const SizedBox(height: 24),

          // Main content
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left sidebar - Profile
                SizedBox(
                  width: 320,
                  child: _buildProfileSidebar(student),
                ),
                const SizedBox(width: 24),

                // Right content - Tabs
                Expanded(
                  child: _buildTabContent(student),
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
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.adminUserDetailBackToStudents),
          ),
          const Text(' / '),
          Text(
            context.l10n.adminUserDetailStudentDetails,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSidebar(UserModel student) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Avatar
          LogoAvatar.user(
            photoUrl: student.photoUrl,
            initials: _getInitials(student.displayName ?? 'U'),
            size: 100,
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            student.displayName ?? context.l10n.adminUserDetailUnknownStudent,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            student.email,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Status Badge
          _buildStatusBadge(student.metadata?['isActive'] == true),
          const SizedBox(height: 24),

          // Quick Stats
          _buildStatCard(context.l10n.adminUserDetailStudentId, 'STU${student.id.substring(0, 6).toUpperCase()}'),
          const SizedBox(height: 12),
          _buildStatCard(context.l10n.adminUserDetailGrade, '${context.l10n.adminUserDetailGradePrefix} ${10 + (student.id.hashCode % 4)}'),
          const SizedBox(height: 12),
          _buildStatCard(context.l10n.adminUserDetailCoursesEnrolled, '${2 + (student.id.hashCode % 5)}'),
          const SizedBox(height: 12),
          _buildStatCard(context.l10n.adminUserDetailApplications, '${3 + (student.id.hashCode % 6)}'),
          const SizedBox(height: 12),
          _buildStatCard(context.l10n.adminUserDetailOverallProgress, '${50 + (student.id.hashCode % 40)}%'),
          const SizedBox(height: 24),

          // Action Buttons
          _buildActionButtons(student),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (isActive ? AppColors.success : AppColors.textSecondary)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? context.l10n.adminUserDetailStatusActive : context.l10n.adminUserDetailStatusInactive,
        style: TextStyle(
          color: isActive ? AppColors.success : AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
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
      ),
    );
  }

  Widget _buildActionButtons(UserModel student) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            context.go('/admin/users/students/${widget.studentId}/edit');
          },
          icon: const Icon(Icons.edit, size: 18),
          label: Text(context.l10n.adminUserDetailEditProfile),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            // TODO: Send message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.adminUserDetailMessageComingSoon)),
            );
          },
          icon: const Icon(Icons.message, size: 18),
          label: Text(context.l10n.adminUserDetailSendMessage),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _showSuspendDialog(student),
          icon: const Icon(Icons.block, size: 18),
          label: Text(
            student.metadata?['isActive'] == true ? context.l10n.adminUserDetailSuspend : context.l10n.adminUserDetailActivate,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.warning,
            side: BorderSide(color: AppColors.warning),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _showDeleteDialog(student),
          icon: const Icon(Icons.delete, size: 18),
          label: Text(context.l10n.adminUserDetailDeleteAccount),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: BorderSide(color: AppColors.error),
          ),
        ),
      ],
    );
  }

  Widget _buildTabContent(UserModel student) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
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
                Tab(text: context.l10n.adminUserDetailTabOverview),
                Tab(text: context.l10n.adminUserDetailTabAcademic),
                Tab(text: context.l10n.adminUserDetailTabApplications),
                Tab(text: context.l10n.adminUserDetailTabDocuments),
                Tab(text: context.l10n.adminUserDetailTabPayments),
                Tab(text: context.l10n.adminUserDetailTabActivity),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(student),
                _buildAcademicTab(student),
                _buildApplicationsTab(student),
                _buildDocumentsTab(student),
                _buildPaymentsTab(student),
                _buildActivityTab(student),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow('Full Name', student.displayName ?? 'N/A'),
          _buildInfoRow('Email', student.email),
          _buildInfoRow('Phone', student.phoneNumber ?? 'Not provided'),
          _buildInfoRow('Date of Birth', 'May 12, 2002'), // Mock
          _buildInfoRow('Nationality', 'Kenyan'), // Mock
          _buildInfoRow('Region', 'East Africa'), // Mock
          _buildInfoRow('Address', '123 Main St, Nairobi, Kenya'), // Mock
          _buildInfoRow('Emergency Contact', '+254712345679'), // Mock

          const SizedBox(height: 32),

          Text(
            'Account Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildInfoRow('Account Created', _formatDate(student.createdAt)),
          _buildInfoRow(
            'Last Login',
            student.lastLoginAt != null
                ? _formatDate(student.lastLoginAt!)
                : 'Never',
          ),
          _buildInfoRow(
            'Email Verified',
            student.isEmailVerified ? 'Yes' : 'No',
          ),
          _buildInfoRow(
            'Phone Verified',
            student.isPhoneVerified ? 'Yes' : 'No',
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Courses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Mock courses
          ...List.generate(3, (index) => _buildCourseCard(index)),

          const SizedBox(height: 24),

          Text(
            'Academic Performance',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildPerformanceCard('GPA', '3.7', Icons.school),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceCard(
                    'Completed Courses', '12', Icons.check_circle),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPerformanceCard(
                    'Achievements', '8', Icons.emoji_events),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Mock applications
          ...List.generate(5, (index) => _buildApplicationCard(index)),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Documents',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

          // Mock documents
          ...List.generate(4, (index) => _buildDocumentCard(index)),
        ],
      ),
    );
  }

  Widget _buildPaymentsTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment History',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildPaymentSummaryCard(
                  'Total Paid',
                  'KES 45,000',
                  Icons.payments,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPaymentSummaryCard(
                  'Pending',
                  'KES 0',
                  Icons.pending,
                  AppColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Payment transactions
          ...List.generate(6, (index) => _buildPaymentCard(index)),
        ],
      ),
    );
  }

  Widget _buildActivityTab(UserModel student) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activity Timeline',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Mock activity timeline
          ...List.generate(10, (index) => _buildActivityItem(index)),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(int index) {
    final courses = [
      {
        'name': 'Introduction to Computer Science',
        'instructor': 'Dr. Smith',
        'progress': 75,
        'grade': 'A'
      },
      {
        'name': 'Advanced Mathematics',
        'instructor': 'Prof. Johnson',
        'progress': 60,
        'grade': 'B+'
      },
      {
        'name': 'English Literature',
        'instructor': 'Ms. Williams',
        'progress': 85,
        'grade': 'A-'
      },
    ];

    if (index >= courses.length) return const SizedBox.shrink();
    final course = courses[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  course['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  course['grade'] as String,
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Instructor: ${course['instructor']}',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (course['progress'] as int) / 100,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${course['progress']}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: AppColors.primary),
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
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(int index) {
    final applications = [
      {
        'institution': 'University of Nairobi',
        'program': 'BSc Computer Science',
        'status': 'accepted',
        'date': 'Mar 15, 2024'
      },
      {
        'institution': 'Kenyatta University',
        'program': 'BSc Information Technology',
        'status': 'pending',
        'date': 'Mar 20, 2024'
      },
      {
        'institution': 'Strathmore University',
        'program': 'BSc Business IT',
        'status': 'rejected',
        'date': 'Feb 28, 2024'
      },
      {
        'institution': 'USIU Africa',
        'program': 'BSc Software Engineering',
        'status': 'pending',
        'date': 'Apr 5, 2024'
      },
      {
        'institution': 'Jomo Kenyatta University',
        'program': 'BSc Computer Engineering',
        'status': 'accepted',
        'date': 'Mar 10, 2024'
      },
    ];

    if (index >= applications.length) return const SizedBox.shrink();
    final app = applications[index];

    Color statusColor;
    switch (app['status']) {
      case 'accepted':
        statusColor = AppColors.success;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.warning;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app['institution'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app['program'] as String,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              (app['status'] as String).toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(int index) {
    final documents = [
      {'name': 'Transcript.pdf', 'type': 'Academic', 'size': '2.4 MB', 'date': 'Feb 1, 2024'},
      {'name': 'ID_Copy.pdf', 'type': 'Identity', 'size': '1.2 MB', 'date': 'Jan 15, 2024'},
      {'name': 'Birth_Certificate.pdf', 'type': 'Identity', 'size': '800 KB', 'date': 'Jan 15, 2024'},
      {'name': 'Recommendation_Letter.pdf', 'type': 'Academic', 'size': '500 KB', 'date': 'Mar 5, 2024'},
    ];

    if (index >= documents.length) return const SizedBox.shrink();
    final doc = documents[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.description,
            color: AppColors.primary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${doc['type']} • ${doc['size']} • ${doc['date']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Download document
            },
            icon: const Icon(Icons.download),
            tooltip: 'Download',
          ),
          IconButton(
            onPressed: () {
              // TODO: View document
            },
            icon: const Icon(Icons.visibility),
            tooltip: 'View',
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(int index) {
    final payments = [
      {
        'description': 'Course Enrollment Fee',
        'amount': 'KES 15,000',
        'method': 'M-Pesa',
        'status': 'completed',
        'date': 'Sep 1, 2024'
      },
      {
        'description': 'Application Fee - University of Nairobi',
        'amount': 'KES 5,000',
        'method': 'M-Pesa',
        'status': 'completed',
        'date': 'Mar 15, 2024'
      },
      {
        'description': 'Exam Fee',
        'amount': 'KES 3,000',
        'method': 'Card',
        'status': 'completed',
        'date': 'Aug 10, 2024'
      },
      {
        'description': 'Library Fee',
        'amount': 'KES 2,000',
        'method': 'M-Pesa',
        'status': 'completed',
        'date': 'Jul 5, 2024'
      },
      {
        'description': 'Lab Fee',
        'amount': 'KES 10,000',
        'method': 'Bank Transfer',
        'status': 'completed',
        'date': 'Sep 1, 2024'
      },
      {
        'description': 'Materials Fee',
        'amount': 'KES 10,000',
        'method': 'M-Pesa',
        'status': 'completed',
        'date': 'Sep 1, 2024'
      },
    ];

    if (index >= payments.length) return const SizedBox.shrink();
    final payment = payments[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            Icons.payment,
            color: AppColors.success,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment['description'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${payment['method']} • ${payment['date']}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            payment['amount'] as String,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'action': 'Enrolled in course',
        'details': 'Introduction to Computer Science',
        'time': '2 hours ago'
      },
      {
        'action': 'Submitted application',
        'details': 'University of Nairobi - BSc Computer Science',
        'time': '1 day ago'
      },
      {
        'action': 'Completed assignment',
        'details': 'Advanced Mathematics - Assignment 3',
        'time': '2 days ago'
      },
      {
        'action': 'Uploaded document',
        'details': 'Transcript.pdf',
        'time': '3 days ago'
      },
      {'action': 'Made payment', 'details': 'Course Enrollment Fee - KES 15,000', 'time': '5 days ago'},
      {'action': 'Updated profile', 'details': 'Changed phone number', 'time': '1 week ago'},
      {'action': 'Enrolled in course', 'details': 'Advanced Mathematics', 'time': '1 week ago'},
      {'action': 'Completed quiz', 'details': 'English Literature - Quiz 2', 'time': '2 weeks ago'},
      {'action': 'Joined platform', 'details': 'Account created', 'time': '1 month ago'},
      {'action': 'Verified email', 'details': 'Email verification successful', 'time': '1 month ago'},
    ];

    if (index >= activities.length) return const SizedBox.shrink();
    final activity = activities[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (index < activities.length - 1)
                Container(
                  width: 2,
                  height: 40,
                  color: AppColors.border,
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['details'] as String,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(UserModel student) {
    final isActive = student.metadata?['isActive'] == true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Suspend Student' : 'Activate Student'),
        content: Text(
          isActive
              ? 'Are you sure you want to suspend this student account? They will not be able to access the platform.'
              : 'Are you sure you want to activate this student account? They will regain access to the platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(adminUsersProvider.notifier).updateUserStatus(
                    student.id,
                    !isActive,
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isActive
                        ? 'Student account suspended'
                        : 'Student account activated',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isActive ? AppColors.warning : AppColors.success,
            ),
            child: Text(isActive ? 'Suspend' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(UserModel student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student Account'),
        content: const Text(
          'Are you sure you want to delete this student account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(adminUsersProvider.notifier).deleteUser(student.id);
              Navigator.pop(context); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student account deleted'),
                ),
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

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} weeks ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} months ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
