import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../theme/app_colors.dart';

/// Progress Ring - Circular progress indicator with percentage
class ProgressRing extends StatelessWidget {
  final double percentage;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;
  final String? label;
  final bool showPercentage;

  const ProgressRing({
    required this.percentage,
    this.size = 100,
    this.strokeWidth = 10,
    this.color,
    this.backgroundColor,
    this.label,
    this.showPercentage = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? AppColors.primary;
    final bgColor = backgroundColor ??
        AppColors.textSecondary.withValues(alpha: 0.1);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              percentage: 100,
              color: bgColor,
              strokeWidth: strokeWidth,
            ),
          ),

          // Progress ring
          CustomPaint(
            size: Size(size, size),
            painter: _ProgressRingPainter(
              percentage: percentage,
              color: progressColor,
              strokeWidth: strokeWidth,
            ),
          ),

          // Center content
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showPercentage)
                Text(
                  '${percentage.toInt()}%',
                  style: TextStyle(
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              if (label != null) ...[
                if (showPercentage) SizedBox(height: size * 0.02),
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: size * 0.1,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.percentage,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Multi Progress Ring - Multiple concentric progress rings
class MultiProgressRing extends StatelessWidget {
  final List<ProgressData> progressData;
  final double size;
  final String? centerLabel;

  const MultiProgressRing({
    required this.progressData,
    this.size = 120,
    this.centerLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rings from outermost to innermost
          ...progressData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final ringSize = size - (index * 20);
            final strokeWidth = 8.0;

            return SizedBox(
              width: ringSize,
              height: ringSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background ring
                  CustomPaint(
                    size: Size(ringSize, ringSize),
                    painter: _ProgressRingPainter(
                      percentage: 100,
                      color: AppColors.textSecondary.withValues(alpha: 0.1),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                  // Progress ring
                  CustomPaint(
                    size: Size(ringSize, ringSize),
                    painter: _ProgressRingPainter(
                      percentage: data.percentage,
                      color: data.color,
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ],
              ),
            );
          }),

          // Center content
          if (centerLabel != null)
            Text(
              centerLabel!,
              style: TextStyle(
                fontSize: size * 0.15,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

/// Progress Data Model
class ProgressData {
  final double percentage;
  final Color color;
  final String? label;

  ProgressData({
    required this.percentage,
    required this.color,
    this.label,
  });
}
