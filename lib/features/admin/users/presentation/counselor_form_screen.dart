import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../shared/widgets/admin_shell.dart';
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
              ? 'Counselor created successfully'
              : 'Counselor updated successfully',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/admin/users/counselors');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.counselorId != null;

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
                        'Personal Information',
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'First Name',
                                  controller: _firstNameController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Last Name',
                                  controller: _lastNameController,
                                  required: true,
                                  validator: (value) =>
                                      value?.isEmpty ?? true ? 'Required' : null,
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
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Professional Information',
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Specialty',
                                  value: _selectedSpecialty,
                                  required: true,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'academic',
                                        child: Text('Academic Counseling')),
                                    DropdownMenuItem(
                                        value: 'career',
                                        child: Text('Career Guidance')),
                                    DropdownMenuItem(
                                        value: 'college',
                                        child: Text('College Admissions')),
                                    DropdownMenuItem(
                                        value: 'mental',
                                        child: Text('Mental Health')),
                                    DropdownMenuItem(
                                        value: 'study',
                                        child: Text('Study Skills')),
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
                                  label: 'Years of Experience',
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
                                  label: 'Credentials',
                                  controller: _credentialsController,
                                  hintText: 'e.g., M.A. Counseling Psychology',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'License Number',
                                  controller: _licenseController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Contact & Availability',
                        [
                          _buildTextField(
                            label: 'Office Location',
                            controller: _officeLocationController,
                            hintText: 'e.g., Building A, Room 203',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Availability',
                            controller: _availabilityController,
                            hintText: 'e.g., Mon-Fri, 9AM-5PM',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Account Settings',
                        [
                          _buildDropdown(
                            label: 'Status',
                            value: _selectedStatus,
                            required: true,
                            items: const [
                              DropdownMenuItem(value: 'active', child: Text('Active')),
                              DropdownMenuItem(
                                  value: 'inactive', child: Text('Inactive')),
                              DropdownMenuItem(
                                  value: 'suspended', child: Text('Suspended')),
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
      ),
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
            label: const Text('Back to Counselors'),
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
          isEditMode ? 'Edit Counselor' : 'Add New Counselor',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? 'Update counselor account information'
              : 'Create a new counselor account',
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
            child: const Text('Cancel'),
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
                  : Text(isEditMode ? 'Update Counselor' : 'Create Counselor'),
            ),
          ),
        ),
      ],
    );
  }
}
