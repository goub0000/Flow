import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/applicant_model.dart';
import '../services/applications_api_service.dart';
import '../services/realtime_service.dart';
import '../../authentication/providers/auth_provider.dart';

/// Provider for Applications API Service
final applicationsApiServiceProvider = Provider.autoDispose<ApplicationsApiService>((ref) {
  // Get access token from auth provider
  final authState = ref.watch(authProvider);
  print('[ApplicationsApiService] Creating service with token: ${authState.accessToken?.substring(0, 20)}...');
  print('[ApplicationsApiService] Auth state: isAuthenticated=${authState.isAuthenticated}, user=${authState.user?.email}');
  return ApplicationsApiService(accessToken: authState.accessToken);
});

/// Provider for Realtime Service
final institutionRealtimeServiceProvider = Provider.autoDispose<InstitutionRealtimeService>((ref) {
  final service = InstitutionRealtimeService();

  // Clean up when provider is disposed
  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

/// State class for managing institution applicants
class InstitutionApplicantsState {
  final List<Applicant> applicants;
  final bool isLoading;
  final String? error;

  const InstitutionApplicantsState({
    this.applicants = const [],
    this.isLoading = false,
    this.error,
  });

  InstitutionApplicantsState copyWith({
    List<Applicant>? applicants,
    bool? isLoading,
    String? error,
  }) {
    return InstitutionApplicantsState(
      applicants: applicants ?? this.applicants,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing institution applicants
class InstitutionApplicantsNotifier extends StateNotifier<InstitutionApplicantsState> {
  final ApplicationsApiService _apiService;
  final InstitutionRealtimeService _realtimeService;
  final String? _institutionId;
  StreamSubscription<ApplicationUpdate>? _realtimeSubscription;

  InstitutionApplicantsNotifier(
    this._apiService,
    this._realtimeService,
    this._institutionId,
  ) : super(const InstitutionApplicantsState()) {
    _initialize();
  }

  void _initialize() {
    fetchApplicants();
    _setupRealtimeSubscription();
  }

  /// Setup real-time subscription for application updates
  void _setupRealtimeSubscription() {
    if (_institutionId == null) return;

    // Subscribe to real-time updates
    _realtimeService.subscribeToApplications(_institutionId);

    // Listen for updates - simplified version without enum
    _realtimeSubscription = _realtimeService.applicationUpdates.listen((update) {
      print('[InstitutionApplicants] Received real-time update: ${update.eventType} for ${update.applicationId}');
      // Real-time updates are disabled in the stub implementation
    });
  }

  /// Fetch all applicants for the institution
  Future<void> fetchApplicants({String? status, String? programId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('[InstitutionApplicants] Fetching applicants...');
      print('[InstitutionApplicants] InstitutionId: $_institutionId, Status: $status, ProgramId: $programId');

      // TODO: Replace with actual institution ID from user profile
      const institutionId = '123';  // Hardcoded for testing

      final result = await _apiService.getInstitutionApplications(
        status: status,
        programId: programId,
      );

      if (result != null) {
        state = state.copyWith(
          applicants: result,
          isLoading: false,
        );
        print('[InstitutionApplicants] Successfully fetched ${result.length} applicants');
      } else {
        state = state.copyWith(
          applicants: [],
          isLoading: false,
        );
        print('[InstitutionApplicants] No applicants found');
      }
    } catch (e, stackTrace) {
      print('[InstitutionApplicants] Error fetching applicants: $e');
      print('[InstitutionApplicants] Stack trace: $stackTrace');
      state = state.copyWith(
        error: 'Failed to load applicants: $e',
        isLoading: false,
      );
    }
  }

  /// Update an applicant's status
  Future<void> updateApplicantStatus(String applicantId, String newStatus) async {
    try {
      await _apiService.updateApplicationStatus(
        applicantId,
        newStatus,
      );

      // Update local state
      final updatedApplicants = state.applicants.map((a) {
        if (a.id == applicantId) {
          return a.copyWith(status: newStatus);
        }
        return a;
      }).toList();

      state = state.copyWith(applicants: updatedApplicants);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update status: $e');
    }
  }

  /// Filter applicants by status
  void filterByStatus(String? status) {
    fetchApplicants(status: status);
  }

  /// Filter applicants by program
  void filterByProgram(String? programId) {
    fetchApplicants(programId: programId);
  }

  /// Search applicants by name or email
  List<Applicant> searchApplicants(String query) {
    if (query.isEmpty) return state.applicants;

    final lowercaseQuery = query.toLowerCase();
    return state.applicants.where((applicant) {
      return applicant.studentName.toLowerCase().contains(lowercaseQuery) ||
          applicant.studentEmail.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Sort applicants by date
  void sortByDate({bool ascending = false}) {
    final sorted = [...state.applicants];
    sorted.sort((a, b) {
      final comparison = a.submittedAt.compareTo(b.submittedAt);
      return ascending ? comparison : -comparison;
    });
    state = state.copyWith(applicants: sorted);
  }

  /// Sort applicants by name
  void sortByName({bool ascending = true}) {
    final sorted = [...state.applicants];
    sorted.sort((a, b) {
      final comparison = a.studentName.compareTo(b.studentName);
      return ascending ? comparison : -comparison;
    });
    state = state.copyWith(applicants: sorted);
  }

  /// Get applicant by ID
  Applicant? getApplicantById(String applicantId) {
    try {
      return state.applicants.firstWhere((a) => a.id == applicantId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _realtimeSubscription?.cancel();
    _realtimeService.unsubscribeFromApplications();
    super.dispose();
  }
}

/// Provider for institution applicants
final institutionApplicantsProvider = StateNotifierProvider.autoDispose<
    InstitutionApplicantsNotifier, InstitutionApplicantsState>((ref) {
  final apiService = ref.watch(applicationsApiServiceProvider);
  final realtimeService = ref.watch(institutionRealtimeServiceProvider);

  // TODO: Get institution ID from user profile
  const institutionId = '123';  // Hardcoded for testing

  return InstitutionApplicantsNotifier(
    apiService,
    realtimeService,
    institutionId,
  );
});

/// Provider for filtered applicants
final filteredApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final state = ref.watch(institutionApplicantsProvider);
  return state.applicants;
});

/// Provider for applicant statistics
final applicantStatisticsProvider = Provider.autoDispose<Map<String, int>>((ref) {
  final applicants = ref.watch(filteredApplicantsProvider);

  return {
    'total': applicants.length,
    'pending': applicants.where((a) => a.status == 'pending').length,
    'reviewing': applicants.where((a) => a.status == 'reviewing').length,
    'accepted': applicants.where((a) => a.status == 'accepted').length,
    'rejected': applicants.where((a) => a.status == 'rejected').length,
    'waitlisted': applicants.where((a) => a.status == 'waitlisted').length,
  };
});

// Additional providers for different states
final institutionApplicantsListProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final state = ref.watch(institutionApplicantsProvider);
  return state.applicants;
});

final institutionApplicantsLoadingProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(institutionApplicantsProvider);
  return state.isLoading;
});

final institutionApplicantsErrorProvider = Provider.autoDispose<String?>((ref) {
  final state = ref.watch(institutionApplicantsProvider);
  return state.error;
});

final pendingApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'pending').toList();
});

final underReviewApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'reviewing' || a.status == 'under_review').toList();
});

final acceptedApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'accepted').toList();
});

final rejectedApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'rejected').toList();
});

final recentApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  final sorted = [...applicants];
  sorted.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  return sorted.take(10).toList();
});

final institutionApplicantStatisticsProvider = Provider.autoDispose<Map<String, dynamic>>((ref) {
  final applicants = ref.watch(institutionApplicantsListProvider);
  return {
    'total': applicants.length,
    'pending': applicants.where((a) => a.status == 'pending').length,
    'reviewing': applicants.where((a) => a.status == 'reviewing' || a.status == 'under_review').length,
    'accepted': applicants.where((a) => a.status == 'accepted').length,
    'rejected': applicants.where((a) => a.status == 'rejected').length,
    'waitlisted': applicants.where((a) => a.status == 'waitlisted').length,
  };
});
