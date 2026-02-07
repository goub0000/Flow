/// Student Applications Real-Time Provider
/// Manages real-time subscriptions for student application updates
library;

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/application_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/enhanced_realtime_service.dart';
import 'student_applications_provider.dart';

/// State class for real-time applications
class RealtimeApplicationsState {
  final List<Application> applications;
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final DateTime? lastUpdate;
  final Map<String, dynamic> statistics;

  const RealtimeApplicationsState({
    this.applications = const [],
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.lastUpdate,
    this.statistics = const {},
  });

  RealtimeApplicationsState copyWith({
    List<Application>? applications,
    bool? isLoading,
    bool? isConnected,
    String? error,
    DateTime? lastUpdate,
    Map<String, dynamic>? statistics,
  }) {
    return RealtimeApplicationsState(
      applications: applications ?? this.applications,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      statistics: statistics ?? this.statistics,
    );
  }

  /// Calculate statistics from applications
  Map<String, dynamic> calculateStatistics() {
    return {
      'total': applications.length,
      'pending': applications.where((app) => app.isPending).length,
      'under_review': applications.where((app) => app.isUnderReview).length,
      'accepted': applications.where((app) => app.isAccepted).length,
      'rejected': applications.where((app) => app.status == 'rejected').length,
      'waitlisted': applications.where((app) => app.status == 'waitlisted').length,
      'withdrawn': applications.where((app) => app.status == 'withdrawn').length,
    };
  }
}

/// StateNotifier for managing real-time student applications
class StudentApplicationsRealtimeNotifier extends StateNotifier<RealtimeApplicationsState> {
  final Ref ref;
  final EnhancedRealtimeService _realtimeService;
  final SupabaseClient _supabase;

  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  Timer? _refreshTimer;

  StudentApplicationsRealtimeNotifier(
    this.ref,
    this._realtimeService,
    this._supabase,
  ) : super(const RealtimeApplicationsState()) {
    _initialize();
  }

  void _initialize() {
    // Initial fetch
    _fetchApplications();

    // Setup real-time subscription
    _setupRealtimeSubscription();

    // Monitor connection status
    _monitorConnectionStatus();

    // Setup periodic refresh as fallback
    _setupPeriodicRefresh();
  }

  /// Fetch applications from database
  Future<void> _fetchApplications() async {
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

      // Fetch from Supabase directly
      final response = await _supabase
          .from('applications')
          .select('*')
          .eq('student_id', user.id)
          .order('created_at', ascending: false);

      final applications = (response as List<dynamic>)
          .map((json) => Application.fromJson(json))
          .toList();

      final statistics = _calculateStatistics(applications);

      state = state.copyWith(
        applications: applications,
        isLoading: false,
        lastUpdate: DateTime.now(),
        statistics: statistics,
      );

    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch applications: $e',
        isLoading: false,
      );
    }
  }

  /// Setup real-time subscription for application updates
  void _setupRealtimeSubscription() {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      return;
    }

    final channelName = 'student_applications_${user.id}';

    _realtimeService.subscribeToUserRecords(
      table: 'applications',
      channelName: channelName,
      userId: user.id,
      userColumn: 'student_id',
      onInsert: _handleInsert,
      onUpdate: _handleUpdate,
      onDelete: _handleDelete,
      onError: (error) {
        state = state.copyWith(error: error);
      },
    );
  }

  /// Handle INSERT event
  void _handleInsert(Map<String, dynamic> payload) {
    try {
      final newApplication = Application.fromJson(payload);

      // Add to state if not already present
      if (!state.applications.any((app) => app.id == newApplication.id)) {
        final updatedApplications = [newApplication, ...state.applications];
        final statistics = _calculateStatistics(updatedApplications);

        state = state.copyWith(
          applications: updatedApplications,
          lastUpdate: DateTime.now(),
          statistics: statistics,
        );

        // Show notification
        _showNotification('New Application', 'Your application to ${newApplication.institutionName} has been created');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  /// Handle UPDATE event
  void _handleUpdate(Map<String, dynamic> payload) {
    try {
      final updatedApplication = Application.fromJson(payload);

      // Find and update the application
      final updatedApplications = state.applications.map((app) {
        if (app.id == updatedApplication.id) {
          // Check if status changed
          if (app.status != updatedApplication.status) {
            _showStatusChangeNotification(app, updatedApplication);
          }
          return updatedApplication;
        }
        return app;
      }).toList();

      final statistics = _calculateStatistics(updatedApplications);

      state = state.copyWith(
        applications: updatedApplications,
        lastUpdate: DateTime.now(),
        statistics: statistics,
      );
    } catch (e) {
      // Handle error silently
    }
  }

  /// Handle DELETE event
  void _handleDelete(Map<String, dynamic> payload) {
    try {

      final deletedId = payload['id'] as String;

      // Remove from state
      final updatedApplications = state.applications
          .where((app) => app.id != deletedId)
          .toList();

      final statistics = _calculateStatistics(updatedApplications);

      state = state.copyWith(
        applications: updatedApplications,
        lastUpdate: DateTime.now(),
        statistics: statistics,
      );

      // Show notification
      _showNotification('Application Removed', 'An application has been removed');
    } catch (e) {
      // Handle error silently
    }
  }

  /// Monitor connection status
  void _monitorConnectionStatus() {
    _connectionSubscription = _realtimeService.connectionStatus.listen((status) {
      final isConnected = status == ConnectionStatus.connected;
      state = state.copyWith(isConnected: isConnected);

      if (status == ConnectionStatus.connected && state.lastUpdate == null) {
        // First connection - fetch data
        _fetchApplications();
      }
    });
  }

  /// Setup periodic refresh as fallback
  void _setupPeriodicRefresh() {
    // Refresh every 30 seconds if not connected to real-time
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!state.isConnected) {
        refresh();
      }
    });
  }

  /// Calculate statistics from applications list
  Map<String, dynamic> _calculateStatistics(List<Application> applications) {
    return {
      'total': applications.length,
      'pending': applications.where((app) => app.isPending).length,
      'under_review': applications.where((app) => app.isUnderReview).length,
      'accepted': applications.where((app) => app.isAccepted).length,
      'rejected': applications.where((app) => app.status == 'rejected').length,
      'waitlisted': applications.where((app) => app.status == 'waitlisted').length,
      'withdrawn': applications.where((app) => app.status == 'withdrawn').length,
      'paid': applications.where((app) => app.isPaid).length,
      'unpaid': applications.where((app) => !app.isPaid && app.applicationFee != null && app.applicationFee! > 0).length,
    };
  }

  /// Show notification for status changes
  void _showStatusChangeNotification(Application oldApp, Application newApp) {
    String message = '';

    switch (newApp.status) {
      case 'accepted':
        message = 'Congratulations! Your application to ${newApp.institutionName} has been accepted!';
        break;
      case 'rejected':
        message = 'Your application to ${newApp.institutionName} has been rejected.';
        break;
      case 'under_review':
        message = 'Your application to ${newApp.institutionName} is now under review.';
        break;
      case 'waitlisted':
        message = 'You have been waitlisted at ${newApp.institutionName}.';
        break;
      default:
        message = 'Your application status at ${newApp.institutionName} has been updated to ${newApp.status}.';
    }

    _showNotification('Application Status Update', message);
  }

  /// Show notification (placeholder - integrate with actual notification system)
  void _showNotification(String title, String message) {
    // TODO: Integrate with actual notification system
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchApplications();
  }

  /// Submit new application with optimistic update
  Future<bool> submitApplication({
    required String institutionId,
    required String institutionName,
    required String programName,
    required Map<String, dynamic> personalInfo,
    required Map<String, dynamic> academicInfo,
    required Map<String, dynamic> documents,
    String? programId,
    String? applicationType,
    double? applicationFee,
  }) async {
    try {
      // Delegate to the regular applications provider
      final success = await ref.read(applicationsProvider.notifier).submitApplication(
        institutionId: institutionId,
        institutionName: institutionName,
        programName: programName,
        personalInfo: personalInfo,
        academicInfo: academicInfo,
        documents: documents,
        programId: programId,
        applicationType: applicationType,
        applicationFee: applicationFee,
      );

      if (success) {
        // Real-time will automatically update the list
        // But we can trigger a manual refresh to be sure
        await refresh();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Update application status with optimistic update
  Future<bool> updateApplicationStatus(String applicationId, String newStatus) async {
    // Find the application
    final applicationIndex = state.applications.indexWhere((app) => app.id == applicationId);
    if (applicationIndex == -1) return false;

    final oldApplication = state.applications[applicationIndex];

    // Optimistic update
    final optimisticApplication = oldApplication.copyWith(status: newStatus);
    final optimisticApplications = [...state.applications];
    optimisticApplications[applicationIndex] = optimisticApplication;

    state = state.copyWith(
      applications: optimisticApplications,
      statistics: _calculateStatistics(optimisticApplications),
    );

    try {
      // Update in backend
      await _supabase
          .from('applications')
          .update({'status': newStatus, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', applicationId);

      // Real-time will confirm the update
      return true;
    } catch (e) {
      // Revert on error
      state = state.copyWith(
        applications: state.applications,
        error: 'Failed to update status',
      );

      // Refresh to get correct data
      await refresh();
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

  /// Get application by ID
  Application? getApplicationById(String id) {
    try {
      return state.applications.firstWhere((app) => app.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    // Clean up subscriptions
    final user = ref.read(currentUserProvider);
    if (user != null) {
      _realtimeService.unsubscribe('student_applications_${user.id}');
    }

    _connectionSubscription?.cancel();
    _refreshTimer?.cancel();

    super.dispose();
  }
}

/// Provider for real-time student applications
final studentApplicationsRealtimeProvider = StateNotifierProvider.autoDispose<
    StudentApplicationsRealtimeNotifier, RealtimeApplicationsState>((ref) {
  final realtimeService = ref.watch(enhancedRealtimeServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return StudentApplicationsRealtimeNotifier(ref, realtimeService, supabase);
});

/// Provider for real-time applications list
final realtimeApplicationsListProvider = Provider.autoDispose<List<Application>>((ref) {
  final state = ref.watch(studentApplicationsRealtimeProvider);
  return state.applications;
});

/// Provider for real-time connection status
final applicationsRealtimeConnectedProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(studentApplicationsRealtimeProvider);
  return state.isConnected;
});

/// Provider for real-time statistics
final applicationsRealtimeStatisticsProvider = Provider.autoDispose<Map<String, dynamic>>((ref) {
  final state = ref.watch(studentApplicationsRealtimeProvider);
  return state.statistics;
});

/// Provider for last update time
final applicationsLastUpdateProvider = Provider.autoDispose<DateTime?>((ref) {
  final state = ref.watch(studentApplicationsRealtimeProvider);
  return state.lastUpdate;
});