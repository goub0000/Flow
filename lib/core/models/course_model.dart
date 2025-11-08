/// Course model
class Course {
  final String id;
  final String title;
  final String description;
  final String institutionId;
  final String institutionName;
  final String? imageUrl;
  final String level; // undergraduate, postgraduate, certificate
  final String category;
  final int duration; // in months
  final double? fee;
  final String currency;
  final List<String> prerequisites;
  final DateTime startDate;
  final DateTime? endDate;
  final int enrolledStudents;
  final int maxStudents;
  final bool isActive;
  final bool isOnline;
  final double rating;
  final DateTime createdAt;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.institutionId,
    required this.institutionName,
    this.imageUrl,
    required this.level,
    required this.category,
    required this.duration,
    this.fee,
    this.currency = 'USD',
    this.prerequisites = const [],
    required this.startDate,
    this.endDate,
    this.enrolledStudents = 0,
    this.maxStudents = 100,
    this.isActive = true,
    this.isOnline = false,
    this.rating = 0.0,
    required this.createdAt,
  });

  bool get isFull => enrolledStudents >= maxStudents;
  bool get hasAvailableSlots => !isFull;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      institutionId: json['institutionId'] as String,
      institutionName: json['institutionName'] as String,
      imageUrl: json['imageUrl'] as String?,
      level: json['level'] as String,
      category: json['category'] as String,
      duration: json['duration'] as int,
      fee: json['fee'] as double?,
      currency: json['currency'] as String? ?? 'USD',
      prerequisites: (json['prerequisites'] as List?)?.cast<String>() ?? [],
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      enrolledStudents: json['enrolledStudents'] as int? ?? 0,
      maxStudents: json['maxStudents'] as int? ?? 100,
      isActive: json['isActive'] as bool? ?? true,
      isOnline: json['isOnline'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'institutionId': institutionId,
      'institutionName': institutionName,
      'imageUrl': imageUrl,
      'level': level,
      'category': category,
      'duration': duration,
      'fee': fee,
      'currency': currency,
      'prerequisites': prerequisites,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'enrolledStudents': enrolledStudents,
      'maxStudents': maxStudents,
      'isActive': isActive,
      'isOnline': isOnline,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// Enrollment model
class Enrollment {
  final String id;
  final String studentId;
  final String courseId;
  final Course? course;
  final DateTime enrolledAt;
  final String status; // active, completed, dropped
  final double progress; // 0-100
  final double? grade;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.course,
    required this.enrolledAt,
    this.status = 'active',
    this.progress = 0,
    this.grade,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      course:
          json['course'] != null ? Course.fromJson(json['course']) : null,
      enrolledAt: DateTime.parse(json['enrolledAt'] as String),
      status: json['status'] as String? ?? 'active',
      progress: (json['progress'] as num?)?.toDouble() ?? 0,
      grade: (json['grade'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'course': course?.toJson(),
      'enrolledAt': enrolledAt.toIso8601String(),
      'status': status,
      'progress': progress,
      'grade': grade,
    };
  }
}
