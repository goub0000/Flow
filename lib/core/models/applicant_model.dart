/// Applicant details for institution review
class Applicant {
  final String id;
  final String applicationId;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String studentPhone;
  final String programId;
  final String programName;
  final String status; // pending, under_review, accepted, rejected
  final DateTime submittedAt;
  final DateTime appliedDate;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? reviewNotes;
  final double gpa;
  final String previousSchool;
  final List<Document> documents;
  final String statementOfPurpose;
  final Map<String, dynamic>? testScores;

  Applicant({
    required this.id,
    required this.applicationId,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.studentPhone,
    required this.programId,
    required this.programName,
    required this.status,
    required this.submittedAt,
    DateTime? appliedDate,
    this.reviewedAt,
    this.reviewedBy,
    this.reviewNotes,
    required this.gpa,
    required this.previousSchool,
    required this.documents,
    required this.statementOfPurpose,
    this.testScores,
  }) : appliedDate = appliedDate ?? submittedAt;

  bool get isPending => status == 'pending';
  bool get isUnderReview => status == 'under_review';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      id: json['id'] as String,
      applicationId: json['applicationId'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      studentPhone: json['studentPhone'] as String,
      programId: json['programId'] as String,
      programName: json['programName'] as String,
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      appliedDate: json['appliedDate'] != null
          ? DateTime.parse(json['appliedDate'] as String)
          : DateTime.parse(json['submittedAt'] as String),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String)
          : null,
      reviewedBy: json['reviewedBy'] as String?,
      reviewNotes: json['reviewNotes'] as String?,
      gpa: (json['gpa'] as num).toDouble(),
      previousSchool: json['previousSchool'] as String,
      documents: (json['documents'] as List)
          .map((doc) => Document.fromJson(doc as Map<String, dynamic>))
          .toList(),
      statementOfPurpose: json['statementOfPurpose'] as String,
      testScores: json['testScores'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'applicationId': applicationId,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'studentPhone': studentPhone,
      'programId': programId,
      'programName': programName,
      'status': status,
      'submittedAt': submittedAt.toIso8601String(),
      'appliedDate': appliedDate.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedBy': reviewedBy,
      'reviewNotes': reviewNotes,
      'gpa': gpa,
      'previousSchool': previousSchool,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'statementOfPurpose': statementOfPurpose,
      'testScores': testScores,
    };
  }

  /// Single mock applicant for development
  static Applicant mockApplicant([int index = 0]) {
    final now = DateTime.now();
    final names = ['Amara Okoye', 'Kwame Mensah', 'Fatima Hassan', 'Chidi Nwosu', 'Aisha Kamara'];
    final statuses = ['pending', 'under_review', 'accepted', 'rejected'];

    return Applicant(
      id: 'app${index + 1}',
      applicationId: 'application${index + 1}',
      studentId: 'student${index + 1}',
      studentName: names[index % names.length],
      studentEmail: 'student${index + 1}@email.com',
      studentPhone: '+234 ${800 + index} 234 5678',
      programId: 'prog${(index % 3) + 1}',
      programName: 'Bachelor of Computer Science',
      status: statuses[index % statuses.length],
      submittedAt: now.subtract(Duration(hours: 6 + index)),
      appliedDate: now.subtract(Duration(hours: 6 + index)),
      gpa: 2.5 + (index % 15) * 0.1,
      previousSchool: 'Secondary School ${index + 1}',
      documents: [
        Document(
          id: 'doc${index + 1}',
          name: 'Transcript.pdf',
          type: 'transcript',
          url: 'https://example.com/doc${index + 1}.pdf',
          uploadedAt: now.subtract(Duration(hours: 7 + index)),
        ),
      ],
      statementOfPurpose:
          'I am passionate about technology and want to contribute to Africa\'s digital transformation.',
      testScores: {'SAT': 1400 + (index * 10), 'TOEFL': 100 + index},
    );
  }

  /// Mock applicants for development
  static List<Applicant> mockApplicants({String? programId}) {
    final now = DateTime.now();
    return [
      Applicant(
        id: 'app1',
        applicationId: 'application1',
        studentId: 'student1',
        studentName: 'Amara Okoye',
        studentEmail: 'amara.okoye@email.com',
        studentPhone: '+234 801 234 5678',
        programId: programId ?? 'prog1',
        programName: 'Bachelor of Computer Science',
        status: 'pending',
        submittedAt: now.subtract(const Duration(hours: 6)),
        gpa: 3.8,
        previousSchool: 'Lagos Secondary School',
        documents: [
          Document(
            id: 'doc1',
            name: 'Transcript.pdf',
            type: 'transcript',
            url: 'https://example.com/doc1.pdf',
            uploadedAt: now.subtract(const Duration(hours: 7)),
          ),
          Document(
            id: 'doc2',
            name: 'ID_Card.pdf',
            type: 'id',
            url: 'https://example.com/doc2.pdf',
            uploadedAt: now.subtract(const Duration(hours: 7)),
          ),
        ],
        statementOfPurpose:
            'I am passionate about technology and want to contribute to Africa\'s digital transformation. With my strong academic background and programming experience, I believe this program will help me achieve my goals.',
      ),
      Applicant(
        id: 'app2',
        applicationId: 'application2',
        studentId: 'student2',
        studentName: 'Kwame Mensah',
        studentEmail: 'kwame.mensah@email.com',
        studentPhone: '+233 24 567 8901',
        programId: programId ?? 'prog1',
        programName: 'Bachelor of Computer Science',
        status: 'under_review',
        submittedAt: now.subtract(const Duration(days: 2)),
        reviewedAt: now.subtract(const Duration(days: 1)),
        reviewedBy: 'Dr. Sarah Johnson',
        gpa: 3.5,
        previousSchool: 'Accra Academy',
        documents: [
          Document(
            id: 'doc3',
            name: 'Academic_Transcript.pdf',
            type: 'transcript',
            url: 'https://example.com/doc3.pdf',
            uploadedAt: now.subtract(const Duration(days: 2)),
          ),
          Document(
            id: 'doc4',
            name: 'National_ID.pdf',
            type: 'id',
            url: 'https://example.com/doc4.pdf',
            uploadedAt: now.subtract(const Duration(days: 2)),
          ),
        ],
        statementOfPurpose:
            'Growing up in Accra, I witnessed the impact of technology on our daily lives. I want to be part of creating innovative solutions for African challenges.',
      ),
      Applicant(
        id: 'app3',
        applicationId: 'application3',
        studentId: 'student3',
        studentName: 'Fatima Hassan',
        studentEmail: 'fatima.hassan@email.com',
        studentPhone: '+254 701 234 567',
        programId: programId ?? 'prog2',
        programName: 'MBA - Business Administration',
        status: 'accepted',
        submittedAt: now.subtract(const Duration(days: 5)),
        reviewedAt: now.subtract(const Duration(days: 3)),
        reviewedBy: 'Prof. Michael Adeyemi',
        reviewNotes:
            'Excellent academic record and strong work experience. Leadership potential evident in application.',
        gpa: 3.9,
        previousSchool: 'University of Nairobi',
        documents: [
          Document(
            id: 'doc5',
            name: 'Bachelor_Degree.pdf',
            type: 'transcript',
            url: 'https://example.com/doc5.pdf',
            uploadedAt: now.subtract(const Duration(days: 5)),
          ),
          Document(
            id: 'doc6',
            name: 'Work_Experience.pdf',
            type: 'other',
            url: 'https://example.com/doc6.pdf',
            uploadedAt: now.subtract(const Duration(days: 5)),
          ),
          Document(
            id: 'doc7',
            name: 'GMAT_Score.pdf',
            type: 'other',
            url: 'https://example.com/doc7.pdf',
            uploadedAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        statementOfPurpose:
            'With 5 years of experience in marketing and a passion for entrepreneurship, I am ready to advance my career through this MBA program.',
      ),
      Applicant(
        id: 'app4',
        applicationId: 'application4',
        studentId: 'student4',
        studentName: 'Chidi Nwosu',
        studentEmail: 'chidi.nwosu@email.com',
        studentPhone: '+234 802 345 6789',
        programId: programId ?? 'prog1',
        programName: 'Bachelor of Computer Science',
        status: 'rejected',
        submittedAt: now.subtract(const Duration(days: 10)),
        reviewedAt: now.subtract(const Duration(days: 8)),
        reviewedBy: 'Dr. Sarah Johnson',
        reviewNotes:
            'Does not meet minimum GPA requirements. Candidate encouraged to reapply after completing foundation courses.',
        gpa: 2.5,
        previousSchool: 'Port Harcourt High School',
        documents: [
          Document(
            id: 'doc8',
            name: 'Transcript.pdf',
            type: 'transcript',
            url: 'https://example.com/doc8.pdf',
            uploadedAt: now.subtract(const Duration(days: 10)),
          ),
        ],
        statementOfPurpose:
            'I have always been interested in computers and want to learn programming.',
      ),
      Applicant(
        id: 'app5',
        applicationId: 'application5',
        studentId: 'student5',
        studentName: 'Aisha Kamara',
        studentEmail: 'aisha.kamara@email.com',
        studentPhone: '+232 76 123 456',
        programId: programId ?? 'prog3',
        programName: 'Certificate in Digital Marketing',
        status: 'pending',
        submittedAt: now.subtract(const Duration(hours: 12)),
        gpa: 3.2,
        previousSchool: 'Freetown Secondary School',
        documents: [
          Document(
            id: 'doc9',
            name: 'School_Certificate.pdf',
            type: 'transcript',
            url: 'https://example.com/doc9.pdf',
            uploadedAt: now.subtract(const Duration(hours: 12)),
          ),
        ],
        statementOfPurpose:
            'I want to help local businesses in Sierra Leone grow through digital marketing.',
      ),
    ];
  }
}

/// Document attached to application
class Document {
  final String id;
  final String name;
  final String type; // transcript, id, photo, recommendation, other
  final String url;
  final DateTime uploadedAt;
  final String? category; // folder/category for organization

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.uploadedAt,
    this.category,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'url': url,
      'uploadedAt': uploadedAt.toIso8601String(),
      'category': category,
    };
  }

  Document copyWith({
    String? id,
    String? name,
    String? type,
    String? url,
    String? category,
    DateTime? uploadedAt,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      category: category ?? this.category,
    );
  }

  /// Mock document for development
  static Document mockDocument([int index = 0]) {
    final types = ['transcript', 'id', 'photo', 'recommendation', 'other'];
    final names = ['Transcript.pdf', 'ID_Card.jpg', 'Photo.jpg', 'Recommendation_Letter.pdf', 'Certificate.pdf'];

    return Document(
      id: 'doc${index + 1}',
      name: names[index % names.length],
      type: types[index % types.length],
      url: 'https://example.com/${names[index % names.length]}',
      uploadedAt: DateTime.now().subtract(Duration(days: index + 1)),
    );
  }
}
