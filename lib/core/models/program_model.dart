// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/foundation.dart' show kDebugMode;

/// Program/Course offered by an institution
class Program {
  final String id;
  final String institutionId;
  final String institutionName;
  final String name;
  final String description;
  final String category;
  final String level; // certificate, diploma, undergraduate, postgraduate
  final Duration duration;
  final double fee;
  final int maxStudents;
  final int enrolledStudents;
  final List<String> requirements;
  final DateTime applicationDeadline;
  final DateTime startDate;
  final bool isActive;
  final DateTime createdAt;
  final String currency;

  Program({
    required this.id,
    required this.institutionId,
    required this.institutionName,
    required this.name,
    required this.description,
    required this.category,
    required this.level,
    required this.duration,
    required this.fee,
    required this.maxStudents,
    required this.enrolledStudents,
    required this.requirements,
    required this.applicationDeadline,
    required this.startDate,
    this.isActive = true,
    required this.createdAt,
    this.currency = 'USD',
  });

  bool get isFull => enrolledStudents >= maxStudents;
  int get availableSlots => maxStudents - enrolledStudents;
  double get fillPercentage => (enrolledStudents / maxStudents) * 100;

  // Aliases for compatibility
  int get capacity => maxStudents;
  int get enrolledCount => enrolledStudents;

  factory Program.fromJson(Map<String, dynamic> json) {
    // Handle both camelCase (frontend) and snake_case (API)
    // Helper function to safely parse int values (handles both int and String)
    int _parseInt(dynamic value, int defaultValue) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    // Helper function to safely parse double values (handles both num and String)
    double _parseDouble(dynamic value, double defaultValue) {
      if (value == null) return defaultValue;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? defaultValue;
      return defaultValue;
    }

    return Program(
      id: json['id'] as String,
      institutionId: (json['institution_id'] ?? json['institutionId']) as String,
      institutionName: (json['institution_name'] ?? json['institutionName']) as String,
      name: json['name'] as String,
      description: (json['description'] ?? '') as String,
      category: json['category'] as String,
      level: json['level'] as String,
      duration: Duration(days: _parseInt(json['duration_days'] ?? json['durationDays'], 365)),
      fee: _parseDouble(json['fee'], 0.0),
      maxStudents: _parseInt(json['max_students'] ?? json['maxStudents'], 0),
      enrolledStudents: _parseInt(json['enrolled_students'] ?? json['enrolledStudents'], 0),
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'] as List)
          : [],
      applicationDeadline: json['application_deadline'] != null || json['applicationDeadline'] != null
          ? DateTime.parse((json['application_deadline'] ?? json['applicationDeadline']) as String)
          : DateTime.now().add(const Duration(days: 30)),
      startDate: json['start_date'] != null || json['startDate'] != null
          ? DateTime.parse((json['start_date'] ?? json['startDate']) as String)
          : DateTime.now().add(const Duration(days: 60)),
      isActive: (json['is_active'] ?? json['isActive'] ?? true) as bool,
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.parse((json['created_at'] ?? json['createdAt']) as String)
          : DateTime.now(),
      currency: (json['currency'] ?? 'USD') as String,
    );
  }

  Map<String, dynamic> toJson() {
    // Use snake_case for API compatibility
    return {
      'id': id,
      'institution_id': institutionId,
      'institution_name': institutionName,
      'name': name,
      'description': description,
      'category': category,
      'level': level,
      'duration_days': duration.inDays,
      'fee': fee,
      'max_students': maxStudents,
      'enrolled_students': enrolledStudents,
      'requirements': requirements,
      'application_deadline': applicationDeadline.toIso8601String(),
      'start_date': startDate.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'currency': currency,
    };
  }

  /// Single mock program for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static Program? mockProgram([int index = 0]) {
    if (!kDebugMode) {
      assert(false, 'mockProgram should not be called in release mode');
      return null;
    }

    final now = DateTime.now();
    final names = ['Bachelor of Computer Science', 'MBA - Business Administration', 'Certificate in Digital Marketing', 'Diploma in Nursing'];
    final categories = ['Technology', 'Business', 'Business', 'Health Sciences'];
    final levels = ['undergraduate', 'postgraduate', 'certificate', 'diploma'];
    final fees = [5000.0, 12000.0, 800.0, 4500.0];

    return Program(
      id: 'prog${index + 1}',
      institutionId: 'inst1',
      institutionName: 'University of Ghana',
      name: names[index % names.length],
      description: 'Comprehensive program covering essential topics and modern practices.',
      category: categories[index % categories.length],
      level: levels[index % levels.length],
      duration: Duration(days: 365 * (2 + (index % 3))), // 2-4 years
      fee: fees[index % fees.length],
      maxStudents: 50 + (index % 5) * 10,
      enrolledStudents: 40 + (index % 4) * 5,
      requirements: [
        'High School Diploma',
        'Minimum GPA of 3.0',
        'English Proficiency',
      ],
      applicationDeadline: now.add(Duration(days: 30 + (index * 10))),
      startDate: now.add(Duration(days: 60 + (index * 15))),
      createdAt: now.subtract(Duration(days: 180 + (index * 20))),
      currency: 'USD',
    );
  }

  /// Mock programs for development - DEBUG ONLY
  /// This method is only available in debug mode to prevent mock data in production
  static List<Program> mockPrograms({String? institutionId}) {
    if (!kDebugMode) {
      assert(false, 'mockPrograms should not be called in release mode');
      return [];
    }

    final now = DateTime.now();
    return [
      Program(
        id: 'prog1',
        institutionId: institutionId ?? 'inst1',
        institutionName: 'University of Ghana',
        name: 'Bachelor of Computer Science',
        description: 'Comprehensive computer science program covering software engineering, algorithms, and modern technologies.',
        category: 'Technology',
        level: 'undergraduate',
        duration: const Duration(days: 1460), // 4 years
        fee: 5000,
        maxStudents: 100,
        enrolledStudents: 75,
        requirements: [
          'High School Diploma with Mathematics',
          'Minimum GPA of 3.0',
          'English Proficiency',
        ],
        applicationDeadline: now.add(const Duration(days: 45)),
        startDate: now.add(const Duration(days: 90)),
        createdAt: now.subtract(const Duration(days: 180)),
      ),
      Program(
        id: 'prog2',
        institutionId: institutionId ?? 'inst1',
        institutionName: 'University of Ghana',
        name: 'MBA - Business Administration',
        description: 'Master\'s program focused on leadership, strategy, and business management.',
        category: 'Business',
        level: 'postgraduate',
        duration: const Duration(days: 730), // 2 years
        fee: 12000,
        maxStudents: 50,
        enrolledStudents: 48,
        requirements: [
          'Bachelor\'s degree in any field',
          'Minimum 2 years work experience',
          'GMAT score of 550+',
        ],
        applicationDeadline: now.add(const Duration(days: 30)),
        startDate: now.add(const Duration(days: 60)),
        createdAt: now.subtract(const Duration(days: 120)),
      ),
      Program(
        id: 'prog3',
        institutionId: institutionId ?? 'inst1',
        institutionName: 'University of Ghana',
        name: 'Certificate in Digital Marketing',
        description: 'Short-term certification program covering social media, SEO, and digital advertising.',
        category: 'Business',
        level: 'certificate',
        duration: const Duration(days: 90), // 3 months
        fee: 800,
        maxStudents: 150,
        enrolledStudents: 120,
        requirements: [
          'Basic computer skills',
          'Interest in marketing',
        ],
        applicationDeadline: now.add(const Duration(days: 15)),
        startDate: now.add(const Duration(days: 30)),
        createdAt: now.subtract(const Duration(days: 60)),
      ),
      Program(
        id: 'prog4',
        institutionId: institutionId ?? 'inst1',
        institutionName: 'University of Ghana',
        name: 'Diploma in Nursing',
        description: 'Professional nursing program with clinical practice and theory.',
        category: 'Health Sciences',
        level: 'diploma',
        duration: const Duration(days: 730), // 2 years
        fee: 4500,
        maxStudents: 60,
        enrolledStudents: 60,
        requirements: [
          'High School Diploma with Biology and Chemistry',
          'Minimum GPA of 3.2',
          'Medical fitness certificate',
        ],
        applicationDeadline: now.add(const Duration(days: 20)),
        startDate: now.add(const Duration(days: 75)),
        isActive: false, // Full - not accepting applications
        createdAt: now.subtract(const Duration(days: 200)),
      ),
    ];
  }
}
