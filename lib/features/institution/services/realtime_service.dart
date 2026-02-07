import 'dart:async';

/// Stub service for managing real-time updates for institutions
/// TODO: Implement proper realtime service with updated Supabase API
class InstitutionRealtimeService {
  final StreamController<ApplicationUpdate> _applicationUpdates = StreamController.broadcast();

  /// Stream of application updates
  Stream<ApplicationUpdate> get applicationUpdates => _applicationUpdates.stream;

  /// Subscribe to real-time updates for institution applications - Stub implementation
  Future<void> subscribeToApplications(String institutionId) async {
    // Real-time service is currently disabled - stub implementation
  }

  /// Subscribe to document upload updates for an application - Stub implementation
  Future<void> subscribeToDocumentUploads(String applicationId) async {
    // Real-time service is currently disabled - stub implementation
  }

  /// Unsubscribe from application updates - Stub implementation
  Future<void> unsubscribeFromApplications() async {
    // Real-time service is currently disabled - stub implementation
  }

  /// Clean up resources
  void dispose() {
    _applicationUpdates.close();
  }
}

/// Application update event
class ApplicationUpdate {
  final String eventType;
  final dynamic application;
  final String? applicationId;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  ApplicationUpdate({
    required this.eventType,
    this.application,
    this.applicationId,
    this.data,
    required this.timestamp,
  });
}