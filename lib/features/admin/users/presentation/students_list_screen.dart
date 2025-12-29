import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../shared/widgets/logo_avatar.dart';
import '../../shared/widgets/admin_shell.dart';
import '../../shared/widgets/admin_data_table.dart';
import '../../shared/widgets/permission_guard.dart';
import '../../shared/widgets/export_dialog.dart';
import '../../shared/widgets/bulk_action_bar.dart';
import '../../shared/services/export_service.dart';
import '../../shared/services/bulk_operations_service.dart';
import '../../shared/utils/export_utils.dart';
import '../../shared/utils/debouncer.dart';
import '../../shared/providers/admin_users_provider.dart';

/// Students List Screen - Manage student accounts
///
/// Features:
/// - View all students (filtered by regional scope for Regional Admins)
/// - Search and filter students
/// - View student details
/// - Edit student profiles
/// - Deactivate/activate accounts
/// - Export student data
class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  // TODO: Replace with actual state management
  final TextEditingController _searchController = TextEditingController();
  final _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 500));
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String _selectedGrade = 'all';
  List<StudentRowData> _selectedItems = [];
  bool _isBulkOperationInProgress = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch students from backend
    // - API endpoint: GET /api/admin/users/students
    // - Support pagination, filtering, search
    // - Filter by regional scope for Regional Admins
    // - Include: profile data, academic info, application status

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

        // Filters and Search
        _buildFiltersSection(),
        const SizedBox(height: 24),

        // Data Table
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                // Bulk Action Bar
                BulkActionBar(
                  selectedCount: _selectedItems.length,
                  onClearSelection: () {
                    setState(() => _selectedItems = []);
                  },
                  isProcessing: _isBulkOperationInProgress,
                  actions: [
                    BulkAction(
                      label: 'Activate',
                      icon: Icons.check_circle,
                      onPressed: _handleBulkActivate,
                    ),
                    BulkAction(
                      label: 'Deactivate',
                      icon: Icons.block,
                      onPressed: _handleBulkDeactivate,
                      isDestructive: true,
                    ),
                  ],
                ),

                // Data Table
                Expanded(child: _buildDataTable()),
              ],
            ),
          ),
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
              Text(
                'Students',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage student accounts and profiles',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Export button (requires permission)
              PermissionGuard(
                permission: AdminPermission.bulkUserOperations,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final users = ref.read(adminStudentsProvider);
                    await showExportDialog(
                      context: context,
                      title: 'Export Students',
                      onExport: (format) => ExportService.exportStudents(
                        students: users,
                        format: format,
                      ),
                    );
                  },
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text('Export'),
                ),
              ),
              const SizedBox(width: 12),
              // Add student button (requires permission)
              PermissionGuard(
                permission: AdminPermission.editUsers,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/students/create'),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Add Student'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, email, or student ID...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                _searchDebouncer.call(() {
                  setState(() => _searchQuery = value.toLowerCase());
                });
              },
            ),
          ),
          const SizedBox(width: 16),

          // Status Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Status')),
                DropdownMenuItem(value: 'active', child: Text('Active')),
                DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                DropdownMenuItem(value: 'pending', child: Text('Pending Verification')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
          ),
          const SizedBox(width: 16),

          // Grade Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedGrade,
              decoration: InputDecoration(
                labelText: 'Grade',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Grades')),
                DropdownMenuItem(value: '9', child: Text('Grade 9')),
                DropdownMenuItem(value: '10', child: Text('Grade 10')),
                DropdownMenuItem(value: '11', child: Text('Grade 11')),
                DropdownMenuItem(value: '12', child: Text('Grade 12')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedGrade = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    // Get users from provider and convert to StudentRowData
    final users = ref.watch(adminStudentsProvider);
    var students = users.map((user) {
      // Extract metadata fields if available
      final metadata = user.metadata ?? {};
      return StudentRowData(
        id: user.id,
        name: user.displayName ?? 'Unknown User',
        email: user.email,
        studentId: 'STU${user.id.substring(0, 6).toUpperCase()}',
        grade: metadata['grade']?.toString() ?? 'Not specified',
        school: metadata['school']?.toString() ?? 'Not specified',
        applications: (metadata['applications_count'] as int?) ?? 0,
        status: metadata['isActive'] == true ? 'active' : 'inactive',
        joinedDate: _formatDate(user.createdAt),
      );
    }).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      students = students.where((student) {
        return student.name.toLowerCase().contains(_searchQuery) ||
            student.email.toLowerCase().contains(_searchQuery) ||
            student.studentId.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'all') {
      students = students.where((student) => student.status == _selectedStatus).toList();
    }

    // Apply grade filter
    if (_selectedGrade != 'all') {
      students = students.where((student) => student.grade.contains(_selectedGrade)).toList();
    }

    return AdminDataTable<StudentRowData>(
      columns: [
        DataTableColumn(
          label: 'Student',
          cellBuilder: (student) => Row(
            children: [
              LogoAvatar.user(
                photoUrl: null, // TODO: Add photoUrl to StudentRowData model
                initials: student.initials,
                size: 32,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    student.email,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          sortable: true,
        ),
        DataTableColumn(
          label: 'Student ID',
          cellBuilder: (student) => Text(student.studentId),
        ),
        DataTableColumn(
          label: 'Grade',
          cellBuilder: (student) => Text(student.grade),
        ),
        DataTableColumn(
          label: 'School',
          cellBuilder: (student) => Text(
            student.school,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataTableColumn(
          label: 'Applications',
          cellBuilder: (student) => Text(student.applications.toString()),
        ),
        DataTableColumn(
          label: 'Status',
          cellBuilder: (student) => _buildStatusChip(student.status),
        ),
        DataTableColumn(
          label: 'Joined',
          cellBuilder: (student) => Text(student.joinedDate),
        ),
      ],
      data: students,
      isLoading: false, // TODO: Set from actual loading state
      enableSelection: true,
      onSelectionChanged: (selectedItems) {
        setState(() => _selectedItems = selectedItems);
      },
      onRowTap: (student) {
        // TODO: Navigate to student detail screen
        _showStudentDetails(student);
      },
      rowActions: [
        DataTableAction(
          icon: Icons.edit,
          tooltip: 'Edit Student',
          onPressed: (student) {
            // TODO: Navigate to edit student screen
          },
        ),
        DataTableAction(
          icon: Icons.block,
          tooltip: 'Deactivate Account',
          color: AppColors.error,
          onPressed: (student) {
            // TODO: Show confirmation dialog
            // TODO: Call deactivate API
          },
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'active':
        color = AppColors.success;
        label = 'Active';
        break;
      case 'inactive':
        color = AppColors.textSecondary;
        label = 'Inactive';
        break;
      case 'pending':
        color = AppColors.warning;
        label = 'Pending';
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

  void _showStudentDetails(StudentRowData student) {
    // Navigate to student detail screen
    context.go('/admin/users/students/${student.id}');
  }

  /// Helper method to format date relative to now
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

  /// Handle bulk activate operation
  Future<void> _handleBulkActivate() async {
    if (_selectedItems.isEmpty) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activate Students'),
        content: Text(
          'Are you sure you want to activate ${_selectedItems.length} student(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Activate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isBulkOperationInProgress = true);

    try {
      final userIds = _selectedItems.map((item) => item.id).toList();
      final result = await BulkOperationsService.activateUsers(userIds: userIds);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.isSuccess ? AppColors.success : AppColors.error,
          ),
        );

        if (result.isSuccess) {
          setState(() {
            _selectedItems = [];
          });
          // TODO: Refresh the data table
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }

  /// Handle bulk deactivate operation
  Future<void> _handleBulkDeactivate() async {
    if (_selectedItems.isEmpty) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deactivate Students'),
        content: Text(
          'Are you sure you want to deactivate ${_selectedItems.length} student(s)? '
          'They will no longer be able to access their accounts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isBulkOperationInProgress = true);

    try {
      final userIds = _selectedItems.map((item) => item.id).toList();
      final result = await BulkOperationsService.deactivateUsers(userIds: userIds);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: result.isSuccess ? AppColors.success : AppColors.error,
          ),
        );

        if (result.isSuccess) {
          setState(() {
            _selectedItems = [];
          });
          // TODO: Refresh the data table
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isBulkOperationInProgress = false);
      }
    }
  }
}

/// Temporary data model for table rows
/// TODO: Replace with actual Student model from backend
class StudentRowData {
  final String id;
  final String name;
  final String email;
  final String studentId;
  final String grade;
  final String school;
  final int applications;
  final String status;
  final String joinedDate;

  StudentRowData({
    required this.id,
    required this.name,
    required this.email,
    required this.studentId,
    required this.grade,
    required this.school,
    required this.applications,
    required this.status,
    required this.joinedDate,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
