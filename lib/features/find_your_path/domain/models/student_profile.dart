/// Student profile model for questionnaire
class StudentProfile {
  final String userId;

  // Global Academic Information
  final String? gradingSystem; // e.g., 'american', 'ib', 'aLevel', 'french'
  final String? gradeValue; // e.g., '3.8', '38', 'A*', '16'
  final String? nationality; // Country code
  final String? currentCountry; // Country code where currently studying
  final String? currentRegion; // State/Province/Region

  // Standardized Tests (flexible for global tests)
  final String? standardizedTestType; // e.g., 'SAT', 'IB', 'A-Levels', etc.
  final Map<String, dynamic>? testScores; // Flexible scores: {'total': 1400, 'math': 700, 'verbal': 700}

  // Legacy fields (maintained for backward compatibility)
  final double? gpa;
  final double gpaScale;
  final int? satTotal;
  final int? satMath;
  final int? satEbrw;
  final int? actComposite;

  // Academic Interests
  final String? intendedMajor;
  final String? fieldOfStudy;
  final List<String> alternativeMajors;

  // Location Preferences
  final List<String> preferredRegions; // Regions/States within countries
  final List<String> preferredCountries;
  final String? locationTypePreference;

  // University Preferences
  final String? universitySizePreference;
  final String? universityTypePreference;

  // Financial
  final String? budgetRange; // e.g., 'Under $10,000', '$10,000 - $20,000'
  final double? maxBudgetPerYear;
  final bool needFinancialAid;
  final String? eligibleForInState;

  // Interests & Preferences
  final bool interestedInSports;
  final bool careerFocused;
  final bool researchInterest;
  final List<String> featuresDesired;
  final List<String> dealBreakers;

  StudentProfile({
    required this.userId,
    // Global fields
    this.gradingSystem,
    this.gradeValue,
    this.nationality,
    this.currentCountry,
    this.currentRegion,
    this.standardizedTestType,
    this.testScores,
    // Legacy fields
    this.gpa,
    this.gpaScale = 4.0,
    this.satTotal,
    this.satMath,
    this.satEbrw,
    this.actComposite,
    // Academic
    this.intendedMajor,
    this.fieldOfStudy,
    this.alternativeMajors = const [],
    // Location
    this.preferredRegions = const [],
    this.preferredCountries = const [],
    this.locationTypePreference,
    // University
    this.universitySizePreference,
    this.universityTypePreference,
    // Financial
    this.budgetRange,
    this.maxBudgetPerYear,
    this.needFinancialAid = false,
    this.eligibleForInState,
    // Interests
    this.interestedInSports = false,
    this.careerFocused = true,
    this.researchInterest = false,
    this.featuresDesired = const [],
    this.dealBreakers = const [],
  });

  /// Helper to parse boolean values from JSON (handles both bool and int 0/1)
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return null;
  }

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      userId: json['user_id'] as String,
      // Global fields
      gradingSystem: json['grading_system'] as String?,
      gradeValue: json['grade_value'] as String?,
      nationality: json['nationality'] as String?,
      currentCountry: json['current_country'] as String?,
      currentRegion: json['current_region'] as String?,
      standardizedTestType: json['standardized_test_type'] as String?,
      testScores: json['test_scores'] as Map<String, dynamic>?,
      // Legacy fields
      gpa: (json['gpa'] as num?)?.toDouble(),
      gpaScale: (json['gpa_scale'] as num?)?.toDouble() ?? 4.0,
      satTotal: json['sat_total'] as int?,
      satMath: json['sat_math'] as int?,
      satEbrw: json['sat_ebrw'] as int?,
      actComposite: json['act_composite'] as int?,
      // Academic
      intendedMajor: json['intended_major'] as String?,
      fieldOfStudy: json['field_of_study'] as String?,
      alternativeMajors: (json['alternative_majors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      // Location
      preferredRegions: (json['preferred_regions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          (json['preferred_states'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      preferredCountries: (json['preferred_countries'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      locationTypePreference: json['location_type_preference'] as String?,
      // University
      universitySizePreference: json['university_size_preference'] as String?,
      universityTypePreference: json['university_type_preference'] as String?,
      // Financial
      budgetRange: json['budget_range'] as String?,
      maxBudgetPerYear: (json['max_budget_per_year'] as num?)?.toDouble(),
      needFinancialAid: _parseBool(json['need_financial_aid']) ?? false,
      eligibleForInState: json['eligible_for_in_state'] as String?,
      // Interests
      interestedInSports: _parseBool(json['interested_in_sports'] ?? json['sports_important']) ?? false,
      careerFocused: _parseBool(json['career_focused']) ?? true,
      researchInterest: _parseBool(json['research_interest'] ?? json['research_opportunities']) ?? false,
      featuresDesired: (json['features_desired'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dealBreakers: (json['deal_breakers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      // Global fields
      'grading_system': gradingSystem,
      'grade_value': gradeValue,
      'nationality': nationality,
      'current_country': currentCountry,
      'current_region': currentRegion,
      'standardized_test_type': standardizedTestType,
      'test_scores': testScores,
      // Legacy fields
      'gpa': gpa,
      'gpa_scale': gpaScale,
      'sat_total': satTotal,
      'sat_math': satMath,
      'sat_ebrw': satEbrw,
      'act_composite': actComposite,
      // Academic
      'intended_major': intendedMajor,
      'field_of_study': fieldOfStudy,
      'alternative_majors': alternativeMajors,
      // Location
      'preferred_regions': preferredRegions,
      'preferred_states': preferredRegions, // Keep for backward compatibility
      'preferred_countries': preferredCountries,
      'location_type_preference': locationTypePreference,
      // University
      'university_size_preference': universitySizePreference,
      'university_type_preference': universityTypePreference,
      // Financial
      'budget_range': budgetRange,
      'max_budget_per_year': maxBudgetPerYear,
      'need_financial_aid': needFinancialAid,
      'eligible_for_in_state': eligibleForInState,
      // Interests
      'interested_in_sports': interestedInSports,
      'career_focused': careerFocused,
      'research_interest': researchInterest,
      'features_desired': featuresDesired,
      'deal_breakers': dealBreakers,
    };
  }

  StudentProfile copyWith({
    String? userId,
    // Global fields
    String? gradingSystem,
    String? gradeValue,
    String? nationality,
    String? currentCountry,
    String? currentRegion,
    String? standardizedTestType,
    Map<String, dynamic>? testScores,
    // Legacy fields
    double? gpa,
    double? gpaScale,
    int? satTotal,
    int? satMath,
    int? satEbrw,
    int? actComposite,
    // Academic
    String? intendedMajor,
    String? fieldOfStudy,
    List<String>? alternativeMajors,
    // Location
    List<String>? preferredRegions,
    List<String>? preferredCountries,
    String? locationTypePreference,
    // University
    String? universitySizePreference,
    String? universityTypePreference,
    // Financial
    String? budgetRange,
    double? maxBudgetPerYear,
    bool? needFinancialAid,
    String? eligibleForInState,
    // Interests
    bool? interestedInSports,
    bool? careerFocused,
    bool? researchInterest,
    List<String>? featuresDesired,
    List<String>? dealBreakers,
  }) {
    return StudentProfile(
      userId: userId ?? this.userId,
      // Global fields
      gradingSystem: gradingSystem ?? this.gradingSystem,
      gradeValue: gradeValue ?? this.gradeValue,
      nationality: nationality ?? this.nationality,
      currentCountry: currentCountry ?? this.currentCountry,
      currentRegion: currentRegion ?? this.currentRegion,
      standardizedTestType: standardizedTestType ?? this.standardizedTestType,
      testScores: testScores ?? this.testScores,
      // Legacy fields
      gpa: gpa ?? this.gpa,
      gpaScale: gpaScale ?? this.gpaScale,
      satTotal: satTotal ?? this.satTotal,
      satMath: satMath ?? this.satMath,
      satEbrw: satEbrw ?? this.satEbrw,
      actComposite: actComposite ?? this.actComposite,
      // Academic
      intendedMajor: intendedMajor ?? this.intendedMajor,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      alternativeMajors: alternativeMajors ?? this.alternativeMajors,
      // Location
      preferredRegions: preferredRegions ?? this.preferredRegions,
      preferredCountries: preferredCountries ?? this.preferredCountries,
      locationTypePreference:
          locationTypePreference ?? this.locationTypePreference,
      // University
      universitySizePreference:
          universitySizePreference ?? this.universitySizePreference,
      universityTypePreference:
          universityTypePreference ?? this.universityTypePreference,
      // Financial
      budgetRange: budgetRange ?? this.budgetRange,
      maxBudgetPerYear: maxBudgetPerYear ?? this.maxBudgetPerYear,
      needFinancialAid: needFinancialAid ?? this.needFinancialAid,
      eligibleForInState: eligibleForInState ?? this.eligibleForInState,
      // Interests
      interestedInSports: interestedInSports ?? this.interestedInSports,
      careerFocused: careerFocused ?? this.careerFocused,
      researchInterest: researchInterest ?? this.researchInterest,
      featuresDesired: featuresDesired ?? this.featuresDesired,
      dealBreakers: dealBreakers ?? this.dealBreakers,
    );
  }
}
