import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/application_model.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// State class for managing applications
class ApplicationsState {
  final List<Application> applications;
  final bool isLoading;
  final String? error;
  final bool isSubmitting;

  const ApplicationsState({
    this.applications = const [],
    this.isLoading = false,
    this.error,
    this.isSubmitting = false,
  });

  ApplicationsState copyWith({
    List<Application>? applications,
    bool? isLoading,
    String? error,
    bool? isSubmitting,
  }) {
    return ApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// StateNotifier for managing applications
class ApplicationsNotifier extends StateNotifier<ApplicationsState> {
  final Ref ref;
  final ApiClient _apiClient;

  ApplicationsNotifier(this.ref, this._apiClient) : super(const ApplicationsState()) {
    fetchApplications();
  }

  /// Fetch student applications from backend API
  Future<void> fetchApplications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isLoading: false,
        );
        return;
      }

      final response = await _apiClient.get(
        '${ApiConfig.students}/me/applications',
        fromJson: (data) {
          if (data is List) {
            return data.map((appJson) => Application.fromJson(appJson)).toList();
          }
          return <Application>[];
        },
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          applications: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch applications',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch applications: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Submit new application via backend API
  Future<bool> submitApplication({
    required String institutionId,  // Added institution_id (UUID)
    required String institutionName,
    required String programName,
    required Map<String, dynamic> personalInfo,
    required Map<String, dynamic> academicInfo,
    required Map<String, dynamic> documents,
    String? programId,
    String? applicationType,  // Added application_type
    double? applicationFee,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        state = state.copyWith(
          error: 'User not authenticated',
          isSubmitting: false,
        );
        return false;
      }

      // Extract the documents list from the map if it exists
      final documentsList = documents['list'] as List<Map<String, String>>? ?? [];

      final response = await _apiClient.post(
        ApiConfig.applications,
        data: {
          'institution_id': institutionId,  // Send institution UUID
          'program_id': programId ?? institutionId,  // Use program_id if available, fallback to institution_id
          'application_type': applicationType ?? 'undergraduate',  // Default to undergraduate
          'institution_name': institutionName,
          'program_name': programName,
          'personal_info': personalInfo,
          'academic_info': academicInfo,
          'documents': documentsList,  // Send as List, not Map
          'application_fee': applicationFee,
        },
        fromJson: (data) => Application.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Add new application to local state
        state = state.copyWith(
          applications: [...state.applications, response.data!],
          isSubmitting: false,
        );
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to submit application',
          isSubmitting: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to submit application: ${e.toString()}',
        isSubmitting: false,
      );
      return false;
    }
  }

  /// Get application by ID
  Application? getApplicationById(String id) {
    try {
      return state.applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Withdraw application via backend API
  Future<bool> withdrawApplication(String applicationId) async {
    try {
      final response = await _apiClient.post(
        '${ApiConfig.applications}/$applicationId/withdraw',
        fromJson: (data) => Application.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Update local state with withdrawn application
        final updatedApplications = state.applications.map((app) {
          if (app.id == applicationId) {
            return response.data!;
          }
          return app;
        }).toList();

        state = state.copyWith(applications: updatedApplications);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to withdraw application',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to withdraw application: ${e.toString()}',
      );
      return false;
    }
  }

  /// Pay application fee
  /// Note: Payment gateway integration (Flutterwave/M-Pesa) needs to be implemented
  Future<bool> payApplicationFee(String applicationId, double amount) async {
    try {
      // TODO: Integrate with payment gateway (e.g., Flutterwave, M-Pesa)
      // This is a placeholder - actual payment processing should happen before this call

      final response = await _apiClient.post(
        '${ApiConfig.applications}/$applicationId/pay',
        data: {
          'amount': amount,
          'payment_method': 'pending', // Should be set by payment gateway
        },
        fromJson: (data) => Application.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Update local state with paid application
        final updatedApplications = state.applications.map((app) {
          if (app.id == applicationId) {
            return response.data!;
          }
          return app;
        }).toList();

        state = state.copyWith(applications: updatedApplications);
        return true;
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to process payment',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to process payment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Filter applications by status
  List<Application> filterByStatus(String status) {
    if (status == 'All') return state.applications;

    return state.applications.where((app) {
      return app.status == status.toLowerCase().replaceAll(' ', '_');
    }).toList();
  }
}

/// Provider for applications state
final applicationsProvider = StateNotifierProvider<ApplicationsNotifier, ApplicationsState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApplicationsNotifier(ref, apiClient);
});

/// Provider for applications list
final applicationsListProvider = Provider<List<Application>>((ref) {
  final applicationsState = ref.watch(applicationsProvider);
  return applicationsState.applications;
});

/// Provider for checking if applications are loading
final applicationsLoadingProvider = Provider<bool>((ref) {
  final applicationsState = ref.watch(applicationsProvider);
  return applicationsState.isLoading;
});

/// Provider for checking if submitting application
final applicationsSubmittingProvider = Provider<bool>((ref) {
  final applicationsState = ref.watch(applicationsProvider);
  return applicationsState.isSubmitting;
});

/// Provider for applications error
final applicationsErrorProvider = Provider<String?>((ref) {
  final applicationsState = ref.watch(applicationsProvider);
  return applicationsState.error;
});

/// Provider for pending applications count
final pendingApplicationsCountProvider = Provider<int>((ref) {
  final applications = ref.watch(applicationsListProvider);
  return applications.where((app) => app.isPending).length;
});

/// Provider for under review applications count
final underReviewApplicationsCountProvider = Provider<int>((ref) {
  final applications = ref.watch(applicationsListProvider);
  return applications.where((app) => app.isUnderReview).length;
});

/// Provider for accepted applications count
final acceptedApplicationsCountProvider = Provider<int>((ref) {
  final applications = ref.watch(applicationsListProvider);
  return applications.where((app) => app.isAccepted).length;
});
