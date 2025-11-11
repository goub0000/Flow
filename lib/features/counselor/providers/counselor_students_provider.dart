import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/counseling_models.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

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
  final ApiClient _apiClient;

  CounselorStudentsNotifier(this._apiClient) : super(const CounselorStudentsState()) {
    fetchStudents();
  }

  /// Fetch all assigned students from backend API
  /// Note: Backend may return students through sessions or separate endpoint
  Future<void> fetchStudents() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Try to fetch student records from counseling API
      // Backend might need to implement: GET /api/v1/counseling/students
      final response = await _apiClient.get(
        '${ApiConfig.counseling}/students',
        fromJson: (data) {
          if (data is List) {
            return data.map((studentJson) => StudentRecord.fromJson(studentJson)).toList();
          }
          return <StudentRecord>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          students: response.data!,
          isLoading: false,
        );
      } else {
        // If endpoint doesn't exist yet, return empty list instead of mock data
        state = state.copyWith(
          students: [],
          isLoading: false,
          error: response.message ?? 'Student records endpoint not yet implemented in backend',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch students: ${e.toString()}',
        isLoading: false,
        students: [], // Return empty instead of mock
      );
    }
  }

  /// Add a new student record via backend API
  Future<bool> addStudent(String studentId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.counseling}/students',
        data: {
          'student_id': studentId,
        },
        fromJson: (data) => StudentRecord.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedStudents = [...state.students, response.data!];
        state = state.copyWith(students: updatedStudents);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to add student',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add student: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update student record via backend API
  Future<bool> updateStudentRecord(String studentId, {
    String? notes,
    Map<String, dynamic>? additionalInfo,
  }) async {
    try {
      final response = await _apiClient.put(
        '${ApiConfig.counseling}/students/$studentId',
        data: {
          if (notes != null) 'notes': notes,
          if (additionalInfo != null) 'additional_info': additionalInfo,
        },
        fromJson: (data) => StudentRecord.fromJson(data),
      );

      if (response.success && response.data != null) {
        final updatedStudents = state.students.map((s) {
          return s.id == studentId ? response.data! : s;
        }).toList();
        state = state.copyWith(students: updatedStudents);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to update student',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update student: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add notes to student via backend API
  Future<bool> addNotes(String studentId, String notes) async {
    try {
      return await updateStudentRecord(studentId, notes: notes);
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
  final apiClient = ref.watch(apiClientProvider);
  return CounselorStudentsNotifier(apiClient);
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
