import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/shared/widgets/stats_widgets.dart';
import 'student_applications_provider.dart';

/// Provider for dashboard statistics calculations
final dashboardStatisticsProvider = Provider<List<StatData>>((ref) {
  // Get applications data
  final applications = ref.watch(applicationsListProvider);

  // Calculate counts
  final totalApplications = applications.length;
  final acceptedCount = applications.where((app) => app.isAccepted).length;
  final pendingCount = applications.where((app) => app.isPending).length;
  final underReviewCount = applications.where((app) => app.isUnderReview).length;

  // Calculate trends (simplified for now - would need historical data for real trends)
  // In production, these would be calculated by comparing with previous period
  final totalTrend = _calculateTrend(totalApplications, totalApplications);
  final acceptedTrend = _calculateTrend(acceptedCount, acceptedCount);
  final pendingTrend = _calculateTrend(pendingCount, pendingCount);

  // Generate sparkline data from recent applications
  final sparklineData = _generateSparklineData(applications);

  return [
    StatData(
      label: 'Total Applications',
      value: '$totalApplications',
      icon: Icons.description,
      color: AppColors.primary,
      trend: totalTrend,
      subtitle: 'All time',
    ),
    StatData(
      label: 'Accepted',
      value: '$acceptedCount',
      icon: Icons.check_circle,
      color: AppColors.success,
      trend: acceptedTrend,
      subtitle: acceptedCount > 0 ? 'Congratulations!' : null,
    ),
    StatData(
      label: 'Pending',
      value: '$pendingCount',
      icon: Icons.pending_actions,
      color: AppColors.warning,
      trend: pendingTrend,
      subtitle: pendingCount > 0 ? 'Awaiting review' : null,
    ),
    StatData(
      label: 'Under Review',
      value: '$underReviewCount',
      icon: Icons.rate_review,
      color: AppColors.info,
      sparklineData: sparklineData,
      trend: null,  // No trend for under review
      subtitle: underReviewCount > 0 ? 'Being processed' : null,
    ),
  ];
});

/// Calculate trend percentage (would need historical data for real calculation)
double? _calculateTrend(int current, int previous) {
  // For now, return null (no trend) since we don't have historical data
  // In production, this would compare with previous period
  return null;
}

/// Generate sparkline data from applications
List<double>? _generateSparklineData(List<dynamic> applications) {
  if (applications.isEmpty) return null;

  // Group applications by week for the last 7 weeks
  final now = DateTime.now();
  final sparklineData = <double>[];

  for (int i = 6; i >= 0; i--) {
    final weekStart = now.subtract(Duration(days: i * 7));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekCount = applications.where((app) {
      final submittedAt = app.submittedAt as DateTime;
      return submittedAt.isAfter(weekStart) && submittedAt.isBefore(weekEnd);
    }).length.toDouble();

    sparklineData.add(weekCount);
  }

  // Return null if all values are zero
  if (sparklineData.every((value) => value == 0)) return null;

  return sparklineData;
}

/// Provider for historical statistics (for trend calculation)
/// This would fetch from an API endpoint that provides historical data
final historicalStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Implement API call to fetch historical statistics
  // For now, return empty map
  return {};
});

/// Provider for messages count (unread messages)
final unreadMessagesCountProvider = Provider<int?>((ref) {
  // TODO: Implement actual messages count from messaging service
  // For now, return null to hide the badge
  return null;
});