import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../providers/admin_auth_provider.dart';

/// Permission Guard - Conditionally renders widgets based on admin permissions
///
/// Usage:
/// ```dart
/// PermissionGuard(
///   permission: AdminPermission.deleteUsers,
///   child: IconButton(
///     icon: Icon(Icons.delete),
///     onPressed: () => deleteUser(),
///   ),
/// )
/// ```
class PermissionGuard extends ConsumerWidget {
  final AdminPermission permission;
  final Widget child;
  final Widget? fallback;
  final bool requireAll; // For multiple permissions

  const PermissionGuard({
    required this.permission,
    required this.child,
    this.fallback,
    this.requireAll = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminUser = ref.watch(currentAdminUserProvider);

    if (adminUser?.hasPermission(permission) ?? false) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Multi-Permission Guard - Check multiple permissions
class MultiPermissionGuard extends ConsumerWidget {
  final List<AdminPermission> permissions;
  final Widget child;
  final Widget? fallback;
  final bool requireAll; // true = AND, false = OR

  const MultiPermissionGuard({
    required this.permissions,
    required this.child,
    this.fallback,
    this.requireAll = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminUser = ref.watch(currentAdminUserProvider);

    if (adminUser == null) {
      return fallback ?? const SizedBox.shrink();
    }

    final hasPermission = requireAll
        ? adminUser.hasAllPermissions(permissions)
        : adminUser.hasAnyPermission(permissions);

    if (hasPermission) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Role Guard - Check if user has specific admin role
class RoleGuard extends ConsumerWidget {
  final List<UserRole> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleGuard({
    required this.allowedRoles,
    required this.child,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adminUser = ref.watch(currentAdminUserProvider);

    if (adminUser != null && allowedRoles.contains(adminUser.adminRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Hierarchy Guard - Check if current admin can manage a target admin role
/// This prevents lower-level admins from managing higher-level admins
///
/// Hierarchy rules:
/// - Super Admin (level 3) can manage all roles
/// - Regional Admin (level 2) can manage Specialized Admins and regular users
/// - Specialized Admins (level 1) cannot manage any admin roles
///
/// Usage:
/// ```dart
/// HierarchyGuard(
///   targetRole: UserRole.superAdmin,
///   child: IconButton(
///     icon: Icon(Icons.edit),
///     onPressed: () => editAdmin(),
///   ),
/// )
/// ```
class HierarchyGuard extends ConsumerWidget {
  final UserRole targetRole;
  final Widget child;
  final Widget? fallback;

  const HierarchyGuard({
    required this.targetRole,
    required this.child,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAdmin = ref.watch(currentAdminUserProvider);

    // If no current admin, hide the widget
    if (currentAdmin == null) {
      return fallback ?? const SizedBox.shrink();
    }

    // Check if current admin can manage the target role
    if (currentAdmin.adminRole.canManage(targetRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
