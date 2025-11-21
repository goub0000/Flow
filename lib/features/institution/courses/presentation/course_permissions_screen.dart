import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/course_model.dart';
import '../../../../core/models/enrollment_permission_model.dart';
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
            const Text('Enrollment Permissions'),
            Text(
              widget.course.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColors.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending Requests'),
            Tab(text: 'Approved'),
            Tab(text: 'All Students'),
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
        label: const Text('Grant Permission'),
      ),
    );
  }

  void _showGrantPermissionDialog() {
    // TODO: Implement grant permission dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Grant Enrollment Permission'),
        content: const Text('Grant permission feature coming soon. Select admitted students to grant access to this course.'),
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
              child: const Text('Retry'),
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
            const Text(
              'No pending requests',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Students can request enrollment permission',
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
                    const Text(
                      'Message:',
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
                  'Requested: ${_formatDate(permission.createdAt)}',
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
                      label: const Text('Deny'),
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
                      label: const Text('Approve'),
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
          content: Text('Approved ${permission.studentDisplayName}'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      final error =
          ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to approve'),
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
        title: const Text('Deny Permission Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deny ${permission.studentDisplayName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for denial',
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Deny'),
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
            content: Text('Denied ${permission.studentDisplayName}'),
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
            const Text(
              'No approved permissions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Grant permissions to allow students to enroll',
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
            const PopupMenuItem(
              value: 'revoke',
              child: Text('Revoke Permission', style: TextStyle(color: Colors.red)),
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
        title: const Text('Revoke Permission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Revoke permission for ${permission.studentDisplayName}?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Revoke'),
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
            content: Text('Revoked permission for ${permission.studentDisplayName}'),
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
              child: const Text('Retry'),
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
            const Text(
              'No admitted students',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Students with accepted applications will appear here',
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
                    child: const Text('Approve'),
                  )
                : ElevatedButton(
                    onPressed: () => _grantPermission(context, ref, student),
                    child: const Text('Grant Access'),
                  )),
      ),
    );
  }

  String _getPermissionStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Request Pending';
      case 'approved':
        return 'Access Granted';
      case 'denied':
        return 'Denied';
      case 'revoked':
        return 'Revoked';
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
        title: const Text('Grant Enrollment Permission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grant ${student['display_name']} permission to enroll in this course?'),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add any notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Grant'),
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
            content: Text('Granted permission to ${student['display_name']}'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh the list
        _fetchAdmittedStudents();
      } else if (mounted) {
        final error = ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to grant permission'),
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
        const SnackBar(
          content: Text('Request approved'),
          backgroundColor: Colors.green,
        ),
      );
      // Refresh the list
      _fetchAdmittedStudents();
    } else if (mounted) {
      final error = ref.read(enrollmentPermissionsProvider(widget.course.id)).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Failed to approve request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
