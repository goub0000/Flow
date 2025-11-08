import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/counseling_models.dart';

/// State class for managing counselor's students
class CounselorStudentsState {
  final List<StudentRecord> students;
  final bool isLoading;
  final String? error;

  const CounselorStudentsState({
    this.students = const [],
    this.isLoading = false,
    this.error,
  });

  CounselorStudentsState copyWith({
    List<StudentRecord>? students,
    bool? isLoading,
    String? error,
  }) {
    return CounselorStudentsState(
      students: students ?? this.students,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing counselor's students
class CounselorStudentsNotifier extends StateNotifier<CounselorStudentsState> {
  CounselorStudentsNotifier() : super(const CounselorStudentsState()) {
    fetchStudents();
  }

  /// Fetch all assigned students
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<void> fetchStudents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance
      //   .collection('student_records')
      //   .where('counselorId', isEqualTo: currentCounselorId)
      //   .get()

      await Future.delayed(const Duration(seconds: 1));

      // Mock data for development
      final mockStudents = List<StudentRecord>.generate(
        12,
        (index) => StudentRecord.mockStudentRecord(index),
      );

      state = state.copyWith(
        students: mockStudents,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch students: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Add a new student
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addStudent(StudentRecord student) async {
    try {
      // TODO: Replace with actual Firebase write

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedStudents = [...state.students, student];
      state = state.copyWith(students: updatedStudents);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add student: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update student record
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> updateStudent(StudentRecord student) async {
    try {
      // TODO: Replace with actual Firebase update

      await Future.delayed(const Duration(milliseconds: 500));

      final updatedStudents = state.students.map((s) {
        return s.id == student.id ? student : s;
      }).toList();

      state = state.copyWith(students: updatedStudents);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update student: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add notes to student
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> addNotes(String studentId, String notes) async {
    try {
      // TODO: Update notes in Firebase

      await Future.delayed(const Duration(milliseconds: 300));

      final updatedStudents = state.students.map((s) {
        if (s.id == studentId) {
          return StudentRecord(
            id: s.id,
            name: s.name,
            email: s.email,
            photoUrl: s.photoUrl,
            grade: s.grade,
            gpa: s.gpa,
            schoolName: s.schoolName,
            interests: s.interests,
            strengths: s.strengths,
            challenges: s.challenges,
            goals: s.goals,
            totalSessions: s.totalSessions,
            upcomingSessions: s.upcomingSessions,
            lastSessionDate: s.lastSessionDate,
            status: s.status,
          );
        }
        return s;
      }).toList();

      state = state.copyWith(students: updatedStudents);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add notes: ${e.toString()}',
      );
      return false;
    }
  }

  /// Search students by name or email
  List<StudentRecord> searchStudents(String query) {
    if (query.isEmpty) return state.students;

    final lowerQuery = query.toLowerCase();
    return state.students.where((student) {
      return student.name.toLowerCase().contains(lowerQuery) ||
          student.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter students by grade
  List<StudentRecord> filterByGrade(String grade) {
    if (grade == 'All') return state.students;

    return state.students.where((student) => student.grade == grade).toList();
  }

  /// Get student by ID
  StudentRecord? getStudentById(String id) {
    try {
      return state.students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get students with upcoming sessions
  List<StudentRecord> getStudentsWithUpcomingSessions() {
    return state.students.where((s) => s.upcomingSessions > 0).toList();
  }

  /// Get students needing attention (no recent session > 30 days)
  List<StudentRecord> getStudentsNeedingAttention() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return state.students.where((s) {
      return s.lastSessionDate == null || s.lastSessionDate!.isBefore(thirtyDaysAgo);
    }).toList();
  }

  /// Get student statistics
  Map<String, dynamic> getStudentStatistics() {
    final totalStudents = state.students.length;
    final studentsWithUpcomingSessions = getStudentsWithUpcomingSessions().length;
    final studentsNeedingAttention = getStudentsNeedingAttention().length;

    // Calculate average GPA
    double totalGpa = 0;
    for (final student in state.students) {
      totalGpa += student.gpa;
    }
    final averageGpa = totalStudents > 0 ? totalGpa / totalStudents : 0.0;

    // Count total sessions
    int totalSessions = 0;
    for (final student in state.students) {
      totalSessions += student.totalSessions;
    }

    return {
      'totalStudents': totalStudents,
      'averageGpa': averageGpa.toStringAsFixed(2),
      'totalSessions': totalSessions,
      'upcomingSessions': state.students.fold<int>(0, (sum, s) => sum + s.upcomingSessions),
      'studentsWithUpcomingSessions': studentsWithUpcomingSessions,
      'studentsNeedingAttention': studentsNeedingAttention,
    };
  }
}

/// Provider for counselor students state
final counselorStudentsProvider = StateNotifierProvider<CounselorStudentsNotifier, CounselorStudentsState>((ref) {
  return CounselorStudentsNotifier();
});

/// Provider for students list
final counselorStudentsListProvider = Provider<List<StudentRecord>>((ref) {
  final studentsState = ref.watch(counselorStudentsProvider);
  return studentsState.students;
});

/// Provider for checking if students are loading
final counselorStudentsLoadingProvider = Provider<bool>((ref) {
  final studentsState = ref.watch(counselorStudentsProvider);
  return studentsState.isLoading;
});

/// Provider for students error
final counselorStudentsErrorProvider = Provider<String?>((ref) {
  final studentsState = ref.watch(counselorStudentsProvider);
  return studentsState.error;
});

/// Provider for student statistics
final counselorStudentStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(counselorStudentsProvider.notifier);
  return notifier.getStudentStatistics();
});

/// Provider for students with upcoming sessions
final studentsWithUpcomingSessionsProvider = Provider<List<StudentRecord>>((ref) {
  final notifier = ref.watch(counselorStudentsProvider.notifier);
  return notifier.getStudentsWithUpcomingSessions();
});

/// Provider for students needing attention
final studentsNeedingAttentionProvider = Provider<List<StudentRecord>>((ref) {
  final notifier = ref.watch(counselorStudentsProvider.notifier);
  return notifier.getStudentsNeedingAttention();
});
