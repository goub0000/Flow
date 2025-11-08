import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';

/// Donut Chart Widget - Donut/Ring chart with center value
class DonutChartWidget extends StatelessWidget {
  final List<DonutChartData> data;
  final String? title;
  final String? centerLabel;
  final double? centerValue;
  final bool showLegend;
  final double holeRadius;

  const DonutChartWidget({
    required this.data,
    this.title,
    this.centerLabel,
    this.centerValue,
    this.showLegend = true,
    this.holeRadius = 60,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Expanded(
          child: Row(
            children: [
              // Chart
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: holeRadius,
                        sections: data.map((item) {
                          final percentage = (item.value / total * 100);
                          return PieChartSectionData(
                            value: item.value,
                            title: '${percentage.toStringAsFixed(0)}%',
                            color: item.color,
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                        ),
                      ),
                    ),
                    // Center content
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (centerValue != null)
                          Text(
                            centerValue!.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        if (centerLabel != null)
                          Text(
                            centerLabel!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Legend
              if (showLegend) ...[
                const SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((item) {
                    final percentage = (item.value / total * 100);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: item.color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${item.value.toInt()} (${percentage.toStringAsFixed(1)}%)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Donut Chart Data Model
class DonutChartData {
  final String label;
  final double value;
  final Color color;

  DonutChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
