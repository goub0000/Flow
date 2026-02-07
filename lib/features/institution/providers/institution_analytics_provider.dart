import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_config.dart';
import '../../../core/providers/service_providers.dart';

/// Funnel stage data model
class FunnelStageData {
  final String stage;
  final int count;
  final double percentage;
  final double? conversionRate;

  const FunnelStageData({
    required this.stage,
    required this.count,
    required this.percentage,
    this.conversionRate,
  });

  factory FunnelStageData.fromJson(Map<String, dynamic> json) {
    return FunnelStageData(
      stage: json['stage'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      conversionRate: json['conversion_rate'] != null
          ? (json['conversion_rate'] as num).toDouble()
          : null,
    );
  }
}

/// Application funnel response model
class ApplicationFunnelData {
  final int totalViewed;
  final int totalStarted;
  final int totalSubmitted;
  final int totalReviewed;
  final int totalAccepted;
  final List<FunnelStageData> stages;
  final double overallConversionRate;

  const ApplicationFunnelData({
    required this.totalViewed,
    required this.totalStarted,
    required this.totalSubmitted,
    required this.totalReviewed,
    required this.totalAccepted,
    required this.stages,
    required this.overallConversionRate,
  });

  factory ApplicationFunnelData.fromJson(Map<String, dynamic> json) {
    return ApplicationFunnelData(
      totalViewed: json['total_viewed'] as int,
      totalStarted: json['total_started'] as int,
      totalSubmitted: json['total_submitted'] as int,
      totalReviewed: json['total_reviewed'] as int,
      totalAccepted: json['total_accepted'] as int,
      stages: (json['stages'] as List)
          .map((e) => FunnelStageData.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallConversionRate: (json['overall_conversion_rate'] as num).toDouble(),
    );
  }
}

/// Demographic distribution data model
class DemographicDistribution {
  final String label;
  final int count;
  final double percentage;

  const DemographicDistribution({
    required this.label,
    required this.count,
    required this.percentage,
  });

  factory DemographicDistribution.fromJson(Map<String, dynamic> json) {
    return DemographicDistribution(
      label: json['label'] as String,
      count: json['count'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

/// Applicant demographics response model
class ApplicantDemographicsData {
  final int totalApplicants;
  final List<DemographicDistribution> locationDistribution;
  final List<DemographicDistribution> ageDistribution;
  final List<DemographicDistribution> academicBackgroundDistribution;

  const ApplicantDemographicsData({
    required this.totalApplicants,
    required this.locationDistribution,
    required this.ageDistribution,
    required this.academicBackgroundDistribution,
  });

  factory ApplicantDemographicsData.fromJson(Map<String, dynamic> json) {
    return ApplicantDemographicsData(
      totalApplicants: json['total_applicants'] as int,
      locationDistribution: (json['location_distribution'] as List)
          .map((e) => DemographicDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
      ageDistribution: (json['age_distribution'] as List)
          .map((e) => DemographicDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
      academicBackgroundDistribution: (json['academic_background_distribution'] as List)
          .map((e) => DemographicDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Program metrics model
class ProgramMetrics {
  final String programId;
  final String programName;
  final int views;
  final int applications;
  final int acceptances;
  final double acceptanceRate;

  const ProgramMetrics({
    required this.programId,
    required this.programName,
    required this.views,
    required this.applications,
    required this.acceptances,
    required this.acceptanceRate,
  });

  factory ProgramMetrics.fromJson(Map<String, dynamic> json) {
    return ProgramMetrics(
      programId: json['program_id'] as String,
      programName: json['program_name'] as String,
      views: json['views'] as int,
      applications: json['applications'] as int,
      acceptances: json['acceptances'] as int,
      acceptanceRate: (json['acceptance_rate'] as num).toDouble(),
    );
  }
}

/// Program popularity response model
class ProgramPopularityData {
  final int totalPrograms;
  final List<ProgramMetrics> mostViewed;
  final List<ProgramMetrics> mostApplied;
  final List<ProgramMetrics> highestAcceptanceRate;

  const ProgramPopularityData({
    required this.totalPrograms,
    required this.mostViewed,
    required this.mostApplied,
    required this.highestAcceptanceRate,
  });

  factory ProgramPopularityData.fromJson(Map<String, dynamic> json) {
    return ProgramPopularityData(
      totalPrograms: json['total_programs'] as int,
      mostViewed: (json['most_viewed'] as List)
          .map((e) => ProgramMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      mostApplied: (json['most_applied'] as List)
          .map((e) => ProgramMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      highestAcceptanceRate: (json['highest_acceptance_rate'] as List)
          .map((e) => ProgramMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Time-to-decision response model
class TimeToDecisionData {
  final double averageDays;
  final double medianDays;
  final int pendingApplications;
  final List<DemographicDistribution> ageDistribution;

  const TimeToDecisionData({
    required this.averageDays,
    required this.medianDays,
    required this.pendingApplications,
    required this.ageDistribution,
  });

  factory TimeToDecisionData.fromJson(Map<String, dynamic> json) {
    return TimeToDecisionData(
      averageDays: (json['average_days'] as num).toDouble(),
      medianDays: (json['median_days'] as num).toDouble(),
      pendingApplications: json['pending_applications'] as int,
      ageDistribution: (json['age_distribution'] as List)
          .map((e) => DemographicDistribution.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// State class for institution analytics
class InstitutionAnalyticsState {
  final ApplicationFunnelData? applicationFunnelData;
  final ApplicantDemographicsData? applicantDemographicsData;
  final ProgramPopularityData? programPopularityData;
  final TimeToDecisionData? timeToDecisionData;
  final bool isLoading;
  final String? error;

  const InstitutionAnalyticsState({
    this.applicationFunnelData,
    this.applicantDemographicsData,
    this.programPopularityData,
    this.timeToDecisionData,
    this.isLoading = false,
    this.error,
  });

  InstitutionAnalyticsState copyWith({
    ApplicationFunnelData? applicationFunnelData,
    ApplicantDemographicsData? applicantDemographicsData,
    ProgramPopularityData? programPopularityData,
    TimeToDecisionData? timeToDecisionData,
    bool? isLoading,
    String? error,
  }) {
    return InstitutionAnalyticsState(
      applicationFunnelData: applicationFunnelData ?? this.applicationFunnelData,
      applicantDemographicsData: applicantDemographicsData ?? this.applicantDemographicsData,
      programPopularityData: programPopularityData ?? this.programPopularityData,
      timeToDecisionData: timeToDecisionData ?? this.timeToDecisionData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for institution analytics
class InstitutionAnalyticsNotifier extends StateNotifier<InstitutionAnalyticsState> {
  final ApiClient _apiClient;
  final String _institutionId;

  InstitutionAnalyticsNotifier(this._apiClient, this._institutionId)
      : super(const InstitutionAnalyticsState());

  /// Fetch application funnel analytics
  Future<void> fetchApplicationFunnel({String period = '30_days'}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.institutions}/$_institutionId/analytics/application-funnel?period=$period',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          applicationFunnelData: ApplicationFunnelData.fromJson(response.data!),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch application funnel data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch application funnel data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch applicant demographics analytics
  Future<void> fetchApplicantDemographics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.institutions}/$_institutionId/analytics/applicant-demographics',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          applicantDemographicsData: ApplicantDemographicsData.fromJson(response.data!),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch applicant demographics data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch applicant demographics data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch program popularity analytics
  Future<void> fetchProgramPopularity({int limit = 10}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.institutions}/$_institutionId/analytics/program-popularity?limit=$limit',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          programPopularityData: ProgramPopularityData.fromJson(response.data!),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch program popularity data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch program popularity data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch time-to-decision analytics
  Future<void> fetchTimeToDecision() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.get(
        '${ApiConfig.institutions}/$_institutionId/analytics/time-to-decision',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        state = state.copyWith(
          timeToDecisionData: TimeToDecisionData.fromJson(response.data!),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.message ?? 'Failed to fetch time-to-decision data',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch time-to-decision data: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Fetch all analytics
  Future<void> fetchAll({String period = '30_days', int limit = 10}) async {
    await Future.wait([
      fetchApplicationFunnel(period: period),
      fetchApplicantDemographics(),
      fetchProgramPopularity(limit: limit),
      fetchTimeToDecision(),
    ]);
  }

  /// Refresh all analytics
  Future<void> refresh({String period = '30_days', int limit = 10}) async {
    await fetchAll(period: period, limit: limit);
  }
}

/// Provider for institution analytics state
final institutionAnalyticsProvider =
    StateNotifierProvider.family<InstitutionAnalyticsNotifier, InstitutionAnalyticsState, String>(
  (ref, institutionId) {
    final apiClient = ref.watch(apiClientProvider);
    return InstitutionAnalyticsNotifier(apiClient, institutionId);
  },
);

/// Provider for application funnel data
final institutionApplicationFunnelProvider = Provider.family<ApplicationFunnelData?, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.applicationFunnelData;
});

/// Provider for applicant demographics data
final institutionApplicantDemographicsProvider = Provider.family<ApplicantDemographicsData?, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.applicantDemographicsData;
});

/// Provider for program popularity data
final institutionProgramPopularityProvider = Provider.family<ProgramPopularityData?, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.programPopularityData;
});

/// Provider for time-to-decision data
final institutionTimeToDecisionProvider = Provider.family<TimeToDecisionData?, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.timeToDecisionData;
});

/// Provider for analytics loading state
final institutionAnalyticsLoadingProvider = Provider.family<bool, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.isLoading;
});

/// Provider for analytics error
final institutionAnalyticsErrorProvider = Provider.family<String?, String>((ref, institutionId) {
  final analyticsState = ref.watch(institutionAnalyticsProvider(institutionId));
  return analyticsState.error;
});
