import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../authentication/providers/auth_provider.dart';
import '../widgets/custom_card.dart';
import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  bool _hasUnsavedChanges = false;
  bool _isSubmitting = false;
  Uint8List? _selectedPhotoBytes;
  String? _selectedPhotoFileName;

  // Basic Info Controllers (All roles)
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  // Student-specific Controllers
  final _schoolController = TextEditingController();
  final _gpaController = TextEditingController();
  final _graduationYearController = TextEditingController();
  final _majorController = TextEditingController();
  final _satScoreController = TextEditingController();
  final _actScoreController = TextEditingController();
  final _toeflController = TextEditingController();
  final _ieltsController = TextEditingController();
  final _classRankController = TextEditingController();
  final _classSizeController = TextEditingController();

  // Student Date Pickers
  DateTime? _dateOfBirth;
  String? _gender;
  String? _gradeLevel;
  String? _gpaScale;
  List<String> _activities = [];
  List<String> _honors = [];
  List<String> _apCourses = [];

  // Institution-specific Controllers
  final _institutionNameController = TextEditingController();
  final _institutionTypeController = TextEditingController();
  final _accreditationController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _websiteController = TextEditingController();
  final _establishedYearController = TextEditingController();
  List<String> _uploadedDocuments = [];

  // Parent-specific Controllers
  final _relationshipController = TextEditingController();
  final _occupationController = TextEditingController();
  final _employerController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  // Counselor-specific Controllers
  final _licenseNumberController = TextEditingController();
  final _yearsExperienceController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _educationController = TextEditingController();
  DateTime? _licenseExpiryDate;
  List<String> _certifications = [];

  // Recommender-specific Controllers
  final _titleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _linkedInController = TextEditingController();
  final _orcidController = TextEditingController();
  List<String> _expertiseAreas = [];

  // Profile completion tracking
  double _profileCompletion = 0.0;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _tabController = TabController(
      length: _getTabCount(user?.activeRole),
      vsync: this,
    );
    _loadUserData();
  }

  int _getTabCount(UserRole? role) {
    if (role == null) return 1;
    switch (role) {
      case UserRole.student:
        return 4; // Basic, Academic, Tests, Activities
      case UserRole.institution:
        return 3; // Basic, Details, Documents
      case UserRole.parent:
        return 3; // Basic, Guardian Info, Emergency
      case UserRole.counselor:
        return 3; // Basic, Professional, Credentials
      case UserRole.recommender:
        return 2; // Basic, Professional
      // Admin roles - only basic info for now
      case UserRole.superAdmin:
      case UserRole.regionalAdmin:
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return 1; // Basic only
    }
  }

  void _loadUserData() {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    _nameController.text = user.displayName ?? '';
    _emailController.text = user.email;
    _phoneController.text = user.phoneNumber ?? '';

    // Load metadata
    if (user.metadata != null) {
      final metadata = user.metadata!;
      _bioController.text = metadata['bio'] ?? '';
      _addressController.text = metadata['address'] ?? '';
      _cityController.text = metadata['city'] ?? '';
      _countryController.text = metadata['country'] ?? '';

      // Load role-specific data
      switch (user.activeRole) {
        case UserRole.student:
          _loadStudentData(metadata);
          break;
        case UserRole.institution:
          _loadInstitutionData(metadata);
          break;
        case UserRole.parent:
          _loadParentData(metadata);
          break;
        case UserRole.counselor:
          _loadCounselorData(metadata);
          break;
        // Admin roles - no additional metadata for now
        case UserRole.superAdmin:
        case UserRole.regionalAdmin:
        case UserRole.contentAdmin:
        case UserRole.supportAdmin:
        case UserRole.financeAdmin:
        case UserRole.analyticsAdmin:
          // No additional data to load for admin roles yet
          break;
        case UserRole.recommender:
          _loadRecommenderData(metadata);
          break;
      }
    }

    _calculateProfileCompletion();
  }

  void _loadStudentData(Map<String, dynamic> metadata) {
    _schoolController.text = metadata['school'] ?? '';
    _gpaController.text = metadata['gpa']?.toString() ?? '';
    _graduationYearController.text = metadata['graduationYear']?.toString() ?? '';
    _majorController.text = metadata['intendedMajor'] ?? '';
    _satScoreController.text = metadata['satScore']?.toString() ?? '';
    _actScoreController.text = metadata['actScore']?.toString() ?? '';
    _toeflController.text = metadata['toeflScore']?.toString() ?? '';
    _ieltsController.text = metadata['ieltsScore']?.toString() ?? '';
    _classRankController.text = metadata['classRank']?.toString() ?? '';
    _classSizeController.text = metadata['classSize']?.toString() ?? '';
    _gender = metadata['gender'];
    _gradeLevel = metadata['gradeLevel'];
    _gpaScale = metadata['gpaScale'] ?? '4.0';
    if (metadata['dateOfBirth'] != null) {
      _dateOfBirth = DateTime.parse(metadata['dateOfBirth']);
    }
    _activities = List<String>.from(metadata['activities'] ?? []);
    _honors = List<String>.from(metadata['honors'] ?? []);
    _apCourses = List<String>.from(metadata['apCourses'] ?? []);
  }

  void _loadInstitutionData(Map<String, dynamic> metadata) {
    _institutionNameController.text = metadata['institutionName'] ?? '';
    _institutionTypeController.text = metadata['institutionType'] ?? '';
    _accreditationController.text = metadata['accreditation'] ?? '';
    _taxIdController.text = metadata['taxId'] ?? '';
    _websiteController.text = metadata['website'] ?? '';
    _establishedYearController.text = metadata['establishedYear']?.toString() ?? '';
    _uploadedDocuments = List<String>.from(metadata['documents'] ?? []);
  }

  void _loadParentData(Map<String, dynamic> metadata) {
    _relationshipController.text = metadata['relationship'] ?? '';
    _occupationController.text = metadata['occupation'] ?? '';
    _employerController.text = metadata['employer'] ?? '';
    _emergencyContactController.text = metadata['emergencyContactName'] ?? '';
    _emergencyPhoneController.text = metadata['emergencyContactPhone'] ?? '';
  }

  void _loadCounselorData(Map<String, dynamic> metadata) {
    _licenseNumberController.text = metadata['licenseNumber'] ?? '';
    _yearsExperienceController.text = metadata['yearsExperience']?.toString() ?? '';
    _specialtiesController.text = metadata['specialties'] ?? '';
    _educationController.text = metadata['education'] ?? '';
    if (metadata['licenseExpiryDate'] != null) {
      _licenseExpiryDate = DateTime.parse(metadata['licenseExpiryDate']);
    }
    _certifications = List<String>.from(metadata['certifications'] ?? []);
  }

  void _loadRecommenderData(Map<String, dynamic> metadata) {
    _titleController.text = metadata['professionalTitle'] ?? '';
    _organizationController.text = metadata['organization'] ?? '';
    _linkedInController.text = metadata['linkedIn'] ?? '';
    _orcidController.text = metadata['orcid'] ?? '';
    _expertiseAreas = List<String>.from(metadata['expertiseAreas'] ?? []);
  }

  void _calculateProfileCompletion() {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    int totalFields = 0;
    int completedFields = 0;

    // Basic fields (all roles)
    totalFields += 7;
    if (_nameController.text.isNotEmpty) completedFields++;
    if (_emailController.text.isNotEmpty) completedFields++;
    if (_phoneController.text.isNotEmpty) completedFields++;
    if (_bioController.text.isNotEmpty) completedFields++;
    if (_addressController.text.isNotEmpty) completedFields++;
    if (_cityController.text.isNotEmpty) completedFields++;
    if (_countryController.text.isNotEmpty) completedFields++;

    // Role-specific fields
    switch (user.activeRole) {
      case UserRole.student:
        totalFields += 15;
        if (_schoolController.text.isNotEmpty) completedFields++;
        if (_gpaController.text.isNotEmpty) completedFields++;
        if (_graduationYearController.text.isNotEmpty) completedFields++;
        if (_majorController.text.isNotEmpty) completedFields++;
        if (_dateOfBirth != null) completedFields++;
        if (_gender != null) completedFields++;
        if (_gradeLevel != null) completedFields++;
        if (_classRankController.text.isNotEmpty) completedFields++;
        if (_classSizeController.text.isNotEmpty) completedFields++;
        if (_satScoreController.text.isNotEmpty) completedFields++;
        if (_actScoreController.text.isNotEmpty) completedFields++;
        if (_activities.isNotEmpty) completedFields++;
        if (_honors.isNotEmpty) completedFields++;
        if (_apCourses.isNotEmpty) completedFields++;
        if (_toeflController.text.isNotEmpty || _ieltsController.text.isNotEmpty) completedFields++;
        break;
      case UserRole.institution:
        totalFields += 6;
        if (_institutionNameController.text.isNotEmpty) completedFields++;
        if (_institutionTypeController.text.isNotEmpty) completedFields++;
        if (_accreditationController.text.isNotEmpty) completedFields++;
        if (_taxIdController.text.isNotEmpty) completedFields++;
        if (_websiteController.text.isNotEmpty) completedFields++;
        if (_uploadedDocuments.isNotEmpty) completedFields++;
        break;
      case UserRole.parent:
        totalFields += 5;
        if (_relationshipController.text.isNotEmpty) completedFields++;
        if (_occupationController.text.isNotEmpty) completedFields++;
        if (_employerController.text.isNotEmpty) completedFields++;
        if (_emergencyContactController.text.isNotEmpty) completedFields++;
        if (_emergencyPhoneController.text.isNotEmpty) completedFields++;
        break;
      case UserRole.counselor:
        totalFields += 6;
        if (_licenseNumberController.text.isNotEmpty) completedFields++;
        if (_yearsExperienceController.text.isNotEmpty) completedFields++;
        if (_specialtiesController.text.isNotEmpty) completedFields++;
        if (_educationController.text.isNotEmpty) completedFields++;
        if (_licenseExpiryDate != null) completedFields++;
        if (_certifications.isNotEmpty) completedFields++;
        break;
      case UserRole.recommender:
        totalFields += 4;
        if (_titleController.text.isNotEmpty) completedFields++;
        if (_organizationController.text.isNotEmpty) completedFields++;
        if (_linkedInController.text.isNotEmpty || _orcidController.text.isNotEmpty) completedFields++;
        if (_expertiseAreas.isNotEmpty) completedFields++;
        break;
      // Admin roles - no additional fields for now
      case UserRole.superAdmin:
      case UserRole.regionalAdmin:
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        // No additional fields to check for admin roles yet
        break;
    }

    setState(() {
      _profileCompletion = completedFields / totalFields;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _schoolController.dispose();
    _gpaController.dispose();
    _graduationYearController.dispose();
    _majorController.dispose();
    _satScoreController.dispose();
    _actScoreController.dispose();
    _toeflController.dispose();
    _ieltsController.dispose();
    _classRankController.dispose();
    _classSizeController.dispose();
    _institutionNameController.dispose();
    _institutionTypeController.dispose();
    _accreditationController.dispose();
    _taxIdController.dispose();
    _websiteController.dispose();
    _establishedYearController.dispose();
    _relationshipController.dispose();
    _occupationController.dispose();
    _employerController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _licenseNumberController.dispose();
    _yearsExperienceController.dispose();
    _specialtiesController.dispose();
    _educationController.dispose();
    _titleController.dispose();
    _organizationController.dispose();
    _linkedInController.dispose();
    _orcidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user found')),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (_hasUnsavedChanges) {
          return await _showUnsavedChangesDialog();
        }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Edit Profile',
          actions: [
            TextButton(
              onPressed: _isSubmitting ? null : _saveProfile,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'SAVE',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: _getTabs(user.activeRole),
          ),
        ),
        body: Column(
          children: [
            // Profile Completion Indicator
            _ProfileCompletionIndicator(completion: _profileCompletion),
            Expanded(
              child: Form(
                key: _formKey,
                onChanged: () {
                  if (!_hasUnsavedChanges) {
                    setState(() => _hasUnsavedChanges = true);
                  }
                  _calculateProfileCompletion();
                },
                child: TabBarView(
                  controller: _tabController,
                  children: _getTabViews(user.activeRole),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Tab> _getTabs(UserRole role) {
    switch (role) {
      case UserRole.student:
        return const [
          Tab(text: 'Basic Info'),
          Tab(text: 'Academic'),
          Tab(text: 'Test Scores'),
          Tab(text: 'Activities'),
        ];
      case UserRole.institution:
        return const [
          Tab(text: 'Basic Info'),
          Tab(text: 'Institution Details'),
          Tab(text: 'Documents'),
        ];
      case UserRole.parent:
        return const [
          Tab(text: 'Basic Info'),
          Tab(text: 'Guardian Info'),
          Tab(text: 'Emergency Contact'),
        ];
      case UserRole.counselor:
        return const [
          Tab(text: 'Basic Info'),
          Tab(text: 'Professional'),
          Tab(text: 'Credentials'),
        ];
      case UserRole.recommender:
        return const [
          Tab(text: 'Basic Info'),
          Tab(text: 'Professional Info'),
        ];
      // Admin roles - basic info only for now
      case UserRole.superAdmin:
      case UserRole.regionalAdmin:
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return const [
          Tab(text: 'Basic Info'),
        ];
    }
  }

  List<Widget> _getTabViews(UserRole role) {
    switch (role) {
      case UserRole.student:
        return [
          _buildBasicInfoTab(),
          _buildStudentAcademicTab(),
          _buildStudentTestScoresTab(),
          _buildStudentActivitiesTab(),
        ];
      case UserRole.institution:
        return [
          _buildBasicInfoTab(),
          _buildInstitutionDetailsTab(),
          _buildInstitutionDocumentsTab(),
        ];
      case UserRole.parent:
        return [
          _buildBasicInfoTab(),
          _buildParentGuardianTab(),
          _buildParentEmergencyTab(),
        ];
      case UserRole.counselor:
        return [
          _buildBasicInfoTab(),
          _buildCounselorProfessionalTab(),
          _buildCounselorCredentialsTab(),
        ];
      case UserRole.recommender:
        return [
          _buildBasicInfoTab(),
          _buildRecommenderProfessionalTab(),
        ];
      // Admin roles - basic info only for now
      case UserRole.superAdmin:
      case UserRole.regionalAdmin:
      case UserRole.contentAdmin:
      case UserRole.supportAdmin:
      case UserRole.financeAdmin:
      case UserRole.analyticsAdmin:
        return [
          _buildBasicInfoTab(),
        ];
    }
  }

  Future<void> _pickProfilePhoto() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true, // Important for web - loads bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _selectedPhotoBytes = file.bytes;
            _selectedPhotoFileName = file.name;
            _hasUnsavedChanges = true;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo selected! Save your changes to upload.'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Widget _buildBasicInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Photo
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                backgroundImage: _selectedPhotoBytes != null
                    ? MemoryImage(_selectedPhotoBytes!)
                    : null,
                child: _selectedPhotoBytes == null
                    ? const Icon(Icons.person, size: 50, color: AppColors.textOnPrimary)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, size: 18, color: AppColors.textOnPrimary),
                    onPressed: _pickProfilePhoto,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Name
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name *',
            prefixIcon: Icon(Icons.person_outline),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Email (read-only)
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            border: OutlineInputBorder(),
            helperText: 'Email cannot be changed',
          ),
          enabled: false,
        ),
        const SizedBox(height: 16),

        // Phone
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone_outlined),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        // Bio
        TextFormField(
          controller: _bioController,
          decoration: const InputDecoration(
            labelText: 'Bio',
            prefixIcon: Icon(Icons.note_outlined),
            border: OutlineInputBorder(),
            hintText: 'Tell us about yourself...',
          ),
          maxLines: 4,
        ),
        const SizedBox(height: 24),

        Text(
          'Address Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // Address
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Street Address',
            prefixIcon: Icon(Icons.home_outlined),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // City
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'City',
            prefixIcon: Icon(Icons.location_city),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        // Country
        TextFormField(
          controller: _countryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            prefixIcon: Icon(Icons.public),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  // STUDENT TABS
  Widget _buildStudentAcademicTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Academic Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        // School
        TextFormField(
          controller: _schoolController,
          decoration: const InputDecoration(
            labelText: 'Current School *',
            prefixIcon: Icon(Icons.school),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your school name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Date of Birth
        CustomCard(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _dateOfBirth ?? DateTime.now().subtract(const Duration(days: 6570)),
              firstDate: DateTime(1950),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() => _dateOfBirth = date);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.cake, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date of Birth',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _dateOfBirth != null
                            ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                            : 'Select your date of birth',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Gender
        DropdownButtonFormField<String>(
          value: _gender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          items: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
              .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
              .toList(),
          onChanged: (value) => setState(() => _gender = value),
        ),
        const SizedBox(height: 16),

        // Grade Level
        DropdownButtonFormField<String>(
          value: _gradeLevel,
          decoration: const InputDecoration(
            labelText: 'Grade Level *',
            prefixIcon: Icon(Icons.grade),
            border: OutlineInputBorder(),
          ),
          items: [
            '9th Grade',
            '10th Grade',
            '11th Grade',
            '12th Grade',
            'Undergraduate',
            'Graduate',
          ].map((grade) => DropdownMenuItem(value: grade, child: Text(grade))).toList(),
          onChanged: (value) => setState(() => _gradeLevel = value),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select your grade level';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Graduation Year
        TextFormField(
          controller: _graduationYearController,
          decoration: const InputDecoration(
            labelText: 'Expected Graduation Year *',
            prefixIcon: Icon(Icons.event),
            border: OutlineInputBorder(),
            hintText: 'e.g., 2025',
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation year';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // GPA
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _gpaController,
                decoration: const InputDecoration(
                  labelText: 'GPA *',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your GPA';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _gpaScale,
                decoration: const InputDecoration(
                  labelText: 'Scale',
                  border: OutlineInputBorder(),
                ),
                items: ['4.0', '5.0', '100']
                    .map((scale) => DropdownMenuItem(value: scale, child: Text(scale)))
                    .toList(),
                onChanged: (value) => setState(() => _gpaScale = value),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Class Rank
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _classRankController,
                decoration: const InputDecoration(
                  labelText: 'Class Rank',
                  prefixIcon: Icon(Icons.format_list_numbered),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _classSizeController,
                decoration: const InputDecoration(
                  labelText: 'Class Size',
                  border: OutlineInputBorder(),
                  hintText: 'out of',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Intended Major
        TextFormField(
          controller: _majorController,
          decoration: const InputDecoration(
            labelText: 'Intended Major',
            prefixIcon: Icon(Icons.book),
            border: OutlineInputBorder(),
            hintText: 'e.g., Computer Science',
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTestScoresTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Standardized Test Scores',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Optional: Add your test scores to strengthen your profile',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),

        Text(
          'SAT / ACT Scores',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // SAT Score
        TextFormField(
          controller: _satScoreController,
          decoration: const InputDecoration(
            labelText: 'SAT Score',
            prefixIcon: Icon(Icons.assignment),
            border: OutlineInputBorder(),
            hintText: 'Out of 1600',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // ACT Score
        TextFormField(
          controller: _actScoreController,
          decoration: const InputDecoration(
            labelText: 'ACT Score',
            prefixIcon: Icon(Icons.assignment),
            border: OutlineInputBorder(),
            hintText: 'Out of 36',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),

        Text(
          'English Proficiency (For International Students)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        // TOEFL Score
        TextFormField(
          controller: _toeflController,
          decoration: const InputDecoration(
            labelText: 'TOEFL Score',
            prefixIcon: Icon(Icons.language),
            border: OutlineInputBorder(),
            hintText: 'Out of 120',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        // IELTS Score
        TextFormField(
          controller: _ieltsController,
          decoration: const InputDecoration(
            labelText: 'IELTS Score',
            prefixIcon: Icon(Icons.language),
            border: OutlineInputBorder(),
            hintText: 'Out of 9.0',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),

        Text(
          'AP Courses',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        _ChipInputField(
          items: _apCourses,
          onChanged: (items) => setState(() => _apCourses = items),
          hintText: 'Add AP courses you have taken',
        ),
      ],
    );
  }

  Widget _buildStudentActivitiesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Extracurricular Activities',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Showcase your interests and achievements outside the classroom',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 24),

        Text(
          'Activities & Clubs',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        _ChipInputField(
          items: _activities,
          onChanged: (items) => setState(() => _activities = items),
          hintText: 'Add activities (e.g., Debate Club, Volleyball Team)',
        ),
        const SizedBox(height: 24),

        Text(
          'Honors & Awards',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        _ChipInputField(
          items: _honors,
          onChanged: (items) => setState(() => _honors = items),
          hintText: 'Add honors and awards received',
        ),
      ],
    );
  }

  // INSTITUTION TABS
  Widget _buildInstitutionDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Institution Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _institutionNameController,
          decoration: const InputDecoration(
            labelText: 'Official Institution Name *',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter institution name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _institutionTypeController,
          decoration: const InputDecoration(
            labelText: 'Institution Type *',
            prefixIcon: Icon(Icons.category),
            border: OutlineInputBorder(),
            hintText: 'e.g., University, College, High School',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter institution type';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _accreditationController,
          decoration: const InputDecoration(
            labelText: 'Accreditation Body *',
            prefixIcon: Icon(Icons.verified),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter accreditation information';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _taxIdController,
          decoration: const InputDecoration(
            labelText: 'Tax ID / Registration Number *',
            prefixIcon: Icon(Icons.numbers),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter tax ID';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _websiteController,
          decoration: const InputDecoration(
            labelText: 'Official Website *',
            prefixIcon: Icon(Icons.link),
            border: OutlineInputBorder(),
            hintText: 'https://www.example.edu',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter website URL';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _establishedYearController,
          decoration: const InputDecoration(
            labelText: 'Year Established',
            prefixIcon: Icon(Icons.history_edu),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildInstitutionDocumentsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Verification Documents',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Card(
          color: AppColors.info.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.info, color: AppColors.info),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Upload official documents to verify your institution. All documents will be reviewed by our team.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        _DocumentUploadSection(
          title: 'Required Documents',
          documents: _uploadedDocuments,
          requiredDocs: [
            'Accreditation Certificate',
            'Business Registration',
            'Tax ID Document',
          ],
          onUpload: () {
            // TODO: Implement document upload
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document upload coming soon')),
            );
          },
        ),
      ],
    );
  }

  // PARENT TABS
  Widget _buildParentGuardianTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Guardian Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _relationshipController,
          decoration: const InputDecoration(
            labelText: 'Relationship to Student *',
            prefixIcon: Icon(Icons.family_restroom),
            border: OutlineInputBorder(),
            hintText: 'e.g., Mother, Father, Guardian',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter relationship';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _occupationController,
          decoration: const InputDecoration(
            labelText: 'Occupation',
            prefixIcon: Icon(Icons.work),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _employerController,
          decoration: const InputDecoration(
            labelText: 'Employer',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildParentEmergencyTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Emergency Contact',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Provide an alternative contact in case of emergency',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _emergencyContactController,
          decoration: const InputDecoration(
            labelText: 'Emergency Contact Name',
            prefixIcon: Icon(Icons.contact_emergency),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _emergencyPhoneController,
          decoration: const InputDecoration(
            labelText: 'Emergency Contact Phone',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // COUNSELOR TABS
  Widget _buildCounselorProfessionalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Professional Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _licenseNumberController,
          decoration: const InputDecoration(
            labelText: 'License Number *',
            prefixIcon: Icon(Icons.badge),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter license number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        CustomCard(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _licenseExpiryDate ?? DateTime.now().add(const Duration(days: 365)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 3650)),
            );
            if (date != null) {
              setState(() => _licenseExpiryDate = date);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.event, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'License Expiry Date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _licenseExpiryDate != null
                            ? '${_licenseExpiryDate!.day}/${_licenseExpiryDate!.month}/${_licenseExpiryDate!.year}'
                            : 'Select expiry date',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _yearsExperienceController,
          decoration: const InputDecoration(
            labelText: 'Years of Experience',
            prefixIcon: Icon(Icons.timeline),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _educationController,
          decoration: const InputDecoration(
            labelText: 'Education Background',
            prefixIcon: Icon(Icons.school),
            border: OutlineInputBorder(),
            hintText: 'e.g., M.Ed in School Counseling',
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _specialtiesController,
          decoration: const InputDecoration(
            labelText: 'Specializations',
            prefixIcon: Icon(Icons.psychology),
            border: OutlineInputBorder(),
            hintText: 'e.g., Career Counseling, College Admissions',
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildCounselorCredentialsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Certifications & Credentials',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        _ChipInputField(
          items: _certifications,
          onChanged: (items) => setState(() => _certifications = items),
          hintText: 'Add certifications (e.g., NACAC, ASCA)',
        ),
        const SizedBox(height: 24),

        ElevatedButton.icon(
          onPressed: () {
            // TODO: Implement credential document upload
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Document upload coming soon')),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: const Text('Upload Credential Documents'),
        ),
      ],
    );
  }

  // RECOMMENDER TABS
  Widget _buildRecommenderProfessionalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Professional Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Professional Title *',
            prefixIcon: Icon(Icons.work),
            border: OutlineInputBorder(),
            hintText: 'e.g., Professor, Teacher, Counselor',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your professional title';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _organizationController,
          decoration: const InputDecoration(
            labelText: 'Organization *',
            prefixIcon: Icon(Icons.business),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),

        Text(
          'Professional Profiles',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        TextFormField(
          controller: _linkedInController,
          decoration: const InputDecoration(
            labelText: 'LinkedIn URL',
            prefixIcon: Icon(Icons.link),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _orcidController,
          decoration: const InputDecoration(
            labelText: 'ORCID (for researchers)',
            prefixIcon: Icon(Icons.link),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          'Areas of Expertise',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),

        _ChipInputField(
          items: _expertiseAreas,
          onChanged: (items) => setState(() => _expertiseAreas = items),
          hintText: 'Add expertise areas',
        ),
      ],
    );
  }

  Future<bool> _showUnsavedChangesDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Unsaved Changes'),
            content: const Text('You have unsaved changes. Do you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Discard'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = ref.read(authProvider).user;
      if (user == null) return;

      // Build metadata based on role
      final metadata = <String, dynamic>{
        'bio': _bioController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'country': _countryController.text,
      };

      switch (user.activeRole) {
        case UserRole.student:
          metadata.addAll({
            'school': _schoolController.text,
            'gpa': _gpaController.text.isNotEmpty ? double.tryParse(_gpaController.text) : null,
            'gpaScale': _gpaScale,
            'graduationYear': _graduationYearController.text.isNotEmpty
                ? int.tryParse(_graduationYearController.text)
                : null,
            'intendedMajor': _majorController.text,
            'dateOfBirth': _dateOfBirth?.toIso8601String(),
            'gender': _gender,
            'gradeLevel': _gradeLevel,
            'satScore': _satScoreController.text.isNotEmpty
                ? int.tryParse(_satScoreController.text)
                : null,
            'actScore': _actScoreController.text.isNotEmpty
                ? int.tryParse(_actScoreController.text)
                : null,
            'toeflScore': _toeflController.text.isNotEmpty
                ? int.tryParse(_toeflController.text)
                : null,
            'ieltsScore':
                _ieltsController.text.isNotEmpty ? double.tryParse(_ieltsController.text) : null,
            'classRank': _classRankController.text.isNotEmpty
                ? int.tryParse(_classRankController.text)
                : null,
            'classSize': _classSizeController.text.isNotEmpty
                ? int.tryParse(_classSizeController.text)
                : null,
            'activities': _activities,
            'honors': _honors,
            'apCourses': _apCourses,
          });
          break;
        case UserRole.institution:
          metadata.addAll({
            'institutionName': _institutionNameController.text,
            'institutionType': _institutionTypeController.text,
            'accreditation': _accreditationController.text,
            'taxId': _taxIdController.text,
            'website': _websiteController.text,
            'establishedYear': _establishedYearController.text.isNotEmpty
                ? int.tryParse(_establishedYearController.text)
                : null,
            'documents': _uploadedDocuments,
          });
          break;
        case UserRole.parent:
          metadata.addAll({
            'relationship': _relationshipController.text,
            'occupation': _occupationController.text,
            'employer': _employerController.text,
            'emergencyContactName': _emergencyContactController.text,
            'emergencyContactPhone': _emergencyPhoneController.text,
          });
          break;
        case UserRole.counselor:
          metadata.addAll({
            'licenseNumber': _licenseNumberController.text,
            'licenseExpiryDate': _licenseExpiryDate?.toIso8601String(),
            'yearsExperience': _yearsExperienceController.text.isNotEmpty
                ? int.tryParse(_yearsExperienceController.text)
                : null,
            'education': _educationController.text,
            'specialties': _specialtiesController.text,
            'certifications': _certifications,
          });
          break;
        case UserRole.recommender:
          metadata.addAll({
            'professionalTitle': _titleController.text,
            'organization': _organizationController.text,
            'linkedIn': _linkedInController.text,
            'orcid': _orcidController.text,
            'expertiseAreas': _expertiseAreas,
          });
          break;
        // Admin roles - no additional metadata for now
        case UserRole.superAdmin:
        case UserRole.regionalAdmin:
        case UserRole.contentAdmin:
        case UserRole.supportAdmin:
        case UserRole.financeAdmin:
        case UserRole.analyticsAdmin:
          // No additional metadata to save for admin roles yet
          break;
      }

      // Update profile via provider
      final success = await ref.read(profileProvider.notifier).updateProfile(
        displayName: _nameController.text,
        phoneNumber: _phoneController.text,
        additionalMetadata: metadata,
        photoBytes: _selectedPhotoBytes,
        photoFileName: _selectedPhotoFileName,
      );

      if (mounted) {
        if (success) {
          // Refresh the profile to ensure we have the latest data
          await ref.read(profileProvider.notifier).refresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.success,
            ),
          );

          setState(() {
            _hasUnsavedChanges = false;
            _isSubmitting = false;
          });

          context.pop();
        } else {
          // Get error from provider state
          final error = ref.read(profileProvider).error ?? 'Failed to update profile';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: AppColors.error,
            ),
          );
          setState(() => _isSubmitting = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() => _isSubmitting = false);
      }
    }
  }
}

// Profile Completion Indicator Widget
class _ProfileCompletionIndicator extends StatelessWidget {
  final double completion;

  const _ProfileCompletionIndicator({required this.completion});

  @override
  Widget build(BuildContext context) {
    final percentage = (completion * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getCompletionColor(completion),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: completion,
              minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(_getCompletionColor(completion)),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCompletionColor(double completion) {
    if (completion >= 0.8) return AppColors.success;
    if (completion >= 0.5) return AppColors.info;
    if (completion >= 0.3) return AppColors.warning;
    return AppColors.error;
  }
}

// Chip Input Field Widget
class _ChipInputField extends StatefulWidget {
  final List<String> items;
  final ValueChanged<List<String>> onChanged;
  final String hintText;

  const _ChipInputField({
    required this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<_ChipInputField> createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<_ChipInputField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...widget.items.map((item) {
              return Chip(
                label: Text(item),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  final newItems = List<String>.from(widget.items)..remove(item);
                  widget.onChanged(newItems);
                },
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                labelStyle: const TextStyle(color: AppColors.primary),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: const OutlineInputBorder(),
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty && !widget.items.contains(value)) {
                    final newItems = List<String>.from(widget.items)..add(value);
                    widget.onChanged(newItems);
                    _controller.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primary),
              onPressed: () {
                final value = _controller.text.trim();
                if (value.isNotEmpty && !widget.items.contains(value)) {
                  final newItems = List<String>.from(widget.items)..add(value);
                  widget.onChanged(newItems);
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Document Upload Section Widget
class _DocumentUploadSection extends StatelessWidget {
  final String title;
  final List<String> documents;
  final List<String> requiredDocs;
  final VoidCallback onUpload;

  const _DocumentUploadSection({
    required this.title,
    required this.documents,
    required this.requiredDocs,
    required this.onUpload,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...requiredDocs.map((doc) {
          final isUploaded = documents.contains(doc);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomCard(
              child: Row(
                children: [
                  Icon(
                    isUploaded ? Icons.check_circle : Icons.upload_file,
                    color: isUploaded ? AppColors.success : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      doc,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (isUploaded)
                    const Icon(Icons.check, color: AppColors.success)
                  else
                    TextButton(
                      onPressed: onUpload,
                      child: const Text('Upload'),
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
