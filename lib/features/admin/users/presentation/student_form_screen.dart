// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';

/// Student Form Screen - Create or edit student accounts
///
/// Features:
/// - Create new student accounts
/// - Edit existing student accounts
/// - Form validation
/// - Multiple sections: Personal Info, Academic Info, Contact Info
/// - Save/Cancel actions
class StudentFormScreen extends ConsumerStatefulWidget {
  final String? studentId; // null for create, populated for edit

  const StudentFormScreen({
    super.key,
    this.studentId,
  });

  @override
  ConsumerState<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends ConsumerState<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  String _selectedGrade = '9';
  String _selectedGender = 'male';
  String _selectedStatus = 'active';
  bool _isLoading = false;
  bool _emailVerified = false;
  bool _phoneVerified = false;

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) {
      _loadStudentData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  void _loadStudentData() {
    // TODO: Load student data from provider
    // For now, populate with mock data for edit mode
    _firstNameController.text = 'Amina';
    _lastNameController.text = 'Hassan';
    _emailController.text = 'amina.hassan@example.com';
    _phoneController.text = '+254 712 345 678';
    _dateOfBirthController.text = '2005-03-15';
    _addressController.text = '123 Main Street';
    _cityController.text = 'Nairobi';
    _countryController.text = 'Kenya';
    _selectedGrade = '11';
    _selectedGender = 'female';
    _selectedStatus = 'active';
    _emailVerified = true;
    _phoneVerified = true;
  }

  Future<void> _saveStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Save student data via provider
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (!mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.studentId == null
              ? context.l10n.adminUserFormStudentCreatedSuccess
              : context.l10n.adminUserFormStudentUpdatedSuccess,
        ),
        backgroundColor: AppColors.success,
      ),
    );

    // Navigate back to list
    context.go('/admin/users/students');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.studentId != null;

    // Content is wrapped by AdminShell via ShellRoute
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          // Breadcrumb Navigation
          _buildBreadcrumb(isEditMode),
          const SizedBox(height: 24),

          // Form Content
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
                      // Page Header
                      _buildHeader(isEditMode),
                      const SizedBox(height: 32),

                      // Personal Information Section
                      _buildSection(
                        context.l10n.adminUserFormPersonalInformation,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFormFirstName,
                                  controller: _firstNameController,
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.l10n.adminUserFormFirstNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFormLastName,
                                  controller: _lastNameController,
                                  required: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.l10n.adminUserFormLastNameRequired;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFormEmail,
                                  controller: _emailController,
                                  required: true,
                                  keyboardType: TextInputType.emailAddress,
                                  suffix: _emailVerified
                                      ? Icon(Icons.verified, color: AppColors.success, size: 20)
                                      : null,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return context.l10n.adminUserFormEmailRequired;
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value)) {
                                      return context.l10n.adminUserFormEmailInvalid;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFormPhone,
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  suffix: _phoneVerified
                                      ? Icon(Icons.verified, color: AppColors.success, size: 20)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserFormGender,
                                  value: _selectedGender,
                                  items: [
                                    DropdownMenuItem(value: 'male', child: Text(context.l10n.adminUserFormGenderMale)),
                                    DropdownMenuItem(value: 'female', child: Text(context.l10n.adminUserFormGenderFemale)),
                                    DropdownMenuItem(value: 'other', child: Text(context.l10n.adminUserFormGenderOther)),
                                    DropdownMenuItem(
                                        value: 'prefer_not_to_say',
                                        child: Text(context.l10n.adminUserFormGenderPreferNotToSay)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedGender = value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminUserFormDateOfBirth,
                                  controller: _dateOfBirthController,
                                  hintText: context.l10n.adminUserFormDateFormat,
                                  suffix: IconButton(
                                    icon: const Icon(Icons.calendar_today, size: 20),
                                    onPressed: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime(2005),
                                        firstDate: DateTime(1990),
                                        lastDate: DateTime.now(),
                                      );
                                      if (date != null) {
                                        _dateOfBirthController.text =
                                            date.toString().split(' ')[0];
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Academic Information Section
                      _buildSection(
                        context.l10n.adminUserFormAcademicInformation,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserFormGrade,
                                  value: _selectedGrade,
                                  required: true,
                                  items: [
                                    DropdownMenuItem(value: '9', child: Text(context.l10n.adminUserFormGrade9)),
                                    DropdownMenuItem(value: '10', child: Text(context.l10n.adminUserFormGrade10)),
                                    DropdownMenuItem(value: '11', child: Text(context.l10n.adminUserFormGrade11)),
                                    DropdownMenuItem(value: '12', child: Text(context.l10n.adminUserFormGrade12)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedGrade = value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserFormStatus,
                                  value: _selectedStatus,
                                  required: true,
                                  items: [
                                    DropdownMenuItem(value: 'active', child: Text(context.l10n.adminUserFormStatusActive)),
                                    DropdownMenuItem(
                                        value: 'inactive', child: Text(context.l10n.adminUserFormStatusInactive)),
                                    DropdownMenuItem(
                                        value: 'suspended', child: Text(context.l10n.adminUserFormStatusSuspended)),
                                    DropdownMenuItem(
                                        value: 'pending', child: Text(context.l10n.adminUserFormStatusPendingVerification)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedStatus = value);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Contact Information Section
                      _buildSection(
                        'Contact Information',
                        [
                          _buildTextField(
                            label: 'Address',
                            controller: _addressController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'City',
                                  controller: _cityController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Country',
                                  controller: _countryController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons
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

  Widget _buildBreadcrumb(bool isEditMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => context.go('/admin/users/students'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.adminUserFormBackToStudents),
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
          isEditMode ? context.l10n.adminUserFormEditStudent : context.l10n.adminUserFormAddNewStudent,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? context.l10n.adminUserFormUpdateStudentInfo
              : context.l10n.adminUserFormCreateStudentAccount,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
    int maxLines = 1,
    Widget? suffix,
    String? Function(String?)? validator,
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
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
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
            onPressed: _isLoading ? null : () => context.go('/admin/users/students'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PermissionGuard(
            permission: AdminPermission.editUsers,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveStudent,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(isEditMode ? 'Update Student' : 'Create Student'),
            ),
          ),
        ),
      ],
    );
  }
}
