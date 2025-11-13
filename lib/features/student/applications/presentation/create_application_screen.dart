import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/models/institution_model.dart';
import '../../../../core/models/program_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_config.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/providers/service_providers.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../authentication/providers/auth_provider.dart' hide currentUserProvider;
import '../../providers/student_applications_provider.dart';
import '../../institutions/browse_institutions_screen.dart';

class CreateApplicationScreen extends ConsumerStatefulWidget {
  const CreateApplicationScreen({super.key});

  @override
  ConsumerState<CreateApplicationScreen> createState() =>
      _CreateApplicationScreenState();
}

class _CreateApplicationScreenState extends ConsumerState<CreateApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Countries and their states/provinces
  static const Map<String, List<String>> _countriesWithStates = {
    'United States': ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'],
    'Canada': ['Alberta', 'British Columbia', 'Manitoba', 'New Brunswick', 'Newfoundland and Labrador', 'Northwest Territories', 'Nova Scotia', 'Nunavut', 'Ontario', 'Prince Edward Island', 'Quebec', 'Saskatchewan', 'Yukon'],
    'United Kingdom': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    'Kenya': ['Nairobi', 'Mombasa', 'Kisumu', 'Nakuru', 'Eldoret', 'Thika', 'Malindi', 'Kitale', 'Garissa', 'Kakamega', 'Nyeri', 'Meru', 'Kiambu', 'Machakos', 'Kajiado'],
    'Nigeria': ['Lagos', 'Kano', 'Ibadan', 'Abuja', 'Port Harcourt', 'Benin City', 'Kaduna', 'Onitsha', 'Enugu', 'Ilorin'],
    'Ghana': ['Greater Accra', 'Ashanti', 'Western', 'Eastern', 'Central', 'Volta', 'Northern', 'Upper East', 'Upper West', 'Brong-Ahafo'],
    'South Africa': ['Gauteng', 'Western Cape', 'KwaZulu-Natal', 'Eastern Cape', 'Free State', 'Limpopo', 'Mpumalanga', 'North West', 'Northern Cape'],
    'Australia': ['New South Wales', 'Victoria', 'Queensland', 'Western Australia', 'South Australia', 'Tasmania', 'Australian Capital Territory', 'Northern Territory'],
    'India': ['Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh', 'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal'],
  };

  // Selected institution (registered institution account)
  Institution? _selectedInstitution;

  // Programs from selected institution
  List<Program> _availablePrograms = [];
  Program? _selectedProgram;
  bool _isLoadingPrograms = false;
  String? _programsError;

  // Form controllers
  final _institutionController = TextEditingController();
  final _programController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _previousSchoolController = TextEditingController();
  final _gpaController = TextEditingController();
  final _personalStatementController = TextEditingController();

  // Address dropdowns
  String? _selectedCountry;
  String? _selectedState;

  // Document upload states
  Map<String, PlatformFile?> _uploadedDocuments = {
    'transcript': null,
    'id': null,
    'statement': null,
  };

  @override
  void dispose() {
    _institutionController.dispose();
    _programController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    _previousSchoolController.dispose();
    _gpaController.dispose();
    _personalStatementController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    print('[CreateApplication] _submitApplication() called');

    // No need to validate form again - we already validated step by step
    // Show uploading indicator
    print('[CreateApplication] Showing upload indicator');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Uploading documents...'),
          ],
        ),
        duration: Duration(minutes: 2),
      ),
    );

    // Declare variables outside try block
    late Map<String, dynamic> personalInfo;
    late Map<String, dynamic> academicInfo;
    late Map<String, dynamic> documents;

    try {
      // Get current user
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Backend expects document URLs as simple strings
      // For now, send filenames to indicate which documents are uploaded
      print('[CreateApplication] Preparing document data for backend');

      // Prepare application data
      personalInfo = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'streetAddress': _streetAddressController.text,
        'city': _cityController.text,
        'state': _selectedState,
        'country': _selectedCountry,
      };

      academicInfo = {
        'previousSchool': _previousSchoolController.text,
        'gpa': _gpaController.text,
        'personalStatement': _personalStatementController.text,
      };

      // Send document URLs (filenames for now, backend can process later)
      documents = {
        'transcript': _uploadedDocuments['transcript']?.name ?? '',
        'id_document': _uploadedDocuments['id']?.name ?? '',
        'passport_photo': _uploadedDocuments['statement']?.name ?? '',
      };
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to prepare application: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Validate institution is selected
    if (_selectedInstitution == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an institution before submitting'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate program is selected
    if (_selectedProgram == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a program before submitting'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Validate required documents
    final missingFields = <String>[];
    if (_fullNameController.text.trim().isEmpty) missingFields.add('Full Name');
    if (_emailController.text.trim().isEmpty) missingFields.add('Email');
    if (_phoneController.text.trim().isEmpty) missingFields.add('Phone');
    if (_streetAddressController.text.trim().isEmpty) missingFields.add('Street Address');
    if (_cityController.text.trim().isEmpty) missingFields.add('City');
    if (_selectedCountry == null) missingFields.add('Country');
    if (_selectedState == null) missingFields.add('State/Province');
    if (_previousSchoolController.text.trim().isEmpty) missingFields.add('Previous School');
    if (_gpaController.text.trim().isEmpty) missingFields.add('GPA');
    if (_personalStatementController.text.trim().isEmpty) missingFields.add('Personal Statement');

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Missing required fields: ${missingFields.join(", ")}'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 5),
        ),
      );
      return;
    }

    // Submit application using provider
    final success = await ref.read(applicationsProvider.notifier).submitApplication(
      institutionId: _selectedInstitution!.id,  // Send institution UUID
      institutionName: _selectedInstitution!.name,
      programId: _selectedProgram!.id,  // Send program UUID
      programName: _selectedProgram!.name,
      applicationType: _selectedProgram!.level,  // Use program level as application type
      personalInfo: personalInfo,
      academicInfo: academicInfo,
      documents: documents,
      applicationFee: _selectedProgram!.fee,  // Use program fee
    );

    if (mounted) {
      // Hide uploading snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: AppColors.success,
            duration: Duration(seconds: 4),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(applicationsErrorProvider) ?? 'Failed to submit application',
            ),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _fetchPrograms(String institutionId) async {
    setState(() {
      _isLoadingPrograms = true;
      _programsError = null;
      _availablePrograms = [];
      _selectedProgram = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final apiClient = ApiClient(prefs);
      final response = await apiClient.get<List<Program>>(
        '${ApiConfig.institutions}/$institutionId/programs',
        fromJson: (data) {
          // API returns {total: X, programs: [...]}
          if (data is Map<String, dynamic> && data['programs'] is List) {
            final programsList = data['programs'] as List;
            return programsList.map((item) => Program.fromJson(item as Map<String, dynamic>)).toList();
          }
          return [];
        },
      );

      if (response.success && response.data != null) {
        setState(() {
          _availablePrograms = response.data!;
          _isLoadingPrograms = false;
        });
      } else {
        setState(() {
          _programsError = response.message ?? 'Failed to load programs';
          _isLoadingPrograms = false;
        });
      }
    } catch (e) {
      setState(() {
        _programsError = 'Error loading programs: ${e.toString()}';
        _isLoadingPrograms = false;
      });
    }
  }

  Future<void> _pickDocument(String type) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _uploadedDocuments[type] = result.files.first;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.files.first.name} uploaded successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(applicationsSubmittingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          tooltip: 'Back',
        ),
        title: const Text('New Application'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            // Validate current step before continuing
            if (_currentStep == 0) {
              // Step 1: Validate institution and program selection
              if (_selectedInstitution == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select an institution to continue'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              if (_selectedProgram == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a program to continue'),
                    backgroundColor: AppColors.error,
                  ),
                );
                return;
              }
              setState(() => _currentStep++);
            } else if (_currentStep == 1) {
              // Step 2: Validate personal information
              final missingPersonalFields = <String>[];
              if (_fullNameController.text.trim().isEmpty) missingPersonalFields.add('Full Name');
              if (_emailController.text.trim().isEmpty) missingPersonalFields.add('Email');
              if (_phoneController.text.trim().isEmpty) missingPersonalFields.add('Phone');
              if (_streetAddressController.text.trim().isEmpty) missingPersonalFields.add('Street Address');
              if (_cityController.text.trim().isEmpty) missingPersonalFields.add('City/Town');
              if (_selectedCountry == null) missingPersonalFields.add('Country');
              if (_selectedState == null) missingPersonalFields.add('State/Province');

              if (missingPersonalFields.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Missing: ${missingPersonalFields.join(", ")}'),
                    backgroundColor: AppColors.error,
                    duration: const Duration(seconds: 5),
                  ),
                );
                return;
              }
              setState(() => _currentStep++);
            } else if (_currentStep == 2) {
              // Step 3: Validate academic information
              final missingAcademicFields = <String>[];
              if (_previousSchoolController.text.trim().isEmpty) missingAcademicFields.add('Previous School');
              if (_gpaController.text.trim().isEmpty) missingAcademicFields.add('GPA');
              if (_personalStatementController.text.trim().isEmpty) missingAcademicFields.add('Personal Statement');

              if (missingAcademicFields.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Missing: ${missingAcademicFields.join(", ")}'),
                    backgroundColor: AppColors.error,
                    duration: const Duration(seconds: 5),
                  ),
                );
                return;
              }
              setState(() => _currentStep++);
            } else {
              // Step 4: Validate documents before submission
              print('[CreateApplication] Submit button clicked');
              print('[CreateApplication] Current step: $_currentStep');
              print('[CreateApplication] Uploaded documents: ${_uploadedDocuments.keys.where((key) => _uploadedDocuments[key] != null).toList()}');

              final missingDocs = <String>[];
              if (_uploadedDocuments['transcript'] == null) {
                missingDocs.add('Academic Transcript');
              }
              if (_uploadedDocuments['id'] == null) {
                missingDocs.add('ID Document');
              }
              if (_uploadedDocuments['statement'] == null) {
                missingDocs.add('Passport Photo');
              }

              if (missingDocs.isNotEmpty) {
                print('[CreateApplication] Missing documents: ${missingDocs.join(", ")}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Missing required documents: ${missingDocs.join(", ")}'),
                    backgroundColor: AppColors.error,
                    duration: const Duration(seconds: 5),
                  ),
                );
                return;
              }

              // All documents uploaded, proceed with submission
              print('[CreateApplication] All documents validated, calling _submitApplication()');
              _submitApplication();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: isSubmitting ? null : details.onStepContinue,
                    child: isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentStep == 3 ? 'Submit' : 'Continue'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: isSubmitting ? null : details.onStepCancel,
                    child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                ],
              ),
            );
          },
          steps: [
            // Step 1: Institution & Program
            Step(
              title: const Text('Program Selection'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // University selection
                  Text(
                    'Select University',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedInstitution == null)
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push<Institution>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BrowseInstitutionsScreen(selectionMode: true),
                          ),
                        );
                        if (result != null) {
                          setState(() {
                            _selectedInstitution = result;
                            _institutionController.text = result.name;
                          });
                          // Fetch programs from selected institution
                          await _fetchPrograms(result.id);
                        }
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Browse Institutions'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    )
                  else
                    CustomCard(
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.business, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _selectedInstitution!.name,
                                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    if (_selectedInstitution!.isVerified)
                                      const Icon(
                                        Icons.verified,
                                        size: 16,
                                        color: AppColors.success,
                                      ),
                                  ],
                                ),
                                Text(
                                  _selectedInstitution!.email,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                                if (_selectedInstitution!.hasOfferings)
                                  Text(
                                    _selectedInstitution!.formattedTotalOfferings,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontSize: 11,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedInstitution = null;
                                _institutionController.clear();
                              });
                            },
                            tooltip: 'Remove',
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Program Selection Dropdown
                  Text(
                    'Select Program *',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 8),
                  if (_isLoadingPrograms)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Loading available programs...'),
                          ],
                        ),
                      ),
                    )
                  else if (_programsError != null)
                    Card(
                      color: AppColors.error.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _programsError!,
                                style: const TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_availablePrograms.isEmpty && _selectedInstitution != null)
                    Card(
                      color: AppColors.warning.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: AppColors.warning),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'This institution has no active programs yet. Please select another institution.',
                                style: TextStyle(color: AppColors.warning),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (_availablePrograms.isNotEmpty)
                    DropdownButtonFormField<Program>(
                      value: _selectedProgram,
                      decoration: InputDecoration(
                        labelText: 'Select a Program *',
                        prefixIcon: const Icon(Icons.school),
                        border: const OutlineInputBorder(),
                        helperText: '${_availablePrograms.length} programs available',
                      ),
                      items: _availablePrograms.map((program) {
                        return DropdownMenuItem<Program>(
                          value: program,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                program.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '${program.level.toUpperCase()} • \$${program.fee.toStringAsFixed(0)} • ${program.duration.inDays ~/ 30} months',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (program) {
                        setState(() {
                          _selectedProgram = program;
                          _programController.text = program?.name ?? '';
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a program';
                        }
                        return null;
                      },
                    ),
                  if (_selectedInstitution == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Please select an institution first to view available programs',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.info,
                            ),
                      ),
                    ),
                ],
              ),
            ),

            // Step 2: Personal Information
            Step(
              title: const Text('Personal Information'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: Validators.fullName,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: Validators.phoneNumber,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _streetAddressController,
                    decoration: const InputDecoration(
                      labelText: 'Street Address *',
                      prefixIcon: Icon(Icons.home),
                      hintText: 'e.g., 123 Main Street',
                    ),
                    validator: Validators.required('Please enter your street address'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City/Town *',
                      prefixIcon: Icon(Icons.location_city),
                      hintText: 'e.g., Norman',
                    ),
                    validator: Validators.required('Please enter your city'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: const InputDecoration(
                      labelText: 'Country *',
                      prefixIcon: Icon(Icons.public),
                      border: OutlineInputBorder(),
                    ),
                    items: _countriesWithStates.keys.map((country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCountry = value;
                        _selectedState = null; // Reset state when country changes
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a country';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'State/Province *',
                      prefixIcon: Icon(Icons.map),
                      border: OutlineInputBorder(),
                    ),
                    items: _selectedCountry != null
                        ? _countriesWithStates[_selectedCountry]!.map((state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList()
                        : [],
                    onChanged: _selectedCountry != null
                        ? (value) {
                            setState(() {
                              _selectedState = value;
                            });
                          }
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a state/province';
                      }
                      return null;
                    },
                    disabledHint: const Text('Select a country first'),
                  ),
                ],
              ),
            ),

            // Step 3: Academic Information
            Step(
              title: const Text('Academic Information'),
              isActive: _currentStep >= 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: Column(
                children: [
                  TextFormField(
                    controller: _previousSchoolController,
                    decoration: const InputDecoration(
                      labelText: 'Previous School/Institution',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your previous school';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _gpaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'GPA / Grade Average',
                      prefixIcon: Icon(Icons.grade),
                      hintText: 'e.g., 3.8',
                    ),
                    validator: Validators.gpa,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _personalStatementController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Personal Statement',
                      prefixIcon: Icon(Icons.article),
                      hintText: 'Why are you interested in this program?',
                    ),
                    validator: Validators.compose([
                      Validators.required('Please write a personal statement'),
                      Validators.minLength(50, 'Personal statement'),
                      Validators.maxLength(1000, 'Personal statement'),
                    ]),
                  ),
                ],
              ),
            ),

            // Step 4: Documents (Required)
            Step(
              title: const Text('Documents (Required)'),
              isActive: _currentStep >= 3,
              state: StepState.indexed,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Required Documents',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _DocumentUploadCard(
                    title: 'Academic Transcript',
                    subtitle: 'Official transcript from your previous school (PDF, DOC, or DOCX format, max 5MB)',
                    icon: Icons.description,
                    onUpload: () => _pickDocument('transcript'),
                    uploadedFile: _uploadedDocuments['transcript'],
                  ),
                  const SizedBox(height: 12),
                  _DocumentUploadCard(
                    title: 'ID Document',
                    subtitle: 'Valid government-issued ID: Passport, National ID Card, or Driver\'s License (PDF, JPG, or PNG)',
                    icon: Icons.badge,
                    onUpload: () => _pickDocument('id'),
                    uploadedFile: _uploadedDocuments['id'],
                  ),
                  const SizedBox(height: 12),
                  _DocumentUploadCard(
                    title: 'Passport Photo',
                    subtitle: 'Recent passport-sized photo with plain background (JPG or PNG format)',
                    icon: Icons.photo_camera,
                    onUpload: () => _pickDocument('statement'),
                    uploadedFile: _uploadedDocuments['statement'],
                  ),
                  const SizedBox(height: 24),
                  CustomCard(
                    color: AppColors.error.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'All three documents are required. Please upload Academic Transcript, ID Document, and Passport Photo before submitting.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onUpload;
  final PlatformFile? uploadedFile;

  const _DocumentUploadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onUpload,
    this.uploadedFile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUploaded = uploadedFile != null;

    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isUploaded
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUploaded ? Icons.check_circle : icon,
              color: isUploaded ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isUploaded
                      ? uploadedFile!.name
                      : subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isUploaded ? AppColors.success : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onUpload,
            child: Text(isUploaded ? 'Change' : 'Upload'),
          ),
        ],
      ),
    );
  }
}
