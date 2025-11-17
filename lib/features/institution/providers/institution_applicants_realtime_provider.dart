/// Institution Applicants Real-Time Provider
/// Manages real-time subscriptions for institution application updates

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/applicant_model.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/enhanced_realtime_service.dart';
import '../../authentication/providers/auth_provider.dart';

/// State class for real-time institution applicants
class RealtimeInstitutionApplicantsState {
  final List<Applicant> applicants;
  final bool isLoading;
  final bool isConnected;
  final String? error;
  final DateTime? lastUpdate;
  final Map<String, dynamic> statistics;
  final String? currentFilter;
  final String? currentProgramFilter;

  const RealtimeInstitutionApplicantsState({
    this.applicants = const [],
    this.isLoading = false,
    this.isConnected = false,
    this.error,
    this.lastUpdate,
    this.statistics = const {},
    this.currentFilter,
    this.currentProgramFilter,
  });

  RealtimeInstitutionApplicantsState copyWith({
    List<Applicant>? applicants,
    bool? isLoading,
    bool? isConnected,
    String? error,
    DateTime? lastUpdate,
    Map<String, dynamic>? statistics,
    String? currentFilter,
    String? currentProgramFilter,
  }) {
    return RealtimeInstitutionApplicantsState(
      applicants: applicants ?? this.applicants,
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      error: error,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      statistics: statistics ?? this.statistics,
      currentFilter: currentFilter ?? this.currentFilter,
      currentProgramFilter: currentProgramFilter ?? this.currentProgramFilter,
    );
  }
}

/// StateNotifier for managing real-time institution applicants
class InstitutionApplicantsRealtimeNotifier extends StateNotifier<RealtimeInstitutionApplicantsState> {
  final Ref ref;
  final EnhancedRealtimeService _realtimeService;
  final SupabaseClient _supabase;

  RealtimeChannel? _channel;
  StreamSubscription<ConnectionStatus>? _connectionSubscription;
  Timer? _refreshTimer;
  String? _institutionId;

  InstitutionApplicantsRealtimeNotifier(
    this.ref,
    this._realtimeService,
    this._supabase,
  ) : super(const RealtimeInstitutionApplicantsState()) {
    _initialize();
  }

  void _initialize() {
    // Get institution ID from auth
    _getInstitutionId();

    // Initial fetch
    _fetchApplicants();

    // Setup real-time subscription
    _setupRealtimeSubscription();

    // Monitor connection status
    _monitorConnectionStatus();

    // Setup periodic refresh as fallback
    _setupPeriodicRefresh();
  }

  /// Get institution ID from authenticated user
  void _getInstitutionId() {
    final authState = ref.read(authProvider);
    // Get institution ID from user metadata
    _institutionId = authState.user?.metadata?['institution_id'] as String?;

    if (_institutionId == null) {
      print('[RealtimeInstitutionApplicants] No institution ID found');
      state = state.copyWith(error: 'Institution ID not found');
    }
  }

  /// Fetch applicants from database
  Future<void> _fetchApplicants() async {
    if (_institutionId == null) {
      print('[RealtimeInstitutionApplicants] Cannot fetch - no institution ID');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      print('[RealtimeInstitutionApplicants] Fetching applicants for institution: $_institutionId');

      // Build query with filters
      var queryBuilder = _supabase
          .from('applications')
          .select('''
            *,
            student:students!inner(
              id,
              full_name,
              email,
              phone_number,
              profile_image_url
            ),
            program:programs!inner(
              id,
              name,
              type
            )
          ''')
          .eq('institution_id', _institutionId!);

      // Apply status filter if set
      if (state.currentFilter != null && state.currentFilter != 'all') {
        queryBuilder = queryBuilder.eq('status', state.currentFilter!);
      }

      // Apply program filter if set
      if (state.currentProgramFilter != null) {
        queryBuilder = queryBuilder.eq('program_id', state.currentProgramFilter!);
      }

      // Apply ordering and execute
      final response = await queryBuilder.order('created_at', ascending: false);

      final applicants = (response as List<dynamic>)
          .map((json) => Applicant.fromJson(json))
          .toList();

      final statistics = _calculateStatistics(applicants);

      state = state.copyWith(
        applicants: applicants,
        isLoading: false,
        lastUpdate: DateTime.now(),
        statistics: statistics,
      );

      print('[RealtimeInstitutionApplicants] Fetched ${applicants.length} applicants');

    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error fetching: $e');
      state = state.copyWith(
        error: 'Failed to fetch applicants: $e',
        isLoading: false,
      );
    }
  }

  /// Setup real-time subscription for application updates
  void _setupRealtimeSubscription() {
    if (_institutionId == null) {
      print('[RealtimeInstitutionApplicants] Cannot setup subscription - no institution ID');
      return;
    }

    final channelName = 'institution_applications_$_institutionId';

    print('[RealtimeInstitutionApplicants] Setting up real-time subscription');

    _channel = _realtimeService.subscribeToTable(
      table: 'applications',
      channelName: channelName,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'institution_id',
        value: _institutionId!,
      ),
      onInsert: _handleInsert,
      onUpdate: _handleUpdate,
      onDelete: _handleDelete,
      onError: (error) {
        print('[RealtimeInstitutionApplicants] Subscription error: $error');
        state = state.copyWith(error: error);
      },
    );
  }

  /// Handle INSERT event
  void _handleInsert(Map<String, dynamic> payload) async {
    try {
      print('[RealtimeInstitutionApplicants] New application inserted: ${payload['id']}');

      // Fetch the complete applicant data with joins
      final response = await _supabase
          .from('applications')
          .select('''
            *,
            student:students!inner(
              id,
              full_name,
              email,
              phone_number,
              profile_image_url
            ),
            program:programs!inner(
              id,
              name,
              type
            )
          ''')
          .eq('id', payload['id'])
          .single();

      final newApplicant = Applicant.fromJson(response);

      // Check if it matches current filters
      if (_shouldIncludeApplicant(newApplicant)) {
        final updatedApplicants = [newApplicant, ...state.applicants];
        final statistics = _calculateStatistics(updatedApplicants);

        state = state.copyWith(
          applicants: updatedApplicants,
          lastUpdate: DateTime.now(),
          statistics: statistics,
        );

        // Show notification
        _showNotification(
          'New Application',
          '${newApplicant.studentName} has submitted an application for ${newApplicant.programName}',
        );
      } else {
        // Update statistics even if not shown in current filter
        final allApplicants = await _fetchAllApplicantsForStatistics();
        final statistics = _calculateStatistics(allApplicants);
        state = state.copyWith(statistics: statistics);
      }
    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error handling insert: $e');
    }
  }

  /// Handle UPDATE event
  void _handleUpdate(Map<String, dynamic> payload) async {
    try {
      print('[RealtimeInstitutionApplicants] Application updated: ${payload['id']}');

      // Check if this applicant is in our current list
      final existingIndex = state.applicants.indexWhere((app) => app.id == payload['id']);

      if (existingIndex != -1) {
        // Fetch updated applicant data with joins
        final response = await _supabase
            .from('applications')
            .select('''
              *,
              student:students!inner(
                id,
                full_name,
                email,
                phone_number,
                profile_image_url
              ),
              program:programs!inner(
                id,
                name,
                type
              )
            ''')
            .eq('id', payload['id'])
            .single();

        final updatedApplicant = Applicant.fromJson(response);

        // Check if it still matches filters
        if (_shouldIncludeApplicant(updatedApplicant)) {
          // Update in list
          final updatedApplicants = [...state.applicants];
          updatedApplicants[existingIndex] = updatedApplicant;

          final statistics = _calculateStatistics(updatedApplicants);

          state = state.copyWith(
            applicants: updatedApplicants,
            lastUpdate: DateTime.now(),
            statistics: statistics,
          );

          // Check for status change
          if (state.applicants[existingIndex].status != updatedApplicant.status) {
            _showStatusChangeNotification(state.applicants[existingIndex], updatedApplicant);
          }
        } else {
          // Remove from current list (no longer matches filter)
          final updatedApplicants = [...state.applicants];
          updatedApplicants.removeAt(existingIndex);

          final statistics = _calculateStatistics(updatedApplicants);

          state = state.copyWith(
            applicants: updatedApplicants,
            lastUpdate: DateTime.now(),
            statistics: statistics,
          );
        }
      } else {
        // Not in current list, check if it should be added
        final response = await _supabase
            .from('applications')
            .select('''
              *,
              student:students!inner(
                id,
                full_name,
                email,
                phone_number,
                profile_image_url
              ),
              program:programs!inner(
                id,
                name,
                type
              )
            ''')
            .eq('id', payload['id'])
            .single();

        final updatedApplicant = Applicant.fromJson(response);

        if (_shouldIncludeApplicant(updatedApplicant)) {
          // Add to list
          final updatedApplicants = [updatedApplicant, ...state.applicants];
          final statistics = _calculateStatistics(updatedApplicants);

          state = state.copyWith(
            applicants: updatedApplicants,
            lastUpdate: DateTime.now(),
            statistics: statistics,
          );
        }
      }

      // Always update overall statistics
      final allApplicants = await _fetchAllApplicantsForStatistics();
      final statistics = _calculateStatistics(allApplicants);
      state = state.copyWith(statistics: statistics);

    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error handling update: $e');
    }
  }

  /// Handle DELETE event
  void _handleDelete(Map<String, dynamic> payload) {
    try {
      print('[RealtimeInstitutionApplicants] Application deleted: ${payload['id']}');

      final deletedId = payload['id'] as String;

      // Remove from state
      final updatedApplicants = state.applicants
          .where((app) => app.id != deletedId)
          .toList();

      final statistics = _calculateStatistics(updatedApplicants);

      state = state.copyWith(
        applicants: updatedApplicants,
        lastUpdate: DateTime.now(),
        statistics: statistics,
      );

      // Show notification
      _showNotification('Application Removed', 'An application has been withdrawn or removed');
    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error handling delete: $e');
    }
  }

  /// Check if applicant should be included based on current filters
  bool _shouldIncludeApplicant(Applicant applicant) {
    // Check status filter
    if (state.currentFilter != null && state.currentFilter != 'all') {
      if (applicant.status != state.currentFilter) {
        return false;
      }
    }

    // Check program filter
    if (state.currentProgramFilter != null) {
      if (applicant.programId != state.currentProgramFilter) {
        return false;
      }
    }

    return true;
  }

  /// Fetch all applicants for statistics (ignoring filters)
  Future<List<Applicant>> _fetchAllApplicantsForStatistics() async {
    if (_institutionId == null) return [];

    try {
      final response = await _supabase
          .from('applications')
          .select('''
            *,
            student:students!inner(
              id,
              full_name,
              email,
              phone_number,
              profile_image_url
            ),
            program:programs!inner(
              id,
              name,
              type
            )
          ''')
          .eq('institution_id', _institutionId!);

      return (response as List<dynamic>)
          .map((json) => Applicant.fromJson(json))
          .toList();
    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error fetching all for statistics: $e');
      return [];
    }
  }

  /// Monitor connection status
  void _monitorConnectionStatus() {
    _connectionSubscription = _realtimeService.connectionStatus.listen((status) {
      final isConnected = status == ConnectionStatus.connected;
      state = state.copyWith(isConnected: isConnected);

      if (status == ConnectionStatus.connected && state.lastUpdate == null) {
        // First connection - fetch data
        _fetchApplicants();
      }
    });
  }

  /// Setup periodic refresh as fallback
  void _setupPeriodicRefresh() {
    // Refresh every 30 seconds if not connected to real-time
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!state.isConnected) {
        print('[RealtimeInstitutionApplicants] Periodic refresh (not connected to real-time)');
        refresh();
      }
    });
  }

  /// Calculate statistics from applicants list
  Map<String, dynamic> _calculateStatistics(List<Applicant> applicants) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisWeek = now.subtract(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month, 1);

    return {
      'total': applicants.length,
      'pending': applicants.where((a) => a.status == 'pending').length,
      'reviewing': applicants.where((a) => a.status == 'reviewing' || a.status == 'under_review').length,
      'accepted': applicants.where((a) => a.status == 'accepted').length,
      'rejected': applicants.where((a) => a.status == 'rejected').length,
      'waitlisted': applicants.where((a) => a.status == 'waitlisted').length,
      'withdrawn': applicants.where((a) => a.status == 'withdrawn').length,
      'today': applicants.where((a) => a.submittedAt.isAfter(today)).length,
      'this_week': applicants.where((a) => a.submittedAt.isAfter(thisWeek)).length,
      'this_month': applicants.where((a) => a.submittedAt.isAfter(thisMonth)).length,
    };
  }

  /// Show notification for status changes
  void _showStatusChangeNotification(Applicant oldApp, Applicant newApp) {
    String message = '${newApp.studentName}\'s application status changed from ${oldApp.status} to ${newApp.status}';
    _showNotification('Application Status Changed', message);
  }

  /// Show notification (placeholder - integrate with actual notification system)
  void _showNotification(String title, String message) {
    // TODO: Integrate with actual notification system
    print('[Notification] $title: $message');
  }

  /// Manual refresh
  Future<void> refresh() async {
    await _fetchApplicants();
  }

  /// Filter by status
  void filterByStatus(String? status) {
    state = state.copyWith(currentFilter: status);
    _fetchApplicants();
  }

  /// Filter by program
  void filterByProgram(String? programId) {
    state = state.copyWith(currentProgramFilter: programId);
    _fetchApplicants();
  }

  /// Update applicant status with optimistic update
  Future<bool> updateApplicantStatus(String applicantId, String newStatus) async {
    // Find the applicant
    final applicantIndex = state.applicants.indexWhere((app) => app.id == applicantId);
    if (applicantIndex == -1) return false;

    final oldApplicant = state.applicants[applicantIndex];

    // Optimistic update
    final optimisticApplicant = oldApplicant.copyWith(status: newStatus);
    final optimisticApplicants = [...state.applicants];
    optimisticApplicants[applicantIndex] = optimisticApplicant;

    state = state.copyWith(
      applicants: optimisticApplicants,
      statistics: _calculateStatistics(optimisticApplicants),
    );

    try {
      // Update in backend
      await _supabase
          .from('applications')
          .update({
            'status': newStatus,
            'updated_at': DateTime.now().toIso8601String(),
            'reviewed_at': newStatus != 'pending' ? DateTime.now().toIso8601String() : null,
          })
          .eq('id', applicantId);

      // Real-time will confirm the update
      return true;
    } catch (e) {
      print('[RealtimeInstitutionApplicants] Error updating status: $e');

      // Revert on error
      state = state.copyWith(
        applicants: state.applicants,
        error: 'Failed to update status',
      );

      // Refresh to get correct data
      await refresh();
      return false;
    }
  }

  /// Search applicants
  List<Applicant> searchApplicants(String query) {
    if (query.isEmpty) return state.applicants;

    final lowercaseQuery = query.toLowerCase();
    return state.applicants.where((applicant) {
      return applicant.studentName.toLowerCase().contains(lowercaseQuery) ||
          applicant.studentEmail.toLowerCase().contains(lowercaseQuery) ||
          applicant.programName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Sort applicants
  void sortByDate({bool ascending = false}) {
    final sorted = [...state.applicants];
    sorted.sort((a, b) {
      final comparison = a.submittedAt.compareTo(b.submittedAt);
      return ascending ? comparison : -comparison;
    });
    state = state.copyWith(applicants: sorted);
  }

  void sortByName({bool ascending = true}) {
    final sorted = [...state.applicants];
    sorted.sort((a, b) {
      final comparison = a.studentName.compareTo(b.studentName);
      return ascending ? comparison : -comparison;
    });
    state = state.copyWith(applicants: sorted);
  }

  @override
  void dispose() {
    // Clean up subscriptions
    if (_institutionId != null) {
      _realtimeService.unsubscribe('institution_applications_$_institutionId');
    }

    _connectionSubscription?.cancel();
    _refreshTimer?.cancel();

    super.dispose();
  }
}

/// Provider for real-time institution applicants
final institutionApplicantsRealtimeProvider = StateNotifierProvider.autoDispose<
    InstitutionApplicantsRealtimeNotifier, RealtimeInstitutionApplicantsState>((ref) {
  final realtimeService = ref.watch(enhancedRealtimeServiceProvider);
  final supabase = ref.watch(supabaseClientProvider);

  return InstitutionApplicantsRealtimeNotifier(ref, realtimeService, supabase);
});

/// Provider for real-time applicants list
final realtimeInstitutionApplicantsListProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final state = ref.watch(institutionApplicantsRealtimeProvider);
  return state.applicants;
});

/// Provider for real-time connection status
final institutionApplicantsRealtimeConnectedProvider = Provider.autoDispose<bool>((ref) {
  final state = ref.watch(institutionApplicantsRealtimeProvider);
  return state.isConnected;
});

/// Provider for real-time statistics
final institutionApplicantsRealtimeStatisticsProvider = Provider.autoDispose<Map<String, dynamic>>((ref) {
  final state = ref.watch(institutionApplicantsRealtimeProvider);
  return state.statistics;
});

/// Provider for filtered applicants by status
final realtimePendingApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(realtimeInstitutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'pending').toList();
});

final realtimeReviewingApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(realtimeInstitutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'reviewing' || a.status == 'under_review').toList();
});

final realtimeAcceptedApplicantsProvider = Provider.autoDispose<List<Applicant>>((ref) {
  final applicants = ref.watch(realtimeInstitutionApplicantsListProvider);
  return applicants.where((a) => a.status == 'accepted').toList();
});