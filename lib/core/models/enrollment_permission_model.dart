/// Enrollment Permission Model
/// Tracks which students can enroll in which courses

class EnrollmentPermission {
  final String id;
  final String studentId;
  final String courseId;
  final String institutionId;
  final PermissionStatus status;
  final PermissionGrantedBy grantedBy;
  final String? grantedByUserId;
  final DateTime? reviewedAt;
  final String? reviewedByUserId;
  final String? denialReason;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? notes;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related data from joins
  final String? studentEmail;
  final String? studentDisplayName;
  final String? courseTitle;

  EnrollmentPermission({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.institutionId,
    required this.status,
    required this.grantedBy,
    this.grantedByUserId,
    this.reviewedAt,
    this.reviewedByUserId,
    this.denialReason,
    this.validFrom,
    this.validUntil,
    this.notes,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.studentEmail,
    this.studentDisplayName,
    this.courseTitle,
  });

  factory EnrollmentPermission.fromJson(Map<String, dynamic> json) {
    // Handle nested user data from join
    final userData = json['users'] as Map<String, dynamic>?;
    final courseData = json['courses'] as Map<String, dynamic>?;

    return EnrollmentPermission(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      courseId: json['course_id'] as String,
      institutionId: json['institution_id'] as String,
      status: PermissionStatus.fromString(json['status'] as String),
      grantedBy: PermissionGrantedBy.fromString(json['granted_by'] as String),
      grantedByUserId: json['granted_by_user_id'] as String?,
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewedByUserId: json['reviewed_by_user_id'] as String?,
      denialReason: json['denial_reason'] as String?,
      validFrom: json['valid_from'] != null
          ? DateTime.parse(json['valid_from'] as String)
          : null,
      validUntil: json['valid_until'] != null
          ? DateTime.parse(json['valid_until'] as String)
          : null,
      notes: json['notes'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      studentEmail: userData?['email'] as String?,
      studentDisplayName: userData?['display_name'] as String?,
      courseTitle: courseData?['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'course_id': courseId,
      'institution_id': institutionId,
      'status': status.value,
      'granted_by': grantedBy.value,
      'granted_by_user_id': grantedByUserId,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'reviewed_by_user_id': reviewedByUserId,
      'denial_reason': denialReason,
      'valid_from': validFrom?.toIso8601String(),
      'valid_until': validUntil?.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == PermissionStatus.pending;
  bool get isApproved => status == PermissionStatus.approved;
  bool get isDenied => status == PermissionStatus.denied;
  bool get isRevoked => status == PermissionStatus.revoked;

  bool get isValid {
    if (!isApproved) return false;
    if (validUntil != null && DateTime.now().isAfter(validUntil!)) {
      return false;
    }
    return true;
  }
}

/// Permission Status Enumeration
enum PermissionStatus {
  pending,
  approved,
  denied,
  revoked;

  String get value => name;
  String get displayName {
    switch (this) {
      case PermissionStatus.pending:
        return 'Pending';
      case PermissionStatus.approved:
        return 'Approved';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.revoked:
        return 'Revoked';
    }
  }

  static PermissionStatus fromString(String value) {
    return PermissionStatus.values.firstWhere(
      (e) => e.value == value.toLowerCase(),
      orElse: () => PermissionStatus.pending,
    );
  }
}

/// How permission was granted
enum PermissionGrantedBy {
  institution,
  studentRequest,
  autoAdmission;

  String get value => name == 'studentRequest' ? 'student_request' : name == 'autoAdmission' ? 'auto_admission' : name;

  String get displayName {
    switch (this) {
      case PermissionGrantedBy.institution:
        return 'Institution';
      case PermissionGrantedBy.studentRequest:
        return 'Student Request';
      case PermissionGrantedBy.autoAdmission:
        return 'Auto Admission';
    }
  }

  static PermissionGrantedBy fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('_', '');
    switch (normalized) {
      case 'institution':
        return PermissionGrantedBy.institution;
      case 'studentrequest':
        return PermissionGrantedBy.studentRequest;
      case 'autoadmission':
        return PermissionGrantedBy.autoAdmission;
      default:
        return PermissionGrantedBy.institution;
    }
  }
}
