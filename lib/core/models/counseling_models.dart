/// Student record for counselor view
class StudentRecord {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String grade;
  final double gpa;
  final String schoolName;
  final List<String> interests;
  final List<String> strengths;
  final List<String> challenges;
  final int totalSessions;
  final DateTime lastSessionDate;
  final String status; // active, inactive, graduated
  final List<String> goals;
  final int upcomingSessions;

  StudentRecord({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.grade,
    required this.gpa,
    required this.schoolName,
    required this.interests,
    required this.strengths,
    required this.challenges,
    required this.totalSessions,
    required this.lastSessionDate,
    required this.status,
    this.goals = const [],
    this.upcomingSessions = 0,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  factory StudentRecord.fromJson(Map<String, dynamic> json) {
    return StudentRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      grade: json['grade'] as String,
      gpa: (json['gpa'] as num).toDouble(),
      schoolName: json['schoolName'] as String,
      interests: List<String>.from(json['interests'] as List),
      strengths: List<String>.from(json['strengths'] as List),
      challenges: List<String>.from(json['challenges'] as List),
      totalSessions: json['totalSessions'] as int,
      lastSessionDate: DateTime.parse(json['lastSessionDate'] as String),
      status: json['status'] as String,
      goals: json['goals'] != null ? List<String>.from(json['goals'] as List) : const [],
      upcomingSessions: json['upcomingSessions'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'grade': grade,
      'gpa': gpa,
      'schoolName': schoolName,
      'interests': interests,
      'strengths': strengths,
      'challenges': challenges,
      'totalSessions': totalSessions,
      'lastSessionDate': lastSessionDate.toIso8601String(),
      'status': status,
      'goals': goals,
      'upcomingSessions': upcomingSessions,
    };
  }

  /// Single mock student record for development
  static StudentRecord mockStudentRecord([int index = 0]) {
    final names = ['Amara Okoye', 'Kwame Mensah', 'Fatima Hassan', 'Chidi Nwosu', 'Aisha Kamara'];
    final schools = ['Lagos International School', 'Accra Academy', 'University of Nairobi', 'Port Harcourt High School', 'Freetown Secondary School'];
    final statuses = ['active', 'active', 'graduated', 'inactive'];

    return StudentRecord(
      id: 'student${index + 1}',
      name: names[index % names.length],
      email: 'student${index + 1}@email.com',
      grade: '${10 + (index % 3)}th Grade',
      gpa: 3.0 + (index % 10) * 0.1,
      schoolName: schools[index % schools.length],
      interests: ['Mathematics', 'Science', 'Technology'],
      strengths: ['Problem solving', 'Communication'],
      challenges: ['Time management'],
      totalSessions: 5 + (index % 10),
      lastSessionDate: DateTime.now().subtract(Duration(days: index + 1)),
      status: statuses[index % statuses.length],
      goals: ['Get into top university', 'Improve GPA'],
      upcomingSessions: index % 3,
    );
  }
}

/// Counseling session
class CounselingSession {
  final String id;
  final String studentId;
  final String studentName;
  final String counselorId;
  final DateTime scheduledDate;
  final Duration duration;
  final String type; // individual, group, career, academic, personal
  final String status; // scheduled, completed, cancelled, no_show
  final String? notes;
  final String? summary;
  final List<String>? actionItems;
  final DateTime createdAt;
  final String location;
  final DateTime? followUpDate;

  CounselingSession({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.counselorId,
    required this.scheduledDate,
    required this.duration,
    required this.type,
    required this.status,
    this.notes,
    this.summary,
    this.actionItems,
    required this.createdAt,
    this.location = 'Office A',
    this.followUpDate,
  });

  bool get isUpcoming => scheduledDate.isAfter(DateTime.now()) && status == 'scheduled';
  bool get isPast => scheduledDate.isBefore(DateTime.now());
  bool get isToday {
    final now = DateTime.now();
    return scheduledDate.year == now.year &&
        scheduledDate.month == now.month &&
        scheduledDate.day == now.day;
  }

  factory CounselingSession.fromJson(Map<String, dynamic> json) {
    return CounselingSession(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      counselorId: json['counselorId'] as String,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      duration: Duration(minutes: json['durationMinutes'] as int),
      type: json['type'] as String,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      summary: json['summary'] as String?,
      actionItems: json['actionItems'] != null
          ? List<String>.from(json['actionItems'] as List)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      location: json['location'] as String? ?? 'Office A',
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'counselorId': counselorId,
      'scheduledDate': scheduledDate.toIso8601String(),
      'durationMinutes': duration.inMinutes,
      'type': type,
      'status': status,
      'notes': notes,
      'summary': summary,
      'actionItems': actionItems,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
      'followUpDate': followUpDate?.toIso8601String(),
    };
  }

  /// Single mock session for development
  static CounselingSession mockSession([int index = 0]) {
    final now = DateTime.now();
    final names = ['Amara Okoye', 'Kwame Mensah', 'Fatima Hassan', 'Chidi Nwosu', 'Aisha Kamara'];
    final types = ['career', 'academic', 'individual', 'personal', 'group'];
    final statuses = ['scheduled', 'completed', 'scheduled', 'completed', 'scheduled'];

    return CounselingSession(
      id: 'session${index + 1}',
      studentId: 'student${index + 1}',
      studentName: names[index % names.length],
      counselorId: 'counselor1',
      scheduledDate: now.add(Duration(hours: 2 + index)),
      duration: Duration(minutes: 45 + (index % 3) * 15),
      type: types[index % types.length],
      status: statuses[index % statuses.length],
      createdAt: now.subtract(Duration(days: 3 + index)),
      location: 'Office ${String.fromCharCode(65 + (index % 5))}',
    );
  }

  /// Mock sessions for development
  static List<CounselingSession> mockSessions() {
    final now = DateTime.now();
    return [
      CounselingSession(
        id: 'session1',
        studentId: 'student1',
        studentName: 'Amara Okoye',
        counselorId: 'counselor1',
        scheduledDate: now.add(const Duration(hours: 2)),
        duration: const Duration(minutes: 45),
        type: 'career',
        status: 'scheduled',
        createdAt: now.subtract(const Duration(days: 3)),
      ),
      CounselingSession(
        id: 'session2',
        studentId: 'student3',
        studentName: 'Fatima Hassan',
        counselorId: 'counselor1',
        scheduledDate: now.add(const Duration(days: 1, hours: 10)),
        duration: const Duration(minutes: 60),
        type: 'academic',
        status: 'scheduled',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      CounselingSession(
        id: 'session3',
        studentId: 'student2',
        studentName: 'Kwame Mensah',
        counselorId: 'counselor1',
        scheduledDate: now.subtract(const Duration(days: 2)),
        duration: const Duration(minutes: 45),
        type: 'individual',
        status: 'completed',
        notes: 'Discussed university application strategy and timeline.',
        summary: 'Student is well-prepared for applications. Recommended 3 target universities.',
        actionItems: [
          'Complete personal statement draft by next week',
          'Request recommendation letters from 2 teachers',
          'Research scholarship opportunities'
        ],
        createdAt: now.subtract(const Duration(days: 7)),
      ),
      CounselingSession(
        id: 'session4',
        studentId: 'student4',
        studentName: 'Chidi Nwosu',
        counselorId: 'counselor1',
        scheduledDate: now.subtract(const Duration(days: 5)),
        duration: const Duration(minutes: 30),
        type: 'personal',
        status: 'completed',
        notes: 'Student expressed concerns about academic performance and career path.',
        summary: 'Explored interests and strengths. Discussed various career options in creative fields.',
        actionItems: [
          'Take career assessment quiz',
          'Shadow a professional in field of interest',
          'Improve study habits - created schedule'
        ],
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      CounselingSession(
        id: 'session5',
        studentId: 'student1',
        studentName: 'Amara Okoye',
        counselorId: 'counselor1',
        scheduledDate: now.add(const Duration(days: 3, hours: 14)),
        duration: const Duration(minutes: 45),
        type: 'career',
        status: 'scheduled',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}

/// Recommendation letter
class Recommendation {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String counselorId;
  final String institutionName;
  final String programName;
  final String status; // draft, submitted, accepted
  final String? content;
  final DateTime requestedDate;
  final DateTime? submittedDate;
  final DateTime? deadline;

  Recommendation({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.counselorId,
    required this.institutionName,
    required this.programName,
    required this.status,
    this.content,
    required this.requestedDate,
    this.submittedDate,
    this.deadline,
  });

  bool get isDraft => status == 'draft';
  bool get isSubmitted => status == 'submitted';
  bool get isOverdue =>
      deadline != null && DateTime.now().isAfter(deadline!) && !isSubmitted;

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      studentEmail: json['studentEmail'] as String,
      counselorId: json['counselorId'] as String,
      institutionName: json['institutionName'] as String,
      programName: json['programName'] as String,
      status: json['status'] as String,
      content: json['content'] as String?,
      requestedDate: DateTime.parse(json['requestedDate'] as String),
      submittedDate: json['submittedDate'] != null
          ? DateTime.parse(json['submittedDate'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'counselorId': counselorId,
      'institutionName': institutionName,
      'programName': programName,
      'status': status,
      'content': content,
      'requestedDate': requestedDate.toIso8601String(),
      'submittedDate': submittedDate?.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
    };
  }

  /// Single mock recommendation for development
  static Recommendation mockRecommendation([int index = 0]) {
    final now = DateTime.now();
    final students = ['Amara Okoye', 'Kwame Mensah', 'Fatima Hassan', 'Chidi Nwosu'];
    final institutions = ['University of Ghana', 'Makerere University', 'MIT', 'Johns Hopkins'];
    final programs = ['Bachelor of Computer Science', 'MBA - Business Administration', 'Engineering', 'Medicine'];
    final statuses = ['draft', 'submitted', 'draft', 'submitted'];

    return Recommendation(
      id: 'rec${index + 1}',
      studentId: 'student${index + 1}',
      studentName: students[index % students.length],
      studentEmail: '${students[index % students.length].toLowerCase().replaceAll(' ', '.')}@email.com',
      counselorId: 'counselor1',
      institutionName: institutions[index % institutions.length],
      programName: programs[index % programs.length],
      status: statuses[index % statuses.length],
      requestedDate: now.subtract(Duration(days: 5 + index)),
      deadline: now.add(Duration(days: 10 + index * 5)),
    );
  }

  /// Mock recommendations for development
  static List<Recommendation> mockRecommendations() {
    final now = DateTime.now();
    return [
      Recommendation(
        id: 'rec1',
        studentId: 'student1',
        studentName: 'Amara Okoye',
        studentEmail: 'amara.okoye@email.com',
        counselorId: 'counselor1',
        institutionName: 'University of Ghana',
        programName: 'Bachelor of Computer Science',
        status: 'draft',
        requestedDate: now.subtract(const Duration(days: 5)),
        deadline: now.add(const Duration(days: 10)),
      ),
      Recommendation(
        id: 'rec2',
        studentId: 'student3',
        studentName: 'Fatima Hassan',
        studentEmail: 'fatima.hassan@email.com',
        counselorId: 'counselor1',
        institutionName: 'Johns Hopkins University',
        programName: 'MBA - Business Administration',
        status: 'submitted',
        content:
            'I am pleased to recommend Fatima Hassan for admission to your MBA program. During the three years I have known Fatima, she has consistently demonstrated exceptional leadership, analytical thinking, and commitment to excellence...',
        requestedDate: now.subtract(const Duration(days: 20)),
        submittedDate: now.subtract(const Duration(days: 5)),
        deadline: now.subtract(const Duration(days: 7)),
      ),
      Recommendation(
        id: 'rec3',
        studentId: 'student2',
        studentName: 'Kwame Mensah',
        studentEmail: 'kwame.mensah@email.com',
        counselorId: 'counselor1',
        institutionName: 'MIT',
        programName: 'Engineering',
        status: 'draft',
        requestedDate: now.subtract(const Duration(days: 3)),
        deadline: now.add(const Duration(days: 15)),
      ),
    ];
  }
}
