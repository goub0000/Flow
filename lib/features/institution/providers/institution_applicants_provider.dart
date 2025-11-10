import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/applicant_model.dart';
import '../services/applications_api_service.dart';
import '../../authentication/providers/auth_provider.dart';

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

  InstitutionApplicantsNotifier({String? accessToken})
      : _apiService = ApplicationsApiService(accessToken: accessToken),
        super(const InstitutionApplicantsState()) {
    fetchApplicants();
  }

  /// Fetch all applicants for the institution
  Future<void> fetchApplicants({String? status, String? programId}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final applicants = await _apiService.getInstitutionApplications(
        status: status,
        programId: programId,
        pageSize: 100,
      );

      state = state.copyWith(
        applicants: applicants,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch applicants: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Update applicant status
  Future<bool> updateApplicantStatus(String applicantId, String newStatus, {String? reviewerNotes}) async {
    try {
      final updatedApplicant = await _apiService.updateApplicationStatus(
        applicantId,
        newStatus,
        reviewerNotes: reviewerNotes,
      );

      // Update in local state
      final updatedApplicants = state.applicants.map((a) {
        if (a.id == applicantId) {
          return updatedApplicant;
        }
        return a;
      }).toList();

      state = state.copyWith(applicants: updatedApplicants);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update applicant status: ${e.toString()}',
      );
      return false;
    }
  }

  /// Add review notes to applicant
  Future<bool> addReviewNotes(String applicantId, String notes, String reviewerName) async {
    try {
      // Update status to under_review with notes
      final updatedApplicant = await _apiService.updateApplicationStatus(
        applicantId,
        'under_review',
        reviewerNotes: notes,
      );

      final updatedApplicants = state.applicants.map((a) {
        if (a.id == applicantId) {
          return updatedApplicant;
        }
        return a;
      }).toList();

      state = state.copyWith(applicants: updatedApplicants);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add review notes: ${e.toString()}',
      );
      return false;
    }
  }

  /// Verify a document
  Future<void> verifyDocument(String applicantId, String documentId) async {
    try {
      // TODO: Implement document verification endpoint in backend
      // For now, just fetch the latest application data
      final application = await _apiService.getApplication(applicantId);

      final updatedApplicants = state.applicants.map((a) {
        if (a.id == applicantId) {
          return application;
        }
        return a;
      }).toList();

      state = state.copyWith(applicants: updatedApplicants);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to verify document: ${e.toString()}',
      );
    }
  }

  /// Search applicants by name or email
  List<Applicant> searchApplicants(String query) {
    if (query.isEmpty) return state.applicants;

    final lowerQuery = query.toLowerCase();
    return state.applicants.where((applicant) {
      return applicant.studentName.toLowerCase().contains(lowerQuery) ||
          applicant.studentEmail.toLowerCase().contains(lowerQuery) ||
          applicant.programName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Filter applicants by status
  List<Applicant> filterByStatus(String status) {
    if (status == 'all') return state.applicants;

    return state.applicants.where((applicant) {
      return applicant.status == status;
    }).toList();
  }

  /// Filter applicants by program
  List<Applicant> filterByProgram(String programId) {
    if (programId.isEmpty) return state.applicants;

    return state.applicants.where((applicant) {
      return applicant.programId == programId;
    }).toList();
  }

  /// Get applicant by ID
  Applicant? getApplicantById(String id) {
    try {
      return state.applicants.firstWhere((applicant) => applicant.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get applicant statistics
  Map<String, int> getApplicantStatistics() {
    return {
      'total': state.applicants.length,
      'pending': state.applicants.where((a) => a.status == 'pending').length,
      'underReview': state.applicants.where((a) => a.status == 'under_review').length,
      'accepted': state.applicants.where((a) => a.status == 'accepted').length,
      'rejected': state.applicants.where((a) => a.status == 'rejected').length,
      'withdrawn': state.applicants.where((a) => a.status == 'withdrawn').length,
    };
  }

  /// Get recent applicants (last 7 days)
  List<Applicant> getRecentApplicants() {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return state.applicants.where((a) {
      return a.appliedDate.isAfter(sevenDaysAgo);
    }).toList();
  }

  /// Dispose resources
  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

/// Provider for institution applicants state
final institutionApplicantsProvider = StateNotifierProvider<InstitutionApplicantsNotifier, InstitutionApplicantsState>((ref) {
  // Get access token from auth provider
  final authState = ref.watch(authProvider);
  return InstitutionApplicantsNotifier(accessToken: authState.accessToken);
});

/// Provider for applicants list
final institutionApplicantsListProvider = Provider<List<Applicant>>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.applicants;
});

/// Provider for checking if applicants are loading
final institutionApplicantsLoadingProvider = Provider<bool>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.isLoading;
});

/// Provider for applicants error
final institutionApplicantsErrorProvider = Provider<String?>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.error;
});

/// Provider for applicant statistics
final institutionApplicantStatisticsProvider = Provider<Map<String, int>>((ref) {
  final notifier = ref.watch(institutionApplicantsProvider.notifier);
  return notifier.getApplicantStatistics();
});

/// Provider for pending applicants
final pendingApplicantsProvider = Provider<List<Applicant>>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.applicants.where((a) => a.status == 'pending').toList();
});

/// Provider for under review applicants
final underReviewApplicantsProvider = Provider<List<Applicant>>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.applicants.where((a) => a.status == 'under_review').toList();
});

/// Provider for accepted applicants
final acceptedApplicantsProvider = Provider<List<Applicant>>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.applicants.where((a) => a.status == 'accepted').toList();
});

/// Provider for rejected applicants
final rejectedApplicantsProvider = Provider<List<Applicant>>((ref) {
  final applicantsState = ref.watch(institutionApplicantsProvider);
  return applicantsState.applicants.where((a) => a.status == 'rejected').toList();
});

/// Provider for recent applicants
final recentApplicantsProvider = Provider<List<Applicant>>((ref) {
  final notifier = ref.watch(institutionApplicantsProvider.notifier);
  return notifier.getRecentApplicants();
});
