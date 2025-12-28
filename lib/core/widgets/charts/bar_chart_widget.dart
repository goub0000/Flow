import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_colors.dart';

/// Bar Chart Widget - Customizable bar chart component
class BarChartWidget extends StatelessWidget {
  final List<BarChartDataItem> data;
  final String? title;
  final String? xAxisLabel;
  final String? yAxisLabel;
  final bool showLegend;
  final bool showGrid;
  final double? maxY;

  const BarChartWidget({
    required this.data,
    this.title,
    this.xAxisLabel,
    this.yAxisLabel,
    this.showLegend = false,
    this.showGrid = true,
    this.maxY,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          child: BarChart(
            BarChartData(
              maxY: maxY ?? _calculateMaxY(),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${data[groupIndex].label}\n${rod.toY.toStringAsFixed(0)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[value.toInt()].label,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  axisNameWidget: xAxisLabel != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            xAxisLabel!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : null,
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      );
                    },
                  ),
                  axisNameWidget: yAxisLabel != null
                      ? Text(
                          yAxisLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : null,
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: showGrid,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              barGroups: data.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value,
                      color: entry.value.color ?? AppColors.primary,
                      width: 20,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    if (data.isEmpty) return 10;
    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2; // Add 20% padding
  }
}

/// Bar Chart Data Model
class BarChartDataItem {
  final String label;
  final double value;
  final Color? color;

  BarChartDataItem({
    required this.label,
    required this.value,
    this.color,
  });
}
