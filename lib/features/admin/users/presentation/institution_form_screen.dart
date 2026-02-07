// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/l10n_extension.dart';
import '../../../../core/constants/admin_permissions.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';

/// Institution Form Screen - Create or edit institution accounts
class InstitutionFormScreen extends ConsumerStatefulWidget {
  final String? institutionId;

  const InstitutionFormScreen({
    super.key,
    this.institutionId,
  });

  @override
  ConsumerState<InstitutionFormScreen> createState() =>
      _InstitutionFormScreenState();
}

class _InstitutionFormScreenState extends ConsumerState<InstitutionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _institutionNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactPositionController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  String _selectedType = 'university';
  String _selectedStatus = 'pending';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.institutionId != null) {
      _loadInstitutionData();
    }
  }

  @override
  void dispose() {
    _institutionNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _contactPersonController.dispose();
    _contactPositionController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  void _loadInstitutionData() {
    // TODO: Load institution data from provider
    _institutionNameController.text = 'University of Nairobi';
    _emailController.text = 'admissions@uonbi.ac.ke';
    _phoneController.text = '+254 20 491 8000';
    _websiteController.text = 'www.uonbi.ac.ke';
    _addressController.text = 'University Way';
    _cityController.text = 'Nairobi';
    _countryController.text = 'Kenya';
    _contactPersonController.text = 'Dr. John Kamau';
    _contactPositionController.text = 'Admissions Director';
    _contactEmailController.text = 'j.kamau@uonbi.ac.ke';
    _contactPhoneController.text = '+254 712 345 678';
    _selectedType = 'university';
    _selectedStatus = 'verified';
  }

  Future<void> _saveInstitution() async {
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
          widget.institutionId == null
              ? context.l10n.adminUserInstitutionCreatedSuccess
              : context.l10n.adminUserInstitutionUpdatedSuccess,
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/admin/users/institutions');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.institutionId != null;

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
                        context.l10n.adminUserInstitutionInformation,
                        [
                          _buildTextField(
                            label: context.l10n.adminUserInstitutionName,
                            controller: _institutionNameController,
                            required: true,
                            validator: (value) =>
                                value?.isEmpty ?? true ? context.l10n.adminUserRequired : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserType,
                                  value: _selectedType,
                                  required: true,
                                  items: [
                                    DropdownMenuItem(
                                        value: 'university', child: Text(context.l10n.adminUserUniversity)),
                                    DropdownMenuItem(
                                        value: 'college', child: Text(context.l10n.adminUserCollege)),
                                    DropdownMenuItem(
                                        value: 'vocational',
                                        child: Text(context.l10n.adminUserVocationalSchool)),
                                    DropdownMenuItem(
                                        value: 'language',
                                        child: Text(context.l10n.adminUserLanguageSchool)),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedType = value);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: context.l10n.adminUserStatus,
                                  value: _selectedStatus,
                                  required: true,
                                  items: [
                                    DropdownMenuItem(
                                        value: 'pending', child: Text(context.l10n.adminUserPendingApproval)),
                                    DropdownMenuItem(
                                        value: 'verified', child: Text(context.l10n.adminUserVerified)),
                                    DropdownMenuItem(
                                        value: 'active', child: Text(context.l10n.adminUserActive)),
                                    DropdownMenuItem(
                                        value: 'rejected', child: Text(context.l10n.adminUserRejected)),
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
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: context.l10n.adminUserWebsite,
                            controller: _websiteController,
                            keyboardType: TextInputType.url,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminInstitutionLocation,
                        [
                          _buildTextField(
                            label: context.l10n.adminInstitutionAddress,
                            controller: _addressController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionCity,
                                  controller: _cityController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionCountry,
                                  controller: _countryController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        context.l10n.adminInstitutionContactPerson,
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionFullName,
                                  controller: _contactPersonController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? context.l10n.adminInstitutionRequired : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionPosition,
                                  controller: _contactPositionController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionContactEmail,
                                  controller: _contactEmailController,
                                  required: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) return context.l10n.adminInstitutionRequired;
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return context.l10n.adminInstitutionInvalidEmail;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: context.l10n.adminInstitutionContactPhone,
                                  controller: _contactPhoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
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
            onPressed: () => context.go('/admin/users/institutions'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.adminInstitutionBackToInstitutions),
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
          isEditMode ? context.l10n.adminInstitutionEditInstitution : context.l10n.adminInstitutionAddNewInstitution,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? context.l10n.adminInstitutionUpdateAccountInfo
              : context.l10n.adminInstitutionCreateAccountInfo,
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
    int maxLines = 1,
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
          maxLines: maxLines,
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
            onPressed: _isLoading
                ? null
                : () => context.go('/admin/users/institutions'),
            style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(context.l10n.adminInstitutionCancel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PermissionGuard(
            permission: AdminPermission.editInstitutions,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveInstitution,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(isEditMode ? context.l10n.adminInstitutionUpdateInstitution : context.l10n.adminInstitutionCreateInstitution),
            ),
          ),
        ),
      ],
    );
  }
}
