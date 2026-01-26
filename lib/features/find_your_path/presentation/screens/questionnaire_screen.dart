import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../authentication/providers/auth_provider.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/constants/global_education_data.dart';
import '../../application/providers/find_your_path_provider.dart';

/// Multi-step questionnaire for collecting student profile
class QuestionnaireScreen extends ConsumerStatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  ConsumerState<QuestionnaireScreen> createState() =>
      _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends ConsumerState<QuestionnaireScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _gradeValueController = TextEditingController();

  // Global Academic Information
  String? _nationality;
  String? _currentCountry;
  String? _currentRegion;
  GradingSystem? _gradingSystem;
  String? _standardizedTestType;
  final Map<String, dynamic> _testScores = {};

  // Academic Interests
  String? _intendedMajor;
  String? _fieldOfStudy;
  List<String> _alternativeMajors = [];
  bool _researchInterest = false;
  bool _careerFocused = true;

  // Location Preferences
  List<String> _preferredCountries = [];
  List<String> _preferredRegions = [];
  String? _locationType;

  // University Preferences
  String? _universitySize;
  String? _universityType;
  bool _interestedInSports = false;
  List<String> _featuresDesired = [];

  // Financial
  String? _budgetRange;
  bool _needFinancialAid = false;
  String? _inStateEligible;

  List<String> _getRegionsForCountry(String? countryCode) {
    if (countryCode == null) return [];
    final country = worldCountries.firstWhere(
      (c) => c.code == countryCode,
      orElse: () => const Country('', '', []),
    );
    return country.regions;
  }

  @override
  void dispose() {
    _gradeValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('University Questionnaire'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Form(
                    key: _formKey,
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
          ),

          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / 6,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Step ${_currentStep + 1} of 6',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getStepTitle(_currentStep),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Background Information';
      case 1:
        return 'Academic Achievements';
      case 2:
        return 'Academic Interests';
      case 3:
        return 'Location Preferences';
      case 4:
        return 'University Preferences';
      case 5:
        return 'Financial Information';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildBackgroundStep();
      case 1:
        return _buildAcademicStep();
      case 2:
        return _buildInterestsStep();
      case 3:
        return _buildLocationStep();
      case 4:
        return _buildUniversityPreferencesStep();
      case 5:
        return _buildFinancialStep();
      default:
        return const SizedBox.shrink();
    }
  }

  // Step 0: Background Information
  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This helps us understand your educational background',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Nationality
        DropdownButtonFormField<String>(
          value: _nationality,
          decoration: const InputDecoration(
            labelText: 'Nationality *',
            prefixIcon: Icon(Icons.flag),
            border: OutlineInputBorder(),
            helperText: 'Your country of citizenship',
          ),
          items: worldCountries.map((country) {
            return DropdownMenuItem(
              value: country.code,
              child: Text('${country.name}'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _nationality = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your nationality';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Current Country
        DropdownButtonFormField<String>(
          value: _currentCountry,
          decoration: const InputDecoration(
            labelText: 'Where are you currently studying? *',
            prefixIcon: Icon(Icons.school),
            border: OutlineInputBorder(),
            helperText: 'Your current location (not where you want to study)',
          ),
          items: worldCountries.map((country) {
            return DropdownMenuItem(
              value: country.code,
              child: Text(country.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _currentCountry = value;
              _currentRegion = null; // Reset region when country changes
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your current country';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Current Region (only show if country has regions)
        if (_currentCountry != null && _getRegionsForCountry(_currentCountry).isNotEmpty) ...[
          DropdownButtonFormField<String>(
            value: _currentRegion,
            decoration: const InputDecoration(
              labelText: 'Current Region/State (Optional)',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
              helperText: 'Select your region if available',
            ),
            items: _getRegionsForCountry(_currentCountry).map((region) {
              return DropdownMenuItem(
                value: region,
                child: Text(region),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _currentRegion = value;
              });
            },
            validator: null, // Optional field - no validation required
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  // Step 1: Academic Profile
  Widget _buildAcademicStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your academic achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This helps us match you with universities where you\'ll be competitive',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Grading System
        DropdownButtonFormField<GradingSystem>(
          value: _gradingSystem,
          decoration: const InputDecoration(
            labelText: 'Your Grading System *',
            prefixIcon: Icon(Icons.assessment),
            border: OutlineInputBorder(),
          ),
          items: GradingSystem.values.map((system) {
            return DropdownMenuItem(
              value: system,
              child: Text(system.displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _gradingSystem = value;
              _gradeValueController.clear(); // Clear when system changes
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your grading system';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Grade Value
        if (_gradingSystem != null) ...[
          TextFormField(
            controller: _gradeValueController,
            decoration: InputDecoration(
              labelText: 'Your Grade *',
              hintText: 'e.g., ${_gradingSystem!.maxScore}',
              helperText: 'Maximum: ${_gradingSystem!.maxScore}',
              prefixIcon: const Icon(Icons.grade),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your grade';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
        ],

        // Standardized Test Type
        DropdownButtonFormField<String>(
          value: _standardizedTestType,
          decoration: const InputDecoration(
            labelText: 'Standardized Test (if applicable)',
            prefixIcon: Icon(Icons.quiz),
            border: OutlineInputBorder(),
            helperText: 'Leave blank if you haven\'t taken any',
          ),
          items: standardizedTests.map((test) {
            return DropdownMenuItem(value: test, child: Text(test));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _standardizedTestType = value;
              _testScores.clear(); // Clear scores when test type changes
            });
          },
        ),
        const SizedBox(height: 20),

        // Test Score Fields (dynamic based on test type)
        if (_standardizedTestType == 'SAT') ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'SAT Total Score',
              hintText: 'e.g., 1400',
              prefixIcon: Icon(Icons.score),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _testScores['total'] = int.tryParse(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final score = int.tryParse(value);
              if (score == null || score < 400 || score > 1600) {
                return 'SAT must be between 400-1600';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ] else if (_standardizedTestType == 'ACT') ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'ACT Composite Score',
              hintText: 'e.g., 28',
              prefixIcon: Icon(Icons.score),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _testScores['composite'] = int.tryParse(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final score = int.tryParse(value);
              if (score == null || score < 1 || score > 36) {
                return 'ACT must be between 1-36';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ] else if (_standardizedTestType == 'IB Diploma') ...[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'IB Predicted/Final Score',
              hintText: 'e.g., 38',
              prefixIcon: Icon(Icons.score),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty) {
                _testScores['total'] = int.tryParse(value);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              final score = int.tryParse(value);
              if (score == null || score < 0 || score > 45) {
                return 'IB score must be between 0-45';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: AppColors.info),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Standardized test scores are optional. If you haven\'t taken these tests yet, you can skip them.',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Step 2: Academic Interests
  Widget _buildInterestsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What do you want to study?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about your academic interests and career goals',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Intended Major
        DropdownButtonFormField<String>(
          value: _intendedMajor,
          decoration: const InputDecoration(
            labelText: 'Intended Major *',
            hintText: 'Select your intended major',
            prefixIcon: Icon(Icons.school),
            border: OutlineInputBorder(),
          ),
          items: commonMajors.map((major) {
            return DropdownMenuItem(value: major, child: Text(major));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _intendedMajor = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select your intended major';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Field of Study
        DropdownButtonFormField<String>(
          value: _fieldOfStudy,
          decoration: const InputDecoration(
            labelText: 'Field of Study *',
            prefixIcon: Icon(Icons.category),
            border: OutlineInputBorder(),
          ),
          items: fieldsOfStudy.map((field) {
            return DropdownMenuItem(value: field, child: Text(field));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _fieldOfStudy = value;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a field of study';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Career Focus
        CheckboxListTile(
          title: const Text('I am career-focused'),
          subtitle: Text(
            'I want to find universities with strong job placement and career services',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          value: _careerFocused,
          onChanged: (value) {
            setState(() {
              _careerFocused = value ?? true;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),

        // Research Interest
        CheckboxListTile(
          title: const Text('Interested in research opportunities'),
          subtitle: Text(
            'I want to participate in research projects during my studies',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          value: _researchInterest,
          onChanged: (value) {
            setState(() {
              _researchInterest = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  // Step 3: Location Preferences
  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where do you want to study?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select your preferred countries and regions',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Preferred Countries
        const Text(
          'Where do you want to study? *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Select countries where you\'d like to attend university (can be different from your current location)',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: const BoxConstraints(maxHeight: 300),
          child: ListView(
            shrinkWrap: true,
            children: worldCountries.map((country) {
              final isSelected = _preferredCountries.contains(country.name);
              return CheckboxListTile(
                dense: true,
                title: Text(country.name),
                value: isSelected,
                onChanged: (selected) {
                  setState(() {
                    if (selected == true) {
                      _preferredCountries.add(country.name);
                    } else {
                      _preferredCountries.remove(country.name);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Location Type
        const Text(
          'Campus Setting',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...locationTypePreferences.map((type) {
          return RadioListTile<String>(
            title: Text(type),
            value: type,
            groupValue: _locationType,
            onChanged: (value) {
              setState(() {
                _locationType = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  // Step 4: University Preferences
  Widget _buildUniversityPreferencesStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'University Characteristics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'What kind of university environment do you prefer?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // University Size
        DropdownButtonFormField<String>(
          value: _universitySize,
          decoration: const InputDecoration(
            labelText: 'Preferred University Size',
            prefixIcon: Icon(Icons.people),
            border: OutlineInputBorder(),
          ),
          items: universitySizePreferences.map((size) {
            return DropdownMenuItem(value: size, child: Text(size));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _universitySize = value;
            });
          },
        ),
        const SizedBox(height: 20),

        // University Type
        DropdownButtonFormField<String>(
          value: _universityType,
          decoration: const InputDecoration(
            labelText: 'Preferred University Type',
            prefixIcon: Icon(Icons.account_balance),
            border: OutlineInputBorder(),
          ),
          items: universityTypePreferences.map((type) {
            return DropdownMenuItem(value: type, child: Text(type));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _universityType = value;
            });
          },
        ),
        const SizedBox(height: 20),

        // Sports Interest
        CheckboxListTile(
          title: const Text('Interested in athletics/sports'),
          subtitle: Text(
            'I want to participate in or attend collegiate sports',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          value: _interestedInSports,
          onChanged: (value) {
            setState(() {
              _interestedInSports = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 20),

        // Desired Features
        const Text(
          'Desired Campus Features (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: campusFeatures.map((feature) {
            final isSelected = _featuresDesired.contains(feature);
            return FilterChip(
              label: Text(feature),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _featuresDesired.add(feature);
                  } else {
                    _featuresDesired.remove(feature);
                  }
                });
              },
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  // Step 5: Financial Information
  Widget _buildFinancialStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Financial Considerations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help us recommend universities within your budget',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Budget Range
        DropdownButtonFormField<String>(
          value: _budgetRange,
          decoration: const InputDecoration(
            labelText: 'Annual Budget Range (USD)',
            prefixIcon: Icon(Icons.attach_money),
            border: OutlineInputBorder(),
            helperText: 'Approximate annual tuition budget',
          ),
          items: budgetRanges.map((range) {
            return DropdownMenuItem(value: range, child: Text(range));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _budgetRange = value;
            });
          },
        ),
        const SizedBox(height: 20),

        // Financial Aid Need
        CheckboxListTile(
          title: const Text('I will need financial aid'),
          subtitle: Text(
            'We\'ll prioritize universities with strong financial aid programs',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          value: _needFinancialAid,
          onChanged: (value) {
            setState(() {
              _needFinancialAid = value ?? false;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 20),

        // In-State Eligibility (US only)
        if (_preferredCountries.contains('US')) ...[
          DropdownButtonFormField<String>(
            value: _inStateEligible,
            decoration: const InputDecoration(
              labelText: 'Eligible for In-State Tuition? (US)',
              prefixIcon: Icon(Icons.location_city),
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text('Not applicable')),
              ...usStates.map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
            ],
            onChanged: (value) {
              setState(() {
                _inStateEligible = value;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildNavigationButtons() {
    final profileState = ref.watch(profileProvider);
    final isLoading = profileState.isLoading;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(_currentStep == 5 ? 'Get Recommendations' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_currentStep < 5) {
        setState(() {
          _currentStep++;
        });
      } else {
        // Final step - submit profile
        await _submitProfile();
      }
    }
  }

  Future<void> _submitProfile() async {
    final authState = ref.read(authProvider);
    // Use real user ID if logged in, otherwise generate anonymous ID
    final userId = authState.user?.id ?? 'anonymous_${const Uuid().v4()}';
    final isAnonymous = authState.user?.id == null;

    // Create profile with new global fields
    final profile = StudentProfile(
      userId: userId,
      // Global fields
      gradingSystem: _gradingSystem?.name,
      gradeValue: _gradeValueController.text.isNotEmpty
          ? _gradeValueController.text
          : null,
      nationality: _nationality,
      currentCountry: _currentCountry,
      currentRegion: _currentRegion,
      standardizedTestType: _standardizedTestType,
      testScores: _testScores.isNotEmpty ? _testScores : null,
      // Academic
      intendedMajor: _intendedMajor,
      fieldOfStudy: _fieldOfStudy,
      alternativeMajors: _alternativeMajors,
      // Location
      preferredRegions: _preferredRegions,
      preferredCountries: _preferredCountries,
      locationTypePreference: _locationType == 'No Preference' ? null : _locationType,
      // University
      universitySizePreference: _universitySize == 'No Preference' ? null : _universitySize,
      universityTypePreference: _universityType == 'No Preference' ? null : _universityType,
      // Financial
      budgetRange: _budgetRange,
      needFinancialAid: _needFinancialAid,
      eligibleForInState: _inStateEligible,
      // Interests
      interestedInSports: _interestedInSports,
      careerFocused: _careerFocused,
      researchInterest: _researchInterest,
      featuresDesired: _featuresDesired,
    );

    // Show loading dialog
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => _LoadingDialog(),
      );
    }

    try {
      // Save profile
      await ref.read(profileProvider.notifier).saveProfile(profile);

      final profileState = ref.read(profileProvider);
      if (profileState.error != null) {
        if (mounted) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving profile: ${profileState.error}'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
        return;
      }

      // Generate recommendations
      await ref.read(recommendationsProvider.notifier).generateRecommendations(
            userId: userId,
          );

      final recsState = ref.read(recommendationsProvider);

      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
      }

      if (recsState.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error generating recommendations: ${recsState.error}'),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () => _submitProfile(),
              ),
            ),
          );
        }
        return;
      }

      // Navigate to results
      if (mounted) {
        context.go('/find-your-path/results');

        // Show sign-up suggestion for anonymous users (non-blocking)
        if (isAnonymous) {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Sign up to save your recommendations!'),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: 'Sign Up',
                    textColor: Colors.white,
                    onPressed: () => context.go('/register'),
                  ),
                ),
              );
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

}

/// Loading dialog widget shown during profile submission and recommendation generation
class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent dismissal
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated circular progress indicator
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 24),
              // Loading message
              const Text(
                'Generating Recommendations',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please wait while we analyze universities\nand create personalized matches for you...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
