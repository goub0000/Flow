/// Application model for institution applications
class Application {
  final String id;
  final String studentId;
  final String institutionId;
  final String institutionName;
  final String programName;
  final String status; // pending, under_review, accepted, rejected
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final Map<String, dynamic> documents; // Document URLs/references
  final Map<String, dynamic> personalInfo;
  final Map<String, dynamic> academicInfo;
  final double? applicationFee;
  final bool feePaid;

  const Application({
    required this.id,
    required this.studentId,
    required this.institutionId,
    required this.institutionName,
    required this.programName,
    this.status = 'pending',
    required this.submittedAt,
    this.reviewedAt,
    this.reviewNotes,
    this.documents = const {},
    this.personalInfo = const {},
    this.academicInfo = const {},
    this.applicationFee,
    this.feePaid = false,
  });

  bool get isPending => status == 'pending';
  bool get isUnderReview => status == 'under_review';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['id'] as String,
      studentId: json['student_id'] as String,
      institutionId: json['institution_id'] as String,
      institutionName: json['institution_name'] as String,
      programName: json['program_name'] as String,
      status: json['status'] as String? ?? 'pending',
      submittedAt: DateTime.parse(json['created_at'] as String),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'] as String)
          : null,
      reviewNotes: json['reviewer_notes'] as String?,
      documents: json['documents'] is List
          ? (json['documents'] as List).isEmpty
              ? {}
              : (json['documents'] as List).first as Map<String, dynamic>
          : json['documents'] as Map<String, dynamic>? ?? {},
      personalInfo: json['personal_info'] as Map<String, dynamic>? ?? {},
      academicInfo: json['academic_info'] as Map<String, dynamic>? ?? {},
      applicationFee: (json['application_fee'] as num?)?.toDouble(),
      feePaid: false, // Fee payment status not stored in DB yet
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'institutionId': institutionId,
      'institutionName': institutionName,
      'programName': programName,
      'status': status,
      'submittedAt': submittedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewNotes': reviewNotes,
      'documents': documents,
      'personalInfo': personalInfo,
      'academicInfo': academicInfo,
      'applicationFee': applicationFee,
      'feePaid': feePaid,
    };
  }

  /// Single mock application for development
  static Application mockApplication([int index = 0]) {
    final institutions = ['University of Ghana', 'Makerere University', 'University of Cape Town', 'University of Lagos'];
    final programs = ['Bachelor of Computer Science', 'MBA - Business Administration', 'Bachelor of Medicine', 'Engineering'];
    final statuses = ['under_review', 'pending', 'accepted', 'rejected'];

    return Application(
      id: 'app${index + 1}',
      studentId: 'student1',
      institutionId: 'inst${index + 1}',
      institutionName: institutions[index % institutions.length],
      programName: programs[index % programs.length],
      status: statuses[index % statuses.length],
      submittedAt: DateTime.now().subtract(Duration(days: 15 + index * 5)),
      documents: {},
      personalInfo: {},
      academicInfo: {},
      applicationFee: 50.0 + (index * 25),
      feePaid: index % 2 == 0,
    );
  }
}
