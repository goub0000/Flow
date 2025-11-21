import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/enrollment_permission_model.dart';
import '../../../core/services/enrollment_permissions_api_service.dart';
import '../../../features/authentication/providers/auth_provider.dart';

/// State class for enrollment permissions
class EnrollmentPermissionsState {
  final List<EnrollmentPermission> permissions;
  final int total;
  final bool isLoading;
  final String? error;
  final PermissionStatus? filterStatus;
  final int currentPage;
  final int pageSize;
  final bool hasMore;

  const EnrollmentPermissionsState({
    this.permissions = const [],
    this.total = 0,
    this.isLoading = false,
    this.error,
    this.filterStatus,
    this.currentPage = 1,
    this.pageSize = 20,
    this.hasMore = false,
  });

  EnrollmentPermissionsState copyWith({
    List<EnrollmentPermission>? permissions,
    int? total,
    bool? isLoading,
    String? error,
    PermissionStatus? filterStatus,
    bool clearFilter = false,
    int? currentPage,
    int? pageSize,
    bool? hasMore,
  }) {
    return EnrollmentPermissionsState(
      permissions: permissions ?? this.permissions,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// StateNotifier for managing enrollment permissions
class EnrollmentPermissionsNotifier
    extends StateNotifier<EnrollmentPermissionsState> {
  final Ref _ref;
  final String _courseId;
  late final EnrollmentPermissionsApiService _apiService;

  EnrollmentPermissionsNotifier(this._ref, this._courseId)
      : super(const EnrollmentPermissionsState()) {
    final accessToken = _ref.read(authProvider).accessToken;
    _apiService = EnrollmentPermissionsApiService(accessToken: accessToken);
    fetchPermissions();
  }

  /// Fetch permissions for the course
  Future<void> fetchPermissions({bool loadMore = false}) async {
    if (state.isLoading) return;

    final page = loadMore ? state.currentPage + 1 : 1;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: page,
    );

    try {
      final result = await _apiService.getCoursePermissions(
        _courseId,
        status: state.filterStatus?.value,
        page: page,
        pageSize: state.pageSize,
      );

      final permissionsList = (result['permissions'] as List?)
              ?.map((p) => EnrollmentPermission.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [];

      final newPermissions =
          loadMore ? [...state.permissions, ...permissionsList] : permissionsList;

      state = state.copyWith(
        permissions: newPermissions,
        total: result['total'] as int? ?? 0,
        hasMore: result['has_more'] as bool? ?? false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch permissions: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Grant permission to a student
  Future<bool> grantPermission(
    String studentId, {
    String? notes,
  }) async {
    try {
      await _apiService.grantPermission(
        studentId,
        _courseId,
        notes: notes,
      );

      // Refresh permissions list
      await fetchPermissions();

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to grant permission: ${e.toString()}',
      );
      return false;
    }
  }

  /// Approve a permission request
  Future<bool> approvePermission(
    String permissionId, {
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.approvePermission(permissionId, notes: notes);

      // Update in local state
      final updatedPermissions = state.permissions.map((p) {
        if (p.id == permissionId) {
          return EnrollmentPermission(
            id: p.id,
            studentId: p.studentId,
            courseId: p.courseId,
            institutionId: p.institutionId,
            status: PermissionStatus.approved,
            grantedBy: p.grantedBy,
            grantedByUserId: p.grantedByUserId,
            reviewedAt: DateTime.now(),
            notes: notes ?? p.notes,
            createdAt: p.createdAt,
            updatedAt: DateTime.now(),
            studentEmail: p.studentEmail,
            studentDisplayName: p.studentDisplayName,
            courseTitle: p.courseTitle,
          );
        }
        return p;
      }).toList();

      state = state.copyWith(
        permissions: updatedPermissions,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to approve permission: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Deny a permission request
  Future<bool> denyPermission(
    String permissionId,
    String denialReason,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.denyPermission(permissionId, denialReason);

      // Update in local state
      final updatedPermissions = state.permissions.map((p) {
        if (p.id == permissionId) {
          return EnrollmentPermission(
            id: p.id,
            studentId: p.studentId,
            courseId: p.courseId,
            institutionId: p.institutionId,
            status: PermissionStatus.denied,
            grantedBy: p.grantedBy,
            grantedByUserId: p.grantedByUserId,
            reviewedAt: DateTime.now(),
            denialReason: denialReason,
            createdAt: p.createdAt,
            updatedAt: DateTime.now(),
            studentEmail: p.studentEmail,
            studentDisplayName: p.studentDisplayName,
            courseTitle: p.courseTitle,
          );
        }
        return p;
      }).toList();

      state = state.copyWith(
        permissions: updatedPermissions,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to deny permission: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Revoke a permission
  Future<bool> revokePermission(
    String permissionId, {
    String? reason,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _apiService.revokePermission(permissionId, reason: reason);

      // Update in local state
      final updatedPermissions = state.permissions.map((p) {
        if (p.id == permissionId) {
          return EnrollmentPermission(
            id: p.id,
            studentId: p.studentId,
            courseId: p.courseId,
            institutionId: p.institutionId,
            status: PermissionStatus.revoked,
            grantedBy: p.grantedBy,
            grantedByUserId: p.grantedByUserId,
            reviewedAt: DateTime.now(),
            denialReason: reason,
            createdAt: p.createdAt,
            updatedAt: DateTime.now(),
            studentEmail: p.studentEmail,
            studentDisplayName: p.studentDisplayName,
            courseTitle: p.courseTitle,
          );
        }
        return p;
      }).toList();

      state = state.copyWith(
        permissions: updatedPermissions,
        isLoading: false,
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to revoke permission: ${e.toString()}',
        isLoading: false,
      );
      return false;
    }
  }

  /// Filter by status
  Future<void> filterByStatus(PermissionStatus? status) async {
    state = state.copyWith(
      filterStatus: status,
      clearFilter: status == null,
    );
    await fetchPermissions();
  }

  /// Load more permissions (pagination)
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    await fetchPermissions(loadMore: true);
  }

  /// Refresh permissions
  Future<void> refresh() async {
    await fetchPermissions();
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for enrollment permissions for a specific course
final enrollmentPermissionsProvider = StateNotifierProvider.family<
    EnrollmentPermissionsNotifier,
    EnrollmentPermissionsState,
    String>((ref, courseId) {
  return EnrollmentPermissionsNotifier(ref, courseId);
});
