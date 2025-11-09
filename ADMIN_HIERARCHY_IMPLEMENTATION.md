# Admin Hierarchy Implementation

## Overview

The Flow EdTech platform implements a strict admin hierarchy system to ensure that lower-level admins cannot manage or view higher-level admins. This document outlines the hierarchy structure, implementation details, and testing guidelines.

## Hierarchy Levels

### Level 3: Super Admin (Highest Authority)
- **Role**: `UserRole.superAdmin`
- **Hierarchy Level**: 3
- **Can Manage**:
  - All other Super Admins
  - All Regional Admins
  - All Specialized Admins (Content, Support, Finance, Analytics)
  - All regular users (Students, Institutions, Parents, Counselors, Recommenders)
- **Permissions**: ALL permissions in the system
- **Visibility**: Can see and manage ALL users in the system

### Level 2: Regional Admin (Regional Authority)
- **Role**: `UserRole.regionalAdmin`
- **Hierarchy Level**: 2
- **Can Manage**:
  - Specialized Admins (Content, Support, Finance, Analytics) in their region
  - Regular users in their region
- **Cannot Manage**:
  - Super Admins
  - Other Regional Admins
- **Permissions**: Regional-scoped permissions (see `AdminPermissions.regionalAdmin()`)
- **Visibility**: Cannot see Super Admins or other Regional Admins in user lists

### Level 1: Specialized Admins (Functional Authority)
- **Roles**:
  - `UserRole.contentAdmin` - Content and curriculum management
  - `UserRole.supportAdmin` - User support and issue resolution
  - `UserRole.financeAdmin` - Payment processing and financial management
  - `UserRole.analyticsAdmin` - Data analysis and reporting
- **Hierarchy Level**: 1
- **Can Manage**:
  - Regular users only (within their functional scope)
- **Cannot Manage**:
  - Super Admins
  - Regional Admins
  - Other Specialized Admins
- **Permissions**: Function-specific permissions (see respective factory methods in `AdminPermissions`)
- **Visibility**: Cannot see any admin users in user management screens

## Implementation Details

### 1. Core Hierarchy Logic (`user_roles.dart`)

The hierarchy is implemented in the `UserRoleExtension` with the following key methods:

```dart
/// Get numeric hierarchy level (higher number = higher authority)
int get hierarchyLevel {
  switch (this) {
    case UserRole.superAdmin: return 3;
    case UserRole.regionalAdmin: return 2;
    case UserRole.contentAdmin:
    case UserRole.supportAdmin:
    case UserRole.financeAdmin:
    case UserRole.analyticsAdmin: return 1;
    default: return 0; // Non-admin roles
  }
}

/// Check if this role can manage another role
bool canManage(UserRole targetRole) {
  // Super Admin can manage everyone
  if (this == UserRole.superAdmin) return true;

  // Regular users cannot manage anyone
  if (!isAdmin) return false;

  // Admins cannot manage other admins of equal or higher hierarchy
  if (targetRole.isAdmin) {
    return hierarchyLevel > targetRole.hierarchyLevel;
  }

  // Regional and specialized admins can manage regular users
  return true;
}
```

### 2. HierarchyGuard Widget (`permission_guard.dart`)

A new widget that conditionally renders UI based on hierarchy permissions:

```dart
HierarchyGuard(
  targetRole: UserRole.superAdmin,
  child: IconButton(
    icon: Icon(Icons.edit),
    onPressed: () => editAdmin(),
  ),
)
```

**Usage**: Wrap any admin management UI element to ensure it's only shown when the current admin can manage the target admin role.

### 3. Admin List Filtering (`admins_list_screen.dart`)

The admins list screen now filters admins based on the current user's hierarchy:

```dart
List<AdminRowData> _getFilteredAdmins() {
  final currentAdmin = ref.read(currentAdminUserProvider);

  return mockAdmins.where((admin) {
    final adminRole = UserRole.values.firstWhere(
      (r) => r.name == admin.role,
      orElse: () => UserRole.superAdmin,
    );

    // Only show admins that the current admin can manage
    if (!currentAdmin.adminRole.canManage(adminRole)) {
      return false;
    }

    // ... other filters
  }).toList();
}
```

### 4. Action Permissions

All admin management actions (edit, deactivate, bulk operations) include hierarchy checks:

```dart
onPressed: (admin) {
  final currentAdmin = ref.read(currentAdminUserProvider);
  final targetRole = UserRole.values.firstWhere(
    (r) => r.name == admin.role,
    orElse: () => UserRole.superAdmin,
  );

  if (currentAdmin.adminRole.canManage(targetRole)) {
    // Allow action
  } else {
    // Show permission denied message
  }
}
```

## Security Considerations

### Frontend Filtering
- ✅ List filtering prevents lower admins from seeing higher admins
- ✅ Action buttons are hidden/disabled based on hierarchy
- ✅ Direct action attempts show permission error messages
- ✅ Bulk operations verify hierarchy for all selected items

### Backend Verification (TODO)
⚠️ **CRITICAL**: The backend MUST also implement hierarchy checks:

```dart
// TODO in API endpoints:
// - GET /api/admin/users/admins
//   - Filter admins based on requesting admin's hierarchy level
//   - Never return admins of equal or higher level (except Super Admin)
//
// - PUT /api/admin/users/{id}
//   - Verify requesting admin can manage target admin
//   - Return 403 Forbidden if hierarchy violation
//
// - DELETE /api/admin/users/{id}
//   - Verify requesting admin can manage target admin
//   - Return 403 Forbidden if hierarchy violation
//
// - POST /api/admin/users/bulk-action
//   - Verify hierarchy for EACH item in bulk operation
//   - Return partial success with list of failed items
```

## Hierarchy Rules Summary

| Current Admin Role | Can Manage Super Admin | Can Manage Regional Admin | Can Manage Specialized Admins | Can Manage Regular Users |
|-------------------|------------------------|---------------------------|-------------------------------|--------------------------|
| Super Admin       | ✅ Yes                 | ✅ Yes                    | ✅ Yes                        | ✅ Yes                   |
| Regional Admin    | ❌ No                  | ❌ No                     | ✅ Yes                        | ✅ Yes (in region)       |
| Content Admin     | ❌ No                  | ❌ No                     | ❌ No                         | ✅ Yes (limited)         |
| Support Admin     | ❌ No                  | ❌ No                     | ❌ No                         | ✅ Yes (limited)         |
| Finance Admin     | ❌ No                  | ❌ No                     | ❌ No                         | ✅ Yes (limited)         |
| Analytics Admin   | ❌ No                  | ❌ No                     | ❌ No                         | ✅ Yes (read-only)       |

## Testing the Hierarchy

### Manual Testing Steps

1. **Test as Super Admin** (Level 3):
   - In `admin_auth_provider.dart`, set: `adminRole: UserRole.superAdmin`
   - Navigate to Admin → System → Admin Users
   - ✅ Should see ALL admin users (Super, Regional, Specialized)
   - ✅ Should be able to Edit and Deactivate ALL admins
   - ✅ Bulk operations should work on all admins

2. **Test as Regional Admin** (Level 2):
   - In `admin_auth_provider.dart`, set: `adminRole: UserRole.regionalAdmin`
   - Navigate to Admin → System → Admin Users
   - ✅ Should see ONLY Specialized Admins (Content, Support, Finance, Analytics)
   - ❌ Should NOT see Super Admins or other Regional Admins
   - ✅ Should be able to Edit and Deactivate Specialized Admins
   - ✅ Bulk operations should work only on Specialized Admins

3. **Test as Content Admin** (Level 1):
   - In `admin_auth_provider.dart`, set: `adminRole: UserRole.contentAdmin`
   - Navigate to Admin → System → Admin Users
   - ❌ Should see NO admin users at all
   - ❌ Should NOT have access to edit/deactivate any admins
   - ❌ Bulk operations should not be available

4. **Test as Support/Finance/Analytics Admin** (Level 1):
   - Same behavior as Content Admin
   - Should not see or manage any admin users

### Expected Behavior

#### Super Admin Sees:
```
Admin Users List:
- John Admin (Super Admin) ✏️ 🚫
- Sarah Manager (Regional Admin) ✏️ 🚫
- Mike Content (Content Admin) ✏️ 🚫
- Lisa Support (Support Admin) ✏️ 🚫
- David Finance (Finance Admin) ✏️ 🚫
- Emma Analytics (Analytics Admin) ✏️ 🚫
```

#### Regional Admin Sees:
```
Admin Users List:
- Mike Content (Content Admin) ✏️ 🚫
- Lisa Support (Support Admin) ✏️ 🚫
- David Finance (Finance Admin) ✏️ 🚫
- Emma Analytics (Analytics Admin) ✏️ 🚫
```

#### Specialized Admin Sees:
```
Admin Users List:
(Empty - no admins shown)
```

## Related Files

- `lib/core/constants/user_roles.dart` - Hierarchy levels and `canManage()` logic
- `lib/core/constants/admin_permissions.dart` - Permission definitions per role
- `lib/core/models/admin_user_model.dart` - Admin user model
- `lib/features/admin/shared/providers/admin_auth_provider.dart` - Current admin state
- `lib/features/admin/shared/widgets/permission_guard.dart` - HierarchyGuard widget
- `lib/features/admin/users/presentation/admins_list_screen.dart` - Admin list with filtering

## Future Enhancements

1. **Audit Logging**: Log all hierarchy violation attempts
2. **Rate Limiting**: Prevent brute force hierarchy bypass attempts
3. **MFA for Admin Actions**: Require MFA for sensitive admin operations
4. **Delegation**: Allow temporary elevation of privileges with approval
5. **Regional Scope Enforcement**: Strict region-based filtering for Regional Admins

---

**Implementation Date**: October 31, 2024
**Status**: ✅ Completed
**Security Level**: High Priority
