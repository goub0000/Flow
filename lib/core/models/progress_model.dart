class CourseProgress {
  final String courseId;
  final String courseName;
  final double completionPercentage;
  final double currentGrade;
  final int assignmentsCompleted;
  final int totalAssignments;
  final int quizzesCompleted;
  final int totalQuizzes;
  final Duration timeSpent;
  final DateTime lastAccessed;
  final List<ModuleProgress> modules;
  final List<AssignmentGrade> grades;

  CourseProgress({
    required this.courseId,
    required this.courseName,
    required this.completionPercentage,
    required this.currentGrade,
    required this.assignmentsCompleted,
    required this.totalAssignments,
    required this.quizzesCompleted,
    required this.totalQuizzes,
    required this.timeSpent,
    required this.lastAccessed,
    required this.modules,
    required this.grades,
  });

  String get formattedTimeSpent {
    final hours = timeSpent.inHours;
    final minutes = timeSpent.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get gradeStatus {
    if (currentGrade >= 90) return 'Excellent';
    if (currentGrade >= 80) return 'Very Good';
    if (currentGrade >= 70) return 'Good';
    if (currentGrade >= 60) return 'Fair';
    return 'Needs Improvement';
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'completionPercentage': completionPercentage,
      'currentGrade': currentGrade,
      'assignmentsCompleted': assignmentsCompleted,
      'totalAssignments': totalAssignments,
      'quizzesCompleted': quizzesCompleted,
      'totalQuizzes': totalQuizzes,
      'timeSpent': timeSpent.inMinutes,
      'lastAccessed': lastAccessed.toIso8601String(),
      'modules': modules.map((m) => m.toJson()).toList(),
      'grades': grades.map((g) => g.toJson()).toList(),
    };
  }

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['courseId'] as String,
      courseName: json['courseName'] as String,
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      currentGrade: (json['currentGrade'] as num).toDouble(),
      assignmentsCompleted: json['assignmentsCompleted'] as int,
      totalAssignments: json['totalAssignments'] as int,
      quizzesCompleted: json['quizzesCompleted'] as int,
      totalQuizzes: json['totalQuizzes'] as int,
      timeSpent: Duration(minutes: json['timeSpent'] as int),
      lastAccessed: DateTime.parse(json['lastAccessed'] as String),
      modules: (json['modules'] as List)
          .map((m) => ModuleProgress.fromJson(m))
          .toList(),
      grades: (json['grades'] as List)
          .map((g) => AssignmentGrade.fromJson(g))
          .toList(),
    );
  }
}

class ModuleProgress {
  final String id;
  final String name;
  final int lessonNumber;
  final bool isCompleted;
  final DateTime? completedAt;

  ModuleProgress({
    required this.id,
    required this.name,
    required this.lessonNumber,
    required this.isCompleted,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lessonNumber': lessonNumber,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory ModuleProgress.fromJson(Map<String, dynamic> json) {
    return ModuleProgress(
      id: json['id'] as String,
      name: json['name'] as String,
      lessonNumber: json['lessonNumber'] as int,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}

class AssignmentGrade {
  final String id;
  final String name;
  final double grade;
  final double maxGrade;
  final DateTime submittedAt;
  final String? feedback;

  AssignmentGrade({
    required this.id,
    required this.name,
    required this.grade,
    required this.maxGrade,
    required this.submittedAt,
    this.feedback,
  });

  double get percentage => (grade / maxGrade) * 100;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'grade': grade,
      'maxGrade': maxGrade,
      'submittedAt': submittedAt.toIso8601String(),
      'feedback': feedback,
    };
  }

  factory AssignmentGrade.fromJson(Map<String, dynamic> json) {
    return AssignmentGrade(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: (json['grade'] as num).toDouble(),
      maxGrade: (json['maxGrade'] as num).toDouble(),
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      feedback: json['feedback'] as String?,
    );
  }
}

class OverallProgress {
  final double averageGrade;
  final double overallCompletion;
  final int totalCoursesEnrolled;
  final int coursesCompleted;
  final int totalAssignmentsSubmitted;
  final Duration totalTimeSpent;
  final List<MonthlyProgress> monthlyProgress;

  OverallProgress({
    required this.averageGrade,
    required this.overallCompletion,
    required this.totalCoursesEnrolled,
    required this.coursesCompleted,
    required this.totalAssignmentsSubmitted,
    required this.totalTimeSpent,
    required this.monthlyProgress,
  });

}

class MonthlyProgress {
  final String month; // e.g., "Jan", "Feb"
  final double averageGrade;
  final int assignmentsCompleted;
  final Duration timeSpent;

  MonthlyProgress({
    required this.month,
    required this.averageGrade,
    required this.assignmentsCompleted,
    required this.timeSpent,
  });
}
