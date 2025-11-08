import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/application_model.dart';
import '../../authentication/providers/auth_provider.dart';

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
  final Uuid _uuid = const Uuid();

  ApplicationsNotifier(this.ref) : super(const ApplicationsState()) {
    fetchApplications();
  }

  /// Fetch student applications
  /// TODO: Connect to backend API (Firebase Firestore)
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

      // TODO: Replace with actual Firebase query
      // Example: FirebaseFirestore.instance.collection('applications')
      //   .where('studentId', isEqualTo: user.id).get()

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 1));

      // For now, return empty list since mock data is removed
      // Backend should provide actual application data
      state = state.copyWith(
        applications: [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch applications: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Submit new application
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> submitApplication({
    required String institutionName,
    required String programName,
    required Map<String, dynamic> personalInfo,
    required Map<String, dynamic> academicInfo,
    required Map<String, dynamic> documents,
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

      final application = Application(
        id: _uuid.v4(),
        studentId: user.id,
        institutionId: _uuid.v4(), // TODO: Get actual institution ID
        institutionName: institutionName,
        programName: programName,
        status: 'pending',
        submittedAt: DateTime.now(),
        personalInfo: personalInfo,
        academicInfo: academicInfo,
        documents: documents,
        applicationFee: applicationFee,
        feePaid: false,
      );

      // TODO: Replace with actual Firebase write
      // Example: await FirebaseFirestore.instance.collection('applications').add(application.toJson())

      // Simulating API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Add to local state
      state = state.copyWith(
        applications: [...state.applications, application],
        isSubmitting: false,
      );

      return true;
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

  /// Withdraw application
  /// TODO: Connect to backend API (Firebase Firestore)
  Future<bool> withdrawApplication(String applicationId) async {
    try {
      // TODO: Replace with actual Firebase update
      // Example: await FirebaseFirestore.instance.collection('applications')
      //   .doc(applicationId).update({'status': 'withdrawn'})

      await Future.delayed(const Duration(milliseconds: 500));

      // Update local state
      final updatedApplications = state.applications.map((app) {
        if (app.id == applicationId) {
          return Application(
            id: app.id,
            studentId: app.studentId,
            institutionId: app.institutionId,
            institutionName: app.institutionName,
            programName: app.programName,
            status: 'withdrawn',
            submittedAt: app.submittedAt,
            reviewedAt: app.reviewedAt,
            reviewNotes: app.reviewNotes,
            documents: app.documents,
            personalInfo: app.personalInfo,
            academicInfo: app.academicInfo,
            applicationFee: app.applicationFee,
            feePaid: app.feePaid,
          );
        }
        return app;
      }).toList();

      state = state.copyWith(applications: updatedApplications);
      return true;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to withdraw application: ${e.toString()}',
      );
      return false;
    }
  }

  /// Pay application fee
  /// TODO: Connect to payment gateway and backend API
  Future<bool> payApplicationFee(String applicationId, double amount) async {
    try {
      // TODO: Integrate with payment gateway (e.g., Stripe, PayPal, M-Pesa)
      // Example: await PaymentService.processPayment(amount, applicationId)

      await Future.delayed(const Duration(seconds: 1));

      // Update application fee status
      final updatedApplications = state.applications.map((app) {
        if (app.id == applicationId) {
          return Application(
            id: app.id,
            studentId: app.studentId,
            institutionId: app.institutionId,
            institutionName: app.institutionName,
            programName: app.programName,
            status: app.status,
            submittedAt: app.submittedAt,
            reviewedAt: app.reviewedAt,
            reviewNotes: app.reviewNotes,
            documents: app.documents,
            personalInfo: app.personalInfo,
            academicInfo: app.academicInfo,
            applicationFee: app.applicationFee,
            feePaid: true,
          );
        }
        return app;
      }).toList();

      state = state.copyWith(applications: updatedApplications);
      return true;
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
  return ApplicationsNotifier(ref);
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
