/// University model for Find Your Path feature
class University {
  final int id;
  final String name;
  final String country;
  final String? state;
  final String? city;
  final String? website;
  final String? logoUrl;
  final String? description;
  final String? universityType;
  final String? locationType;
  final int? totalStudents;
  final int? globalRank;
  final int? nationalRank;
  final double? acceptanceRate;
  final double? gpaAverage;
  final int? satMath25th;
  final int? satMath75th;
  final int? satEbrw25th;
  final int? satEbrw75th;
  final int? actComposite25th;
  final int? actComposite75th;
  final double? tuitionOutState;
  final double? totalCost;
  final double? graduationRate;
  final double? medianEarnings;
  final List<Program>? programs;

  University({
    required this.id,
    required this.name,
    required this.country,
    this.state,
    this.city,
    this.website,
    this.logoUrl,
    this.description,
    this.universityType,
    this.locationType,
    this.totalStudents,
    this.globalRank,
    this.nationalRank,
    this.acceptanceRate,
    this.gpaAverage,
    this.satMath25th,
    this.satMath75th,
    this.satEbrw25th,
    this.satEbrw75th,
    this.actComposite25th,
    this.actComposite75th,
    this.tuitionOutState,
    this.totalCost,
    this.graduationRate,
    this.medianEarnings,
    this.programs,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      city: json['city'] as String?,
      website: json['website'] as String?,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      universityType: json['university_type'] as String?,
      locationType: json['location_type'] as String?,
      totalStudents: json['total_students'] as int?,
      globalRank: json['global_rank'] as int?,
      nationalRank: json['national_rank'] as int?,
      acceptanceRate: (json['acceptance_rate'] as num?)?.toDouble(),
      gpaAverage: (json['gpa_average'] as num?)?.toDouble(),
      satMath25th: json['sat_math_25th'] as int?,
      satMath75th: json['sat_math_75th'] as int?,
      satEbrw25th: json['sat_ebrw_25th'] as int?,
      satEbrw75th: json['sat_ebrw_75th'] as int?,
      actComposite25th: json['act_composite_25th'] as int?,
      actComposite75th: json['act_composite_75th'] as int?,
      tuitionOutState: (json['tuition_out_state'] as num?)?.toDouble(),
      totalCost: (json['total_cost'] as num?)?.toDouble(),
      graduationRate: (json['graduation_rate_4year'] as num?)?.toDouble(),
      medianEarnings: (json['median_earnings_10year'] as num?)?.toDouble(),
      programs: json['programs'] != null
          ? (json['programs'] as List)
              .map((p) => Program.fromJson(p as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'state': state,
      'city': city,
      'website': website,
      'logo_url': logoUrl,
      'description': description,
      'university_type': universityType,
      'location_type': locationType,
      'total_students': totalStudents,
      'global_rank': globalRank,
      'national_rank': nationalRank,
      'acceptance_rate': acceptanceRate,
      'gpa_average': gpaAverage,
      'tuition_out_state': tuitionOutState,
      'total_cost': totalCost,
      'graduation_rate_4year': graduationRate,
      'median_earnings_10year': medianEarnings,
    };
  }

  String get location {
    final parts = <String>[];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    parts.add(country);
    return parts.join(', ');
  }

  String? get formattedTuition {
    if (tuitionOutState == null) return null;
    return '\$${tuitionOutState!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
  }

  String? get formattedAcceptanceRate {
    if (acceptanceRate == null) return null;
    return '${acceptanceRate!.toStringAsFixed(1)}%';
  }
}

/// Academic program model
class Program {
  final int id;
  final String name;
  final String degreeType;
  final String? field;
  final String? description;
  final double? medianSalary;

  Program({
    required this.id,
    required this.name,
    required this.degreeType,
    this.field,
    this.description,
    this.medianSalary,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] as int,
      name: json['name'] as String,
      degreeType: json['degree_type'] as String,
      field: json['field'] as String?,
      description: json['description'] as String?,
      medianSalary: (json['median_salary'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'degree_type': degreeType,
      'field': field,
      'description': description,
      'median_salary': medianSalary,
    };
  }
}
