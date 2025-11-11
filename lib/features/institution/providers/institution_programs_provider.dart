import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/program_model.dart';
import '../services/programs_api_service.dart';
import '../../authentication/providers/auth_provider.dart';

const _uuid = Uuid();

// Provider for Programs API Service
final programsApiServiceProvider = Provider.autoDispose<ProgramsApiService>((ref) {
  // Get access token from auth provider
  final authState = ref.watch(authProvider);
  return ProgramsApiService(accessToken: authState.accessToken);
});

/// State class for managing institution programs
class InstitutionProgramsState {
  final List<Program> programs;
  final bool isLoading;
  final String? error;

  const InstitutionProgramsState({
    this.programs = const [],
    this.isLoading = false,
    this.error,
  });

  InstitutionProgramsState copyWith({
    List<Program>? programs,
    bool? isLoading,
    String? error,
  }) {
    return InstitutionProgramsState(
      programs: programs ?? this.programs,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing institution programs
class InstitutionProgramsNotifier extends StateNotifier<InstitutionProgramsState> {
  final ProgramsApiService _apiService;
  final String? _institutionId;

  InstitutionProgramsNotifier(this._apiService, {String? institutionId})
      : _institutionId = institutionId,
        super(const InstitutionProgramsState()) {
    fetchPrograms();
  }

  /// Fetch all programs for the institution
  Future<void> fetchPrograms() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final programs = await _apiService.getPrograms(
        institutionId: _institutionId,
        // Can add more filters as needed
      );

      state = state.copyWith(
        programs: programs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch programs: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Create a new program
  Future<bool> createProgram(Program program) async {
    try {
      final createdProgram = await _apiService.createProgram(program);

      // Add to local state
      final updatedPrograms = [...state.programs, createdProgram];
      state = state.copyWith(programs: updatedPrograms);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to create program: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update an existing program
  Future<bool> updateProgram(Program program) async {
    try {
      final updatedProgram = await _apiService.updateProgram(program);

      // Update in local state
      final updatedPrograms = state.programs.map((p) {
        return p.id == program.id ? updatedProgram : p;
      }).toList();

      state = state.copyWith(programs: updatedPrograms);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update program: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete a program
  Future<bool> deleteProgram(String programId) async {
    try {
      await _apiService.deleteProgram(programId);

      // Remove from local state
      final updatedPrograms = state.programs.where((p) => p.id != programId).toList();
      state = state.copyWith(programs: updatedPrograms);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to delete program: ${e.toString()}',
      );
      return false;
    }
  }

  /// Toggle program active status
  Future<void> toggleProgramStatus(String programId) async {
    try {
      final updatedProgram = await _apiService.toggleProgramStatus(programId);

      // Update in local state
      final updatedPrograms = state.programs.map((p) {
        return p.id == programId ? updatedProgram : p;
      }).toList();

      state = state.copyWith(programs: updatedPrograms);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to toggle program status: ${e.toString()}',
      );
    }
  }

  /// Search programs by name
  List<Program> searchPrograms(String query) {
    if (query.isEmpty) return state.programs;

    final lowerQuery = query.toLowerCase();
    return state.programs.where((program) {
      return program.name.toLowerCase().contains(lowerQuery) ||
          program.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter programs by category
  List<Program> filterByCategory(String category) {
    if (category == 'All') return state.programs;

    return state.programs.where((program) {
      return program.category == category;
    }).toList();
  }

  /// Get program by ID
  Program? getProgramById(String id) {
    try {
      return state.programs.firstWhere((program) => program.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get program statistics
  Map<String, dynamic> getProgramStatistics() {
    final totalPrograms = state.programs.length;
    final activePrograms = state.programs.where((p) => p.isActive).length;
    final totalCapacity = state.programs.fold<int>(0, (sum, p) => sum + p.capacity);
    final totalEnrolled = state.programs.fold<int>(0, (sum, p) => sum + p.enrolledCount);

    return {
      'totalPrograms': totalPrograms,
      'activePrograms': activePrograms,
      'inactivePrograms': totalPrograms - activePrograms,
      'totalCapacity': totalCapacity,
      'totalEnrolled': totalEnrolled,
      'availableSpots': totalCapacity - totalEnrolled,
      'occupancyRate': totalCapacity > 0 ? (totalEnrolled / totalCapacity * 100).toStringAsFixed(1) : '0',
    };
  }
}

/// Provider for institution programs state
final institutionProgramsProvider = StateNotifierProvider.autoDispose<InstitutionProgramsNotifier, InstitutionProgramsState>((ref) {
  final apiService = ref.watch(programsApiServiceProvider);
  // TODO: Get actual institution ID from auth/context
  return InstitutionProgramsNotifier(apiService);
});

/// Provider for programs list
final institutionProgramsListProvider = Provider.autoDispose<List<Program>>((ref) {
  final programsState = ref.watch(institutionProgramsProvider);
  return programsState.programs;
});

/// Provider for checking if programs are loading
final institutionProgramsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final programsState = ref.watch(institutionProgramsProvider);
  return programsState.isLoading;
});

/// Provider for programs error
final institutionProgramsErrorProvider = Provider.autoDispose<String?>((ref) {
  final programsState = ref.watch(institutionProgramsProvider);
  return programsState.error;
});

/// Provider for active programs only
final activeInstitutionProgramsProvider = Provider.autoDispose<List<Program>>((ref) {
  final programsState = ref.watch(institutionProgramsProvider);
  return programsState.programs.where((p) => p.isActive).toList();
});

/// Provider for program statistics
final institutionProgramStatisticsProvider = Provider.autoDispose<Map<String, dynamic>>((ref) {
  final notifier = ref.watch(institutionProgramsProvider.notifier);
  return notifier.getProgramStatistics();
});
