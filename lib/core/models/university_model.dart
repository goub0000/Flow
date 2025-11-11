/// University model representing college/university data
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
  final double? graduationRate4year;
  final double? medianEarnings10year;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const University({
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
    this.graduationRate4year,
    this.medianEarnings10year,
    this.createdAt,
    this.updatedAt,
  });

  /// Create University from JSON
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
      graduationRate4year: (json['graduation_rate_4year'] as num?)?.toDouble(),
      medianEarnings10year: (json['median_earnings_10year'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  /// Convert University to JSON
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
      'sat_math_25th': satMath25th,
      'sat_math_75th': satMath75th,
      'sat_ebrw_25th': satEbrw25th,
      'sat_ebrw_75th': satEbrw75th,
      'act_composite_25th': actComposite25th,
      'act_composite_75th': actComposite75th,
      'tuition_out_state': tuitionOutState,
      'total_cost': totalCost,
      'graduation_rate_4year': graduationRate4year,
      'median_earnings_10year': medianEarnings10year,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get location string
  String get location {
    if (city != null && state != null) {
      return '$city, $state';
    } else if (state != null) {
      return state!;
    } else if (city != null) {
      return city!;
    }
    return country;
  }

  /// Get formatted tuition cost
  String? get formattedTuition {
    if (tuitionOutState != null) {
      return '\$${tuitionOutState!.toStringAsFixed(0)}';
    }
    if (totalCost != null) {
      return '\$${totalCost!.toStringAsFixed(0)}';
    }
    return null;
  }

  /// Get acceptance rate as percentage
  String? get formattedAcceptanceRate {
    if (acceptanceRate != null) {
      return '${(acceptanceRate! * 100).toStringAsFixed(1)}%';
    }
    return null;
  }

  /// Create copy with updated fields
  University copyWith({
    int? id,
    String? name,
    String? country,
    String? state,
    String? city,
    String? website,
    String? logoUrl,
    String? description,
    String? universityType,
    String? locationType,
    int? totalStudents,
    int? globalRank,
    int? nationalRank,
    double? acceptanceRate,
    double? gpaAverage,
    int? satMath25th,
    int? satMath75th,
    int? satEbrw25th,
    int? satEbrw75th,
    int? actComposite25th,
    int? actComposite75th,
    double? tuitionOutState,
    double? totalCost,
    double? graduationRate4year,
    double? medianEarnings10year,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      website: website ?? this.website,
      logoUrl: logoUrl ?? this.logoUrl,
      description: description ?? this.description,
      universityType: universityType ?? this.universityType,
      locationType: locationType ?? this.locationType,
      totalStudents: totalStudents ?? this.totalStudents,
      globalRank: globalRank ?? this.globalRank,
      nationalRank: nationalRank ?? this.nationalRank,
      acceptanceRate: acceptanceRate ?? this.acceptanceRate,
      gpaAverage: gpaAverage ?? this.gpaAverage,
      satMath25th: satMath25th ?? this.satMath25th,
      satMath75th: satMath75th ?? this.satMath75th,
      satEbrw25th: satEbrw25th ?? this.satEbrw25th,
      satEbrw75th: satEbrw75th ?? this.satEbrw75th,
      actComposite25th: actComposite25th ?? this.actComposite25th,
      actComposite75th: actComposite75th ?? this.actComposite75th,
      tuitionOutState: tuitionOutState ?? this.tuitionOutState,
      totalCost: totalCost ?? this.totalCost,
      graduationRate4year: graduationRate4year ?? this.graduationRate4year,
      medianEarnings10year: medianEarnings10year ?? this.medianEarnings10year,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
