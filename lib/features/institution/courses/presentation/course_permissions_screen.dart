import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/enrollment_permission_model.dart';
import '../../../../core/services/enrollment_permissions_api_service.dart';
import '../../../../core/l10n_extension.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../providers/enrollment_permissions_provider.dart';

/// Course Permissions Management Screen
/// Institution manages enrollment permissions for a specific course
class CoursePermissionsScreen extends ConsumerStatefulWidget {
  final Course course;

  const CoursePermissionsScreen({super.key, required this.course});

  @override
  ConsumerState<CoursePermissionsScreen> createState() =>
      _CoursePermissionsScreenState();
}

class _CoursePermissionsScreenState
    extends ConsumerState<CoursePermissionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.instCourseEnrollmentPermissions),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.instCoursePendingRequests),
            Tab(text: context.l10n.instCourseApproved),
            Tab(text: context.l10n.instCourseAllStudents),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PendingRequestsTab(course: widget.course),
          _ApprovedPermissionsTab(course: widget.course),
          _AllStudentsTab(course: widget.course),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showGrantPermissionDialog(),
        icon: const Icon(Icons.person_add),
        label: Text(context.l10n.instCourseGrantPermission),
      ),
    );
  }

  void _showGrantPermissionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GrantPermissionBottomSheet(course: widget.course),
    );
  }
}

/// Bottom sheet for granting permissions to admitted students
class _GrantPermissionBottomSheet extends ConsumerStatefulWidget {
  final Course course;

  const _GrantPermissionBottomSheet({required this.course});

  @override
  ConsumerState<_GrantPermissionBottomSheet> createState() =>
      _GrantPermissionBottomSheetState();
}

class _GrantPermissionBottomSheetState
    extends ConsumerState<_GrantPermissionBottomSheet> {
  List<dynamic> _students = [];
  List<dynamic> _filteredStudents = [];
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  final Set<String> _selectedStudentIds = {};

  @override
  void initState() {
    super.initState();
    _fetchAdmittedStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((s) {
          final name = (s['display_name'] ?? '').toLowerCase();
          final email = (s['email'] ?? '').toLowerCase();
          return name.contains(query) || email.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchAdmittedStudents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final accessToken = ref.read(authProvider).accessToken;
      final apiService =
          EnrollmentPermissionsApiService(accessToken: accessToken);

      final result =
          await apiService.getAdmittedStudents(courseId: widget.course.id);

      if (mounted) {
        final allStudents = result['students'] as List? ?? [];
        // Filter out students who already have approved or pending permissions
        final availableStudents = allStudents.where((s) {
          final permission = s['permission'] as Map<String, dynamic>?;
          if (permission == null) return true;
          final status = permission['status'];
          return status != 'approved' && status != 'pending';
        }).toList();

        setState(() {
          _students = availableStudents;
          _filteredStudents = availableStudents;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load students: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _grantPermissions() async {
    if (_selectedStudentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.instCourseSelectAtLeastOne)),
      );
      return;
    }

    setState(() => _isLoading = true);

    int successCount = 0;
    int failCount = 0;

    for (final studentId in _selectedStudentIds) {
      final success = await ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .grantPermission(studentId);

      if (success) {
        successCount++;
      } else {
        failCount++;
      }
    }

    if (mounted) {
      Navigator.pop(context);

      if (successCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instCourseGrantedPermission(successCount)),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (failCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instCourseFailedGrantPermission(failCount)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.instCourseGrantEnrollmentPermission,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.l10n.instCourseSelectStudentsGrant,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: context.l10n.instCourseSearchStudents,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Selection count
          if (_selectedStudentIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      context.l10n.instCourseSelectedCount(_selectedStudentIds.length),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => setState(() => _selectedStudentIds.clear()),
                    child: Text(context.l10n.instCourseClear),
                  ),
                ],
              ),
            ),

          // Student List
          Expanded(
            child: _buildStudentList(),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(context.l10n.instCourseCancel),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          _selectedStudentIds.isEmpty ? null : _grantPermissions,
                      child: Text(
                        _selectedStudentIds.isEmpty
                            ? context.l10n.instCourseSelectStudents
                            : context.l10n.instCourseGrantToStudents(_selectedStudentIds.length),
                      ),
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

  Widget _buildStudentList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAdmittedStudents,
              child: Text(context.l10n.instCourseRetry),
            ),
          ],
        ),
      );
    }

    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoStudentsAvailable,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseAllStudentsHavePermissions,
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_filteredStudents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoMatchingStudents,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredStudents.length,
      itemBuilder: (context, index) {
        final student = _filteredStudents[index];
        final studentId = student['student_id'] as String;
        final isSelected = _selectedStudentIds.contains(studentId);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  _selectedStudentIds.add(studentId);
                } else {
                  _selectedStudentIds.remove(studentId);
                }
              });
            },
            secondary: CircleAvatar(
              backgroundColor:
                  isSelected ? AppColors.primary : Colors.grey[200],
              child: Text(
                (student['display_name'] ?? 'S')[0].toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
            title: Text(
              student['display_name'] ?? 'Student',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(student['email'] ?? ''),
            activeColor: AppColors.primary,
          ),
        );
      },
    );
  }
}

/// Pending Requests Tab
class _PendingRequestsTab extends ConsumerStatefulWidget {
  final Course course;

  const _PendingRequestsTab({required this.course});

  @override
  ConsumerState<_PendingRequestsTab> createState() =>
      _PendingRequestsTabState();
}

class _PendingRequestsTabState extends ConsumerState<_PendingRequestsTab> {
  @override
  void initState() {
    super.initState();
    // Filter to pending status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .filterByStatus(PermissionStatus.pending);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(enrollmentPermissionsProvider(widget.course.id));

    if (state.isLoading && state.permissions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.permissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(state.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref
                  .read(enrollmentPermissionsProvider(widget.course.id).notifier)
                  .refresh(),
              child: Text(context.l10n.instCourseRetry),
            ),
          ],
        ),
      );
    }

    if (state.permissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pending_actions, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoPendingRequests,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseStudentsCanRequest,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.permissions.length,
        itemBuilder: (context, index) {
          final permission = state.permissions[index];
          return _buildPermissionCard(
            context,
            ref,
            permission,
            showActions: true,
          );
        },
      ),
    );
  }

  Widget _buildPermissionCard(
    BuildContext context,
    WidgetRef ref,
    EnrollmentPermission permission, {
    bool showActions = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(
                    (permission.studentDisplayName ?? 'S')[0].toUpperCase(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        permission.studentDisplayName ?? 'Student',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        permission.studentEmail ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (permission.notes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.instCourseMessage,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(permission.notes!),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  context.l10n.instCourseRequested(_formatDate(permission.createdAt)),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (showActions) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDenyDialog(context, ref, permission),
                      icon: const Icon(Icons.close, size: 18),
                      label: Text(context.l10n.instCourseDeny),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _approvePermission(ref, permission),
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(context.l10n.instCourseApprove),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _approvePermission(
    WidgetRef ref,
    EnrollmentPermission permission,
  ) async {
    final success = await ref
        .read(enrollmentPermissionsProvider(widget.course.id).notifier)
        .approvePermission(permission.id);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.instCourseApprovedStudent(permission.studentDisplayName ?? '')),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      final error =
          ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? context.l10n.instCourseFailedToApprove),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDenyDialog(
    BuildContext context,
    WidgetRef ref,
    EnrollmentPermission permission,
  ) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instCourseDenyPermissionRequest),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.instCourseDenyStudent(permission.studentDisplayName ?? '')),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.instCourseReasonForDenial,
                hintText: context.l10n.instCourseEnterReason,
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(context.l10n.instCoursePleaseProvideReason)),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.instCourseDeny),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final success = await ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .denyPermission(permission.id, reasonController.text.trim());

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instCourseDeniedStudent(permission.studentDisplayName ?? '')),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    reasonController.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Approved Permissions Tab
class _ApprovedPermissionsTab extends ConsumerStatefulWidget {
  final Course course;

  const _ApprovedPermissionsTab({required this.course});

  @override
  ConsumerState<_ApprovedPermissionsTab> createState() =>
      _ApprovedPermissionsTabState();
}

class _ApprovedPermissionsTabState
    extends ConsumerState<_ApprovedPermissionsTab> {
  @override
  void initState() {
    super.initState();
    // Filter to approved status
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .filterByStatus(PermissionStatus.approved);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(enrollmentPermissionsProvider(widget.course.id));

    if (state.isLoading && state.permissions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.permissions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoApprovedPermissions,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseGrantToAllowEnroll,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.permissions.length,
        itemBuilder: (context, index) {
          final permission = state.permissions[index];
          return _buildApprovedCard(context, ref, permission);
        },
      ),
    );
  }

  Widget _buildApprovedCard(
    BuildContext context,
    WidgetRef ref,
    EnrollmentPermission permission,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(Icons.check, color: Colors.green[700]),
        ),
        title: Text(permission.studentDisplayName ?? 'Student'),
        subtitle: Text(permission.studentEmail ?? ''),
        trailing: PopupMenuButton<String>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'revoke',
              child: Text(context.l10n.instCourseRevokePermission, style: const TextStyle(color: Colors.red)),
            ),
          ],
          onSelected: (value) {
            if (value == 'revoke') {
              _showRevokeDialog(context, ref, permission);
            }
          },
        ),
      ),
    );
  }

  Future<void> _showRevokeDialog(
    BuildContext context,
    WidgetRef ref,
    EnrollmentPermission permission,
  ) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instCourseRevokePermission),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.instCourseRevokePermissionFor(permission.studentDisplayName ?? '')),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: context.l10n.instCourseReasonOptional,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.instCourseRevoke),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final success = await ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .revokePermission(
            permission.id,
            reason: reasonController.text.trim().isEmpty
                ? null
                : reasonController.text.trim(),
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instCourseRevokedPermissionFor(permission.studentDisplayName ?? '')),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }

    reasonController.dispose();
  }
}

/// All Admitted Students Tab
class _AllStudentsTab extends ConsumerStatefulWidget {
  final Course course;

  const _AllStudentsTab({required this.course});

  @override
  ConsumerState<_AllStudentsTab> createState() => _AllStudentsTabState();
}

class _AllStudentsTabState extends ConsumerState<_AllStudentsTab> {
  List<dynamic> _students = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAdmittedStudents();
  }

  Future<void> _fetchAdmittedStudents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final accessToken = ref.read(authProvider).accessToken;
      final apiService = EnrollmentPermissionsApiService(accessToken: accessToken);

      final result = await apiService.getAdmittedStudents(courseId: widget.course.id);

      if (mounted) {
        setState(() {
          _students = result['students'] as List? ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load admitted students: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchAdmittedStudents,
              child: Text(context.l10n.instCourseRetry),
            ),
          ],
        ),
      );
    }

    if (_students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              context.l10n.instCourseNoAdmittedStudents,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.instCourseAcceptedStudentsAppearHere,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAdmittedStudents,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final student = _students[index];
          return _buildStudentCard(context, ref, student);
        },
      ),
    );
  }

  Widget _buildStudentCard(BuildContext context, WidgetRef ref, dynamic student) {
    final permission = student['permission'] as Map<String, dynamic>?;
    final hasPermission = permission != null && permission['status'] == 'approved';
    final hasPendingRequest = permission != null && permission['status'] == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: hasPermission
              ? Colors.green[100]
              : (hasPendingRequest ? Colors.orange[100] : Colors.grey[200]),
          child: hasPermission
              ? Icon(Icons.check, color: Colors.green[700])
              : (hasPendingRequest
                  ? Icon(Icons.pending, color: Colors.orange[700])
                  : Text(
                      (student['display_name'] ?? 'S')[0].toUpperCase(),
                      style: TextStyle(color: Colors.grey[700]),
                    )),
        ),
        title: Text(student['display_name'] ?? 'Student'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student['email'] ?? ''),
            if (permission != null) ...[
              const SizedBox(height: 4),
              Text(
                'Status: ${_getPermissionStatusText(permission['status'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: _getPermissionStatusColor(permission['status']),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        trailing: hasPermission
            ? null
            : (hasPendingRequest
                ? TextButton(
                    onPressed: () => _approveRequest(context, ref, permission!),
                    child: Text(context.l10n.instCourseApprove),
                  )
                : ElevatedButton(
                    onPressed: () => _grantPermission(context, ref, student),
                    child: Text(context.l10n.instCourseGrantAccess),
                  )),
      ),
    );
  }

  String _getPermissionStatusText(String status) {
    switch (status) {
      case 'pending':
        return context.l10n.instCourseRequestPending;
      case 'approved':
        return context.l10n.instCourseAccessGranted;
      case 'denied':
        return context.l10n.instCourseDenied;
      case 'revoked':
        return context.l10n.instCourseRevoked;
      default:
        return status;
    }
  }

  Color _getPermissionStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'denied':
      case 'revoked':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _grantPermission(BuildContext context, WidgetRef ref, dynamic student) async {
    final notesController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.instCourseGrantEnrollmentPermission),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.instCourseGrantStudentPermission(student['display_name'] ?? '')),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: context.l10n.instCourseNotesOptional,
                hintText: context.l10n.instCourseAddNotes,
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.instCourseCancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.instCourseGrant),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final success = await ref
          .read(enrollmentPermissionsProvider(widget.course.id).notifier)
          .grantPermission(
            student['student_id'],
            notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.instCourseGrantedPermissionTo(student['display_name'] ?? '')),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the list
        _fetchAdmittedStudents();
      } else if (mounted) {
        final error = ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? context.l10n.instCourseFailedToGrantPermission),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    notesController.dispose();
  }

  Future<void> _approveRequest(BuildContext context, WidgetRef ref, Map<String, dynamic> permission) async {
    final success = await ref
        .read(enrollmentPermissionsProvider(widget.course.id).notifier)
        .approvePermission(permission['id']);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.instCourseRequestApproved),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh the list
      _fetchAdmittedStudents();
    } else if (mounted) {
      final error = ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? context.l10n.instCourseFailedToApproveRequest),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
