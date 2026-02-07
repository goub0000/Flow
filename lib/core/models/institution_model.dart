/// Institution Model
/// Represents a registered institution (user account) in the Flow platform
/// This is DIFFERENT from University model which is used for recommendations
library;

class Institution {
  final String id; // UUID from users table
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final DateTime? createdAt;
  final bool isVerified;
  final int programsCount;
  final int coursesCount;

  Institution({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
    this.createdAt,
    required this.isVerified,
    required this.programsCount,
    required this.coursesCount,
  });

  /// Create Institution from API JSON response
  factory Institution.fromJson(Map<String, dynamic> json) {
    return Institution(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      photoUrl: json['photo_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      isVerified: json['is_verified'] as bool? ?? false,
      programsCount: json['programs_count'] as int? ?? 0,
      coursesCount: json['courses_count'] as int? ?? 0,
    );
  }

  /// Convert Institution to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'photo_url': photoUrl,
      'created_at': createdAt?.toIso8601String(),
      'is_verified': isVerified,
      'programs_count': programsCount,
      'courses_count': coursesCount,
    };
  }

  /// Create a copy with modified fields
  Institution copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    DateTime? createdAt,
    bool? isVerified,
    int? programsCount,
    int? coursesCount,
  }) {
    return Institution(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      programsCount: programsCount ?? this.programsCount,
      coursesCount: coursesCount ?? this.coursesCount,
    );
  }

  /// Get formatted location or default text
  String get location {
    // Institutions don't have location field, so return email domain or generic
    if (email.contains('@')) {
      final domain = email.split('@').last;
      return domain;
    }
    return 'Institution';
  }

  /// Get formatted programs count text
  String get formattedProgramsCount {
    if (programsCount == 0) return 'No programs';
    if (programsCount == 1) return '1 program';
    return '$programsCount programs';
  }

  /// Get formatted courses count text
  String get formattedCoursesCount {
    if (coursesCount == 0) return 'No courses';
    if (coursesCount == 1) return '1 course';
    return '$coursesCount courses';
  }

  /// Get verification status text
  String get verificationStatus {
    return isVerified ? 'Verified' : 'Not verified';
  }

  /// Get total offerings (programs + courses)
  int get totalOfferings => programsCount + coursesCount;

  /// Get formatted total offerings text
  String get formattedTotalOfferings {
    if (totalOfferings == 0) return 'No offerings';
    if (totalOfferings == 1) return '1 offering';
    return '$totalOfferings offerings';
  }

  /// Check if institution has any offerings
  bool get hasOfferings => totalOfferings > 0;

  @override
  String toString() {
    return 'Institution(id: $id, name: $name, email: $email, '
        'programs: $programsCount, courses: $coursesCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Institution &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode;
  }
}

/// Paginated response for institutions list
class InstitutionsListResponse {
  final List<Institution> institutions;
  final int total;
  final int page;
  final int pageSize;

  InstitutionsListResponse({
    required this.institutions,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory InstitutionsListResponse.fromJson(Map<String, dynamic> json) {
    return InstitutionsListResponse(
      institutions: (json['institutions'] as List<dynamic>)
          .map((item) => Institution.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'institutions': institutions.map((inst) => inst.toJson()).toList(),
      'total': total,
      'page': page,
      'page_size': pageSize,
    };
  }

  /// Check if there are more pages available
  bool get hasMorePages {
    final totalPages = (total / pageSize).ceil();
    return page < totalPages;
  }

  /// Calculate total number of pages
  int get totalPages {
    return (total / pageSize).ceil();
  }

  @override
  String toString() {
    return 'InstitutionsListResponse(total: $total, page: $page/$totalPages, '
        'institutions: ${institutions.length})';
  }
}
