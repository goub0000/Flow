import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
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
              ? 'Institution created successfully'
              : 'Institution updated successfully',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/admin/users/institutions');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.institutionId != null;

    return AdminShell(
      child: Column(
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
                        'Institution Information',
                        [
                          _buildTextField(
                            label: 'Institution Name',
                            controller: _institutionNameController,
                            required: true,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Type',
                                  value: _selectedType,
                                  required: true,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'university', child: Text('University')),
                                    DropdownMenuItem(
                                        value: 'college', child: Text('College')),
                                    DropdownMenuItem(
                                        value: 'vocational',
                                        child: Text('Vocational School')),
                                    DropdownMenuItem(
                                        value: 'language',
                                        child: Text('Language School')),
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
                                  label: 'Status',
                                  value: _selectedStatus,
                                  required: true,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'pending', child: Text('Pending Approval')),
                                    DropdownMenuItem(
                                        value: 'verified', child: Text('Verified')),
                                    DropdownMenuItem(
                                        value: 'active', child: Text('Active')),
                                    DropdownMenuItem(
                                        value: 'rejected', child: Text('Rejected')),
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
                                  label: 'Email',
                                  controller: _emailController,
                                  required: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) return 'Required';
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return 'Invalid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Phone',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Website',
                            controller: _websiteController,
                            keyboardType: TextInputType.url,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Location',
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
                      _buildSection(
                        'Contact Person',
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Full Name',
                                  controller: _contactPersonController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Position',
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
                                  label: 'Email',
                                  controller: _contactEmailController,
                                  required: true,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) return 'Required';
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value!)) {
                                      return 'Invalid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Phone',
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
      ),
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
            label: const Text('Back to Institutions'),
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
          isEditMode ? 'Edit Institution' : 'Add New Institution',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? 'Update institution account information'
              : 'Create a new institution account',
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
            child: const Text('Cancel'),
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
                  : Text(isEditMode ? 'Update Institution' : 'Create Institution'),
            ),
          ),
        ),
      ],
    );
  }
}
