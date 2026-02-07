// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// A decorative wave divider between sections.
///
/// Creates smooth SVG-like wave curves using CustomPainter.
/// Configurable color, height, and wave direction.
class WaveDivider extends StatelessWidget {
  final Color color;
  final double height;
  final bool flipVertical;
  final bool flipHorizontal;
  final WaveStyle style;

  const WaveDivider({
    super.key,
    required this.color,
    this.height = 80,
    this.flipVertical = false,
    this.flipHorizontal = false,
    this.style = WaveStyle.gentle,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(flipHorizontal ? -1.0 : 1.0, flipVertical ? -1.0 : 1.0),
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: CustomPaint(
          painter: _WavePainter(
            color: color,
            style: style,
          ),
        ),
      ),
    );
  }
}

enum WaveStyle {
  gentle,
  dramatic,
  minimal,
  curved,
}

class _WavePainter extends CustomPainter {
  final Color color;
  final WaveStyle style;

  _WavePainter({
    required this.color,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (style) {
      case WaveStyle.gentle:
        _drawGentleWave(path, size);
        break;
      case WaveStyle.dramatic:
        _drawDramaticWave(path, size);
        break;
      case WaveStyle.minimal:
        _drawMinimalWave(path, size);
        break;
      case WaveStyle.curved:
        _drawCurvedWave(path, size);
        break;
    }

    canvas.drawPath(path, paint);
  }

  void _drawGentleWave(Path path, Size size) {
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.6,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
  }

  void _drawDramaticWave(Path path, Size size) {
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.3,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.5,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
  }

  void _drawMinimalWave(Path path, Size size) {
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width,
      size.height * 0.5,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
  }

  void _drawCurvedWave(Path path, Size size) {
    path.moveTo(0, size.height * 0.8);
    path.cubicTo(
      size.width * 0.33,
      size.height * 0.2,
      size.width * 0.66,
      size.height * 0.4,
      size.width,
      size.height * 0.1,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.style != style;
  }
}

/// A layered wave divider with multiple overlapping waves.
class LayeredWaveDivider extends StatelessWidget {
  final Color primaryColor;
  final Color? secondaryColor;
  final double height;
  final bool flipVertical;

  const LayeredWaveDivider({
    super.key,
    required this.primaryColor,
    this.secondaryColor,
    this.height = 120,
    this.flipVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final secondary = secondaryColor ?? primaryColor.withValues(alpha: 0.5);

    return Transform(
      transform: Matrix4.identity()..scale(1.0, flipVertical ? -1.0 : 1.0),
      alignment: Alignment.center,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          children: [
            // Back wave
            Positioned.fill(
              child: CustomPaint(
                painter: _LayeredWavePainter(
                  color: secondary,
                  offset: 0.2,
                ),
              ),
            ),
            // Front wave
            Positioned.fill(
              child: CustomPaint(
                painter: _LayeredWavePainter(
                  color: primaryColor,
                  offset: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayeredWavePainter extends CustomPainter {
  final Color color;
  final double offset;

  _LayeredWavePainter({
    required this.color,
    required this.offset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final yOffset = size.height * offset;

    path.moveTo(0, size.height * 0.6 + yOffset);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.3 + yOffset,
      size.width * 0.5,
      size.height * 0.7 + yOffset,
      size.width * 0.75,
      size.height * 0.4 + yOffset,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.25 + yOffset,
      size.width,
      size.height * 0.5 + yOffset,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LayeredWavePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.offset != offset;
  }
}

/// A simple curved divider (arc shape).
class CurvedDivider extends StatelessWidget {
  final Color color;
  final double height;
  final bool inverted;

  const CurvedDivider({
    super.key,
    required this.color,
    this.height = 60,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _CurvedDividerPainter(
          color: color,
          inverted: inverted,
        ),
      ),
    );
  }
}

class _CurvedDividerPainter extends CustomPainter {
  final Color color;
  final bool inverted;

  _CurvedDividerPainter({
    required this.color,
    required this.inverted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (inverted) {
      path.moveTo(0, 0);
      path.quadraticBezierTo(
        size.width / 2,
        size.height,
        size.width,
        0,
      );
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, size.height);
      path.quadraticBezierTo(
        size.width / 2,
        0,
        size.width,
        size.height,
      );
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedDividerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.inverted != inverted;
  }
}

/// An angled/slanted divider.
class AngledDivider extends StatelessWidget {
  final Color color;
  final double height;
  final bool reverseAngle;

  const AngledDivider({
    super.key,
    required this.color,
    this.height = 80,
    this.reverseAngle = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _AngledDividerPainter(
          color: color,
          reverseAngle: reverseAngle,
        ),
      ),
    );
  }
}

class _AngledDividerPainter extends CustomPainter {
  final Color color;
  final bool reverseAngle;

  _AngledDividerPainter({
    required this.color,
    required this.reverseAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    if (reverseAngle) {
      path.moveTo(0, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AngledDividerPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.reverseAngle != reverseAngle;
  }
}
