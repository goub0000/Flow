import 'package:flutter/foundation.dart' show kDebugMode;

/// Child model for parent monitoring
class Child {
  final String id;
  final String parentId;
  final String name;
  final String email;
  final DateTime dateOfBirth;
  final String? photoUrl;
  final String? schoolName;
  final String grade;
  final List<String> enrolledCourses;
  final List<ChildApplication> applications;
  final double averageGrade;
  final DateTime lastActive;

  Child({
    required this.id,
    required this.parentId,
    required this.name,
    required this.email,
    required this.dateOfBirth,
    this.photoUrl,
    this.schoolName,
    required this.grade,
    required this.enrolledCourses,
    required this.applications,
    required this.averageGrade,
    required this.lastActive,
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  // Alias for compatibility
  String? get school => schoolName;

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as String,
      parentId: json['parentId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      photoUrl: json['photoUrl'] as String?,
      schoolName: json['schoolName'] as String?,
      grade: json['grade'] as String,
      enrolledCourses: List<String>.from(json['enrolledCourses'] as List),
      applications: (json['applications'] as List)
          .map((app) => ChildApplication.fromJson(app as Map<String, dynamic>))
          .toList(),
      averageGrade: (json['averageGrade'] as num).toDouble(),
      lastActive: DateTime.parse(json['lastActive'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'photoUrl': photoUrl,
      'schoolName': schoolName,
      'grade': grade,
      'enrolledCourses': enrolledCourses,
      'applications': applications.map((app) => app.toJson()).toList(),
      'averageGrade': averageGrade,
      'lastActive': lastActive.toIso8601String(),
    };
  }

  /// Single mock child for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static Child? mockChild([int index = 0]) {
    if (!kDebugMode) {
      assert(false, 'mockChild should not be called in release mode');
      return null;
    }

    final now = DateTime.now();
    final names = ['Amara Okafor', 'Kwame Mensah', 'Fatima Hassan', 'Chidi Nwosu'];
    final schools = ['Lagos International School', 'Accra Academy', 'Nairobi High School', 'Cape Town College'];
    final grades = ['10th Grade', '11th Grade', '9th Grade', '12th Grade'];

    return Child(
      id: 'child${index + 1}',
      parentId: 'parent1',
      name: names[index % names.length],
      email: '${names[index % names.length].toLowerCase().replaceAll(' ', '.')}@email.com',
      dateOfBirth: DateTime(2008 + index, 5, 15),
      schoolName: schools[index % schools.length],
      grade: grades[index % grades.length],
      enrolledCourses: ['Mathematics', 'Physics', 'Computer Science'],
      applications: [],
      averageGrade: 85.0 + (index % 10),
      lastActive: now.subtract(Duration(hours: 3 + index)),
    );
  }

  /// Mock children for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static List<Child> mockChildren({String? parentId}) {
    if (!kDebugMode) {
      assert(false, 'mockChildren should not be called in release mode');
      return [];
    }

    final now = DateTime.now();
    return [
      Child(
        id: 'child1',
        parentId: parentId ?? 'parent1',
        name: 'Amara Okafor',
        email: 'amara.okafor@email.com',
        dateOfBirth: DateTime(2008, 5, 15),
        schoolName: 'Lagos International School',
        grade: '10th Grade',
        enrolledCourses: ['Mathematics', 'Physics', 'Computer Science'],
        applications: [
          ChildApplication(
            id: 'app1',
            institutionName: 'University of Ghana',
            programName: 'Bachelor of Computer Science',
            status: 'under_review',
            submittedAt: now.subtract(const Duration(days: 15)),
          ),
          ChildApplication(
            id: 'app2',
            institutionName: 'University of Lagos',
            programName: 'Software Engineering',
            status: 'pending',
            submittedAt: now.subtract(const Duration(days: 5)),
          ),
        ],
        averageGrade: 88.5,
        lastActive: now.subtract(const Duration(hours: 3)),
      ),
      Child(
        id: 'child2',
        parentId: parentId ?? 'parent1',
        name: 'Chidi Okafor',
        email: 'chidi.okafor@email.com',
        dateOfBirth: DateTime(2011, 9, 22),
        schoolName: 'Lagos International School',
        grade: '7th Grade',
        enrolledCourses: ['Mathematics', 'English', 'Science', 'Art'],
        applications: [],
        averageGrade: 92.3,
        lastActive: now.subtract(const Duration(hours: 1)),
      ),
      Child(
        id: 'child3',
        parentId: parentId ?? 'parent1',
        name: 'Zara Okafor',
        email: 'zara.okafor@email.com',
        dateOfBirth: DateTime(2006, 3, 10),
        schoolName: 'University of Ibadan',
        grade: '2nd Year',
        enrolledCourses: [
          'Organic Chemistry',
          'Biology',
          'Research Methods',
          'Laboratory Techniques'
        ],
        applications: [
          ChildApplication(
            id: 'app3',
            institutionName: 'Johns Hopkins University',
            programName: 'PhD in Biochemistry',
            status: 'accepted',
            submittedAt: now.subtract(const Duration(days: 90)),
          ),
        ],
        averageGrade: 95.7,
        lastActive: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}

/// Simplified application for child monitoring
class ChildApplication {
  final String id;
  final String institutionName;
  final String programName;
  final String status;
  final DateTime submittedAt;

  ChildApplication({
    required this.id,
    required this.institutionName,
    required this.programName,
    required this.status,
    required this.submittedAt,
  });

  factory ChildApplication.fromJson(Map<String, dynamic> json) {
    return ChildApplication(
      id: json['id'] as String,
      institutionName: json['institutionName'] as String,
      programName: json['programName'] as String,
      status: json['status'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'institutionName': institutionName,
      'programName': programName,
      'status': status,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }

  /// Single mock application for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static ChildApplication? mockApplication([int index = 0]) {
    if (!kDebugMode) {
      assert(false, 'ChildApplication.mockApplication should not be called in release mode');
      return null;
    }

    final institutions = ['University of Ghana', 'Makerere University', 'University of Cape Town', 'University of Lagos'];
    final programs = ['Bachelor of Computer Science', 'MBA - Business Administration', 'Bachelor of Medicine', 'Engineering'];
    final statuses = ['under_review', 'pending', 'accepted', 'rejected'];

    return ChildApplication(
      id: 'app${index + 1}',
      institutionName: institutions[index % institutions.length],
      programName: programs[index % programs.length],
      status: statuses[index % statuses.length],
      submittedAt: DateTime.now().subtract(Duration(days: 15 + index * 5)),
    );
  }
}

/// Course progress for child
class CourseProgress {
  final String id;
  final String courseName;
  final double completionPercentage;
  final double currentGrade;
  final int assignmentsCompleted;
  final int totalAssignments;
  final DateTime lastActivity;

  CourseProgress({
    required this.id,
    required this.courseName,
    required this.completionPercentage,
    required this.currentGrade,
    required this.assignmentsCompleted,
    required this.totalAssignments,
    required this.lastActivity,
  });

  // Alias for compatibility
  int get completedAssignments => assignmentsCompleted;

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      currentGrade: (json['currentGrade'] as num).toDouble(),
      assignmentsCompleted: json['assignmentsCompleted'] as int,
      totalAssignments: json['totalAssignments'] as int,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'completionPercentage': completionPercentage,
      'currentGrade': currentGrade,
      'assignmentsCompleted': assignmentsCompleted,
      'totalAssignments': totalAssignments,
      'lastActivity': lastActivity.toIso8601String(),
    };
  }

  /// Single mock course progress for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static CourseProgress? mockCourseProgress([int index = 0]) {
    if (!kDebugMode) {
      assert(false, 'mockCourseProgress should not be called in release mode');
      return null;
    }

    final courses = ['Mathematics', 'Physics', 'Computer Science', 'Chemistry', 'Literature'];
    final completions = [75.0, 60.0, 90.0, 55.0, 80.0];
    final grades = [88.5, 72.0, 95.0, 68.5, 85.0];

    return CourseProgress(
      id: '${index + 1}',
      courseName: courses[index % courses.length],
      completionPercentage: completions[index % completions.length],
      currentGrade: grades[index % grades.length],
      assignmentsCompleted: 15 + index,
      totalAssignments: 20,
      lastActivity: DateTime.now().subtract(Duration(days: index + 1)),
    );
  }

  /// Mock course progress - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static List<CourseProgress> mockProgress() {
    if (!kDebugMode) {
      assert(false, 'mockProgress should not be called in release mode');
      return [];
    }

    final now = DateTime.now();
    return [
      CourseProgress(
        id: '1',
        courseName: 'Mathematics',
        completionPercentage: 75.0,
        currentGrade: 88.5,
        assignmentsCompleted: 15,
        totalAssignments: 20,
        lastActivity: now.subtract(const Duration(days: 1)),
      ),
      CourseProgress(
        id: '2',
        courseName: 'Physics',
        completionPercentage: 60.0,
        currentGrade: 85.0,
        assignmentsCompleted: 12,
        totalAssignments: 20,
        lastActivity: now.subtract(const Duration(days: 3)),
      ),
      CourseProgress(
        id: '3',
        courseName: 'Computer Science',
        completionPercentage: 90.0,
        currentGrade: 92.0,
        assignmentsCompleted: 18,
        totalAssignments: 20,
        lastActivity: now.subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
