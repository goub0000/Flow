import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';

/// Counselor Form Screen - Create or edit counselor accounts
class CounselorFormScreen extends ConsumerStatefulWidget {
  final String? counselorId;

  const CounselorFormScreen({
    super.key,
    this.counselorId,
  });

  @override
  ConsumerState<CounselorFormScreen> createState() =>
      _CounselorFormScreenState();
}

class _CounselorFormScreenState extends ConsumerState<CounselorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _credentialsController = TextEditingController();
  final _licenseController = TextEditingController();
  final _experienceController = TextEditingController();
  final _officeLocationController = TextEditingController();
  final _availabilityController = TextEditingController();

  String _selectedSpecialty = 'academic';
  String _selectedStatus = 'active';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.counselorId != null) {
      _loadCounselorData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _credentialsController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _officeLocationController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _loadCounselorData() {
    // TODO: Load counselor data from provider
    _firstNameController.text = 'Dr. Sarah';
    _lastNameController.text = 'Johnson';
    _emailController.text = 'sarah.johnson@example.com';
    _phoneController.text = '+254 712 345 678';
    _credentialsController.text = 'M.A. Counseling Psychology';
    _licenseController.text = 'LPC-12345678';
    _experienceController.text = '8';
    _officeLocationController.text = 'Building A, Room 203';
    _availabilityController.text = 'Mon-Fri, 9AM-5PM';
    _selectedSpecialty = 'academic';
    _selectedStatus = 'active';
  }

  Future<void> _saveCounselor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.counselorId == null
              ? context.l10n.adminUserCounselorCreatedSuccess
              : context.l10n.adminUserCounselorUpdatedSuccess,
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/admin/users/counselors');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.counselorId != null;

    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          _buildBreadcrumb(),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isEditMode),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminUserPersonalInformation,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFirstName,
                                  controller: _firstNameController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? context.l10n.adminUserRequired : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserLastName,
                                  controller: _lastNameController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? context.l10n.adminUserRequired : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserEmail,
                                  controller: _emailController,
                                  required: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) return context.l10n.adminUserRequired;
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return context.l10n.adminUserInvalidEmail;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserPhone,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminUserProfessionalInformation,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserSpecialty,
                                  value: _selectedSpecialty,
                                  required: true,
                                  items: [
                                    DropdownMenuItem(
                                        value: 'academic',
                                        child: Text(context.l10n.adminUserAcademicCounseling)),
                                    DropdownMenuItem(
                                        value: 'career',
                                        child: Text(context.l10n.adminUserCareerGuidance)),
                                    DropdownMenuItem(
                                        value: 'college',
                                        child: Text(context.l10n.adminUserCollegeAdmissions)),
                                    DropdownMenuItem(
                                        value: 'mental',
                                        child: Text(context.l10n.adminUserMentalHealth)),
                                    DropdownMenuItem(
                                        value: 'study',
                                        child: Text(context.l10n.adminUserStudySkills)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedSpecialty = value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserYearsOfExperience,
                                  controller: _experienceController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserCredentials,
                                  controller: _credentialsController,
                                  hintText: context.l10n.adminUserCredentialsHint,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserLicenseNumber,
                                  controller: _licenseController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminUserContactAndAvailability,
                        [
                          _buildTextField(
                            label: context.l10n.adminUserOfficeLocation,
                            controller: _officeLocationController,
                            hintText: context.l10n.adminUserOfficeLocationHint,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: context.l10n.adminUserAvailability,
                            controller: _availabilityController,
                            hintText: context.l10n.adminUserAvailabilityHint,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminUserAccountSettings,
                        [
                          _buildDropdown(
                            label: context.l10n.adminUserStatus,
                            value: _selectedStatus,
                            required: true,
                            items: [
                              DropdownMenuItem(value: 'active', child: Text(context.l10n.adminUserActive)),
                              DropdownMenuItem(
                                  value: 'inactive', child: Text(context.l10n.adminUserInactive)),
                              DropdownMenuItem(
                                  value: 'suspended', child: Text(context.l10n.adminUserSuspended)),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedStatus = value);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildActionButtons(isEditMode),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
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
            label: Text(context.l10n.adminUserBackToCounselors),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isEditMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEditMode ? context.l10n.adminUserEditCounselor : context.l10n.adminUserAddNewCounselor,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? context.l10n.adminUserUpdateCounselorSubtitle
              : context.l10n.adminUserCreateCounselorSubtitle,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
      ],
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
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool required = false,
    String? hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            if (required)
              Text(' *', style: TextStyle(color: AppColors.error, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            if (required)
              Text(' *', style: TextStyle(color: AppColors.error, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(bool isEditMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed:
                _isLoading ? null : () => context.go('/admin/users/counselors'),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(context.l10n.adminUserCancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PermissionGuard(
            permission: AdminPermission.editUsers,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveCounselor,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(isEditMode ? context.l10n.adminUserUpdateCounselor : context.l10n.adminUserCreateCounselor),
            ),
          ),
        ),
      ],
    );
  }
}
