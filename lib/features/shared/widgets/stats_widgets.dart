import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';
import 'chart_widgets.dart';

/// Stats Widgets for Dashboards
///
/// Provides various stat card components:
/// - Simple stat cards with icons
/// - Stat cards with trends
/// - Stat cards with sparklines
/// - Comparison cards
///
/// Backend Integration TODO:
/// ```dart
/// // Fetch stats from API
/// import 'package:dio/dio.dart';
///
/// class DashboardService {
///   final Dio _dio;
///
///   Future<Map<String, dynamic>> getDashboardStats() async {
///     final response = await _dio.get('/api/dashboard/stats');
///     return response.data;
///   }
///
///   Future<List<StatData>> getStudentStats(String studentId) async {
///     final response = await _dio.get('/api/students/$studentId/stats');
///     return (response.data['stats'] as List)
///         .map((json) => StatData.fromJson(json))
///         .toList();
///   }
///
///   Future<Map<String, dynamic>> getInstitutionStats(String institutionId) async {
///     final response = await _dio.get('/api/institutions/$institutionId/stats');
///     return response.data;
///   }
/// }
/// ```

/// Stat Data Model
class StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final double? trend; // Percentage change (positive or negative)
  final List<double>? sparklineData;

  StatData({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.subtitle,
    this.trend,
    this.sparklineData,
  });

  factory StatData.fromJson(Map<String, dynamic> json) {
    return StatData(
      label: json['label'],
      value: json['value'].toString(),
      icon: _iconFromString(json['icon']),
      color: json['color'] != null ? Color(json['color']) : AppColors.primary,
      subtitle: json['subtitle'],
      trend: json['trend']?.toDouble(),
      sparklineData: json['sparklineData'] != null
          ? List<double>.from(json['sparklineData'])
          : null,
    );
  }

  static IconData _iconFromString(String? iconName) {
    switch (iconName) {
      case 'school':
        return Icons.school;
      case 'people':
        return Icons.people;
      case 'assignment':
        return Icons.assignment;
      case 'payment':
        return Icons.payment;
      case 'trending_up':
        return Icons.trending_up;
      case 'star':
        return Icons.star;
      default:
        return Icons.analytics;
    }
  }
}

/// Simple Stat Card
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat Card with Trend
class TrendStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double trend; // Percentage change
  final String? subtitle;
  final VoidCallback? onTap;

  const TrendStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.trend,
    this.color = AppColors.primary,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = trend >= 0;
    final trendColor = isPositive ? AppColors.success : AppColors.error;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trendColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 12,
                          color: trendColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${trend.abs().toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: trendColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat Card with Sparkline
class SparklineStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final List<double> sparklineData;
  final VoidCallback? onTap;

  const SparklineStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.sparklineData,
    this.color = AppColors.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SparklineChart(
                        data: sparklineData,
                        color: color,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Comparison Stat Card
class ComparisonStatCard extends StatelessWidget {
  final String label;
  final String currentValue;
  final String comparisonValue;
  final String comparisonLabel;
  final IconData icon;
  final Color color;

  const ComparisonStatCard({
    super.key,
    required this.label,
    required this.currentValue,
    required this.comparisonValue,
    required this.comparisonLabel,
    required this.icon,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.swStatsCurrent,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentValue,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.border,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comparisonLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comparisonValue,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stats Grid (2 columns)
class StatsGrid extends StatelessWidget {
  final List<StatData> stats;
  final Function(StatData)? onStatTap;

  const StatsGrid({
    super.key,
    required this.stats,
    this.onStatTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];

        if (stat.trend != null) {
          return TrendStatCard(
            label: stat.label,
            value: stat.value,
            icon: stat.icon,
            color: stat.color,
            trend: stat.trend!,
            subtitle: stat.subtitle,
            onTap: () => onStatTap?.call(stat),
          );
        } else if (stat.sparklineData != null) {
          return SparklineStatCard(
            label: stat.label,
            value: stat.value,
            icon: stat.icon,
            color: stat.color,
            sparklineData: stat.sparklineData!,
            onTap: () => onStatTap?.call(stat),
          );
        } else {
          return StatCard(
            label: stat.label,
            value: stat.value,
            icon: stat.icon,
            color: stat.color,
            onTap: () => onStatTap?.call(stat),
          );
        }
      },
    );
  }
}

/// Horizontal Stat List
class HorizontalStatList extends StatelessWidget {
  final List<StatData> stats;
  final double height;

  const HorizontalStatList({
    super.key,
    required this.stats,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stats.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            width: 160,
            margin: EdgeInsets.only(right: index < stats.length - 1 ? 12 : 0),
            child: StatCard(
              label: stat.label,
              value: stat.value,
              icon: stat.icon,
              color: stat.color,
            ),
          );
        },
      ),
    );
  }
}
