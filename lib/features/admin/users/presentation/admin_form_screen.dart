import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';
import '../../shared/providers/admin_auth_provider.dart';

/// Admin Form Screen - Create or edit admin accounts
///
/// Features:
/// - Create new admin accounts (Super Admin, Regional, Content, Support, Finance, Analytics)
/// - Edit existing admin accounts
/// - Form validation
/// - Password requirements (create only)
/// - Role selection with hierarchy enforcement
class AdminFormScreen extends ConsumerStatefulWidget {
  final String? adminId; // null for create, populated for edit

  const AdminFormScreen({super.key, this.adminId});

  @override
  ConsumerState<AdminFormScreen> createState() => _AdminFormScreenState();
}

class _AdminFormScreenState extends ConsumerState<AdminFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _regionalScopeController = TextEditingController();

  UserRole _selectedRole = UserRole.supportAdmin;
  bool _isActive = true;
  bool _isLoading = false;
  bool _isLoadingData = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get isEditMode => widget.adminId != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadAdminData();
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _regionalScopeController.dispose();
    super.dispose();
  }

  Future<void> _loadAdminData() async {
    setState(() => _isLoadingData = true);

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get('/admin/users/admins/${widget.adminId}');

      if (!mounted) return;

      if (response.success && response.data != null) {
        final admin = response.data['admin'] as Map<String, dynamic>?;
        if (admin != null) {
          _fullNameController.text = admin['display_name'] ?? '';
          _emailController.text = admin['email'] ?? '';
          _phoneController.text = admin['phone_number'] ?? '';
          _regionalScopeController.text = admin['regional_scope'] ?? '';
          _isActive = admin['is_active'] ?? true;

          final roleStr = admin['admin_role'] as String?;
          if (roleStr != null) {
            _selectedRole = UserRole.values.firstWhere(
              (r) => UserRoleHelper.getRoleName(r) == roleStr,
              orElse: () => UserRole.supportAdmin,
            );
          }
          setState(() {});
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? context.l10n.adminUserFailedLoadData),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminUserErrorLoadingData(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingData = false);
      }
    }
  }

  Future<void> _saveAdmin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate passwords match (create mode only)
    if (!isEditMode && _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminUserPasswordsDoNotMatch),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiClient = ref.read(apiClientProvider);

      // Map UserRole enum to the backend string
      final adminRoleStr = UserRoleHelper.getRoleName(_selectedRole);

      if (isEditMode) {
        // Update existing admin
        final body = <String, dynamic>{
          'display_name': _fullNameController.text.trim(),
          'admin_role': adminRoleStr,
          'is_active': _isActive,
        };

        if (_phoneController.text.trim().isNotEmpty) {
          body['phone_number'] = _phoneController.text.trim();
        }

        if (_selectedRole == UserRole.regionalAdmin &&
            _regionalScopeController.text.trim().isNotEmpty) {
          body['regional_scope'] = _regionalScopeController.text.trim();
        }

        final response = await apiClient.put(
          '/admin/users/admins/${widget.adminId}',
          data: body,
        );

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.adminUserAccountUpdatedSuccess),
              backgroundColor: AppColors.success,
            ),
          );
          context.go('/admin/system/admins');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? context.l10n.adminUserFailedUpdateAccount),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } else {
        // Create new admin
        final body = <String, dynamic>{
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
          'display_name': _fullNameController.text.trim(),
          'admin_role': adminRoleStr,
        };

        if (_phoneController.text.trim().isNotEmpty) {
          body['phone_number'] = _phoneController.text.trim();
        }

        if (_selectedRole == UserRole.regionalAdmin &&
            _regionalScopeController.text.trim().isNotEmpty) {
          body['regional_scope'] = _regionalScopeController.text.trim();
        }

        final response = await apiClient.post(
          '/admin/users/admins',
          data: body,
        );

        setState(() => _isLoading = false);

        if (!mounted) return;

        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.adminUserAccountCreatedSuccess(_emailController.text.trim())),
              backgroundColor: AppColors.success,
            ),
          );
          context.go('/admin/system/admins');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message ?? context.l10n.adminUserFailedCreateAccount),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.adminUserError(e.toString())),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          TextButton(
            onPressed: () => context.go('/admin'),
            child: Text(context.l10n.adminUserDashboard),
          ),
          const Icon(Icons.chevron_right, size: 16),
          TextButton(
            onPressed: () => context.go('/admin/system/admins'),
            child: Text(context.l10n.adminUserAdmins),
          ),
          const Icon(Icons.chevron_right, size: 16),
          Text(
            isEditMode ? context.l10n.adminUserEdit : context.l10n.adminUserCreate,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
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
              isEditMode ? Icons.edit : Icons.admin_panel_settings,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? context.l10n.adminUserEditAdminAccount : context.l10n.adminUserCreateAdminAccount,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditMode
                      ? context.l10n.adminUserUpdateAdminSubtitle
                      : context.l10n.adminUserCreateAdminSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? helperText,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: AppColors.error),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            suffixIcon: suffixIcon,
            helperText: helperText,
            helperMaxLines: 2,
          ),
          enabled: enabled && !_isLoading,
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    final currentAdmin = ref.watch(currentAdminUserProvider);
    final isSuperAdmin = currentAdmin?.adminRole == UserRole.superAdmin;

    // Regional admins can only create lower-level admins (not super or regional)
    final adminRoles = isSuperAdmin
        ? [
            UserRole.superAdmin,
            UserRole.regionalAdmin,
            UserRole.contentAdmin,
            UserRole.supportAdmin,
            UserRole.financeAdmin,
            UserRole.analyticsAdmin,
          ]
        : [
            UserRole.contentAdmin,
            UserRole.supportAdmin,
            UserRole.financeAdmin,
            UserRole.analyticsAdmin,
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.adminUserAdminRole,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: AppColors.error),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<UserRole>(
          value: _selectedRole,
          decoration: InputDecoration(
            hintText: context.l10n.adminUserSelectAdminRole,
            helperText: context.l10n.adminUserChooseRoleHelperText,
          ),
          items: adminRoles.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.getAdminRoleColor(role),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(role.displayName),
                ],
              ),
            );
          }).toList(),
          onChanged: _isLoading
              ? null
              : (role) {
                  setState(() => _selectedRole = role!);
                },
        ),
      ],
    );
  }

  Widget _buildStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isActive
            ? AppColors.success.withValues(alpha: 0.05)
            : AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isActive
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isActive ? Icons.check_circle : Icons.block,
            color: _isActive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.adminUserAccountStatus,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _isActive
                      ? context.l10n.adminUserAccountActiveDesc
                      : context.l10n.adminUserAccountInactiveDesc,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: _isLoading
                ? null
                : (value) => setState(() => _isActive = value),
            activeColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return const Center(child: CircularProgressIndicator());
    }

    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          _buildBreadcrumb(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // Admin Information
                      _buildSection(
                        context.l10n.adminUserAdminInformation,
                        [
                          _buildTextField(
                            label: context.l10n.adminUserFullName,
                            controller: _fullNameController,
                            required: true,
                            validator: Validators.fullName,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: context.l10n.adminUserEmail,
                            controller: _emailController,
                            required: true,
                            validator: Validators.email,
                            keyboardType: TextInputType.emailAddress,
                            helperText: isEditMode
                                ? context.l10n.adminUserEmailCannotBeChanged
                                : context.l10n.adminUserEmailLoginHelper,
                            enabled: !isEditMode,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: context.l10n.adminUserPhoneNumber,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            helperText: context.l10n.adminUserPhoneHelper,
                          ),
                          const SizedBox(height: 16),
                          _buildRoleDropdown(),
                          if (_selectedRole == UserRole.regionalAdmin) ...[
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: context.l10n.adminUserRegionalScope,
                              controller: _regionalScopeController,
                              required: true,
                              validator: (value) =>
                                  value?.isEmpty ?? true ? context.l10n.adminUserRequiredForRegional : null,
                              helperText: context.l10n.adminUserRegionalScopeHelper,
                            ),
                          ],
                          if (isEditMode) ...[
                            const SizedBox(height: 16),
                            _buildStatusToggle(),
                          ],
                        ],
                      ),

                      // Password section (create mode only)
                      if (!isEditMode) ...[
                        const SizedBox(height: 24),
                        _buildSection(
                          context.l10n.adminUserSecuritySettings,
                          [
                            _buildTextField(
                              label: context.l10n.adminUserPassword,
                              controller: _passwordController,
                              required: true,
                              validator: Validators.password,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              helperText: context.l10n.adminUserPasswordHelper,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              label: context.l10n.adminUserConfirmPassword,
                              controller: _confirmPasswordController,
                              required: true,
                              obscureText: _obscureConfirmPassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.l10n.adminUserPleaseConfirmPassword;
                                }
                                if (value != _passwordController.text) {
                                  return context.l10n.adminUserPasswordsDoNotMatch;
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 32),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => context.go('/admin/system/admins'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: Text(context.l10n.adminUserCancel),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveAdmin,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(isEditMode ? Icons.save : Icons.person_add, size: 20),
                                        const SizedBox(width: 8),
                                        Text(isEditMode ? context.l10n.adminUserSaveChanges : context.l10n.adminUserCreateAdminAccount),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }
}
