import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/admin_permissions.dart';
import '../../../../core/l10n_extension.dart';
// AdminShell is now provided by ShellRoute in admin_routes.dart
import '../../shared/widgets/permission_guard.dart';

/// Recommender Form Screen - Create or edit recommender accounts
class RecommenderFormScreen extends ConsumerStatefulWidget {
  final String? recommenderId;

  const RecommenderFormScreen({
    super.key,
    this.recommenderId,
  });

  @override
  ConsumerState<RecommenderFormScreen> createState() =>
      _RecommenderFormScreenState();
}

class _RecommenderFormScreenState extends ConsumerState<RecommenderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _organizationController = TextEditingController();
  final _positionController = TextEditingController();
  final _yearsAtOrgController = TextEditingController();
  final _officeController = TextEditingController();

  String _selectedType = 'teacher';
  String _selectedStatus = 'active';
  String _selectedPreferredContact = 'email';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.recommenderId != null) {
      _loadRecommenderData();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _organizationController.dispose();
    _positionController.dispose();
    _yearsAtOrgController.dispose();
    _officeController.dispose();
    super.dispose();
  }

  void _loadRecommenderData() {
    // TODO: Load recommender data from provider
    _firstNameController.text = 'Prof. Michael';
    _lastNameController.text = 'Osei';
    _emailController.text = 'michael.osei@example.com';
    _phoneController.text = '+254 712 345 678';
    _organizationController.text = 'Nairobi High School';
    _positionController.text = 'Senior Mathematics Teacher';
    _yearsAtOrgController.text = '10';
    _officeController.text = 'Building B, Room 305';
    _selectedType = 'teacher';
    _selectedStatus = 'active';
    _selectedPreferredContact = 'email';
  }

  Future<void> _saveRecommender() async {
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
          widget.recommenderId == null
              ? 'Recommender created successfully'
              : 'Recommender updated successfully',
        ),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/admin/users/recommenders');
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.recommenderId != null;

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
                                  label: 'Type',
                                  value: _selectedType,
                                  required: true,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'teacher', child: Text('Teacher')),
                                    DropdownMenuItem(
                                        value: 'professor', child: Text('Professor')),
                                    DropdownMenuItem(
                                        value: 'employer', child: Text('Employer')),
                                    DropdownMenuItem(
                                        value: 'mentor', child: Text('Mentor')),
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
                                child: _buildTextField(
                                  label: 'Years at Organization',
                                  controller: _yearsAtOrgController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Organization',
                            controller: _organizationController,
                            required: true,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Position',
                            controller: _positionController,
                            required: true,
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildSection(
                        'Contact Preferences',
                        [
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Office',
                                  controller: _officeController,
                                  hintText: 'e.g., Building B, Room 305',
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildDropdown(
                                  label: 'Preferred Contact Method',
                                  value: _selectedPreferredContact,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'email', child: Text('Email')),
                                    DropdownMenuItem(
                                        value: 'phone', child: Text('Phone')),
                                    DropdownMenuItem(
                                        value: 'both', child: Text('Either')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() => _selectedPreferredContact = value);
                                    }
                                  },
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: () => context.go('/admin/users/recommenders'),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Back to Recommenders'),
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
          isEditMode ? 'Edit Recommender' : 'Add New Recommender',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          isEditMode
              ? 'Update recommender account information'
              : 'Create a new recommender account',
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
                _isLoading ? null : () => context.go('/admin/users/recommenders'),
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
              onPressed: _isLoading ? null : _saveRecommender,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(isEditMode ? 'Update Recommender' : 'Create Recommender'),
            ),
          ),
        ),
      ],
    );
  }
}
