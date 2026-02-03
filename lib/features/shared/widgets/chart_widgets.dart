import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/app_colors.dart';
import '../../../core/l10n_extension.dart';

/// Chart Widgets for Analytics
///
/// Provides various chart types for data visualization:
/// - Line charts for trends
/// - Bar charts for comparisons
/// - Progress indicators (circular, linear)
/// - Pie charts for distributions
///
/// Backend Integration TODO:
/// ```dart
/// // For advanced charts, consider using:
/// // fl_chart: ^0.65.0
/// // charts_flutter: ^0.12.0
/// // syncfusion_flutter_charts: ^24.1.41
///
/// import 'package:fl_chart/fl_chart.dart';
///
/// class AdvancedLineChart extends StatelessWidget {
///   final List<FlSpot> dataPoints;
///
///   Widget build(BuildContext context) {
///     return LineChart(
///       LineChartData(
///         lineBarsData: [
///           LineChartBarData(
///             spots: dataPoints,
///             isCurved: true,
///             color: AppColors.primary,
///             barWidth: 3,
///             dotData: FlDotData(show: true),
///           ),
///         ],
///         titlesData: FlTitlesData(show: true),
///         borderData: FlBorderData(show: true),
///         gridData: FlGridData(show: true),
///       ),
///     );
///   }
/// }
///
/// // Fetch chart data from API
/// import 'package:dio/dio.dart';
///
/// class AnalyticsService {
///   final Dio _dio;
///
///   Future<Map<String, dynamic>> getProgressData() async {
///     final response = await _dio.get('/api/analytics/progress');
///     return response.data;
///   }
///
///   Future<List<ChartDataPoint>> getCourseProgress(String courseId) async {
///     final response = await _dio.get('/api/courses/$courseId/progress');
///     return (response.data['progress'] as List)
///         .map((json) => ChartDataPoint.fromJson(json))
///         .toList();
///   }
/// }
/// ```

/// Chart Data Point
class ChartDataPoint {
  final String label;
  final double value;
  final Color? color;
  final DateTime? timestamp;

  ChartDataPoint({
    required this.label,
    required this.value,
    this.color,
    this.timestamp,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      label: json['label'],
      value: (json['value'] as num).toDouble(),
      color: json['color'] != null ? Color(json['color']) : null,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
    );
  }
}

/// Circular Progress Indicator with Label
class CircularProgressChart extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;
  final String? subtitle;
  final Color color;
  final double size;
  final double strokeWidth;

  const CircularProgressChart({
    super.key,
    required this.progress,
    required this.label,
    this.subtitle,
    this.color = AppColors.primary,
    this.size = 120,
    this.strokeWidth = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: strokeWidth,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.border,
                  ),
                ),
              ),
              // Progress circle
              SizedBox(
                width: size,
                height: size,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.0, end: progress),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: strokeWidth,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(color),
                      strokeCap: StrokeCap.round,
                    );
                  },
                ),
              ),
              // Center text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Simple Bar Chart
class SimpleBarChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final double height;
  final bool showLabels;
  final bool showValues;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.height = 200,
    this.showLabels = true,
    this.showValues = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(context.l10n.swChartNoDataAvailable),
        ),
      );
    }

    final maxValue = data.map((e) => e.value).reduce(math.max);

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((entry) {
                final index = entry.key;
                final point = entry.value;
                final barHeight = (point.value / maxValue) * (height - 60);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (showValues)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              point.value.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        TweenAnimationBuilder<double>(
                          duration: Duration(milliseconds: 500 + (index * 100)),
                          tween: Tween(begin: 0.0, end: barHeight),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Container(
                              height: value,
                              decoration: BoxDecoration(
                                color: point.color ?? AppColors.primary,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (showLabels) ...[
            const SizedBox(height: 8),
            Row(
              children: data.map((point) {
                return Expanded(
                  child: Text(
                    point.label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple Line Chart
class SimpleLineChart extends StatelessWidget {
  final List<ChartDataPoint> data;
  final double height;
  final Color lineColor;
  final bool showDots;
  final bool showLabels;

  const SimpleLineChart({
    super.key,
    required this.data,
    this.height = 200,
    this.lineColor = AppColors.primary,
    this.showDots = true,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(context.l10n.swChartNoDataAvailable),
        ),
      );
    }

    final maxValue = data.map((e) => e.value).reduce(math.max);
    final minValue = data.map((e) => e.value).reduce(math.min);
    final range = maxValue - minValue;

    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _LineChartPainter(
                    data: data,
                    maxValue: maxValue,
                    minValue: minValue,
                    range: range,
                    lineColor: lineColor,
                    showDots: showDots,
                  ),
                );
              },
            ),
          ),
          if (showLabels) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.first.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  data.last.label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final double maxValue;
  final double minValue;
  final double range;
  final Color lineColor;
  final bool showDots;

  _LineChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    required this.range,
    required this.lineColor,
    required this.showDots,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = lineColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    final points = <Offset>[];

    // Calculate points
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalizedValue = range > 0
          ? (data[i].value - minValue) / range
          : 0.5;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    // Complete fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill
    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    canvas.drawPath(path, paint);

    // Draw dots
    if (showDots) {
      for (final point in points) {
        canvas.drawCircle(point, 4, dotPaint);
        canvas.drawCircle(
          point,
          6,
          Paint()
            ..color = lineColor.withOpacity(0.3)
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Progress Bar with Label
class LabeledProgressBar extends StatelessWidget {
  final String label;
  final double progress; // 0.0 to 1.0
  final Color color;
  final String? trailing;

  const LabeledProgressBar({
    super.key,
    required this.label,
    required this.progress,
    this.color = AppColors.primary,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              trailing ?? '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: progress),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Mini Sparkline Chart
class SparklineChart extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double height;
  final double strokeWidth;

  const SparklineChart({
    super.key,
    required this.data,
    this.color = AppColors.primary,
    this.height = 40,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          data: data,
          color: color,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double strokeWidth;

  _SparklinePainter({
    required this.data,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final maxValue = data.reduce(math.max);
    final minValue = data.reduce(math.min);
    final range = maxValue - minValue;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalizedValue = range > 0 ? (data[i] - minValue) / range : 0.5;
      final y = size.height - (normalizedValue * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
