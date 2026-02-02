import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/l10n_extension.dart';
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
        title: Text(context.l10n.fypQuestionnaireTitle),
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
                context.l10n.fypStepOf(_currentStep + 1, 6),
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
            _getStepTitle(context, _currentStep),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(BuildContext context, int step) {
    switch (step) {
      case 0:
        return context.l10n.fypStepBackgroundInfo;
      case 1:
        return context.l10n.fypStepAcademicAchievements;
      case 2:
        return context.l10n.fypStepAcademicInterests;
      case 3:
        return context.l10n.fypStepLocationPreferences;
      case 4:
        return context.l10n.fypStepUniversityPreferences;
      case 5:
        return context.l10n.fypStepFinancialInfo;
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
        Text(
          context.l10n.fypTellUsAboutYourself,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypBackgroundHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Nationality
        DropdownButtonFormField<String>(
          value: _nationality,
          decoration: InputDecoration(
            labelText: context.l10n.fypNationalityLabel,
            prefixIcon: const Icon(Icons.flag),
            border: const OutlineInputBorder(),
            helperText: context.l10n.fypNationalityHelper,
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
              return context.l10n.fypSelectNationality;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Current Country
        DropdownButtonFormField<String>(
          value: _currentCountry,
          decoration: InputDecoration(
            labelText: context.l10n.fypCurrentStudyingLabel,
            prefixIcon: const Icon(Icons.school),
            border: const OutlineInputBorder(),
            helperText: context.l10n.fypCurrentStudyingHelper,
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
              return context.l10n.fypSelectCurrentCountry;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Current Region (only show if country has regions)
        if (_currentCountry != null && _getRegionsForCountry(_currentCountry).isNotEmpty) ...[
          DropdownButtonFormField<String>(
            value: _currentRegion,
            decoration: InputDecoration(
              labelText: context.l10n.fypCurrentRegionLabel,
              prefixIcon: const Icon(Icons.location_on),
              border: const OutlineInputBorder(),
              helperText: context.l10n.fypSelectRegionHelper,
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
        Text(
          context.l10n.fypYourAcademicAchievements,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypAcademicMatchHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Grading System
        DropdownButtonFormField<GradingSystem>(
          value: _gradingSystem,
          decoration: InputDecoration(
            labelText: context.l10n.fypGradingSystemLabel,
            prefixIcon: const Icon(Icons.assessment),
            border: const OutlineInputBorder(),
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
              return context.l10n.fypSelectGradingSystem;
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
              labelText: context.l10n.fypYourGradeLabel,
              hintText: 'e.g., ${_gradingSystem!.maxScore}',
              helperText: 'Maximum: ${_gradingSystem!.maxScore}',
              prefixIcon: const Icon(Icons.grade),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.l10n.fypEnterGrade;
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
        ],

        // Standardized Test Type
        DropdownButtonFormField<String>(
          value: _standardizedTestType,
          decoration: InputDecoration(
            labelText: context.l10n.fypStandardizedTestLabel,
            prefixIcon: const Icon(Icons.quiz),
            border: const OutlineInputBorder(),
            helperText: context.l10n.fypStandardizedTestHelper,
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
            decoration: InputDecoration(
              labelText: context.l10n.fypSatTotalScoreLabel,
              hintText: context.l10n.fypSatScoreHint,
              prefixIcon: const Icon(Icons.score),
              border: const OutlineInputBorder(),
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
                return context.l10n.fypSatValidation;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ] else if (_standardizedTestType == 'ACT') ...[
          TextFormField(
            decoration: InputDecoration(
              labelText: context.l10n.fypActCompositeLabel,
              hintText: context.l10n.fypActScoreHint,
              prefixIcon: const Icon(Icons.score),
              border: const OutlineInputBorder(),
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
                return context.l10n.fypActValidation;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
        ] else if (_standardizedTestType == 'IB Diploma') ...[
          TextFormField(
            decoration: InputDecoration(
              labelText: context.l10n.fypIbScoreLabel,
              hintText: context.l10n.fypIbScoreHint,
              prefixIcon: const Icon(Icons.score),
              border: const OutlineInputBorder(),
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
                return context.l10n.fypIbValidation;
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
                  context.l10n.fypTestScoresOptional,
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
        Text(
          context.l10n.fypWhatStudy,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypInterestsHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Intended Major
        DropdownButtonFormField<String>(
          value: _intendedMajor,
          decoration: InputDecoration(
            labelText: context.l10n.fypIntendedMajorLabel,
            hintText: context.l10n.fypIntendedMajorHint,
            prefixIcon: const Icon(Icons.school),
            border: const OutlineInputBorder(),
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
              return context.l10n.fypSelectIntendedMajor;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Field of Study
        DropdownButtonFormField<String>(
          value: _fieldOfStudy,
          decoration: InputDecoration(
            labelText: context.l10n.fypFieldOfStudyLabel,
            prefixIcon: const Icon(Icons.category),
            border: const OutlineInputBorder(),
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
              return context.l10n.fypSelectFieldOfStudy;
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Career Focus
        CheckboxListTile(
          title: Text(context.l10n.fypCareerFocused),
          subtitle: Text(
            context.l10n.fypCareerFocusedSubtitle,
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
          title: Text(context.l10n.fypResearchInterest),
          subtitle: Text(
            context.l10n.fypResearchInterestSubtitle,
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
        Text(
          context.l10n.fypWhereStudy,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypLocationHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Preferred Countries
        Text(
          context.l10n.fypWhereStudyRequired,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.fypSelectCountriesHelper,
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
        Text(
          context.l10n.fypCampusSetting,
          style: const TextStyle(
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
        Text(
          context.l10n.fypUniversityCharacteristics,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypUniversityEnvironmentHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // University Size
        DropdownButtonFormField<String>(
          value: _universitySize,
          decoration: InputDecoration(
            labelText: context.l10n.fypPreferredSizeLabel,
            prefixIcon: const Icon(Icons.people),
            border: const OutlineInputBorder(),
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
          decoration: InputDecoration(
            labelText: context.l10n.fypPreferredTypeLabel,
            prefixIcon: const Icon(Icons.account_balance),
            border: const OutlineInputBorder(),
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
          title: Text(context.l10n.fypSportsInterest),
          subtitle: Text(
            context.l10n.fypSportsInterestSubtitle,
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
        Text(
          context.l10n.fypDesiredFeatures,
          style: const TextStyle(
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
        Text(
          context.l10n.fypFinancialConsiderations,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.fypFinancialHelper,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),

        // Budget Range
        DropdownButtonFormField<String>(
          value: _budgetRange,
          decoration: InputDecoration(
            labelText: context.l10n.fypBudgetRangeLabel,
            prefixIcon: const Icon(Icons.attach_money),
            border: const OutlineInputBorder(),
            helperText: context.l10n.fypBudgetRangeHelper,
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
          title: Text(context.l10n.fypNeedFinancialAid),
          subtitle: Text(
            context.l10n.fypFinancialAidSubtitle,
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
            decoration: InputDecoration(
              labelText: context.l10n.fypInStateTuitionLabel,
              prefixIcon: const Icon(Icons.location_city),
              border: const OutlineInputBorder(),
            ),
            items: [
              DropdownMenuItem(value: null, child: Text(context.l10n.fypNotApplicable)),
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
                child: Text(context.l10n.fypBack),
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
                  : Text(_currentStep == 5 ? context.l10n.fypGetRecommendations : context.l10n.fypNext),
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
              content: Text(context.l10n.fypErrorSavingProfile(profileState.error!)),
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
              content: Text(context.l10n.fypErrorGeneratingRecs(recsState.error!)),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: context.l10n.fypRetry,
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
                  content: Text(context.l10n.fypSignUpToSave),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 5),
                  action: SnackBarAction(
                    label: context.l10n.fypSignUp,
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
            content: Text(context.l10n.fypUnexpectedError(e.toString())),
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
              Text(
                context.l10n.fypGeneratingRecommendations,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.fypGeneratingPleaseWait,
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
